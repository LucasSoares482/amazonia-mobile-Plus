import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../l10n/l10n.dart';
import '../../services/analytics_service.dart';

class TelaAdminUsuarios extends StatefulWidget {
  const TelaAdminUsuarios({super.key});

  @override
  State<TelaAdminUsuarios> createState() => _TelaAdminUsuariosState();
}

class _TelaAdminUsuariosState extends State<TelaAdminUsuarios> {
  final _tipos = const ['visitador', 'responsavel', 'administrador'];
  bool _carregando = true;
  List<Map<String, dynamic>> _usuarios = [];
  String _filtroTipo = 'todos';

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreenView('admin_users');
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    setState(() => _carregando = true);
    try {
      final usuarios = await DatabaseHelper.instance.obterUsuarios();
      if (!mounted) return;
      setState(() {
        _usuarios = usuarios;
        _carregando = false;
      });
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          title: Text(AppLocalizations.of(context).drawerManageUsers),
        ),
        body: RefreshIndicator(
          color: Colors.green.shade700,
          onRefresh: _carregarUsuarios,
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : _buildConteudo(),
        ),
      );

  Widget _buildConteudo() {
    final usuariosFiltrados = _usuarios.where((usuario) {
      if (_filtroTipo == 'todos') return true;
      return (usuario['tipo'] ?? 'visitador') == _filtroTipo;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Controle perfis de acesso',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Promova responsáveis a administradores ou ajuste perfis de visitantes.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        _buildFiltros(),
        const SizedBox(height: 16),
        if (usuariosFiltrados.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Nenhum usuário com o filtro selecionado.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          ...usuariosFiltrados.map(_buildUsuarioTile),
      ],
    );
  }

  Widget _buildFiltros() => Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: const Text('Todos'),
            selected: _filtroTipo == 'todos',
            onSelected: (_) => setState(() => _filtroTipo = 'todos'),
          ),
          ..._tipos.map(
            (tipo) => ChoiceChip(
              label: Text(tipo),
              selected: _filtroTipo == tipo,
              onSelected: (_) => setState(() => _filtroTipo = tipo),
            ),
          ),
        ],
      );

  Widget _buildUsuarioTile(Map<String, dynamic> usuario) {
    final tipoAtual = (usuario['tipo'] ?? 'visitador').toString();
    final nome = (usuario['nome'] ?? 'Sem nome').toString();
    final email = (usuario['email'] ?? '').toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Text(nome.isNotEmpty ? nome[0].toUpperCase() : '?'),
        ),
        title: Text(nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: tipoAtual,
              items: _tipos
                  .map(
                    (tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null || value == tipoAtual) return;
                _atualizarTipo(usuario['id'] as String, value);
              },
              decoration: const InputDecoration(
                labelText: 'Perfil',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Aplicar outra função',
          onPressed: () => _atualizarTipo(usuario['id'] as String, tipoAtual),
        ),
      ),
    );
  }

  Future<void> _atualizarTipo(String usuarioId, String tipo) async {
    await DatabaseHelper.instance.atualizarTipoUsuario(usuarioId, tipo);
    await _carregarUsuarios();
    if (!mounted) return;
    AnalyticsService.instance.logEvent(
      'admin_user_role_update',
      properties: {'usuario_id': usuarioId, 'novo_tipo': tipo},
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Função atualizada para $tipo'),
          backgroundColor: Colors.green.shade600,
        ),
      );
  }
}
