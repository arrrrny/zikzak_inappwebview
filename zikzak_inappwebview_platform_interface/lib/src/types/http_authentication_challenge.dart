import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import 'url_credential.dart';
import 'url_response.dart';
import 'url_authentication_challenge.dart';
import 'url_protection_space.dart';
import '../in_app_webview/platform_webview.dart';

part 'http_authentication_challenge.g.dart';

///Class that represents the challenge of the [PlatformWebViewCreationParams.onReceivedHttpAuthRequest] event.
///It provides all the information about the challenge.
@ExchangeableObject()
class HttpAuthenticationChallenge_ extends URLAuthenticationChallenge_ {
  ///A count of previous failed authentication attempts.
  int previousFailureCount;

  ///The proposed credential for this challenge.
  ///This method returns `null` if there is no default credential for this challenge.
  ///If you have previously attempted to authenticate and failed, this method returns the most recent failed credential.
  ///If the proposed credential is not nil and returns true when you call its hasPassword method, then the credential is ready to use as-is.
  ///If the proposed credential’s hasPassword method returns false, then the credential provides a default user name,
  ///and the client must prompt the user for a corresponding password.
  URLCredential_? proposedCredential;

  ///The URL response object representing the last authentication failure.
  ///This value is `null` if the protocol doesn’t use responses to indicate an authentication failure.
  ///
  ///**NOTE**: available only on iOS.
  URLResponse_? failureResponse;

  ///The error object representing the last authentication failure.
  ///This value is `null` if the protocol doesn’t use errors to indicate an authentication failure.
  ///
  ///**NOTE**: available only on iOS.
  String? error;

  HttpAuthenticationChallenge_({
    required this.previousFailureCount,
    required URLProtectionSpace_ protectionSpace,
    this.failureResponse,
    this.proposedCredential,
    this.error,
  }) : super(protectionSpace: protectionSpace);
}
