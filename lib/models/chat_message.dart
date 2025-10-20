import 'package:uuid/uuid.dart';

/// Representa uma mensagem trocada com o chatbot.
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.remetente,
    required this.texto,
    required this.enviadaEm,
    this.status = ChatMessageStatus.entregue,
  });

  ChatMessage.usuario(String texto)
      : this(
          id: const Uuid().v4(),
          remetente: ChatSender.usuario,
          texto: texto,
          enviadaEm: DateTime.now(),
          status: ChatMessageStatus.emFila,
        );

  ChatMessage.assistente(String texto)
      : this(
          id: const Uuid().v4(),
          remetente: ChatSender.assistente,
          texto: texto,
          enviadaEm: DateTime.now(),
        );

  final String id;
  final ChatSender remetente;
  final String texto;
  final DateTime enviadaEm;
  final ChatMessageStatus status;

  bool get isUsuario => remetente == ChatSender.usuario;
  bool get isAssistente => remetente == ChatSender.assistente;
  bool get isPendente => status == ChatMessageStatus.emFila;
  bool get isErro => status == ChatMessageStatus.erro;

  ChatMessage copyWith({
    String? texto,
    ChatMessageStatus? status,
    DateTime? enviadaEm,
  }) =>
      ChatMessage(
        id: id,
        remetente: remetente,
        texto: texto ?? this.texto,
        enviadaEm: enviadaEm ?? this.enviadaEm,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'remetente': remetente.name,
        'texto': texto,
        'enviadaEm': enviadaEm.toIso8601String(),
        'status': status.name,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final enviadaEmRaw = json['enviadaEm'] as String?;
    final enviadaEmParsed = DateTime.tryParse(enviadaEmRaw ?? '');

    return ChatMessage(
      id: (json['id'] ?? const Uuid().v4()).toString(),
      remetente: _parseSender(json['remetente']),
      texto: (json['texto'] ?? '').toString(),
      enviadaEm: enviadaEmParsed ?? DateTime.now(),
      status: _parseStatus(json['status']),
    );
  }

  static ChatSender _parseSender(dynamic value) {
    final name = value?.toString();
    return ChatSender.values.firstWhere(
      (candidate) => candidate.name == name,
      orElse: () => ChatSender.assistente,
    );
  }

  static ChatMessageStatus _parseStatus(dynamic value) {
    final name = value?.toString();
    return ChatMessageStatus.values.firstWhere(
      (candidate) => candidate.name == name,
      orElse: () => ChatMessageStatus.entregue,
    );
  }
}

enum ChatSender { usuario, assistente }

enum ChatMessageStatus { emFila, entregue, erro }
