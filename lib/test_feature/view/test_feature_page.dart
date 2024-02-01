import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_emulators_demo/l10n/l10n.dart';
import 'package:flutter_firebase_emulators_demo/test_feature/test_feature.dart';
import 'package:test_repository/test_repository.dart';

class TestFeaturePage extends StatelessWidget {
  const TestFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TestFeatureCubit(
        testsRepository: context.read<TestRepository>(),
      )..getTest(),
      child: const TestView(),
    );
  }
}

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final testState = context.select((TestFeatureCubit cubit) => cubit.state);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: switch (testState) {
        TestFeatureInitial() || TestFeatureLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        TestFeatureLoaded(:final testData) when testData.isNotEmpty =>
          TestList(tests: testData),
        TestFeatureLoaded() => const Center(child: Text('No tests')),
        TestFeatureError(:final error) => Center(child: Text(error)),
      },
    );
  }
}

class TestList extends StatelessWidget {
  const TestList({
    required this.tests,
    super.key,
  });

  final List<TestData> tests;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tests.length,
      itemBuilder: (_, index) {
        final test = tests[index];
        return ListTile(
          title: Text(test.name),
          subtitle: Text(test.description),
        );
      },
    );
  }
}
