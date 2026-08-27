// Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
// the URLAuthenticationChallenge hierarchy (HttpAuthenticationChallenge /
// ClientCertChallenge / ServerTrustChallenge EXTENDS this base) cannot be
// expressed as Zorphy value objects. Plain Dart classes preserve the public
// is-a relationship and the flat wire format of the old codegen.

import '../domain/entities/url_protection_space/url_protection_space.dart';

///Class that represents a challenge from a server requiring authentication from the client.
///It provides all the information about the challenge.
class URLAuthenticationChallenge {
  ///The protection space requiring authentication.
  URLProtectionSpace protectionSpace;

  URLAuthenticationChallenge({required this.protectionSpace});

  ///Gets a possible [URLAuthenticationChallenge] instance from a [Map] value.
  static URLAuthenticationChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return URLAuthenticationChallenge(
      protectionSpace: URLProtectionSpace.fromJson(
        (map['protectionSpace'] as Map).cast<String, dynamic>(),
      ),
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"protectionSpace": protectionSpace.toJson()};
  }

  ///Gets a possible [URLAuthenticationChallenge] instance from a [Map] value.
  static URLAuthenticationChallenge? fromJson(Map<String, dynamic>? map) =>
      fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
