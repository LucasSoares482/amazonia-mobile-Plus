import 'package:flutter/material.dart';
import 'rotas.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazônia Experience',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/abertura',
      routes: rotasApp,
    );
  }
}