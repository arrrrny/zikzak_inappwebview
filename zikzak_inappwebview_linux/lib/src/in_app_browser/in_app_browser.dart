import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../find_interaction/find_interaction_controller.dart';
import '../in_app_webview/in_app_webview_controller.dart';
import '../util/debug_logging.dart';
import '../util/wire.dart';

/// Object specifying creation parameters for creating a [LinuxInAppBrowser].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformInAppBrowserCreationParams] for
/// more information.
class LinuxInAppBrowserCreationParams
    extends PlatformInAppBrowserCreationParams {
  /// Creates a new [LinuxInAppBrowserCreationParams] instance.
  const LinuxInAppBrowserCreationParams({
    super.contextMenu,
    super.pullToRefreshController,
    LinuxFindInteractionController? super.findInteractionController,
    super.initialUserScripts,
    super.windowId,
  });

  /// Creates a [LinuxInAppBrowserCreationParams] instance based on [PlatformInAppBrowserCreationParams].
  factory LinuxInAppBrowserCreationParams.fromPlatformInAppBrowserCreationParams(
    // Recommended placeholder to prevent being broken by platform interface.
    // ignore: avoid_unused_constructor_parameters
    PlatformInAppBrowserCreationParams params,
  ) {
    return LinuxInAppBrowserCreationParams(
      contextMenu: params.contextMenu,
      pullToRefreshController: params.pullToRefreshController,
      findInteractionController:
          params.findInteractionController as LinuxFindInteractionController?,
      initialUserScripts: params.initialUserScripts,
      windowId: params.windowId,
    );
  }

  @override
  LinuxFindInteractionController? get findInteractionController =>
      super.findInteractionController as LinuxFindInteractionController?;
}

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppBrowser}
class LinuxInAppBrowser extends PlatformInAppBrowser with ChannelController {
  @override
  final String id = IdGenerator.generate();

  /// Constructs a [LinuxInAppBrowser].
  LinuxInAppBrowser(PlatformInAppBrowserCreationParams params)
    : super.implementation(
        params is LinuxInAppBrowserCreationParams
            ? params
            : LinuxInAppBrowserCreationParams.fromPlatformInAppBrowserCreationParams(
                params,
              ),
      ) {
    _contextMenu = params.contextMenu;
  }

  static final LinuxInAppBrowser _staticValue = LinuxInAppBrowser(
    LinuxInAppBrowserCreationParams(),
  );

  /// Provide static access.
  factory LinuxInAppBrowser.static() {
    return _staticValue;
  }

  LinuxInAppBrowserCreationParams get _linuxParams =>
      params as LinuxInAppBrowserCreationParams;

  static const MethodChannel _staticChannel = MethodChannel(
    'wtf.zikzak/zikzak_inappbrowser',
  );

  ContextMenu? _contextMenu;

  @override
  ContextMenu? get contextMenu => _contextMenu;

  final Map<int, InAppBrowserMenuItem> _menuItems = HashMap();
  bool _isOpened = false;
  LinuxInAppWebViewController? _webViewController;

  @override
  LinuxInAppWebViewController? get webViewController {
    return _isOpened ? _webViewController : null;
  }

  void _init() {
    channel = MethodChannel('wtf.zikzak/zikzak_inappbrowser_$id');
    handler = _handleMethod;
    initMethodCallHandler();

    _webViewController = LinuxInAppWebViewController.fromInAppBrowser(
      LinuxInAppWebViewControllerCreationParams(id: id),
      channel!,
      this,
      initialUserScripts,
    );
    _linuxParams.findInteractionController?.init(id);
  }

