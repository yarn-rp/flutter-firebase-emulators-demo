import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_emulators_demo/platforms/platforms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platforms_repository/platforms_repository.dart';

import '../../helpers/pump_app.dart';

class MockPlatformsCubit extends Mock implements PlatformsCubit {}

void main() {
  group('PlatformsView', () {
    late PlatformsCubit platformsCubit;

    setUp(() {
      platformsCubit = MockPlatformsCubit();
    });

    testWidgets('calls getPlatforms when PlatformsView is rendered',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: platformsCubit,
          child: const PlatformsView(),
        ),
      );
      verify(() => platformsCubit.getPlatforms()).called(1);
    });

    testWidgets('renders PlatformsList with platforms when state is loaded',
        (tester) async {
      when(() => platformsCubit.state).thenReturn(
        PlatformsLoaded(
          platforms: [
            Platform(
              id: 'some-id',
              displayName: 'displayName',
              iconUrl: 'iconUrl',
              authentication: Basic(),
            ),
          ],
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: platformsCubit,
          child: const PlatformsView(),
        ),
      );
      expect(find.byType(PlatformsList), findsOneWidget);
    });
  });
}
