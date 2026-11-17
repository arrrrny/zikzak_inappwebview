import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:zikzak_webview_windows/zikzak_webview_windows.dart';
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
  final PlatformInAppWebViewControllerCreationParams _creationParams;
  final WebviewController _controller;

  /// The app-facing controller handed to `shouldOverrideUrlLoading` and the
  /// other `params` callbacks.
  ///
  /// In the federated plugin this is the wrapper `zikzak_inappwebview` returns
  /// from `controllerFromPlatform` (not this platform controller). It is
  /// resolved lazily on first access — the same value the Android
  /// implementation caches in its constructor — and cached, so a controller
  /// built through any path has a non-null value to pass to the callbacks. It
  /// is `dynamic` because the wrapper does not implement
  /// [PlatformInAppWebViewController] (see the note on
  /// `dispatchLoadingStateChange`).
  dynamic _callbackController;

  /// The value passed to the navigation callback; see [_callbackController].
  dynamic get callbackController =>
      _callbackController ??=
          _creationParams.webviewParams?.controllerFromPlatform?.call(this) ??
          this;

  /// Handlers registered through [addJavaScriptHandler], keyed by name.
  final Map<String, JavaScriptHandlerCallback> _javaScriptHandlersMap = {};

  StreamSubscription<dynamic>? _webMessageSubscription;
  StreamSubscription<Map<String, dynamic>>? _devToolsProtocolSubscription;
  final Map<String, Map<String, String>> _pendingRequestHeaders = {};
  final Map<String, String> _pendingHtmlDocuments = {};
  /// User scripts registered with WebView2, keyed by [UserScript] value.
  ///
  /// The value is a LIST of ids, not a single id: WebView2 registers a script
  /// on every `addScriptToExecuteOnDocumentCreated` call and the same
  /// [UserScript] value can be added more than once (a rebuild, a
  /// re-registered `initialUserScripts` list), producing several ids that must
  /// all be removed to fully unregister it.
  final Map<UserScript, List<ScriptID>> _userScriptIds = {};
  final Map<String, Function(dynamic data)> _devToolsProtocolCallbacks = {};

  /// Whether `Fetch` interception is currently enabled on the underlying
  /// controller. It is turned on only while a navigation has headers to inject
  /// or a navigation-policy callback to consult, and turned back off once the
  /// pending work is consumed, so a fully idle webview never pays the
  /// pause → Dart → continue round-trip.
  bool _fetchEnabled = false;

  /// Whether the `Fetch.requestPaused` DevTools listener is currently
  /// registered with WebView2.
  ///
  /// WebView2 refuses a duplicate registration (its native
  /// `AddDevToolsProtocolEventListener` returns `false` when the event is
  /// already registered, surfacing as a `PlatformException(method_failed)`), so
  /// the listener is owned by the controller and registered exactly once for
  /// the lifetime of the webview rather than re-added on every fetch-enabled
  /// load. See [_ensureFetchListener].
  bool _fetchListenerAdded = false;

  /// Registers the `Fetch.requestPaused` DevTools listener once.
  ///
  /// A second [WebviewController.addDevToolsProtocolEventListener] for an event
  /// that is already registered throws on the native side, so every caller must
  /// go through this guard instead of calling the controller directly.
  Future<void> _ensureFetchListener() async {
    if (_fetchListenerAdded) return;
    await _controller.addDevToolsProtocolEventListener('Fetch.requestPaused');
    _fetchListenerAdded = true;
  }
  Future<void> _fetchOperations = Future<void>.value();

  Future<void> _withFetch(Future<void> Function() operation) {
    final result = _fetchOperations.then((_) => operation());
    // Keep the queue usable; the returned future still reports the failure.
    _fetchOperations = result.catchError((Object _) {});
    return result;
  }

  /// Whether the JavaScript handler bridge has already been installed on the
  /// underlying [WebviewController]. The bridge is idempotent so it is safe to
  /// install it only once.
  bool _isJsBridgeInstalled = false;

  /// Navigation state mirrored off the [WebviewController] event streams.
  ///
  /// `webview_windows` publishes the current URL, the loading state and the
  /// history depth only as events, with no synchronous getter, while the
  /// platform interface asks for them on demand ([getUrl], [getProgress],
  /// [canGoBack], [canGoForward]). `url` and `historyChanged` are also
  /// single-subscription streams, so this controller — the long-lived owner of
  /// the [WebviewController] — has to be the one listener that caches them.
  /// `loadingState` is a broadcast stream, so the widget keeps its own
  /// subscription there for dispatching the load callbacks.
  String? _currentUrl;
  int _progress = 0;
  bool _canGoBack = false;
  bool _canGoForward = false;

  StreamSubscription<String>? _urlSubscription;
  StreamSubscription<LoadingState>? _loadingStateSubscription;
  StreamSubscription<HistoryChanged>? _historyChangedSubscription;

  InAppWebViewWindowsController(
    PlatformInAppWebViewControllerCreationParams params,
    this._controller,
  ) : _creationParams = params,
      super.implementation(params) {
    _urlSubscription = _controller.url.listen((url) => _currentUrl = url);
    _loadingStateSubscription = _controller.loadingState.listen((state) {
      // webview_windows reports no granular percentage, so mirror the same
      // 0 -> 100 mapping dispatchLoadingStateChange already reports to
      // onProgressChanged.
      _progress = switch (state) {
        LoadingState.loading => 0,
        LoadingState.navigationCompleted => 100,
        LoadingState.none => _progress,
      };
    });
    _historyChangedSubscription = _controller.historyChanged.listen((history) {
      _canGoBack = history.canGoBack;
      _canGoForward = history.canGoForward;
    });
    _devToolsProtocolSubscription = _controller.devToolsProtocolEvent.listen(
      _handleDevToolsProtocolEvent,
    );
  }

  /// The most recent URL reported by the `urlChanged` event, or null before the
  /// first navigation.
  ///
  /// The widget reads this instead of subscribing to
  /// [WebviewController.url] itself: that stream is single-subscription, and
  /// sharing one cache keeps the URL handed to `onLoadStart`/`onLoadStop` and
  /// the URL returned by [getUrl] from drifting apart.
  String? get currentUrl => _currentUrl;

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

  void _handleDevToolsProtocolEvent(Map<String, dynamic> event) {
    final eventName = event['eventName'];
    // Schedule internal handling before calling application listeners, which
    // may throw. They must not prevent a paused request from being settled.
    if (eventName == 'Fetch.requestPaused') {
      final data = event['data'];
      if (data is Map && data['requestId'] is String) {
        unawaited(_withFetch(() => _continueRequest(data)));
      }
    }
    if (eventName is String) {
      _devToolsProtocolCallbacks[eventName]?.call(event['data']);
    }
  }

  Future<void> _continueRequest(Map data) async {
    final requestId = data['requestId'];
    // Without a request id there is nothing to resume. Every other guard
    // degrades to "continue with the original request": a malformed or
    // unexpectedly-shaped event must never leave a paused navigation hanging
    // (white screen, no timeout, no recovery).
    if (requestId is! String) return;

    final request = data['request'];
    final url = request is Map ? request['url'] : null;
    if (url is String) {
      final html = _pendingHtmlDocuments.remove(_canonicalKeyFor(url));
      if (html != null) {
        await _controller.callDevToolsProtocolMethod('Fetch.fulfillRequest', {
          'requestId': requestId,
          'responseCode': 200,
          'responseHeaders': [
            {'name': 'Content-Type', 'value': 'text/html; charset=utf-8'},
            {'name': 'Cache-Control', 'value': 'no-store'},
          ],
          'body': base64Encode(utf8.encode(html)),
        });
        await _finishFetchIfIdle();
        return;
      }
    }

    final navigationCallback =
        _creationParams.webviewParams?.shouldOverrideUrlLoading;
    if (navigationCallback != null && url is String) {
      // `Fetch.requestPaused` carries a `frameId` but no `isForMainFrame`, and
      // the `Document` resource type also matches iframe navigations. WebView2
      // does not surface the main-frame id on this event, so an empty frameId
      // (Chromium reports none for the top-level document request) is treated as
      // main frame and any real frameId as a subframe. This is an approximation,
      // not the derived id the review suggested, which is tracked as a follow-up
      // on PR #443.
      final frameId = data['frameId'];
      final isForMainFrame = frameId == null || frameId == '';
      final policy = await navigationCallback(
        callbackController,
        NavigationAction(
          request: URLRequest(url: WebUri(url)),
          isForMainFrame: isForMainFrame,
        ),
      );
      if (policy == NavigationActionPolicy.CANCEL) {
        // Consume the cancelled request's pending headers before returning:
        // the navigation is gone, and leaving them armed would leak an auth
        // header into a later navigation to the same URL.
        _pendingRequestHeaders.remove(_canonicalKeyFor(url));
        await _controller.callDevToolsProtocolMethod('Fetch.failRequest', {
          'requestId': requestId,
          'errorReason': 'Aborted',
        });
        await _finishFetchIfIdle();
        return;
      }
    }

    var headers = <String, dynamic>{};
    if (request is Map) {
      final requestHeaders = request['headers'];
      if (requestHeaders is Map) {
        headers.addAll(
          requestHeaders.map((key, value) => MapEntry(key.toString(), value)),
        );
      }
      final requestUrl = request['url'];
      if (requestUrl is String) {
        final extra =
            _pendingRequestHeaders.remove(_canonicalKeyFor(requestUrl)) ??
            const <String, String>{};
        for (final entry in extra.entries) {
          headers.removeWhere(
            (key, _) => key.toLowerCase() == entry.key.toLowerCase(),
          );
          headers[entry.key] = entry.value;
        }
      }
    }
    try {
      await _controller.callDevToolsProtocolMethod(
        'Fetch.continueRequest',
        <String, dynamic>{
          'requestId': requestId,
          if (headers.isNotEmpty)
            'headers': headers.entries
                .map((entry) => {'name': entry.key, 'value': entry.value})
                .toList(),
        },
      );
    } catch (_) {
      // Terminate the request rather than silently retrying it without headers.
      try {
        await _controller.callDevToolsProtocolMethod('Fetch.failRequest', {
          'requestId': requestId,
          'errorReason': 'Failed',
        });
      } catch (_) {
        // If the CDP request can no longer be addressed, cancel navigation at
        // the native WebView2 boundary. A failure here remains observable.
        await _controller.stop();
      }
    }
    await _finishFetchIfIdle();
  }

  Future<void> _finishFetchIfIdle() async {
    if (_pendingRequestHeaders.isEmpty && _pendingHtmlDocuments.isEmpty) {
      await _disableFetch();
    }
  }

  /// Normalizes a URL for [_pendingRequestHeaders] matching.
  ///
  /// WebView2 reports `Fetch.requestPaused` URLs in Chromium's canonical form
  /// (an empty path becomes `/`, a default port is elided), while
  /// [Uri.toString] preserves whatever the caller wrote. Keying the map by this
  /// form on both the store and the lookup keeps the two sides matching.
  String _canonicalRequestUrl(Uri uri) {
    final parsed = Uri.parse(uri.toString());
    return parsed
        .replace(path: parsed.path.isEmpty ? '/' : parsed.path, fragment: '')
        .toString();
  }

  /// [_canonicalRequestUrl] for a URL that arrived as a string, falling back to
  /// the raw string when it cannot be parsed (it can then only match itself).
  String _canonicalKeyFor(String url) {
    try {
      return _canonicalRequestUrl(Uri.parse(url));
    } catch (_) {
      return url;
    }
  }

  /// Change local state only after WebView2 acknowledges the transition.
  Future<void> _disableFetch() async {
    if (!_fetchEnabled) return;
    await _controller.callDevToolsProtocolMethod('Fetch.disable', {});
    _fetchEnabled = false;
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
    final url = urlRequest.url;
    if (url == null) return;
    final headers = urlRequest.headers;
    final hasHeaders = headers != null && headers.isNotEmpty;
    final hasNavigationCallback =
        _creationParams.webviewParams?.shouldOverrideUrlLoading != null;
    await _withFetch(() async {
      _pendingRequestHeaders.clear();
      // A new top-level navigation supersedes any outstanding loadData(baseUrl:)
      // that never delivered its requestPaused event; leaving the stale document
      // armed would fulfill a later navigation to the same URL with it.
      _pendingHtmlDocuments.clear();
      if (hasHeaders || hasNavigationCallback) {
        await _ensureFetchListener();
        await _controller.callDevToolsProtocolMethod('Fetch.enable', {
          'patterns': [
            {'resourceType': 'Document', 'requestStage': 'Request'},
          ],
        });
        _fetchEnabled = true;
        if (hasHeaders) {
          _pendingRequestHeaders[_canonicalRequestUrl(url)] = Map.of(headers);
        }
      } else {
        await _disableFetch();
      }
      try {
        await _controller.loadUrl(url.toString());
      } catch (_) {
        _pendingRequestHeaders.clear();
        await _disableFetch();
        rethrow;
      }
    });
  }

  @override
  Future<dynamic> callDevToolsProtocolMethod({
    required String methodName,
    Map<String, dynamic>? parameters,
  }) => _controller.callDevToolsProtocolMethod(methodName, parameters);

  @override
  Future<void> addDevToolsProtocolEventListener({
    required String eventName,
    required Function(dynamic data) callback,
  }) async {
    _devToolsProtocolCallbacks[eventName] = callback;
    // The navigation interceptor registers the `Fetch.requestPaused` listener
    // itself; routing it through the guard keeps the native registration
    // idempotent instead of throwing on the second navigation.
    if (eventName == 'Fetch.requestPaused') {
      await _ensureFetchListener();
    } else {
      await _controller.addDevToolsProtocolEventListener(eventName);
    }
  }

  @override
  Future<void> removeDevToolsProtocolEventListener({
    required String eventName,
  }) async {
    _devToolsProtocolCallbacks.remove(eventName);
    // The navigation interceptor owns this listener even when an application
    // removes its own callback for the same event.
    await _withFetch(() async {
      if (eventName != 'Fetch.requestPaused' || !_fetchEnabled) {
        await _controller.removeDevToolsProtocolEventListener(eventName);
      }
    });
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
    if (baseUrl == null) {
      final dataUri = Uri.dataFromString(
        data,
        mimeType: mimeType,
        encoding: Encoding.getByName(encoding),
      ).toString();
      await loadUrl(urlRequest: URLRequest(url: WebUri(dataUri)));
      return;
    }
    // SECURITY NOTE: with a [baseUrl] the HTML is served through the WebView2
    // `Fetch` boundary as a real document of that origin — NOT as a `data:` URL
    // in an opaque origin. The injected markup therefore runs with the full
    // privileges of `baseUrl`: it can read that origin's non-HttpOnly cookies,
    // `localStorage`, IndexedDB, and issue credentialed `fetch` calls. This is
    // exactly what the authenticated-document use case needs, but [loadData] is
    // also the API most often handed untrusted HTML (rendered markdown, message
    // bodies), so pass a [baseUrl] you trust the origin of. A `file://`
    // [baseUrl] confers the same file-origin privileges.
    final url = baseUrl.toString();
    await _withFetch(() async {
      _pendingRequestHeaders.clear();
      await _ensureFetchListener();
      await _controller.callDevToolsProtocolMethod('Fetch.enable', {
        'patterns': [
          {'resourceType': 'Document', 'requestStage': 'Request'},
        ],
      });
      _fetchEnabled = true;
      _pendingHtmlDocuments[_canonicalRequestUrl(baseUrl)] = data;
      try {
        await _controller.loadUrl(url);
      } catch (_) {
        _pendingHtmlDocuments.remove(_canonicalRequestUrl(baseUrl));
        await _disableFetch();
        rethrow;
      }
    });
  }

  @override
  Future<void> addUserScript({required UserScript userScript}) async {
    if (userScript.injectionTime != UserScriptInjectionTime.AT_DOCUMENT_START) {
      throw UnsupportedError(
        'Windows WebView2 supports only AT_DOCUMENT_START user scripts',
      );
    }
    // WebView2's `addScriptToExecuteOnDocumentCreated` takes only the source: it
    // has no `forMainFrameOnly` / `allowedOriginRules` / `contentWorld` options.
    // Honor `forMainFrameOnly` (default true) by gating the source on the frame
    // it runs in, and honor `allowedOriginRules` by gating on the document
    // origin, so a narrowed script does not silently run in every frame and on
    // every origin as WebView2 would do by default.
    final id = await _controller.addScriptToExecuteOnDocumentCreated(
      _wrapUserScriptSource(userScript),
    );
    if (id != null) _userScriptIds.putIfAbsent(userScript, () => []).add(id);
  }

  /// Wraps a user script's [UserScript.source] in the frame/origin guards that
  /// WebView2's source-only registration cannot express natively.
  ///
  /// - `forMainFrameOnly` (default `true`): when `false`, the script runs in
  ///   every frame; when `true`, the wrapper returns early unless it is the top
  ///   frame (`window.top === window`, with a cross-origin-safe fallback).
  /// - `allowedOriginRules` (default `{'*'}`): when narrowed, the wrapper
  ///   returns early unless `document.location.origin` matches one of the rules
  ///   (exact match or a single trailing `*` wildcard). `*` always matches.
  String _wrapUserScriptSource(UserScript userScript) {
    final source = userScript.source;
    final rules = userScript.allowedOriginRules;
    final restrictOrigin = rules.isNotEmpty && !rules.contains('*');
    final restrictFrame = userScript.forMainFrameOnly;
    if (!restrictOrigin && !restrictFrame) return source;

    final buffer = StringBuffer('(function(){\n');
    if (restrictFrame) {
      buffer.write('''
  try {
    if (window.top !== window) return;
  } catch (e) {
    // Cross-origin access to window.top throws; the script is therefore not in
    // the top frame, so skip it (forMainFrameOnly).
    return;
  }
''');
    }
    if (restrictOrigin) {
      final ruleList = rules.map((r) => "'${r.replaceAll(r"\\", r"\\\\").replaceAll("'", r"\\'")}'").join(',');
      buffer.write('''
  var __allowed = [$ruleList];
  var __origin = (document && document.location && document.location.origin) || '';
  var __matched = __allowed.some(function(rule) {
    if (rule === '*') return true;
    if (rule.length > 1 && rule.slice(-1) === '*') {
      return __origin.indexOf(rule.slice(0, -1)) === 0;
    }
    return rule === __origin;
  });
  if (!__matched) return;
''');
    }
    buffer.write('$source\n})();');
    return buffer.toString();
  }

  @override
  Future<void> addUserScripts({required List<UserScript> userScripts}) async {
    // Validate the whole batch up front so a bad script (e.g. AT_DOCUMENT_END)
    // is rejected before anything is registered — otherwise the earlier scripts
    // stay injected with no bulk-removal API to undo them (NetworkCaptureManager
    // feeds this path with generated batches).
    for (final userScript in userScripts) {
      if (userScript.injectionTime !=
          UserScriptInjectionTime.AT_DOCUMENT_START) {
        throw UnsupportedError(
          'Windows WebView2 supports only AT_DOCUMENT_START user scripts',
        );
      }
    }
    // Track what registered so a mid-loop failure can roll back instead of
    // leaving a partially applied batch.
    final registered = <UserScript>[];
    try {
      for (final userScript in userScripts) {
        await addUserScript(userScript: userScript);
        registered.add(userScript);
      }
    } catch (_) {
      for (final userScript in registered) {
        await removeUserScript(userScript: userScript);
      }
      rethrow;
    }
  }

  @override
  Future<bool> removeUserScript({required UserScript userScript}) async {
    final ids = _userScriptIds.remove(userScript);
    if (ids == null) return false;
    // A script may be registered under more than one id (a rebuild, or a
    // re-registered initialUserScripts list): remove every registered id so
    // none stays injected for the lifetime of the webview.
    for (final id in ids) {
      await _controller.removeScriptToExecuteOnDocumentCreated(id);
    }
    return true;
  }

  @override
  Future<void> removeUserScripts({required List<UserScript> userScripts}) async {
    for (final userScript in userScripts) {
      await removeUserScript(userScript: userScript);
    }
  }

  @override
  Future<void> removeAllUserScripts() async {
    for (final ids in _userScriptIds.values) {
      for (final id in ids) {
        await _controller.removeScriptToExecuteOnDocumentCreated(id);
      }
    }
    _userScriptIds.clear();
  }

  @override
  Future<void> removeUserScriptsByGroupName({required String groupName}) async {
    final matching = _userScriptIds.keys
        .where((userScript) => userScript.groupName == groupName)
        .toList();
    for (final userScript in matching) {
      await removeUserScript(userScript: userScript);
    }
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
    await loadUrl(urlRequest: URLRequest(url: WebUri(fileUri)));
  }

  @override
  Future<WebUri?> getUrl() async {
    final url = _currentUrl;
    return url == null ? null : WebUri(url);
  }

  @override
  Future<String?> getTitle() async {
    return await _controller.title.first;
  }

  @override
  Future<int?> getProgress() async {
    return _progress;
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
  Future<bool> canGoBack() async {
    return _canGoBack;
  }

  @override
  Future<bool> canGoForward() async {
    return _canGoForward;
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
    _devToolsProtocolSubscription?.cancel();
    _devToolsProtocolSubscription = null;
    _pendingRequestHeaders.clear();
    _pendingHtmlDocuments.clear();
    for (final ids in _userScriptIds.values) {
      for (final id in ids) {
        unawaited(_controller.removeScriptToExecuteOnDocumentCreated(id));
      }
    }
    _userScriptIds.clear();
    _fetchEnabled = false;
    _fetchListenerAdded = false;
    _devToolsProtocolCallbacks.clear();
    _urlSubscription?.cancel();
    _urlSubscription = null;
    _loadingStateSubscription?.cancel();
    _loadingStateSubscription = null;
    _historyChangedSubscription?.cancel();
    _historyChangedSubscription = null;
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
