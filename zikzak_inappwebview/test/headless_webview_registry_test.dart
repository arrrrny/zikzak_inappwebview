// Issue #371 R4/R7 — the core live headless WebView registry.
//
// The registry is the core-tier equivalent of the module package's pool: a
// consumer that depends on `zikzak_inappwebview` alone gets cap enforcement
// (evict the oldest idle instance, or fail loudly), idle-TTL eviction and a
// dispose-all. These tests are behavioural: they drive the real registry
// against real [HeadlessInAppWebView] wrappers over a fake platform, and assert
// on the observable platform calls.
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// A headless platform fake that records the id and dispose count.
class _FakeHeadlessPlatform extends PlatformHeadlessInAppWebView {
  _FakeHeadlessPlatform(this.name)
    : super.implementation(
        PlatformHeadlessInAppWebViewCreationParams(
          controllerFromPlatform: (_) => throw UnimplementedError(),
        ),
      );

  final String name;
  bool ran = false;
  int disposeCount = 0;

  /// When true, [dispose] reports a failure the way the real platform
  /// implementations do: through [lastDisposeError], not by throwing.
  bool failDispose = false;
  Object? _lastDisposeError;

  @override
  Object? get lastDisposeError => _lastDisposeError;

  @override
  Future<void> run() async {
    ran = true;
  }

  @override
  bool isRunning() => ran;

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    disposeCount++;
    ran = false;
    _lastDisposeError = failDispose ? Exception('native dispose failed') : null;
  }
}

HeadlessInAppWebView _webView(String name) {
  final platform = _FakeHeadlessPlatform(name);
  return HeadlessInAppWebView.fromPlatform(platform: platform);
}

int _disposeCount(HeadlessInAppWebView webView) =>
    (webView.platform as _FakeHeadlessPlatform).disposeCount;

