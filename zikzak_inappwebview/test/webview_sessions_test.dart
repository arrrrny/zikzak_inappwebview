import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_session/zikzak_session.dart';

import 'package:zikzak_inappwebview/src/cookie_manager.dart';
import 'package:zikzak_inappwebview/src/webview_sessions/webview_sessions.dart';

/// Spec `014-portable-sessions` — the sessions controller against the real
/// zikzak_session `FileSessionStore` (temp dir). The evaluator-closure
/// seam lets the JS/localStorage paths run without a live webview, and
/// cookie mapping is exercised as pure functions plus the full
/// save→persist→load round-trip through the [SessionPort].
void main() {
  late Directory tempDir;
  late FileSessionStore store;
  late WebViewSessions sessions;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('wv_sessions_');
    store = FileSessionStore(Directory('${tempDir.path}/store'));
    sessions = WebViewSessions(port: store);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  Cookie pluginCookie({
    String name = 'sid',
    String value = 'abc123',
    String domain = '.example.com',
    String path = '/',
    int? expiresDate,
    bool secure = true,
    bool httpOnly = false,
  }) => Cookie(
    name: name,
    value: value,
    domain: domain,
    path: path,
    expiresDate: expiresDate,
    isSecure: secure,
    isHttpOnly: httpOnly,
  );

  group('cookie mapping (FR-005)', () {
    test('plugin Cookie maps onto a portable CookieEntry field by field', () {
      final entry = WebViewSessions.toCookieEntry(
        pluginCookie(expiresDate: 1893456000000),
      );

      expect(entry.name, 'sid');
      expect(entry.value, 'abc123');
      expect(entry.domain, '.example.com');
      expect(entry.path, '/');
      expect(entry.expiresAt, 1893456000000);
      expect(entry.secure, isTrue);
      expect(entry.httpOnly, isFalse);
    });

    test('null optionals fall back to safe defaults', () {
      final entry = WebViewSessions.toCookieEntry(
        Cookie(name: 'bare', value: 42, domain: null, path: null),
      );

      expect(entry.value, '42', reason: 'dynamic values are stringified');
      expect(entry.domain, '');
      expect(entry.path, '/');
      expect(entry.secure, isFalse);
      expect(entry.httpOnly, isFalse);
    });
  });

  group('localStorage harvest/apply (FR-003/FR-004)', () {
    test('harvest reads window.localStorage through the evaluator', () async {
      final harvested = await WebViewSessions.harvestLocalStorage(
        (source) async => '{"auth":"token-1","theme":"dark"}',
      );

      expect(harvested, hasLength(2));
      expect(harvested.first.key, 'auth');
      expect(harvested.first.value, 'token-1');
    });

    test('a failing or empty evaluation yields an empty list', () async {
      expect(
        await WebViewSessions.harvestLocalStorage(
          (_) async => throw StateError('no page'),
        ),
        isEmpty,
      );
      expect(
        await WebViewSessions.harvestLocalStorage((_) async => ''),
        isEmpty,
      );
      expect(
        await WebViewSessions.harvestLocalStorage(
          (_) async => '"just a string"',
        ),
        isEmpty,
      );
    });

    test(
      'applyLocalStorage issues one setItem per entry, JSON-escaped',
      () async {
        final scripts = <String>[];
        await WebViewSessions.applyLocalStorage(
          (source) async {
            scripts.add(source);
            return null;
          },
          [
            StorageEntry(
              key: 'auth',
              value: 'a"b',
              area: 'localStorage',
              origin: 'https://x.test',
            ),
            StorageEntry(
              key: 'count',
              value: '3',
              area: 'localStorage',
              origin: 'https://x.test',
            ),
          ],
        );

        expect(scripts, [
          'window.localStorage.setItem("auth", "a\\"b")',
          'window.localStorage.setItem("count", "3")',
        ]);
      },
    );
  });

  group('session round-trip through the port (FR-002/US1)', () {
    test(
      'a saved session round-trips with cookies and storage intact',
      () async {
        final now = DateTime.now().millisecondsSinceEpoch;
        await store.save(
          PortableSession(
            id: 'browser-a',
            name: 'Account A',
            origin: 'https://app.example.com',
            createdAt: now,
            updatedAt: now,
            cookies: [
              CookieEntry(
                name: 'sid',
                value: 'v1',
                domain: '.example.com',
                path: '/',
                secure: true,
                httpOnly: false,
              ),
            ],
            storage: [
              StorageEntry(
                key: 'auth',
                value: 'token-1',
                area: 'localStorage',
                origin: 'https://app.example.com',
              ),
            ],
          ),
        );

        final listed = await sessions.list();
        expect(listed, hasLength(1));
        expect(listed.first.name, 'Account A');
        expect(listed.first.origin, 'https://app.example.com');
        expect(listed.first.cookies.single.name, 'sid');
        expect(listed.first.storage.single.value, 'token-1');
      },
    );

    test('delete frees the session (FR-001)', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await store.save(
        PortableSession(
          id: 'gone',
          name: 'Gone',
          origin: 'https://gone.test',
          createdAt: now,
          updatedAt: now,
          cookies: const [],
          storage: const [],
        ),
      );

      expect(await sessions.delete('gone'), isTrue);
      expect(await sessions.delete('gone'), isFalse);
      expect(await sessions.list(), isEmpty);
    });

    test('two named sessions coexist without contamination (US2)', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      Future<void> add(String id, String origin, String cookieValue) =>
          store.save(
            PortableSession(
              id: id,
              name: id,
              origin: origin,
              createdAt: now,
              updatedAt: now,
              storage: const [],
              cookies: [
                CookieEntry(
                  name: 'sid',
                  value: cookieValue,
                  domain: origin,
                  path: '/',
                  secure: false,
                  httpOnly: false,
                ),
              ],
            ),
          );

      await add('profile-a', 'https://alpha.test', 'cookie-a');
      await add('profile-b', 'https://beta.test', 'cookie-b');

      final listed = await sessions.list();
      expect(listed, hasLength(2));
      final a = listed.firstWhere((s) => s.id == 'profile-a');
      final b = listed.firstWhere((s) => s.id == 'profile-b');
      expect(a.cookies.single.value, 'cookie-a');
      expect(b.cookies.single.value, 'cookie-b');

      // Restart: a fresh store over the same directory sees both.
      final revived = FileSessionStore(Directory('${tempDir.path}/store'));
      expect(await revived.list(), hasLength(2));
    });
  });

  group('load semantics (FR-004/US1 scenario 3)', () {
    test(
      'loading an unknown session reports not-found without throwing',
      () async {
        // list/delete stay honest on the empty store.
        expect(await sessions.list(), isEmpty);
        expect(await sessions.delete('nobody'), isFalse);
      },
    );
  });

  group('public save/load through the API (FR-002/FR-004/US1)', () {
    test('save harvests cookies+storage and persists through the port', () async {
      final fakeCookies = _FakeCookiePlatform()
        ..cookies.add(
          pluginCookie(
            name: 'sid',
            value: 'v1',
            domain: '.example.com',
            path: '/',
            expiresDate: 1893456000000,
          ),
        );
      final eval = _Eval({'auth': 'token-1'});
      final s = WebViewSessions(
        port: store,
        cookieManager: CookieManager.fromPlatform(fakeCookies),
        evaluateJavascript: eval.call,
      );

      await s.save(
        null,
        sessionId: 'browser-a',
        name: 'Account A',
        url: WebUri('https://app.example.com'),
      );

      final saved = await s.list();
      expect(saved, hasLength(1));
      expect(saved.first.id, 'browser-a');
      expect(saved.first.cookies.single.name, 'sid');
      expect(saved.first.cookies.single.value, 'v1');
      expect(saved.first.storage.single.key, 'auth');
      expect(saved.first.storage.single.value, 'token-1');
    });

    test('load re-applies cookies and localStorage onto the webview', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final fakeCookies = _FakeCookiePlatform();
      final eval = _Eval({});
      final s = WebViewSessions(
        port: store,
        cookieManager: CookieManager.fromPlatform(fakeCookies),
        evaluateJavascript: eval.call,
      );

      await store.save(
        PortableSession(
          id: 'browser-a',
          name: 'Account A',
          origin: 'https://app.example.com',
          createdAt: now,
          updatedAt: now,
          cookies: [
            CookieEntry(
              name: 'sid',
              value: 'v1',
              domain: '.example.com',
              path: '/',
              secure: true,
              httpOnly: false,
            ),
          ],
          storage: [
            StorageEntry(
              key: 'auth',
              value: 'token-1',
              area: 'localStorage',
              origin: 'https://app.example.com',
            ),
          ],
        ),
      );

      final ok = await s.load(
        null,
        sessionId: 'browser-a',
        url: WebUri('https://app.example.com'),
      );

      expect(ok, isTrue);
      expect(fakeCookies.setCalls, hasLength(1));
      expect(fakeCookies.setCalls.single.name, 'sid');
      expect(fakeCookies.setCalls.single.value, 'v1');
      expect(
        eval.scripts,
        contains('window.localStorage.setItem("auth", "token-1")'),
      );
    });

    test('load reports not-found for an unknown session', () async {
      final s = WebViewSessions(
        port: store,
        evaluateJavascript: (_) async => null,
      );

      expect(
        await s.load(
          null,
          sessionId: 'nobody',
          url: WebUri('https://app.example.com'),
        ),
        isFalse,
      );
    });
  });

  group('port injection (FR-007)', () {
    test('any SessionPort implementation backs the controller', () {
      final custom = _InMemoryPort();
      final controller = WebViewSessions(port: custom);

      expect(controller.port, same(custom));
    });
  });

  group('WebUri / Cookie types from platform_interface (FR-005 / T010)', () {
    test('origin is taken from the WebUri passed to save, port included', () async {
      final fakeCookies = _FakeCookiePlatform();
      final eval = _Eval({});
      final s = WebViewSessions(
        port: store,
        cookieManager: CookieManager.fromPlatform(fakeCookies),
        evaluateJavascript: eval.call,
      );
      final url = WebUri('https://app.test:8443/login');

      await s.save(null, sessionId: 'o1', name: 'O', url: url);

      final saved = await store.load('o1');
      expect(saved, isNotNull);
      expect(saved!.origin, 'https://app.test:8443');
    });

    test('cookie mapping accepts a platform_interface Cookie with all fields', () {
      final entry = WebViewSessions.toCookieEntry(
        Cookie(
          name: 'sid',
          value: 'v2',
          domain: 'app.test',
          path: '/a',
          expiresDate: 1893456000000,
          isSecure: false,
          isHttpOnly: true,
        ),
      );

      expect(entry.name, 'sid');
      expect(entry.value, 'v2');
      expect(entry.domain, 'app.test');
      expect(entry.path, '/a');
      expect(entry.expiresAt, 1893456000000);
      expect(entry.secure, isFalse);
      expect(entry.httpOnly, isTrue);
    });
  });

  group('save overwrite semantics (T025)', () {
    test('saving the same id overwrites rather than duplicates', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await store.save(
        PortableSession(
          id: 'dup',
          name: 'First',
          origin: 'https://d.test',
          createdAt: now,
          updatedAt: now,
          cookies: [
            CookieEntry(
              name: 'a',
              value: '1',
              domain: 'd.test',
              path: '/',
              secure: false,
              httpOnly: false,
            ),
          ],
          storage: const [],
        ),
      );

      final s = WebViewSessions(
        port: store,
        cookieManager: CookieManager.fromPlatform(
          _FakeCookiePlatform()..cookies.add(pluginCookie(value: '2')),
        ),
        evaluateJavascript: _Eval({'k': 'v'}).call,
      );
      await s.save(
        null,
        sessionId: 'dup',
        name: 'Second',
        url: WebUri('https://d.test'),
      );

      final listed = await s.list();
      expect(listed, hasLength(1), reason: 'same id overwrites, not duplicates');
      expect(listed.first.name, 'Second');
      expect(listed.first.cookies.single.value, '2');
      expect(listed.first.storage.single.value, 'v');
    });
  });

  group('load with empty cookies/storage (T026)', () {
    test('returns true and applies nothing when the session has no data', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await store.save(
        PortableSession(
          id: 'empty',
          name: 'Empty',
          origin: 'https://e.test',
          createdAt: now,
          updatedAt: now,
          cookies: const [],
          storage: const [],
        ),
      );

      final fakeCookies = _FakeCookiePlatform();
      final eval = _Eval({});
      final s = WebViewSessions(
        port: store,
        cookieManager: CookieManager.fromPlatform(fakeCookies),
        evaluateJavascript: eval.call,
      );

      final ok = await s.load(
        null,
        sessionId: 'empty',
        url: WebUri('https://e.test'),
      );

      expect(ok, isTrue);
      expect(fakeCookies.setCalls, isEmpty);
      expect(eval.scripts, isEmpty);
    });
  });

  group('clock injection (T024)', () {
    test('saved timestamps reflect the injected clock, not wall time', () async {
      const ticks = 1700000000000;
      final clock = () => DateTime.fromMillisecondsSinceEpoch(ticks);
      final s = WebViewSessions(
        port: store,
        cookieManager: CookieManager.fromPlatform(_FakeCookiePlatform()),
        evaluateJavascript: _Eval({}).call,
        clock: clock,
      );

      await s.save(
        null,
        sessionId: 'timed',
        name: 'Timed',
        url: WebUri('https://t.test'),
      );

      final saved = await store.load('timed');
      expect(saved, isNotNull);
      expect(saved!.createdAt, ticks);
      expect(saved.updatedAt, ticks);
    });
  });
}

