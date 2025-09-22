// telas/tela_checkin.dart - Tela de check-in
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/app_state.dart';

class TelaCheckin extends StatefulWidget {
  const TelaCheckin({super.key});
  
  @override
  State<TelaCheckin> createState() => _TelaCheckinState();
}

class _TelaCheckinState extends State<TelaCheckin> {
  Map<String, dynamic>? _eventoSelecionado;
  bool _carregando = false;
  bool _checkinRealizado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receber evento passado como argumento
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _eventoSelecionado = args;
    }
  }

  bool get _eventoEstaAtivo {
    if (_eventoSelecionado == null) return false;
    
    final dataInicio = DateTime.parse(_eventoSelecionado!['data_inicio']);
    final dataFim = DateTime.parse(_eventoSelecionado!['data_fim']);
    final agora = DateTime.now();
    
    return agora.isAfter(dataInicio) && agora.isBefore(dataFim);
  }

  Future<void> _realizarCheckin() async {
    if (_eventoSelecionado == null || AppState.usuarioLogado == null) return;

    setState(() => _carregando = true);

    try {
      // Simular delay de processamento
      await Future.delayed(const Duration(seconds: 2));

      // Adicionar check-in
      await DatabaseHelper.instance.adicionarCheckin(
        AppState.usuarioLogado!.id!,
        _eventoSelecionado!['endereco'],
        _eventoSelecionado!['titulo'],
      );

      // Adicionar AmaCoins
      await DatabaseHelper.instance.adicionarAmaCoins(
        AppState.usuarioLogado!.id!,
        _eventoSelecionado!['amacoins'],
      );

      // Atualizar usuário local
      AppState.usuarioLogado!.amacoins += _eventoSelecionado!['amacoins'] as int;

      setState(() {
        _carregando = false;
        _checkinRealizado = true;
      });

    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao realizar check-in'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: const Text('Check-in'),
        elevation: 0,
      ),
      body: _eventoSelecionado == null
          ? _buildSemEventoSelecionado()
          : _checkinRealizado 
              ? _buildCheckinSucesso()
              : _buildTelaCheckin(),
    );

  Widget _buildSemEventoSelecionado() => const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum evento selecionado',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selecione um evento na tela principal para fazer check-in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );

  Widget _buildTelaCheckin() => Column(
      children: [
        // Header do evento
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade600, Colors.green.shade800],
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.location_on,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                _eventoSelecionado!['titulo'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _eventoSelecionado!['endereco'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Recompensa disponível:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 32,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_eventoSelecionado!['amacoins']}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AmaCoins',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _eventoSelecionado!['descricao'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _eventoEstaAtivo && !_carregando 
                        ? _realizarCheckin 
                        : null,
                    icon: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle, size: 24),
                    label: Text(
                      _carregando 
                          ? 'Processando...' 
                          : _eventoEstaAtivo 
                              ? 'Fazer Check-in'
                              : 'Evento não disponível',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _eventoEstaAtivo 
                          ? Colors.green.shade600 
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                if (!_eventoEstaAtivo)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Este evento ainda não começou ou já terminou',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );

  Widget _buildCheckinSucesso() => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Check-in realizado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Você ganhou ${_eventoSelecionado!['amacoins']} AmaCoins!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Obrigado por visitar "${_eventoSelecionado!['titulo']}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
}