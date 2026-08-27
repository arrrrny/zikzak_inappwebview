import 'dart:collection';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';
import 'network_capture_interceptor_js.dart';

///Name of the JavaScript handler the interceptor script reports through.
const String kNetworkCaptureHandlerName = '__zikzakNetworkCapture__';

///Signature of the `onNetworkRequest` event.
typedef NetworkRequestCallback =
    void Function(InAppWebViewController controller, NetworkRequest request);

///Signature of the `onNetworkResponse` event.
typedef NetworkResponseCallback =
    void Function(InAppWebViewController controller, NetworkResponse response);

///Signature of the `onNetworkLoadingFinished` event.
typedef NetworkResponseBodyCallback =
    void Function(
      InAppWebViewController controller,
      NetworkResponseBody responseBody,
    );

///Dart-side engine of the Network Capture API.
///
///A manager is created by [InAppWebView]/[HeadlessInAppWebView] when network
///capture is enabled. It:
///
/// 1. builds the interceptor [UserScript] injected at document start in all
///    frames (see [buildUserScript]);
/// 2. registers the `__zikzakNetworkCapture__` JavaScript handler when the
///    WebView is created (see [attach]) and flushes events the page buffered
///    before the handler was ready;
/// 3. routes captured events to the user's callbacks and to the
///    [NetworkCaptureController] collector.
///
///The implementation is platform-independent (pure Dart + JavaScript
///injection), so it behaves identically on Android, iOS and macOS, and works
///for both visible and headless WebViews.
class NetworkCaptureManager {
  ///JavaScript handler callback arguments index of the event payload.
  static const int _payloadIndex = 0;

  static final Expando<NetworkCaptureManager> _registry =
      Expando<NetworkCaptureManager>('zikzakNetworkCaptureManager');

  final InAppWebViewSettings _settings;

  final NetworkRequestCallback? _onNetworkRequest;
  final NetworkResponseCallback? _onNetworkResponse;
  final NetworkResponseBodyCallback? _onNetworkLoadingFinished;

  ///The collector that accumulates captured entries.
  ///Either the user-provided `InAppWebViewSettings.networkCapture` instance
  ///or an automatically created one.
  final NetworkCaptureController collector;

  ///Deduplication of events that are sent both optimistically and through
  ///the pre-ready flush queue. Keys are `pageId:seq`.
  final Set<String> _seenEvents = HashSet<String>();
  final Queue<String> _seenEventsOrder = Queue<String>();

  NetworkCaptureManager._(
    this._settings,
    this._onNetworkRequest,
    this._onNetworkResponse,
    this._onNetworkLoadingFinished,
    this.collector,
  );

  ///Creates a manager when network capture is enabled, `null` otherwise.
  ///
  ///Capture is enabled when `settings.useNetworkCapture == true`, or when it
  ///is `null` and a [NetworkCaptureController] or any of the network capture
  ///callbacks is provided.
  static NetworkCaptureManager? maybeCreate({
    required InAppWebViewSettings? settings,
    NetworkRequestCallback? onNetworkRequest,
    NetworkResponseCallback? onNetworkResponse,
    NetworkResponseBodyCallback? onNetworkLoadingFinished,
  }) {
    final effectiveSettings = settings ?? InAppWebViewSettings();
    final enabled =
        effectiveSettings.useNetworkCapture == true ||
        (effectiveSettings.useNetworkCapture == null &&
            (effectiveSettings.networkCapture != null ||
                onNetworkRequest != null ||
                onNetworkResponse != null ||
                onNetworkLoadingFinished != null));
    if (!enabled) {
      return null;
    }
    return NetworkCaptureManager._(
      effectiveSettings,
      onNetworkRequest,
      onNetworkResponse,
      onNetworkLoadingFinished,
      effectiveSettings.networkCapture ?? NetworkCaptureController(),
    );
  }

  ///Returns the manager attached to [controller], if any.
  static NetworkCaptureManager? of(InAppWebViewController controller) {
    return _registry[controller] ?? _registry[controller.platform];
  }

  ///Merges the interceptor script into the user-provided initial scripts.
  ///Returns [initialUserScripts] unchanged when [manager] is `null`.
  static UnmodifiableListView<UserScript>? mergeUserScripts(
    UnmodifiableListView<UserScript>? initialUserScripts,
    NetworkCaptureManager? manager,
  ) {
    if (manager == null) {
      return initialUserScripts;
    }
    return UnmodifiableListView<UserScript>(<UserScript>[
      if (initialUserScripts != null) ...initialUserScripts,
      manager.buildUserScript(),
    ]);
  }

