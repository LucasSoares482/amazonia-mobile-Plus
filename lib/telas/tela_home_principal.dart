import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/app_state.dart';
import '../widgets/evento_card.dart';
import '../widgets/sidebar_drawer.dart';

class TelaHomePrincipal extends StatefulWidget {
  const TelaHomePrincipal({super.key});

  @override
  State<TelaHomePrincipal> createState() => _TelaHomePrincipalState();
}

class _TelaHomePrincipalState extends State<TelaHomePrincipal> {
  List<Map<String, dynamic>> _eventos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    setState(() => _carregando = true);
    try {
      final eventos = await DatabaseHelper.instance.obterEventos();
      if (mounted) {
        setState(() {
          _eventos = eventos;
        });
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _abrirCheckin(Map<String, dynamic> evento) {
    Navigator.pushNamed(context, '/checkin', arguments: evento);
  }
  
  void _editarEvento(Map<String, dynamic> evento) async {
    final resultado = await Navigator.pushNamed(context, '/criar-evento', arguments: evento);
    if (resultado == true && mounted) {
      _carregarEventos();
    }
  }

  void _excluirEvento(int eventoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Evento'),
        content: const Text('Deseja realmente excluir este evento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await DatabaseHelper.instance.excluirEvento(eventoId);
              _carregarEventos();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Evento excluído com sucesso')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final usuario = AppState.usuarioLogado;
    if (usuario == null) {
      return const Scaffold(body: Center(child: Text('Usuário não encontrado')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${usuario.nome.split(' ').first}'),
      ),
      drawer: const SidebarDrawer(),
      body: RefreshIndicator(
        onRefresh: _carregarEventos,
        child:
            usuario.isVisitador ? _buildVisitadorHome() : _buildResponsavelHome(),
      ),
    );
  }

  Widget _buildVisitadorHome() {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Eventos Disponíveis', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Visite os eventos e ganhe AmaCoins!', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        if (_carregando)
          const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
        else if (_eventos.isEmpty)
          const SliverFillRemaining(child: Center(child: Text('Nenhum evento disponível')))
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final evento = _eventos[index];
                  return EventoCard(
                    evento: evento,
                    onTap: () => _abrirCheckin(evento),
                  );
                },
                childCount: _eventos.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResponsavelHome() {
    final meusEventos = _eventos
        .where((e) => e['responsavel_id'] == AppState.usuarioLogado!.id)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Meus Eventos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            final resultado = await Navigator.pushNamed(context, '/criar-evento');
            if (resultado == true) {
              _carregarEventos();
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Criar Novo Evento'),
        ),
        const SizedBox(height: 20),
        if (_carregando)
          const Center(child: CircularProgressIndicator())
        else if (meusEventos.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.only(top: 48.0), child: Text('Nenhum evento criado')))
        else
          ...meusEventos.map((evento) => _buildMeuEventoCard(evento)),
      ],
    );
  }
  
  Widget _buildMeuEventoCard(Map<String, dynamic> evento) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(evento['titulo'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'editar') {
                      _editarEvento(evento);
                    } else if (value == 'excluir') {
                      _excluirEvento(evento['id']);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'editar', child: Text('Editar')),
                    const PopupMenuItem(value: 'excluir', child: Text('Excluir', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(evento['descricao'], style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}