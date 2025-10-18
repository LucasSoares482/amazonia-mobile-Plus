import 'package:flutter/material.dart';
import 'telas/tela_abertura.dart';
import 'telas/tela_login.dart';
import 'telas/tela_cadastro.dart';
import 'telas/tela_home_principal.dart';
import 'telas/tela_mapa.dart';
import 'telas/tela_checkin.dart';
import 'telas/tela_historico.dart';
import 'telas/tela_carteira.dart';
import 'telas/tela_perfil.dart';
import 'telas/tela_emergencia.dart';
import 'telas/tela_criar_evento.dart';
import 'telas/tela_recuperar_senha.dart';
import 'telas/tela_chat.dart';
import 'telas/admin/tela_admin_usuarios.dart';
import 'telas/admin/tela_admin_pontos.dart';
import 'telas/admin/tela_admin_estatisticas.dart';
import 'telas/tela_erro.dart';
import 'telas/tela_cop30_detalhes.dart';
import 'telas/tela_sabores.dart';

/// Mapa de rotas nomeadas da aplicação.
final Map<String, WidgetBuilder> rotasApp = {
  '/abertura': (context) => const TelaAbertura(),
  '/login': (context) => const TelaLogin(),
  '/cadastro': (context) => const TelaCadastro(),
  '/home': (context) => const TelaHomePrincipal(),
  '/mapa': (context) => const TelaMapa(),
  '/checkin': (context) => const TelaCheckin(),
  '/historico': (context) => const TelaHistorico(),
  '/carteira': (context) => const TelaCarteira(),
  '/perfil': (context) => const TelaPerfil(),
  '/emergencia': (context) => const TelaEmergencia(),
  '/recuperar-senha': (context) => const TelaRecuperarSenha(),
  '/chat': (context) => const TelaChat(),
  '/admin/usuarios': (context) => const TelaAdminUsuarios(),
  '/admin/pontos': (context) => const TelaAdminPontos(),
  '/admin/estatisticas': (context) => const TelaAdminEstatisticas(),
  '/erro': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return TelaErro(
      mensagem: args?['mensagem']?.toString(),
      sugestao: args?['sugestao']?.toString(),
      origem: args?['origem']?.toString(),
    );
  },
  '/cop30': (context) => const TelaCop30Detalhes(),
  '/sabores': (context) => const TelaSabores(),
  '/criar-evento': (context) {
    final evento = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return TelaCriarEvento(eventoParaEditar: evento);
  },
};
