// Lifecycle tests for LinuxHeadlessInAppWebView: run() must reach the shared
// 'wtf.zikzak/flutter_headless_inappwebview' channel with a generated id
// instead of throwing UnimplementedError from the platform-interface's
// PlatformHeadlessInAppWebView.id getter (the macOS port overrides id in its
// constructor; the Linux port did not, so run() died inside _init() before
// any channel call and every headless WebView was dead on arrival), and
// dispose() must tear the same id down through the same channel.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/headless_in_app_webview.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sharedChannel = MethodChannel(
    'wtf.zikzak/flutter_headless_inappwebview',
  );
  late List<MethodCall> sharedCalls;

  setUp(() {
    sharedCalls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sharedChannel, (call) async {
          sharedCalls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sharedChannel, null);
  });

  LinuxHeadlessInAppWebView build() => LinuxHeadlessInAppWebView(
    LinuxHeadlessInAppWebViewCreationParams(),
  );

  group('headless lifecycle', () {
    test('run() reaches the shared channel with a generated id', () async {
      final headless = build();
      await headless.run();

      expect(headless.id, isNotEmpty);
      expect(headless.isRunning(), isTrue);
      expect(sharedCalls.single.method, 'run');
      final args = sharedCalls.single.arguments as Map;
      expect(args['id'], headless.id);
      expect(args['params'], isMap);

      await headless.dispose();
    });

    test('dispose() tears the same id down through the shared channel', () async {
      final headless = build();
      await headless.run();
      await headless.dispose();

      expect(headless.isRunning(), isFalse);
      expect(sharedCalls.map((c) => c.method).toList(), ['run', 'dispose']);
      final disposeArgs =
          sharedCalls.last.arguments as Map;
      expect(disposeArgs['id'], headless.id);
    });

    test('distinct instances get distinct ids', () async {
      expect(build().id, isNot(equals(build().id)));
    });
  });
}
