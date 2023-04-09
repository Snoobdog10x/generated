// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app_store.dart';

class AppInit {
  static AppStore appStore = AppStore();
  static init(bool isDebug) async {
    if (!appStore.isWeb()) {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
    }
    if (isDebug) {
      try {
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
        await FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    await appStore.init();
  }
}
