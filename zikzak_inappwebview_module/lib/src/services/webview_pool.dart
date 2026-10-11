import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import '../models/pool_session.dart';
import '../ports/webview_session_factory.dart';

/// Pool configuration with platform-aware defaults.
///
/// Spec: 007 (FR-003, FR-008)
class WebViewPoolConfig {
  /// Maximum number of live instances (active + idle).
  final int maxLiveInstances;

  /// Maximum number of idle instances per eTLD+1 domain.
  final int maxPerDomain;

  /// Idle TTL before eviction (seconds).
  final int idleTtlSeconds;

  const WebViewPoolConfig({
    this.maxLiveInstances = 5,
    this.maxPerDomain = 2,
    this.idleTtlSeconds = 300,
  });

  /// Returns platform-aware defaults.
  ///
  /// iOS/Android get lower caps due to memory constraints;
  /// desktop/Web get higher caps.
  factory WebViewPoolConfig.platformDefaults() {
    if (Platform.isIOS || Platform.isAndroid) {
      return const WebViewPoolConfig(
        maxLiveInstances: 3,
        maxPerDomain: 1,
        idleTtlSeconds: 180,
      );
    }
    if (Platform.isMacOS) {
      return const WebViewPoolConfig(
        maxLiveInstances: 5,
        maxPerDomain: 2,
        idleTtlSeconds: 300,
      );
    }
    // Web, Linux, Windows
    return const WebViewPoolConfig(
      maxLiveInstances: 8,
      maxPerDomain: 3,
      idleTtlSeconds: 300,
    );
  }
}

/// A pooled webview manager that acquires/releases
/// [HeadlessInAppWebView] instances keyed by session handle.
///
/// Features:
/// - One instance per active [sessionId] (session continuity)
/// - Domain affinity (eTLD+1) for warm state reuse
/// - Platform-aware caps and idle TTL eviction
/// - Memory-pressure / lifecycle hook for idle disposal
/// - Thread-safe concurrent acquisition
/// - Per-acquisition [InAppWebViewSettings] composition
///
/// Spec: 007 (all FRs)
class WebViewPool implements WebViewSessionFactory {
  final WebViewPoolConfig config;

  // Active sessions: sessionId -> PoolSession
  final Map<String, PoolSession> _active = {};

  // Idle sessions: etldPlusOne -> list of PoolSession (most recently used first)
  final Map<String, List<PoolSession>> _idle = {};

  // Generic idle sessions (no domain affinity)
  final List<PoolSession> _genericIdle = [];

  // Serializes critical sections (acquire/release/disposeAll) so concurrent
  // callers cannot observe an inconsistent pool state or exceed
  // maxLiveInstances. Each caller waits on the previous one's completion.
  Future<void> _lock = Future.value();

  // TTL eviction timer
  Timer? _evictionTimer;

  // Lifecycle listener for memory-pressure disposal
  AppLifecycleListener? _lifecycleListener;

  WebViewPool({WebViewPoolConfig? config})
      : config = config ?? WebViewPoolConfig.platformDefaults() {
    _startEvictionTimer();
    _startLifecycleListener();
  }

  @override
  Future<PoolSession> acquire({
    required String sessionId,
    String? domainHint,
    InAppWebViewSettings? settings,
  }) async {
    return _synchronized(() async {
      // 1. Check if session is already active
      final existing = _active[sessionId];
      if (existing != null && existing.isActive) {
        return existing;
      }

      // 2. Try domain-affinity match from idle
      final etld = _extractEtldPlusOne(domainHint);
      PoolSession? session;

      if (etld != null) {
        final domainIdle = _idle[etld];
        if (domainIdle != null && domainIdle.isNotEmpty) {
          session = domainIdle.removeLast();
          if (domainIdle.isEmpty) _idle.remove(etld);
        }
      }

      // 3. Try generic idle
      session ??= _genericIdle.isNotEmpty ? _genericIdle.removeLast() : null;

      // 4. Create new if needed (respecting cap)
      session ??= await _createSession(sessionId, domainHint, etld, settings);

      // 5. Register as active
      // Reused idle sessions retain a stale releasedAt (set on release),
      // which would make isActive report false for a live, reused session.
      session.releasedAt = null;
      _active[sessionId] = session;
      return session;
    });
  }

  @override
  Future<void> release(String sessionId) async {
    return _synchronized(() async {
      final session = _active.remove(sessionId);
      if (session == null) return; // safe no-op

      session.releasedAt = DateTime.now();

      final etld = session.etldPlusOne;
      if (etld != null) {
        (_idle[etld] ??= []).add(session);
      } else {
        _genericIdle.add(session);
      }
    });
  }

