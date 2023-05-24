import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/views/signIn/singIn_form.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';

void main() {
  testWidgets('singIn_noEmptyFields', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    final emailField = find.byKey(ValueKey('signIn_email'));
    final passwordField = find.byKey(ValueKey('signIn_password'));
    final signInButton = find.byKey(ValueKey('signIn_button'));

    final textFinderEmail = find.text('Please enter your email');
    final validationMessageFinderEmail =
        find.descendant(of: emailField, matching: textFinderEmail);

    final textFinderPassword = find.text('Please enter your password');
    final validationMessageFinderPassword =
        find.descendant(of: passwordField, matching: textFinderPassword);

    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (_) => OrganizerController()),
        ],
            child: Builder(
                builder: (_) => Scaffold(
                    body: CenteredView(
                        child: Column(children: [SignInForm()])))))));
    await tester.tap(signInButton);
    await tester.pump();

    expect(validationMessageFinderEmail, findsOneWidget);
    expect(validationMessageFinderPassword, findsOneWidget);
  });

  testWidgets('signIn_passwordLongerThan8', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    final passwordField = find.byKey(ValueKey('signIn_password'));
    final signInButton = find.byKey(ValueKey('signIn_button'));

    final textFinder =
        find.text('Password have to be at least 8 characters long');
    final validationMessageFinder =
        find.descendant(of: passwordField, matching: textFinder);

    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (_) => OrganizerController()),
        ],
            child: Builder(
                builder: (_) => Scaffold(
                    body: CenteredView(
                        child: Column(children: [SignInForm()])))))));
    await tester.enterText(passwordField, '1234567');
    await tester.tap(signInButton);
    await tester.pump();

    expect(validationMessageFinder, findsOneWidget);
  });
}
