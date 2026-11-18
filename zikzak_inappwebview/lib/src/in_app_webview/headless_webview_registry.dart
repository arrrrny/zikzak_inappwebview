import 'dart:async';

import 'package:flutter/foundation.dart';

import 'headless_in_app_webview.dart';

/// Configuration for a [HeadlessWebViewRegistry].
///
/// The defaults mirror the module-tier pool's platform-aware caps: mobile
/// engines hold a whole render process per instance, so they get a tighter
/// ceiling than desktop.
class HeadlessWebViewRegistryConfig {
  /// Maximum number of live headless WebViews (running or idle).
  ///
  /// A registration beyond this cap evicts the oldest **idle** instance; when
  /// every live instance is active the registration fails with a
  /// [HeadlessWebViewCapExceededException] instead of silently growing.
  ///
  /// There is no platform-independent default on purpose: the native managers
  /// hard-stop at `3` on iOS/Android and `5` on macOS, so a value picked here
  /// could promise room the platform then refuses. Use
  /// [HeadlessWebViewRegistryConfig.platformDefaults] for the platform-aware
  /// ceilings.
  final int maxLiveInstances;

  /// How long an idle instance may stay registered before
  /// [HeadlessWebViewRegistry.evictIdleExpired] releases it.
  ///
  /// [Duration.zero] disables idle-TTL eviction.
  final Duration idleTtl;

  /// How long [HeadlessWebViewRegistry.acquire] waits FIFO-style for a slot
  /// when every live instance is active before failing with
  /// [HeadlessWebViewCapExceededException].
  ///
  /// [Duration.zero] fails immediately, matching [track]'s loud failure.
  final Duration slotAcquireTimeout;

  const HeadlessWebViewRegistryConfig({
    required this.maxLiveInstances,
    this.idleTtl = const Duration(seconds: 300),
    this.slotAcquireTimeout = const Duration(seconds: 30),
  }) : assert(maxLiveInstances >= 1, 'a cap of zero can never be satisfied');

  /// Platform-aware defaults (iOS/Android `3`, macOS `5`, everything else `8`).
  ///
  /// Uses `defaultTargetPlatform`, not `dart:io`, so this file stays compilable
  /// for Flutter Web.
  factory HeadlessWebViewRegistryConfig.platformDefaults() {
    final platform = defaultTargetPlatform;
    if (!kIsWeb &&
        (platform == TargetPlatform.iOS ||
            platform == TargetPlatform.android)) {
      return const HeadlessWebViewRegistryConfig(
        maxLiveInstances: 3,
        idleTtl: Duration(seconds: 180),
      );
    }
    if (!kIsWeb && platform == TargetPlatform.macOS) {
      return const HeadlessWebViewRegistryConfig(
        maxLiveInstances: 5,
        idleTtl: Duration(seconds: 300),
      );
    }
    return const HeadlessWebViewRegistryConfig(
      maxLiveInstances: 8,
      idleTtl: Duration(seconds: 300),
    );
  }
}

/// Thrown when a [HeadlessWebViewRegistry] is full of active instances.
///
/// Failing loudly is deliberate: silently exceeding the platform cap is what
/// leaves a per-domain scraper with several live render processes fighting
/// over one shared navigation queue (issue #371).
class HeadlessWebViewCapExceededException implements Exception {
  /// The configured ceiling.
  final int maxLiveInstances;

  /// How many instances were live when the registration was refused.
  final int liveCount;

  const HeadlessWebViewCapExceededException({
    required this.maxLiveInstances,
    required this.liveCount,
  });

  @override
  String toString() =>
      'HeadlessWebViewCapExceededException: $liveCount live headless WebViews '
      'are all active (cap: $maxLiveInstances). Dispose one, or raise '
      'HeadlessWebViewRegistryConfig.maxLiveInstances.';
}

