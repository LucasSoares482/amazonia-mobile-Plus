import 'package:flutter/material.dart';

class TelaHistorico extends StatelessWidget {
  final List<String> checkins = [
    'Check-in na Trilha Ecológica - 01/07/2025',
    'Check-in na Comunidade Ribeirinha - 15/07/2025',
    'Check-in no Viveiro de Mudas - 28/07/2025',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Check-ins')),
      body: ListView.builder(
        itemCount: checkins.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text(checkins[index]),
          );
        },
      ),
    );
  }
}
