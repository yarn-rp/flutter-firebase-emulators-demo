import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_emulators_demo/app/app.dart';
import 'package:flutter_firebase_emulators_demo/bootstrap.dart';
import 'package:flutter_firebase_emulators_demo/emulators_config.dart';
import 'package:flutter_firebase_emulators_demo/firebase_options.dart';
import 'package:test_repository/test_repository.dart';

void main() async {
  // ... Initialize all your services here regularly
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final auth = FirebaseAuth.instanceFor(app: firebaseApp);
  final firestore = FirebaseFirestore.instanceFor(app: firebaseApp);
  final functions = FirebaseFunctions.instanceFor(app: firebaseApp);

  if (kDebugMode) {
    await setupFirebaseEmulators(auth, firestore, functions);
  }

  final testsRepository = TestRepository(firestore: firestore);
  return bootstrap(
    () => RepositoryProvider(
      create: (context) => testsRepository,
      child: const App(),
    ),
  );
}