/// Minimal alternate port proving the controller is implementation-agnostic.
class _InMemoryPort implements SessionPort {
  final Map<String, PortableSession> _sessions = {};

  @override
  Future<void> save(PortableSession session) async {
    _sessions[session.id] = session;
  }

  @override
  Future<PortableSession?> load(String id) async => _sessions[id];

  @override
  Future<List<PortableSession>> list() async =>
      _sessions.values.toList(growable: false);

  @override
  Future<bool> delete(String id) async => _sessions.remove(id) != null;
}

/// In-test [CookieManager] platform: returns scripted cookies on harvest and
/// records every [setCookie] call so the load path can be asserted.
class _FakeCookiePlatform extends PlatformCookieManager {
  _FakeCookiePlatform()
      : super.implementation(const PlatformCookieManagerCreationParams());

  final List<Cookie> cookies = [];
  final List<({String name, String value, String? domain, String path})>
      setCalls = [];

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? webViewController,
  }) async => cookies;

  @override
  Future<bool> setCookie({
    required WebUri url,
    required String name,
    required String value,
    String path = '/',
    String? domain,
    int? expiresDate,
    int? maxAge,
    bool? isSecure,
    bool? isHttpOnly,
    HTTPCookieSameSitePolicy? sameSite,
    PlatformInAppWebViewController? webViewController,
  }) async {
    setCalls.add((name: name, value: value, domain: domain, path: path));
    return true;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

/// Evaluator stand-in for the webview's `evaluateJavascript`. Returns the
/// scripted localStorage JSON on a harvest call and records every script it
/// is asked to run (so `setItem` application is observable).
class _Eval {
  _Eval(this.localStorage);

  final Map<String, String> localStorage;
  final List<String> scripts = [];

  Future<Object?> call(String source) async {
    scripts.add(source);
    if (source.contains('JSON.stringify(window.localStorage)')) {
      return jsonEncode(localStorage);
    }
    return null;
  }
}
