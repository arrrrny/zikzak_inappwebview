import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// A10 (spec 001): iOS `takeScreenshot` with default configuration returns a
/// non-null [Uint8List] containing valid PNG image data once a real WebView has
/// loaded content.
///
/// Acceptance test: the native `takeScreenshot` handler only produces real
/// bytes when a live iOS WebView is attached, so it must run on an iOS device,
/// not the Dart-VM host compile-probe suites.
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
          // A real WebView always has a layout size; give it explicit bounds so
          // the native capture has a non-zero width/height to render.
          body: SizedBox(
            width: 400,
            height: 600,
            child: InAppWebView(
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
      ),
    );
    final controller = await created.future.timeout(const Duration(seconds: 120));
    await controller.loadData(
      data: '<html><body><h1>shot</h1><p>hello zikzak</p></body></html>',
    );
    // Slow first-launch on a physical device; 120s instead of the default 15s.
    await pageLoaded.future.timeout(const Duration(seconds: 120));
    await tester.pumpAndSettle();
    // The WKWebView layer must be committed/painted before takeSnapshot returns
    // a non-nil image; the simulator paints on a later run-loop pass, so wait
    // briefly for the content to appear (mirrors a real call after visible paint).
    await Future.delayed(const Duration(seconds: 2));
    return controller;
  }

  testWidgets(
    'A10 iOS takeScreenshot with default configuration returns valid PNG image bytes',
    (WidgetTester tester) async {
      // takeScreenshot is an iOS acceptance behavior (US5-AC1); skip elsewhere.
      if (!Platform.isIOS) return;

      final controller = await pumpWebView(tester, pageLoaded: Completer());

      final Uint8List? bytes = await controller
          .takeScreenshot()
          .timeout(const Duration(seconds: 120));

      expect(bytes, isNotNull,
          reason: 'takeScreenshot must return non-null bytes on iOS (US5-AC1)');
      expect(bytes!.length, greaterThan(100),
          reason: 'the screenshot byte buffer must be non-trivial');
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47],
          reason: 'returned bytes must be a valid PNG image (magic 89 50 4E 47)');
    },
  );
}
