// telas/tela_historico.dart - Tela de histórico com WhatsApp
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _compartilharWhatsApp(Map<String, dynamic> checkin) async {
    try {
      final nomeLocal = checkin['evento'] ?? checkin['local'] ?? 'um local incrível';
      final endereco = checkin['local'] ?? '';
      
      final mensagem = 'Olá! 🌟 Visitei "$nomeLocal" em $endereco através do app AmaCoins. '
                      'Foi uma experiência incrível! 🎉 Você também deveria conhecer. '
                      'Baixe o AmaCoins e explore a Amazônia ganhando recompensas! 🏆';
      
      final encodedMessage = Uri.encodeComponent(mensagem);
      final whatsappUrl = 'https://wa.me/?text=$encodedMessage';
      
      final uri = Uri.parse(whatsappUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o WhatsApp'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao compartilhar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: const Text('Histórico de Visitas'),
        elevation: 0,
      ),
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

  Widget _buildHistoricoVazio() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 24),
          Text(
            'Nenhuma visita registrada',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Quando você fizer check-in nos eventos, eles aparecerão aqui para você compartilhar com seus amigos!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaHistorico() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suas Visitas (${_checkins.length})',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Compartilhe suas experiências com amigos!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _checkins.length,
            itemBuilder: (context, index) {
              // Mostrar mais recentes primeiro
              final checkin = _checkins[_checkins.length - 1 - index];
              return _buildHistoricoItem(checkin, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoricoItem(Map<String, dynamic> checkin, int index) {
    final data = DateTime.parse(checkin['data']);
    final nomeEvento = checkin['evento'] ?? checkin['local'] ?? 'Evento';
    final endereco = checkin['local'] ?? '';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomeEvento,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (endereco.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                endereco,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 16,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+10', // Valor padrão por enquanto
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  'Visitado em ${_formatarData(data)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _compartilharWhatsApp(checkin),
                icon: const Icon(
                  Icons.share,
                  size: 18,
                ),
                label: const Text(
                  'Compartilhar no WhatsApp',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}