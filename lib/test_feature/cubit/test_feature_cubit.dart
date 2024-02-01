import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_repository/test_repository.dart';

part 'test_feature_state.dart';

class TestFeatureCubit extends Cubit<TestFeatureState> {
  TestFeatureCubit({
    required TestRepository testsRepository,
  })  : _testsRepository = testsRepository,
        super(TestFeatureInitial());

  final TestRepository _testsRepository;

  Future<void> getTest() async {
    emit(TestFeatureLoading());
    try {
      final tests = await _testsRepository.fetchTest();
      emit(TestFeatureLoaded(testData: tests));
    } on Exception catch (e) {
      emit(TestFeatureError(error: e.toString()));
    }
  }
}
