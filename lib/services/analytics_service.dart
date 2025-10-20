import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/analytics_event.dart';
import '../utils/app_state.dart';
import 'locale_service.dart';

/// Serviço responsável pela telemetria offline-first.
class AnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService instance = AnalyticsService._internal();

  static const _eventsKey = 'analytics_events_queue';
  static const _optOutKey = 'analytics_opt_out';
  static const _maxEvents = 200;

  final List<AnalyticsEvent> _queue = [];
  bool _optOut = false;
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _optOut = _prefs?.getBool(_optOutKey) ?? false;
    final rawList = _prefs?.getStringList(_eventsKey) ?? [];
    _queue
      ..clear()
      ..addAll(
        rawList.map((item) {
          final decoded = jsonDecode(item) as Map<String, dynamic>;
          return AnalyticsEvent.fromJson(decoded);
        }),
      );
  }

  Future<void> setOptOut(bool value) async {
    _optOut = value;
    await _prefs?.setBool(_optOutKey, value);
  }

  List<AnalyticsEvent> get pendingEvents =>
      List.unmodifiable(_queue.reversed); // mais recentes primeiro

  void logAppOpen() => _logEvent('app_open');

  void logScreenView(String screenName, {Map<String, dynamic>? extra}) =>
      _logEvent('screen_view', properties: {
        'screen_name': screenName,
        if (extra != null) ...extra,
      });

  void logErrorShown(String origem, String codigo) => _logEvent(
        'error_shown',
        properties: {
          'origem': origem,
          'codigo_generico': codigo,
        },
      );

  void logEvent(String name, {Map<String, dynamic>? properties}) =>
      _logEvent(name, properties: properties);

  void _logEvent(String name, {Map<String, dynamic>? properties}) {
    if (_optOut) return;

    final localeTag = LocaleService.instance.locale.value.toLanguageTag();
    final baseProps = <String, dynamic>{
      'user_id': AppState.usuarioLogado?.id,
      'idioma': localeTag,
      'device': defaultTargetPlatform.name,
      'online': true, // TODO: detectar conectividade real
      'versao_app': '1.0.0',
    };

    if (properties != null) {
      baseProps.addAll(properties);
    }

    final event = AnalyticsEvent(
      name: name,
      timestamp: DateTime.now(),
      properties: baseProps,
    );

    _queue.add(event);
    if (_queue.length > _maxEvents) {
      _queue.removeRange(0, _queue.length - _maxEvents);
    }

    unawaited(_persistQueue());
    // TODO: quando backend estiver disponível, realizar flush incremental aqui.
  }

  Future<void> _persistQueue() async {
    final list = _queue
        .map((event) => jsonEncode(event.toJson()))
        .toList(growable: false);
    await _prefs?.setStringList(_eventsKey, list);
  }
}
