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
  });
}
