import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview/in_app_webview_controller.dart';

class LinuxInAppBrowserCreationParams
    extends PlatformInAppBrowserCreationParams {
  LinuxInAppBrowserCreationParams({
    super.contextMenu,
    super.pullToRefreshController,
    super.findInteractionController,
    super.initialUserScripts,
    super.windowId,
    super.webViewEnvironment,
  });

  LinuxInAppBrowserCreationParams.fromPlatformInAppBrowserCreationParams(
    PlatformInAppBrowserCreationParams params,
  ) : this(
        contextMenu: params.contextMenu,
        pullToRefreshController: params.pullToRefreshController,
        findInteractionController: params.findInteractionController,
        initialUserScripts: params.initialUserScripts,
        windowId: params.windowId,
        webViewEnvironment: params.webViewEnvironment,
      );
}

class LinuxInAppBrowser extends PlatformInAppBrowser with ChannelController {
  MethodChannel? _channel;

  static const MethodChannel _staticChannel = MethodChannel(
    'dev.zuzu/flutter_inappbrowser',
  );

  LinuxInAppWebViewController? _webViewController;
  bool _isOpened = false;

  @override
  LinuxInAppWebViewController? get webViewController => _webViewController;

  LinuxInAppBrowser(PlatformInAppBrowserCreationParams params)
    : super.implementation(
        params is LinuxInAppBrowserCreationParams
            ? params
            : LinuxInAppBrowserCreationParams.fromPlatformInAppBrowserCreationParams(
                params,
              ),
      );

  static final LinuxInAppBrowser _staticValue = LinuxInAppBrowser(
    LinuxInAppBrowserCreationParams(),
  );

  factory LinuxInAppBrowser.static() {
    return _staticValue;
  }

  final Map<int, InAppBrowserMenuItem> _menuItems = {};

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onBrowserCreated":
        eventHandler?.onBrowserCreated();
        break;
      case "onExit":
        _isOpened = false;
        eventHandler?.onExit();
        dispose();
        break;
      case "onMenuItemClicked":
        int id = call.arguments["id"];
        final menuItem = _menuItems[id];
        if (menuItem != null) {
          menuItem.onClick?.call();
        }
        break;
      default:
        // forward to controller
        return await _webViewController?.handleMethod(call);
    }
  }

  @override
  void addMenuItem(InAppBrowserMenuItem menuItem) {
    _menuItems[menuItem.id] = menuItem;
  }

  @override
  void addMenuItems(List<InAppBrowserMenuItem> menuItems) {
    for (final menuItem in menuItems) {
      _menuItems[menuItem.id] = menuItem;
    }
  }

  @override
  bool removeMenuItem(InAppBrowserMenuItem menuItem) {
    return _menuItems.remove(menuItem.id) != null;
  }

  @override
  void removeMenuItems(List<InAppBrowserMenuItem> menuItems) {
    for (final menuItem in menuItems) {
      _menuItems.remove(menuItem.id);
    }
  }

  @override
  void removeAllMenuItem() {
    _menuItems.clear();
  }

  @override
  bool hasMenuItem(InAppBrowserMenuItem menuItem) {
    return _menuItems.containsKey(menuItem.id);
  }

  void _init() {
    _channel = MethodChannel('dev.zuzu/flutter_inappbrowser_$id');
    _channel?.setMethodCallHandler(handleMethod);

    // Create webview params that delegate to our eventHandler
    // This is a simplified delegation for now
    // We would need to implement all callbacks to properly delegate
    // For now we just create the controller

    _webViewController = LinuxInAppWebViewController.fromInAppBrowser(
      PlatformInAppWebViewControllerCreationParams(
        id: id,
        webviewParams: PlatformInAppWebViewWidgetCreationParams(
          controllerFromPlatform: (controller) => controller,
        ),
      ),
      _channel!,
    );
  }

  Map<String, dynamic> _prepareOpenRequest({
    InAppBrowserClassSettings? settings,
  }) {
    if (_isOpened) {
      return {};
    }
    _isOpened = true;
    _init();

    var initialSettings =
        settings?.toMap() ?? InAppBrowserClassSettings().toMap();

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('id', () => id);
    args.putIfAbsent('settings', () => initialSettings);
    args.putIfAbsent('contextMenu', () => contextMenu?.toMap() ?? {});
    args.putIfAbsent('windowId', () => windowId);
    args.putIfAbsent(
      'initialUserScripts',
      () => initialUserScripts?.map((e) => e.toMap()).toList() ?? [],
    );
    args.putIfAbsent(
      'menuItems',
      () => _menuItems.values.map((e) => e.toMap()).toList(),
    );

    return args;
  }

  @override
  Future<void> openUrlRequest({
    required URLRequest urlRequest,
    InAppBrowserClassSettings? settings,
  }) async {
    Map<String, dynamic> args = _prepareOpenRequest(settings: settings);
    args.putIfAbsent('urlRequest', () => urlRequest.toMap());
    await _staticChannel.invokeMethod('open', args);
  }

  @override
  Future<void> openFile({
    required String assetFilePath,
    InAppBrowserClassSettings? settings,
  }) async {
    Map<String, dynamic> args = _prepareOpenRequest(settings: settings);
    args.putIfAbsent('assetFilePath', () => assetFilePath);
    await _staticChannel.invokeMethod('open', args);
  }

  @override
  Future<void> openData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    InAppBrowserClassSettings? settings,
  }) async {
    Map<String, dynamic> args = _prepareOpenRequest(settings: settings);
    args.putIfAbsent('data', () => data);
    args.putIfAbsent('mimeType', () => mimeType);
    args.putIfAbsent('encoding', () => encoding);
    args.putIfAbsent('baseUrl', () => baseUrl?.toString() ?? "about:blank");
    args.putIfAbsent(
      'historyUrl',
      () => historyUrl?.toString() ?? "about:blank",
    );
    await _staticChannel.invokeMethod('open', args);
  }

  @override
  Future<void> openWithSystemBrowser({required WebUri url}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('url', () => url.toString());
    await _staticChannel.invokeMethod('openWithSystemBrowser', args);
  }

  @override
  Future<void> show() async {
    await _channel?.invokeMethod('show');
  }

  @override
  Future<void> hide() async {
    await _channel?.invokeMethod('hide');
  }

  @override
  Future<void> close() async {
    await _channel?.invokeMethod('close');
  }

  @override
  Future<bool> isHidden() async {
    return await _channel?.invokeMethod<bool>('isHidden') ?? false;
  }

  @override
  Future<void> setSettings({
    required InAppBrowserClassSettings settings,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('settings', () => settings.toMap());
    await _channel?.invokeMethod('setSettings', args);
  }

  @override
  Future<InAppBrowserClassSettings?> getSettings() async {
    Map<String, dynamic> args = <String, dynamic>{};
    Map<String, dynamic>? settings = (await _channel?.invokeMethod(
      'getSettings',
      args,
    ))?.cast<String, dynamic>();
    return settings != null
        ? InAppBrowserClassSettings.fromMap(settings)
        : null;
  }

  @override
  bool isOpened() {
    return _isOpened;
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    disposeChannel();
    _webViewController?.dispose();
    _webViewController = null;
    super.dispose();
  }
}
