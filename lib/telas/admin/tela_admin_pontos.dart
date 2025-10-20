import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../l10n/l10n.dart';
import '../../services/analytics_service.dart';

class TelaAdminPontos extends StatefulWidget {
  const TelaAdminPontos({super.key});

  @override
  State<TelaAdminPontos> createState() => _TelaAdminPontosState();
}

class _TelaAdminPontosState extends State<TelaAdminPontos> {
  bool _carregando = true;
  List<Map<String, dynamic>> _pontos = [];

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreenView('admin_pontos');
    _carregarPontos();
  }

  Future<void> _carregarPontos() async {
    setState(() => _carregando = true);
    try {
      final pontos = await DatabaseHelper.instance.obterPontosTuristicos();
      if (!mounted) return;
      setState(() {
        _pontos = pontos;
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
          title: Text(AppLocalizations.of(context).drawerManagePoints),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _abrirEditor(),
              tooltip: 'Adicionar ponto',
            ),
          ],
        ),
        body: RefreshIndicator(
          color: Colors.green.shade700,
          onRefresh: _carregarPontos,
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : _pontos.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _pontos.length,
                      itemBuilder: (context, index) {
                        final ponto = _pontos[index];
                        return _buildPontoCard(ponto);
                      },
                    ),
        ),
      );

  Widget _buildEmptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Ainda não há pontos cadastrados. Adicione o primeiro para começar!',
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _abrirEditor,
                icon: const Icon(Icons.add),
                label: const Text('Novo ponto'),
              ),
            ],
          ),
        ),
      );

  Widget _buildPontoCard(Map<String, dynamic> ponto) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (ponto['nome'] ?? 'Sem nome').toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Editar',
                    onPressed: () => _abrirEditor(ponto: ponto),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Excluir',
                    onPressed: () => _confirmarExclusao(ponto),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                (ponto['descricao'] ?? 'Sem descrição').toString(),
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.place, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      (ponto['endereco'] ?? '').toString(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Future<void> _abrirEditor({Map<String, dynamic>? ponto}) async {
    final resultado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _PontoEditor(ponto: ponto),
    );
    if (resultado == true) {
      await _carregarPontos();
    }
  }

  Future<void> _confirmarExclusao(Map<String, dynamic> ponto) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir ponto'),
        content: Text(
          'Tem certeza de que deseja remover "${ponto['nome']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmado == true) {
      await DatabaseHelper.instance.deletarPontoTuristico(
        ponto['id'].toString(),
      );
      AnalyticsService.instance.logEvent(
        'admin_point_delete',
        properties: {'ponto_id': ponto['id'], 'nome': ponto['nome']},
      );
      await _carregarPontos();
    }
  }
}

class _PontoEditor extends StatefulWidget {
  const _PontoEditor({this.ponto});

  final Map<String, dynamic>? ponto;

  @override
  State<_PontoEditor> createState() => _PontoEditorState();
}

class _PontoEditorState extends State<_PontoEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _enderecoController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  bool _salvando = false;

  bool get _isEditando => widget.ponto != null;

  @override
  void initState() {
    super.initState();
    _nomeController =
        TextEditingController(text: widget.ponto?['nome']?.toString());
    _descricaoController =
        TextEditingController(text: widget.ponto?['descricao']?.toString());
    _enderecoController =
        TextEditingController(text: widget.ponto?['endereco']?.toString());
    _latitudeController = TextEditingController(
      text: widget.ponto?['latitude']?.toString(),
    );
    _longitudeController = TextEditingController(
      text: widget.ponto?['longitude']?.toString(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _enderecoController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isEditando ? 'Editar ponto turístico' : 'Novo ponto turístico',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Descreva o ponto'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Informe o endereço'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latitudeController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Latitude'),
                        validator: _validarCoordenada,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _longitudeController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Longitude'),
                        validator: _validarCoordenada,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: _salvando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isEditando ? 'Salvar alterações' : 'Cadastrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  String? _validarCoordenada(String? value) {
    if (value == null || value.isEmpty) return 'Informe a coordenada';
    return double.tryParse(value) == null ? 'Valor inválido' : null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    final dados = {
      'nome': _nomeController.text.trim(),
      'descricao': _descricaoController.text.trim(),
      'endereco': _enderecoController.text.trim(),
      'latitude': double.tryParse(_latitudeController.text.trim()) ?? 0,
      'longitude': double.tryParse(_longitudeController.text.trim()) ?? 0,
    };

    try {
      if (_isEditando) {
        await DatabaseHelper.instance.atualizarPontoTuristico({
          'id': widget.ponto!['id'],
          ...dados,
        });
        AnalyticsService.instance.logEvent(
          'admin_point_update',
          properties: {
            'ponto_id': widget.ponto!['id'],
            'nome': dados['nome'],
          },
        );
      } else {
        await DatabaseHelper.instance.adicionarPontoTuristico(dados);
        AnalyticsService.instance.logEvent(
          'admin_point_create',
          properties: {'nome': dados['nome']},
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }
}
