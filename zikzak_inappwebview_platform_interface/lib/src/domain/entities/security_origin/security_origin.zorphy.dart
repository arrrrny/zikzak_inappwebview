// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'security_origin.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class SecurityOrigin {
  SecurityOrigin({
    required String this.host,
    required int this.port,
    required String this.protocol,
  });

  factory SecurityOrigin.fromJson(Map<String, dynamic> json) =>
      _$SecurityOriginFromJson(json);

  final String host;

  final int port;

  final String protocol;

  SecurityOrigin copyWith({String? host, int? port, String? protocol}) {
    return SecurityOrigin(
      host: host ?? this.host,
      port: port ?? this.port,
      protocol: protocol ?? this.protocol,
    );
  }

  SecurityOrigin copyWithSecurityOrigin({
    String? host,
    int? port,
    String? protocol,
  }) {
    return copyWith(host: host, port: port, protocol: protocol);
  }

  SecurityOrigin patchWithSecurityOrigin([SecurityOriginPatch? patchInput]) {
    final _patcher = patchInput ?? SecurityOriginPatch();
    final _patchMap = _patcher.patchMap;
    return SecurityOrigin(
      host: _patchMap.containsKey(SecurityOrigin$.host)
          ? (_patchMap[SecurityOrigin$.host] is Function)
                ? _patchMap[SecurityOrigin$.host](this.host)
                : (_patchMap[SecurityOrigin$.host] is Patch)
                ? _patchMap[SecurityOrigin$.host].applyTo(this.host)
                : _patchMap[SecurityOrigin$.host]
          : this.host,
      port: _patchMap.containsKey(SecurityOrigin$.port)
          ? (_patchMap[SecurityOrigin$.port] is Function)
                ? _patchMap[SecurityOrigin$.port](this.port)
                : (_patchMap[SecurityOrigin$.port] is Patch)
                ? _patchMap[SecurityOrigin$.port].applyTo(this.port)
                : _patchMap[SecurityOrigin$.port]
          : this.port,
      protocol: _patchMap.containsKey(SecurityOrigin$.protocol)
          ? (_patchMap[SecurityOrigin$.protocol] is Function)
                ? _patchMap[SecurityOrigin$.protocol](this.protocol)
                : (_patchMap[SecurityOrigin$.protocol] is Patch)
                ? _patchMap[SecurityOrigin$.protocol].applyTo(this.protocol)
                : _patchMap[SecurityOrigin$.protocol]
          : this.protocol,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SecurityOrigin &&
        host == other.host &&
        port == other.port &&
        protocol == other.protocol;
  }

  @override
  int get hashCode {
    return Object.hash(this.host, this.port, this.protocol);
  }

  @override
  String toString() {
    return 'SecurityOrigin(' +
        'host: ${host}' +
        ', ' +
        'port: ${port}' +
        ', ' +
        'protocol: ${protocol})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$SecurityOriginToJson(this);
    return _sanitizeJson(data);
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension SecurityOriginPropertyHelpers on SecurityOrigin {
  bool get hasHost {
    return this.host.isNotEmpty;
  }

  bool get noHost {
    return this.host.isEmpty;
  }

  bool get hasProtocol {
    return this.protocol.isNotEmpty;
  }

  bool get noProtocol {
    return this.protocol.isEmpty;
  }
}

extension SecurityOriginSerialization on SecurityOrigin {
  Map<String, dynamic> toJson() {
    return _$SecurityOriginToJson(this);
  }
}

enum SecurityOrigin$ { host, port, protocol }

class SecurityOriginPatch extends PatchBase<SecurityOrigin, SecurityOrigin$> {
  SecurityOrigin applyTo(SecurityOrigin entity) {
    return entity.patchWithSecurityOrigin(this);
  }

  SecurityOriginPatch withHost(String? value) {
    patchMap[SecurityOrigin$.host] = value;
    return this;
  }

  SecurityOriginPatch withPort(int? value) {
    patchMap[SecurityOrigin$.port] = value;
    return this;
  }

  SecurityOriginPatch withProtocol(String? value) {
    patchMap[SecurityOrigin$.protocol] = value;
    return this;
  }
}

/// Field descriptors for [SecurityOrigin] query construction
abstract final class SecurityOriginFields {
  static const host = Field<SecurityOrigin, String>('host', _$host);

  static const port = Field<SecurityOrigin, int>('port', _$port);

  static const protocol = Field<SecurityOrigin, String>('protocol', _$protocol);

  static String _$host(SecurityOrigin e) {
    return e.host;
  }

  static int _$port(SecurityOrigin e) {
    return e.port;
  }

  static String _$protocol(SecurityOrigin e) {
    return e.protocol;
  }
}

extension SecurityOriginCompareE on SecurityOrigin {
  Map<String, dynamic> compareToSecurityOrigin(SecurityOrigin other) {
    final Map<String, dynamic> diff = {};

    if (host != other.host) {
      diff['host'] = () => other.host;
    }

    if (port != other.port) {
      diff['port'] = () => other.port;
    }

    if (protocol != other.protocol) {
      diff['protocol'] = () => other.protocol;
    }
    return diff;
  }
}
