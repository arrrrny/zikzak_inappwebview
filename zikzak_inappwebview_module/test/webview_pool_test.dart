import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_module/zikzak_inappwebview_module.dart';

/// Spec 007 outer acceptance behaviors for `WebViewPool`.
///
/// Every behavior is driven through the pool's real public entry points
/// (`acquire` / `release` / `disposeAll` / `liveCount` / `sessions()`), as
/// required by `specs/007-webview-pool-sessions/tdd/test-list.md`. No MCP and
/// no zuraffa types are involved (FR-010).
///
/// The pool runs against a platform-aware cap config sized down for tests:
/// `maxLiveInstances: 4`, `maxPerDomain: 2`, `idleTtlSeconds: 60`.
void main() {
  group('WebViewPool acceptance (spec 007)', () {
    late WebViewPool pool;

    setUp(() {
      pool = WebViewPool(
        config: const WebViewPoolConfig(
          maxLiveInstances: 4,
          maxPerDomain: 2,
          idleTtlSeconds: 60,
        ),
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

      // A second session without settings gets the pool default and does
      // not inherit the first session's configuration object.
      final second = await pool.acquire(
        sessionId: 'mission-2',
        domainHint: 'other.org',
      );
      expect(second.settings, isNot(same(captureFilters)));
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
    });

    test(
        'A18: an acquire with no settings override issues the pool default '
        'base configuration', () async {
      final session = await pool.acquire(
        sessionId: 'mission-1',
        domainHint: 'example.com',
      );

      expect(session.settings, isA<InAppWebViewSettings>());
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
      expect(pool.liveCount, 1);
    });

  });
}
