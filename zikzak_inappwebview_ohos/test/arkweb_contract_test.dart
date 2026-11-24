import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_ohos/zikzak_inappwebview_ohos.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

const viewChannel = MethodChannel('wtf.zikzak/arkweb_12');
const cookieChannel = MethodChannel('wtf.zikzak/arkweb_cookies');

Future<dynamic> nativeEvent(String name, Map<String, dynamic> data) async {
  final response = Completer<ByteData?>();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(
        viewChannel.name,
        const StandardMethodCodec().encodeMethodCall(
          MethodCall(name, jsonEncode(data)),
        ),
        response.complete,
      );
  return const StandardMethodCodec().decodeEnvelope((await response.future)!);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OhosInAppWebViewController controller;
  setUp(() {
    OhosInAppWebViewPlatform.registerWith();
    controller = PlatformInAppWebViewController(
      const PlatformInAppWebViewControllerCreationParams(id: 12),
    ) as OhosInAppWebViewController;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(viewChannel, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(viewChannel, null);
    controller.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(cookieChannel, null);
  });

  test(
    'JavaScript handlers return asynchronous structured values to the page',
    () async {
      controller.addJavaScriptHandler(
        handlerName: 'echo',
        callback: (args) async => {'received': args.single, 'answer': '中文'},
      );
      final reply = await nativeEvent('onCallJsHandler', {
        'handlerName': 'echo',
        'args': [
          {'number': 7},
        ],
      });
      expect(jsonDecode(reply as String), {
        'received': {'number': 7},
        'answer': '中文',
      });
      controller.removeJavaScriptHandler(handlerName: 'echo');
      expect(
        nativeEvent('onCallJsHandler', {'handlerName': 'echo', 'args': []}),
        throwsA(isA<PlatformException>()),
      );
    },
  );

  test(
    'missing media permission callback denies the requested resources',
    () async {
      expect(
        await nativeEvent('onPermissionRequest', {
          'origin': 'https://example.com',
          'resources': ['VIDEO', 'AUDIO'],
        }),
        isEmpty,
      );
    },
  );

  test('navigation policy receives the app-facing controller', () async {
    controller.dispose();
    final publicController = Object();
    Object? receivedController;
    String? receivedUrl;
    controller = OhosInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams(
        id: 12,
        webviewParams: PlatformInAppWebViewWidgetCreationParams(
          controllerFromPlatform: (_) => publicController,
          shouldOverrideUrlLoading: (owner, action) async {
            receivedController = owner;
            receivedUrl = action.request.url.toString();
            return NavigationActionPolicy.CANCEL;
          },
        ),
      ),
    );
    expect(
      await nativeEvent('shouldOverrideUrlLoading', {
        'url': 'https://blocked.example/',
        'method': 'GET',
        'isMainFrame': true,
      }),
      isFalse,
    );
    expect(receivedController, same(publicController));
    expect(receivedUrl, 'https://blocked.example/');
  });

  test(
    'JavaScript results retain nested JSON and native failures propagate',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            viewChannel,
            (_) async => '{"answer":[42,true,"珞家"]}',
          );
      expect(await controller.evaluateJavascript(source: 'window.answer'), {
        'answer': [42, true, '珞家'],
      });
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            viewChannel,
            (_) async => throw PlatformException(
              code: 'ARKWEB_ERROR',
              message: 'detached',
            ),
          );
      expect(
        controller.evaluateJavascript(source: 'window.answer'),
        throwsA(isA<PlatformException>()),
      );
      await expectLater(
        controller.startInitialLoad(),
        throwsA(isA<PlatformException>()),
      );
    },
  );

  test(
    'disposed controllers cannot send commands to a reused native view',
    () async {
      final calls = <String>[];
      final initial = Completer<void>();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(viewChannel, (call) async {
            calls.add(call.method);
            return {
              'startInitialLoad': initial.future,
              'dispose': Future<void>.value(),
            }[call.method];
          });
      final startup = controller.startInitialLoad();
      controller.dispose();
      controller.dispose();
      initial.completeError(
        PlatformException(code: 'ARKWEB_ERROR', message: 'disposed'),
      );
      await startup;
      expect(calls, ['startInitialLoad', 'dispose']);
      expect(() => controller.reload(), throwsStateError);
    },
  );

  test('resource errors distinguish DNS, timeout and TLS failures', () async {
    controller.dispose();
    final errors = <WebResourceErrorType?>[];
    controller = OhosInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams(
        id: 12,
        webviewParams: PlatformInAppWebViewWidgetCreationParams(
          onReceivedError: (_, _, error) => errors.add(error.type),
        ),
      ),
    );
    await nativeEvent('onReceivedError', {
      'url': 'https://example.invalid/',
      'description': 'DNS',
      'errorCode': -105,
    });
    await nativeEvent('onReceivedError', {
      'url': 'https://example.invalid/',
      'description': 'timeout',
      'errorCode': -118,
    });
    await nativeEvent('onReceivedError', {
      'url': 'https://example.invalid/',
      'description': 'TLS',
      'errorCode': -107,
    });
    await nativeEvent('onReceivedError', {
      'url': 'https://example.invalid/',
      'description': 'new error',
      'errorCode': -9999,
    });
    expect(errors, [
      WebResourceErrorType.HOST_LOOKUP,
      WebResourceErrorType.TIMEOUT,
      WebResourceErrorType.FAILED_SSL_HANDSHAKE,
      WebResourceErrorType.UNKNOWN,
    ]);
  });

  test(
    'bulk deletion preserves native scopes and reads inventory only twice',
    () async {
      final before = jsonEncode([
        {
          'name': 'session',
          'value': 'host',
          'domain': 'example.com',
          'path': '/',
          'isSecure': true,
          'isHttpOnly': true,
          'isSessionCookie': true,
        },
        {
          'name': 'session',
          'value': 'domain',
          'domain': '.example.com',
          'path': '/',
          'isSecure': false,
          'isHttpOnly': false,
          'isSessionCookie': true,
        },
      ]);
      final replies = [before, '[]'].iterator;
      final writes = <String>[];
      var reads = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            cookieChannel,
            (call) async => <String, Object? Function()>{
              'getAllCookies': () {
                reads++;
                replies.moveNext();
                return replies.current;
              },
              'setCookie': () {
                writes.add(
                  (jsonDecode(call.arguments as String) as Map)['cookie']
                      as String,
                );
                return true;
              },
            }[call.method]!(),
          );
      final cookies = PlatformCookieManager(
        const PlatformCookieManagerCreationParams(),
      );
      expect(
        await cookies.deleteCookies(url: WebUri('https://example.com/')),
        isTrue,
      );
      expect(reads, 2);
      expect(writes, [
        'session=; Path=/; Max-Age=0; Secure; HttpOnly',
        'session=; Path=/; Domain=.example.com; Max-Age=0',
      ]);
    },
  );

  test('default-domain deletion detects an unchanged domain cookie', () async {
    final inventory = jsonEncode([
      {
        'name': 'session',
        'value': 'domain',
        'domain': '.example.com',
        'path': '/',
        'isSecure': false,
        'isHttpOnly': false,
        'isSessionCookie': true,
      },
    ]);
    final writes = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          cookieChannel,
          (call) async => <String, Object? Function()>{
            'getAllCookies': () => inventory,
            'setCookie': () {
              writes.add(
                (jsonDecode(call.arguments as String) as Map)['cookie']
                    as String,
              );
              return true;
            },
          }[call.method]!(),
        );
    final cookies = PlatformCookieManager(
      const PlatformCookieManagerCreationParams(),
    );
    expect(
      await cookies.deleteCookie(
        url: WebUri('https://example.com/'),
        name: 'session',
      ),
      isFalse,
    );
    expect(writes, ['session=; Path=/; Domain=.example.com; Max-Age=0']);
  });

  test(
    'native cookie inventory preserves path variants and host-only scope',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            cookieChannel,
            (_) async => jsonEncode([
              {
                'name': 'session',
                'value': 'root',
                'domain': 'example.com',
                'path': '/',
                'isSecure': true,
                'isHttpOnly': true,
                'isSessionCookie': true,
              },
              {
                'name': 'session',
                'value': 'auth',
                'domain': 'example.com',
                'path': '/auth',
                'isSecure': true,
                'isHttpOnly': true,
                'isSessionCookie': true,
              },
              {
                'name': 'other',
                'value': 'private',
                'domain': 'other.example.com',
                'path': '/',
                'isSecure': true,
                'isHttpOnly': true,
                'isSessionCookie': true,
              },
              {
                'name': 'shared',
                'value': 'subdomain',
                'domain': '.example.com',
                'path': '/',
                'isSecure': true,
                'isHttpOnly': false,
                'isSessionCookie': true,
              },
            ]),
          );
      final cookies = PlatformCookieManager(
        const PlatformCookieManagerCreationParams(),
      );
      final scoped = await cookies.getCookies(
        url: WebUri('https://example.com/auth/login'),
      );
      expect(scoped.map((cookie) => cookie.value), [
        'auth',
        'root',
        'subdomain',
      ]);
      expect(scoped.first.isHttpOnly, isTrue);
      expect(
        (await cookies.getCookies(url: WebUri('https://child.example.com/')))
            .map((cookie) => cookie.value),
        ['subdomain'],
      );
      expect(
        await cookies.getCookies(url: WebUri('http://example.com/')),
        isEmpty,
      );
    },
  );

  test(
    'setCookie forwards values the RFC 6265 validator would reject',
    () async {
      // Value validation belongs to the native engine, as on other platforms.
      final sent = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(cookieChannel, (call) async {
            sent.add(call);
            return true;
          });
      final cookies = PlatformCookieManager(
        const PlatformCookieManagerCreationParams(),
      );
      expect(
        await cookies.setCookie(
          url: WebUri('https://example.com/'),
          name: 'token',
          value: 'a,b;c\\d ünïcode',
          isSecure: true,
          isHttpOnly: true,
          sameSite: HTTPCookieSameSitePolicy.LAX,
        ),
        isTrue,
      );
      final body =
          jsonDecode(sent.single.arguments as String) as Map<String, dynamic>;
      expect(body['cookie'], contains('token=a,b;c\\d ünïcode'));
      expect(body['cookie'], contains('Path=/'));
      expect(body['cookie'], contains('Secure'));
      expect(body['cookie'], contains('HttpOnly'));
      expect(body['cookie'], contains('SameSite=Lax'));
    },
  );

  test('setCookie serialises expiresDate as an RFC 1123 date', () async {
    final sent = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(cookieChannel, (call) async {
          sent.add(call);
          return true;
        });
    final cookies = PlatformCookieManager(
      const PlatformCookieManagerCreationParams(),
    );
    await cookies.setCookie(
      url: WebUri('https://example.com/'),
      name: 'n',
      value: 'v',
      expiresDate: DateTime.utc(2027, 1, 2, 3, 4, 5).millisecondsSinceEpoch,
    );
    final body =
        jsonDecode(sent.single.arguments as String) as Map<String, dynamic>;
    expect(body['cookie'], contains('Expires=Sat, 02 Jan 2027 03:04:05 GMT'));
  });

  test(
    'deleteCookie matches the stored row instead of inventing attributes',
    () async {
      // Preserve the stored flags even when they differ from the URL scheme.
      // ArkWeb decides whether this expiration is accepted over HTTP.
      final sent = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(cookieChannel, (call) async {
            sent.add(call);
            if (call.method == 'getAllCookies') {
              return jsonEncode([
                {
                  'name': 'sid',
                  'value': 'secret',
                  'domain': 'example.com',
                  'path': '/',
                  'isSecure': true,
                  'isHttpOnly': false,
                  'isSessionCookie': true,
                  'samesitePolicy': 2,
                },
              ]);
            }
            return true;
          });
      final cookies = PlatformCookieManager(
        const PlatformCookieManagerCreationParams(),
      );
      await cookies.deleteCookie(
        url: WebUri('http://example.com/'),
        name: 'sid',
        path: '/',
      );
      final setCall = sent.firstWhere((call) => call.method == 'setCookie');
      final body =
          jsonDecode(setCall.arguments as String) as Map<String, dynamic>;
      final cookie = body['cookie'] as String;
      expect(cookie, contains('Max-Age=0'));
      expect(cookie, contains('Secure'), reason: 'the stored row is Secure');
      expect(
        cookie,
        isNot(contains('HttpOnly')),
        reason: 'the stored row is not HttpOnly',
      );
      expect(cookie, contains('SameSite=Strict'));
    },
  );
}
