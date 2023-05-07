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
  late final LocalUser localUser;
  late final CloudStorage cloudStorage;
  late final Security security;
  late final ReceiveNotification receiveNotification;
  late final LocalSetting localSetting;
  late final LocalSearchHistory localSearchHistory;
  late final ServerConnection serverConnection;
  ListStack<void Function(bool isConnected)> _notifyDataChangedStack =
      new ListStack();

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

  Future<void> initServices() async {
    init();
    await localUser.init();
    serverConnection.init();
    localSetting.init();
    localSearchHistory.init();
    receiveNotification.init();
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

  bool isConnected() {
    return _isConnected;
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
