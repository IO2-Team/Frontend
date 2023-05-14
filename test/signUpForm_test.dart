import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test/test.dart' as test;
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/views/signUp/signup_view.dart';
import 'package:webfrontend_dionizos/views/signUp/singUp_form.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';

void main() {
  testWidgets('singup_noEmptyFields', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    final userNameField = find.byKey(ValueKey('signUp_username'));
    final emailField = find.byKey(ValueKey('signUp_email'));
    final passwordField = find.byKey(ValueKey('signUp_password'));
    final passwordConfirmField = find.byKey(ValueKey('signUp_passwordConfirm'));
    final signUpButton = find.byKey(ValueKey('signUp_button'));

    final textFinderUserName = find.text('Please enter your username');
    final validationMessageFinderUserName =
        find.descendant(of: userNameField, matching: textFinderUserName);

    final textFinderEmail = find.text('Please enter your email address');
    final validationMessageFinderEmail =
        find.descendant(of: emailField, matching: textFinderEmail);

    final textFinderPassword = find.text('Please enter your password');
    final validationMessageFinderPassword =
        find.descendant(of: passwordField, matching: textFinderPassword);

    final textFinderPasswordConfirm = find.text('Please enter your password');
    final validationMessageFinderPasswordConfirm = find.descendant(
        of: passwordConfirmField, matching: textFinderPasswordConfirm);

    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (_) => OrganizerController()),
        ],
            child: Builder(
                builder: (_) => Scaffold(
                    body: CenteredView(
                        child: Column(children: [SignUpForm()])))))));
    await tester.tap(signUpButton);
    await tester.pump();

    expect(validationMessageFinderUserName, findsOneWidget);
    expect(validationMessageFinderEmail, findsOneWidget);
    expect(validationMessageFinderPassword, findsOneWidget);
    expect(validationMessageFinderPasswordConfirm, findsOneWidget);
  });

  testWidgets('signUp_validEmail', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    final emailField = find.byKey(ValueKey('signUp_email'));
    final signUpButton = find.byKey(ValueKey('signUp_button'));

    final textFinder = find.text('Email is incorrect');
    final validationMessageFinder =
        find.descendant(of: emailField, matching: textFinder);

    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (_) => OrganizerController()),
        ],
            child: Builder(
                builder: (_) => Scaffold(
                    body: CenteredView(
                        child: Column(children: [SignUpForm()])))))));
    await tester.enterText(emailField, 'testtest.pl');
    await tester.tap(signUpButton);
    await tester.pump();

    expect(validationMessageFinder, findsOneWidget);
  });

  testWidgets('signUp_passwordLongerThan8', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    final passwordField = find.byKey(ValueKey('signUp_password'));
    final signUpButton = find.byKey(ValueKey('signUp_button'));

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
                        child: Column(children: [SignUpForm()])))))));
    await tester.enterText(passwordField, '1234567');
    await tester.tap(signUpButton);
    await tester.pump();

    expect(validationMessageFinder, findsOneWidget);
  });

  testWidgets('signUp_passwordMatching', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    final passwordField = find.byKey(ValueKey('signUp_password'));
    final passwordConfirmField = find.byKey(ValueKey('signUp_passwordConfirm'));
    final signUpButton = find.byKey(ValueKey('signUp_button'));

    final textFinder = find.text('Password not matching');
    final validationMessageFinder =
        find.descendant(of: passwordConfirmField, matching: textFinder);

    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (_) => OrganizerController()),
        ],
            child: Builder(
                builder: (_) => Scaffold(
                    body: CenteredView(
                        child: Column(children: [SignUpForm()])))))));
    await tester.enterText(passwordField, 'password');
    await tester.enterText(passwordConfirmField, 'passwordd');
    await tester.tap(signUpButton);
    await tester.pump();

    expect(validationMessageFinder, findsOneWidget);
  });
}
