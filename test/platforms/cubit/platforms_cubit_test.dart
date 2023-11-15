import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_firebase_emulators_demo/platforms/platforms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platforms_repository/platforms_repository.dart';

class _MockPlatformsRepository extends Mock implements PlatformsRepository {}

void main() {
  group('PlatformsCubit', () {
    late PlatformsRepository platformsRepository;
    final platforms = [
      Platform(
        id: 'some-id',
        displayName: 'displayName',
        iconUrl: 'iconUrl',
        authentication: Basic(),
      ),
    ];

    setUp(() {
      platformsRepository = _MockPlatformsRepository();
    });

    test('initial state is PlatformsState.initial()', () {
      final cubit = PlatformsCubit(
        platformsRepository: platformsRepository,
      );
      expect(
        cubit.state,
        isA<PlatformsInitial>(),
      );
    });

    blocTest<PlatformsCubit, PlatformsState>(
      'emits [PlatformsLoading, PlatformsLoaded] when getPlatforms is called '
      'and repositories returns platforms',
      setUp: () {
        when(() => platformsRepository.fetchPlatforms())
            .thenAnswer((_) => Future.value(platforms));
      },
      build: () => PlatformsCubit(
        platformsRepository: platformsRepository,
      ),
      act: (cubit) => cubit.getPlatforms(),
      expect: () => [
        isA<PlatformsLoading>(),
        isA<PlatformsLoaded>().having(
          (state) => state.platforms,
          'platforms',
          equals(platforms),
        ),
      ],
    );

    blocTest<PlatformsCubit, PlatformsState>(
      'emits [PlatformsLoading, PlatformsError] when getPlatforms is called '
      'and repositories throws',
      setUp: () {
        when(() => platformsRepository.fetchPlatforms()).thenThrow(
          Exception('oops'),
        );
      },
      build: () => PlatformsCubit(
        platformsRepository: platformsRepository,
      ),
      act: (cubit) => cubit.getPlatforms(),
      expect: () => [
        isA<PlatformsLoading>(),
        isA<PlatformsError>().having(
          (state) => state.error,
          'error',
          equals('Exception: oops'),
        ),
      ],
    );
  });
}