  @override
  Future<void> disposeAll() async {
    return _synchronized(() async {
      // Dispose active sessions
      for (final session in _active.values) {
        await session.webview.dispose();
      }
      _active.clear();

      // Dispose idle sessions
      for (final entries in _idle.values) {
        for (final session in entries) {
          await session.webview.dispose();
        }
      }
      _idle.clear();

      for (final session in _genericIdle) {
        await session.webview.dispose();
      }
      _genericIdle.clear();
    });
  }

  @override
  int get liveCount {
    var count = _active.length;
    for (final entries in _idle.values) {
      count += entries.length;
    }
    count += _genericIdle.length;
    return count;
  }

  @override
  List<PoolSessionInfo> sessions() {
    final result = <PoolSessionInfo>[];
    for (final entry in _active.entries) {
      result.add(PoolSessionInfo(
        sessionId: entry.key,
        domainHint: entry.value.domainHint,
        etldPlusOne: entry.value.etldPlusOne,
        isActive: true,
        acquiredAt: entry.value.acquiredAt,
      ));
    }
    return result;
  }
  /// Disposes the pool and releases all resources.
  Future<void> dispose() async {
    _evictionTimer?.cancel();
    _lifecycleListener?.dispose();
    await disposeAll();
  }

  // --- Private ---

  Future<T> _synchronized<T>(Future<T> Function() fn) async {
    // Serialize critical sections via a future-chain mutex: each caller
    // appends its work after the previous caller finishes, so only one
    // critical section runs at a time. This prevents concurrent acquire()
    // calls from exceeding maxLiveInstances.
    final previous = _lock;
    final completer = Completer<void>();
    _lock = completer.future;
    try {
      await previous;
      return await fn();
    } finally {
      completer.complete();
    }
  }

  Future<PoolSession> _createSession(
    String sessionId,
    String? domainHint,
    String? etld,
    InAppWebViewSettings? settings,
  ) async {
    if (liveCount >= config.maxLiveInstances) {
      await _evictOldestIdle();
    }

    final webview = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri('about:blank')),
      initialSettings: InAppWebViewSettings(),
    );
    await webview.run();

    return PoolSession(
      sessionId: sessionId,
      domainHint: domainHint,
      etldPlusOne: etld,
      webview: webview,
      settings: settings ?? InAppWebViewSettings(),
    );
  }

  Future<void> _evictOldestIdle() async {
    // Evict from domain idle pools first
    for (final entries in _idle.values) {
      if (entries.isNotEmpty) {
        final oldest = entries.removeAt(0);
        await oldest.webview.dispose();
        return;
      }
    }
    // Fall back to generic idle
    if (_genericIdle.isNotEmpty) {
      final oldest = _genericIdle.removeAt(0);
      await oldest.webview.dispose();
    }
  }

  void _startEvictionTimer() {
    _evictionTimer = Timer.periodic(
      Duration(seconds: 30),
      (_) => _evictExpired(),
    );
  }

  Future<void> _evictExpired() async {
    final cutoff = DateTime.now().subtract(
      Duration(seconds: config.idleTtlSeconds),
    );

    for (final entries in _idle.values) {
      entries.removeWhere((s) {
        final expired = s.releasedAt != null && s.releasedAt!.isBefore(cutoff);
        if (expired) {
          unawaited(s.webview.dispose());
        }
        return expired;
      });
    }
    _idle.removeWhere((_, entries) => entries.isEmpty);

    _genericIdle.removeWhere((s) {
      final expired = s.releasedAt != null && s.releasedAt!.isBefore(cutoff);
      if (expired) {
        unawaited(s.webview.dispose());
      }
      return expired;
    });
  }

  void _startLifecycleListener() {
    try {
      _lifecycleListener = AppLifecycleListener(
        onInactive: _onLifecycleInactive,
      );
    } catch (_) {
      // Best-effort: not available in test/non-Flutter contexts.
    }
  }

  void _onLifecycleInactive() {
    // Dispose idle instances under memory pressure / backgrounding.
    // Active sessions remain intact.
    for (final entries in _idle.values) {
      for (final session in entries) {
        unawaited(session.webview.dispose());
      }
    }
    _idle.clear();

    for (final session in _genericIdle) {
      unawaited(session.webview.dispose());
    }
    _genericIdle.clear();
  }

  /// Extracts eTLD+1 from a domain hint.
  ///
  /// Uses a simple heuristic: split on dots and take the last two parts.
  /// Handles IP addresses and localhost by returning them as-is.
  /// A full public-suffix-list implementation can be swapped in later.
  static String? _extractEtldPlusOne(String? domain) {
    if (domain == null || domain.isEmpty) return null;

    // Handle IP addresses and localhost
    final ipPattern = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
    if (ipPattern.hasMatch(domain) || domain == 'localhost') {
      return domain;
    }

    // Simple heuristic: take last two dot-separated parts
    final parts = domain.split('.');
    if (parts.length >= 2) {
      return parts.sublist(parts.length - 2).join('.');
    }
    return domain;
  }
}
