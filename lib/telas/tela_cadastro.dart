import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../l10n/l10n.dart';
import '../models/usuario.dart';
import '../services/analytics_service.dart';
import '../services/wallet_service.dart';
import '../utils/app_state.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/primary_button.dart';
import '../utils/image_resolver.dart';

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
  final _paisController = TextEditingController();
  final _idadeController = TextEditingController();
  final _bioController = TextEditingController();
  bool _carregando = false;
  String _tipoUsuario = 'visitador';
  bool _mostrarSenha = false;
  String? _fotoPath;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreenView('signup');
  }

  Future<void> _selecionarImagem(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _fotoPath = picked.path);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Não foi possível selecionar a foto agora.'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  Future<void> _mostrarOpcoesImagem() async {
    await showModalBottomSheet<void>(
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
              const SizedBox(height: 16),
              const Text(
                'Escolha a foto do seu perfil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarImagem(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarImagem(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fotoPath == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Selecione uma foto de perfil para continuar.'),
            backgroundColor: Colors.orange,
          ),
        );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _carregando = true);

    try {
      final idadeValor = _idadeController.text.trim();
      final idade = idadeValor.isEmpty ? null : int.tryParse(idadeValor);
      final fotoParaSalvar = kIsWeb ? null : _fotoPath;
      final userData = {
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'senha': _senhaController.text.trim(),
        'tipo': _tipoUsuario,
        'amacoins': 100,
        'foto_perfil': fotoParaSalvar,
        'bio': _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        'pais': _paisController.text.trim().isEmpty
            ? null
            : _paisController.text.trim(),
        'idade': idade,
      };

      final id = await DatabaseHelper.instance.inserirUsuario(userData);
      userData['id'] = id;

      final usuario = Usuario.fromMap(userData);
      await AppState.login(usuario);
      await WalletService.instance.registrarCredito(
        userId: id,
        descricao: 'Bônus de boas-vindas',
        valor: 100,
        contexto: {'motivo': 'cadastro'},
      );
      AnalyticsService.instance.logEvent('signup_success');

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).signupSuccess),
            backgroundColor: Colors.green,
          ),
        );

      await Future.delayed(const Duration(milliseconds: 450));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      AnalyticsService.instance.logEvent(
        'signup_error',
        properties: {'motivo': e.toString()},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).signupEmailExists)),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/belem_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.78),
                      Colors.black.withOpacity(0.62),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: _carregando ? null : () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.signupTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.signupSubtitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                        const SizedBox(height: 32),
                        _buildCadastroForm(l10n),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton(
                            onPressed: _carregando
                                ? null
                                : () => Navigator.pushReplacementNamed(
                                      context,
                                      '/login',
                                    ),
                            child: Text(
                              l10n.loginTitle,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCadastroForm(AppLocalizations l10n) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: _carregando ? null : _mostrarOpcoesImagem,
              child: Stack(
                children: [
                  Builder(
                    builder: (context) {
                      final avatarProvider = resolveUserImage(_fotoPath);
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.green.shade600, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.grey.shade100,
                          backgroundImage: avatarProvider,
                          child: avatarProvider == null
                              ? Icon(
                                  Icons.person,
                                  size: 56,
                                  color: Colors.grey.shade400,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _nomeController,
            labelText: l10n.signupNameLabel,
            icon: Icons.person_outline,
            validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? l10n.signupNameError : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _emailController,
                labelText: l10n.signupEmailLabel,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return l10n.signupEmailError;
                  if (!(value!.contains('@') && value.contains('.'))) {
                    return l10n.signupEmailError;
                  }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _paisController,
            labelText: 'País de origem',
            icon: Icons.flag_outlined,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _idadeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Idade',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cake_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Bio',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_pin_circle_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _senhaController,
            obscureText: !_mostrarSenha,
            decoration: InputDecoration(
              labelText: l10n.signupPasswordLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _mostrarSenha
                        ? l10n.signupPasswordLabel
                        : l10n.signupPasswordLabel,
                    icon: Icon(
                      _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _mostrarSenha = !_mostrarSenha),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return l10n.signupPasswordError;
                  if (value!.length < 6) return l10n.signupPasswordError;
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildUserTypeSelector(l10n),
              const SizedBox(height: 24),
              PrimaryButton(
                text: l10n.signupSubmit,
                onPressed: _carregando ? null : _cadastrar,
                isLoading: _carregando,
              ),
            ],
          ),
        ),
      );

  Widget _buildUserTypeSelector(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.signupRoleTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            title: Text(l10n.signupRoleVisitorTitle),
            subtitle: Text(l10n.signupRoleVisitorSubtitle),
            value: 'visitador',
            groupValue: _tipoUsuario,
            onChanged: (value) => setState(() => _tipoUsuario = value!),
          ),
          RadioListTile<String>(
            title: Text(l10n.signupRoleResponsibleTitle),
            subtitle: Text(l10n.signupRoleResponsibleSubtitle),
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
    _paisController.dispose();
    _idadeController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
