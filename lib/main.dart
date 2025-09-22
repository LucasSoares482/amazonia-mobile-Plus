// main.dart - Entrada principal do aplicativo (Corrigido)
import 'package:flutter/material.dart';
import 'config/flavors.dart';
import 'core/crash_reporter.dart';
import 'rotas.dart';

void main() async {
  // Garante que os bindings do Flutter foram inicializados antes de chamar código nativo.
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o Sentry (se configurado)
  await initCrashReporter();
  // Executa a aplicação
  runApp(const AppRoot());
}

/// O widget raiz da aplicação.
class AppRoot extends StatelessWidget {
  /// Construtor do widget raiz.
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp( // CORREÇÃO: Corpo de função de expressão
        title: appTitle,
        debugShowCheckedModeBanner: currentFlavor != Flavor.prod,
        theme: _buildTheme(),
        initialRoute: '/abertura',
        routes: rotasApp,
      );

  ThemeData _buildTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF006837),
      brightness: Brightness.light,
    );

    return baseTheme.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      // CORREÇÃO 1: Usar CardThemeData em vez de CardTheme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // CORREÇÃO 2: Removido horizontal: 0 que era redundante
        margin: const EdgeInsets.symmetric(vertical: 8), 
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        // centerTitle: true foi removido pois já é o padrão em muitas configurações
      ),
    );
  }
}