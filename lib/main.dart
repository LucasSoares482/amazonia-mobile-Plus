// main.dart - Entrada principal do aplicativo
import 'dart:async';
import 'package:flutter/material.dart';
import 'config/flavors.dart';
import 'core/crash_reporter.dart';
import 'core/log.dart';
import 'telas/tela_abertura.dart';
import 'rotas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Sentry (se SENTRY_DSN estiver definido)
  await CrashReporter.init();

  // Captura erros não tratados
  runZonedGuarded(
    () {
      runApp(const AppRoot());
    },
    (error, stack) async {
      log.e('Uncaught error', error: error, stackTrace: stack);
      await CrashReporter.capture(error, stack);
    },
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: currentFlavor != Flavor.prod,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF006837),
        brightness: Brightness.light,
      ),
      // Define a tela inicial como splash/abertura
      initialRoute: '/abertura',
      routes: rotasApp,
    );
  }
}