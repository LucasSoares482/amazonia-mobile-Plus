import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';
import '../utils/app_state.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/primary_button.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _inicializarUsuariosDemo();
  }

  Future<void> _inicializarUsuariosDemo() async {
    try {
      await DatabaseHelper.instance.inserirUsuario({
        'nome': 'João Visitador',
        'email': 'visitador@test.com',
        'senha': '1234',
        'tipo': 'visitador',
        'amacoins': 150,
      });
      await DatabaseHelper.instance.inserirUsuario({
        'nome': 'Maria Responsável',
        'email': 'responsavel@test.com',
        'senha': '1234',
        'tipo': 'responsavel',
        'amacoins': 0,
      });
    } catch (e) {
      // Usuários já existem
    }
  }

  void _loginRapido(String email) {
    _emailController.text = email;
    _senhaController.text = '1234';
    _fazerLogin();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);
    try {
      final resultado = await DatabaseHelper.instance.loginUsuario(
        _emailController.text,
        _senhaController.text,
      );
      if (resultado != null) {
        AppState.login(Usuario.fromMap(resultado));
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email ou senha incorretos')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade400, Colors.green.shade800],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'AmaCoins',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  _buildTestUsersCard(),
                  const SizedBox(height: 30),
                  _buildLoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestUsersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text('Usuários de Teste',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _loginRapido('visitador@test.com'),
            icon: const Icon(Icons.person),
            label: const Text('Login como Visitador'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _loginRapido('responsavel@test.com'),
            icon: const Icon(Icons.business),
            label: const Text('Login como Responsável'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
                if (value?.isEmpty ?? true) return 'Digite sua senha';
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Entrar',
              onPressed: _fazerLogin,
              isLoading: _carregando,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/cadastro'),
              child: const Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}