/// Tracks live [HeadlessInAppWebView] instances and enforces a cap.
///
/// This is the core-tier equivalent of the module package's headless pool: a
/// consumer that depends on `zikzak_inappwebview` alone gets live-instance
/// tracking, cap enforcement (evict-the-oldest-idle, fail loudly via [track],
/// or queue FIFO via [acquire]), idle-TTL eviction and a dispose-all — the
/// primitives a multi-session headless transport needs (issue #371 R4/R7).
///
/// Registration is explicit:
///
/// ```dart
/// final registry = HeadlessWebViewRegistry();
/// final webView = HeadlessInAppWebView(initialUrlRequest: ...);
/// await registry.track(webView);
/// await webView.run();
/// registry.markActive(webView);   // while a session is using it
/// ...
/// registry.markIdle(webView);     // ready for reuse or eviction
/// await registry.disposeAll();    // releases everything
/// ```
///
/// The registry never owns creation: it cannot know a caller's settings or
/// callbacks. It owns the ceiling and the teardown.
class HeadlessWebViewRegistry {
  /// A process-wide default registry.
  ///
  /// Use it for the common "one app, one ceiling" case; construct your own
  /// [HeadlessWebViewRegistry] when a test or a tenant needs an isolated one.
  static final HeadlessWebViewRegistry instance = HeadlessWebViewRegistry();

  /// The active configuration.
  final HeadlessWebViewRegistryConfig config;

  /// Injected clock, so idle-TTL behaviour is testable without wall time.
  final DateTime Function() _clock;

  /// Live instances in registration order (oldest first).
  final Map<HeadlessInAppWebView, _RegisteredHeadlessWebView> _entries = {};

  /// FIFO tail of [acquire] calls parked on a full-of-active registry, in
  /// arrival order. The head is woken when a slot frees.
  final List<Completer<void>> _slotWaiters = [];

  /// Ids of idle instances whose eviction is already in flight.
  ///
  /// Two concurrent [acquire] calls must not both pick the same
  /// `oldestIdle` and then both await its `dispose()`: the loser would burn
  /// the eviction and, after the winner freed the slot, be told
  /// [HeadlessWebViewCapExceededException] as if nothing happened (issue #371
  /// review). Reserving the id here makes the second caller re-pick.
  final Set<HeadlessInAppWebView> _evicting = {};

  HeadlessWebViewRegistry({
    HeadlessWebViewRegistryConfig? config,
    DateTime Function()? clock,
  }) : config = config ?? HeadlessWebViewRegistryConfig.platformDefaults(),
       _clock = clock ?? DateTime.now;

  /// Configured ceiling.
  int get maxLiveInstances => config.maxLiveInstances;

  /// How many instances are currently tracked.
  int get liveCount => _entries.length;

  /// Every live instance, oldest registration first.
  List<HeadlessInAppWebView> get liveInstances =>
      List.unmodifiable(_entries.keys);

  /// Whether [webView] is currently tracked.
  bool contains(HeadlessInAppWebView webView) => _entries.containsKey(webView);

  /// Registers [webView], evicting the oldest idle instance when the cap is
  /// reached.
  ///
  /// A registration that would exceed the cap with **no** idle instance to
  /// release throws [HeadlessWebViewCapExceededException] and leaves the
  /// registry untouched. Registering an already tracked instance only updates
  /// its activity state.
  Future<void> track(
    HeadlessInAppWebView webView, {
    bool active = false,
  }) async {
    final existing = _entries[webView];
    if (existing != null) {
      existing.setActive(active, _clock());
      return;
    }

    if (_entries.length >= config.maxLiveInstances) {
      final oldestIdle = _oldestIdleInstance();
      if (oldestIdle == null) {
        throw HeadlessWebViewCapExceededException(
          maxLiveInstances: config.maxLiveInstances,
          liveCount: _entries.length,
        );
      }
      final entry = _entries[oldestIdle];
      if (entry != null) {
        await _disposeEntry(oldestIdle, entry);
      }
      // The eviction is only good enough if it actually released the slot: a
      // failed native dispose keeps it registered (see [_disposeEntry]), and
      // registering on top of it would drift the Dart count below the native
      // one until `run()` dies with `headless_cap_exceeded`.
      if (_entries.length >= config.maxLiveInstances) {
        throw HeadlessWebViewCapExceededException(
          maxLiveInstances: config.maxLiveInstances,
          liveCount: _entries.length,
        );
      }
    }

    _entries[webView] = _RegisteredHeadlessWebView(
      active: active,
      lastUsedAt: _clock(),
    );
  }

