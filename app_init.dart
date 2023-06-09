// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';
import 'package:reel_t/models/conversation/conversation_sample_data.dart';
import 'package:reel_t/models/search_history/search_history_sample_data.dart';
import '../models/user_profile/user_profile_sample_data.dart';
import '../models/video/video_sample_data.dart';
import 'app_store.dart';

class AppInit {
  static final AppStore appStore = AppStore();

  Future<void> init({
    bool isDebug = false,
    bool isInitSample = false,
  }) async {
    try {
      await PlatformNotifier.I.init(appName: "Reel T");
      await _initHive();
      await appStore.preInitServices();
      if (isDebug) initRunWithEmulator();
      if (isInitSample) initSamples();
    } catch (e) {
      print(e);
    }
  }

  Future<void> initSamples() async {
    appStore.localUser.clearUser();
    await VideoData().initSampleData();
    await UserProfileData().initSampleData();
    ConversationData().initConversationData();
    SearchHistoryData().initSearchHistoryData();
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

  Future<void> _initHive() async {
    if (appStore.isWeb()) return;

    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }
}
