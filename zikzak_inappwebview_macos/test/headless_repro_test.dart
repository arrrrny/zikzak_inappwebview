import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_macos/src/in_app_webview/headless_in_app_webview.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('headless run() sends valid args without throwing', () async {
    final headless = MacOSHeadlessInAppWebView(
      PlatformHeadlessInAppWebViewCreationParams(
        initialUrlRequest: URLRequest(url: WebUri('https://flutter.dev')),
        initialSettings: InAppWebViewSettings(isInspectable: true),
        onWebViewCreated: (controller) {
          print('HEADLESS onWebViewCreated FIRED');
        },
      ),
    );

    final sharedChannel = const MethodChannel(
      'wtf.zikzak/flutter_headless_inappwebview',
    );
    Map<String, dynamic>? capturedArgs;
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sharedChannel, (call) async {
      calls.add(call.method);
      if (call.method == 'run') {
        capturedArgs = (call.arguments as Map).cast<String, dynamic>();
      }
      return true;
    });

    try {
      await headless.run().timeout(const Duration(seconds: 5));
      print('RUN COMPLETED OK');
    } catch (e, st) {
      print('RUN THREW: $e');
      print(st);
      fail('run() threw: $e');
    }

    print('CHANNEL CALLS: $calls');
    final params = capturedArgs?['params'] as Map<String, dynamic>?;
    print('initialUrlRequest: ${params?['initialUrlRequest']}');
    print('initialSettings: ${params?['initialSettings']}');
    print('initialSize: ${params?['initialSize']}');
    expect(params, isNotNull);
  });
}
