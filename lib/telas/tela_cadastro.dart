import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';
import '../utils/app_state.dart';

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

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      final usuario = Usuario(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
      );

      final id = await DatabaseHelper.instance.inserirUsuario(usuario.toMap());
      usuario.id = id;
      
      AppState.login(usuario);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail já cadastrado')),
        );
      }
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Digite seu nome';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Digite seu e-mail';
                    if (!value!.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Digite uma senha';
                    if (value!.length < 4) return 'Mínimo 4 caracteres';
                    return null;
                  },
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _cadastrar,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _carregando
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Cadastrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}