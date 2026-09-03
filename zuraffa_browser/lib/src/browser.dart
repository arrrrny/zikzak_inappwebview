import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import 'page_host.dart';
import 'platform_settings.dart';
import 'proxy_config.dart';
import 'proxy_ports.dart';

part 'profile.dart';
part 'page.dart';

/// Creates the [PageHost] for pages opened on a [Profile].
typedef PageHostFactory = PageHost Function(Profile profile);

/// The browser: owns the global proxy configuration and the profiles.
///
/// Spec 279. The global proxy applies to every profile (FR-001); setting it
/// persists the configuration through the injected [ProxyConfigStore] (minus
/// the password, which goes to the [SecretVault]) and pushes it through the
/// [ProxyApplier] so all future connections route through it.
class Browser {
  final ProxyConfigStore _store;
  final SecretVault _vault;
  final ProxyApplier _applier;
  final PageHostFactory _pageHostFactory;

  ProxyConfig? _global;
  ResolvedProxy? _lastApplied;
  var _hasApplied = false;
  final Map<String, Profile> _profiles = {};
  bool _disposed = false;

  Browser._({
    required ProxyConfigStore store,
    required SecretVault vault,
    required ProxyApplier applier,
    PageHostFactory? pageHostFactory,
  })  : _store = store,
        _vault = vault,
        _applier = applier,
        _pageHostFactory = pageHostFactory ?? _defaultPageHostFactory;

  /// Opens a browser, restoring persisted proxy configuration.
  ///
  /// [store], [vault] default to in-memory implementations (tests). The
  /// global record (if any) is restored from [store]; its password is
  /// re-resolved through [vault] (FR-002, FR-009).
  static Future<Browser> open({
    ProxyConfigStore? store,
    SecretVault? vault,
    required ProxyApplier applier,
    PageHostFactory? pageHostFactory,
  }) async {
    final browser = Browser._(
      store: store ?? InMemoryProxyConfigStore(),
      vault: vault ?? InMemorySecretVault(),
      applier: applier,
      pageHostFactory: pageHostFactory,
    );
    final record = await browser._store.loadGlobal();
    if (record != null) {
      final password = record.secretRef == null
          ? null
          : await browser._vault.read(record.secretRef!);
      browser._global = record.toConfig(password: password);
    }
    // Restore per-profile proxy records (FR-005): every profile the store
    // knows a proxy record for comes back with its configuration attached.
    for (final profileId in await browser._store.profileIds()) {
      final profileRecord = await browser._store.loadProfile(profileId);
      if (profileRecord == null) {
        continue;
      }
      final password = profileRecord.secretRef == null
          ? null
          : await browser._vault.read(profileRecord.secretRef!);
      final profile = Profile._(
        id: profileId,
        name: profileId,
        browser: browser,
      );
      profile._explicit = profileRecord.toConfig(password: password);
      browser._profiles[profileId] = profile;
    }
    return browser;
  }

  /// The current global proxy configuration, or null (direct connection).
  ProxyConfig? get proxy => _global;

  /// Creates (or returns the already-known) profile with [id].
  ///
  /// Profiles restored from the store on [open] are returned as-is, so a
  /// restart over the same store keeps their per-profile proxies (FR-005).
  Profile createProfile(String id, {String? name}) {
    _guardNotDisposed();
    final existing = _profiles[id];
    if (existing != null) {
      return existing;
    }
    final profile = Profile._(
      id: id,
      name: name ?? id,
      browser: this,
    );
    _profiles[id] = profile;
    return profile;
  }

  /// The profile with [id], or null when unknown.
  Profile? profile(String id) => _profiles[id];

  /// The live profiles.
  List<Profile> get profiles => _profiles.values.toList();

  /// Whether the browser has been disposed.
  bool get isDisposed => _disposed;

  /// Disposes the browser (FR-008): disposes all live profiles (closing
  /// their pages and releasing their proxy resources) and disposes the
  /// applier. Further API calls throw [StateError].
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    for (final profile in _profiles.values.toList()) {
      await profile.dispose();
    }
    await _applier.dispose();
    _disposed = true;
  }

  /// Sets (or changes) the global proxy (FR-001).
  ///
  /// Persists the configuration (password only into the vault, FR-009) and
  /// immediately pushes the new configuration through the applier: the
  /// platform override is process-wide and governs future connections of
  /// every profile.
  Future<void> setProxy(ProxyConfig config) async {
    _guardNotDisposed();
    _global = config;
    await _persistGlobal(config);
    await _applyForScope(ResolvedScope.global, 'global', config);
  }

  /// Clears the global proxy: direct connection for profiles without their
  /// own proxy (FR-004, FR-010).
  Future<void> clearProxy() async {
    _guardNotDisposed();
    _global = null;
    await _store.saveGlobal(null);
    await _vault.delete(_globalSecretKey);
    await _applyForScope(ResolvedScope.global, 'global', null);
  }

  /// Pushes [config] (or a clear, with null) through the applier and
  /// records it as the currently applied process override.
  Future<void> _applyForScope(
    ResolvedScope scope,
    String scopeId,
    ProxyConfig? config,
  ) async {
    final resolved = config == null
        ? null
        : ResolvedProxy(
            scope: scope,
            scopeId: scopeId,
            config: config,
            password: config.password,
          );
    await _applier.apply(resolved);
    _lastApplied = resolved;
    _hasApplied = true;
  }

  /// Whether [resolved] is already the applied process override; the very
  /// first application always counts as a change so that the
  /// direct-connection default is established explicitly (FR-010).
  bool _isApplied(ResolvedProxy? resolved) {
    if (!_hasApplied) {
      return false;
    }
    final last = _lastApplied;
    if (last == null || resolved == null) {
      return last == null && resolved == null;
    }
    // The process override carries only the configuration: scope/scopeId
    // are not compared, so navigating from any scope with the same
    // effective config is idempotent (FR-007).
    return last.config == resolved.config &&
        last.password == resolved.password;
  }

  Future<void> _persistGlobal(ProxyConfig? config) async {
    if (config == null) {
      await _store.saveGlobal(null);
      await _vault.delete(_globalSecretKey);
      return;
    }
    if (config.password != null) {
      await _vault.write(_globalSecretKey, config.password!);
      await _store.saveGlobal(config.toRecord(secretRef: _globalSecretKey));
    } else {
      await _vault.delete(_globalSecretKey);
      await _store.saveGlobal(config.toRecord());
    }
  }

  /// Vault key for the global proxy password.
  static const String _globalSecretKey = 'proxy/global/password';

  /// Default production page host: a headless webview bound to the profile
  /// persistent store.
  static PageHost _defaultPageHostFactory(Profile profile) =>
      HeadlessPageHost(
        settings: InAppWebViewSettings(
          persistentStoreIdentifier: 'zuraffa_browser/${profile.id}',
        ),
      );

  void _guardNotDisposed() {
    if (_disposed) {
      throw StateError('Browser has been disposed');
    }
  }
}
