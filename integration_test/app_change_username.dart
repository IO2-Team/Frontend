import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webfrontend_dionizos/main.dart' as app;

import 'tests_info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const Duration pumpDuration = Duration(milliseconds: 1000);

  testWidgets('Edit Accout Username', (tester) async {
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

    final editButton = find.byKey(ValueKey('accountEditButtonKey'));
    await tester.tap(editButton);
    await tester.pumpAndSettle(pumpDuration);

    final userNameTextField = find.byKey(ValueKey('accountEditUsernameKey'));
    await tester.enterText(userNameTextField, 'Username changed');
    final saveChangesButton =
        find.byKey(ValueKey('accountSaveChangesButtonKey'));
    await tester.tap(saveChangesButton);
    await tester.pumpAndSettle(pumpDuration);
    expect(find.text('Username changed'), findsAtLeastNWidgets(1));

    final editButton2 = find.byKey(ValueKey('accountEditButtonKey'));
    await tester.tap(editButton2);
    await tester.pumpAndSettle(pumpDuration);

    final userNameTextField2 = find.byKey(ValueKey('accountEditUsernameKey'));
    await tester.enterText(userNameTextField2, username);
    final saveChangesButton2 =
        find.byKey(ValueKey('accountSaveChangesButtonKey'));
    await tester.tap(saveChangesButton2);
    await tester.pumpAndSettle(pumpDuration);
    expect(find.text(username), findsAtLeastNWidgets(1));
  });
}
