import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';
import '../utils/app_state.dart';

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
  bool _senhaVisivel = false;

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
      // Usuários já existem, ignorar
    }
  }

  void _loginRapido(String email, String tipo) {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer login')),
        );
      }
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo via URL
          Image.network(
            'https://blog.archtrends.com/wp-content/uploads/2024/11/belemdoparaabre-1536x1024.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.green);
            },
          ),
          // Overlay verde translúcido
          Container(color: Colors.green.withOpacity(0.4)),
          // Conteúdo
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo via URL
                    SizedBox(
                      height: 120,
                      child: Image.network(
                        'https://i0.wp.com/apublica.org/wp-content/uploads/2025/04/Selo_COPv9-sem-frase.png?fit=800%2C373&ssl=1',
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 120,
                            child: Center(
                              child: Icon(Icons.error, size: 80, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'AMAZONIA EXPERIENCE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Usuários de teste
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Usuários de Teste',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _loginRapido('visitador@test.com', 'visitador'),
                              icon: const Icon(Icons.person, color: Colors.white),
                              label: const Text(
                                'Login como Visitador',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _loginRapido('responsavel@test.com', 'responsavel'),
                              icon: const Icon(Icons.business, color: Colors.white),
                              label: const Text(
                                'Login como Responsável',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Formulário manual
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Digite seu e-mail';
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'E-mail inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _senhaController,
                              obscureText: !_senhaVisivel,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(_senhaVisivel ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Digite sua senha';
                                if (value.length < 4) return 'Senha muito curta';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _carregando ? null : _fazerLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                ),
                                child: _carregando
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text('Entrar', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                              child: const Text('Não tem conta? Cadastre-se'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}