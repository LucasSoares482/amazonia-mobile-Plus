import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/chat_message.dart';
import '../services/analytics_service.dart';
import '../services/chat_service.dart';
import '../utils/app_state.dart';

class TelaChat extends StatefulWidget {
  const TelaChat({super.key});

  @override
  State<TelaChat> createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
  final _mensagens = <ChatMessage>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
    AnalyticsService.instance
      ..logScreenView('chat')
      ..logEvent('chat_open');
  }

  Future<void> _carregarHistorico() async {
    final usuarioId = AppState.usuarioLogado?.id;
    if (usuarioId == null) return;
    final historico =
        await ChatService.instance.carregarHistorico(usuarioId: usuarioId);
    if (!mounted) return;
    setState(() => _mensagens.addAll(historico));
    _scrollAteFinal();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          title: Text(AppLocalizations.of(context).drawerChat),
        ),
        body: Column(
          children: [
            Expanded(child: _buildMensagens()),
            _buildComposer(),
          ],
        ),
      );

  Widget _buildMensagens() => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _mensagens.length,
        itemBuilder: (context, index) {
          final mensagem = _mensagens[index];
          final isUsuario = mensagem.remetente == ChatSender.usuario;
          final alinhamento =
              isUsuario ? CrossAxisAlignment.end : CrossAxisAlignment.start;
          final cor = isUsuario ? Colors.green.shade600 : Colors.grey.shade200;
          final textoCor = isUsuario ? Colors.white : Colors.grey.shade900;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: alinhamento,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUsuario ? 18 : 4),
                      bottomRight: Radius.circular(isUsuario ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(
                    mensagem.texto,
                    style: TextStyle(
                      color: textoCor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatarData(mensagem.enviadaEm),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                if (isUsuario) ...[
                  const SizedBox(height: 2),
                  _buildMensagemStatus(mensagem),
                ],
              ],
            ),
          );
        },
      );

  Widget _buildComposer() => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).chatPlaceholder,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _enviarMensagem(),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.green.shade600,
                child: IconButton(
                  onPressed: _enviando ? null : _enviarMensagem,
                  icon: _enviando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _enviarMensagem() async {
    await _enviarMensagemInterno();
  }

  Future<void> _enviarMensagemInterno({
    ChatMessage? reenvio,
    String? textoManual,
  }) async {
    final texto = (textoManual ?? reenvio?.texto ?? _controller.text).trim();
    if (texto.isEmpty || _enviando) return;
    final usuarioId = AppState.usuarioLogado?.id;
    if (usuarioId == null) return;

    final mensagemUsuario = reenvio?.copyWith(
          texto: texto,
          status: ChatMessageStatus.emFila,
          enviadaEm: DateTime.now(),
        ) ??
        ChatMessage.usuario(texto);
    setState(() {
      final idx = _mensagens.indexWhere((m) => m.id == mensagemUsuario.id);
      if (idx != -1) {
        _mensagens[idx] = mensagemUsuario;
      } else {
        _mensagens.add(mensagemUsuario);
      }
      _enviando = true;
      if (reenvio == null) {
        _controller.clear();
      }
    });
    AnalyticsService.instance.logEvent(
      reenvio == null ? 'chat_message_sent' : 'chat_message_retry',
    );
    _scrollAteFinal();

    try {
      await ChatService.instance.salvarHistorico(
        usuarioId: usuarioId,
        mensagens: _mensagens,
      );

      final resposta =
          await ChatService.instance.gerarResposta(mensagemUsuario.texto);
      if (!mounted) return;
      setState(() {
        final idx = _mensagens.indexWhere((m) => m.id == mensagemUsuario.id);
        if (idx != -1) {
          _mensagens[idx] =
              mensagemUsuario.copyWith(status: ChatMessageStatus.entregue);
        }
        _mensagens.add(resposta);
      });

      await ChatService.instance.salvarHistorico(
        usuarioId: usuarioId,
        mensagens: _mensagens,
      );
      AnalyticsService.instance.logEvent('chat_message_answered');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        final idx = _mensagens.indexWhere((m) => m.id == mensagemUsuario.id);
        if (idx != -1) {
          _mensagens[idx] =
              mensagemUsuario.copyWith(status: ChatMessageStatus.erro);
        }
      });
      await ChatService.instance.salvarHistorico(
        usuarioId: usuarioId,
        mensagens: _mensagens,
      );
      AnalyticsService.instance.logEvent('chat_message_error');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).chatSendError),
            backgroundColor: Colors.red.shade600,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
        _scrollAteFinal();
      }
    }
  }

  void _scrollAteFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatarData(DateTime data) =>
      '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';

  Widget _buildMensagemStatus(ChatMessage mensagem) {
    final l10n = AppLocalizations.of(context);
    IconData icon;
    Color color;
    String label;
    final bool podeReenviar = mensagem.status == ChatMessageStatus.erro;

    switch (mensagem.status) {
      case ChatMessageStatus.emFila:
        icon = Icons.schedule;
        color = Colors.white70;
        label = l10n.chatStatusSending;
        break;
      case ChatMessageStatus.entregue:
        icon = Icons.check_circle_outline;
        color = Colors.white70;
        label = l10n.chatStatusDelivered;
        break;
      case ChatMessageStatus.erro:
        icon = Icons.error_outline;
        color = Colors.red.shade200;
        label = l10n.chatStatusError;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
          ),
        ),
        if (podeReenviar) ...[
          const SizedBox(width: 8),
          TextButton(
            onPressed: _enviando ? null : () => _reenviarMensagem(mensagem),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: Colors.red.shade200,
            ),
            child: Text(
              l10n.chatActionRetry,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _reenviarMensagem(ChatMessage mensagem) async {
    await _enviarMensagemInterno(reenvio: mensagem);
  }
}
