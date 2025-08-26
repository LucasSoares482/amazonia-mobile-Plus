class Env {
  /// dev | staging | prod
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  /// Base URL da sua API (ex.: http://10.0.2.2:3000 ou https://api.seuapp.com)
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  /// DSN do Sentry (pode ficar vazio em dev)
  static const sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  /// Ativa/desativa logs verbosos do app (true em dev/staging, false em prod)
  static const enableLogs = bool.fromEnvironment(
    'ENABLE_LOGS',
    defaultValue: true,
  );
}
