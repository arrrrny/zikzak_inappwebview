
import '../url_protection_space/url_protection_space.dart';


///Class that represents the constants describing known values of the [URLProtectionSpace.authenticationMethod] property.
enum URLProtectionSpaceAuthenticationMethod {
  ///Use client certificate authentication for this protection space.
  NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE,
  ///Negotiate whether to use Kerberos or NTLM authentication for this protection space.
  NSURL_AUTHENTICATION_METHOD_NEGOTIATE,
  ///Use NTLM authentication for this protection space.
  NSURL_AUTHENTICATION_METHOD_NTLM,
  ///Perform server trust authentication (certificate validation) for this protection space.
  NSURL_AUTHENTICATION_METHOD_SERVER_TRUST,
}
