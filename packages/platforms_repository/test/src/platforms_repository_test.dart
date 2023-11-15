// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platforms_repository/platforms_repository.dart';

class _MockFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class _MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

void main() {
  group('PlatformsRepository', () {
    late FirebaseFirestore firestore;

    setUp(() {
      firestore = _MockFirestore();
      final collectionReference =
          _MockCollectionReference<Map<String, dynamic>>();

      final platformCollectionReference = _MockCollectionReference<Platform>();

      when(() => firestore.collection(any())).thenReturn(collectionReference);
      when(
        () => collectionReference.withConverter<Platform>(
          fromFirestore: any(named: 'fromFirestore'),
          toFirestore: any(named: 'toFirestore'),
        ),
      ).thenReturn(platformCollectionReference);
    });

    test('can be instantiated', () {
      expect(PlatformsRepository(firestore: firestore), isNotNull);
    });
  });
}
