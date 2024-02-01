// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_repository/test_repository.dart';

class _MockFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class _MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

void main() {
  group('TestRepository', () {
    late FirebaseFirestore firestore;

    setUp(() {
      firestore = _MockFirestore();
      final collectionReference =
          _MockCollectionReference<Map<String, dynamic>>();

      final testCollectionReference = _MockCollectionReference<TestData>();

      when(() => firestore.collection(any())).thenReturn(collectionReference);
      when(
        () => collectionReference.withConverter<TestData>(
          fromFirestore: any(named: 'fromFirestore'),
          toFirestore: any(named: 'toFirestore'),
        ),
      ).thenReturn(testCollectionReference);
    });

    test('can be instantiated', () {
      expect(TestRepository(firestore: firestore), isNotNull);
    });
  });
}
