import 'dart:async';
import 'dart:js_interop';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
// ignore: implementation_imports
import 'package:zikzak_inappwebview_web/src/in_app_webview_web_controller.dart';
import 'package:web/web.dart' as web;

void main() {
  test('getHtml() returns HTML content on Web', () async {
    // 1. Create and attach iframe
    final iframe = web.HTMLIFrameElement();
    iframe.id = 'test_iframe';
    // Append to body to ensure it is connected and has a contentWindow
    web.document.body!.appendChild(iframe);

    // 2. Create params
    final widgetParams = PlatformInAppWebViewWidgetCreationParams(
      controllerFromPlatform: (c) => c,
      windowId: 12345,
    );
    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: 12345,
      webviewParams: widgetParams,
    );

    // 3. Create controller
    final controller = InAppWebViewWebController(controllerParams, iframe);

    // 4. Load data
    final htmlData = """
<!DOCTYPE html>
<html>
<head>
    <title>Test Page</title>
</head>
<body>
    <h1>Hello World</h1>
</body>
</html>
""";
    
    // We use loadData which sets srcdoc
    controller.loadData(data: htmlData);

    // 5. Wait for load (iframe onload)
    final completer = Completer<void>();
    iframe.addEventListener(
      'load',
      ((web.Event event) {
        if (!completer.isCompleted) completer.complete();
      }).toJS,
    );
    
    // Also set a timeout
    try {
      await completer.future.timeout(const Duration(seconds: 2));
    } catch (e) {
      // Ignore timeout, we will poll anyway
    }

    // 6. Check getHtml
    // Poll for content because even after onLoad, the document might not be ready immediately in some environments
    String? content;
    for (int i = 0; i < 20; i++) {
      content = await controller.getHtml();
      if (content != null && content.contains('<h1>Hello World</h1>')) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // 7. Cleanup
    iframe.remove();

    // 8. Assert
    expect(content, isNotNull, reason: 'HTML content should not be null');
    expect(content, contains('<h1>Hello World</h1>'), reason: 'HTML content should contain "Hello World"');
  });
}
