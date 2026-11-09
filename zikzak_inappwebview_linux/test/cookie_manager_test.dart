import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/zikzak_inappwebview_linux.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('wtf.zikzak/zikzak_inappwebview_cookiemanager');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  final manager = LinuxCookieManager(const LinuxCookieManagerCreationParams());
  final url = WebUri('https://example.com/');

  Map<dynamic, dynamic> sent() =>
      (calls.single.arguments as Map)['cookie'] as Map;

  test('sameSite is sent as the native spelling', () async {
    await manager.setCookie(
        url: url, name: 'a', value: '1', sameSite: HTTPCookieSameSitePolicy.LAX);
    expect(sent()['sameSite'], 'Lax');
    calls.clear();
    await manager.setCookie(
        url: url,
        name: 'a',
        value: '1',
        sameSite: HTTPCookieSameSitePolicy.STRICT);
    expect(sent()['sameSite'], 'Strict');
  });

  test('maxAge becomes an absolute expiresDate', () async {
    final before = DateTime.now().millisecondsSinceEpoch;
    await manager.setCookie(url: url, name: 'a', value: '1', maxAge: 60);
    final after = DateTime.now().millisecondsSinceEpoch;
    final expires = sent()['expiresDate'] as int;
    expect(expires, inInclusiveRange(before + 60000, after + 60000));
    expect(sent().containsKey('maxAge'), isFalse);
  });

  test('explicit expiresDate wins over maxAge', () async {
    await manager.setCookie(
        url: url, name: 'a', value: '1', expiresDate: 123456, maxAge: 60);
    expect(sent()['expiresDate'], 123456);
  });
}
