import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
// ignore: implementation_imports
import 'package:zikzak_inappwebview_web/src/in_app_webview_web_controller.dart';
import 'package:web/web.dart' as web;

void main() {
  test('getHtml() on cross-origin website (pub.dev)', () async {
    // 1. Create and attach iframe
    final iframe = web.HTMLIFrameElement();
    iframe.id = 'test_iframe_pub';
    web.document.body!.appendChild(iframe);

    // 2. Create controller
    final widgetParams = PlatformInAppWebViewWidgetCreationParams(
      controllerFromPlatform: (c) => c,
      windowId: 54321,
    );
    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: 54321,
      webviewParams: widgetParams,
    );
    final controller = InAppWebViewWebController(controllerParams, iframe);

    // 3. Load pub.dev
    // Note: pub.dev might block iframing via X-Frame-Options, but we are testing getHtml behavior
    final url = WebUri('https://pub.dev');
    await controller.loadUrl(urlRequest: URLRequest(url: url));

    // Wait for some time to allow potential loading
    await Future.delayed(const Duration(seconds: 3));

    // 4. Try getHtml
    final html = await controller.getHtml();
    print('Result for pub.dev: $html');

    // We expect null because of Cross-Origin policies
    expect(html, isNull, reason: 'Should return null for cross-origin content due to browser security policies');

    // Cleanup
    iframe.remove();
  });

  test('getHtml() on cross-origin website (example.com)', () async {
    // 1. Create and attach iframe
    final iframe = web.HTMLIFrameElement();
    iframe.id = 'test_iframe_example';
    web.document.body!.appendChild(iframe);

    // 2. Create controller
    final widgetParams = PlatformInAppWebViewWidgetCreationParams(
      controllerFromPlatform: (c) => c,
      windowId: 54322,
    );
    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: 54322,
      webviewParams: widgetParams,
    );
    final controller = InAppWebViewWebController(controllerParams, iframe);

    // 3. Load example.com (usually allows iframing)
    final url = WebUri('https://example.com');
    await controller.loadUrl(urlRequest: URLRequest(url: url));

    // Wait for some time
    await Future.delayed(const Duration(seconds: 3));

    // 4. Try getHtml
    final html = await controller.getHtml();
    print('Result for example.com: $html');

    // We expect null because of Cross-Origin policies
    expect(html, isNull, reason: 'Should return null for cross-origin content due to browser security policies');

    // Cleanup
    iframe.remove();
  });
}
