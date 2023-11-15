import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:platforms_repository/platforms_repository.dart';

part 'platforms_state.dart';

class PlatformsCubit extends Cubit<PlatformsState> {
  PlatformsCubit({
    required PlatformsRepository platformsRepository,
  })  : _platformsRepository = platformsRepository,
        super(PlatformsInitial());

  final PlatformsRepository _platformsRepository;

  Future<void> getPlatforms() async {
    emit(PlatformsLoading());
    try {
      final platforms = await _platformsRepository.fetchPlatforms();
      emit(PlatformsLoaded(platforms: platforms));
    } on Exception catch (e) {
      emit(PlatformsError(error: e.toString()));
    }
  }
}
