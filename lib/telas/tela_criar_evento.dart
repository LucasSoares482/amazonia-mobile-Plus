import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../utils/app_state.dart';
import '../utils/image_resolver.dart';

class TelaCriarEvento extends StatefulWidget {

  const TelaCriarEvento({super.key, this.eventoParaEditar});
  final Map<String, dynamic>? eventoParaEditar;

  @override
  State<TelaCriarEvento> createState() => _TelaCriarEventoState();
}

class _TelaCriarEventoState extends State<TelaCriarEvento> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _amacoinsController = TextEditingController();
  final _dataInicioController = TextEditingController();
  final _dataFimController = TextEditingController();

  DateTime _dataInicio = DateTime.now().add(const Duration(hours: 1));
  DateTime _dataFim = DateTime.now().add(const Duration(days: 1));
  String? _fotoPath;
  bool _salvando = false;

  bool get isEditing => widget.eventoParaEditar != null;

  @override
  void initState() {
    super.initState();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    if (isEditing) {
      final evento = widget.eventoParaEditar!;
      _tituloController.text = evento['titulo'];
      _descricaoController.text = evento['descricao'];
      _enderecoController.text = evento['endereco'];
      _amacoinsController.text = evento['amacoins'].toString();
      _dataInicio = DateTime.parse(evento['data_inicio']);
      _dataFim = DateTime.parse(evento['data_fim']);
      _fotoPath = evento['foto_path'];
      if (kIsWeb && _fotoPath != null && _fotoPath!.startsWith('blob:')) {
        _fotoPath = null;
      }
    }

    _dataInicioController.text = dateFormat.format(_dataInicio);
    _dataFimController.text = dateFormat.format(_dataFim);
  }

  Future<void> _salvarEvento() async {
    if (!_formKey.currentState!.validate()) return;
    
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    try {
      _dataInicio = dateFormat.parse(_dataInicioController.text);
      _dataFim = dateFormat.parse(_dataFimController.text);

      if (_dataFim.isBefore(_dataInicio)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A data de fim deve ser posterior à de início')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formato de data inválido. Use DD/MM/AAAA HH:MM')),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      final dadosEvento = {
        'titulo': _tituloController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'endereco': _enderecoController.text.trim(),
        'data_inicio': _dataInicio.toIso8601String(),
        'data_fim': _dataFim.toIso8601String(),
        'amacoins': int.parse(_amacoinsController.text),
        'responsavel_id': AppState.usuarioLogado!.id,
        'foto_path': kIsWeb ? null : _fotoPath,
      };

      if (isEditing) {
        dadosEvento['id'] = widget.eventoParaEditar!['id'];
        await DatabaseHelper.instance.atualizarEvento(dadosEvento);
      } else {
        await DatabaseHelper.instance.inserirEvento(dadosEvento);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Evento ${isEditing ? 'atualizado' : 'criado'} com sucesso!'),
            backgroundColor: Colors.green.shade600,
          ),
        );
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _selecionarFoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() => _fotoPath = pickedFile.path);
      }
    } catch (e) {
      // Handle error
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Evento' : 'Criar Evento'),
        actions: [
          TextButton.icon(
            onPressed: _salvando ? null : _salvarEvento,
            icon: _salvando
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save, color: Colors.white),
            label: Text(_salvando ? 'A guardar...' : 'Guardar', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              _buildEventInfoForm(),
              _buildDateTimePicker(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );

  Widget _buildImagePicker() => GestureDetector(
        onTap: () => _selecionarFoto(ImageSource.gallery),
        child: Builder(
          builder: (context) {
            final previewImage = resolveUserImage(_fotoPath);
            return Container(
              height: 200,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration
              (
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                image: previewImage != null
                    ? DecorationImage(image: previewImage, fit: BoxFit.cover)
                    : null,
              ),
              child: previewImage == null
                  ? const Center(child: Icon(Icons.add_a_photo, size: 48))
                  : null,
            );
          },
        ),
      );

  Widget _buildEventInfoForm() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informações do Evento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
            validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descricaoController,
            decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
            maxLines: 3,
            validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _enderecoController,
            decoration: const InputDecoration(labelText: 'Endereço', border: OutlineInputBorder()),
            validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amacoinsController,
            decoration: const InputDecoration(labelText: 'AmaCoins', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
          ),
        ],
      ),
    );

  Widget _buildDateTimePicker() => Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Período do Evento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _dataInicioController,
            decoration: const InputDecoration(labelText: 'Início', hintText: 'DD/MM/AAAA HH:MM', border: OutlineInputBorder()),
            keyboardType: TextInputType.datetime,
            validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dataFimController,
            decoration: const InputDecoration(labelText: 'Fim', hintText: 'DD/MM/AAAA HH:MM', border: OutlineInputBorder()),
            keyboardType: TextInputType.datetime,
            validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
          ),
        ],
      ),
    );
}
