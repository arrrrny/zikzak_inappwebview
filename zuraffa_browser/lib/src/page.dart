part of 'browser.dart';

/// A page opened within a [Profile] (spec 279, FR-006).
///
/// A page may carry a one-off proxy override that wins over the profile and
/// global configuration for this page only ([proxyOverride]); clearing it
/// falls back to the profile proxy, then the global proxy, then direct
/// connection ([effectiveProxy]). The override is deliberately NOT
/// persisted — it is a one-off.
class BrowserPage {
  final String id;
  final Profile profile;

  /// The underlying webview host.
  final PageHost host;

  ProxyConfig? _override;
  bool _disposed = false;

  BrowserPage._({
    required this.id,
    required this.profile,
    required this.host,
  });

  /// The one-off per-page proxy override, or null when none is set.
  ProxyConfig? get proxyOverride => _override;

  /// The proxy this page resolves to: the page override, otherwise the
  /// profile's effective proxy (profile proxy, then global), otherwise null
  /// (direct connection).
  ProxyConfig? get effectiveProxy {
    if (_disposed) {
      throw StateError('Page $id has been disposed');
    }
    return _override ?? profile.effectiveProxy;
  }

  /// Whether this page has been disposed.
  bool get isDisposed => _disposed;

  /// Sets the one-off per-page proxy override (FR-006).
  ///
  /// Not persisted; taking effect is a lifecycle concern handled at
  /// navigation time (FR-007).
  Future<void> setProxy(ProxyConfig config) async {
    _guardNotDisposed();
    _override = config;
  }

  /// Clears the page override: resolution falls back to the profile proxy,
  /// then the global proxy (FR-006).
  Future<void> clearProxy() async {
    _guardNotDisposed();
    _override = null;
  }

  void _guardNotDisposed() {
    if (_disposed) {
      throw StateError('Page $id has been disposed');
    }
  }

  /// Detaches runtime state; the host is closed by [Profile.disposePage].
  void markDisposed() {
    _disposed = true;
  }
}
