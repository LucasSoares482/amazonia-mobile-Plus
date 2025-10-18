import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_amazonia/l10n/l10n.dart';
import 'package:mobile_amazonia/models/usuario.dart';
import 'package:mobile_amazonia/telas/tela_abertura.dart';
import 'package:mobile_amazonia/telas/tela_login.dart';
import 'package:mobile_amazonia/utils/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Widget _testApp(Widget child) => MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: {
          '/login': (_) => const Scaffold(body: Text('Tela Login Mock')),
          '/home': (_) => const Scaffold(body: Text('Tela Home Mock')),
        },
        home: child,
      );

  group('Testes do App', () {
    testWidgets('App deve iniciar com tela de abertura', (WidgetTester tester) async {
      AppState.usuarioLogado = null;
      await tester.pumpWidget(_testApp(const TelaAbertura()));
      await tester.pump(); // primeira frame da animação
      expect(find.text('Amazonia Experience'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('Navegação para tela de login', (WidgetTester tester) async {
      await tester.pumpWidget(_testApp(const TelaLogin(seedDemo: false)));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
      final context =
          tester.element(find.byType(TextFormField).first);
      final l10n = AppLocalizations.of(context);
      expect(find.text(l10n.loginPrimaryButton), findsOneWidget);
    });
  });

  group('Testes do Modelo Usuario', () {
    test('Criar usuário com valores padrão', () {
      final usuario = Usuario(
        nome: 'João',
        email: 'joao@email.com',
        senha: '1234',
        tipo: 'visitador', // ADICIONADO - parâmetro obrigatório
      );
      
      expect(usuario.nome, 'João');
      expect(usuario.email, 'joao@email.com');
      expect(usuario.senha, '1234');
      expect(usuario.tipo, 'visitador'); // ADICIONADO - verificar tipo
      expect(usuario.amacoins, 0); // CORRIGIDO - valor padrão é 0, não 100
    });

    test('Converter usuário para Map', () {
      final usuario = Usuario(
        id: '1',
        nome: 'Maria',
        email: 'maria@email.com',
        senha: 'senha123',
        tipo: 'visitador', // ADICIONADO - parâmetro obrigatório
        amacoins: 150,
      );
      
      final map = usuario.toMap();
      
      expect(map['id'], '1');
      expect(map['nome'], 'Maria');
      expect(map['email'], 'maria@email.com');
      expect(map['senha'], 'senha123');
      expect(map['tipo'], 'visitador'); // ADICIONADO - verificar tipo no map
      expect(map['amacoins'], 150);
    });

    test('Criar usuário a partir de Map', () {
      final map = {
        'id': '2',
        'nome': 'Pedro',
        'email': 'pedro@email.com',
        'senha': 'senha456',
        'tipo': 'responsavel', // ADICIONADO - parâmetro obrigatório
        'amacoins': 200,
      };
      
      final usuario = Usuario.fromMap(map);
      
      expect(usuario.id, '2');
      expect(usuario.nome, 'Pedro');
      expect(usuario.email, 'pedro@email.com');
      expect(usuario.senha, 'senha456');
      expect(usuario.tipo, 'responsavel'); // ADICIONADO - verificar tipo
      expect(usuario.amacoins, 200);
    });
  });

  group('Testes de Validação', () {
    test('Email deve conter @', () {
      final emailValido = 'teste@email.com';
      final emailInvalido = 'testeemail.com';
      
      expect(emailValido.contains('@'), true);
      expect(emailInvalido.contains('@'), false);
    });

    test('Senha deve ter no mínimo 4 caracteres', () {
      final senhaValida = '1234';
      final senhaInvalida = '123';
      
      expect(senhaValida.length >= 4, true);
      expect(senhaInvalida.length >= 4, false);
    });
  });
}
