import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webfrontend_dionizos/main.dart' as app;
import 'package:webfrontend_dionizos/views/home/home_navigation_bar.dart';

import 'tests_info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    const Duration pumpDuration = Duration(milliseconds: 1000);

    testWidgets('Test Cancel Event', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // SIGN IN
      final Finder signInButton = find.ancestor(
          of: find.text('Sign In'), matching: find.byType(HighlightButton));
      await tester.tap(signInButton);
      await tester.pumpAndSettle(pumpDuration);
      expect(find.text('Enter email address'), findsOneWidget);

      final emailField = find.byKey(const ValueKey('signIn_email'));
      final passwordField = find.byKey(const ValueKey('signIn_password'));
      final signToAppButton = find.byKey(const ValueKey('signIn_button'));
      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.tap(signToAppButton);
      await tester.pumpAndSettle(pumpDuration);
      expect(find.text(username), findsOneWidget);

      // Create event
      await tester.tap(find.text(infutureEventName));
      await tester.pumpAndSettle(pumpDuration);

      expect(find.text('Enter event description'), findsOneWidget);
      final Finder eventDescriptionField =
          find.byKey(const Key('EventDescriptionKey'));
      await tester.enterText(eventDescriptionField, 'Cancelable description');
      await tester.pumpAndSettle(pumpDuration);

      await tester.tap(find.text('Cancel event'));
      await tester.pumpAndSettle(pumpDuration);
    });
  });
}
