// telas/tela_criar_evento.dart - Tela para criar eventos com câmera
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database/database_helper.dart';
import '../utils/app_state.dart';

class TelaCriarEvento extends StatefulWidget {
  const TelaCriarEvento({super.key});

  @override
  State<TelaCriarEvento> createState() => _TelaCriarEventoState();
}

class _TelaCriarEventoState extends State<TelaCriarEvento> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _amacoinsController = TextEditingController();
  
  DateTime _dataInicio = DateTime.now().add(const Duration(hours: 1));
  DateTime _dataFim = DateTime.now().add(const Duration(days: 1));
  String? _fotoPath;
  bool _salvando = false;

  Future<void> _selecionarFoto() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Adicionar foto do evento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.blue.shade600,
                  ),
                ),
                title: const Text('Câmera'),
                subtitle: const Text('Tirar foto do evento'),
                onTap: () {
                  Navigator.pop(context);
                  _tirarFoto(ImageSource.camera);
                },
              ),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: Colors.green.shade600,
                  ),
                ),
                title: const Text('Galeria'),
                subtitle: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _tirarFoto(ImageSource.gallery);
                },
              ),
              
              if (_fotoPath != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red.shade600,
                    ),
                  ),
                  title: const Text(
                    'Remover foto',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _fotoPath = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _tirarFoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() => _fotoPath = pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao capturar foto'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selecionarData(bool isInicio) async {
    final data = await showDatePicker(
      context: context,
      initialDate: isInicio ? _dataInicio : _dataFim,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );
    
    if (data != null && mounted) {
      final hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isInicio ? _dataInicio : _dataFim),
      );
      
      if (hora != null) {
        final dataCompleta = DateTime(
          data.year,
          data.month,
          data.day,
          hora.hour,
          hora.minute,
        );
        
        setState(() {
          if (isInicio) {
            _dataInicio = dataCompleta;
            // Garantir que data fim seja depois da data início
            if (_dataFim.isBefore(_dataInicio)) {
              _dataFim = _dataInicio.add(const Duration(hours: 2));
            }
          } else {
            if (dataCompleta.isBefore(_dataInicio)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('A data de fim deve ser posterior à data de início'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            _dataFim = dataCompleta;
          }
        });
      }
    }
  }

  Future<void> _salvarEvento() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final evento = {
        'titulo': _tituloController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'endereco': _enderecoController.text.trim(),
        'data_inicio': _dataInicio.toIso8601String(),
        'data_fim': _dataFim.toIso8601String(),
        'amacoins': int.parse(_amacoinsController.text),
        'responsavel_id': AppState.usuarioLogado!.id,
        'foto_path': _fotoPath,
      };

      await DatabaseHelper.instance.inserirEvento(evento);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Evento criado com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
        Navigator.pop(context, true); // Retorna true para indicar sucesso
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar evento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _salvando = false);
    }
  }

  String _formatarDataHora(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: const Text('Criar Evento'),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _salvando ? null : _salvarEvento,
            icon: _salvando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save, color: Colors.white, size: 20),
            label: Text(
              _salvando ? 'Criando...' : 'Criar',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade600,
              Colors.grey.shade50,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Foto do evento
                Container(
                  margin: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: _selecionarFoto,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: _fotoPath == null 
                            ? Colors.white.withOpacity(0.9)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _fotoPath != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    File(_fotoPath!),
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: _selecionarFoto,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 48,
                                  color: Colors.green.shade600,
                                ),
                                const SizedBox(height: 12),
                                  Text(
                                  'Adicionar foto do evento',
                                  style: TextStyle(
                                    color: Colors.green.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Toque para selecionar',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                
                // Formulário
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações do Evento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      TextFormField(
                        controller: _tituloController,
                        decoration: InputDecoration(
                          labelText: 'Título do evento',
                          prefixIcon: Icon(
                            Icons.event,
                            color: Colors.green.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Digite o título do evento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descricaoController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Descrição do evento',
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.green.shade600,
                          ),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Digite a descrição do evento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _enderecoController,
                        decoration: InputDecoration(
                          labelText: 'Endereço/Local',
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.green.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Digite o endereço do evento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _amacoinsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'AmaCoins de recompensa',
                          prefixIcon: Icon(
                            Icons.monetization_on,
                            color: Colors.amber.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                          helperText: 'Quantos AmaCoins o visitante ganhará?',
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Digite a quantidade de AmaCoins';
                          }
                          final amacoins = int.tryParse(value!);
                          if (amacoins == null || amacoins <= 0) {
                            return 'Digite um número válido maior que 0';
                          }
                          if (amacoins > 1000) {
                            return 'Máximo de 1000 AmaCoins por evento';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                
                // Datas
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Período do Evento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildCampoData(
                              'Data de início',
                              _dataInicio,
                              Icons.play_circle_outline,
                              Colors.green,
                              () => _selecionarData(true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCampoData(
                              'Data de fim',
                              _dataFim,
                              Icons.stop_circle_outlined,
                              Colors.red,
                              () => _selecionarData(false),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'O evento ficará disponível para check-in apenas durante este período',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCampoData(
    String label,
    DateTime data,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${data.day}/${data.month}/${data.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _enderecoController.dispose();
    _amacoinsController.dispose();
    super.dispose();
  }
}