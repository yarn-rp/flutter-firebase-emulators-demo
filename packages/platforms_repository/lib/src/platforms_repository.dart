import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platforms_repository/src/models/platform.dart';

/// {@template platforms_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PlatformsRepository {
  /// {@macro platforms_repository}
  PlatformsRepository({
    required FirebaseFirestore firestore,
  }) : _platformsCollection =
            firestore.collection('platforms').withConverter<Platform>(
                  fromFirestore: (snapshot, _) =>
                      Platform.fromJson(snapshot.data()!),
                  toFirestore: (platform, _) => platform.toJson(),
                );

  final CollectionReference<Platform> _platformsCollection;

  /// Fetches all platforms.
  Future<List<Platform>> fetchPlatforms() async {
    final snapshot = await _platformsCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
