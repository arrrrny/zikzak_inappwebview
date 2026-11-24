import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// One Dart controller and event handler per native ArkWeb instance.
class OhosInAppWebViewController extends PlatformInAppWebViewController {
  OhosInAppWebViewController(super.params) : super.implementation() {
    _channel.setMethodCallHandler(_event);
  }

  late final MethodChannel _channel = MethodChannel('wtf.zikzak/arkweb_$id');
  final Map<String, JavaScriptHandlerCallback> _handlers = {};
  bool _disposed = false;
  dynamic get _publicController =>
      webviewParams?.controllerFromPlatform?.call(this) ?? this;

  /// The widget registers its controller and callbacks before native loading starts.
  Future<void> startInitialLoad() => _invoke<void>('startInitialLoad');

  Future<T?> _invoke<T>(String method, [Map<String, dynamic> args = const {}]) {
    if (_disposed) throw StateError('WebView has been disposed');
    return _channel.invokeMethod<T>(method, jsonEncode(args));
  }

  Future<dynamic> _event(MethodCall call) async {
    if (_disposed) return null;
    final data = Map<String, dynamic>.from(
      jsonDecode(call.arguments as String) as Map,
    );
    final callbacks = webviewParams;
    final controller = _publicController;
    switch (call.method) {
      case 'onLoadStart':
        callbacks?.onLoadStart?.call(controller, WebUri(data['url'] as String));
      case 'onLoadStop':
        callbacks?.onLoadStop?.call(controller, WebUri(data['url'] as String));
      case 'onProgressChanged':
        callbacks?.onProgressChanged?.call(controller, data['progress'] as int);
      case 'onTitleChanged':
        callbacks?.onTitleChanged?.call(controller, data['title'] as String);
      case 'onUpdateVisitedHistory':
        callbacks?.onUpdateVisitedHistory?.call(
          controller,
          WebUri(data['url'] as String),
          data['isReload'] as bool? ?? false,
        );
      case 'onConsoleMessage':
        callbacks?.onConsoleMessage?.call(
          controller,
          ConsoleMessage(
            message: data['message'] as String,
            messageLevel: switch (data['level']) {
              1 => ConsoleMessageLevel.DEBUG,
              3 => ConsoleMessageLevel.WARNING,
              4 => ConsoleMessageLevel.ERROR,
              _ => ConsoleMessageLevel.LOG,
            },
          ),
        );
      case 'onReceivedError':
        callbacks?.onReceivedError?.call(
          controller,
          WebResourceRequest(
            url: WebUri(data['url'] as String),
            isForMainFrame: data['isMainFrame'] as bool?,
          ),
          WebResourceError(
            description: data['description'] as String,
            type: WebResourceErrorType.UNKNOWN,
          ),
        );
      case 'onReceivedHttpError':
        callbacks?.onReceivedHttpError?.call(
          controller,
          WebResourceRequest(
            url: WebUri(data['url'] as String),
            isForMainFrame: data['isMainFrame'] as bool?,
          ),
          WebResourceResponse(statusCode: data['statusCode'] as int),
        );
      case 'shouldOverrideUrlLoading':
        final action = await callbacks?.shouldOverrideUrlLoading?.call(
          controller,
          NavigationAction(
            request: URLRequest(
              url: WebUri(data['url'] as String),
              method: data['method'] as String?,
              headers: (data['headers'] as Map?)?.cast<String, String>(),
            ),
            isForMainFrame: data['isMainFrame'] as bool? ?? true,
          ),
        );
        return action != NavigationActionPolicy.CANCEL;
      case 'onPermissionRequest':
        final resources = (data['resources'] as List)
            .map(
              (value) => switch (value) {
                'VIDEO' => PermissionResourceType.CAMERA,
                'AUDIO' => PermissionResourceType.MICROPHONE,
                _ => PermissionResourceType.PROTECTED_MEDIA_ID,
              },
            )
            .toList();
        final response = await callbacks?.onPermissionRequest?.call(
          controller,
          PermissionRequest(
            origin: WebUri(data['origin'] as String),
            resources: resources,
          ),
        );
        if (response?.action != PermissionResponseAction.GRANT) {
          return <String>[];
        }
        return <String>[
          if (response!.resources?.contains(PermissionResourceType.CAMERA) ??
              false)
            'VIDEO',
          if (response.resources?.contains(PermissionResourceType.MICROPHONE) ??
              false)
            'AUDIO',
        ];
      case 'onGeolocationPermissionsShowPrompt':
        final response = await callbacks?.onGeolocationPermissionsShowPrompt
            ?.call(controller, data['origin'] as String);
        return response?.allow ?? false;
      case 'onCallJsHandler':
        final callback = _handlers[data['handlerName']];
        if (callback == null) throw StateError('Unknown JavaScript handler');
        return jsonEncode(
          await callback(List<dynamic>.from(data['args'] as List)),
        );
    }
    return null;
  }

