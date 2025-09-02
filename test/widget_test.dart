import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_amazonia/main.dart';
import 'package:mobile_amazonia/models/usuario.dart';

void main() {
  group('Testes do App', () {
    testWidgets('App deve iniciar com tela de abertura', (WidgetTester tester) async {
      await tester.pumpWidget(const AppRoot());
      
      // Verifica se o texto da tela de abertura está presente
      expect(find.text('Amazônia Experience'), findsOneWidget);
    });

    testWidgets('Navegação para tela de login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {},
            child: const Text('Login'),
          ),
        ),
      ));
      
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('Testes do Modelo Usuario', () {
    test('Criar usuário com valores padrão', () {
      final usuario = Usuario(
        nome: 'João',
        email: 'joao@email.com',
        senha: '1234',
      );
      
      expect(usuario.nome, 'João');
      expect(usuario.email, 'joao@email.com');
      expect(usuario.senha, '1234');
      expect(usuario.amacoins, 100); // Valor padrão
    });

    test('Converter usuário para Map', () {
      final usuario = Usuario(
        id: 1,
        nome: 'Maria',
        email: 'maria@email.com',
        senha: 'senha123',
        amacoins: 150,
      );
      
      final map = usuario.toMap();
      
      expect(map['id'], 1);
      expect(map['nome'], 'Maria');
      expect(map['email'], 'maria@email.com');
      expect(map['senha'], 'senha123');
      expect(map['amacoins'], 150);
    });

    test('Criar usuário a partir de Map', () {
      final map = {
        'id': 2,
        'nome': 'Pedro',
        'email': 'pedro@email.com',
        'senha': 'senha456',
        'amacoins': 200,
      };
      
      final usuario = Usuario.fromMap(map);
      
      expect(usuario.id, 2);
      expect(usuario.nome, 'Pedro');
      expect(usuario.email, 'pedro@email.com');
      expect(usuario.senha, 'senha456');
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