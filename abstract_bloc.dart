// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'app_init.dart';
import 'app_store.dart';
import 'abstract_state.dart';

abstract class AbstractBloc<T extends AbstractState> extends ChangeNotifier {
  late T state;
  AppStore appStore = AppInit.appStore;

  bool _isDispose = false;
  bool isLogin() => state.isLogin();

  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }

  void notifyDataChanged() {
    if (_isDispose) return;
    notifyListeners();
  }
}
