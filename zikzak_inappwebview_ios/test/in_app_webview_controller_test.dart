// Channel-args + handleMethod tests for the iOS platform controller:
// pins the exact MethodChannel method names and argument maps serialized for
// the native side (loadUrl, postUrl, evaluateJavascript) and the
// handleMethod deserialization paths (onLoadStart/onLoadStop) — the
// Dart/native wire contract for the zuraffa-only rewrite.
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_ios/src/in_app_webview/in_app_webview_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const int controllerId = 123123;
  late List<MethodCall> calls;
  late IOSInAppWebViewController controller;

  setUp(() {
    calls = [];
    MethodChannel('wtf.zikzak/zikzak_inappwebview_$controllerId')
        .setMockMethodCallHandler((call) async {
      calls.add(call);
      return null;
    });
    final params = PlatformInAppWebViewControllerCreationParams(
      id: controllerId,
      webviewParams: PlatformInAppWebViewWidgetCreationParams(
        controllerFromPlatform: (c) => c,
      ),
    );
    controller = IOSInAppWebViewController(params);
  });

  tearDown(() {
    MethodChannel('wtf.zikzak/zikzak_inappwebview_$controllerId')
        .setMockMethodCallHandler(null);
  });

  group('channel-arg serialization', () {
    test('loadUrl serializes urlRequest + allowingReadAccessTo', () async {
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://a.dev/page'),
          headers: {'x-a': 'b'},
        ),
        allowingReadAccessTo: WebUri('file:///tmp'),
      );
      expect(calls.single.method, 'loadUrl');
      final args = calls.single.arguments as Map;
      final urlRequest = args['urlRequest'] as Map;
      expect(urlRequest['url'], 'https://a.dev/page');
      expect(urlRequest['headers'], {'x-a': 'b'});
      expect(args['allowingReadAccessTo'], 'file:///tmp');
    });

    test('postUrl serializes url + postData', () async {
      await controller.postUrl(
        url: WebUri('https://a.dev/post'),
        postData: Uint8List.fromList([9, 8]),
      );
      expect(calls.single.method, 'postUrl');
      final args = calls.single.arguments as Map;
      expect(args['url'], 'https://a.dev/post');
      expect(args['postData'], Uint8List.fromList([9, 8]));
    });

    test('evaluateJavascript serializes source + contentWorld', () async {
      await controller.evaluateJavascript(
        source: 'document.title',
        contentWorld: ContentWorld.world(name: 'w'),
      );
      expect(calls.single.method, 'evaluateJavascript');
      final args = calls.single.arguments as Map;
      expect(args['source'], 'document.title');
      expect(args['contentWorld'], {'name': 'w'});
    });
  });

  group('handleMethod deserialization', () {
    test('onLoadStart + onLoadStop deliver WebUri', () async {
      final loaded = <WebUri?>[];
      final stopped = <WebUri?>[];
      final params = PlatformInAppWebViewControllerCreationParams(
        id: controllerId,
        webviewParams: PlatformInAppWebViewWidgetCreationParams(
          controllerFromPlatform: (c) => c,
          onLoadStart: (c, url) => loaded.add(url),
          onLoadStop: (c, url) => stopped.add(url),
        ),
      );
      final c = IOSInAppWebViewController(params);
      await c.handleMethod(
        MethodCall('onLoadStart', {'url': 'https://a.dev/'}),
      );
      await c.handleMethod(MethodCall('onLoadStop', {'url': null}));
      expect(loaded.single?.toString(), 'https://a.dev/');
      expect(stopped.single, isNull);
    });
  });
}
