import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database_helper.dart';
import '../utils/app_state.dart';
import '../widgets/historico_card.dart';

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
    setState(() => _carregando = true);
    try {
      final checkins = await DatabaseHelper.instance.obterCheckins(AppState.usuarioLogado!.id!);
      if (mounted) setState(() => _checkins = checkins);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _compartilharWhatsApp(Map<String, dynamic> checkin) async {
    final nomeLocal = checkin['evento'] ?? checkin['local'] ?? 'um local incrível';
    final mensagem = Uri.encodeComponent('Olá! 🌟 Visitei "$nomeLocal" através do app AmaCoins. Foi uma experiência incrível! 🎉');
    final whatsappUrl = Uri.parse('https://wa.me/?text=$mensagem');
    
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível abrir o WhatsApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Visitas')),
      body: RefreshIndicator(
        onRefresh: _carregarCheckins,
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _checkins.isEmpty
                ? _buildHistoricoVazio()
                : _buildListaHistorico(),
      ),
    );
  }

  Widget _buildListaHistorico() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _checkins.length,
      itemBuilder: (context, index) {
        final checkin = _checkins[index];
        return HistoricoCard(
          checkin: checkin,
          onShare: () => _compartilharWhatsApp(checkin),
        );
      },
    );
  }

  Widget _buildHistoricoVazio() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 100, color: Colors.grey),
          SizedBox(height: 24),
          Text('Nenhuma visita registrada', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Quando você fizer check-in nos eventos, eles aparecerão aqui!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}