// GENERATED CODE - DO NOT MODIFY BY HAND
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../shared_product/widgets/app_theme.dart';
import 'app_init.dart';
import 'app_store.dart';
import 'abstract_bloc.dart';

abstract class AbstractState<T extends StatefulWidget> extends State<T> {
  AppStore appStore = AppInit.appStore;
  late AbstractBloc _bloc;
  late BuildContext _context;
  late double _topPadding;
  late double _screenHeight;
  late double _screenWidth;
  AppTheme _theme = AppTheme();
  void onCreate();
  void onDispose();
  void onReady();
  bool hasDisplayConnected = true;
  AbstractBloc initBloc();
  BuildContext initContext();
  Widget buildScreen({
    bool isSafe = true,
    bool isSafeTop = true,
    bool isSafeBottom = true,
    bool isPushLayoutWhenShowKeyboard = false,
    bool isShowConnect = false,
    Widget? appBar,
    Widget? bottomNavBar,
    Widget? body,
    Widget? notLoggedBody,
    EdgeInsets? padding,
    Color background = const Color.fromARGB(255, 240, 240, 240),
    bool isDarkTheme = true,
  }) {
    List<Widget> layout = [];
    EdgeInsets truePadding = EdgeInsets.only(
      top: isSafe && isSafeTop ? paddingTop() : 0,
      left: padding?.left ?? 0,
      right: padding?.right ?? 0,
      bottom: isSafe && isSafeBottom ? paddingBottom() : 0,
    );
    layout.add(_buildAppBar(appBar, truePadding));
    bool isLogged = appStore.localUser.isLogin();
    layout.add(Expanded(
        child: _buildTrueBody(
            isLogged ? body : notLoggedBody ?? body, truePadding)));
    if (isShowConnect) {
      if (!appStore.isConnected()) {
        layout.add(_buildConnectionStatus(false, bottomNavBar != null));
        hasDisplayConnected = false;
      }

      if (hasDisplayConnected == false && appStore.isConnected()) {
        layout.add(_buildConnectionStatus(true, bottomNavBar != null));
        Future.delayed(Duration(seconds: 2), () {
          hasDisplayConnected = true;
          notifyDataChanged();
        });
      }
    }
    layout.add(_buildBottomBar(bottomNavBar, truePadding));

    return Theme(
      data: isDarkTheme ? _theme.DARK_THEME : _theme.LIGHT_THEME,
      child: Scaffold(
        resizeToAvoidBottomInset: isPushLayoutWhenShowKeyboard,
        backgroundColor: background,
        body: Column(
          children: layout,
        ),
      ),
    );
  }

  Widget _buildTrueBody(Widget? body, EdgeInsets padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: body,
    );
  }

  Widget _buildBottomBar(Widget? bottomBar, EdgeInsets padding) {
    return Container(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: bottomBar,
    );
  }

  Widget _buildAppBar(Widget? appBar, EdgeInsets padding) {
    return Container(
      padding: EdgeInsets.only(top: padding.top),
      child: appBar,
    );
  }

  Widget _buildConnectionStatus(bool isConnected, bool isSafe) {
    return Container(
      margin: EdgeInsets.only(bottom: isSafe ? 0 : paddingBottom()),
      height: 40,
      width: double.infinity,
      alignment: Alignment.center,
      color: isConnected ? Colors.green : Colors.red,
      child: Text(isConnected ? "Connected" : "Disconnected"),
    );
  }

  @override
  void initState() {
    super.initState();
    onCreate();
    _bloc = initBloc();
    _bloc.state = this;
    _context = initContext();
    appStore.setNotify(notifyDataChanged);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        onReady();
      },
    );
  }

  void notifyDataChanged() {
    _bloc.notifyDataChanged();
  }

  bool isLogin() {
    return appStore.localUser.isLogin();
  }

  double screenHeight() {
    if (_context == null) {
      return 0;
    }
    return MediaQuery.of(_context!).size.height;
  }

  double screenWidth() {
    if (_context == null) {
      return 0;
    }
    return MediaQuery.of(_context!).size.width;
  }

  double screenRatio() {
    if (_context == null) {
      return 0;
    }
    return MediaQuery.of(_context!).size.aspectRatio;
  }

  double paddingTop() {
    if (_context == null) {
      return 0;
    }
    return MediaQuery.of(_context!).padding.top;
  }

  double paddingBottom() {
    if (_context == null) {
      return 0;
    }
    return MediaQuery.of(_context!).padding.bottom;
  }

  @override
  Widget build(BuildContext context);
  @override
  void dispose() {
    super.dispose();
    onDispose();
  }

  bool _isLoading = false;
  void stopLoading() {
    if (!_isLoading) return;
    Navigator.pop(_context);
    _isLoading = false;
  }

  void showScreenBottomSheet(Widget content) {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: _context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: content,
        );
      },
    );
  }

  void showAlertDialog({
    String? title,
    String? content,
    Function? confirm,
    Function? cancel,
    bool isLockOutsideTap = false,
  }) {
    stopLoading();
    List<CupertinoDialogAction> actions = [];
    if (confirm != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            confirm();
          },
          child: const Text('OK'),
        ),
      );
    }

    if (cancel != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            cancel();
          },
          child: const Text('NO'),
        ),
      );
    }
    showCupertinoModalPopup<void>(
      context: _context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(content ?? ""),
        actions: actions,
      ),
    );
  }

  void startLoading() {
    if (_isLoading) return;

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            radius: 20,
            color: Colors.grey,
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: _context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    _isLoading = true;
    Future.delayed(Duration(seconds: 10), () {
      if (_isLoading) {
        stopLoading();
      }
    });
  }

  void onPopWidget() {
    notifyDataChanged();
  }

  void pushToScreen(Widget screen, {bool isReplace = false}) {
    Route route = MaterialPageRoute(builder: (context) => screen);
    if (isReplace) {
      Navigator.of(_context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (_) => false,
      );
      return;
    }

    Navigator.of(_context).push(route).then(
      (value) {
        onPopWidget();
      },
    );
  }

  void popTopDisplay() {
    Navigator.pop(_context);
  }
}
