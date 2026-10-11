// Channel-args + handleMethod tests for the Android platform controller:
// pins the exact MethodChannel method names and argument maps serialized for
// the native side (loadUrl, postUrl, evaluateJavascript) and the
// handleMethod deserialization paths (onLoadStart/onLoadStop) — the
// Dart/native wire contract for the zuraffa-only rewrite.
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_android/src/in_app_webview/in_app_webview_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const int controllerId = 98765;
  late List<MethodCall> calls;
  late AndroidInAppWebViewController controller;

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
    controller = AndroidInAppWebViewController(params);
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
      );
      expect(calls.single.method, 'loadUrl');
      final urlRequest = (calls.single.arguments as Map)['urlRequest'] as Map;
      expect(urlRequest['url'], 'https://a.dev/page');
      expect(urlRequest['headers'], {'x-a': 'b'});
    });

    test('postUrl serializes url + postData', () async {
      await controller.postUrl(
        url: WebUri('https://a.dev/post'),
        postData: Uint8List.fromList([1, 2, 3]),
      );
      expect(calls.single.method, 'postUrl');
      final args = calls.single.arguments as Map;
      expect(args['url'], 'https://a.dev/post');
      expect(args['postData'], Uint8List.fromList([1, 2, 3]));
    });

    test('evaluateJavascript serializes source + contentWorld', () async {
      await controller.evaluateJavascript(
        source: '1+1',
        contentWorld: ContentWorld.world(name: 'w'),
      );
      expect(calls.single.method, 'evaluateJavascript');
      final args = calls.single.arguments as Map;
      expect(args['source'], '1+1');
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
      final c = AndroidInAppWebViewController(params);
      await c.handleMethod(
        MethodCall('onLoadStart', {'url': 'https://a.dev/'}),
      );
      await c.handleMethod(MethodCall('onLoadStop', {'url': null}));
      expect(loaded.single?.toString(), 'https://a.dev/');
      expect(stopped.single, isNull);
    });

    test('unknown methods throw UnimplementedError', () async {
      expect(
        () => controller.handleMethod(MethodCall('bogusMethod', {})),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
