import 'package:flutter/material.dart';

class TelaCarteira extends StatelessWidget {
  final int amaCoins = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carteira')),
      body: Center(
        child: Text(
          'Você tem $amaCoins AmaCoins',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
