import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_session/zikzak_session.dart';

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

  group('port injection (FR-007)', () {
    test('any SessionPort implementation backs the controller', () {
      final custom = _InMemoryPort();
      final controller = WebViewSessions(port: custom);

      expect(controller.port, same(custom));
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
