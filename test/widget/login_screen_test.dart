import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_amazonia/l10n/l10n.dart';
import 'package:mobile_amazonia/telas/tela_login.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _build(Widget child) => MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
  );

  testWidgets('renderiza campos de login', (tester) async {
    await tester.pumpWidget(_build(const TelaLogin(seedDemo: false)));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(2));
    final context = tester.element(find.byType(TextFormField).first);
    final l10n = AppLocalizations.of(context);
    expect(find.text(l10n.loginPrimaryButton), findsOneWidget);
  });
}
