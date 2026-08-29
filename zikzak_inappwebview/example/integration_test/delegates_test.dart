import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// A6 runtime verification (spec 011): the Android/iOS platform implementation
/// exposes non-null delegate instances for all four domains
/// (navigation / javaScript / cookies / settings) once a real WebView is live.
///
/// This is an integration test because the delegates are only populated when a
/// real platform controller (MethodChannel-backed) is attached. The host
/// compile-probe suites (`android_delegates_test.dart`, `ios_delegates_test.dart`)
/// only prove the symbols compile and instantiate — not that the live platform
/// returns non-null delegates. SC-004 requires the runtime check, which is what
/// this test provides on a real device/emulator.
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
            // A unique key forces the platform view to be recreated on every
            // pump, faithfully simulating a fresh attachment (see lifecycle_test).
            key: UniqueKey(),
            onWebViewCreated: (c) {
              if (!created.isCompleted) created.complete(c);
            },
            onLoadStop: (controller, url) {
              if (!pageLoaded.isCompleted) pageLoaded.complete();
            },
          ),
        ),
      ),
    );
    final controller = await created.future.timeout(const Duration(seconds: 120));
    await controller.loadData(
      data: '<html><body><h1>delegates</h1></body></html>',
    );
    // Slow 2019 Intel Mac / emulator: 120s instead of the default 15s.
    await pageLoaded.future.timeout(const Duration(seconds: 120));
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets(
    'A6 platform exposes non-null domain delegates at runtime',
    (WidgetTester tester) async {
      // SC-004 is an Android/iOS requirement; desktop platforms do not override
      // the delegate getters, so skip elsewhere rather than fail.
      if (!Platform.isAndroid && !Platform.isIOS) {
        return;
      }

      final controller = await pumpWebView(tester, pageLoaded: Completer());

      final platform = controller.platform;
      expect(platform, isNotNull);

      // Each domain delegate must be a concrete, non-null instance supplied by
      // the live platform implementation (FR-004 / SC-004).
      expect(platform.navigationDelegate, isNotNull,
          reason: 'navigationDelegate must be non-null at runtime (FR-004/SC-004)');
      expect(platform.javaScriptDelegate, isNotNull,
          reason: 'javaScriptDelegate must be non-null at runtime (FR-004/SC-004)');
      expect(platform.cookieDelegate, isNotNull,
          reason: 'cookieDelegate must be non-null at runtime (FR-004/SC-004)');
      expect(platform.settingsDelegate, isNotNull,
          reason: 'settingsDelegate must be non-null at runtime (FR-004/SC-004)');

      // The convenience facades on the monolith must resolve through them too.
      expect(controller.navigation, isNotNull);
      expect(controller.javaScript, isNotNull);
      expect(controller.cookies, isNotNull);
      expect(controller.settings, isNotNull);
    },
  );
}
