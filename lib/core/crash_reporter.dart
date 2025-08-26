import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../env/env.dart';

class CrashReporter {
  static Future<void> init() async {
    // Se não tiver DSN, não inicializa Sentry (útil em dev local)
    if (Env.sentryDsn.isEmpty) return;

    await SentryFlutter.init((options) {
      options.dsn = Env.sentryDsn;
      options.environment = Env.flavor;
      // tracing alto em dev, menor em release
      options.tracesSampleRate = kReleaseMode ? 0.2 : 1.0;
    });
  }

  static Future<void> capture(dynamic error, [StackTrace? stack]) async {
    try {
      await Sentry.captureException(error, stackTrace: stack);
    } catch (_) {
      // Ignora falha de envio
    }
  }
}