  @override
  Future<WebUri?> getUrl() async {
    final value = await _invoke<String>('getUrl');
    return value == null ? null : WebUri(value);
  }

  @override
  Future<String?> getTitle() => _invoke<String>('getTitle');
  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) => _invoke<void>('loadUrl', urlRequest.toJson());
  @override
  Future<void> loadData({
    required String data,
    String mimeType = 'text/html',
    String encoding = 'utf8',
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) => _invoke<void>('loadData', {
    'data': data,
    'mimeType': mimeType,
    'encoding': encoding,
    'baseUrl': baseUrl?.toString(),
    'historyUrl': historyUrl?.toString(),
  });
  @override
  Future<void> loadFile({required String assetFilePath}) =>
      _invoke<void>('loadFile', {'assetFilePath': assetFilePath});
  @override
  Future<void> postUrl({required WebUri url, required Uint8List postData}) =>
      _invoke<void>('postUrl', {
        'url': url.toString(),
        'body': postData.toList(),
      });
  @override
  Future<void> reload() => _invoke<void>('reload');
  @override
  Future<void> stopLoading() => _invoke<void>('stopLoading');
  @override
  Future<bool> canGoBack() async => await _invoke<bool>('canGoBack') ?? false;
  @override
  Future<bool> canGoForward() async =>
      await _invoke<bool>('canGoForward') ?? false;
  @override
  Future<void> goBack() => _invoke<void>('goBack');
  @override
  Future<void> goForward() => _invoke<void>('goForward');
  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    if (contentWorld != null && contentWorld != ContentWorld.PAGE) {
      throw UnsupportedError(
        'ArkWeb isolated content worlds are not implemented',
      );
    }
    final value = await _invoke<String>('evaluateJavascript', {
      'source': source,
    });
    return value == null || value == 'undefined' ? null : jsonDecode(value);
  }

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) => _handlers[handlerName] = callback;
  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) => _handlers.remove(handlerName);
  @override
  bool hasJavaScriptHandler({required String handlerName}) =>
      _handlers.containsKey(handlerName);
  @override
  Future<void> addUserScript({required UserScript userScript}) async {
    await _invoke<void>('addUserScript', userScript.toJson());
  }

  @override
  Future<bool> removeUserScript({required UserScript userScript}) async {
    final removed =
        await _invoke<bool>('removeUserScript', userScript.toJson()) ?? false;
    return removed;
  }

  @override
  Future<void> addUserScripts({required List<UserScript> userScripts}) async {
    for (final script in userScripts) {
      await addUserScript(userScript: script);
    }
  }

  @override
  Future<void> removeAllUserScripts() async {
    await _invoke<void>('removeAllUserScripts');
  }

  @override
  Future<void> setSettings({required InAppWebViewSettings settings}) =>
      _invoke<void>('setSettings', settings.toJson());
  @override
  Future<InAppWebViewSettings?> getSettings() async {
    final result = await _invoke<String>('getSettings');
    return result == null
        ? null
        : InAppWebViewSettings.fromJson(
            Map<String, dynamic>.from(jsonDecode(result) as Map),
          );
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    if (_disposed) return;
    // Release the native view first: `_invoke` refuses once `_disposed` is set,
    // and the ArkTS side is the only place that unregisters the JS bridge and
    // stops the controller. A controller disposed apart from its widget would
    // otherwise leave the native WebView attached and still loading.
    if (!isKeepAlive) {
      unawaited(
        _channel.invokeMethod<void>('dispose').catchError((Object _) {}),
      );
    }
    _disposed = true;
    _handlers.clear();
    _channel.setMethodCallHandler(null);
  }
}
