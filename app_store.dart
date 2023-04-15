// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reel_t/generated/abstract_state.dart';
import 'package:reel_t/shared_product/services/local_setting.dart';
import 'package:reel_t/shared_product/services/receive_notification.dart';
import '../shared_product/services/cloud_storage.dart';
import '../shared_product/services/local_user.dart';
import '../shared_product/services/security.dart';
import 'dart:io' show InternetAddress, Platform, SocketException;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppStore {
  Function? _notifyDataChanged;
  Function? _navigationNotifyDataChanged;
  final LocalUser localUser = LocalUser();
  final CloudStorage cloudStorage = CloudStorage();
  final Connectivity _connectivity = Connectivity();
  final Security security = Security();
  final ReceiveNotification receiveNotification = ReceiveNotification();
  final LocalSetting localSetting = LocalSetting();
  void setNotify(Function notifyDataChanged) {
    _notifyDataChanged = notifyDataChanged;
  }

  void setGlobalNavigationNotifyDataChanged(Function notifyDataChanged) {
    _navigationNotifyDataChanged = notifyDataChanged;
  }

  Future<void> init() async {
    await localUser.init();
    var userId = localUser.getCurrentUser().id;
    await localSetting.init(userId);
    await receiveNotification.init(isWeb());

    receiveNotification.setNotificationStream(userId);

    initConnectivity();
  }

  bool _isConnected = true;
  bool isConnected() {
    return _isConnected;
  }

  Future<void> updateConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _isConnected = false;
      _navigationNotifyDataChanged?.call();
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
      _navigationNotifyDataChanged?.call();
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
