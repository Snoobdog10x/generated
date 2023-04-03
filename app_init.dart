// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app_store.dart';

class AppInit {
  static AppStore appStore = AppStore();
  static init() async {
    if (!appStore.isWeb()) {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
    }
    await appStore.init();
  }
}
