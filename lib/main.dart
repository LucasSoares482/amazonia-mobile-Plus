// main.dart - Entrada principal do aplicativo (com Firebase integrado)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'config/flavors.dart';
import 'core/crash_reporter.dart';
import 'core/navigation.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'rotas.dart';
import 'services/analytics_service.dart';
import 'services/error_service.dart';
import 'services/locale_service.dart';
import 'services/theme_service.dart';
import 'utils/app_state.dart';

Future<void> main() async {
  // Garante que o Flutter está inicializado antes de rodar código assíncrono.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as configurações do projeto geradas pelo FlutterFire CLI.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Faz login anônimo (útil para demonstrações e protótipos).
  await FirebaseAuth.instance.signInAnonymously();

  // Inicializa o sistema de relatórios de erro (Sentry, por exemplo)
  await initCrashReporter();

  // Restaura a sessão e inicializa telemetria offline-first.
  await AppState.initialize();
  await ThemeService.instance.initialize();
  await LocaleService.instance.initialize();
  await AnalyticsService.instance.initialize();
  AnalyticsService.instance.logAppOpen();

  FlutterError.onError = (details) {
    ErrorService.instance.handleError(
      origem: details.library ?? 'flutter_framework',
      mensagem: details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    ErrorService.instance.handleError(
      origem: 'platform_dispatcher',
      mensagem: error.toString(),
      stackTrace: stack,
    );
    return true;
  };

  // Executa a aplicação.
  runApp(const AppRoot());
}

/// Widget raiz da aplicação.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeService.instance.themeMode,
        builder: (context, themeMode, _) => ValueListenableBuilder<Locale>(
          valueListenable: LocaleService.instance.locale,
          builder: (context, locale, __) => ValueListenableBuilder<bool>(
            valueListenable: ThemeService.instance.isTransitioning,
            builder: (context, transitioning, ___) => AnimatedTheme(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              data: themeMode == ThemeMode.dark
                  ? _buildDarkTheme()
                  : _buildLightTheme(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: MaterialApp(
                  key: ValueKey('${themeMode.name}_${locale.toLanguageTag()}'),
                  title: appTitle,
                  onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
                  debugShowCheckedModeBanner: currentFlavor != Flavor.prod,
                  navigatorKey: appNavigatorKey,
                  themeMode: themeMode,
                  theme: _buildLightTheme(),
                  darkTheme: _buildDarkTheme(),
                  locale: locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  initialRoute: '/abertura',
                  routes: rotasApp,
                ),
              ),
            ),
          ),
        ),
      );

  ThemeData _buildLightTheme() {
    const primary = Color(0xFF006837);
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardColor: Colors.white,
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        bodyColor: const Color(0xFF1B1B1B),
        displayColor: const Color(0xFF1B1B1B),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    const background = Color(0xFF121212);
    const surface = Color(0xFF1E1E1E);
    const primary = Color(0xFF00C853);
    const secondary = Color(0xFF00BFA5);

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      dialogBackgroundColor: surface,
      canvasColor: background,
      cardColor: surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        background: background,
        surface: surface,
        primary: primary,
        secondary: secondary,
      ),
    );

    final textTheme = baseTheme.textTheme.apply(
      bodyColor: const Color(0xFFE0E0E0),
      displayColor: const Color(0xFFE0E0E0),
    ).copyWith(
      headlineLarge: baseTheme.textTheme.headlineLarge?.copyWith(
        color: Colors.white,
      ),
      headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
        color: Colors.white,
      ),
      titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
        color: const Color(0xFFE0E0E0),
      ),
      bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
        color: const Color(0xFFBDBDBD),
      ),
    );

    return baseTheme.copyWith(
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          overlayColor: Colors.white.withOpacity(0.08),
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFFE0E0E0),
        textColor: Color(0xFFE0E0E0),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerColor: Colors.white12,
      splashColor: primary.withOpacity(0.12),
      highlightColor: secondary.withOpacity(0.08),
    );
  }
}

/// Página de teste do Firebase (opcional, pode remover depois)
class FirebaseTestPage extends StatelessWidget {
  const FirebaseTestPage({super.key});

  Future<void> _gravarTeste() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'sem-usuario';
    await FirebaseFirestore.instance.collection('testes').add({
      'userId': uid,
      'mensagem': 'Olá, Firebase!',
      'data': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Teste Firebase')),
      body: Center(
        child: ElevatedButton(
          onPressed: _gravarTeste,
          child: const Text('Gravar teste no Firestore'),
        ),
      ),
    );
}