  void _debugLog(String method, dynamic args) {
    debugLog(
      className: runtimeType.toString(),
      id: id,
      debugLoggingSettings: PlatformInAppBrowser.debugLoggingSettings,
      method: method,
      args: args,
    );
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onBrowserCreated":
        _debugLog(call.method, call.arguments);
        eventHandler?.onBrowserCreated();
        break;
      case "onMenuItemClicked":
        _debugLog(call.method, call.arguments);
        int id = call.arguments["id"].toInt();
        if (_menuItems[id] != null) {
          if (_menuItems[id]?.onClick != null) {
            _menuItems[id]?.onClick!();
          }
        }
        break;
      case "onMainWindowWillClose":
        _debugLog(call.method, call.arguments);
        eventHandler?.onMainWindowWillClose();
        break;
      case "onExit":
        _debugLog(call.method, call.arguments);
        _isOpened = false;
        final onExit = eventHandler?.onExit;
        dispose();
        onExit?.call();
        break;
      default:
        return _webViewController?.handleMethod(call);
    }
  }

  /// The browser's events are methods of [eventHandler], so whether the app
  /// handles `onAjaxReadyStateChange` / `onAjaxProgress` cannot be detected:
  /// both are enabled whenever the app enables Ajax interception.
  static Map<String, dynamic> _settingsToWire(
    InAppBrowserClassSettings settings,
  ) {
    final ajax = settings.webViewSettings.useShouldInterceptAjaxRequest == true;
    return withAjaxEventFlags(
      inAppBrowserClassSettingsToWire(settings),
      onReadyStateChange: ajax,
      onProgress: ajax,
    );
  }

  Map<String, dynamic> _prepareOpenRequest({
    InAppBrowserClassSettings? settings,
  }) {
    assert(!_isOpened, 'The browser is already opened.');
    _isOpened = true;
    _init();

    var initialSettings = _settingsToWire(
      settings ?? InAppBrowserClassSettings(),
    );

    Map<String, dynamic> pullToRefreshSettings =
        pullToRefreshController?.settings?.toJson() ??
        PullToRefreshSettings(enabled: false).toJson();

    List<Map<String, dynamic>> menuItemList = [];
    _menuItems.forEach((key, value) {
      menuItemList.add(value.toMap());
    });

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('id', () => id);
    args.putIfAbsent(debugLoggingEnabledArg, () => nativeDebugLoggingEnabled);
    args.putIfAbsent('settings', () => initialSettings);
    args.putIfAbsent('contextMenu', () => contextMenu?.toMap() ?? {});
    args.putIfAbsent('windowId', () => windowId);
    args.putIfAbsent(
      'initialUserScripts',
      () => initialUserScripts?.map(userScriptToWire).toList() ?? [],
    );
    args.putIfAbsent('pullToRefreshSettings', () => pullToRefreshSettings);
    args.putIfAbsent('menuItems', () => menuItemList);
    return args;
  }

  @override
  Future<void> openUrlRequest({
    required URLRequest urlRequest,
    InAppBrowserClassSettings? settings,
  }) async {
    assert(urlRequest.url != null && urlRequest.url.toString().isNotEmpty);

    Map<String, dynamic> args = _prepareOpenRequest(settings: settings);
    args.putIfAbsent('urlRequest', () => urlRequest.toJson());
    await _staticChannel.invokeMethod('open', args);
  }

  @override
  Future<void> openFile({
    required String assetFilePath,
    InAppBrowserClassSettings? settings,
  }) async {
    assert(assetFilePath.isNotEmpty);

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
    assert(url.toString().isNotEmpty);

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('url', () => url.toString());
    return await _staticChannel.invokeMethod('openWithSystemBrowser', args);
  }

  @override
  void addMenuItem(InAppBrowserMenuItem menuItem) {
    _menuItems[menuItem.id] = menuItem;
  }

  @override
  void addMenuItems(List<InAppBrowserMenuItem> menuItems) {
    for (var menuItem in menuItems) {
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
      removeMenuItem(menuItem);
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

  @override
  Future<void> show() async {
    assert(_isOpened, 'The browser is not opened.');

    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('show', args);
  }

  @override
  Future<void> hide() async {
    assert(_isOpened, 'The browser is not opened.');

    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('hide', args);
  }

  @override
  Future<void> close() async {
    assert(_isOpened, 'The browser is not opened.');

    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('close', args);
  }

  @override
  Future<bool> isHidden() async {
    assert(_isOpened, 'The browser is not opened.');

    Map<String, dynamic> args = <String, dynamic>{};
    return await channel?.invokeMethod<bool>('isHidden', args) ?? false;
  }

  @override
  Future<void> setSettings({
    required InAppBrowserClassSettings settings,
  }) async {
    assert(_isOpened, 'The browser is not opened.');

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('settings', () => _settingsToWire(settings));
    await channel?.invokeMethod('setSettings', args);
  }

  @override
  Future<InAppBrowserClassSettings?> getSettings() async {
    assert(_isOpened, 'The browser is not opened.');

    Map<String, dynamic> args = <String, dynamic>{};

    final settings = await channel?.invokeMethod('getSettings', args);
    return inAppBrowserClassSettingsFromWire(settings);
  }

  @override
  bool isOpened() {
    return _isOpened;
  }

  @override
  @mustCallSuper
  void dispose({bool isKeepAlive = false}) {
    super.dispose(isKeepAlive: isKeepAlive);
    disposeChannel();
    _webViewController?.dispose();
    _webViewController = null;
    pullToRefreshController?.dispose();
    findInteractionController?.dispose();
  }
}

extension InternalInAppBrowser on LinuxInAppBrowser {
  void setContextMenu(ContextMenu? contextMenu) {
    _contextMenu = contextMenu;
  }
}