  /// Registers [webView], parking FIFO-style when the registry is full of
  /// **active** instances instead of failing immediately.
  ///
  /// This is the queue counterpart of [track]. When the cap is reached with
  /// an idle instance available it behaves like [track] (evict the oldest
  /// idle and proceed). When every live instance is active it appends a
  /// waiter to the FIFO tail and suspends until [markIdle], [evict] or
  /// [disposeAll] frees a slot, waking waiters in arrival order. The wait is
  /// bounded by [HeadlessWebViewRegistryConfig.slotAcquireTimeout] — when it
  /// elapses the waiter is removed and [HeadlessWebViewCapExceededException]
  /// still fires, so a permanently jammed pool fails loudly rather than
  /// accumulating parked registrations forever.
  Future<void> acquire(
    HeadlessInAppWebView webView, {
    bool active = false,
  }) async {
    // Absolute deadline for the whole call, not a per-park budget: every
    // spurious wake-up (a `markIdle` on an already-idle instance, an `evict`
    // of a different id) used to cancel the timer and re-park with a fresh
    // full `slotAcquireTimeout`, so the documented bound was per-park rather
    // than per-call (issue #371 review).
    final deadline = Stopwatch()..start();
    while (true) {
      final existing = _entries[webView];
      if (existing != null) {
        existing.setActive(active, _clock());
        return;
      }

      if (_entries.length < config.maxLiveInstances) {
        _entries[webView] = _RegisteredHeadlessWebView(
          active: active,
          lastUsedAt: _clock(),
        );
        return;
      }

      final oldestIdle = _oldestIdleInstance();
      if (oldestIdle != null) {
        // Reserve the candidate before the await so a concurrent caller
        // cannot pick the same one and double-evict it.
        _evicting.add(oldestIdle);
        try {
          final entry = _entries[oldestIdle];
          if (entry != null) {
            await _disposeEntry(oldestIdle, entry);
          }
        } finally {
          _evicting.remove(oldestIdle);
        }
        // Only re-check when the eviction actually released the slot: a
        // failed native dispose keeps the entry (see [_disposeEntry]), and
        // retrying the same idle instance forever would spin. A call that
        // freed a slot and lost it to another acquirer re-parks below rather
        // than reporting a cap failure for work it did (issue #371 review).
        if (_entries.length < config.maxLiveInstances) {
          continue;
        }
      }

      if (config.slotAcquireTimeout <= Duration.zero ||
          deadline.elapsed >= config.slotAcquireTimeout) {
        throw HeadlessWebViewCapExceededException(
          maxLiveInstances: config.maxLiveInstances,
          liveCount: _entries.length,
        );
      }

      // Full of active instances: park at the FIFO tail until a slot frees,
      // bounded by the REMAINING budget so the wait is per-call.
      final remaining = config.slotAcquireTimeout - deadline.elapsed;
      final waiter = Completer<void>();
      _slotWaiters.add(waiter);
      final timer = Timer(remaining, () {
        _slotWaiters.remove(waiter);
        if (!waiter.isCompleted) {
          waiter.completeError(
            HeadlessWebViewCapExceededException(
              maxLiveInstances: config.maxLiveInstances,
              liveCount: _entries.length,
            ),
          );
        }
      });
      try {
        await waiter.future;
      } finally {
        timer.cancel();
        _slotWaiters.remove(waiter);
      }
      // Re-check: another acquirer may have taken the freed slot first.
    }
  }

  /// Marks [webView] as busy: eviction will skip it.
  void markActive(HeadlessInAppWebView webView) {
    _entries[webView]?.setActive(true, _clock());
  }

