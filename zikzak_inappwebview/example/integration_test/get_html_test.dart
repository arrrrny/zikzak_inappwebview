import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getHtml() returns HTML content', (WidgetTester tester) async {
    final Completer<void> pageLoaded = Completer<void>();
    InAppWebViewController? controller;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InAppWebView(
            onWebViewCreated: (c) {
              controller = c;
              c.loadData(data: """
<!DOCTYPE html>
<html>
<head>
    <title>Test Page</title>
</head>
<body>
    <h1>Hello World</h1>
</body>
</html>
""");
            },
            onLoadStop: (controller, url) {
              print('onLoadStop: $url');
              if (!pageLoaded.isCompleted) {
                pageLoaded.complete();
              }
            },
            onReceivedError: (controller, request, error) {
              print('onReceivedError: ${error.description}');
            },
          ),
        ),
      ),
    );

    // Wait for page to load
    await pageLoaded.future.timeout(const Duration(seconds: 10), onTimeout: () {
       print('Timeout waiting for page load');
    });
    
    // Extra delay to ensure JS execution (if any) or rendering
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(controller, isNotNull);

    try {
      final html = await controller!.getHtml();
      print('HTML Content: $html');
      
      expect(html, isNotNull);
      expect(html, contains('<h1>Hello World</h1>'));
    } catch (e) {
      fail('getHtml() failed with error: $e');
    }
  });
}