void main() {
  group('HeadlessWebViewRegistry cap (issue #371 R4)', () {
    test('platform defaults cap iOS/Android tighter than desktop', () {
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      // Pin each platform explicitly: `inInclusiveRange(3, 8)` used to accept
      // the desktop value on iOS/Android, which is exactly what this test
      // claims to prevent.
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(
        HeadlessWebViewRegistryConfig.platformDefaults().maxLiveInstances,
        3,
      );

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(
        HeadlessWebViewRegistryConfig.platformDefaults().maxLiveInstances,
        3,
      );

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(
        HeadlessWebViewRegistryConfig.platformDefaults().maxLiveInstances,
        5,
      );

      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      expect(
        HeadlessWebViewRegistryConfig.platformDefaults().maxLiveInstances,
        8,
      );
    });

    test('the config rejects a cap of zero at construction', () {
      expect(
        () => HeadlessWebViewRegistryConfig(maxLiveInstances: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
      'tracking more than the cap evicts the oldest idle instance',
      () async {
        final registry = HeadlessWebViewRegistry(
          config: const HeadlessWebViewRegistryConfig(maxLiveInstances: 2),
        );
        final first = _webView('first');
        final second = _webView('second');

        await registry.track(first);
        await registry.track(second);
        expect(registry.liveCount, 2);

        final third = _webView('third');
        await registry.track(third);

        expect(
          registry.liveCount,
          2,
          reason: 'the live count never exceeds cap',
        );
        expect(registry.contains(first), isFalse, reason: 'oldest evicted');
        expect(
          _disposeCount(first),
          1,
          reason: 'eviction disposes the WebView',
        );
        expect(registry.contains(second), isTrue);
        expect(registry.contains(third), isTrue);
      },
    );

    test('a full registry of active instances fails loudly', () async {
      final registry = HeadlessWebViewRegistry(
        config: const HeadlessWebViewRegistryConfig(maxLiveInstances: 1),
      );
      final active = _webView('active');
      await registry.track(active, active: true);

      final extra = _webView('extra');

      await expectLater(
        registry.track(extra),
        throwsA(isA<HeadlessWebViewCapExceededException>()),
      );
      expect(registry.liveCount, 1);
      expect(registry.contains(extra), isFalse);
      expect(
        _disposeCount(active),
        0,
        reason: 'an active instance is never evicted',
      );
    });

    test('a failed eviction keeps the slot and refuses the registration',
        () async {
      final registry = HeadlessWebViewRegistry(
        config: const HeadlessWebViewRegistryConfig(maxLiveInstances: 1),
      );
      final stuck = _webView('stuck');
      (stuck.platform as _FakeHeadlessPlatform).failDispose = true;
      await registry.track(stuck);

      final extra = _webView('extra');

      await expectLater(
        registry.track(extra),
        throwsA(isA<HeadlessWebViewCapExceededException>()),
        reason: 'a slot the native side never released is still occupied',
      );
      expect(registry.contains(stuck), isTrue);
      expect(registry.contains(extra), isFalse);
      expect(registry.liveCount, 1);
      expect(_disposeCount(stuck), 1);
    });

    test('markIdle makes an active instance evictable', () async {
      final registry = HeadlessWebViewRegistry(
        config: const HeadlessWebViewRegistryConfig(maxLiveInstances: 1),
      );
      final active = _webView('active');
      await registry.track(active, active: true);
      registry.markIdle(active);

      final next = _webView('next');
      await registry.track(next);

      expect(_disposeCount(active), 1);
      expect(registry.contains(next), isTrue);
    });

    test(
      'tracking the same instance twice does not grow the registry',
      () async {
        final registry = HeadlessWebViewRegistry(
          config: const HeadlessWebViewRegistryConfig(maxLiveInstances: 2),
        );
        final webView = _webView('one');

        await registry.track(webView);
        await registry.track(webView);

        expect(registry.liveCount, 1);
      },
    );
  });

  group('HeadlessWebViewRegistry idle TTL (issue #371 R4)', () {
    test('only instances idle past the TTL are evicted', () async {
      var now = DateTime.utc(2026, 1, 1, 12);
      final registry = HeadlessWebViewRegistry(
        config: const HeadlessWebViewRegistryConfig(
          maxLiveInstances: 5,
          idleTtl: Duration(minutes: 1),
        ),
        clock: () => now,
      );
      final stale = _webView('stale');
      final fresh = _webView('fresh');

      await registry.track(stale);
      now = now.add(const Duration(seconds: 30));
      await registry.track(fresh);

      now = now.add(const Duration(seconds: 45));
      final evicted = await registry.evictIdleExpired();

      expect(evicted, hasLength(1));
      expect(_disposeCount(stale), 1);
      expect(_disposeCount(fresh), 0, reason: 'still inside its idle TTL');
      expect(registry.liveCount, 1);
    });

    test('a zero TTL disables idle eviction', () async {
      var now = DateTime.utc(2026, 1, 1, 12);
      final registry = HeadlessWebViewRegistry(
        config: const HeadlessWebViewRegistryConfig(
          maxLiveInstances: 2,
          idleTtl: Duration.zero,
        ),
        clock: () => now,
      );
      final webView = _webView('pinned');
      await registry.track(webView);

      now = now.add(const Duration(days: 1));
      final evicted = await registry.evictIdleExpired();

      expect(evicted, isEmpty);
      expect(registry.liveCount, 1);
    });
  });

  group('HeadlessWebViewRegistry teardown (issue #371 R4/R7)', () {
    test(
      'disposeAll releases every live instance and empties the registry',
      () async {
        final registry = HeadlessWebViewRegistry(
          config: const HeadlessWebViewRegistryConfig(maxLiveInstances: 4),
        );
        final first = _webView('first');
        final second = _webView('second');
        await registry.track(first);
        await registry.track(second);

        await registry.disposeAll();

        expect(registry.liveCount, 0);
        expect(_disposeCount(first), 1);
        expect(_disposeCount(second), 1);
      },
    );

    test('evict releases one instance on demand', () async {
      final registry = HeadlessWebViewRegistry(
        config: const HeadlessWebViewRegistryConfig(maxLiveInstances: 4),
      );
      final webView = _webView('one');
      await registry.track(webView);

      await registry.evict(webView);

      expect(registry.contains(webView), isFalse);
      expect(_disposeCount(webView), 1);
    });
  });
}
