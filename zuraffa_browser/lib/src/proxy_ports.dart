/// Injected ports behind which the browser isolates persistence, secret
/// storage, and platform proxy application (spec 279, FR-012).
///
/// Tests substitute in-memory implementations; production apps inject the
/// real ones (a file store, an OS-keychain-backed vault, and the platform
/// applier that wraps zikzak_inappwebview's `ProxyController`).
library;

import 'dart:convert';
import 'dart:io';

import 'proxy_config.dart';

/// Persistence port for proxy configuration records (FR-002, FR-005).
///
/// A `null` record passed to a save method clears the stored configuration.
abstract class ProxyConfigStore {
  /// Loads the persisted global proxy record, or null when none is set.
  Future<ProxyConfigRecord?> loadGlobal();

  /// Persists (or clears, with null) the global proxy record.
  Future<void> saveGlobal(ProxyConfigRecord? record);

  /// Loads the persisted record for [profileId], or null when none is set.
  Future<ProxyConfigRecord?> loadProfile(String profileId);

  /// Persists (or clears, with null) the record for [profileId].
  Future<void> saveProfile(String profileId, ProxyConfigRecord? record);

  /// Lists the profile ids that currently have a stored record.
  Future<List<String>> profileIds();
}

/// In-memory [ProxyConfigStore]; the test default.
class InMemoryProxyConfigStore implements ProxyConfigStore {
  ProxyConfigRecord? _global;
  final Map<String, ProxyConfigRecord> _profiles = {};

  @override
  Future<ProxyConfigRecord?> loadGlobal() async => _global;

  @override
  Future<void> saveGlobal(ProxyConfigRecord? record) async {
    _global = record;
  }

  @override
  Future<ProxyConfigRecord?> loadProfile(String profileId) async =>
      _profiles[profileId];

  @override
  Future<void> saveProfile(String profileId, ProxyConfigRecord? record) async {
    if (record == null) {
      _profiles.remove(profileId);
    } else {
      _profiles[profileId] = record;
    }
  }

  @override
  Future<List<String>> profileIds() async => _profiles.keys.toList();
}

/// File-backed [ProxyConfigStore]: one JSON file holding the global record
/// and the per-profile records; the default restart-survival implementation
/// (FR-002, FR-005). Records contain no secrets — only [secretRef] keys.
class FileProxyConfigStore implements ProxyConfigStore {
  /// The JSON file backing this store.
  final File file;

  /// Creates a store backed by [file] (created on first write).
  FileProxyConfigStore({required this.file});

  Map<String, dynamic> _readAll() {
    if (!file.existsSync()) {
      return <String, dynamic>{};
    }
    final content = file.readAsStringSync();
    if (content.isEmpty) {
      return <String, dynamic>{};
    }
    return jsonDecode(content) as Map<String, dynamic>;
  }

  void _writeAll(Map<String, dynamic> all) {
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(jsonEncode(all), flush: true);
  }

  @override
  Future<ProxyConfigRecord?> loadGlobal() async {
    final all = _readAll();
    final raw = all['global'];
    if (raw == null) {
      return null;
    }
    return ProxyConfigRecord.fromJson((raw as Map).cast<String, dynamic>());
  }

  @override
  Future<void> saveGlobal(ProxyConfigRecord? record) async {
    final all = _readAll();
    if (record == null) {
      all.remove('global');
    } else {
      all['global'] = record.toJson();
    }
    _writeAll(all);
  }

  @override
  Future<ProxyConfigRecord?> loadProfile(String profileId) async {
    final all = _readAll();
    final profiles = (all['profiles'] as Map?)?.cast<String, dynamic>();
    final raw = profiles?[profileId];
    if (raw == null) {
      return null;
    }
    return ProxyConfigRecord.fromJson((raw as Map).cast<String, dynamic>());
  }

  @override
  Future<void> saveProfile(String profileId, ProxyConfigRecord? record) async {
    final all = _readAll();
    final profiles =
        (all['profiles'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    if (record == null) {
      profiles.remove(profileId);
    } else {
      profiles[profileId] = record.toJson();
    }
    if (profiles.isEmpty) {
      all.remove('profiles');
    } else {
      all['profiles'] = profiles;
    }
    _writeAll(all);
  }

  @override
  Future<List<String>> profileIds() async {
    final all = _readAll();
    final profiles = (all['profiles'] as Map?)?.cast<String, dynamic>();
    return profiles?.keys.toList() ?? const [];
  }
}

/// Secret storage port (FR-009): passwords never touch the config store in
/// plaintext; production apps inject an OS-keychain / secure-storage
/// implementation.
abstract class SecretVault {
  /// Stores [secret] under [key].
  Future<void> write(String key, String secret);

  /// Reads the secret under [key], or null when absent.
  Future<String?> read(String key);

  /// Deletes the secret under [key].
  Future<void> delete(String key);
}

/// In-memory [SecretVault]; the test default.
class InMemorySecretVault implements SecretVault {
  final _secrets = <String, String>{};

  @override
  Future<void> write(String key, String secret) async {
    _secrets[key] = secret;
  }

  @override
  Future<String?> read(String key) async => _secrets[key];

  @override
  Future<void> delete(String key) async {
    _secrets.remove(key);
  }
}

/// Which browser scope a resolved proxy was resolved for.
enum ResolvedScope { global, profile, page }

/// A proxy configuration resolved for a navigating scope, with the password
/// already resolved from the vault, ready to be handed to a [ProxyApplier].
class ResolvedProxy {
  /// The scope kind the config was resolved for.
  final ResolvedScope scope;

  /// `'global'`, the profile id, or the page id depending on [scope].
  final String scopeId;

  /// The resolved configuration.
  final ProxyConfig config;

  /// The password resolved from the vault (null when unauthenticated).
  final String? password;

  /// Creates a resolved proxy.
  const ResolvedProxy({
    required this.scope,
    required this.scopeId,
    required this.config,
    this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolvedProxy &&
          scope == other.scope &&
          scopeId == other.scopeId &&
          config == other.config &&
          password == other.password;

  @override
  int get hashCode => Object.hash(scope, scopeId, config, password);

  @override
  String toString() =>
      'ResolvedProxy(${scope.name}/$scopeId, $config'
      '${password != null ? ', password: •••' : ''})';
}

/// Application port: pushes a resolved proxy (or clears it, with null) into
/// the underlying platform proxy infrastructure (FR-012).
abstract class ProxyApplier {
  /// Applies [proxy] to the platform, or clears the override when null
  /// (direct connection, FR-010).
  Future<void> apply(ResolvedProxy? proxy);

  /// Releases all platform proxy resources held by this applier.
  Future<void> dispose();
}
