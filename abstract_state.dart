// GENERATED CODE - DO NOT MODIFY BY HAND
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../shared_product/widgets/app_theme.dart';
import 'app_init.dart';
import 'app_store.dart';
import 'abstract_bloc.dart';

abstract class AbstractState<T extends StatefulWidget> extends State<T> {
  AppStore appStore = AppInit.appStore;
  Timer? _readyTimer;
  String ALERT_DIALOG_WIDGET = "alert_dialog_widget";
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

  bool isConnected() {
    if (!appStore.isInitialized) return false;
    return appStore.isInitialized;
  }

  Widget buildScreen({
    bool isSafe = true,
    bool isSafeTop = true,
    bool isSafeBottom = true,
    bool isPushLayoutWhenShowKeyboard = false,
    bool isShowConnect = false,
    bool isWrapBody = false,
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
    bool isLogged = isLogin();

    if (!isWrapBody)
      layout.add(Expanded(
          child: _buildTrueBody(
              isLogged ? body : notLoggedBody ?? body, truePadding)));
    else
      layout.add(
          _buildTrueBody(isLogged ? body : notLoggedBody ?? body, truePadding));

    if (isShowConnect) {
      if (!isConnected()) {
        layout.add(_buildConnectionStatus(false, bottomNavBar != null));
        hasDisplayConnected = false;
      }

      if (hasDisplayConnected == false && isConnected()) {
        layout.add(_buildConnectionStatus(true, bottomNavBar != null));
        Future.delayed(Duration(seconds: 1), () {
          hasDisplayConnected = true;
          notifyDataChanged();
        });
      }
    }
    layout.add(_buildBottomBar(bottomNavBar, truePadding));
    if (isWrapBody)
      return Container(
        color: background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: layout,
        ),
      );

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
    _context = initContext();
    onCreate();
    _bloc = initBloc();
    _bloc.state = this;
    appStore.pushNotifyDataChanged(_checkConnectionAndNotifyDataChanged);
    onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onPostFrame();
    });
  }

  @mustCallSuper
  void onPostFrame() {}
  void notifyDataChanged() {
    _bloc.notifyDataChanged();
  }

  bool isLogin() {
    if (!appStore.isInitialized) return false;
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
    return MediaQuery.of(_context).padding.bottom;
  }

  @override
  Widget build(BuildContext context);

  @override
  void dispose() {
    onDispose();
    appStore.popNotifyDataChanged();
    super.dispose();
  }

  bool _isLoading = false;
  void stopLoading() {
    if (!_isLoading) return;
    popTopDisplay();
    _isLoading = false;
  }

  void showScreenBottomSheet(Widget content, {bool isDismissible = true}) {
    stopLoading();
    showMaterialModalBottomSheet(
      isDismissible: isDismissible,
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
    ).whenComplete(() {
      onPopWidget(content.runtimeType.toString());
    });
  }

  void showAlertDialog({
    String? title,
    String? content,
    TextEditingController? controller,
    String confirmTitle = "OK",
    String cancelTitle = "NO",
    Function? confirm,
    Function? cancel,
    bool isLockOutsideTap = false,
  }) {
    stopLoading();
    List<CupertinoDialogAction> actions = [];
    if (cancel != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            cancel();
          },
          child: Text(cancelTitle),
        ),
      );
    }

    if (confirm != null) {
      actions.add(
        CupertinoDialogAction(
          onPressed: () {
            confirm();
          },
          child: Text(confirmTitle),
        ),
      );
    }
    Widget dialogContent = Text(content ?? "");
    ;
    if (controller != null) {
      dialogContent = Column(
        children: [
          Text(content ?? ""),
          CupertinoTextField(
            controller: controller,
          )
        ],
      );
    }
    showCupertinoModalPopup<void>(
      context: _context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: dialogContent,
        actions: actions,
      ),
    ).then((value) {
      onPopWidget(ALERT_DIALOG_WIDGET);
    });
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
    Future.delayed(Duration(seconds: 20), () {
      if (_isLoading) {
        stopLoading();
      }
    });
  }

  void onPopWidget(String previousScreen) {
    notifyDataChanged();
  }

  void pushToScreen(Widget screen, {bool isReplace = false}) {
    Route route = MaterialPageRoute(builder: (context) => screen);
    if (isReplace) {
      Navigator.of(_context).pushAndRemoveUntil(
        route,
        (_) => false,
      );
      return;
    }

    Navigator.of(_context).push(route).then(
      (value) {
        onPopWidget(screen.runtimeType.toString());
      },
    );
  }

  void _checkConnectionAndNotifyDataChanged(bool isConnected) {
    if (isConnected) {
      print("ready");
      onReady();
    }

    notifyDataChanged();
  }

  void popTopDisplay() {
    Navigator.pop(_context);
  }
}
