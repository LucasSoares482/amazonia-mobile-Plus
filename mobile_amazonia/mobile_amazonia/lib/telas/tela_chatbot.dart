import 'package:flutter/material.dart';

class TelaChatbot extends StatelessWidget {
  final TextEditingController mensagemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text('Bot: Olá! Como posso ajudar?', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: mensagemController,
                    decoration: InputDecoration(hintText: 'Digite sua mensagem'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    mensagemController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
