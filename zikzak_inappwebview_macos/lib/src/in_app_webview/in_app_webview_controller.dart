import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import '../print_job/print_job_controller.dart';

final _JAVASCRIPT_HANDLER_FORBIDDEN_NAMES = UnmodifiableListView<String>([
  "onLoadResource",
  "shouldInterceptAjaxRequest",
  "onAjaxReadyStateChange",
  "onAjaxProgress",
  "shouldInterceptFetchRequest",
  "onPrintRequest",
  "onWindowFocus",
  "onWindowBlur",
  "callAsyncJavaScript",
  "evaluateJavaScriptWithContentWorld",
]);

class MacOSInAppWebViewController extends PlatformInAppWebViewController {
  /// Mutable override for the context menu set via [setContextMenu].
  ///
  /// The construction-time [PlatformWebViewCreationParams.contextMenu] is
  /// `final`, so without this override, calling `setContextMenu(newMenu)`
  /// would update the native side but leave Dart-side event routing stuck on
  /// the old menu. Event handlers prefer this field, falling back to
  /// `webviewParams?.contextMenu` (mirroring the iOS port's fallback to
  /// `_inAppBrowser!.contextMenu`).
  ContextMenu? _contextMenu;

  /// Whether `setContextMenu` has been called at least once.
  ///
  /// Without this flag, an explicit `setContextMenu(null)` could not clear
  /// a construction-time `webviewParams.contextMenu`: the event handlers
  /// fell back to `webviewParams?.contextMenu` whenever `_contextMenu` was
  /// null, so the original menu kept receiving lifecycle callbacks forever.
  /// When true, the event handlers prefer `_contextMenu` (even if null)
  /// and skip the construction-time fallback.
  bool _contextMenuSet = false;

  MacOSInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) : super.implementation(params) {
    _channel = MethodChannel('dev.zuzu/zikzak_inappwebview_${params.id}');
    _channel.setMethodCallHandler((call) async {
      try {
        return await handleMethod(call);
      } on Error catch (e) {
        print(e);
        print(e.stackTrace);
      }
    });
  }

  MacOSInAppWebViewController.fromInAppBrowser(
    PlatformInAppWebViewControllerCreationParams params,
    MethodChannel channel,
  ) : super.implementation(params) {
    _channel = channel;
  }

  MacOSInAppWebViewController.static()
    : super.implementation(
        PlatformInAppWebViewControllerCreationParams(id: 'static'),
      );

  late MethodChannel _channel;
  Map<String, JavaScriptHandlerCallback> _javaScriptHandlersMap =
      HashMap<String, JavaScriptHandlerCallback>();

  Future<dynamic> handleMethod(MethodCall call) async {
    final controller = params.webviewParams?.controllerFromPlatform != null
        ? params.webviewParams!.controllerFromPlatform!(this)
        : this;

    switch (call.method) {
      case 'onLoadStart':
        if (params.webviewParams?.onLoadStart != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onLoadStart!(
            controller,
            url != null ? WebUri(url) : null,
          );
        }
        break;
      case 'onLoadStop':
        if (params.webviewParams?.onLoadStop != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onLoadStop!(
            controller,
            url != null ? WebUri(url) : null,
          );
        }
        break;
      case 'onPageCommitVisible':
        if (params.webviewParams?.onPageCommitVisible != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onPageCommitVisible!(
            controller,
            url != null ? WebUri(url) : null,
          );
        }
        break;
      case 'onDidReceiveServerRedirectForProvisionalNavigation':
        if (params
                .webviewParams
                ?.onDidReceiveServerRedirectForProvisionalNavigation !=
            null) {
          params
              .webviewParams!
              .onDidReceiveServerRedirectForProvisionalNavigation!(controller);
        }
        break;
      case 'onReceivedError':
        if (params.webviewParams?.onReceivedError != null) {
          String? url = call.arguments['url'];
          int code = call.arguments['code'];
          String message = call.arguments['message'];

          params.webviewParams!.onReceivedError!(
            controller,
            WebResourceRequest(url: url != null ? WebUri(url) : WebUri('')),
            WebResourceError(
              type:
                  WebResourceErrorType.fromNativeValue(code) ??
                  WebResourceErrorType.UNKNOWN,
              description: message,
            ),
          );
        }
        break;
      case 'onProgressChanged':
        if (params.webviewParams?.onProgressChanged != null) {
          int progress = call.arguments['progress'];
          params.webviewParams!.onProgressChanged!(controller, progress);
        }
        break;
      case 'onUpdateVisitedHistory':
        if (params.webviewParams?.onUpdateVisitedHistory != null) {
          String? url = call.arguments['url'];
          bool? isReload = call.arguments['isReload'];
          params.webviewParams!.onUpdateVisitedHistory!(
            controller,
            url != null ? WebUri(url) : null,
            isReload,
          );
        }
        break;
      case 'onTitleChanged':
        if (params.webviewParams?.onTitleChanged != null) {
          String? title = call.arguments['title'];
          params.webviewParams!.onTitleChanged!(controller, title);
        }
        break;
      case 'shouldOverrideUrlLoading':
        if (params.webviewParams?.shouldOverrideUrlLoading != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          var navigationAction = NavigationAction.fromMap(
            arguments['navigationAction'].cast<String, dynamic>(),
          )!;
          var policy = await params.webviewParams!.shouldOverrideUrlLoading!(
            controller,
            navigationAction,
          );
          return policy?.toNativeValue() ??
              NavigationActionPolicy.CANCEL.toNativeValue();
        }
        return NavigationActionPolicy.ALLOW.toNativeValue();
      case 'onCreateWindow':
        if (params.webviewParams?.onCreateWindow != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          CreateWindowAction? createWindowAction = CreateWindowAction.fromMap(
            arguments,
          );
          if (createWindowAction != null) {
            return await params.webviewParams!.onCreateWindow!(
              controller,
              createWindowAction,
            );
          }
        }
        break;
      case 'onCloseWindow':
        if (params.webviewParams?.onCloseWindow != null) {
          params.webviewParams!.onCloseWindow!(controller);
        }
        break;
      case 'onConsoleMessage':
        if (params.webviewParams?.onConsoleMessage != null) {
          var map =
              (call.arguments as Map<dynamic, dynamic>?)
                  ?.cast<String, dynamic>() ??
              {};
          var consoleMessage = ConsoleMessage(
            message: map['message'] as String? ?? '',
            messageLevel:
                ConsoleMessageLevel.fromNativeValue(map['messageLevel']) ??
                ConsoleMessageLevel.LOG,
          );
          params.webviewParams!.onConsoleMessage!(controller, consoleMessage);
        }
        break;
      case 'onReceivedHttpError':
        if (params.webviewParams?.onReceivedHttpError != null) {
          String? url = call.arguments['request']['url'];
          var request = WebResourceRequest(
            url: url != null ? WebUri(url) : WebUri(''),
          );
          var errorResponse = WebResourceResponse.fromMap(
            call.arguments['errorResponse'].cast<String, dynamic>(),
          )!;
          params.webviewParams!.onReceivedHttpError!(
            controller,
            request,
            errorResponse,
          );
        }
        break;
      case 'onWebContentProcessDidTerminate':
        if (params.webviewParams?.onWebContentProcessDidTerminate != null) {
          params.webviewParams!.onWebContentProcessDidTerminate!(controller);
        }
        break;
      case 'onJsAlert':
        if (params.webviewParams?.onJsAlert != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          var request = JsAlertRequest.fromJson(arguments);
          var response = await params.webviewParams!.onJsAlert!(
            controller,
            request,
          );
          return response?.toJson();
        }
        return null;
      case 'onJsConfirm':
        if (params.webviewParams?.onJsConfirm != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          var request = JsConfirmRequest.fromJson(arguments);
          var response = await params.webviewParams!.onJsConfirm!(
            controller,
            request,
          );
          return response?.toJson();
        }
        return null;
      case 'onJsPrompt':
        if (params.webviewParams?.onJsPrompt != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          var request = JsPromptRequest.fromJson(arguments);
          var response = await params.webviewParams!.onJsPrompt!(
            controller,
            request,
          );
          return response?.toJson();
        }
        return null;
      case 'callHandler':
        var map =
            (call.arguments as Map<dynamic, dynamic>?)
                ?.cast<String, dynamic>() ??
            {};
        String handlerName = map['handlerName'] as String? ?? '';
        String argsJson = map['args'] as String? ?? '[]';
        List<dynamic> args = <dynamic>[];
        try {
          args = jsonDecode(argsJson) as List<dynamic>;
        } catch (_) {}
        if (_javaScriptHandlersMap.containsKey(handlerName)) {
          try {
            return jsonEncode(await _javaScriptHandlersMap[handlerName]!(args));
          } catch (error, stacktrace) {
            debugPrint(error.toString() + '\n' + stacktrace.toString());
            throw Exception(error.toString().replaceFirst('Exception: ', ''));
          }
        }
        break;
      case 'onCreateContextMenu':
        ContextMenu? contextMenu = _contextMenuSet
            ? _contextMenu
            : webviewParams?.contextMenu;
        if (contextMenu != null && contextMenu.onCreateContextMenu != null) {
          Map<String, dynamic> arguments =
              (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();
          InAppWebViewHitTestResult hitTestResult =
              InAppWebViewHitTestResult.fromMap(arguments)!;
          contextMenu.onCreateContextMenu!(hitTestResult);
        }
        break;
      case 'onHideContextMenu':
        ContextMenu? contextMenu = _contextMenuSet
            ? _contextMenu
            : webviewParams?.contextMenu;
        if (contextMenu != null && contextMenu.onHideContextMenu != null) {
          contextMenu.onHideContextMenu!();
        }
        break;
      case 'onContextMenuActionItemClicked':
        ContextMenu? contextMenu = _contextMenuSet
            ? _contextMenu
            : webviewParams?.contextMenu;
        if (contextMenu != null) {
          dynamic id = call.arguments['id'];
          String title = call.arguments['title'];
          ContextMenuItem menuItemClicked = ContextMenuItem(
            id: id,
            title: title,
            action: null,
          );
          for (var menuItem in contextMenu.menuItems) {
            if (menuItem.id == id) {
              menuItemClicked = menuItem;
              if (menuItem.action != null) {
                menuItem.action!();
              }
              break;
            }
          }
          if (contextMenu.onContextMenuActionItemClicked != null) {
            contextMenu.onContextMenuActionItemClicked!(menuItemClicked);
          }
        }
        break;

      case 'onReceivedHttpAuthRequest':
        if (params.webviewParams?.onReceivedHttpAuthRequest != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          HttpAuthenticationChallenge challenge =
              HttpAuthenticationChallenge.fromMap(arguments)!;
          return (await params.webviewParams!.onReceivedHttpAuthRequest!(
            controller,
            challenge,
          ))?.toMap();
        }
        break;
      case 'onReceivedServerTrustAuthRequest':
        if (params.webviewParams?.onReceivedServerTrustAuthRequest != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          ServerTrustChallenge challenge = ServerTrustChallenge.fromMap(
            arguments,
          )!;
          return (await params.webviewParams!.onReceivedServerTrustAuthRequest!(
            controller,
            challenge,
          ))?.toMap();
        }
        break;
      case 'onReceivedClientCertRequest':
        if (params.webviewParams?.onReceivedClientCertRequest != null) {
          Map<String, dynamic> arguments = call.arguments
              .cast<String, dynamic>();
          ClientCertChallenge challenge = ClientCertChallenge.fromMap(
            arguments,
          )!;
          return (await params.webviewParams!.onReceivedClientCertRequest!(
            controller,
            challenge,
          ))?.toMap();
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    assert(
      !_JAVASCRIPT_HANDLER_FORBIDDEN_NAMES.contains(handlerName),
      '"$handlerName" is a forbidden name!',
    );
    _javaScriptHandlersMap[handlerName] = callback;
  }

  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) {
    return _javaScriptHandlersMap.remove(handlerName);
  }

  @override
  bool hasJavaScriptHandler({required String handlerName}) {
    return _javaScriptHandlersMap.containsKey(handlerName);
  }

  @override
  Future<WebUri?> getUrl() async {
    final String? url = await _channel.invokeMethod<String>('getUrl');
    return url != null ? WebUri(url) : null;
  }

  @override
  Future<String?> getTitle() async {
    return await _channel.invokeMethod<String>('getTitle');
  }

  @override
  Future<int?> getProgress() async {
    return await _channel.invokeMethod<int>('getProgress');
  }

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlRequest', () => urlRequest.toMap());
    args.putIfAbsent(
      'allowingReadAccessTo',
      () => allowingReadAccessTo.toString(),
    );
    await _channel.invokeMethod('loadUrl', args);
  }

  @override
  Future<void> setSettings({required InAppWebViewSettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('settings', () => settings.toMap());
    await _channel.invokeMethod('setSettings', args);
  }

  @override
  Future<InAppWebViewSettings?> getSettings() async {
    Map<dynamic, dynamic>? settings = await _channel.invokeMethod(
      'getSettings',
    );
    if (settings != null) {
      return InAppWebViewSettings.fromMap(settings.cast<String, dynamic>());
    }
    return null;
  }

  @override
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('data', () => data);
    args.putIfAbsent('mimeType', () => mimeType);
    args.putIfAbsent('encoding', () => encoding);
    args.putIfAbsent('baseUrl', () => baseUrl?.toString() ?? "about:blank");
    args.putIfAbsent(
      'historyUrl',
      () => historyUrl?.toString() ?? "about:blank",
    );
    args.putIfAbsent(
      'allowingReadAccessTo',
      () => allowingReadAccessTo?.toString(),
    );
    await _channel.invokeMethod('loadData', args);
  }

  @override
  Future<String?> getHtml() async {
    return await _channel.invokeMethod<String>('getHtml');
  }

  @override
  Future<Uint8List?> createPdf({PDFConfiguration? pdfConfiguration}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('pdfConfiguration', () => pdfConfiguration?.toMap());
    return await _channel.invokeMethod<Uint8List?>('createPdf', args);
  }

  @override
  Future<Uint8List?> takeScreenshot({
    ScreenshotConfiguration? screenshotConfiguration,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent(
      'screenshotConfiguration',
      () => screenshotConfiguration?.toMap(),
    );
    return await _channel.invokeMethod<Uint8List?>('takeScreenshot', args);
  }

  @override
  Future<void> reload() async {
    await _channel.invokeMethod('reload');
  }

  @override
  Future<void> goBack() async {
    await _channel.invokeMethod('goBack');
  }

  @override
  Future<bool> canGoBack() async {
    return await _channel.invokeMethod<bool>('canGoBack') ?? false;
  }

  @override
  Future<void> goForward() async {
    await _channel.invokeMethod('goForward');
  }

  @override
  Future<bool> canGoForward() async {
    return await _channel.invokeMethod<bool>('canGoForward') ?? false;
  }

  @override
  Future<bool> isLoading() async {
    return await _channel.invokeMethod<bool>('isLoading') ?? false;
  }

  @override
  Future<void> stopLoading() async {
    await _channel.invokeMethod('stopLoading');
  }

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('source', () => source);
    args.putIfAbsent('contentWorld', () => contentWorld?.toMap());
    return await _channel.invokeMethod('evaluateJavascript', args);
  }

  @override
  Future<MacOSPrintJobController?> printCurrentPage({
    PrintJobSettings? settings,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("settings", () => settings?.toMap());
    String? jobId = await _channel.invokeMethod<String?>(
      'printCurrentPage',
      args,
    );
    if (jobId != null) {
      return MacOSPrintJobController(
        PlatformPrintJobControllerCreationParams(id: jobId),
      );
    }
    return null;
  }

  @override
  Future<void> setContextMenu(ContextMenu? contextMenu) async {
    // Keep the Dart-side reference in sync so subsequent onCreateContextMenu /
    // onHideContextMenu / onContextMenuActionItemClicked events route to the
    // new menu's callbacks (the construction-time webviewParams.contextMenu
    // is final and cannot be updated).
    _contextMenu = contextMenu;
    // Mark that setContextMenu was explicitly called. Without this, an
    // explicit setContextMenu(null) could not clear a construction-time
    // menu — see _contextMenuSet docs above.
    _contextMenuSet = true;
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("contextMenu", () => contextMenu?.toMap());
    await _channel.invokeMethod('setContextMenu', args);
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    if (!isKeepAlive) {
      _channel.setMethodCallHandler(null);
      _javaScriptHandlersMap.clear();
    }
  }
}
