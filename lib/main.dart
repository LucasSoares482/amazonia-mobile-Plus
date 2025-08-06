import 'package:flutter/material.dart';
import 'rotas.dart';

void main() {
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