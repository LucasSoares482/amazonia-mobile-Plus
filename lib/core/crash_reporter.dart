import 'package:flutter/foundation.dart'; // CORRIGIDO: de 'package.flutter' para 'package:flutter'
import 'package:sentry_flutter/sentry_flutter.dart';
import '../env/env.dart';

/// Inicializa o serviço de relatório de erros (Sentry).
Future<void> initCrashReporter() async {
  if (Env.sentryDsn.isEmpty) return;

  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDsn;
    options.environment = Env.flavor;
    options.tracesSampleRate = kReleaseMode ? 0.2 : 1.0;
  });
}

/// Captura e envia um erro para o serviço de relatório de erros.
Future<void> captureError(dynamic error, [StackTrace? stack]) async {
  try {
    await Sentry.captureException(error, stackTrace: stack);
  } catch (_) {
    // Ignora falha de envio
  }
}