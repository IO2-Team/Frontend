import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webfrontend_dionizos/main.dart' as app;
import 'package:webfrontend_dionizos/views/home/home_navigation_bar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {

    const Duration pumpDuration = Duration(milliseconds: 1000);

    testWidgets('Test Edit Pending Event', (tester) async {
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
      await tester.enterText(emailField, 'wojtek.kutak@gmail.com');
      await tester.enterText(passwordField, '12341234');
      await tester.tap(signToAppButton);
      await tester.pumpAndSettle(pumpDuration);
      expect(find.text('TestAccount'), findsOneWidget);

      // Create event
      expect(find.text('PendingTest'), findsOneWidget);
      await tester.tap(find.text('PendingTest'));
      await tester.pumpAndSettle(pumpDuration);

      expect(find.text('Enter event Title'), findsOneWidget);
      final Finder eventTitleField = find.byKey(const Key('EventTitleKey'));
      await tester.enterText(eventTitleField, 'TestowyTest');

      expect(find.text('Enter event description'), findsOneWidget);
      final Finder eventDescriptionField =
          find.byKey(const Key('EventDescriptionKey'));
      await tester.enterText(eventDescriptionField , 'TestowyTest Opis');

      expect(find.text('Enter number of places'), findsOneWidget);
      final Finder eventNumberField = find.byKey(const Key('EventNumberKey'));
      await tester.enterText(eventNumberField , '2');

      expect(find.text('Enter start date'), findsOneWidget);
      final Finder eventStartDateField =
          find.byKey(const Key('EventStartDateKey'));
      await tester.tap(eventStartDateField);
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('PM'));
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(pumpDuration);

      expect(find.text('Enter end date'), findsOneWidget);
      final Finder eventEndDateField =
          find.byKey(const Key('EventEndDateKey'));
      await tester.tap(eventEndDateField);
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('PM'));
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(pumpDuration);


      expect(find.text('Enter location'), findsOneWidget);
      final Finder eventLocationField =
          find.byKey(const Key('EventLocationKey'));
      await tester.tap(eventLocationField);
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('Set Current Location'));
      await tester.pumpAndSettle(pumpDuration);

      expect(find.text('Add new category'), findsOneWidget);
      await tester.tap(find.text('Add new category'));
      await tester.pumpAndSettle(pumpDuration);
      await tester.enterText(
          find.ancestor(
              of: find.text('category name'),
              matching: find.byType(TextFormField)),
          'testCategory');
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.byKey(const Key('CancelCategoryKey')));
      await tester.pumpAndSettle(pumpDuration);
    
      await tester.tap(find.text('Choose categories'));
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('testCategory'));
      await tester.pumpAndSettle(pumpDuration);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(pumpDuration);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle(pumpDuration);
    });
  });
}