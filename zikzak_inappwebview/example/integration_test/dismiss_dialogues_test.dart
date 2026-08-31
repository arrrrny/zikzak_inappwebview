import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Dismiss-dialogue integration coverage (spec 002).
///
/// Combines the spec-002 SC-002/SC-003/SC-004/SC-005 coverage (macOS/iOS/Android)
/// with the legacy `dismissDialogues` acceptance tests (US1/US2/US3, A1-A6).
///
/// The legacy seam fires on `onLoadStop` and injects the removal script 3x with
/// an 800ms delay between attempts (~1.6s window), so tests wait out that window
/// before asserting the resulting DOM. Avoids `pumpAndSettle` where a live WebView
/// keeps the frame dirty and never settles; uses fixed delays plus explicit
/// per-call timeouts instead.
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
    // 120s ceilings: Intel-2019 macOS needs the headroom; fast platforms finish
    // well under this and are unaffected by the higher ceiling.
    final controller = await created.future
        .timeout(const Duration(seconds: 120));
    await controller
        .loadData(data: html)
        .timeout(const Duration(seconds: 120));
    await pageLoaded.future.timeout(const Duration(seconds: 120));
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

  Future<InAppWebViewController> pumpDismissWebView(
    WidgetTester tester, {
    required String html,
    required bool dismissDialogues,
    Completer<void>? loadCompleter,
  }) async {
    final created = Completer<InAppWebViewController>();
    final loaded = loadCompleter ?? Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InAppWebView(
            initialSettings: InAppWebViewSettings(dismissDialogues: dismissDialogues),
            onWebViewCreated: (c) {
              if (!created.isCompleted) created.complete(c);
            },
            onLoadStop: (c, url) {
              if (!loaded.isCompleted) loaded.complete();
            },
          ),
        ),
      ),
    );
    final controller = await created.future.timeout(const Duration(seconds: 15));
    await controller.loadData(data: html);
    await loaded.future.timeout(const Duration(seconds: 15));
    // Wait out the legacy dismissal retry window (3x with 800ms between).
    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    return controller;
  }

  int toInt(dynamic v) => v is num ? v.toInt() : int.parse(v.toString());

  Future<int> countFixedSticky(InAppWebViewController c) async {
    final raw = await c.evaluateJavascript(
      source: r'''
(function() {
  var els = Array.from(document.querySelectorAll('*'));
  return els.filter(function(e) {
    var p = getComputedStyle(e).position;
    return p === 'fixed' || p === 'sticky';
  }).length;
})()
''',
    );
    return toInt(raw);
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
      timeout: const Timeout(Duration(minutes: 8)),
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
      timeout: const Timeout(Duration(minutes: 8)),
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
      timeout: const Timeout(Duration(minutes: 8)),
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
      timeout: const Timeout(Duration(minutes: 8)),
    );

    // A1 — US1-S1, US1-S2, FR-003, FR-004
    testWidgets('A1: dismissDialogues removes all fixed AND sticky elements', (
      WidgetTester tester,
    ) async {
      const html = '''
<!DOCTYPE html><html><head><style>
.fixed{position:fixed;top:0;left:0;}
.sticky{position:sticky;top:0;}
</style></head><body>
<h1>content</h1>
<div id="ovl" class="fixed">overlay</div>
<div id="stk" class="sticky">sticky</div>
</body></html>''';
      final c = await pumpDismissWebView(tester, html: html, dismissDialogues: true);
      expect(await countFixedSticky(c), 0);
      final out = await c.getHtml();
      expect(out, isNotNull);
      expect(out!, isNot(contains('id="ovl"')));
      expect(out, isNot(contains('id="stk"')));
    });

    // A2 — US1-S3, FR-005
    testWidgets('A2: dismissDialogues resets overflow/margin on documentElement and body', (
      WidgetTester tester,
    ) async {
      const html = '''
<!DOCTYPE html><html><head></head>
<body style="overflow:hidden;margin:10px">
<div id="ovl" style="position:fixed">overlay</div>
</body></html>''';
      final c = await pumpDismissWebView(tester, html: html, dismissDialogues: true);
      expect(await c.evaluateJavascript(source: "document.documentElement.style.overflow"), '');
      expect(await c.evaluateJavascript(source: "document.documentElement.style.margin"), '');
      expect(await c.evaluateJavascript(source: "document.body.style.overflow"), '');
      expect(await c.evaluateJavascript(source: "document.body.style.margin"), '');
    });

    // A3 — US2-S1, FR-007
    testWidgets('A3: dismissDialogues false keeps fixed/sticky elements', (
      WidgetTester tester,
    ) async {
      const html = '''
<!DOCTYPE html><html><head><style>
.fixed{position:fixed;top:0;left:0;}
.sticky{position:sticky;top:0;}
</style></head><body>
<h1>content</h1>
<div id="ovl" class="fixed">overlay</div>
<div id="stk" class="sticky">sticky</div>
</body></html>''';
      final c = await pumpDismissWebView(tester, html: html, dismissDialogues: false);
      expect(await countFixedSticky(c), 2);
      final out = await c.getHtml();
      expect(out, isNotNull);
      expect(out!, contains('id="ovl"'));
      expect(out, contains('id="stk"'));
    });

    // A4 — US2-S2, SC-004
    testWidgets('A4: dismissDialogues false leaves overlays in a screenshot capture', (
      WidgetTester tester,
    ) async {
      const html = '''
<!DOCTYPE html><html><head></head>
<body><div id="ovl" style="position:fixed">overlay</div></body></html>''';
      final c = await pumpDismissWebView(tester, html: html, dismissDialogues: false);
      expect(await countFixedSticky(c), 1);
      final shot = await c.takeScreenshot();
      expect(shot, isNotNull);
      expect(shot!.length, greaterThan(0));
    });

    // A5 — US3-S1, FR-006
    testWidgets('A5: dismissDialogues removes a fixed overlay injected after load', (
      WidgetTester tester,
    ) async {
      const html = '<!DOCTYPE html><html><body><h1>content</h1></body></html>';
      final loaded = Completer<void>();
      final created = Completer<InAppWebViewController>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InAppWebView(
              initialSettings: InAppWebViewSettings(dismissDialogues: true),
              onWebViewCreated: (c) {
                if (!created.isCompleted) created.complete(c);
              },
              onLoadStop: (c, url) {
                if (!loaded.isCompleted) loaded.complete();
              },
            ),
          ),
        ),
      );
      final c = await created.future.timeout(const Duration(seconds: 15));
      await c.loadData(data: html);
      await loaded.future.timeout(const Duration(seconds: 15));
      // Inject a fixed overlay after the first dismissal attempt but before the
      // 800ms retry window closes, so a later retry must catch it.
      await Future.delayed(const Duration(milliseconds: 400));
      await c.evaluateJavascript(
        source:
            "var d=document.createElement('div');d.id='dyn';d.style.position='fixed';d.textContent='late';document.body.appendChild(d);",
      );
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(await countFixedSticky(c), 0);
      final out = await c.getHtml();
      expect(out, isNotNull);
      expect(out!, isNot(contains('id="dyn"')));
    });

    // A6 — US3-S2, FR-008, FR-009
    testWidgets('A6: dismissDialogues with no overlays completes cleanly', (
      WidgetTester tester,
    ) async {
      const html = '<!DOCTYPE html><html><body><h1>clean page</h1><p>body text</p></body></html>';
      final c = await pumpDismissWebView(tester, html: html, dismissDialogues: true);
      expect(await countFixedSticky(c), 0);
      final out = await c.getHtml();
      expect(out, isNotNull);
      expect(out!, contains('clean page'));
      expect(out, contains('body text'));
    });
  });
}
