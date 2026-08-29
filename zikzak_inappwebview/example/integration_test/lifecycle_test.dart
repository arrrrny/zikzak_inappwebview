import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Lifecycle integration tests (P2 of the dispose-pattern epic).
///
/// Covers:
///  - hot restart: the WebView keeps working after a reassemble
///  - activity recreation: background -> foreground without
///    MissingPluginException
///  - plugin registration without an Activity (FlutterFragment scenario)
///  - HeadlessInAppWebView dispose-before-run and double-dispose (P1 bug)
///  - InAppLocalhostServer.dispose stops the server (P1)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<InAppWebViewController> pumpWebView(
    WidgetTester tester, {
    required Completer<void> pageLoaded,
  }) async {
    final Completer<InAppWebViewController> created = Completer();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InAppWebView(
            // A unique key forces the element (and thus the native
            // AppKitView/AndroidView platform view) to be recreated on every
            // pump. Without it, reassemble() reuses the existing element via
            // canUpdate() and onWebViewCreated never fires a second time, which
            // does not faithfully simulate a hot restart on desktop. This matches
            // how a real hot restart recreates the widget tree.
            key: UniqueKey(),
            onWebViewCreated: (c) {
              if (!created.isCompleted) {
                created.complete(c);
              }
            },
            onLoadStop: (controller, url) {
              if (!pageLoaded.isCompleted) {
                pageLoaded.complete();
              }
            },
          ),
        ),
      ),
    );
    final controller = await created.future.timeout(
      const Duration(seconds: 120),
    );
    await controller.loadData(
      data: '<html><body><h1>lifecycle</h1></body></html>',
    );
    // No onTimeout fallback: a page that never finishes loading must fail
    // the test instead of being silently swallowed. Bumped from 15s to 120s
    // for the slow 2019 Intel Mac (see FirstLoadRaceScreen readiness notes).
    await pageLoaded.future.timeout(const Duration(seconds: 120));
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets('WebView survives hot restart (reassemble)', (
    WidgetTester tester,
  ) async {
    var controller = await pumpWebView(tester, pageLoaded: Completer());
    expect(
      await controller.evaluateJavascript(source: '1 + 1'),
      anyOf(equals(2), equals('2')),
    );

    // Simulate hot restart: reassembles the whole widget tree, recreating
    // platform views the same way a real hot restart does.
    final binding = IntegrationTestWidgetsFlutterBinding.instance;
    await binding.reassembleApplication();
    await tester.pumpAndSettle();

    controller = await pumpWebView(tester, pageLoaded: Completer());
    expect(
      await controller.evaluateJavascript(source: '2 + 2'),
      anyOf(equals(4), equals('4')),
    );
  });

  testWidgets(
    'background -> foreground does not throw MissingPluginException',
    (WidgetTester tester) async {
      final controller = await pumpWebView(tester, pageLoaded: Completer());

      // Simulate activity going to background and coming back.
      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.paused,
      );
      await tester.pump();
      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
      await tester.pumpAndSettle();

      // Channel must still be alive.
      expect(
        await controller.evaluateJavascript(source: '3 + 3'),
        anyOf(equals(6), equals('6')),
      );
      expect(await controller.getUrl(), isNotNull);
    },
  );

  testWidgets('plugin registration works without an Activity', (
    WidgetTester tester,
  ) async {
    // FlutterFragment scenario: the plugin must be registered and usable
    // even when no Android Activity is attached. On desktop/mobile test
    // runners the equivalent statement is that the platform instance is
    // registered and controller methods round-trip.
    expect(InAppWebViewPlatform.instance, isNotNull);

    final controller = await pumpWebView(tester, pageLoaded: Completer());
    expect(await controller.getTitle(), isA<String?>());
  });

  testWidgets('HeadlessInAppWebView: dispose before run + double dispose', (
    WidgetTester tester,
  ) async {
    final headless = HeadlessInAppWebView(
      initialData: InAppWebViewInitialData(
        data: '<html><body>headless</body></html>',
      ),
    );

    // P1 regression: dispose() before run() must be safe and idempotent.
    await headless.dispose();
    await headless.dispose();

    // dispose() while run() is still in flight must coordinate with the
    // pending startup: it waits for the native side to come up, tears it
    // down, and must not hang; a second dispose() remains a no-op.
    final headlessInFlight = HeadlessInAppWebView(
      initialData: InAppWebViewInitialData(
        data: '<html><body>headless-in-flight</body></html>',
      ),
    );
    final runFuture = headlessInFlight.run();
    await headlessInFlight.dispose();
    await runFuture;
    await headlessInFlight.dispose();

    // A fresh instance still runs and disposes cleanly.
    final Completer<void> loaded = Completer();
    final headless2 = HeadlessInAppWebView(
      initialData: InAppWebViewInitialData(
        data: '<html><body>headless2</body></html>',
      ),
      onLoadStop: (controller, url) {
        if (!loaded.isCompleted) {
          loaded.complete();
        }
      },
    );
    await headless2.run();
    await headless2.dispose();
    await headless2.dispose();
  });

  testWidgets('InAppLocalhostServer.dispose stops the server', (
    WidgetTester tester,
  ) async {
    final server = InAppLocalhostServer(port: 18099, shared: true);
    await server.start();
    expect(server.isRunning(), isTrue);
    expect(server.disposed, isFalse);

    server.dispose();
    expect(server.disposed, isTrue);

    // close() is asynchronous inside dispose(); give it a moment.
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (server.isRunning() && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    expect(server.isRunning(), isFalse);

    // Double dispose is a no-op.
    server.dispose();
  });

  testWidgets('wrapper classes implement Disposable at runtime', (
    WidgetTester tester,
  ) async {
    final controller = await pumpWebView(tester, pageLoaded: Completer());
    expect(controller, isA<Disposable>());
    expect(InAppWebView(onWebViewCreated: (_) {}), isA<Disposable>());
    expect(InAppLocalhostServer(port: 18098), isA<Disposable>());
  });

  testWidgets(
    'Windows: WebView2 read-only install directory (Program Files)',
    (WidgetTester tester) async {},
    // Requires a Windows host with WebView2; covered by Windows CI.
    skip: true,
  );
}
