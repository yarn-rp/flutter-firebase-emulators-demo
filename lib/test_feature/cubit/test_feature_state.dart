part of 'test_feature_cubit.dart';

@immutable
sealed class TestFeatureState {}

final class TestFeatureInitial extends TestFeatureState {}

final class TestFeatureLoading extends TestFeatureState {}

final class TestFeatureLoaded extends TestFeatureState {
  TestFeatureLoaded({required this.testData});

  final List<TestData> testData;
}

final class TestFeatureError extends TestFeatureState {
  TestFeatureError({
    required this.error,
  });

  final String error;
}
