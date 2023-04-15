// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reel_t/models/conversation/conversation_sample_data.dart';
import 'package:reel_t/models/follow/follow_sample_data.dart';
import '../models/user_profile/user_profile_sample_data.dart';
import '../models/video/video_sample_data.dart';
import 'app_store.dart';

class AppInit {
  static final AppStore appStore = AppStore();

  Future<void> init({
    bool isDebug = false,
    bool isInitSample = false,
  }) async {
    // await _initPersistence();
    await _initHive();

    await appStore.init();
    if (isDebug) {
      initRunWithEmulator();
    }

    if (isInitSample) {
      await initSamples();
    }
  }

  Future<void> initSamples() async {
    appStore.localUser.clearUser();
    await VideoData().initSampleData();
    await UserProfileData().initSampleData();
    await ConversationData().initConversationData();
    await FollowData().initFollowData();
  }

  void initRunWithEmulator() {
    final _db = FirebaseFirestore.instance;
    if (_db.settings.host == '127.0.0.1') return;
    try {
      _db.useFirestoreEmulator('127.0.0.1', 8080);
      FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
      FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
      FirebaseStorage.instance.useStorageEmulator("127.0.0.1", 9199);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _initPersistence() async {
    if (appStore.isWeb()) {
      await FirebaseFirestore.instance
          .enablePersistence(const PersistenceSettings(synchronizeTabs: true));
      return;
    }
  }

  Future<void> _initHive() async {
    if (appStore.isWeb()) return;

    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }
}
