import 'package:flutter/material.dart';
import 'telas/tela_abertura.dart';
import 'telas/tela_login.dart';
import 'telas/tela_cadastro.dart';
import 'telas/tela_checkin.dart';
import 'telas/tela_historico.dart';
import 'telas/telas_simples.dart';

final Map<String, WidgetBuilder> rotasApp = {
  '/abertura': (context) => const TelaAbertura(),
  '/login': (context) => const TelaLogin(),
  '/cadastro': (context) => const TelaCadastro(),
  '/home': (context) => const TelaHome(),
  '/mapa': (context) => const TelaMapa(),
  '/checkin': (context) => const TelaCheckin(),
  '/eventos': (context) => const TelaEventos(),
  '/quiz': (context) => const TelaQuiz(),
  '/chatbot': (context) => const TelaChatbot(),
  '/carteira': (context) => const TelaCarteira(),
  '/perfil': (context) => const TelaPerfil(),
  '/historico': (context) => const TelaHistorico(),
};