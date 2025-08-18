import 'package:flutter/material.dart';
import 'rotas.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o banco e garante que o usuário demo existe
  await DatabaseHelper.instance.database;
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazônia Experience',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: false,
      ),
      initialRoute: '/login',
      routes: rotasApp,
    );
  }
}