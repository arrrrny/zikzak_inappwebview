import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/zikzak_inappwebview_windows.dart';

/// A [PlatformInAppWebViewController] double for the cookie manager's
/// controller-provided branch of `_call`. It records the CDP calls instead of
/// reaching the platform channel, so a test can tell which controller served
/// a cookie operation rather than inferring it from the wire.
class _RecordingController extends PlatformInAppWebViewController {
  _RecordingController()
    : super.implementation(
        const PlatformInAppWebViewControllerCreationParams(id: 'recording'),
      );

  /// DevTools methods called, in order.
  final List<Map<String, dynamic>> calls = <Map<String, dynamic>>[];

  /// CDP result returned per method, defaulting to an empty object.
  final Map<String, Object?> responses = <String, Object?>{
    'Network.getCookies': <String, Object?>{'cookies': <dynamic>[]},
    'Network.setCookie': <String, Object?>{'success': true},
  };

  @override
  Future<dynamic> callDevToolsProtocolMethod({
    required String methodName,
    Map<String, dynamic>? parameters,
  }) async {
    calls.add(<String, dynamic>{'method': methodName, ...?parameters});
    return responses[methodName] ?? <String, dynamic>{};
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('cookies await the visible profile, preserve native scopes and report failures', () async {
    final directory = await Directory.systemTemp.createTemp('zikzak-cookies-');
    addTearDown(() => directory.delete(recursive: true));
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const plugin = MethodChannel('io.jns.webview.win');
    const controller = MethodChannel('io.jns.webview.win/911');
    const events = MethodChannel('io.jns.webview.win/911/events');
    final creating = Completer<void>();
    final initialized = Completer<void>();
    final environmentCalls = <MethodCall>[];
    final calls = <Map<String, dynamic>>[];
    const session = {
      'name': 'SESSION',
      'value': 'native-token',
      'domain': '.example.test',
      'path': '/private',
      'httpOnly': true,
      'secure': true,
      'session': true,
      'expires': -1,
    };
    const persistent = {
      'name': 'PREFERENCE',
      'value': 'retained',
      'domain': 'example.test',
      'path': '/',
      'httpOnly': false,
      'secure': true,
      'session': false,
      'expires': 2000000000.5,
      'sameSite': 'Lax',
    };
    final responses = <String, Object? Function()>{
      'Storage.getCookies': () => {
        'cookies': [session, persistent],
      },
      'Network.getCookies': () => {
        'cookies': [session],
      },
      'Network.setCookie': () => {'success': true},
      'Network.deleteCookies': () => <String, dynamic>{},
      'Network.clearBrowserCookies': () => <String, dynamic>{},
    };
    messenger.setMockMethodCallHandler(plugin, (call) async {
      environmentCalls.add(call);
      return await <String, Future<Object?> Function()>{
        'initializeEnvironment': () async {
          creating.complete();
          await initialized.future;
          return null;
        },
        'initialize': () async => {'textureId': 911},
        'dispose': () async => null,
      }[call.method]!();
    });
    messenger.setMockMethodCallHandler(events, (_) async => null);
    messenger.setMockMethodCallHandler(controller, (call) async {
      final arguments = Map<String, dynamic>.from(call.arguments as Map);
      calls.add(arguments);
      return jsonEncode(responses[arguments['method']]!());
    });
    addTearDown(() => messenger.setMockMethodCallHandler(plugin, null));
    addTearDown(() => messenger.setMockMethodCallHandler(events, null));
    addTearDown(() => messenger.setMockMethodCallHandler(controller, null));

    ZikzakInAppWebViewWindows.registerWith();
    final settings = WebViewEnvironmentSettings(
      userDataFolder: directory.path,
      additionalBrowserArguments: '--proxy-server=http://127.0.0.1:18999',
    );
    final environment = PlatformWebViewEnvironment(
      PlatformWebViewEnvironmentCreationParams(settings: settings),
    );
    addTearDown(environment.dispose);
    final manager = PlatformCookieManager(
      PlatformCookieManagerCreationParams(webViewEnvironment: environment),
    );
    final profile = environment.create();
    final reading = manager.getAllCookies();
    await creating.future;
    expect(environmentCalls, hasLength(1));
    expect(calls, isEmpty);
    expect(
      environmentCalls.single.arguments,
      containsPair('userDataPath', directory.path),
    );
    expect(
      environmentCalls.single.arguments,
      containsPair('additionalArguments', settings.additionalBrowserArguments),
    );
    initialized.complete();
    final ready = await profile;
    final inventory = await reading;
    expect(ready.id, environment.id);
    expect(inventory.first.isHttpOnly, isTrue);
    expect(inventory.first.isSessionOnly, isTrue);
    expect(inventory.first.expiresDate, isNull);
    expect(inventory.last.expiresDate, 2000000000500);
    expect(inventory.last.sameSite, HTTPCookieSameSitePolicy.LAX);
    await WindowsWebViewEnvironment.initializeShared();
    expect(
      environmentCalls.where((call) => call.method == 'initializeEnvironment'),
      hasLength(1),
    );
    await expectLater(
      environment.create(
        settings: WebViewEnvironmentSettings(
          userDataFolder: '${directory.path}/other',
        ),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          allOf(
            contains('userDataFolder'),
            contains('${directory.path}/other'),
            contains(directory.path),
            contains('claims the default profile'),
          ),
        ),
      ),
    );
    await expectLater(
      environment.create(
        settings: WebViewEnvironmentSettings(
          additionalBrowserArguments: '--proxy-server=http://127.0.0.1:19000',
        ),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          allOf(
            contains('additionalBrowserArguments'),
            contains('--proxy-server=http://127.0.0.1:19000'),
          ),
        ),
      ),
    );
    await expectLater(
      environment.create(
        settings: WebViewEnvironmentSettings(
          userDataFolder: directory.path,
          additionalBrowserArguments: '--disable-web-security',
        ),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('additionalBrowserArguments'),
        ),
      ),
      reason: 'a folder spelled identically must not read as a conflict',
    );
    await expectLater(
      environment.create(
        settings: WebViewEnvironmentSettings(
          userDataFolder: '${directory.path}${p.separator}',
        ),
      ),
      completes,
      reason: 'a trailing separator is the same folder',
    );

