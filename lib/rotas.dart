import 'package:flutter/material.dart';
import 'telas/tela_abertura.dart';
import 'telas/tela_login.dart';
import 'telas/tela_cadastro.dart';
import 'telas/tela_home_principal.dart';
import 'telas/tela_mapa.dart';
import 'telas/tela_checkin.dart';
import 'telas/tela_historico.dart';
import 'telas/tela_chatbot.dart';
import 'telas/tela_recompensa.dart';
import 'telas/tela_carteira.dart';
import 'telas/tela_perfil.dart';
import 'telas/tela_emergencia.dart';
import 'telas/tela_criar_evento.dart';

/// Mapa de rotas nomeadas da aplicação.
final Map<String, WidgetBuilder> rotasApp = {
  '/abertura': (context) => const TelaAbertura(),
  '/login': (context) => const TelaLogin(),
  '/cadastro': (context) => const TelaCadastro(),
  '/home': (context) => const TelaHomePrincipal(),
  '/mapa': (context) => const TelaMapa(),
  '/checkin': (context) => const TelaCheckin(),
  '/historico': (context) => const TelaHistorico(),
  '/chatbot': (context) => const ChatBotScreen(),
  '/recompensas': (context) => const TelaRecompensas(),
  '/carteira': (context) => const TelaCarteira(),
  '/perfil': (context) => const TelaPerfil(),
  '/emergencia': (context) => const TelaEmergencia(),
  '/criar-evento': (context) {
    final evento =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return TelaCriarEvento(eventoParaEditar: evento);
  },
};
