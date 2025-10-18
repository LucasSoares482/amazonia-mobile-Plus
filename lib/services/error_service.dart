import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/navigation.dart';

/// Registro de erro persistido para consulta posterior.
class ErrorLogEntry {
  ErrorLogEntry({
    required this.id,
    required this.origem,
    required this.mensagem,
    required this.ocorreuEm,
    required this.sugestao,
  });

  final String id;
  final String origem;
  final String mensagem;
  final DateTime ocorreuEm;
  final String sugestao;

  Map<String, dynamic> toJson() => {
        'id': id,
        'origem': origem,
        'mensagem': mensagem,
        'ocorreuEm': ocorreuEm.toIso8601String(),
        'sugestao': sugestao,
      };

  factory ErrorLogEntry.fromJson(Map<String, dynamic> json) => ErrorLogEntry(
        id: json['id'] as String? ?? UniqueKey().toString(),
        origem: json['origem'] as String? ?? 'desconhecido',
        mensagem: json['mensagem'] as String? ?? 'erro não informado',
        ocorreuEm: DateTime.tryParse(json['ocorreuEm'] as String? ?? '') ??
            DateTime.now(),
        sugestao: json['sugestao'] as String? ?? 'Reinicie o aplicativo.',
      );
}

/// Serviço responsável por logar erros e direcionar para a tela padrão de falha.
class ErrorService {
  ErrorService._internal();

  static final ErrorService instance = ErrorService._internal();

  static const _logsKey = 'error_logs_local';
  static const _maxLogs = 50;

  final List<ErrorLogEntry> _cache = [];
  bool _carregouCache = false;
  bool _exibindoTelaErro = false;

  Future<void> handleError({
    required String origem,
    required String mensagem,
    StackTrace? stackTrace,
  }) async {
    final sugestao = _gerarSugestao(mensagem);
    await _registrarErro(
      origem: origem,
      mensagem: mensagem,
      sugestao: sugestao,
    );

    if (_exibindoTelaErro) return;
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;
    _exibindoTelaErro = true;

    navigator.pushNamedAndRemoveUntil(
      '/erro',
      (route) => false,
      arguments: {
        'origem': origem,
        'mensagem': mensagem,
        'sugestao': sugestao,
      },
    );
  }

  void finalizarApresentacaoErro() {
    _exibindoTelaErro = false;
  }

  Future<List<ErrorLogEntry>> obterLogs() async {
    if (!_carregouCache) {
      await _carregarDoStorage();
    }
    return List.unmodifiable(_cache);
  }

  Future<void> limparLogs() async {
    _cache.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_logsKey);
  }

  Future<void> _registrarErro({
    required String origem,
    required String mensagem,
    required String sugestao,
  }) async {
    final entry = ErrorLogEntry(
      id: UniqueKey().toString(),
      origem: origem,
      mensagem: mensagem,
      ocorreuEm: DateTime.now(),
      sugestao: sugestao,
    );

    if (!_carregouCache) {
      await _carregarDoStorage();
    }

    _cache.insert(0, entry);
    if (_cache.length > _maxLogs) {
      _cache.removeRange(_maxLogs, _cache.length);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _logsKey,
      jsonEncode(_cache.map((e) => e.toJson()).toList(growable: false)),
    );
  }

  Future<void> _carregarDoStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_logsKey);
    if (raw == null) {
      _carregouCache = true;
      return;
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _cache
        ..clear()
        ..addAll(
          decoded
              .map((item) =>
                  ErrorLogEntry.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList(),
        );
      _carregouCache = true;
    } catch (_) {
      _cache.clear();
      _carregouCache = true;
    }
  }

  String _gerarSugestao(String mensagem) {
    final lower = mensagem.toLowerCase();
    if (lower.contains('network') || lower.contains('conex')) {
      return 'Verifique a conexão com a internet e tente novamente.';
    }
    if (lower.contains('firebase') || lower.contains('auth')) {
      return 'Reautentique o utilizador e confirme as credenciais do Firebase.';
    }
    if (lower.contains('storage') || lower.contains('cache')) {
      return 'Limpe o cache local ou reinstale para restaurar arquivos corrompidos.';
    }
    return 'Reinicie o aplicativo e, se persistir, contate o suporte técnico.';
  }
}
