import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _authEmulator = 'auth';
const _firestoreEmulator = 'firestore';
const _functionsEmulator = 'functions';

// If you are running the flutter project using non external devices, you can
// use localhost. If you are using an external device, you can use the IP address
// of the machine running the emulators.
const _hostAddress = 'localhost';

/// The expected format of the Firebase Emulators configuration.
typedef EmulatorsConfig = ({
  Address authAddress,
  Address firestoreAddress,
  Address functionsAddress,
});

/// The expected format of the Firebase Emulators address.
typedef Address = ({
  String host,
  int port,
});

/// Setups the emulators for Firebase services by reading the configuration
/// `firebase.json` file by passing the json file via environment variable.
///
/// Calling this function without the `emulators` environment variable set
/// will do nothing.
Future<void> setupFirebaseEmulators(
  FirebaseAuth auth,
  FirebaseFirestore firestore,
  FirebaseFunctions functions,
) async {
  const emulatorsConfigString = String.fromEnvironment('emulators');

  if (emulatorsConfigString.isEmpty) {
    log('No emulators configuration found. Skipping firebase config setup...');
    return;
  }

  final (:authAddress, :firestoreAddress, :functionsAddress) =
      _parseEmulatorsConfig(emulatorsConfigString);

  await auth.useAuthEmulator(authAddress.host, authAddress.port);
  firestore.useFirestoreEmulator(firestoreAddress.host, firestoreAddress.port);
  functions.useFunctionsEmulator(functionsAddress.host, functionsAddress.port);
}

EmulatorsConfig _parseEmulatorsConfig(String emulatorsConfigString) {
  // Remove all whitespace for easier parsing
  final compactConfig = emulatorsConfigString.replaceAll(RegExp(r'\s+'), '');

  // Extract key-value pairs using a regular expression
  final exp = RegExp(r'(\w+):{?([^\{\}]+)}?,?');
  final matches = exp.allMatches(compactConfig);

  final emulatorsConfig = <String, dynamic>{};
  for (final match in matches) {
    final group1 = match.group(1);
    final group2 = match.group(2);
    if (group1 == null || group2 == null) {
      continue;
    }
    // Nested structure
    if (group2.contains(':')) {
      final innerMatch = RegExp(r'(\w+):(\d+)').firstMatch(group2);
      final innerGroup1 = innerMatch?.group(1);
      final innerGroup2 = innerMatch?.group(2);

      if (innerGroup1 == null || innerGroup2 == null) {
        continue;
      }

      if (innerMatch != null) {
        final innerMap = <String, int>{};
        innerMap[innerGroup1] = int.parse(innerGroup2);

        emulatorsConfig[group1] = innerMap;
      }
    } else {
      emulatorsConfig[group1] = group2;
    }
  }
  final authAddress = _parseAddress(emulatorsConfig[_authEmulator]);
  final firestoreAddress = _parseAddress(emulatorsConfig[_firestoreEmulator]);
  final functionsAddress = _parseAddress(emulatorsConfig[_functionsEmulator]);

  log('Auth emulator: $authAddress');
  log('Firestore emulator: $firestoreAddress');
  log('Functions emulator: $functionsAddress');

  return (
    authAddress: authAddress,
    firestoreAddress: firestoreAddress,
    functionsAddress: functionsAddress,
  );
}

Address _parseAddress(dynamic address) {
  if (address is Map) {
    return (
      host: _hostAddress,
      port: address['port'],
    );
  }
  // Handle other cases or throw an error
  throw const FormatException('Invalid address format');
}
