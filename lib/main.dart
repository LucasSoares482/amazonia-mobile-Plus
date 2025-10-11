// main.dart - Entrada principal do aplicativo (com Firebase integrado)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'config/flavors.dart';
import 'core/crash_reporter.dart';
import 'firebase_options.dart';
import 'rotas.dart';

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

  // Executa a aplicação.
  runApp(const AppRoot());
}

/// Widget raiz da aplicação.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
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
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste Firebase')),
      body: Center(
        child: ElevatedButton(
          onPressed: _gravarTeste,
          child: const Text('Gravar teste no Firestore'),
        ),
      ),
    );
  }
}
