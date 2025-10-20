import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/log.dart';
import '../models/usuario.dart';

/// Gerencia a sessão persistida localmente para suportar o modo offline.
class SessionManager {
  SessionManager._();

  static const _userKey = 'session_user';
  static const _loginTimestampKey = 'session_login_ts';
  static const _sessionMaxDuration = Duration(days: 5);

  /// Salva o utilizador autenticado e carimba o horário do login.
  static Future<void> saveSession(Usuario usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(usuario.toMap()));
      await prefs.setInt(
        _loginTimestampKey,
        DateTime.now().toUtc().millisecondsSinceEpoch,
      );
    } catch (error, stackTrace) {
      log.e(
        'Falha ao persistir sessão local',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Tenta restaurar a sessão previamente armazenada.
  static Future<Usuario?> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson == null) return null;

      final timestamp = prefs.getInt(_loginTimestampKey);
      if (timestamp != null) {
        final loginDate = DateTime.fromMillisecondsSinceEpoch(
          timestamp,
          isUtc: true,
        ).toLocal();
        final isExpired =
            DateTime.now().difference(loginDate) > _sessionMaxDuration;
        if (isExpired) {
          await clearSession();
          return null;
        }
      }

      final decoded =
          Map<String, dynamic>.from(jsonDecode(userJson) as Map<dynamic, dynamic>);
      return Usuario.fromMap(decoded);
    } catch (error, stackTrace) {
      log.e(
        'Falha ao restaurar sessão local',
        error: error,
        stackTrace: stackTrace,
      );
      await clearSession();
      return null;
    }
  }

  /// Remove todos os dados da sessão persistida.
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_loginTimestampKey);
    } catch (error, stackTrace) {
      log.e(
        'Falha ao limpar sessão local',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
