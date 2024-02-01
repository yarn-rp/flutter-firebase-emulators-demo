import 'package:flutter_firebase_emulators_demo/app/app.dart';
import 'package:flutter_firebase_emulators_demo/test_feature/test_feature.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders TestFeaturePage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(TestFeaturePage), findsOneWidget);
    });
  });
}
