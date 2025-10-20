import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';

enum CheckinStatus { synced, queued, duplicate, failure }

class CheckinQueueService {
  CheckinQueueService._internal();

  static final CheckinQueueService instance = CheckinQueueService._internal();

  static const _queueKey = 'checkin_queue_items';
  static const _pendingKey = 'checkin_pending_ids';
  static const _completedKey = 'checkin_completed_ids';

  Future<CheckinStatus> registrarCheckin({
    required String usuarioId,
    required String eventoId,
    required String eventoTitulo,
    required String local,
    required int amacoins,
  }) async {
    final identifier = _identifier(usuarioId, eventoId);
    final prefs = await SharedPreferences.getInstance();
    final pending = _loadSet(prefs.getStringList(_pendingKey));
    final completed = _loadSet(prefs.getStringList(_completedKey));

    if (pending.contains(identifier) || completed.contains(identifier)) {
      return CheckinStatus.duplicate;
    }

    final payload = <String, dynamic>{
      'usuario_id': usuarioId,
      'evento': eventoTitulo,
      'local': local,
      'evento_id': eventoId,
      'amacoins': amacoins,
      'data': DateTime.now().toIso8601String(),
    };

    try {
      await DatabaseHelper.instance.inserirCheckin(payload);
      if (amacoins > 0) {
        await DatabaseHelper.instance.adicionarAmaCoins(usuarioId, amacoins);
      }
      await _registrarConclusao(prefs, identifier);
      return CheckinStatus.synced;
    } catch (_) {
      await _adicionarNaFila(prefs, payload);
      await _registrarPendente(prefs, identifier);
      return CheckinStatus.queued;
    }
  }

  Future<void> sincronizarPendentes() async {
    final prefs = await SharedPreferences.getInstance();
    final fila = await _carregarFila(prefs);
    if (fila.isEmpty) return;

    final pendentes = _loadSet(prefs.getStringList(_pendingKey));
    final concluido = _loadSet(prefs.getStringList(_completedKey));
    final itensParaRemover = <int>[];

    for (var i = 0; i < fila.length; i++) {
      final item = fila[i];
      final usuarioId = item['usuario_id']?.toString();
      final eventoId = item['evento_id']?.toString();
      if (usuarioId == null || eventoId == null) continue;
      final identifier = _identifier(usuarioId, eventoId);

      try {
        await DatabaseHelper.instance.inserirCheckin(item);
        final amacoins = (item['amacoins'] as num?)?.toInt() ?? 0;
        if (amacoins > 0) {
          await DatabaseHelper.instance.adicionarAmaCoins(usuarioId, amacoins);
        }
        itensParaRemover.add(i);
        pendentes.remove(identifier);
        concluido.add(identifier);
      } catch (_) {
        // Mantém o item na fila para nova tentativa futura.
      }
    }

    if (itensParaRemover.isEmpty) return;

    // Remove itens sincronizados da fila (do fim para o início).
    itensParaRemover
      ..sort((a, b) => b.compareTo(a))
      ..forEach(fila.removeAt);

    await prefs.setString(_queueKey, jsonEncode(fila));
    await prefs.setStringList(_pendingKey, pendentes.toList());
    await prefs.setStringList(_completedKey, concluido.toList());
  }

  Future<void> limparHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
    await prefs.remove(_pendingKey);
    await prefs.remove(_completedKey);
  }

  Future<void> _registrarConclusao(
    SharedPreferences prefs,
    String identifier,
  ) async {
    final concluido = _loadSet(prefs.getStringList(_completedKey));
    concluido.add(identifier);
    await prefs.setStringList(_completedKey, concluido.toList());
  }

  Future<void> _registrarPendente(
    SharedPreferences prefs,
    String identifier,
  ) async {
    final pendentes = _loadSet(prefs.getStringList(_pendingKey));
    pendentes.add(identifier);
    await prefs.setStringList(_pendingKey, pendentes.toList());
  }

  Future<void> _adicionarNaFila(
    SharedPreferences prefs,
    Map<String, dynamic> payload,
  ) async {
    final fila = await _carregarFila(prefs);
    fila.add(payload);
    await prefs.setString(_queueKey, jsonEncode(fila));
  }

  Future<List<Map<String, dynamic>>> _carregarFila(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString(_queueKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
          )
          .toList();
    } catch (_) {
      await prefs.remove(_queueKey);
      return [];
    }
  }

  Set<String> _loadSet(List<String>? source) =>
      source == null ? <String>{} : source.toSet();

  String _identifier(String usuarioId, String eventoId) =>
      '$usuarioId|$eventoId';
}
