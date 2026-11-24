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
  });
  tearDown(() {
    controller.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(viewChannel, null);
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
    },
  );

  test(
    'disposed controllers cannot send commands to a reused native view',
    () async {
      controller.dispose();
      expect(() => controller.reload(), throwsStateError);
    },
  );

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
      // `dart:io`'s `Cookie` throws FormatException for a comma, a backslash
      // and every non-ASCII character. The engine accepts them, and every
      // other platform hands them straight through, so the manager must not
      // route the value through a validating formatter.
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
      // The row is Secure but the URL is http:// — deletion needs no TLS, so
      // the delete must still address that exact jar entry. The old code
      // derived `Secure` from the scheme and forced `HttpOnly`, mutating a
      // different cookie (or missing it entirely).
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

  test(
    'dispose releases the native view before refusing further calls',
    () async {
      final sent = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(viewChannel, (call) async {
            sent.add(call);
            return null;
          });
      final disposable = OhosInAppWebViewController(
        const PlatformInAppWebViewControllerCreationParams(id: 12),
      );
      disposable.dispose();
      await Future<void>.delayed(Duration.zero);
      expect(sent.map((call) => call.method), contains('dispose'));
      expect(() => disposable.reload(), throwsStateError);
    },
  );
}