  /// Marks [webView] as idle and restarts its idle-TTL clock.
  ///
  /// A newly idle instance is evictable, so the FIFO head of [acquire]
  /// waiters is woken to re-check for a slot.
  void markIdle(HeadlessInAppWebView webView) {
    _entries[webView]?.setActive(false, _clock());
    _signalSlotFreed();
  }

  /// Disposes [webView] and removes it from the registry.
  Future<void> evict(HeadlessInAppWebView webView) async {
    final entry = _entries[webView];
    if (entry == null) {
      return;
    }
    await _disposeEntry(webView, entry);
    _signalSlotFreed();
  }

  /// Disposes every idle instance whose idle time exceeds
  /// [HeadlessWebViewRegistryConfig.idleTtl].
  ///
  /// Returns the disposed instances. Call this from an app-level tick (a
  /// timer, an app-lifecycle pause); the registry holds no timer of its own so
  /// it cannot keep a process or a test alive.
  Future<List<HeadlessInAppWebView>> evictIdleExpired() async {
    if (config.idleTtl <= Duration.zero) {
      return const [];
    }
    final now = _clock();
    final expired = <HeadlessInAppWebView>[];
    for (final entry in _entries.entries.toList()) {
      if (entry.value.isExpired(config.idleTtl, now)) {
        expired.add(entry.key);
      }
    }
    for (final webView in expired) {
      final entry = _entries[webView];
      if (entry != null) {
        await _disposeEntry(webView, entry);
      }
    }
    return expired;
  }

  /// Disposes every tracked instance and empties the registry.
  Future<void> disposeAll() async {
    final entries = _entries.entries.toList();
    for (final entry in entries) {
      await _disposeEntry(entry.key, entry.value);
    }
  }

  HeadlessInAppWebView? _oldestIdleInstance() {
    HeadlessInAppWebView? oldest;
    DateTime? oldestAt;
    for (final entry in _entries.entries) {
      if (entry.value.active) continue;
      if (_evicting.contains(entry.key)) continue;
      if (oldestAt == null || entry.value.lastUsedAt.isBefore(oldestAt)) {
        oldest = entry.key;
        oldestAt = entry.value.lastUsedAt;
      }
    }
    return oldest;
  }

  Future<void> _disposeEntry(
    HeadlessInAppWebView webView,
    _RegisteredHeadlessWebView entry,
  ) async {
    try {
      await webView.dispose();
      // `dispose()` is documented as non-throwing: a platform records a failed
      // teardown in [HeadlessInAppWebView.lastDisposeError] instead. Reading it
      // here is what keeps the Dart live count honest — a slot whose native
      // side did not release it stays occupied (issue #371 R4/R6).
      final error = webView.lastDisposeError;
      if (error != null) {
        throw error;
      }
      _entries.remove(webView);
      _signalSlotFreed();
    } catch (error) {
      // Keep the registration and report it. A platform that still throws must
      // not abort the teardown of the remaining registrations either.
      debugPrint(
        '[zikzak_inappwebview] headless registry eviction failed: $error',
      );
    }
  }

  /// Completes the longest-waiting [acquire] caller, if any.
  ///
  /// Woken waiters re-check the registry themselves; this only hands them
  /// the turn. Called from every path that makes a slot evictable or free.
  void _signalSlotFreed() {
    while (_slotWaiters.isNotEmpty) {
      final waiter = _slotWaiters.removeAt(0);
      if (!waiter.isCompleted) {
        waiter.complete();
        return;
      }
    }
  }
}

/// One tracked instance's activity bookkeeping.
class _RegisteredHeadlessWebView {
  bool active;
  DateTime lastUsedAt;

  _RegisteredHeadlessWebView({required this.active, required this.lastUsedAt});

  void setActive(bool value, DateTime now) {
    active = value;
    lastUsedAt = now;
  }

  bool isExpired(Duration ttl, DateTime now) =>
      !active && now.difference(lastUsedAt) >= ttl;
}
