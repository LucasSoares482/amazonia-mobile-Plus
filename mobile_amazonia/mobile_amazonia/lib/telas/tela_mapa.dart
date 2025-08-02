import 'package:flutter/material.dart';

class TelaMapa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 100, color: Colors.green),
            SizedBox(height: 16),
            Text('Aqui será exibido o mapa com os pontos de check-in'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/checkin');
              },
              child: Text('Fazer Check-in'),
            ),
          ],
        ),
      ),
    );
  }
}
