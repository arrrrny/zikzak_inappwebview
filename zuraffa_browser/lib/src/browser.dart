import 'proxy_config.dart';
import 'proxy_ports.dart';

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

  ProxyConfig? _global;
  ResolvedProxy? _lastApplied;
  bool _disposed = false;

  Browser._({
    required ProxyConfigStore store,
    required SecretVault vault,
    required ProxyApplier applier,
  })  : _store = store,
        _vault = vault,
        _applier = applier;

  /// Opens a browser, restoring persisted proxy configuration.
  ///
  /// [store], [vault] default to in-memory implementations (tests). The
  /// global record (if any) is restored from [store]; its password is
  /// re-resolved through [vault] (FR-002, FR-009).
  static Future<Browser> open({
    ProxyConfigStore? store,
    SecretVault? vault,
    required ProxyApplier applier,
  }) async {
    final browser = Browser._(
      store: store ?? InMemoryProxyConfigStore(),
      vault: vault ?? InMemorySecretVault(),
      applier: applier,
    );
    final record = await browser._store.loadGlobal();
    if (record != null) {
      final password = record.secretRef == null
          ? null
          : await browser._vault.read(record.secretRef!);
      browser._global = record.toConfig(password: password);
    }
    return browser;
  }

  /// The current global proxy configuration, or null (direct connection).
  ProxyConfig? get proxy => _global;

  /// Whether the browser has been disposed.
  bool get isDisposed => _disposed;

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
    final resolved = ResolvedProxy(
      scope: ResolvedScope.global,
      scopeId: 'global',
      config: config,
      password: config.password,
    );
    await _applier.apply(resolved);
    _lastApplied = resolved;
  }

  /// Clears the global proxy: direct connection for profiles without their
  /// own proxy (FR-004, FR-010).
  Future<void> clearProxy() async {
    _guardNotDisposed();
    _global = null;
    await _store.saveGlobal(null);
    await _vault.delete(_globalSecretKey);
    await _applier.apply(null);
    _lastApplied = null;
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

  void _guardNotDisposed() {
    if (_disposed) {
      throw StateError('Browser has been disposed');
    }
  }
}
