import 'dart:async';

import 'package:flutter/material.dart';

import '../core/security/login_rate_limiter.dart';
import '../database/database_helper.dart';
import '../l10n/l10n.dart';
import '../models/usuario.dart';
import '../services/analytics_service.dart';
import '../utils/app_state.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/primary_button.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key, this.seedDemo = true});

  final bool seedDemo;

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;
  bool _mostrarSenha = false;

  @override
  void initState() {
    super.initState();
    if (widget.seedDemo) {
      unawaited(_inicializarUsuariosDemo());
    }
    AnalyticsService.instance.logScreenView('login');
  }

  Future<void> _inicializarUsuariosDemo() =>
      DatabaseHelper.instance.seedDemoData();

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    final lockInfo = await LoginRateLimiter.checkLock(email);
    if (lockInfo != null) {
      AnalyticsService.instance.logEvent(
        'login_error',
        properties: {'motivo': 'tentativas_excedidas'},
      );
      _mostrarSnackBar(AppLocalizations.of(context).loginAttemptsExceeded);
      return;
    }

    setState(() => _carregando = true);
    try {
      final resultado = await DatabaseHelper.instance.loginUsuario(email, senha);
      if (resultado != null) {
        await LoginRateLimiter.registerSuccess(email);
        await AppState.login(Usuario.fromMap(resultado));

        AnalyticsService.instance.logEvent('login_success');
        if (!mounted) return;
        _mostrarSnackBar(
          AppLocalizations.of(context).loginSuccess,
          background: Colors.green.shade600,
        );
        await Future.delayed(const Duration(milliseconds: 450));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        final tentativasRestantes =
            await LoginRateLimiter.registerFailure(email);
        if (!mounted) return;
        if (tentativasRestantes == 0) {
          AnalyticsService.instance.logEvent(
            'login_error',
            properties: {'motivo': 'tentativas_excedidas'},
          );
          _mostrarSnackBar(AppLocalizations.of(context).loginAttemptsExceeded);
        } else {
          AnalyticsService.instance.logEvent(
            'login_error',
            properties: {'motivo': 'credenciais_invalidas'},
          );
          _mostrarSnackBar(
            AppLocalizations.of(context)
                .loginRemainingAttempts(tentativasRestantes),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarSnackBar(
    String message, {
    Color? background,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: background,
      ),
    );
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
                      Colors.black.withOpacity(0.75),
                      Colors.black.withOpacity(0.65),
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
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.travel_explore,
                          size: 72,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.appTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.loginSubtitle,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                        const SizedBox(height: 32),
                        _buildLoginForm(l10n),
                        const SizedBox(height: 24),
                        _buildActionsRow(l10n),
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

  Widget _buildLoginForm(AppLocalizations l10n) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _emailController,
                labelText: l10n.loginEmailLabel,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return l10n.loginEmailError;
                  }
                  if (!(value!.contains('@') && value.contains('.'))) {
                    return l10n.loginEmailError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                obscureText: !_mostrarSenha,
                decoration: InputDecoration(
                  labelText: l10n.loginPasswordLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _mostrarSenha
                        ? l10n.loginPasswordLabel
                        : l10n.loginPasswordLabel,
                    icon: Icon(
                      _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _mostrarSenha = !_mostrarSenha),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return l10n.loginPasswordError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: l10n.loginPrimaryButton,
                onPressed: _carregando ? null : _fazerLogin,
                isLoading: _carregando,
              ),
            ],
          ),
        ),
      );

  Widget _buildActionsRow(AppLocalizations l10n) => Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 160,
            child: TextButton(
              onPressed: _carregando
                  ? null
                  : () => Navigator.pushNamed(context, '/cadastro'),
              child: Text(
                l10n.loginSignupLink,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: TextButton(
              onPressed: _carregando
                  ? null
                  : () => Navigator.pushNamed(context, '/recuperar-senha'),
              child: Text(
                l10n.loginForgotPassword,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );

}
