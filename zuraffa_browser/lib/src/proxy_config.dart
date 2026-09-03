/// Proxy configuration value objects for zuraffa_browser (spec 279).
///
/// [ProxyConfig] is the in-memory configuration (its [ProxyConfig.password]
/// is transient and never serialized). [ProxyConfigRecord] is the persistable
/// projection: it carries a [ProxyConfigRecord.secretRef] pointing at a
/// [SecretVault] key instead of a plaintext password (FR-009).
library;

/// Supported proxy schemes (FR-001).
enum ProxyType {
  http('http'),
  https('https'),
  socks5('socks5');

  /// The lowercase wire representation used in serialized records and proxy
  /// URLs.
  final String wire;

  const ProxyType(this.wire);

  /// Parses a [wire] value; throws [ArgumentError] for unknown values.
  static ProxyType fromWire(String wire) {
    for (final type in values) {
      if (type.wire == wire) {
        return type;
      }
    }
    throw ArgumentError.value(wire, 'wire', 'unknown proxy type');
  }
}

/// A proxy configuration: host, port, type, and optional credentials.
///
/// [password] is transient: it participates in equality (so configuration
/// change detection reacts to credential rotation) but is never serialized
/// ([toJson] and [toString] redact it, FR-009).
class ProxyConfig {
  /// Proxy host (non-empty).
  final String host;

  /// Proxy port (1-65535).
  final int port;

  /// Proxy scheme.
  final ProxyType type;

  /// Optional username for authenticated proxies (FR-009).
  final String? username;

  /// Transient password; resolved through a [SecretVault] for persistence.
  final String? password;

  /// Creates a proxy configuration; throws [ArgumentError] on an empty host
  /// or a port outside 1-65535.
  ProxyConfig({
    required this.host,
    required this.port,
    required this.type,
    this.username,
    this.password,
  }) {
    if (host.isEmpty) {
      throw ArgumentError.value(host, 'host', 'must not be empty');
    }
    if (port < 1 || port > 65535) {
      throw ArgumentError.value(port, 'port', 'must be within 1-65535');
    }
  }

  /// The URL scheme for this configuration (equals [ProxyType.wire]).
  String get scheme => type.wire;

  /// Renders `[scheme://][user:pass@]host:port`; [password] overrides the
  /// transient [ProxyConfig.password] (used when the password is resolved
  /// from the vault at apply time).
  String toProxyUrl({String? password}) {
    final effectivePassword = password ?? this.password;
    final credentials = (username != null || effectivePassword != null)
        ? '${username ?? ''}:${effectivePassword ?? ''}@'
        : '';
    return '$scheme://$credentials$host:$port';
  }

  /// Serializes the configuration WITHOUT the password (FR-009).
  Map<String, dynamic> toJson() => <String, dynamic>{
    'host': host,
    'port': port,
    'type': type.wire,
    if (username != null) 'username': username,
  };

  /// Restores a configuration from [ProxyConfig.toJson] output.
  factory ProxyConfig.fromJson(Map<String, dynamic> json) => ProxyConfig(
    host: json['host'] as String,
    port: json['port'] as int,
    type: ProxyType.fromWire(json['type'] as String),
    username: json['username'] as String?,
  );

  /// Projects the configuration into a persistable record; [secretRef] is
  /// the vault key where the password (if any) is stored.
  ProxyConfigRecord toRecord({String? secretRef}) => ProxyConfigRecord(
    host: host,
    port: port,
    type: type,
    username: username,
    secretRef: secretRef,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProxyConfig &&
          host == other.host &&
          port == other.port &&
          type == other.type &&
          username == other.username &&
          password == other.password;

  @override
  int get hashCode => Object.hash(host, port, type, username, password);

  @override
  String toString() =>
      'ProxyConfig($scheme://'
      '${username != null ? '$username:•••@' : ''}$host:$port)';
}

/// The persistable projection of a [ProxyConfig]: same fields plus
/// [secretRef] (the vault key for the password), never the password itself
/// (FR-009).
class ProxyConfigRecord {
  final String host;
  final int port;
  final ProxyType type;
  final String? username;

  /// Vault key that resolves to the password, or null when the proxy has no
  /// stored credential.
  final String? secretRef;

  const ProxyConfigRecord({
    required this.host,
    required this.port,
    required this.type,
    this.username,
    this.secretRef,
  });

  /// Serializes the record; contains no secrets.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'host': host,
    'port': port,
    'type': type.wire,
    if (username != null) 'username': username,
    if (secretRef != null) 'secretRef': secretRef,
  };

  /// Restores a record from [toJson] output.
  factory ProxyConfigRecord.fromJson(Map<String, dynamic> json) =>
      ProxyConfigRecord(
        host: json['host'] as String,
        port: json['port'] as int,
        type: ProxyType.fromWire(json['type'] as String),
        username: json['username'] as String?,
        secretRef: json['secretRef'] as String?,
      );

  /// Expands the record back into a [ProxyConfig]; [password] comes from the
  /// vault at resolve time.
  ProxyConfig toConfig({String? password}) => ProxyConfig(
    host: host,
    port: port,
    type: type,
    username: username,
    password: password,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProxyConfigRecord &&
          host == other.host &&
          port == other.port &&
          type == other.type &&
          username == other.username &&
          secretRef == other.secretRef;

  @override
  int get hashCode => Object.hash(host, port, type, username, secretRef);

  @override
  String toString() =>
      'ProxyConfigRecord($type://$host:$port'
      '${username != null ? ', user: $username' : ''}'
      '${secretRef != null ? ', secretRef: $secretRef' : ''})';
}
