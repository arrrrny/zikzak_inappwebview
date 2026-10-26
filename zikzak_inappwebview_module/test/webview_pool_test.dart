import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_module/zikzak_inappwebview_module.dart';

/// A plain-Dart fake [HeadlessInAppWebView] (spec 007 test harness).
///
/// The pool only ever touches `dispose()` and `webViewController` on issued
/// instances; everything else stays unimplemented and fails loudly via
/// [noSuchMethod] rather than silently passing.
class _FakeHeadlessWebView implements HeadlessInAppWebView {
  int disposeCount = 0;

  @override
  InAppWebViewController? get webViewController => null;

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    disposeCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Fake [HeadlessWebViewInstanceFactory]: records every creation call and the
/// settings it was asked to apply, and hands out fresh fakes.
class _Recorder {
  int created = 0;
  final Map<HeadlessInAppWebView, InAppWebViewSettings?> settingsByInstance =
      {};
  final List<HeadlessInAppWebView> instances = [];

  Future<HeadlessInAppWebView> factory(InAppWebViewSettings? settings) async {
    created++;
    final webview = _FakeHeadlessWebView();
    settingsByInstance[webview] = settings;
    instances.add(webview);
    return webview;
  }
}

/// Spec 007 outer acceptance behaviors for `WebViewPool`.
///
/// Every behavior is driven through the pool's real public entry points
/// (`acquire` / `release` / `disposeAll` / `liveCount` / `sessions()`), as
/// required by `specs/007-webview-pool-sessions/tdd/test-list.md`, with
/// instance creation injected as a plain Dart fake. No MCP and no zuraffa
/// types are involved (FR-010).
///
/// The pool runs against a cap config sized down for tests:
/// `maxLiveInstances: 4`, `maxPerDomain: 2`, `idleTtlSeconds: 60`.
void main() {
  group('WebViewPool acceptance (spec 007)', () {
    late WebViewPool pool;
    late _Recorder recorder;

    setUp(() {
      recorder = _Recorder();
      pool = WebViewPool(
        config: const WebViewPoolConfig(
          maxLiveInstances: 4,
          maxPerDomain: 2,
          idleTtlSeconds: 60,
        ),
        instanceFactory: recorder.factory,
      );
    });

    tearDown(() async {
      await pool.dispose();
    });

    test('A1: acquiring a session with no instance creates one, liveCount 1',
        () async {
      final session = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );

      expect(session.sessionId, 'mission-1');
      expect(recorder.created, 1);
      expect(pool.liveCount, 1);
    });

    test(
        'A2: re-acquiring the same live session returns the same instance '
        'and creates no second instance', () async {
      final first = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );
      final second = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );

      expect(second, same(first));
      expect(recorder.created, 1);
      expect(pool.liveCount, 1);
    });

    test(
        'A3: releasing a live session returns it idle and drops it from '
        'the sessions() active set', () async {
      await pool.acquire(sessionId: 'mission-1', domainHint: 'example.com');

      await pool.release('mission-1');

      // Active set is empty after release...
      expect(pool.sessions(), isEmpty);
      // ...but the idle instance is still allocated for warm reuse
      // (liveCount counts live + idle per FR-006/tasks U10), and disposeAll
      // returns it to 0.
      expect(pool.liveCount, 1);

      await pool.disposeAll();
      expect(pool.liveCount, 0);
    });

    test(
        'A4: disposeAll with several live sessions disposes every instance '
        'and liveCount returns to 0', () async {
      await pool.acquire(sessionId: 'mission-1', domainHint: 'example.com');
      await pool.acquire(sessionId: 'mission-2', domainHint: 'other.org');
      expect(pool.liveCount, 2);

      await pool.disposeAll();

      expect(pool.liveCount, 0);
      expect(pool.sessions(), isEmpty);
      // Every issued instance was really disposed, not just dropped.
      for (final webview in recorder.instances) {
        expect((webview as _FakeHeadlessWebView).disposeCount, 1);
      }
    });

