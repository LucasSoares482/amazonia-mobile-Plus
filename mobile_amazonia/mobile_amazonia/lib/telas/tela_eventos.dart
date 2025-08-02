import 'package:flutter/material.dart';

class TelaEventos extends StatelessWidget {
  final List<String> eventos = [
    'Passeio Ecológico',
    'Trilha Sensorial',
    'Oficina de Reciclagem',
    'Visita a Comunidade Ribeirinha',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Experiências')),
      body: ListView.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.nature_people),
            title: Text(eventos[index]),
            subtitle: Text('Clique para saber mais'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
