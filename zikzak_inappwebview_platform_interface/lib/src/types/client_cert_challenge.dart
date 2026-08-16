// Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
// the URLAuthenticationChallenge hierarchy (this class EXTENDS the base)
// cannot be expressed as Zorphy value objects. Plain Dart class preserving
// the public is-a relationship and the flat wire format of the old codegen.

import '../domain/entities/url_protection_space/url_protection_space.dart';

import 'url_authentication_challenge.dart';

///Class that represents the challenge of the [PlatformWebViewCreationParams.onReceivedClientCertRequest] event.
///It provides all the information about the challenge.
class ClientCertChallenge extends URLAuthenticationChallenge {
  ///The acceptable certificate issuers for the certificate matching the private key.
  List<String>? principals;

  ///Returns the acceptable types of asymmetric keys.
  List<String>? keyTypes;

  ClientCertChallenge({
    required super.protectionSpace,
    this.principals,
    this.keyTypes,
  });

  ///Gets a possible [ClientCertChallenge] instance from a [Map] value.
  static ClientCertChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return ClientCertChallenge(
      protectionSpace: URLProtectionSpace.fromJson(
        (map['protectionSpace'] as Map).cast<String, dynamic>(),
      ),
      principals: map['principals']?.cast<String>(),
      keyTypes: map['keyTypes']?.cast<String>(),
    );
  }

  ///Converts instance to a map (flattened — the old codegen wire).
  @override
  Map<String, dynamic> toMap() {
    return {
      "protectionSpace": protectionSpace.toJson(),
      "principals": principals,
      "keyTypes": keyTypes,
    };
  }

  ///Gets a possible [ClientCertChallenge] instance from a [Map] value.
  static ClientCertChallenge? fromJson(Map<String, dynamic>? map) =>
      fromMap(map);

  ///Converts instance to a map.
  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
