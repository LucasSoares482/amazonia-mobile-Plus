import 'dart:async';
import 'package:flutter/material.dart';

import 'env/env.dart';
import 'config/flavors.dart';
import 'core/crash_reporter.dart';
import 'core/log.dart';

// Se você já tem sua splash, ajuste o import/caminho conforme seu projeto:
import 'telas/tela_abertura.dart' as screens;

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
      // Se preferir rotas nomeadas, integre com seu rotas.dart aqui
      home: screens.TelaAbertura(), // ajuste se sua tela inicial for outra
    );
  }
}
