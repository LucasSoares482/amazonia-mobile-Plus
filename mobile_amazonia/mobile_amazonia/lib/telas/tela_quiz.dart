import 'package:flutter/material.dart';

class TelaQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Educativo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qual a maior floresta tropical do mundo?', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: Text('Floresta Amazônica')),
            ElevatedButton(onPressed: () {}, child: Text('Floresta do Congo')),
            ElevatedButton(onPressed: () {}, child: Text('Floresta de Bornéu')),
          ],
        ),
      ),
    );
  }
}
