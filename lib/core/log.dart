import 'package:logger/logger.dart';
import '../env/env.dart';

final log = Logger(
  printer: PrettyPrinter(),
  level: Env.enableLogs ? Level.debug : Level.warning,
);
