// Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
// the URLAuthenticationChallenge hierarchy (this class EXTENDS the base)
// cannot be expressed as Zorphy value objects. Plain Dart class preserving
// the public is-a relationship and the flat wire format of the old codegen.

import '../domain/entities/url_protection_space/url_protection_space.dart';

import 'url_authentication_challenge.dart';

///Class that represents the challenge of the [PlatformWebViewCreationParams.onReceivedServerTrustAuthRequest] event.
///It provides all the information about the challenge.
class ServerTrustChallenge extends URLAuthenticationChallenge {
  ServerTrustChallenge({required super.protectionSpace});

  ///Gets a possible [ServerTrustChallenge] instance from a [Map] value.
  static ServerTrustChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return ServerTrustChallenge(
      protectionSpace: URLProtectionSpace.fromJson(
        (map['protectionSpace'] as Map).cast<String, dynamic>(),
      ),
    );
  }

  ///Converts instance to a map.
  @override
  Map<String, dynamic> toMap() {
    return {"protectionSpace": protectionSpace.toJson()};
  }

  ///Gets a possible [ServerTrustChallenge] instance from a [Map] value.
  static ServerTrustChallenge? fromJson(Map<String, dynamic>? map) =>
      fromMap(map);

  ///Converts instance to a map.
  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
