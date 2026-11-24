import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Maps ArkWeb's net-error stack codes (`WebNetErrorList`, which mirror
/// Chromium's `net_error_list.h`) onto the cross-platform error taxonomy, so
/// an app can tell a DNS failure from a TLS failure instead of string-matching
/// `description`. Codes with no faithful equivalent stay
/// [WebResourceErrorType.UNKNOWN].
WebResourceErrorType _errorTypeFromCode(int? code) => switch (code) {
  // Files and local access.
  -6 => WebResourceErrorType.FILE_NOT_FOUND,
  -10 => WebResourceErrorType.NO_PERMISSIONS_TO_READ_FILE,
  // Timeouts.
  -7 || -118 || -803 => WebResourceErrorType.TIMEOUT,
  // Transport.
  -21 || -100 || -101 || -103 => WebResourceErrorType.NETWORK_CONNECTION_LOST,
  -102 || -104 || -109 => WebResourceErrorType.CANNOT_CONNECT_TO_HOST,
  -105 || -137 => WebResourceErrorType.HOST_LOOKUP,
  -106 || -138 => WebResourceErrorType.NOT_CONNECTED_TO_INTERNET,
  // TLS.
  -107 || -113 || -218 => WebResourceErrorType.FAILED_SSL_HANDSHAKE,
  -110 || -502 => WebResourceErrorType.CLIENT_CERTIFICATE_REQUIRED,
  -117 => WebResourceErrorType.CLIENT_CERTIFICATE_REJECTED,
  -200 ||
  -202 ||
  -206 ||
  -207 ||
  -208 ||
  -210 ||
  -211 ||
  -214 => WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED,
  -201 || -213 => WebResourceErrorType.SERVER_CERTIFICATE_HAS_BAD_DATE,
  -501 => WebResourceErrorType.SECURE_CONNECTION_FAILED,
  // URLs and redirects.
  -300 => WebResourceErrorType.BAD_URL,
  -301 || -302 => WebResourceErrorType.UNSUPPORTED_SCHEME,
  -310 => WebResourceErrorType.TOO_MANY_REDIRECTS,
  -311 || -312 => WebResourceErrorType.UNSAFE_RESOURCE,
  // Authentication.
  -323 => WebResourceErrorType.PROXY_AUTHENTICATION,
  -338 => WebResourceErrorType.USER_AUTHENTICATION_FAILED,
  -339 => WebResourceErrorType.UNSUPPORTED_AUTH_SCHEME,
  -341 => WebResourceErrorType.USER_AUTHENTICATION_REQUIRED,
  // Server responses.
  -379 => WebResourceErrorType.BAD_SERVER_RESPONSE,
  _ => WebResourceErrorType.UNKNOWN,
};

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
  Future<void> startInitialLoad() async {
    try {
      await _invoke<void>('startInitialLoad');
    } catch (error, stack) {
      // Removing the widget cancels a pending native bootstrap load.
      if (!_disposed) Error.throwWithStackTrace(error, stack);
    }
  }

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
            type: _errorTypeFromCode(data['errorCode'] as int?),
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
    // The platform-view owner may already have removed its native handler.
    // Swallowing is deliberately limited to that case: any other native
    // dispose failure (e.g. a PlatformException) is intentionally left to
    // surface rather than being hidden during teardown, so a real cleanup
    // problem is not silently masked.
    if (!isKeepAlive) {
      unawaited(
        _channel
            .invokeMethod<void>('dispose')
            .onError<MissingPluginException>((_, _) {}),
      );
    }
    _disposed = true;
    _handlers.clear();
    _channel.setMethodCallHandler(null);
  }
}
