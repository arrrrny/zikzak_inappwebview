import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// A1 (spec 001): macOS `takeScreenshot` returns a non-null [Uint8List]
/// containing valid PNG image data once a real WebView has loaded content.
///
/// Acceptance test: the native `takeScreenshot` handler only produces real
/// bytes when a live macOS WebView is attached, so it must run on the macOS
/// desktop target, not the Dart-VM host compile-probe suites.
(int, int) _pngSize(Uint8List b) {
  // PNG IHDR: width at bytes 16..19, height at bytes 20..23 (big-endian).
  final w = (b[16] << 24) | (b[17] << 16) | (b[18] << 8) | b[19];
  final h = (b[20] << 24) | (b[21] << 16) | (b[22] << 8) | b[23];
  return (w, h);
}

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
    // Slow 2019 Intel Mac: 120s instead of the default 15s.
    await pageLoaded.future.timeout(const Duration(seconds: 120));
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets(
    'A1 macOS takeScreenshot returns non-null valid PNG image bytes',
    (WidgetTester tester) async {
      // takeScreenshot is a macOS acceptance behavior (US1-AC1); skip elsewhere.
      if (!Platform.isMacOS) return;

      final controller = await pumpWebView(tester, pageLoaded: Completer());

      final Uint8List? bytes = await controller
          .takeScreenshot()
          .timeout(const Duration(seconds: 120));

      expect(bytes, isNotNull,
          reason: 'takeScreenshot must return non-null bytes on macOS (US1-AC1)');
      expect(bytes!.length, greaterThan(100),
          reason: 'the screenshot byte buffer must be non-trivial');
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47],
          reason: 'returned bytes must be a valid PNG image (magic 89 50 4E 47)');
    },
  );

  testWidgets(
    'A2 macOS takeScreenshot with JPEG format and quality 80 returns valid JPEG bytes',
    (WidgetTester tester) async {
      // takeScreenshot JPEG is a macOS acceptance behavior (US1-AC2); skip elsewhere.
      if (!Platform.isMacOS) return;

      final controller = await pumpWebView(tester, pageLoaded: Completer());

      final Uint8List? bytes = await controller
          .takeScreenshot(
            screenshotConfiguration: ScreenshotConfiguration(
              compressFormat: CompressFormat.JPEG,
              quality: 80,
            ),
          )
          .timeout(const Duration(seconds: 120));

      expect(bytes, isNotNull,
          reason: 'takeScreenshot must return non-null bytes on macOS (US1-AC2)');
      expect(bytes!.length, greaterThan(100),
          reason: 'the screenshot byte buffer must be non-trivial');
      // JPEG SOI marker is FF D8 FF (the 4th byte may vary, so check the first 3).
      expect(bytes.sublist(0, 3), [0xFF, 0xD8, 0xFF],
          reason: 'returned bytes must be a valid JPEG image (magic FF D8 FF)');
    },
  );

  testWidgets(
    'A3 macOS takeScreenshot with rect captures only the specified portion of the view',
    (WidgetTester tester) async {
      // takeScreenshot rect crop is a macOS acceptance behavior (US1-AC3); skip elsewhere.
      if (!Platform.isMacOS) return;

      final controller = await pumpWebView(tester, pageLoaded: Completer());

      final Uint8List? full = await controller
          .takeScreenshot()
          .timeout(const Duration(seconds: 120));
      expect(full, isNotNull, reason: 'full screenshot must be non-null (US1-AC1)');
      expect(full!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47],
          reason: 'full screenshot must be a valid PNG');
      final (fullW, fullH) = _pngSize(full);
      expect(fullW, greaterThan(0));
      expect(fullH, greaterThan(0));

      // Crop the left-half / top-half of the 400x600 view: rect = 200x300 CSS px.
      final Uint8List? cropped = await controller
          .takeScreenshot(
            screenshotConfiguration: ScreenshotConfiguration(
              rect: InAppWebViewRect(x: 0, y: 0, width: 200, height: 300),
            ),
          )
          .timeout(const Duration(seconds: 120));
      expect(cropped, isNotNull, reason: 'cropped screenshot must be non-null (US1-AC3)');
      expect(cropped!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47],
          reason: 'cropped screenshot must be a valid PNG');
      final (cropW, cropH) = _pngSize(cropped);

      // The crop is exactly half the view in each axis (rect 200x300 of a 400x600
      // view); the captured PNG must be smaller than the full one and ~half its
      // size in each dimension (US1-AC3).
      expect(cropW, lessThan(fullW), reason: 'rect must crop the width (US1-AC3)');
      expect(cropH, lessThan(fullH), reason: 'rect must crop the height (US1-AC3)');
      expect(cropW, closeTo(fullW / 2, 2.0),
          reason: 'cropped width must be ~half the full width');
      expect(cropH, closeTo(fullH / 2, 2.0),
          reason: 'cropped height must be ~half the full height');
    },
  );
}
