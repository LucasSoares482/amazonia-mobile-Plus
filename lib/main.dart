import 'dart:async';
import 'package:flutter/material.dart';
import 'config/flavors.dart';
import 'core/crash_reporter.dart';
import 'core/log.dart';

// Se você já tem sua splash, ajuste o import/caminho conforme seu projeto:
// import 'telas/tela_abertura.dart' as screens;
import 'telas/tela_mapa.dart';

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
  Widget build(BuildContext context) => MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: currentFlavor != Flavor.prod,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF006837),
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Menu Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaMapa()),
                );
              },
              child: const Text('Mapa de Belém do Pará'),
            ),
          ],
        ),
      ),
    );
}
