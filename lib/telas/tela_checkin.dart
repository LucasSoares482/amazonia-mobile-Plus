import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/app_state.dart';

class TelaCheckin extends StatefulWidget {
  const TelaCheckin({super.key});
  
  @override
  State<TelaCheckin> createState() => _TelaCheckinState();
}

class _TelaCheckinState extends State<TelaCheckin> {
  final List<Map<String, dynamic>> _locais = [
    {'nome': 'Trilha Ecológica', 'coins': 10},
    {'nome': 'Viveiro de Mudas', 'coins': 15},
    {'nome': 'Comunidade Ribeirinha', 'coins': 20},
    {'nome': 'Mirante da Floresta', 'coins': 25},
  ];

  Future<void> _fazerCheckin(String local, int coins) async {
    if (AppState.usuarioLogado == null) return;

    try {
      await DatabaseHelper.instance.inserirCheckin({
        'usuario_id': AppState.usuarioLogado!.id,
        'local': local,
        'data': DateTime.now().toIso8601String(),
      });

      await DatabaseHelper.instance.adicionarAmaCoins(
        AppState.usuarioLogado!.id!,
        coins,
      );

      AppState.usuarioLogado!.amacoins += coins;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Check-in realizado! +$coins AmaCoins'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer check-in')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check-in')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _locais.length,
        itemBuilder: (context, index) {
          final local = _locais[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.location_on, color: Colors.green, size: 40),
              title: Text(
                local['nome'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Ganhe ${local['coins']} AmaCoins'),
              trailing: ElevatedButton(
                onPressed: () => _fazerCheckin(local['nome'], local['coins']),
                child: Text('Check-in'),
              ),
            ),
          );
        },
      ),
    );
  }
}