part of 'platforms_cubit.dart';

@immutable
sealed class PlatformsState {}

final class PlatformsInitial extends PlatformsState {}

final class PlatformsLoading extends PlatformsState {}

final class PlatformsLoaded extends PlatformsState {
  PlatformsLoaded({required this.platforms});

  final List<Platform> platforms;
}

final class PlatformsError extends PlatformsState {
  PlatformsError({
    required this.error,
  });

  final String error;
}
