import 'package:flutter/material.dart';

class TelaPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.green),
            SizedBox(height: 16),
            Text('Nome do Usuário', style: TextStyle(fontSize: 20)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: Text('Editar Perfil'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
