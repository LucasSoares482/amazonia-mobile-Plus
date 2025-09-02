// main.dart - Entrada principal do aplicativo
import 'package:flutter/material.dart';
import 'config/flavors.dart';
import 'core/crash_reporter.dart';
import 'telas/tela_abertura.dart';
import 'rotas.dart';

void main() async {
  // Tudo deve estar na mesma zona
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Sentry (se SENTRY_DSN estiver definido)
  await CrashReporter.init();
  
  // Executa o app
  runApp(const AppRoot());
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