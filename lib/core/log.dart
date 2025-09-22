import 'package:logger/logger.dart';
import '../env/env.dart';

/// Instância global do Logger para a aplicação.
final log = Logger(
  printer: PrettyPrinter(),
  level: Env.enableLogs ? Level.debug : Level.warning,
);