    test(
        'A5: acquiring with an eTLD+1 hint reuses a warm idle instance '
        'already scoped to that eTLD+1 (affinity hit)', () async {
      final first = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'shop.example.com',
      );
      await pool.release('mission-1');

      final second = await pool.acquire(
        sessionId: 'mission-2',
        domainHint: 'app.example.com',
      );

      // Same underlying headless instance is reissued (same eTLD+1).
      expect(second.webview, same(first.webview));
      expect(recorder.created, 1);
      expect(pool.liveCount, 1);
    });

    test(
        'A7: acquiring an unknown eTLD+1 creates a new instance instead of '
        'reusing a domain-scoped idle one, and a generic idle instance is '
        'reused for a non-affine acquisition', () async {
      // Domain-scoped idle exists for example.com...
      final scoped = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );
      await pool.release('mission-1');

      // ...but other.org must NOT receive the example.com instance.
      final other = await pool.acquire(
        sessionId: 'mission-2',
        domainHint: 'other.org',
      );
      expect(other.webview, isNot(same(scoped.webview)));

      // A generic (no-hint) session is released into the generic idle pool...
      final generic = await pool.acquire(sessionId: 'mission-3');
      await pool.release('mission-3');

      // ...and any later acquisition may reuse it.
      final reused = await pool.acquire(sessionId: 'mission-4');
      expect(reused.webview, same(generic.webview));
    });

    test(
        'A8: sessions() reports each active entry\'s current eTLD+1 domain '
        'association after a generic idle instance is re-scoped', () async {
      // Acquire with no domain hint, release, then re-acquire with a hint.
      await pool.acquire(sessionId: 'mission-1');
      await pool.release('mission-1');

      await pool.acquire(sessionId: 'mission-2', domainHint: 'app.example.com');

      final snapshot = pool.sessions();
      expect(snapshot, hasLength(1));
      expect(snapshot.single.sessionId, 'mission-2');
      expect(snapshot.single.etldPlusOne, 'example.com');
      expect(snapshot.single.isActive, isTrue);
    });

    test(
        'A13: concurrent acquire calls for one session create exactly one '
        'instance', () async {
      final sessions = <PoolSession>[];
      await Future.wait([
        for (var i = 0; i < 10; i++)
          pool
              .acquire(sessionId: 'mission-1', domainHint: 'example.com')
              .then(sessions.add),
      ]);

      expect(sessions, hasLength(10));
      for (final session in sessions) {
        expect(identical(session, sessions.first), isTrue);
      }
      expect(recorder.created, 1);
      expect(pool.liveCount, 1);
    });

    test(
        'A14: concurrent acquisitions across distinct sessions leave '
        'liveCount == M with no aliased instances', () async {
      final ids = ['m1', 'm2', 'm3', 'm4', 'm5', 'm6'];
      final domains = [
        'a.org',
        'b.org',
        'c.org',
        'd.org',
        'e.org',
        'f.org',
      ];

      final sessions = await Future.wait([
        for (var i = 0; i < ids.length; i++)
          pool.acquire(sessionId: ids[i], domainHint: domains[i]),
      ]);

      expect(sessions, hasLength(6));
      expect(pool.liveCount, 6);
      final distinctInstances = sessions.map((s) => s.webview).toSet();
      expect(distinctInstances, hasLength(6));
      expect(pool.sessions(), hasLength(6));
    });

    test('A16: acquire settings are passed to the issued instance only',
        () async {
      final captureFilters = InAppWebViewSettings(javaScriptEnabled: false);

      final first = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
        settings: captureFilters,
      );

      expect(first.settings, same(captureFilters));
      // The factory received exactly the caller's settings for that instance.
      expect(recorder.settingsByInstance[first.webview],
          same(captureFilters));

      // A second session without settings does not inherit the first
      // session's configuration object.
      final second = await pool.acquire(
        sessionId: 'mission-2',
        domainHint: 'other.org',
      );
      expect(second.settings, isNot(same(captureFilters)));
      expect(recorder.settingsByInstance[second.webview], isNull);
    });

    test(
        'A17: two sessions with different settings each retain only their '
        'own configuration', () async {
      final filtersA = InAppWebViewSettings(javaScriptEnabled: false);
      final filtersB = InAppWebViewSettings(javaScriptEnabled: true);

      final a = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
        settings: filtersA,
      );
      final b = await pool.acquire(
        sessionId: 'mission-2',
        domainHint: 'other.org',
        settings: filtersB,
      );

      expect(a.settings, same(filtersA));
      expect(b.settings, same(filtersB));
      expect(a.settings, isNot(same(b.settings)));
      expect(recorder.settingsByInstance[a.webview], same(filtersA));
      expect(recorder.settingsByInstance[b.webview], same(filtersB));
    });

    test(
        'A18: an acquire with no settings override issues the pool default '
        'base configuration', () async {
      final session = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );

      expect(session.settings, isA<InAppWebViewSettings>());
      expect(recorder.settingsByInstance[session.webview], isNull);
    });

    test(
        'edge: release of an unknown / never-acquired sessionId is a safe '
        'no-op', () async {
      await pool.release('never-acquired');

      expect(pool.liveCount, 0);
      expect(pool.sessions(), isEmpty);
    });

    test(
        'edge: acquire for a previously-disposed session creates a fresh '
        'instance', () async {
      final first = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );

      await pool.disposeAll();

      final second = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );

      expect(second.webview, isNot(same(first.webview)));
      expect(recorder.created, 2);
      expect(pool.liveCount, 1);
    });

    test(
        'cap: acquiring past the max-live cap with nothing evictable throws '
        'WebViewPoolExhaustedException (SC-005: cap is never exceeded)',
        () async {
      await pool.acquire(sessionId: 'm1', domainHint: 'a.org');
      await pool.acquire(sessionId: 'm2', domainHint: 'b.org');
      await pool.acquire(sessionId: 'm3', domainHint: 'c.org');
      await pool.acquire(sessionId: 'm4', domainHint: 'd.org');
      expect(pool.liveCount, 4);

      await expectLater(
        pool.acquire(sessionId: 'm5', domainHint: 'e.org'),
        throwsA(isA<WebViewPoolExhaustedException>()),
      );

      // Cap invariant holds after the refused acquisition.
      expect(pool.liveCount, 4);
    });

    test(
        'cap: acquiring past the max-live cap evicts the oldest idle '
        'instance instead of exceeding the cap', () async {
      await pool.acquire(sessionId: 'm1', domainHint: 'a.org');
      await pool.acquire(sessionId: 'm2', domainHint: 'b.org');

      // Free one instance back to idle: the pool may evict it to make room.
      await pool.release('m1');
      expect(pool.liveCount, 2);

      await pool.acquire(sessionId: 'm3', domainHint: 'c.org');

      // liveCount never exceeded the cap.
      expect(pool.liveCount, 2);
      final active = pool.sessions().map((s) => s.sessionId).toSet();
      expect(active, containsAll(<String>['m2', 'm3']));
      expect(active, isNot(contains('m1')));
    });

    test(
        'cap: an affine acquire past the max-per-domain cap throws instead '
        'of exceeding it', () async {
      await pool.acquire(sessionId: 'm1', domainHint: 'app.example.com');
      await pool.acquire(sessionId: 'm2', domainHint: 'shop.example.com');

      await expectLater(
        pool.acquire(sessionId: 'm3', domainHint: 'www.example.com'),
        throwsA(isA<WebViewPoolExhaustedException>()),
      );

      expect(pool.liveCount, 2);
    });
  });
}
