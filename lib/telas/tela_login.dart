import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';
import '../utils/app_state.dart';
import '../utils/responsive.dart';

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
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade800,
              Colors.green.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: Responsive.padding(context),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxWidth(context),
                ),
                child: Card(
                  elevation: isDesktop ? 8 : 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      Responsive.isMobile(context) ? 24 : 40,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.forest,
                            size: Responsive.fontSize(context,
                              mobile: 60,
                              tablet: 80,
                              desktop: 100,
                            ),
                            color: Colors.green,
                          ),
                          SizedBox(height: isDesktop ? 24 : 16),
                          Text(
                            'Amazônia Experience',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context,
                                mobile: 24,
                                tablet: 28,
                                desktop: 32,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          SizedBox(height: isDesktop ? 40 : 32),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Digite seu e-mail';
                              if (!value!.contains('@')) return 'E-mail inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _senhaController,
                            obscureText: !_senhaVisivel,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() => _senhaVisivel = !_senhaVisivel);
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Digite sua senha';
                              if (value!.length < 4) return 'Senha muito curta';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: Responsive.isMobile(context) ? 48 : 56,
                            child: ElevatedButton(
                              onPressed: _carregando ? null : _fazerLogin,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.green,
                              ),
                              child: _carregando
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(context,
                                          mobile: 16,
                                          tablet: 18,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Não tem conta?'),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                                child: const Text('Criar conta'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info_outline, 
                                  size: 16, 
                                  color: Colors.amber.shade800,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Demo: demo@email.com / 1234',
                                  style: TextStyle(
                                    color: Colors.amber.shade800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}