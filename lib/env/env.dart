/// Classe para gerir variáveis de ambiente.
class Env {
  /// O ambiente atual da aplicação (dev | staging | prod).
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  /// A URL base da API.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  /// A DSN do Sentry para relatório de erros.
  static const sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
  );

  /// Ativa ou desativa os logs detalhados da aplicação.
  static const enableLogs = bool.fromEnvironment(
    'ENABLE_LOGS',
    defaultValue: true,
  );
}