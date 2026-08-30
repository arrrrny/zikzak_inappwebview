// Public-API regression tests for the cookie + favicon valueObjects (Zorphy
// entities). Pins the consumer-visible contract:
//   - constructor shapes (Cookie name required; Favicon url required)
//   - JSON wire format (WebUri as toString; sameSite as native strings
//     'Lax'/'Strict'/'None'; int passthroughs)
//   - null/missing-key tolerance of fromJson (required fields throw)
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('Cookie', () {
    test('name is required; defaults serialize', () {
      final c = Cookie(name: 'n');
      expect(c.name, 'n');
      expect(c.value, isNull);
      expect(c.sameSite, isNull);
      final map = c.toJson();
      expect(map['name'], 'n');
      expect(map['sameSite'], null);
      // fromJson missing required `name` throws.
      expect(() => Cookie.fromJson({}), throwsA(anything));
    });

    test('toJson emits the fork wire format', () {
      final c = Cookie(
        name: 'session',
        value: 'abc',
        expiresDate: 1700000000000,
        isSessionOnly: true,
        domain: 'flutter.dev',
        sameSite: HTTPCookieSameSitePolicy.LAX,
        isSecure: true,
        isHttpOnly: false,
        path: '/',
      );
      expect(c.toJson(), {
        'name': 'session',
        'value': 'abc',
        'expiresDate': 1700000000000,
        'isSessionOnly': true,
        'domain': 'flutter.dev',
        'sameSite': 'Lax',
        'isSecure': true,
        'isHttpOnly': false,
        'path': '/',
      });
    });

    test('fromJson is null/missing-key tolerant (except name) + round-trip', () {
      final c = Cookie.fromJson({'name': 'x'});
      expect(c.value, isNull);
      expect(c.expiresDate, isNull);
      expect(c.isSessionOnly, isNull);

      final full = Cookie(
        name: 'y',
        value: 'v',
        sameSite: HTTPCookieSameSitePolicy.STRICT,
        isSessionOnly: true,
      );
      final back = Cookie.fromJson(full.toJson());
      expect(back.name, 'y');
      expect(back.value, 'v');
      expect(back.sameSite, HTTPCookieSameSitePolicy.STRICT);
      expect(back.isSessionOnly, true);
    });

    test('copyWith is available (zorphy addition)', () {
      final c = Cookie(name: 'n', value: '1');
      expect(c.copyWith(value: '2').value, '2');
      expect(c.copyWith().value, '1');
    });
  });

  group('HTTPCookieSameSitePolicy wire', () {
    test('native strings match the old wire', () {
      expect(httpCookieSameSitePolicyToWire(HTTPCookieSameSitePolicy.LAX), 'Lax');
      expect(
        httpCookieSameSitePolicyToWire(HTTPCookieSameSitePolicy.STRICT),
        'Strict',
      );
      expect(httpCookieSameSitePolicyToWire(HTTPCookieSameSitePolicy.NONE), 'None');
      expect(httpCookieSameSitePolicyFromWire('Lax'), HTTPCookieSameSitePolicy.LAX);
      expect(httpCookieSameSitePolicyFromWire('bogus'), isNull);
      expect(httpCookieSameSitePolicyFromWire(3), isNull);
    });
  });

  group('Favicon', () {
    test('url is required; round-trips as WebUri string', () {
      expect(() => Favicon.fromJson({}), throwsA(anything));
      final f = Favicon(
        url: WebUri('https://flutter.dev/favicon.png'),
        rel: 'icon',
        width: 32,
        height: 32,
      );
      expect(f.toJson(), {
        'url': 'https://flutter.dev/favicon.png',
        'rel': 'icon',
        'width': 32,
        'height': 32,
      });
      final back = Favicon.fromJson(f.toJson());
      expect(back.url.toString(), 'https://flutter.dev/favicon.png');
      expect(back.rel, 'icon');
      expect(back.width, 32);
      expect(back.height, 32);
    });

    test('fromJson tolerates null optional fields + copyWith', () {
      final f = Favicon.fromJson({'url': 'https://x.dev/i.png'});
      expect(f.rel, isNull);
      expect(f.width, isNull);
      expect(f.copyWith(rel: 'apple-touch-icon').rel, 'apple-touch-icon');
    });
  });
}
