import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview/in_app_webview_controller.dart';

/// Object specifying creation parameters for creating a [MacOSInAppBrowser].
class MacOSInAppBrowserCreationParams
    extends PlatformInAppBrowserCreationParams {
  /// Creates a new [MacOSInAppBrowserCreationParams] instance.
  MacOSInAppBrowserCreationParams(
      {super.contextMenu,
      super.pullToRefreshController,
      super.findInteractionController,
      super.initialUserScripts,
      super.windowId,
      super.webViewEnvironment});

  /// Creates a [MacOSInAppBrowserCreationParams] instance based on [PlatformInAppBrowserCreationParams].
  MacOSInAppBrowserCreationParams.fromPlatformInAppBrowserCreationParams(
      PlatformInAppBrowserCreationParams params)
      : this(
            contextMenu: params.contextMenu,
            pullToRefreshController: params.pullToRefreshController,
            findInteractionController: params.findInteractionController,
            initialUserScripts: params.initialUserScripts,
            windowId: params.windowId,
            webViewEnvironment: params.webViewEnvironment);
}

/// Implementation of [PlatformInAppBrowser] for macOS.
class MacOSInAppBrowser extends PlatformInAppBrowser with ChannelController {
  @override
  final String id = IdGenerator.generate();

  /// The channel used to interact with the native platform.
  MethodChannel? get channel => _channel;
  MethodChannel? _channel;

  static const MethodChannel _staticChannel =
      MethodChannel('dev.zuzu/flutter_inappbrowser');

  MacOSInAppWebViewController? _webViewController;
  bool _isOpened = false;

  @override
  MacOSInAppWebViewController? get webViewController => _webViewController;

  /// Creates a new [MacOSInAppBrowser] instance.
  MacOSInAppBrowser(PlatformInAppBrowserCreationParams params)
      : super.implementation(
          params is MacOSInAppBrowserCreationParams
              ? params
              : MacOSInAppBrowserCreationParams
                  .fromPlatformInAppBrowserCreationParams(params),
        );

  static final MacOSInAppBrowser _staticValue =
      MacOSInAppBrowser(MacOSInAppBrowserCreationParams());

  /// Provide static access.
  factory MacOSInAppBrowser.static() {
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
    final webviewParams = PlatformInAppWebViewWidgetCreationParams(
      onLoadStart: (controller, url) => eventHandler?.onLoadStart(url),
      onLoadStop: (controller, url) => eventHandler?.onLoadStop(url),
      onReceivedError: (controller, request, error) =>
          eventHandler?.onReceivedError(request, error),
      onReceivedHttpError: (controller, request, errorResponse) =>
          eventHandler?.onReceivedHttpError(request, errorResponse),
      onProgressChanged: (controller, progress) =>
          eventHandler?.onProgressChanged(progress),
      onUpdateVisitedHistory: (controller, url, isReload) =>
          eventHandler?.onUpdateVisitedHistory(url, isReload),
      onTitleChanged: (controller, title) =>
          eventHandler?.onTitleChanged(title),
      onConsoleMessage: (controller, consoleMessage) =>
          eventHandler?.onConsoleMessage(consoleMessage),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        return await eventHandler
            ?.shouldOverrideUrlLoading(navigationAction);
      },
      onJsAlert: (controller, jsAlertRequest) async {
        return await eventHandler?.onJsAlert(jsAlertRequest);
      },
      onJsConfirm: (controller, jsConfirmRequest) async {
        return await eventHandler?.onJsConfirm(jsConfirmRequest);
      },
      onJsPrompt: (controller, jsPromptRequest) async {
        return await eventHandler?.onJsPrompt(jsPromptRequest);
      },
      // Add other events as needed
    );

    _webViewController = MacOSInAppWebViewController.fromInAppBrowser(
      PlatformInAppWebViewControllerCreationParams(
          id: id, webviewParams: webviewParams),
      _channel!,
    );
  }

  Map<String, dynamic> _prepareOpenRequest(
      {InAppBrowserClassSettings? settings}) {
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
    args.putIfAbsent('initialUserScripts',
        () => initialUserScripts?.map((e) => e.toMap()).toList() ?? []);
    args.putIfAbsent('menuItems',
        () => _menuItems.values.map((e) => e.toMap()).toList());

    return args;
  }

  @override
  Future<void> openUrlRequest(
      {required URLRequest urlRequest,
      InAppBrowserClassSettings? settings}) async {
    Map<String, dynamic> args = _prepareOpenRequest(settings: settings);
    if (args.isEmpty) return; // Already opened
    args.putIfAbsent('urlRequest', () => urlRequest.toMap());
    await _staticChannel.invokeMethod('open', args);
  }

  @override
  Future<void> openFile(
      {required String assetFilePath,
      InAppBrowserClassSettings? settings}) async {
    Map<String, dynamic> args = _prepareOpenRequest(settings: settings);
    if (args.isEmpty) return;
    args.putIfAbsent('assetFilePath', () => assetFilePath);
    await _staticChannel.invokeMethod('open', args);
  }

  @override
  Future<void> openData(
      {required String data,
      String mimeType = "text/html",
      String encoding = "utf8",
      WebUri? baseUrl,
      WebUri? historyUrl,
      InAppBrowserClassSettings? settings}) async {
    Map<String, dynamic> args = _prepareOpenRequest(settings: settings);
    if (args.isEmpty) return;
    args.putIfAbsent('data', () => data);
    args.putIfAbsent('mimeType', () => mimeType);
    args.putIfAbsent('encoding', () => encoding);
    args.putIfAbsent('baseUrl', () => baseUrl?.toString() ?? "about:blank");
    args.putIfAbsent('historyUrl',
        () => historyUrl?.toString() ?? "about:blank");
    await _staticChannel.invokeMethod('open', args);
  }

  @override
  Future<void> close() async {
    await _channel?.invokeMethod('close');
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
  bool isOpened() {
    return _isOpened;
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    _webViewController?.dispose();
    _webViewController = null;
    super.dispose();
  }
}
