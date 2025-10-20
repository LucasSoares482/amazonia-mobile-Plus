import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/error_service.dart';

class TelaErro extends StatefulWidget {
  const TelaErro({super.key, this.mensagem, this.sugestao, this.origem});

  final String? mensagem;
  final String? sugestao;
  final String? origem;

  @override
  State<TelaErro> createState() => _TelaErroState();
}

class _TelaErroState extends State<TelaErro> {
  static const _redirectDelay = Duration(seconds: 4);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_redirectDelay, _navegarParaHome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.white,
                  size: 72,
                ),
                const SizedBox(height: 24),
                Text(
                  'Por favor, nos desculpe.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Estamos com algumas instabilidades no sistema. Logo mais, voltaremos com tudo. Nos aguarde.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (widget.mensagem != null && widget.mensagem!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes técnicos',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.mensagem!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        if (widget.sugestao != null &&
                            widget.sugestao!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Sugestão automática:',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.sugestao!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  l10n.errorRedirectHint,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _navegarParaHome,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.home),
                  label: Text(l10n.errorGoHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navegarParaHome() {
    ErrorService.instance.finalizarApresentacaoErro();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }
}
