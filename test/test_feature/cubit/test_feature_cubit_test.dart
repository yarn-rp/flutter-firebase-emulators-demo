import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_firebase_emulators_demo/test_feature/test_feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_repository/test_repository.dart';

class _MockTestRepository extends Mock implements TestRepository {}

void main() {
  group('TestCubit', () {
    late TestRepository testsRepository;
    final tests = [
      const TestData(
        id: 'some-id',
        name: 'name',
        description: 'description',
      ),
    ];

    setUp(() {
      testsRepository = _MockTestRepository();
    });

    test('initial state is TestState.initial()', () {
      final cubit = TestFeatureCubit(
        testsRepository: testsRepository,
      );
      expect(
        cubit.state,
        isA<TestFeatureInitial>(),
      );
    });

    blocTest<TestFeatureCubit, TestFeatureState>(
      'emits [TestFeatureLoading, TestFeatureLoaded] when getTest is called '
      'and repositories returns tests',
      setUp: () {
        when(() => testsRepository.fetchTest())
            .thenAnswer((_) => Future.value(tests));
      },
      build: () => TestFeatureCubit(
        testsRepository: testsRepository,
      ),
      act: (cubit) => cubit.getTest(),
      expect: () => [
        isA<TestFeatureLoading>(),
        isA<TestFeatureLoaded>().having(
          (state) => state.testData,
          'tests',
          equals(tests),
        ),
      ],
    );

    blocTest<TestFeatureCubit, TestFeatureState>(
      'emits [TestFeatureLoading, TestFeatureError] when getTest is called '
      'and repositories throws',
      setUp: () {
        when(() => testsRepository.fetchTest()).thenThrow(
          Exception('oops'),
        );
      },
      build: () => TestFeatureCubit(
        testsRepository: testsRepository,
      ),
      act: (cubit) => cubit.getTest(),
      expect: () => [
        isA<TestFeatureLoading>(),
        isA<TestFeatureError>().having(
          (state) => state.error,
          'error',
          equals('Exception: oops'),
        ),
      ],
    );
  });
}
