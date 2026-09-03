part of 'browser.dart';

/// Looks up the browser's current global proxy configuration.
typedef GlobalProxyLookup = ProxyConfig? Function();

/// A profile: a session-isolated scope that may carry its own proxy
/// configuration (FR-003).
///
/// The per-profile proxy overrides the global proxy for this profile only
/// (FR-003); removing it falls back to the global proxy, or to a direct
/// connection when no global proxy is set (FR-004). Profiles without an
/// explicit proxy always inherit the global proxy (FR-011).
class Profile {
  final String id;
  final String name;
  final ProxyConfigStore _store;
  final SecretVault _vault;
  final GlobalProxyLookup _globalLookup;
  final PageHostFactory _pageHostFactory;

  ProxyConfig? _explicit;
  bool _disposed = false;
  int _pageCounter = 0;
  final List<BrowserPage> _pages = [];

  Profile._({
    required this.id,
    required this.name,
    required ProxyConfigStore store,
    required SecretVault vault,
    required GlobalProxyLookup globalLookup,
    required PageHostFactory pageHostFactory,
  })  : _store = store,
        _vault = vault,
        _globalLookup = globalLookup,
        _pageHostFactory = pageHostFactory;

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
    return _explicit ?? _globalLookup();
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
      await _vault.write(_secretKey, config.password!);
      await _store.saveProfile(id, config.toRecord(secretRef: _secretKey));
    } else {
      await _vault.delete(_secretKey);
      await _store.saveProfile(id, config.toRecord());
    }
  }

  /// Removes this profile's proxy (FR-004): resolution falls back to the
  /// global proxy, or to a direct connection when no global is set.
  Future<void> clearProxy() async {
    _guardNotDisposed();
    _explicit = null;
    await _store.saveProfile(id, null);
    await _vault.delete(_secretKey);
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
      host: _pageHostFactory(this),
    );
    _pages.add(page);
    return page;
  }

  void _guardNotDisposed() {
    if (_disposed) {
      throw StateError('Profile $id has been disposed');
    }
  }

  /// Detaches runtime state (persistence stays; see Browser.dispose and the
  /// lifecycle tests for the full dispose contract).
  void markDisposed() {
    _disposed = true;
  }
}
