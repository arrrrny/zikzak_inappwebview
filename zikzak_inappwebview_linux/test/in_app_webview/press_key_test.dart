import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/zikzak_inappwebview_linux.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('wtf.zikzak/zikzak_inappwebview_k');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async { calls.add(call); return null; });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  LinuxInAppWebViewController c() =>
      LinuxInAppWebViewController(PlatformInAppWebViewControllerCreationParams(id: 'k'));

  test('named keys map to XKB keysyms and X keycodes', () async {
    await c().pressKey(key: 'Enter', keyCode: 36);
    expect(calls.single.method, 'pressKey');
    expect(calls.single.arguments, {'keysym': 0xff0d, 'scanCode': 36, 'characters': '\r'});
  });

  test('named keys without text send empty characters', () async {
    await c().pressKey(key: 'Backspace', keyCode: 51);
    expect(calls.single.arguments, {'keysym': 0xff08, 'scanCode': 22, 'characters': ''});
  });

  test('printable characters use their Unicode keysym', () async {
    await c().pressKey(key: 'a', keyCode: 0, characters: 'a');
    expect(calls.single.arguments, {'keysym': 0x61, 'scanCode': 38, 'characters': 'a'});
  });

  test('upper-case letters keep their keysym and use the letter keycode', () async {
    await c().pressKey(key: 'A', keyCode: 0, characters: 'A');
    expect(calls.single.arguments, {'keysym': 0x41, 'scanCode': 38, 'characters': 'A'});
  });

  test('non-Latin-1 characters use the 0x01000000 + code point keysym', () async {
    await c().pressKey(key: 'ж', keyCode: 0);
    expect(calls.single.arguments, {'keysym': 0x01000000 + 0x436, 'scanCode': 0, 'characters': 'ж'});
  });

  test('unknown keys are rejected', () async {
    await expectLater(c().pressKey(key: 'NoSuchKey', keyCode: 0), throwsArgumentError);
    expect(calls, isEmpty);
  });
}
