// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reel_t/generated/abstract_state.dart';
import 'package:reel_t/shared_product/services/local_search_history.dart';
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
  final LocalSearchHistory localSearchHistory = LocalSearchHistory();
  void setNotify(Function notifyDataChanged) {
    _notifyDataChanged = notifyDataChanged;
  }

  void setGlobalNavigationNotifyDataChanged(Function notifyDataChanged) {
    _navigationNotifyDataChanged = notifyDataChanged;
  }

  Future<void> init() async {
    await localUser.init();
    List<Future> inits = [];
    var userId = localUser.getCurrentUser().id;
    inits.add(localSetting.init(userId));
    inits.add(localSearchHistory.init(userId));
    inits.add(receiveNotification.init(isWeb()));
    _initConnectivity();
    await Future.wait(inits);
  }

  bool _isConnected = true;
  bool isConnected() {
    return _isConnected;
  }

  Future<void> _updateConnection(ConnectivityResult result) async {
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

  void _initConnectivity() {
    try {
      _connectivity.onConnectivityChanged.listen((result) {
        _updateConnection(result);
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
