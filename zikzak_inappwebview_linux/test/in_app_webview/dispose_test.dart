import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/zikzak_inappwebview_linux.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('wtf.zikzak/zikzak_inappwebview_d');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  LinuxInAppWebViewController build() =>
      LinuxInAppWebViewController(PlatformInAppWebViewControllerCreationParams(id: 'd'));

  test('dispose does not throw, also when called twice', () async {
    final c = build();
    // dispose() returns void: a throw would fail the test synchronously, and
    // an async error escaping it fails the test zone once pumped.
    c.dispose();
    c.dispose();
    await pumpEventQueue();
    // The widget owns the native webview; the controller sends nothing.
    expect(calls, isEmpty);
  });

  test('dispose with isKeepAlive does not throw, also when called twice', () async {
    final c = build();
    c.dispose(isKeepAlive: true);
    c.dispose(isKeepAlive: true);
    await pumpEventQueue();
    expect(calls, isEmpty);
  });

  test('dispose stops handling native calls', () async {
    final loads = <WebUri?>[];
    final c = LinuxInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams(
        id: 'd',
        webviewParams: PlatformInAppWebViewWidgetCreationParams(onLoadStart: (_, url) => loads.add(url)),
      ),
    );
    Future<void> sendFromNative() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          channel.name,
          const StandardMethodCodec().encodeMethodCall(const MethodCall('onLoadStart', {'url': 'https://a.b/'})),
          (_) {},
        );
    await sendFromNative();
    expect(loads, hasLength(1));
    c.dispose();
    await sendFromNative();
    expect(loads, hasLength(1));
  });
}
