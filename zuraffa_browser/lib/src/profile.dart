part of 'browser.dart';

/// A profile: a session-isolated scope that may carry its own proxy
/// configuration (spec 279, FR-003).
///
/// The per-profile proxy overrides the global proxy for this profile only
/// (FR-003); removing it falls back to the global proxy, or to a direct
/// connection when no global proxy is set (FR-004). Profiles without an
/// explicit proxy always inherit the global proxy (FR-011).
class Profile {
  final String id;
  final String name;
  final Browser _browser;

  ProxyConfig? _explicit;
  bool _disposed = false;
  int _pageCounter = 0;
  final List<BrowserPage> _pages = [];

  Profile._({required this.id, required this.name, required Browser browser})
    : _browser = browser;

  /// Vault key for this profile's proxy password.
  String get _secretKey => 'proxy/profile/$id/password';

  /// The explicit per-profile proxy, or null when none is set.
  ProxyConfig? get proxy => _explicit;

  /// The proxy this profile resolves to: explicit per-profile config,
  /// otherwise the global proxy, otherwise null (direct connection).
  ProxyConfig? get effectiveProxy {
    if (_disposed) {
      throw StateError('Profile $id has been disposed');
    }
    return _explicit ?? _browser._global;
  }

  /// Whether this profile has been disposed.
  bool get isDisposed => _disposed;

  /// Sets (or changes) this profile's proxy (FR-003).
  ///
  /// The configuration is persisted with the profile (FR-005); the password,
  /// if any, goes to the vault only (FR-009). Taking effect is a lifecycle
  /// concern: the change applies on the next navigation (FR-007), so this
  /// method does NOT touch the applier.
  Future<void> setProxy(ProxyConfig config) async {
    _guardNotDisposed();
    _explicit = config;
    if (config.password != null) {
      await _browser._vault.write(_secretKey, config.password!);
      await _browser._store.saveProfile(
        id,
        config.toRecord(secretRef: _secretKey),
      );
    } else {
      await _browser._vault.delete(_secretKey);
      await _browser._store.saveProfile(id, config.toRecord());
    }
  }

  /// Removes this profile's proxy (FR-004): resolution falls back to the
  /// global proxy, or to a direct connection when no global is set.
  Future<void> clearProxy() async {
    _guardNotDisposed();
    _explicit = null;
    await _browser._store.saveProfile(id, null);
    await _browser._vault.delete(_secretKey);
  }

  /// The live pages opened on this profile.
  List<BrowserPage> get pages => List.unmodifiable(_pages);

  /// Opens a new [BrowserPage] on this profile.
  ///
  /// The page host comes from the browser's [PageHostFactory]; the default
  /// factory binds the page's webview to this profile's persistent store.
  BrowserPage openPage() {
    _guardNotDisposed();
    final page = BrowserPage._(
      id: '$id/page-${++_pageCounter}',
      profile: this,
      host: _browser._pageHostFactory(this),
    );
    _pages.add(page);
    return page;
  }

  /// Disposes the profile (FR-008): closes and disposes its pages, removes
  /// the profile from the live list, and — when the profile carried its own
  /// proxy — re-applies the fallback (the global proxy, or a direct
  /// connection) so the process override no longer routes through the
  /// released profile's proxy. Persisted records are kept: the profile can
  /// be re-created with its proxy later.
  Future<void> dispose() async {
    _guardNotDisposed();
    _disposed = true;
    for (final page in List.of(_pages)) {
      await page.dispose();
    }
    _pages.clear();
    _browser._profiles.remove(id);
    if (_explicit != null) {
      await _browser._applyForScope(
        ResolvedScope.global,
        'global',
        _browser._global,
      );
    }
  }

  void _guardNotDisposed() {
    if (_disposed) {
      throw StateError('Profile $id has been disposed');
    }
  }
}
