import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';

class LocaleService {
  LocaleService._();

  static final LocaleService instance = LocaleService._();

  static const _key = 'app_locale';
  final ValueNotifier<Locale> locale =
      ValueNotifier(const Locale('pt', 'BR'));
  SharedPreferences? _prefs;

  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    final stored = _prefs?.getString(_key);
    if (stored != null) {
      locale.value = _stringToLocale(stored);
    }
  }

  Future<bool> setLocale(Locale newLocale) async {
    final previous = locale.value;
    try {
      locale.value = newLocale;
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs?.setString(_key, _localeToString(newLocale));
      return true;
    } catch (_) {
      locale.value = previous;
      return false;
    }
  }

  String labelFor(Locale locale) {
    switch (locale.languageCode) {
      case 'pt':
        return locale.countryCode == 'PT' ? 'Português (Portugal)' : 'Português (Brasil)';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'zh':
        return locale.countryCode == 'CN' ? '中文 (简体)' : '中文';
      case 'ru':
        return 'Русский';
      default:
        return locale.toLanguageTag();
    }
  }

  String _localeToString(Locale locale) {
    if (locale.countryCode?.isNotEmpty ?? false) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  Locale _stringToLocale(String value) {
    final parts = value.split('_');
    if (parts.length == 2) {
      final candidate = Locale(parts[0], parts[1]);
      if (supportedLocales.contains(candidate)) return candidate;
    }
    final fallback = Locale(parts[0]);
    return supportedLocales.contains(fallback)
        ? fallback
        : const Locale('pt', 'BR');
  }
}