    final url = WebUri('https://example.test/private/home');
    final selected = await manager.getCookie(url: url, name: 'SESSION');
    expect(selected?.path, '/private');
    expect(jsonDecode(calls.last['parameters'] as String), {
      'urls': [url.toString()],
    });
    expect(
      await manager.setCookie(
        url: url,
        name: 'SESSION',
        value: 'updated',
        path: '/private',
        isHttpOnly: true,
        isSecure: true,
        expiresDate: 2000000000500,
      ),
      isTrue,
    );
    expect(jsonDecode(calls.last['parameters'] as String), {
      'url': url.toString(),
      'name': 'SESSION',
      'value': 'updated',
      'path': '/private',
      'httpOnly': true,
      'secure': true,
      'expires': 2000000000.5,
    });
    expect(await manager.deleteCookies(url: url, path: '/private'), isTrue);
    expect(jsonDecode(calls.last['parameters'] as String), {
      'name': 'SESSION',
      'domain': '.example.test',
      'path': '/private',
    });
    // Without an explicit domain the cookie's own stored domain decides: a
    // dotted-domain cookie must not be deleted under the bare url host.
    expect(
      await manager.deleteCookie(url: url, name: 'SESSION', path: '/private'),
      isTrue,
    );
    expect(jsonDecode(calls.last['parameters'] as String), {
      'name': 'SESSION',
      'domain': '.example.test',
      'path': '/private',
    });
    expect(
      await manager.deleteCookie(url: url, name: 'ABSENT', path: '/private'),
      isTrue,
    );
    expect(jsonDecode(calls.last['parameters'] as String), {
      'name': 'ABSENT',
      'domain': url.host,
      'path': '/private',
    });
    expect(await manager.removeSessionCookies(), isTrue);
    expect(jsonDecode(calls.last['parameters'] as String), {
      'name': 'SESSION',
      'domain': '.example.test',
      'path': '/private',
    });
    expect(await manager.deleteAllCookies(), isTrue);
    // A supplied controller serves the operation, so the shared native cookie
    // controller is not created for it.
    final nativeInits = environmentCalls
        .where((call) => call.method == 'initialize')
        .length;
    final supplied = _RecordingController();
    expect(
      await manager.getCookies(url: url, webViewController: supplied),
      isEmpty,
    );
    expect(supplied.calls.map((call) => call['method']), [
      'Network.getCookies',
    ]);
    expect(supplied.calls.single['urls'], [url.toString()]);
    expect(
      environmentCalls.where((call) => call.method == 'initialize').length,
      nativeInits,
      reason: 'the supplied controller replaces the shared native one',
    );
    expect(
      await manager.deleteCookie(
        url: url,
        name: 'SESSION',
        path: '/private',
        webViewController: supplied,
      ),
      isTrue,
    );
    expect(supplied.calls.last['method'], 'Network.deleteCookies');
    expect(supplied.calls.last['name'], 'SESSION');
    expect(supplied.calls.length, 3, reason: 'read then delete, both supplied');
    expect(
      await manager.setCookie(
        url: url,
        name: 'SESSION',
        value: 'via-controller',
        webViewController: supplied,
      ),
      isTrue,
    );
    expect(supplied.calls.last['method'], 'Network.setCookie');
    expect(supplied.calls.last['value'], 'via-controller');
    responses['Network.setCookie'] = () => {'success': false};
    expect(
      await manager.setCookie(url: url, name: 'INVALID', value: 'rejected'),
      isFalse,
    );
    responses['Network.clearBrowserCookies'] = () =>
        throw PlatformException(code: 'native_failed');
    await expectLater(
      manager.deleteAllCookies(),
      throwsA(isA<PlatformException>()),
    );
  });
}
