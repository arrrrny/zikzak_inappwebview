import 'dart:async';
import 'dart:convert';

import 'in_app_webview_controller.dart';

/// Outcome of a [WebViewRenderWait].
enum WebViewRenderStatus {
  /// The awaited condition was observed.
  satisfied,

  /// The bounded wait ran out before the condition was observed.
  timedOut,

  /// The caller cancelled the wait before the condition was observed.
  cancelled,

  /// A JavaScript probe failed; the error is on [WebViewRenderResult.error].
  failed,
}

/// The result of a [WebViewRenderWait].
class WebViewRenderResult {
  /// What the wait ended with.
  final WebViewRenderStatus status;

  /// The probe failure, set only for [WebViewRenderStatus.failed].
  final Object? error;

  /// How many JavaScript probes were issued.
  final int probeCount;

  /// How many consecutive identical DOM samples ended the wait; `0` for a
  /// selector wait.
  final int stableSamples;

  /// The last DOM fingerprint, set only for a settled wait.
  final String? fingerprint;

  const WebViewRenderResult({
    required this.status,
    required this.probeCount,
    this.error,
    this.stableSamples = 0,
    this.fingerprint,
  });

  /// Whether the awaited condition was observed.
  bool get isSatisfied => status == WebViewRenderStatus.satisfied;
}

/// A bounded, cancellable awaitable for a rendering condition (issue #371 R5).
///
/// `onLoadStop` fires on the native `didFinish`, before the page's own scripts
/// have populated the DOM; `onPageCommitVisible` fires earlier still. A
/// scraping transport needs "the page has rendered", which is a property of the
/// engine, so it lives here instead of being hand-rolled by every consumer.
///
/// The wait is implemented over [InAppWebViewController.evaluateJavascript], so
/// it works on every engine that can evaluate JavaScript — including the native
/// iOS, Android and macOS headless WebViews — without a second native code path
/// per platform. It is **bounded** by `timeout` and **cancellable** through
/// [cancel].
///
/// ```dart
/// final wait = controller.waitForSelector('#results', timeout: Duration(seconds: 8));
/// final result = await wait.result;
/// if (!result.isSatisfied) { /* timedOut / cancelled / failed */ }
/// ```
class WebViewRenderWait {
  WebViewRenderWait._(this._completer);

  final Completer<WebViewRenderResult> _completer;
  bool _cancelled = false;

  /// Completes exactly once with the outcome.
  Future<WebViewRenderResult> get result => _completer.future;

  /// Whether [cancel] was called.
  bool get isCancelled => _cancelled;

  /// Stops the wait. The future completes immediately with
  /// [WebViewRenderStatus.cancelled]; no further probe is issued.
  void cancel() {
    if (_cancelled || _completer.isCompleted) {
      return;
    }
    _cancelled = true;
    _complete(
      WebViewRenderResult(status: WebViewRenderStatus.cancelled, probeCount: 0),
    );
  }

  void _complete(WebViewRenderResult result) {
    if (!_completer.isCompleted) {
      _completer.complete(result);
    }
  }
}

/// Render-finished signal primitives for [InAppWebViewController].
extension WebViewRenderWaitExtension on InAppWebViewController {
  /// Awaits the appearance of a CSS [selector] in the live DOM.
  ///
  /// Uses `document.querySelector`, so the selector is a normal CSS selector.
  /// An empty selector is a programming error and throws [ArgumentError].
  ///
  /// The returned wait starts immediately and is bounded by [timeout];
  /// [pollInterval] controls how often the DOM is probed.
  WebViewRenderWait waitForSelector(
    String selector, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) {
    if (selector.trim().isEmpty) {
      throw ArgumentError.value(selector, 'selector', 'must not be empty');
    }
    final encoded = jsonEncode(selector);
    final source = '!!(document.querySelector($encoded))';

    return _startWait(
      timeout: timeout,
      pollInterval: pollInterval,
      probe: () async {
        final value = await evaluateJavascript(source: source);
        return value == true;
      },
      onSatisfied: (probeCount) => WebViewRenderResult(
        status: WebViewRenderStatus.satisfied,
        probeCount: probeCount,
      ),
    );
  }

