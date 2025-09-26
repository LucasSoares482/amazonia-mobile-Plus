import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  // Respostas personalizadas do chatbot
  String _getBotResponse(String userMessage) {
    final lower = userMessage.toLowerCase();

    if (lower.contains("amacoins") || lower.contains("moeda")) {
      return "As AmaCoins são moedas digitais da plataforma AmazôniaExperience. Você acumula participando de eventos oficiais da COP30, visitando pontos turísticos e estabelecimentos credenciados.";
    } else if (lower.contains("como acumular") || lower.contains("ganhar")) {
      return "Você pode acumular AmaCoins ao registrar sua presença em eventos da COP30 e também visitando locais parceiros em Belém.";
    } else if (lower.contains("trocar") || lower.contains("usar")) {
      return "As AmaCoins podem ser trocadas por serviços como Uber, 99, e também em supermercados como Líder e Formosa em Belém do Pará.";
    } else if (lower.contains("cop30") || lower.contains("evento")) {
      return "A COP30 será realizada em Belém do Pará e reunirá líderes globais para discutir as mudanças climáticas e ações sustentáveis.";
    } else if (lower.contains("significado") || lower.contains("o que é cop30")) {
      return "COP30 significa 'Conference of the Parties' (Conferência das Partes). É a 30ª edição da conferência da ONU sobre mudanças climáticas.";
    } else if (lower.contains("local") || lower.contains("endereço")) {
      return "O evento principal acontece no Centro de Convenções Hangar, em Belém do Pará.";
    } else if (lower.contains("horário") || lower.contains("quando")) {
      return "A COP30 ocorrerá em novembro de 2025, entre os dias 10 e 21.";
    } else if (lower.contains("contato") || lower.contains("ajuda")) {
      return "Você pode falar com nossa equipe pelo e-mail: suporte@amazoniaexperience.com.";
    } else if (lower.contains("parceiro") || lower.contains("estabelecimento")) {
      return "Os estabelecimentos parceiros estarão listados no aplicativo AmazôniaExperience. Basta apresentar o QR Code do app para acumular AmaCoins.";
    } else if (lower.contains("turismo") || lower.contains("pontos turísticos")) {
      return "Você pode ganhar AmaCoins visitando pontos turísticos oficiais como Ver-o-Peso, Mangal das Garças, Estação das Docas e Museu Emílio Goeldi.";
    } else if (lower.contains("transporte") || lower.contains("locomoção")) {
      return "A plataforma terá integração com transporte por aplicativo (Uber e 99) e também parcerias com empresas locais de mobilidade.";
    } else if (lower.contains("sustentabilidade") || lower.contains("meio ambiente")) {
      return "A COP30 vai trazer debates sobre sustentabilidade, preservação da Amazônia e compromissos globais contra o aquecimento global.";
    } else if (lower.contains("benefícios") || lower.contains("vantagens")) {
      return "Com AmaCoins você terá vantagens como descontos exclusivos, benefícios em viagens, restaurantes, supermercados e transporte parceiro.";
    } else {
      return "Ainda não tenho essa informação 🤔. Tente perguntar sobre AmaCoins, parceiros, turismo, transporte ou a COP30.";
    }
  }

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _messages.add({"sender": "bot", "text": _getBotResponse(text)});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          "Chatbot AmazôniaExperience",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Mensagens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message["sender"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[600] : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(0),
                        bottomRight: isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Campo de digitação
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.green.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: "Digite sua dúvida...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.green[600],
                  child: IconButton(
                    icon: const Icon(Icons.chat, color: Colors.white), // <- trocado para chat
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}