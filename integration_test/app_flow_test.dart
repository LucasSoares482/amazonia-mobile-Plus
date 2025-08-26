import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_amazonia/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fluxo básico: abre app e carrega splash', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    // Aqui você pode validar elementos da sua TelaAbertura
    // Ex.: expect(find.text('Bem-vindo'), findsOneWidget);
  });
}
