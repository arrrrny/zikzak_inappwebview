import 'dart:collection';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview/in_app_webview_controller.dart';
import 'navigation_tracker_js.dart';
import 'url_cycle_entry.dart';

///Signature of the [NavigationTracker] entry callback.
typedef UrlCycleEntryCallback = void Function(UrlCycleEntry entry);

///Unified, ordered URL-cycle stream for a WebView.
///
///Merges every URL-change source the package exposes into one ordered,
///deduplicated list of [UrlCycleEntry]s:
///
/// 1. the widget callbacks forwarded via [onLoadStart],
///    [onUpdateVisitedHistory] and [onServerRedirect];
/// 2. the injected tracker [UserScript] (see [buildNavigationTrackerJs])
///    which monkey-patches the history API and listens to
///    `popstate`/`hashchange`/`pageshow`, reported through the
///    `__zikzakNavigationTracker__` JavaScript handler.
///
///Dedup rule: the same URL observed within a 500ms window collapses to one
///entry, keeping the earliest trigger.
///
///The tracker works without a WebView: [handleJsPayload] and the forwarder
///methods operate on a plain instance; [attach] only wires the JS bridge.
class NavigationTracker {
  ///Deduplication window: same URL within this window collapses to one entry.
  static const Duration dedupWindow = Duration(milliseconds: 500);

  final UrlCycleEntryCallback? _onUrlCycleEntry;

  ///Whether sub-frame URL changes are dropped (default `true`).
  final bool mainFrameOnly;

  final List<UrlCycleEntry> _entries = <UrlCycleEntry>[];

  InAppWebViewController? _controller;

  ///Creates a tracker. Usable without a WebView; call [attach] from
  ///`onWebViewCreated` to wire the JS bridge.
  NavigationTracker({
    UrlCycleEntryCallback? onUrlCycleEntry,
    this.mainFrameOnly = true,
  }) : _onUrlCycleEntry = onUrlCycleEntry;

  ///Creates a tracker (same convention as
  ///`NetworkCaptureManager.maybeCreate`).
  static NavigationTracker? maybeCreate({
    UrlCycleEntryCallback? onUrlCycleEntry,
  }) {
    return NavigationTracker(onUrlCycleEntry: onUrlCycleEntry);
  }

  ///Merges the tracker script into the user-provided scripts.
  ///Returns [userScripts] unchanged when [tracker] is `null`.
  static UnmodifiableListView<UserScript>? mergeUserScripts(
    List<UserScript>? userScripts,
    NavigationTracker? tracker,
  ) {
    if (tracker == null) {
      return userScripts == null ? null : UnmodifiableListView(userScripts);
    }
    return UnmodifiableListView<UserScript>(<UserScript>[
      ...?userScripts,
      tracker.buildUserScript(),
    ]);
  }

  ///Builds the tracker script to add to the initial user scripts.
  UserScript buildUserScript() {
    return UserScript(
      groupName: 'zikzakNavigationTracker',
      source: buildNavigationTrackerJs(),
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      forMainFrameOnly: false,
    );
  }

  ///Ordered, deduplicated URL-cycle entries.
  List<UrlCycleEntry> get entries => UnmodifiableListView(_entries);

  ///Registers the JavaScript handler on [controller] and flushes events the
  ///page buffered before registration. Call from `onWebViewCreated`.
  void attach(InAppWebViewController controller) {
    _controller = controller;
    controller.addJavaScriptHandler(
      handlerName: kNavigationTrackerHandlerName,
      callback: (arguments) {
        if (arguments.isEmpty) return null;
        final raw = arguments[0];
        if (raw is Map) {
          handleJsPayload(Map<String, dynamic>.from(raw));
        }
        return null;
      },
    );
    _flushPageQueue();
  }

  ///Removes the JavaScript handler.
  void detach() {
    final controller = _controller;
    if (controller != null) {
      controller.removeJavaScriptHandler(
        handlerName: kNavigationTrackerHandlerName,
      );
    }
    _controller = null;
  }

  ///Forward from the widget's `onLoadStart` callback.
  void onLoadStart(WebUri? url) {
    _recordUrl(url?.toString(), UrlCycleTrigger.loadStart);
  }

  ///Forward from the widget's `onUpdateVisitedHistory` callback.
  void onUpdateVisitedHistory(WebUri? url) {
    _recordUrl(url?.toString(), UrlCycleTrigger.visitedHistory);
  }

  ///Forward from the widget's server-redirect callback (iOS/macOS).
  ///The callback carries no URL, so the last recorded URL is reused.
  void onServerRedirect() {
    if (_entries.isEmpty) return;
    recordEntry(
      url: _entries.last.url,
      trigger: UrlCycleTrigger.redirect,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  ///Forward a `shouldOverrideUrlLoading` observation.
  void onUserOverride(WebUri? url) {
    _recordUrl(url?.toString(), UrlCycleTrigger.userOverride);
  }

  ///Processes a raw payload reported by the injected tracker script.
  ///Public so it can be unit-tested without a WebView.
  void handleJsPayload(Map<String, dynamic> payload) {
    final url = payload['url']?.toString();
    recordEntry(
      url: url,
      trigger: UrlCycleTrigger.fromName(payload['trigger']?.toString() ?? ''),
      timestamp:
          payload['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      isMainFrame: payload['isMainFrame'] as bool? ?? true,
    );
  }

  ///Records a URL change, applying the main-frame filter and the 500ms
  ///dedup window (earliest trigger wins).
  void recordEntry({
    required String? url,
    required UrlCycleTrigger trigger,
    int? timestamp,
    bool isMainFrame = true,
  }) {
    if (url == null || url.isEmpty) return;
    if (mainFrameOnly && !isMainFrame) return;
    final ts = timestamp ?? DateTime.now().millisecondsSinceEpoch;

    // Collapse the same URL observed within the dedup window, keeping the
    // earliest (already recorded) trigger.
    for (var i = _entries.length - 1; i >= 0; i--) {
      final existing = _entries[i];
      if (existing.url == url) {
        if ((ts - existing.timestamp).abs() <= dedupWindow.inMilliseconds) {
          return;
        }
        break;
      }
    }

    final entry = UrlCycleEntry(
      url: url,
      timestamp: ts,
      trigger: trigger,
      isMainFrame: isMainFrame,
    );
    _entries.add(entry);
    _onUrlCycleEntry?.call(entry);
  }

  void _recordUrl(String? url, UrlCycleTrigger trigger) {
    recordEntry(url: url, trigger: trigger);
  }

  Future<void> _flushPageQueue() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.evaluateJavascript(
        source:
            'window.__zikzakNavigationTracker__ && window.__zikzakNavigationTracker__.ready ? window.__zikzakNavigationTracker__.ready() : 0;',
      );
    } catch (_) {
      // The page may not exist yet or navigation may have aborted.
    }
  }
}
