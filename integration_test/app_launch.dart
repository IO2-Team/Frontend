import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webfrontend_dionizos/main.dart' as app;
import 'package:webfrontend_dionizos/views/home/home_navigation_bar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    const Duration pumpDuration = Duration(milliseconds: 1000);

    testWidgets('Test launch app', (tester) async {
      app.main();
      await tester.pumpAndSettle(pumpDuration);

      expect(find.textContaining('Welcome'), findsOneWidget);
    });
  });
}