  ///Builds the interceptor script to add to the initial user scripts.
  UserScript buildUserScript() {
    final config = <String, dynamic>{
      'maxBodySize': _settings.networkCaptureMaxBodySize ?? 50000,
      'captureBodies': _settings.networkCaptureBodies ?? true,
      'captureBinaryBodies': _settings.networkCaptureBinaryBodies ?? false,
      'urlPatterns': _settings.networkCaptureUrlPatterns ?? const <String>[],
      'patternType':
          (_settings.networkCaptureUrlPatternType ?? UrlPatternType.substring)
              .toNativeValue(),
      'resourceTypes':
          (_settings.networkCaptureResourceTypes ??
                  const [ResourceType.xhr, ResourceType.fetch])
              .map((e) => e.toNativeValue())
              .toList(),
      'mimeTypes': _settings.networkCaptureMimeTypes ?? const <String>[],
    };
    return UserScript(
      groupName: 'zikzakNetworkCapture',
      source: buildNetworkCaptureInterceptorJs(config),
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      forMainFrameOnly: false,
    );
  }

  ///Registers the JavaScript handler on [controller] and flushes events the
  ///page buffered before registration. Called from `onWebViewCreated`.
  void attach(InAppWebViewController controller) {
    if (_registry[controller] == this) return;
    _registry[controller] = this;
    _registry[controller.platform] = this;
    controller.addJavaScriptHandler(
      handlerName: kNetworkCaptureHandlerName,
      callback: (arguments) {
        _onJavaScriptEvent(controller, arguments);
        return null;
      },
    );
    _flushPageQueue(controller);
  }

  ///Re-flushes the in-page event buffer. Should be called on page load
  ///events so events fired at the very beginning of a navigation (before the
  ///new document's bridge is reachable) are delivered.
  void onPageLoad(InAppWebViewController controller) {
    _flushPageQueue(controller);
  }

  ///Removes the JavaScript handler and clears registry entries.
  ///Should be called from WebView dispose paths.
  void detach(InAppWebViewController controller) {
    if (_registry[controller] != this) return;
    controller.removeJavaScriptHandler(handlerName: kNetworkCaptureHandlerName);
    _registry[controller] = null;
    _registry[controller.platform] = null;
  }

  Future<void> _flushPageQueue(InAppWebViewController controller) async {
    try {
      await controller.evaluateJavascript(
        source:
            'window.__zikzakNetworkCapture__ && window.__zikzakNetworkCapture__.ready ? window.__zikzakNetworkCapture__.ready() : 0;',
      );
    } catch (_) {
      // The page may not exist yet or navigation may have aborted.
    }
  }

  void _onJavaScriptEvent(
    InAppWebViewController controller,
    List<dynamic> arguments,
  ) {
    if (arguments.length <= _payloadIndex) {
      return;
    }
    final raw = arguments[_payloadIndex];
    if (raw is! Map) {
      return;
    }
    final payload = Map<String, dynamic>.from(raw);

    // Deduplicate optimistic sends vs. flushed queue sends.
    final dedupKey = '${payload['pageId']}:${payload['seq']}';
    if (_seenEvents.contains(dedupKey)) {
      return;
    }
    _seenEvents.add(dedupKey);
    _seenEventsOrder.add(dedupKey);
    while (_seenEventsOrder.length > 2000) {
      _seenEvents.remove(_seenEventsOrder.removeFirst());
    }

    switch (payload['kind']) {
      case 'request':
        final request = NetworkRequest.fromMap(payload);
        if (request == null) return;
        collector.trackRequest(request);
        _onNetworkRequest?.call(controller, request);
        break;
      case 'response':
        final response = NetworkResponse.fromMap(payload);
        if (response == null) return;
        collector.attachResponse(response);
        _onNetworkResponse?.call(controller, response);
        break;
      case 'body':
        final body = NetworkResponseBody.fromMap(payload);
        if (body == null) return;
        collector.attachBody(body);
        _onNetworkLoadingFinished?.call(controller, body);
        break;
      case 'error':
        final requestId = payload['requestId']?.toString() ?? '';
        final message = payload['error']?.toString() ?? 'unknown error';
        collector.attachError(requestId, message);
        break;
    }
  }
}
