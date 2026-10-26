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
/// The pool runs against a cap config sized for tests:
/// `maxLiveInstances: 8` (raised so A14's six concurrent sessions fit under
/// the cap), `maxPerDomain: 2`, `idleTtlSeconds: 60`. Each cap test below
/// builds its own smaller pool instead of lowering this one.
void main() {
  group('WebViewPool acceptance (spec 007)', () {
    late WebViewPool pool;
    late _Recorder recorder;

    setUp(() {
      recorder = _Recorder();
      pool = WebViewPool(
        config: const WebViewPoolConfig(
          maxLiveInstances: 8,
          maxPerDomain: 2,
          idleTtlSeconds: 60,
        ),
        instanceFactory: recorder.factory,
      );
    });

    tearDown(() async {
      await pool.dispose();
    });

    /// Builds a pool with its own smaller caps and fake recorder, so each cap
    /// test states its boundary instead of depending on the group config.
    (WebViewPool, _Recorder) buildCapPool({
      int maxLiveInstances = 2,
      int maxPerDomain = 4,
    }) {
      final capRecorder = _Recorder();
      final capPool = WebViewPool(
        config: WebViewPoolConfig(
          maxLiveInstances: maxLiveInstances,
          maxPerDomain: maxPerDomain,
          idleTtlSeconds: 60,
        ),
        instanceFactory: capRecorder.factory,
      );
      addTearDown(capPool.dispose);
      return (capPool, capRecorder);
    }

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
        'A5b: releasing and re-acquiring the same sessionId for the same '
        'eTLD+1 reuses the warm instance, which stays active', () async {
      final first = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'shop.example.com',
      );
      await pool.release('mission-1');

      final second = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'shop.example.com',
      );

      expect(second, same(first));
      expect(second.isActive, isTrue);
      expect(recorder.created, 1);
      expect(pool.liveCount, 1);

      // A further acquire must take that same live session, not build a
      // duplicate behind it (the stale releasedAt did exactly that and left
      // the first instance tracked by nobody).
      final third = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'shop.example.com',
      );
      expect(third, same(first));
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
        expect(session, same(sessions.first));
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
      expect(recorder.settingsByInstance[first.webview], same(captureFilters));

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
        'A16b: a warm reuse carries the new acquisition\'s settings into the '
        'handle while the native instance keeps its initial settings',
        () async {
      final filtersA = InAppWebViewSettings(javaScriptEnabled: false);
      final filtersB = InAppWebViewSettings(javaScriptEnabled: true);

      final first = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'shop.example.com',
        settings: filtersA,
      );
      await pool.release('mission-1');

      final second = await pool.acquire(
        sessionId: 'mission-2',
        domainHint: 'app.example.com',
        settings: filtersB,
      );

      // Same warm webview, but the handle reports whatever this caller asked
      // for (FR-008: no configuration bleed between callers).
      expect(second.webview, same(first.webview));
      expect(second.settings, same(filtersB));
      // initialSettings is not retroactive: the factory only ever saw the
      // first acquisition's object.
      expect(recorder.settingsByInstance[second.webview], same(filtersA));
      expect(recorder.created, 1);
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
      // The pool's base configuration, not an empty/unknown object.
      expect(session.settings.javaScriptEnabled, isTrue);
      // The factory was not handed a caller object: the pool base config
      // applies.
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
      final (capPool, capRecorder) = buildCapPool();

      await capPool.acquire(sessionId: 'm1', domainHint: 'a.org');
      await capPool.acquire(sessionId: 'm2', domainHint: 'b.org');
      expect(capPool.liveCount, 2);

      await expectLater(
        capPool.acquire(sessionId: 'm3', domainHint: 'c.org'),
        throwsA(isA<WebViewPoolExhaustedException>()),
      );

      // Cap invariant holds after the refused acquisition.
      expect(capPool.liveCount, 2);
      expect(capRecorder.created, 2);
    });

    test(
        'cap: acquiring past the max-live cap evicts the oldest idle '
        'instance instead of exceeding the cap', () async {
      final (capPool, capRecorder) = buildCapPool();

      await capPool.acquire(sessionId: 'm1', domainHint: 'a.org');
      await capPool.acquire(sessionId: 'm2', domainHint: 'b.org');

      // Free one instance back to idle: the pool may evict it to make room.
      await capPool.release('m1');
      expect(capPool.liveCount, 2);

      await capPool.acquire(sessionId: 'm3', domainHint: 'c.org');

      // liveCount never exceeded the cap; the idle instance was disposed.
      expect(capPool.liveCount, 2);
      expect(capRecorder.created, 3);
      final active = capPool.sessions().map((s) => s.sessionId).toSet();
      expect(active, containsAll(<String>['m2', 'm3']));
      expect(active, isNot(contains('m1')));
      expect(
        (capRecorder.instances.first as _FakeHeadlessWebView).disposeCount,
        1,
      );
    });

    test(
        'cap: evicting for room disposes the OLDEST idle instance and leaves '
        'the younger idle one warm (US3)', () async {
      final (capPool, capRecorder) = buildCapPool();

      await capPool.acquire(sessionId: 'm1', domainHint: 'a.org');
      await capPool.release('m1');
      // Live 2: a.org idle, b.org active.
      await capPool.acquire(sessionId: 'm2', domainHint: 'b.org');
      await capPool.release('m2');
      // Two idle candidates now, a.org released before b.org.
      expect(capPool.liveCount, 2);

      await capPool.acquire(sessionId: 'm3', domainHint: 'c.org');

      // The first-released (a.org) instance pays; b.org's stays warm.
      expect(
        (capRecorder.instances[0] as _FakeHeadlessWebView).disposeCount,
        1,
      );
      expect(
        (capRecorder.instances[1] as _FakeHeadlessWebView).disposeCount,
        0,
      );
      expect(capPool.liveCount, 2);
    });

    test(
        'cap: an affine acquire past the max-per-domain cap throws instead '
        'of exceeding it', () async {
      final (capPool, capRecorder) =
          buildCapPool(maxLiveInstances: 4, maxPerDomain: 2);

      await capPool.acquire(sessionId: 'm1', domainHint: 'app.example.com');
      await capPool.acquire(sessionId: 'm2', domainHint: 'shop.example.com');
      expect(capPool.liveCount, 2);

      await expectLater(
        capPool.acquire(sessionId: 'm3', domainHint: 'www.example.com'),
        throwsA(isA<WebViewPoolExhaustedException>()),
      );

      expect(capPool.liveCount, 2);
      expect(capRecorder.created, 2);
    });

    test(
        'cap: a refused per-domain acquire is side-effect free — no idle '
        'instance is disposed and liveCount is unchanged', () async {
      final (capPool, capRecorder) =
          buildCapPool(maxLiveInstances: 2, maxPerDomain: 1);

      await capPool.acquire(sessionId: 'm1', domainHint: 'a.org');
      await capPool.acquire(sessionId: 'm2', domainHint: 'b.org');
      // b.org goes idle while the live cap is full.
      await capPool.release('m2');
      expect(capPool.liveCount, 2);

      // Same eTLD+1 as m1: refused, and the request needs no room, so the
      // warm b.org instance must survive it.
      await expectLater(
        capPool.acquire(sessionId: 'm3', domainHint: 'www.a.org'),
        throwsA(isA<WebViewPoolExhaustedException>()),
      );

      expect(capPool.liveCount, 2);
      expect(capRecorder.created, 2);
      for (final instance in capRecorder.instances) {
        expect((instance as _FakeHeadlessWebView).disposeCount, 0);
      }
    });
  });
}
