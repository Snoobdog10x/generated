import 'package:reel_t/generated/abstract_service.dart';
import 'package:reel_t/shared_product/services/local_search_history.dart';
import 'package:reel_t/shared_product/services/local_setting.dart';
import 'package:reel_t/shared_product/services/receive_notification.dart';
import 'package:reel_t/shared_product/services/server_connection.dart';
import 'package:reel_t/shared_product/vendors/collection/list_stack/list_stack.dart';
import '../shared_product/services/cloud_storage.dart';
import '../shared_product/services/local_user.dart';
import '../shared_product/services/security.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppStore extends AbstractService {
  bool _isConnected = true;
  late LocalUser localUser;
  late CloudStorage cloudStorage;
  late Security security;
  late ReceiveNotification receiveNotification;
  late LocalSetting localSetting;
  late LocalSearchHistory localSearchHistory;
  late ServerConnection serverConnection;
  ListStack<void Function(bool isConnected)> _notifyDataChangedStack =
      new ListStack();
  bool _isInitialized = false;
  get isInitialized => _isInitialized;

  void pushNotifyDataChanged(
      void Function(bool isConnected) notifyDataChanged) {
    _notifyDataChangedStack.push(notifyDataChanged);
  }

  void popNotifyDataChanged() {
    _notifyDataChangedStack.pop();
  }

  void _notifyDataChangedAllStack() {
    _notifyDataChangedStack.forEach((element) {
      element(_isConnected);
    });
  }

  Future<void> _postInitServices() async {
    List<Future> wait = [];
    wait.add(localSetting.init());
    wait.add(localSearchHistory.init());
    wait.add(receiveNotification.init());

    await Future.wait(wait);
    _isInitialized = true;
    _notifyDataChangedAllStack();
  }

  Future<void> preInitServices() async {
    if (!_isInitialized) init();
    serverConnection.init();
    await localUser.init();
    await _postInitServices();
  }

  void init() {
    localUser = LocalUser();
    cloudStorage = CloudStorage();
    security = Security();
    receiveNotification = ReceiveNotification();
    localSetting = LocalSetting();
    localSearchHistory = LocalSearchHistory();
    serverConnection = ServerConnection();
    serverConnection.setCallBack((isConnected) {
      _isConnected = isConnected;
      _notifyDataChangedAllStack();
    });
  }

  bool isConnected() => _isConnected;

  bool isWeb() {
    return kIsWeb;
  }

  bool isAndroid() {
    return Platform.isAndroid;
  }

  bool isIOS() {
    return Platform.isIOS;
  }

  @override
  void dispose() {
    localUser.dispose();
    cloudStorage.dispose();
    security.dispose();
    receiveNotification.dispose();
    localSetting.dispose();
    localSearchHistory.dispose();
    serverConnection.dispose();
  }
}
