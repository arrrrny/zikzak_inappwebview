import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Names reserved by the platform and not allowed for user-registered
/// JavaScript handlers. Mirrors the lists used by the Android, iOS, macOS
/// and Linux implementations so behaviour stays consistent across platforms.
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

class InAppWebViewWindowsController extends PlatformInAppWebViewController {
  final WebviewController _controller;

  /// Handlers registered through [addJavaScriptHandler], keyed by name.
  final Map<String, JavaScriptHandlerCallback> _javaScriptHandlersMap = {};

  StreamSubscription<dynamic>? _webMessageSubscription;

  /// Whether the JavaScript handler bridge has already been installed on the
  /// underlying [WebviewController]. The bridge is idempotent so it is safe to
  /// install it only once.
  bool _isJsBridgeInstalled = false;

  InAppWebViewWindowsController(
    PlatformInAppWebViewControllerCreationParams params,
    this._controller,
  ) : super.implementation(params);

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
    _ensureJavaScriptHandlerBridge();
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

  /// Installs (once) the JavaScript bridge that exposes
  /// `window.zikzak_inappwebview.callHandler(handlerName, ...args)` and wires
  /// the incoming [WebviewController.webMessage] stream to the registered
  /// Dart handlers. The bridge follows the same contract documented by the
  /// platform interface (see [PlatformInAppWebViewController.addJavaScriptHandler]):
  /// `callHandler` returns a `Promise` that resolves with the JSON-encoded
  /// value returned by the Dart callback, and the
  /// `flutterInAppWebViewPlatformReady` event is dispatched once the bridge
  /// is available.
  void _ensureJavaScriptHandlerBridge() {
    if (_isJsBridgeInstalled) return;
    _isJsBridgeInstalled = true;
    _webMessageSubscription = _controller.webMessage.listen(
      _dispatchWebMessage,
      onError: (_) {
        // Ignore malformed messages — they are not part of the handler
        // protocol and must not crash the webview.
      },
    );
    // Inject the bridge on every new document so it survives navigation.
    // The script is idempotent (guards against double installation).
    const bridge = r'''
(function() {
  if (window.zikzak_inappwebview && window.zikzak_inappwebview._isZikzakBridge) {
    return;
  }
  var pending = {};
  var nextCallId = 0;
  function asArray(value) {
    if (Array.isArray(value)) return value;
    return [];
  }
  window.zikzak_inappwebview = {
    _isZikzakBridge: true,
    callHandler: function(handlerName) {
      var args = asArray(Array.prototype.slice.call(arguments, 1));
      return new Promise(function(resolve, reject) {
        var callId = ++nextCallId;
        pending[callId] = { resolve: resolve, reject: reject };
        try {
          window.chrome.webview.postMessage(JSON.stringify({
            _zikzakHandlerCall: true,
            callId: callId,
            handlerName: handlerName,
            args: args
          }));
        } catch (e) {
          delete pending[callId];
          reject(e);
        }
      });
    }
  };
  window._zikzakInAppWebViewResolveHandler = function(callId, success, jsonResult) {
    var entry = pending[callId];
    if (!entry) return;
    delete pending[callId];
    var value = null;
    if (jsonResult != null) {
      try { value = JSON.parse(jsonResult); }
      catch (e) {
        if (success) { entry.resolve(null); } else { entry.reject(new Error("Failed to parse handler result")); }
        return;
      }
    }
    if (success) { entry.resolve(value); } else { entry.reject(value); }
  };
  window.dispatchEvent(new Event("flutterInAppWebViewPlatformReady"));
})();
''';
    try {
      _controller
          .addScriptToExecuteOnDocumentCreated(bridge)
          .catchError((Object _) => null);
      // Best-effort: if injection fails (e.g. controller disposed), the
      // bridge simply won't be available and JS calls will reject — but
      // addJavaScriptHandler itself must not throw.
    } catch (_) {
      // Same as above — never propagate injection errors to the caller.
    }
  }

