import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/chat_message.dart';
import '../utils/app_state.dart';

/// Serviço simples que simula um chatbot Gemini e mantém histórico offline.
class ChatService {
  ChatService._internal();

  static final ChatService instance = ChatService._internal();

  static const _historyKeyPrefix = 'chat_history_';
  static const _storage = FlutterSecureStorage();

  Future<List<ChatMessage>> carregarHistorico({required String usuarioId}) async {
    final raw = await _storage.read(
      key: _storageKey(usuarioId),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => a.enviadaEm.compareTo(b.enviadaEm));
  }

  Future<void> salvarHistorico({
    required String usuarioId,
    required List<ChatMessage> mensagens,
  }) async {
    final jsonList = mensagens.map((e) => e.toJson()).toList();
    await _storage.write(
      key: _storageKey(usuarioId),
      value: jsonEncode(jsonList),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOsOptions,
      lOptions: _linuxOptions,
      webOptions: _webOptions,
    );
  }

  Future<ChatMessage> gerarResposta(String pergunta) async {
    final idioma = AppState.usuarioLogado?.tipo == 'administrador'
        ? 'pt-BR'
        : 'pt-BR'; // TODO: integrar com preferências de idioma

    await Future.delayed(const Duration(milliseconds: 800));

    final textoResposta = _construirResposta(pergunta, idioma: idioma);
    return ChatMessage.assistente(textoResposta);
  }

  String _storageKey(String usuarioId) => '$_historyKeyPrefix$usuarioId';

  String _construirResposta(String pergunta, {required String idioma}) {
    final normalized = pergunta.toLowerCase();
    if (normalized.contains('ola') || normalized.contains('olá')) {
      return 'Olá! Como posso ajudar na sua experiência em Belém e na COP30 hoje?';
    }
    if (normalized.contains('amacoins')) {
      return 'AmaCoins são a moeda verde do aplicativo. Você ganha 100 ao criar sua conta, +50 nos eventos oficiais e +30 nos pontos turísticos credenciados.';
    }
    if (normalized.contains('transporte')) {
      return 'Para se locomover, recomendamos usar os atalhos dos cards para abrir direto o Uber ou 99 com o destino configurado. Além disso, ônibus elétricos estarão disponíveis nos polos da COP30.';
    }
    if (normalized.contains('cop30')) {
      return 'A COP30 acontece em Belém em 2025 e reúne líderes para discutir o futuro climático. Confira a agenda na Home para saber horários e locais.';
    }
    if (normalized.contains('clima') || normalized.contains('temperatura')) {
      return 'Belém costuma ter clima quente e úmido, com média de 30ºC. Leve roupas leves, protetor solar e mantenha-se hidratado.';
    }

    return 'Entendi sua pergunta, mas ainda estou aprendendo. Posso ajudar com dicas de pontos turísticos, agenda da COP30, transporte sustentável e uso dos AmaCoins. Em breve, integraremos o Gemini para respostas ainda mais completas!';
  }

  static const AndroidOptions _androidOptions =
      AndroidOptions(encryptedSharedPreferences: true);
  static const IOSOptions _iosOptions =
      IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  static const MacOsOptions _macOsOptions = MacOsOptions();
  static const LinuxOptions _linuxOptions = LinuxOptions();
  static const WebOptions _webOptions = WebOptions();
}
