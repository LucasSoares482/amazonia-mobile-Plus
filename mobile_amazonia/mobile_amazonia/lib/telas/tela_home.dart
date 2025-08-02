import 'package:flutter/material.dart';

class TelaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.pushNamed(context, '/carteira');
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/mapa');
            },
            child: Text('Mapa e Check-in'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/eventos');
            },
            child: Text('Experiências e Eventos'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quiz');
            },
            child: Text('Quizzes Educativos'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/chatbot');
            },
            child: Text('Chatbot Inteligente'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/historico');
            },
            child: Text('Histórico de Check-ins'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/perfil');
            },
            child: Text('Perfil e Configurações'),
          ),
        ],
      ),
    );
  }
}
