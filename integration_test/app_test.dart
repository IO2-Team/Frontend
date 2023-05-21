import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webfrontend_dionizos/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Test if launch properly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome'), findsOneWidget);
    });

    testWidgets('Test if launch properly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('Test SignIn', (tester) async {
      app.main();
      final Finder signInButton = find.descendant(
          of: find.text('Sign In'), matching: find.byType(ElevatedButton));
      //final signInButton = find.byKey(ValueKey('SignInPageKey'));
      await tester.tap(signInButton);
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
      expect(find.text('Enter email address'), findsOneWidget);
      final emailField = find.byKey(ValueKey('signIn_email'));
      final passwordField = find.byKey(ValueKey('signIn_password'));
      final signToAppButton = find.byKey(ValueKey('signIn_button'));

      await tester.enterText(emailField, 'test@test.pl');
      await tester.enterText(passwordField, '12341234');
      await tester.tap(signToAppButton);
      await tester.pumpAndSettle();
      expect(find.text('Test Dionizos'), findsOneWidget);
    });
  });
}
