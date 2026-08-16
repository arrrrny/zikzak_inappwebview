// Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
// the URLAuthenticationChallenge hierarchy (this class EXTENDS the base)
// cannot be expressed as Zorphy value objects. Plain Dart class preserving
// the public is-a relationship and the flat wire format of the old codegen.

import '../domain/entities/url_credential/url_credential.dart';
import '../domain/entities/url_response/url_response.dart';
import '../domain/entities/url_protection_space/url_protection_space.dart';

import 'url_authentication_challenge.dart';

///Class that represents the challenge of the [PlatformWebViewCreationParams.onReceivedHttpAuthRequest] event.
///It provides all the information about the challenge.
class HttpAuthenticationChallenge extends URLAuthenticationChallenge {
  ///A count of previous failed authentication attempts.
  int previousFailureCount;

  ///The proposed credential for this challenge.
  ///This method returns `null` if there is no default credential for this challenge.
  ///If you have previously attempted to authenticate and failed, this method returns the most recent failed credential.
  ///If the proposed credential is not nil and returns true when you call its hasPassword method, then the credential is ready to use as-is.
  ///If the proposed credential’s hasPassword method returns false, then the credential provides a default user name,
  ///and the client must prompt the user for a corresponding password.
  URLCredential? proposedCredential;

  ///The URL response object representing the last authentication failure.
  ///This value is `null` if the protocol doesn’t use responses to indicate an authentication failure.
  ///
  ///**NOTE**: available only on iOS.
  URLResponse? failureResponse;

  ///The error object representing the last authentication failure.
  ///This value is `null` if the protocol doesn’t use errors to indicate an authentication failure.
  ///
  ///**NOTE**: available only on iOS.
  String? error;

  HttpAuthenticationChallenge({
    required super.protectionSpace,
    required this.previousFailureCount,
    this.proposedCredential,
    this.failureResponse,
    this.error,
  });

  ///Gets a possible [HttpAuthenticationChallenge] instance from a [Map] value.
  static HttpAuthenticationChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return HttpAuthenticationChallenge(
      protectionSpace: URLProtectionSpace.fromJson(
        (map['protectionSpace'] as Map).cast<String, dynamic>(),
      ),
      previousFailureCount: map['previousFailureCount'],
      proposedCredential: map['proposedCredential'] != null
          ? URLCredential.fromJson(
              (map['proposedCredential'] as Map).cast<String, dynamic>(),
            )
          : null,
      failureResponse: map['failureResponse'] != null
          ? URLResponse.fromJson(
              (map['failureResponse'] as Map).cast<String, dynamic>(),
            )
          : null,
      error: map['error'],
    );
  }

  ///Converts instance to a map (flattened — the old codegen wire).
  @override
  Map<String, dynamic> toMap() {
    return {
      "protectionSpace": protectionSpace.toJson(),
      "previousFailureCount": previousFailureCount,
      "proposedCredential": proposedCredential?.toJson(),
      "failureResponse": failureResponse?.toJson(),
      "error": error,
    };
  }

  ///Gets a possible [HttpAuthenticationChallenge] instance from a [Map] value.
  static HttpAuthenticationChallenge? fromJson(Map<String, dynamic>? map) =>
      fromMap(map);

  ///Converts instance to a map.
  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
