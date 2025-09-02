import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/app_state.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});
  
  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  List<Map<String, dynamic>> _checkins = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCheckins();
  }

  Future<void> _carregarCheckins() async {
    if (AppState.usuarioLogado == null) return;

    try {
      final checkins = await DatabaseHelper.instance.obterCheckins(
        AppState.usuarioLogado!.id!,
      );
      setState(() {
        _checkins = checkins;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  String _formatarData(String dataIso) {
    final data = DateTime.parse(dataIso);
    return '${data.day}/${data.month}/${data.year} às ${data.hour}:${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Histórico de Check-ins')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _checkins.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Nenhum check-in realizado'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _checkins.length,
                  itemBuilder: (context, index) {
                    final checkin = _checkins[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(checkin['local']),
                        subtitle: Text(_formatarData(checkin['data'])),
                      ),
                    );
                  },
                ),
    );
}