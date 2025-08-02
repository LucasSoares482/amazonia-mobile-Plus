import 'package:flutter/material.dart';

class TelaCheckin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check-in')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Check-in realizado com sucesso!')),
            );
          },
          child: Text('Confirmar Check-in'),
        ),
      ),
    );
  }
}