  /// Awaits a settled DOM: the document fingerprint (HTML length + element
  /// count) is unchanged for [stableSamples] consecutive probes.
  ///
  /// This is the engine-side replacement for the scroll-to-bottom dance and the
  /// "poll `outerHTML.length` ten times" heuristic consumers hand-roll to force
  /// lazy hydration. It is a heuristic signal, not a guarantee — but it is a
  /// bounded, cancellable one, measured on the same DOM the consumer will read.
  WebViewRenderWait waitForDomSettled({
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 100),
    int stableSamples = 3,
  }) {
    if (stableSamples < 1) {
      throw ArgumentError.value(stableSamples, 'stableSamples', 'must be >= 1');
    }

    const source =
        '(function(){'
        'var doc = document;'
        'var html = doc.documentElement;'
        'return [html ? html.outerHTML.length : 0, '
        'doc.getElementsByTagName("*").length];'
        '})()';

    String? fingerprint;
    var stable = 0;
    return _startWait(
      timeout: timeout,
      pollInterval: pollInterval,
      probe: () async {
        final value = await evaluateJavascript(source: source);
        final next = _fingerprintOf(value);
        if (next == null) {
          stable = 0;
          return false;
        }
        // `stable` counts consecutive probes that observed the same DOM,
        // including the first one, so `stableSamples: 3` means the fingerprint
        // was observed unchanged three probes in a row.
        if (next == fingerprint) {
          stable++;
        } else {
          fingerprint = next;
          stable = 1;
        }
        return stable >= stableSamples;
      },
      onSatisfied: (probeCount) => WebViewRenderResult(
        status: WebViewRenderStatus.satisfied,
        probeCount: probeCount,
        stableSamples: stable,
        fingerprint: fingerprint,
      ),
      snapshot: () => (stable, fingerprint),
    );
  }

  WebViewRenderWait _startWait({
    required Duration timeout,
    required Duration pollInterval,
    required Future<bool> Function() probe,
    required WebViewRenderResult Function(int probeCount) onSatisfied,
    (int, String?)? Function()? snapshot,
  }) {
    final completer = Completer<WebViewRenderResult>();
    final wait = WebViewRenderWait._(completer);
    final stopwatch = Stopwatch()..start();
    var probes = 0;

    void completeTimedOut() {
      final state = snapshot?.call();
      completer.complete(
        WebViewRenderResult(
          status: WebViewRenderStatus.timedOut,
          probeCount: probes,
          stableSamples: state?.$1 ?? 0,
          fingerprint: state?.$2,
        ),
      );
    }

    Future<void> run() async {
      try {
        while (true) {
          if (wait.isCancelled) {
            return;
          }
          final remaining = timeout - stopwatch.elapsed;
          if (remaining <= Duration.zero) {
            completeTimedOut();
            return;
          }

          probes++;
          final bool satisfied;
          try {
            satisfied = await probe().timeout(remaining);
          } on TimeoutException {
            completeTimedOut();
            return;
          }
          if (satisfied) {
            completer.complete(onSatisfied(probes));
            return;
          }

          if (wait.isCancelled) {
            return;
          }
          final pause = timeout - stopwatch.elapsed;
          if (pause <= Duration.zero) {
            continue;
          }
          await Future<void>.delayed(
            pause < pollInterval ? pause : pollInterval,
          );
        }
      } catch (error) {
        completer.complete(
          WebViewRenderResult(
            status: WebViewRenderStatus.failed,
            probeCount: probes,
            error: error,
          ),
        );
      }
    }

    run();
    return wait;
  }

  static String? _fingerprintOf(dynamic value) {
    if (value is! List || value.length < 2) {
      return null;
    }
    return '${value[0]}:${value[1]}';
  }
}
