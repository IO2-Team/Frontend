import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webfrontend_dionizos/main.dart' as app;

import 'tests_info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const Duration pumpDuration = Duration(milliseconds: 1000);

  testWidgets('Account page', (tester) async {
    app.main();
    await tester.pumpAndSettle(pumpDuration);

    final signInButton = find.byKey(Key('SignInPageKey'));

    await tester.tap(signInButton);
    await tester.pumpAndSettle(pumpDuration);
    expect(find.text('Enter email address'), findsOneWidget);

    final emailField = find.byKey(ValueKey('signIn_email'));
    final passwordField = find.byKey(ValueKey('signIn_password'));
    final signToAppButton = find.byKey(ValueKey('signIn_button'));

    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    await tester.tap(signToAppButton);
    await tester.pumpAndSettle(pumpDuration);
    expect(find.text(username), findsOneWidget);

    final menuButton = find.byKey(ValueKey('menuButtonKey'));
    await tester.tap(menuButton);
    await tester.pumpAndSettle(pumpDuration);

    final accountMenuButton = find.byKey(ValueKey('accountMenuButtonKey'));
    await tester.tap(accountMenuButton);
    await tester.pumpAndSettle(pumpDuration);

    expect(find.text(username), findsAtLeastNWidgets(2));

    final editButton = find.byKey(ValueKey('accountEditButtonKey'));
    await tester.tap(editButton);
    //await tester.pumpAndSettle(pumpDuration);
    await Future.delayed(pumpDuration);

    expect(find.text('Delete account'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });
}
