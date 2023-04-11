// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reel_t/models/conversation/conversation_sample_data.dart';
import 'package:reel_t/models/follow/follow_sample_data.dart';
import '../models/user_profile/user_profile_sample_data.dart';
import '../models/video/video_sample_data.dart';
import 'app_store.dart';

class AppInit {
  static AppStore appStore = AppStore();
  static Future<void> init({
    bool isDebug = false,
    bool isInitSample = false,
  }) async {
    List<Future> futureMethod = [];
    if (!appStore.isWeb()) {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
    }
    if (isDebug) {
      try {
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        futureMethod
            .add(FirebaseAuth.instance.useAuthEmulator('localhost', 9099));
        FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
        futureMethod.add(
            FirebaseStorage.instance.useStorageEmulator("localhost", 9199));
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    await appStore.init();
    if (isInitSample) {
      appStore.localUser.clearUser();
      futureMethod.add(VideoData().initSampleData());
      futureMethod.add(UserProfileData().initSampleData());
      futureMethod.add(ConversationData().initConversationData());
      futureMethod.add(FollowData().initFollowData());
    }
    await Future.wait(futureMethod);
  }
}
