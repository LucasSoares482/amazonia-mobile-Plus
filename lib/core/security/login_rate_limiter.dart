import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Informações sobre um bloqueio de tentativas de login.
class LoginLockInfo {
  LoginLockInfo({
    required this.lockUntil,
    required this.remaining,
  });

  /// Data e hora em que o bloqueio expira.
  final DateTime lockUntil;

  /// Tempo restante para liberação.
  final Duration remaining;
}

/// Controla tentativas consecutivas de login para evitar força bruta.
class LoginRateLimiter {
  static const _maxAttempts = 5;
  static const _lockDuration = Duration(hours: 3);

  static const _attemptKeyPrefix = 'login_attempts_';
  static const _lockKeyPrefix = 'login_lock_until_';

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const AndroidOptions _androidOptions =
      AndroidOptions(encryptedSharedPreferences: true);
  static const IOSOptions _iosOptions =
      IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  static const MacOsOptions _macOsOptions = MacOsOptions();
  static const LinuxOptions _linuxOptions = LinuxOptions();
  static const WebOptions _webOptions = WebOptions();

  /// Verifica se o email está temporariamente bloqueado.
  static Future<LoginLockInfo?> checkLock(String email) async {
    final key = _lockKey(email);
    final value = await _storage.read(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );
    if (value == null) return null;

    final lockUntil = DateTime.tryParse(value)?.toLocal();
    if (lockUntil == null) {
      await _storage.delete(
        key: key,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        mOptions: _macOsOptions,
        lOptions: _linuxOptions,
        webOptions: _webOptions,
      );
      return null;
    }

    if (DateTime.now().isAfter(lockUntil)) {
      await reset(email);
      return null;
    }

    return LoginLockInfo(
      lockUntil: lockUntil,
      remaining: lockUntil.difference(DateTime.now()),
    );
  }

  /// Registra uma tentativa de login válida e limpa contadores.
  static Future<void> registerSuccess(String email) async {
    await reset(email);
  }

  /// Registra uma tentativa inválida e devolve as tentativas restantes.
  ///
  /// Retorna 0 quando o usuário foi bloqueado.
  static Future<int> registerFailure(String email) async {
    final normalizedEmail = _normalizeEmail(email);
    final attemptKey = '$_attemptKeyPrefix$normalizedEmail';

    final rawAttempts = await _storage.read(
      key: attemptKey,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );
    var attempts = int.tryParse(rawAttempts ?? '0') ?? 0;
    attempts += 1;

    if (attempts >= _maxAttempts) {
      await _storage.delete(
        key: attemptKey,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        mOptions: _macOsOptions,
        lOptions: _linuxOptions,
        webOptions: _webOptions,
      );

      final lockUntil = DateTime.now().add(_lockDuration).toUtc();
      await _storage.write(
        key: _lockKey(normalizedEmail),
        value: lockUntil.toIso8601String(),
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        mOptions: _macOsOptions,
        lOptions: _linuxOptions,
        webOptions: _webOptions,
      );

      return 0;
    }

    await _storage.write(
      key: attemptKey,
      value: attempts.toString(),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );

    return _maxAttempts - attempts;
  }

  /// Limpa tentativas e bloqueios.
  static Future<void> reset(String email) async {
    final normalizedEmail = _normalizeEmail(email);

    await _storage.delete(
      key: '$_attemptKeyPrefix$normalizedEmail',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );
    await _storage.delete(
      key: _lockKey(normalizedEmail),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );
  }

  static String _lockKey(String email) =>
      '$_lockKeyPrefix${_normalizeEmail(email)}';

  static String _normalizeEmail(String email) => email.trim().toLowerCase();
}
