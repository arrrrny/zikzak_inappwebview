part of 'browser.dart';

/// A page opened within a [Profile] (spec 279, FR-006).
///
/// A page may carry a one-off proxy override that wins over the profile and
/// global configuration for this page only ([proxyOverride]); clearing it
/// falls back to the profile proxy, then the global proxy, then direct
/// connection ([effectiveProxy]). The override is deliberately NOT
/// persisted — it is a one-off.
///
/// Lifecycle (FR-007): proxy changes are never retroactive. [navigate]
/// resolves the page's effective proxy and applies it through the platform
/// BEFORE loading the URL, and only when it differs from what the process
/// override currently is.
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

  /// Navigates to [uri]: applies the page's effective proxy through the
  /// platform (when it differs from the currently applied process override,
  /// or when nothing has been applied yet) and THEN loads the URL (FR-007).
  Future<void> navigate(WebUri uri) async {
    _guardNotDisposed();
    final browser = profile._browser;
    final effective = effectiveProxy;
    final resolved = effective == null
        ? null
        : ResolvedProxy(
            scope: ResolvedScope.page,
            scopeId: id,
            config: effective,
            password: effective.password,
          );
    if (!browser._isApplied(resolved)) {
      await browser._applier.apply(resolved);
      browser._lastApplied = resolved;
      browser._hasApplied = true;
    }
    await host.loadUrl(uri);
  }

  /// Disposes the page: closes the underlying host and detaches the page
  /// from its profile. Persisted proxy configuration is not touched.
  Future<void> dispose() async {
    _guardNotDisposed();
    _disposed = true;
    profile._pages.remove(this);
    await host.close();
  }

  void _guardNotDisposed() {
    if (_disposed) {
      throw StateError('Page $id has been disposed');
    }
  }
}
