// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'app_init.dart';
import 'app_store.dart';
import 'abstract_state.dart';

abstract class AbstractBloc<T extends AbstractState> extends ChangeNotifier {
  late T state;
  bool _isDispose = false;
  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }

  AppStore appStore = AppInit.appStore;
  void notifyDataChanged() {
    if (_isDispose) return;
    notifyListeners();
  }
}
