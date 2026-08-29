import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// A4 (spec 001): Android `createPdf` returns a non-null [Uint8List] containing
/// valid PDF data (%PDF header) once a real WebView has loaded content.
///
/// This is an acceptance test: the platform `createPdf` handler only produces
/// real PDF bytes when a live Android WebView is attached and ready, so it must
/// run on a device/emulator, not the Dart-VM host compile-probe suites.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<InAppWebViewController> pumpWebView(
    WidgetTester tester, {
    required Completer<void> pageLoaded,
    String content = '<html><body><h1>pdf</h1><p>hello zikzak</p></body></html>',
  }) async {
    final Completer<InAppWebViewController> created = Completer();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          // A real WebView always has a layout size; give it explicit bounds so
          // the native createPdf capture has a non-zero width/height to render.
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
    await controller.loadData(data: content);
    // Slow 2019 Intel Mac / emulator: 120s instead of the default 15s.
    await pageLoaded.future.timeout(const Duration(seconds: 120));
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets(
    'A4 Android createPdf returns non-null valid PDF bytes',
    (WidgetTester tester) async {
      // createPdf is an Android acceptance behavior (US2-AC1); skip elsewhere.
      if (!Platform.isAndroid) return;

      final controller = await pumpWebView(tester, pageLoaded: Completer());

      final Uint8List? pdf = await controller
          .createPdf(pdfConfiguration: PDFConfiguration())
          .timeout(const Duration(seconds: 120));

      expect(pdf, isNotNull,
          reason: 'createPdf must return non-null PDF bytes on Android (US2-AC1)');
      expect(pdf!.length, greaterThan(4),
          reason: 'the PDF byte buffer must be non-trivial');
      final header = String.fromCharCodes(pdf.sublist(0, pdf.length >= 5 ? 5 : pdf.length));
      expect(header.startsWith('%PDF'), isTrue,
          reason: 'returned bytes must be a valid PDF document (%PDF header)');
    },
  );

  testWidgets(
    'A5 Android createPdf with A4 page size produces A4 pages with all content',
    (WidgetTester tester) async {
      // A4 page-size pagination is an Android acceptance behavior (US2-AC2).
      if (!Platform.isAndroid) return;

      // A tall document forces the content to span more than one A4 page.
      final tallContent = '<html><body style="margin:0">'
          '${List.generate(40, (i) => '<div style="height:60px;background:#eee">row $i</div>').join()}'
          '</body></html>';
      final controller = await pumpWebView(
        tester,
        pageLoaded: Completer(),
        content: tallContent,
      );

      final Uint8List? pdf = await controller
          .createPdf(
            pdfConfiguration: PDFConfiguration(
              pageSize: const Size(595.28, 841.89),
            ),
          )
          .timeout(const Duration(seconds: 120));

      expect(pdf, isNotNull,
          reason: 'A4 createPdf must return non-null PDF bytes (US2-AC2)');
      expect(String.fromCharCodes(pdf!.sublist(0, 5)).startsWith('%PDF'), isTrue,
          reason: 'A4 result must be a valid PDF document');

      final text = String.fromCharCodes(pdf);
      final mediaBoxes = RegExp(
        r'/MediaBox\s*\[\s*0\s+0\s+([\d.]+)\s+([\d.]+)\s*\]',
      ).allMatches(text).toList();
      expect(mediaBoxes.length, greaterThanOrEqualTo(2),
          reason: 'A4 content must paginate across at least 2 pages (US2-AC2)');

      final w = double.parse(mediaBoxes.first.group(1)!);
      final h = double.parse(mediaBoxes.first.group(2)!);
      expect((w - 595.28).abs(), lessThan(6),
          reason: 'first page width must be ~A4 width 595.28 pt (got $w)');
      expect((h - 841.89).abs(), lessThan(6),
          reason: 'first page height must be ~A4 height 841.89 pt (got $h)');
    },
  );
}
