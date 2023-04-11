// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:reel_t/shared_product/services/notification.dart';
import '../shared_product/services/firestore.dart';
import '../shared_product/services/cloud_storage.dart';
import '../shared_product/services/local_storage.dart';
import '../shared_product/services/local_user.dart';
import '../shared_product/services/security.dart';
import 'dart:io' show InternetAddress, Platform, SocketException;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppStore {
  FireStore _fireStore = FireStore();
  Function? _notifyDataChanged;
  LocalUser localUser = LocalUser();
  CloudStorage cloudStorage = CloudStorage();
  final Connectivity _connectivity = Connectivity();
  Security security = Security();
  Notification notification = Notification();
  void setNotify(Function notifyDataChanged) {
    _notifyDataChanged = notifyDataChanged;
  }

  Future<void> init() async {
    await localUser.init();
    await notification.init(isWeb());
    notification.setNotificationStream(localUser.getCurrentUser().id);
    initConnectivity();
  }

  void setNotificationStream() {
    notification.setNotificationStream(localUser.getCurrentUser().id);
  }

  bool _isConnected = true;
  bool isConnected() {
    return _isConnected;
  }

  Future<void> updateConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _isConnected = false;
      _notifyDataChanged?.call();
      return;
    }

    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      try {
        final result = await InternetAddress.lookup('example.com');
        _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        _isConnected = false;
      }
      _notifyDataChanged?.call();
    }
  }

  void initConnectivity() {
    try {
      _connectivity.onConnectivityChanged.listen((result) {
        updateConnection(result);
      });
    } on PlatformException catch (e) {
      return;
    }
  }

  bool isWeb() {
    return kIsWeb;
  }

  bool isAndroid() {
    return Platform.isAndroid;
  }

  bool isIOS() {
    return Platform.isIOS;
  }
}
