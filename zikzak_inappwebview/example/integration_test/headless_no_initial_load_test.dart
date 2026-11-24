// Issue #460 — `HeadlessInAppWebView.run()` with no initial load, end to end
// on a real engine.
//
// The unit test in `zikzak_inappwebview_ios/test/headless_no_initial_load_test.dart`
// only greps the Swift sources for the fixed shapes. This case drives the REAL
// native manager: an instance built with settings and callbacks but NO
// `initialUrlRequest` / `initialFile` / `initialData` must complete `run()` and
// then accept a `loadUrl` — the exact scenario that hung forever on iOS 18.7.1
// with zikzak_inappwebview 6.5.0.
//
// Before the fix `run()` armed `webView.firstNavigationCompleted` and deferred
// its result to that signal, which can only fire from `didFinish`/`didFail`. A
// blank WebView issues no navigation, so nothing ever fired and the future
// stayed pending. Run this file on the simulator to reproduce the hang.
//
// Run on the iOS Simulator:
//   cd zikzak_inappwebview/example
//   flutter test integration_test/headless_no_initial_load_test.dart -d <device>
//
// The example resolves the platform packages from pub.dev by default, so the
// run must override `zikzak_inappwebview_ios` to this checkout (the same
// `pubspec_overrides.yaml` the CI `build-ios` job writes), or this test
// exercises the published native code where the hang still exists:
//   dependency_overrides:
//     zikzak_inappwebview_ios:
//       path: ../../zikzak_inappwebview_ios
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('run() completes with no initial load, then loadUrl works', (
    tester,
  ) async {
    // Deliberately no initialUrlRequest / initialFile / initialData: settings
    // and callbacks only, which is what the bug report describes.
    final headless = HeadlessInAppWebView(
      initialSize: const Size(320, 240),
      initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
    );
    addTearDown(headless.dispose);

    // The regression: this future never completed before the fix. The timeout
    // is only so a regression FAILS instead of wedging the test run forever —
    // it is not the fix.
    await headless.run().timeout(
      const Duration(seconds: 20),
      onTimeout: () => fail(
        'run() did not complete with no initial load — iOS issue #460 regressed',
      ),
    );

    expect(
      headless.isRunning(),
      isTrue,
      reason: 'the instance must be live once run() returns',
    );
    expect(
      headless.webViewController,
      isNotNull,
      reason: 'run() must leave a usable controller behind',
    );

    // Acceptance criterion 1: a blank headless WebView accepts a later loadUrl
    // and actually executes the document.
    const page = '<html><body><h1 id="title">after-run</h1></body></html>';
    headless.webViewController!.loadData(data: page);
    final title = await _awaitJavascript(
      headless.webViewController!,
      'document.getElementById("title")?.textContent',
    );
    expect(
      title,
      'after-run',
      reason:
          'a loadUrl/loadData issued AFTER a no-initial-load run() must reach '
          'the page — the early completion must not leave the WebView inert',
    );
  });

  testWidgets('an initial load still completes run() — acceptance criterion 2', (
    tester,
  ) async {
    const page = '<html><body><h1 id="title">initial</h1></body></html>';
    final headless = HeadlessInAppWebView(
      initialSize: const Size(320, 240),
      initialData: InAppWebViewInitialData(data: page),
    );
    addTearDown(headless.dispose);

    await headless.run().timeout(
      const Duration(seconds: 20),
      onTimeout: () => fail(
        'run() did not complete for an instance WITH initialData — the #460 '
        'fix must not regress the loading path',
      ),
    );

    final title = await _awaitJavascript(
      headless.webViewController!,
      'document.getElementById("title")?.textContent',
    );
    expect(
      title,
      'initial',
      reason: 'initialData must still be loaded by run()',
    );
  });
}

/// Polls [source] until it yields a non-null value, so the assertion reads the
/// page rather than racing the navigation.
Future<Object?> _awaitJavascript(
  InAppWebViewController controller,
  String source,
) async {
  Object? last;
  for (var attempt = 0; attempt < 100; attempt++) {
    try {
      last = await controller.evaluateJavascript(source: source);
    } on PlatformException {
      last = null;
    }
    if (last != null) return last;
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  return last;
}
