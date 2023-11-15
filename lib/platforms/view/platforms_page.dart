import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_emulators_demo/l10n/l10n.dart';
import 'package:flutter_firebase_emulators_demo/platforms/platforms.dart';
import 'package:platforms_repository/platforms_repository.dart';

class PlatformsPage extends StatelessWidget {
  const PlatformsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlatformsCubit(
        platformsRepository: context.read<PlatformsRepository>(),
      )..getPlatforms(),
      child: const PlatformsView(),
    );
  }
}

class PlatformsView extends StatelessWidget {
  const PlatformsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final platformState = context.select((PlatformsCubit cubit) => cubit.state);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: switch (platformState) {
        PlatformsInitial() || PlatformsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        PlatformsLoaded(:final platforms) when platforms.isNotEmpty =>
          PlatformsList(platforms: platforms),
        PlatformsLoaded() => const Center(child: Text('No platforms')),
        PlatformsError(:final error) => Center(child: Text(error)),
      },
    );
  }
}

class PlatformsList extends StatelessWidget {
  const PlatformsList({
    required this.platforms,
    super.key,
  });

  final List<Platform> platforms;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: platforms.length,
      itemBuilder: (_, index) {
        final platform = platforms[index];
        return ListTile(
          leading: CircleAvatar(
            child: Image.network(platform.iconUrl),
          ),
          title: Text(platform.displayName),
        );
      },
    );
  }
}
