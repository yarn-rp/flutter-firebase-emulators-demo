import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_repository/src/models/models.dart';

const _testDataCollection = 'testData';

/// {@template tests_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class TestRepository {
  /// {@macro tests_repository}
  TestRepository({
    required FirebaseFirestore firestore,
  }) : _testsCollection =
            firestore.collection(_testDataCollection).withConverter<TestData>(
                  fromFirestore: (snapshot, _) =>
                      TestData.fromJson(snapshot.data()!),
                  toFirestore: (test, _) => test.toJson(),
                );

  final CollectionReference<TestData> _testsCollection;

  /// Fetches all tests.
  Future<List<TestData>> fetchTest() async {
    final snapshot = await _testsCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
