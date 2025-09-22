import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';
import '../utils/app_state.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/primary_button.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;
  String _tipoUsuario = 'visitador';

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      final userData = {
        'nome': _nomeController.text,
        'email': _emailController.text,
        'senha': _senhaController.text,
        'tipo': _tipoUsuario,
        'amacoins': 0,
      };

      final id = await DatabaseHelper.instance.inserirUsuario(userData);
      userData['id'] = id;

      final usuario = Usuario.fromMap(userData);
      AppState.login(usuario);

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail já cadastrado')),
        );
      }
    } finally {
      if(mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Criar Nova Conta', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 30),
              CustomTextFormField(
                controller: _nomeController,
                labelText: 'Nome completo',
                icon: Icons.person,
                validator: (value) => (value?.isEmpty ?? true) ? 'Digite seu nome' : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _emailController,
                labelText: 'E-mail',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Digite seu e-mail';
                  if (!value!.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _senhaController,
                labelText: 'Senha',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Digite uma senha';
                  if (value!.length < 4) return 'Mínimo 4 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildUserTypeSelector(),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Criar Conta',
                onPressed: _cadastrar,
                isLoading: _carregando,
              ),
            ],
          ),
        ),
      ),
    );

  Widget _buildUserTypeSelector() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tipo de conta:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        RadioListTile<String>(
          title: const Text('Visitador'),
          subtitle: const Text('Para visitar eventos e ganhar AmaCoins'),
          value: 'visitador',
          groupValue: _tipoUsuario,
          onChanged: (value) => setState(() => _tipoUsuario = value!),
        ),
        RadioListTile<String>(
          title: const Text('Responsável'),
          subtitle: const Text('Para criar e gerenciar eventos'),
          value: 'responsavel',
          groupValue: _tipoUsuario,
          onChanged: (value) => setState(() => _tipoUsuario = value!),
        ),
      ],
    );

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}