  void _dispatchWebMessage(dynamic message) {
    Map<dynamic, dynamic>? payload;
    if (message is Map) {
      payload = message;
    } else if (message is String) {
      try {
        final decoded = jsonDecode(message);
        if (decoded is Map) payload = decoded;
      } catch (_) {
        return;
      }
    } else {
      return;
    }
    if (payload == null) return;
    if (payload['_zikzakHandlerCall'] != true) return;
    final handlerName = payload['handlerName'];
    if (handlerName is! String) return;
    final callId = payload['callId'];
    final rawArgs = payload['args'];
    final args = rawArgs is List ? rawArgs : <dynamic>[];
    final handler = _javaScriptHandlersMap[handlerName];
    if (handler == null) {
      _reply(callId, false, 'Handler "$handlerName" is not registered');
      return;
    }
    dynamic result;
    try {
      result = handler(args);
    } catch (e) {
      _reply(callId, false, e.toString());
      return;
    }
    if (result is Future) {
      result
          .then((Object? value) {
            _reply(callId, true, value);
          })
          .catchError((Object error) {
            _reply(callId, false, error.toString());
          });
    } else {
      _reply(callId, true, result);
    }
  }

  void _reply(dynamic callId, bool success, dynamic result) {
    String jsonResult;
    try {
      jsonResult = jsonEncode(result);
    } catch (_) {
      jsonResult = 'null';
    }
    final js =
        'window._zikzakInAppWebViewResolveHandler && '
        'window._zikzakInAppWebViewResolveHandler('
        '${jsonEncode(callId)}, ${success ? 'true' : 'false'}, '
        '${jsonEncode(jsonResult)});';
    try {
      _controller.executeScript(js).catchError((Object _) {
        // Best-effort delivery — ignore failures.
      });
    } catch (_) {
      // Ignore — controller may be disposed between calls.
    }
  }

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) async {
    if (urlRequest.url != null) {
      await _controller.loadUrl(urlRequest.url.toString());
    }
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
    final dataUri = Uri.dataFromString(
      data,
      mimeType: mimeType,
      encoding: Encoding.getByName(encoding),
    ).toString();
    await _controller.loadUrl(dataUri);
  }

  @override
  Future<void> loadFile({required String assetFilePath}) async {
    final assetsDir = p.join(
      p.dirname(Platform.resolvedExecutable),
      'data',
      'flutter_assets',
    );
    final filePath = p.join(assetsDir, assetFilePath);

    // Windows file uri
    final fileUri = Uri.file(filePath).toString();
    await _controller.loadUrl(fileUri);
  }

  @override
  Future<WebUri?> getUrl() async {
    // Return null as we can't synchronously get the current URL without tracking it
    // and we don't want to block on the stream.
    // TODO: Implement URL tracking
    return null;
  }

  @override
  Future<String?> getTitle() async {
    return await _controller.title.first;
  }

  @override
  Future<int?> getProgress() async {
    return 100; // Placeholder
  }

  @override
  Future<String?> getHtml() async {
    final result = await evaluateJavascript(
      source: "document.documentElement.outerHTML",
    );
    return result?.toString();
  }

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    return await _controller.executeScript(source);
  }

  @override
  Future<void> reload() async {
    await _controller.reload();
  }

  @override
  Future<void> goBack() async {
    await _controller.goBack();
  }

  @override
  Future<Uint8List?> takeScreenshot({
    ScreenshotConfiguration? screenshotConfiguration,
  }) async {
    return null;
  }

  @override
  Future<Uint8List?> createPdf({PDFConfiguration? pdfConfiguration}) async {
    // TODO: Implement createPdf for Windows when webview_windows supports it
    return null;
  }

  @override
  Future<void> goForward() async {
    await _controller.goForward();
  }

  @override
  Future<void> stopLoading() async {
    await _controller.stop();
  }

  @override
  Future<PlatformPrintJobController?> printCurrentPage({
    PrintJobSettings? settings,
  }) async {
    // TODO: Implement printCurrentPage for Windows
    return null;
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    _webMessageSubscription?.cancel();
    _webMessageSubscription = null;
    _javaScriptHandlersMap.clear();
    if (!isKeepAlive) {
      try {
        // Only dispose the underlying WebviewController when it has actually
        // been initialized; calling dispose on a never-initialized controller
        // throws a LateInitializationError inside the webview_windows package.
        if (_controller.value.isInitialized) {
          _controller.dispose();
        }
      } catch (_) {
        // Best-effort — never let cleanup crash the host.
      }
    }
  }
}
