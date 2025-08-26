import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
// Ajuste o caminho conforme seu projeto:
import 'package:mobile_amazonia/telas/tela_login.dart';

void main() {
  testWidgets('renderiza campos de login', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TelaLogin()));
    expect(find.byType(TextField), findsNWidgets(2)); // email + senha
    expect(find.textContaining('Entrar'), findsOneWidget);
  });
}
