// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_origin.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///An object that identifies the origin of a particular resource.
class SecurityOrigin {
  ///The security origin’s host.
  String host;

  ///The security origin's port.
  int port;

  ///The security origin's protocol.
  String protocol;
  SecurityOrigin(
      {required this.host, required this.port, required this.protocol});

  ///Gets a possible [SecurityOrigin] instance from a [Map] value.
  static SecurityOrigin? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = SecurityOrigin(
      host: map['host'],
      port: map['port'],
      protocol: map['protocol'],
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "host": host,
      "port": port,
      "protocol": protocol,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'SecurityOrigin{host: $host, port: $port, protocol: $protocol}';
  }
}
