import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/zikzak_inappwebview_linux.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const id = 'test-id';
  const channel = MethodChannel('wtf.zikzak/zikzak_inappwebview_$id');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'isVisible':
        case 'isMuted':
        case 'isPlayingAudio':
        case 'requestFocus':
        case 'requestPointerLock':
        case 'restoreState':
          return true;
        case 'getScreenScale':
          return 2.0;
        case 'saveState':
          return Uint8List.fromList([1, 2, 3]);
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  LinuxInAppWebViewController controller() => LinuxInAppWebViewController(
        PlatformInAppWebViewControllerCreationParams(id: id),
      );

  test('the 15 Linux-only methods call their channel methods', () async {
    final c = controller();
    expect(await c.isVisible(), isTrue);
    await c.setVisible(visible: false);
    expect(await c.getScreenScale(), 2.0);
    await c.setScreenScale(scale: 1.5);
    await c.setTargetRefreshRate(rate: 30);
    await c.requestEnterFullscreen();
    await c.requestExitFullscreen();
    expect(await c.isMuted(), isTrue);
    await c.setMuted(muted: true);
    expect(await c.isPlayingAudio(), isTrue);
    expect(await c.saveState(), [1, 2, 3]);
    expect(await c.restoreState(Uint8List.fromList([1, 2, 3])), isTrue);
    await c.terminateWebProcess();
    expect(await c.requestFocus(), isTrue);
    expect(await c.requestPointerLock(), isTrue);
    expect(calls.map((m) => m.method).toList(), <String>[
      'isVisible', 'setVisible', 'getScreenScale', 'setScreenScale', 'setTargetRefreshRate',
      'requestEnterFullscreen', 'requestExitFullscreen', 'isMuted', 'setMuted', 'isPlayingAudio',
      'saveState', 'restoreState', 'terminateWebProcess', 'requestFocus', 'requestPointerLock',
    ]);
  });

  test('argument shapes match what linux/in_app_webview/webview_channel_delegate.cc reads', () async {
    final c = controller();
    await c.setVisible(visible: false);
    await c.setScreenScale(scale: 1.5);
    await c.setTargetRefreshRate(rate: 30);
    await c.setMuted(muted: true);
    await c.restoreState(Uint8List.fromList([1, 2, 3]));
    final args = {for (final m in calls) m.method: m.arguments};
    // setVisible, setScreenScale and setTargetRefreshRate take a bare value.
    expect(args['setVisible'], false);
    expect(args['setScreenScale'], 1.5);
    expect(args['setTargetRefreshRate'], 30);
    expect(args['setMuted'], {'muted': true});
    expect(args['restoreState'], {'state': [1, 2, 3]});
  });
}
