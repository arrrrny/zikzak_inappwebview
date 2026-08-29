import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Dismiss-dialogue integration coverage (spec 002, SC-002 / SC-004).
///
/// Runs on macOS desktop, iOS simulator, and Android emulator. Loads a page with
/// fixed/sticky overlays and asserts the `dismissDialogues` setting's effect on
/// the live DOM. Avoids `pumpAndSettle` (a live WebView keeps the frame dirty and
/// never settles); uses fixed delays plus explicit per-call timeouts instead.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const pageHtml = '''
  <!DOCTYPE html>
  <html>
  <head><title>Overlays</title></head>
  <body>
    <h1>Content</h1>
    <div id="cookie" style="position:fixed; top:0; left:0; z-index:9999;">
      We use cookies
    </div>
    <nav id="sticky" style="position:sticky; top:0;">Sticky nav</nav>
  </body>
  </html>
  ''';

  // Injects a fixed overlay 1s after load, inside the dismissal retry window.
  const dynamicOverlayHtml = '''
  <!DOCTYPE html>
  <html>
  <head><title>Overlays</title></head>
  <body>
    <h1>Content</h1>
    <div id="cookie" style="position:fixed; top:0; left:0; z-index:9999;">
      We use cookies
    </div>
    <nav id="sticky" style="position:sticky; top:0;">Sticky nav</nav>
    <script>
      setTimeout(function() {
        var d = document.createElement('div');
        d.id = 'late';
        d.style.position = 'fixed';
        d.style.top = '0';
        d.style.zIndex = '9999';
        d.textContent = 'late overlay';
        document.body.appendChild(d);
      }, 1000);
    </script>
  </body>
  </html>
  ''';

  // Forces the dismissal script's querySelectorAll to throw on every call.
  const throwOnRemovalHtml = '''
  <!DOCTYPE html>
  <html>
  <head><title>Throw</title></head>
  <body>
    <h1>Content</h1>
    <div id="cookie" style="position:fixed; top:0; left:0; z-index:9999;">
      We use cookies
    </div>
    <script>
      document.querySelectorAll = function() {
        throw new Error('forced removal failure');
      };
    </script>
  </body>
  </html>
  ''';

  Future<InAppWebViewController> pumpWebView(
    WidgetTester tester, {
    required Completer<void> pageLoaded,
    required bool dismissDialogues,
    String html = pageHtml,
  }) async {
    final created = Completer<InAppWebViewController>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(
            child: InAppWebView(
              initialSettings: InAppWebViewSettings(
                dismissDialogues: dismissDialogues,
              ),
              onWebViewCreated: (c) {
                if (!created.isCompleted) created.complete(c);
              },
              onLoadStop: (controller, url) {
                if (!pageLoaded.isCompleted) pageLoaded.complete();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    final controller = await created.future
        .timeout(const Duration(seconds: 30));
    await controller
        .loadData(data: html)
        .timeout(const Duration(seconds: 20));
    await pageLoaded.future.timeout(const Duration(seconds: 20));
    // Give the onLoadStop removal loop (3 retries) time to run.
    await Future<void>.delayed(const Duration(seconds: 4));
    return controller;
  }

  Future<bool> elementPresent(
    InAppWebViewController controller,
    String selector,
  ) async {
    final result = await controller
        .evaluateJavascript(
          source: 'document.querySelector($selector) !== null',
        )
        .timeout(const Duration(seconds: 20));
    return result == true;
  }

  group('dismissDialogues (spec 002)', () {
    testWidgets(
      'SC-002: dismissDialogues removes fixed/sticky overlays when enabled',
      (WidgetTester tester) async {
        final controller = await pumpWebView(
          tester,
          pageLoaded: Completer(),
          dismissDialogues: true,
        );

        final cookiePresent = await elementPresent(controller, '"#cookie"');
        final stickyPresent = await elementPresent(controller, '"#sticky"');
        final contentPresent = await elementPresent(controller, '"h1"');

        expect(cookiePresent, isFalse,
            reason: 'fixed cookie banner must be removed');
        expect(stickyPresent, isFalse, reason: 'sticky nav must be removed');
        expect(contentPresent, isTrue,
            reason: 'page content must be preserved');
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    testWidgets(
      'SC-004: dismissDialogues leaves overlays intact when disabled',
      (WidgetTester tester) async {
        final controller = await pumpWebView(
          tester,
          pageLoaded: Completer(),
          dismissDialogues: false,
        );

        final cookiePresent = await elementPresent(controller, '"#cookie"');
        final stickyPresent = await elementPresent(controller, '"#sticky"');

        expect(cookiePresent, isTrue,
            reason: 'fixed cookie banner must remain when disabled');
        expect(stickyPresent, isTrue,
            reason: 'sticky nav must remain when disabled');
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    testWidgets(
      'SC-003: dismissDialogues removes fixed/sticky overlays injected after load (retry window)',
      (WidgetTester tester) async {
        final controller = await pumpWebView(
          tester,
          pageLoaded: Completer(),
          dismissDialogues: true,
          html: dynamicOverlayHtml,
        );

        expect(await elementPresent(controller, '"#cookie"'), isFalse,
            reason: 'fixed cookie banner must be removed');
        expect(await elementPresent(controller, '"#sticky"'), isFalse,
            reason: 'sticky nav must be removed');
        expect(await elementPresent(controller, '"#late"'), isFalse,
            reason:
                'dynamically injected fixed overlay must be removed within the retry window');
        expect(await elementPresent(controller, '"h1"'), isTrue,
            reason: 'page content must be preserved');
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    testWidgets(
      'SC-005: dismissDialogues never crashes the web view when the removal script throws',
      (WidgetTester tester) async {
        final controller = await pumpWebView(
          tester,
          pageLoaded: Completer(),
          dismissDialogues: true,
          html: throwOnRemovalHtml,
        );

        // The page made document.querySelectorAll (used by the removal script) throw.
        // The web view must stay responsive and still execute JS afterwards.
        final title = await controller
            .evaluateJavascript(source: 'document.title')
            .timeout(const Duration(seconds: 20));
        expect(title, 'Throw',
            reason: 'web view must remain responsive after a JS error');
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}
