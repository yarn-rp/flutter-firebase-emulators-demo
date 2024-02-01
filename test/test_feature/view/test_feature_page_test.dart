import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_emulators_demo/test_feature/test_feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_repository/test_repository.dart';

import '../../helpers/pump_app.dart';

class MockTestCubit extends Mock implements TestFeatureCubit {}

void main() {
  group('TestFeatureView', () {
    late TestFeatureCubit testsCubit;

    setUp(() {
      testsCubit = MockTestCubit();
    });

    testWidgets('calls getTest when TestView is rendered', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: testsCubit,
          child: const TestView(),
        ),
      );
      verify(() => testsCubit.getTest()).called(1);
    });

    testWidgets('renders TestList with tests when state is loaded',
        (tester) async {
      when(() => testsCubit.state).thenReturn(
        TestFeatureLoaded(
          testData: const [
            TestData(
              id: 'some-id',
              name: 'name',
              description: 'description',
            ),
          ],
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: testsCubit,
          child: const TestView(),
        ),
      );
      expect(find.byType(TestList), findsOneWidget);
    });
  });
}
