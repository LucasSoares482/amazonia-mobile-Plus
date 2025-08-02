import 'package:flutter/material.dart';
import 'telas/tela_abertura.dart';
import 'telas/tela_login.dart';
import 'telas/tela_cadastro.dart';
import 'telas/tela_home.dart';
import 'telas/tela_mapa.dart';
import 'telas/tela_checkin.dart';
import 'telas/tela_eventos.dart';
import 'telas/tela_quiz.dart';
import 'telas/tela_chatbot.dart';
import 'telas/tela_carteira.dart';
import 'telas/tela_perfil.dart';
import 'telas/tela_historico.dart';

final Map<String, WidgetBuilder> rotasApp = {
  '/abertura': (context) => TelaAbertura(),
  '/login': (context) => TelaLogin(),
  '/cadastro': (context) => TelaCadastro(),
  '/home': (context) => TelaHome(),
  '/mapa': (context) => TelaMapa(),
  '/checkin': (context) => TelaCheckin(),
  '/eventos': (context) => TelaEventos(),
  '/quiz': (context) => TelaQuiz(),
  '/chatbot': (context) => TelaChatbot(),
  '/carteira': (context) => TelaCarteira(),
  '/perfil': (context) => TelaPerfil(),
  '/historico': (context) => TelaHistorico(),
};