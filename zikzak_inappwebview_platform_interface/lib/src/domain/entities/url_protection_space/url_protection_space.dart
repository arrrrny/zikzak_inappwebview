// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the custom @ExchangeableObjectProperty
// deserializer + SslCertificate reference as manual): X509Certificate data
// deserializer, string-wire enum lookups, and the hand-written SslCertificate
// glue replicate the old wire.

import 'dart:typed_data';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../x509_certificate/x509_certificate.dart';
import '../enums/url_protection_space_proxy_type.dart';
import '../enums/url_protection_space_authentication_method.dart';
import '../ssl_error/ssl_error.dart';
import '../ssl_certificate/ssl_certificate.dart';

part 'url_protection_space.zorphy.dart';
part 'url_protection_space.g.dart';

///Class that represents the physical properties of a server.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $URLProtectionSpace {
  ///The hostname of the server.
  String get host;

  ///The protocol of the server - e.g. "http", "ftp", "https".
  String? get protocol;

  ///A string indicating a protocol-specific subdivision of a single host.
  ///For http and https, this maps to the realm string in http authentication challenges.
  ///For many other protocols it is unused.
  String? get realm;

  ///The port of the server.
  int? get port;

  ///The SSL certificate used.
  @JsonKey(fromJson: _sslCertificateFromJson, toJson: _sslCertificateToJson)
  SslCertificate? get sslCertificate;

  ///The SSL Error associated.
  @JsonKey(fromJson: _sslErrorFromJson, toJson: _sslErrorToJson)
  SslError? get sslError;

  ///The authentication method used by the receiver.
  @JsonKey(
    fromJson: _authenticationMethodFromJson,
    toJson: _authenticationMethodToJson,
  )
  URLProtectionSpaceAuthenticationMethod? get authenticationMethod;

  ///The acceptable certificate-issuing authorities for client certificate authentication.
  ///This value is `null` if the authentication method of the protection space is not client certificate.
  ///The returned issuing authorities are encoded with Distinguished Encoding Rules (DER).
  @JsonKey(
    fromJson: _distinguishedNamesFromJson,
    toJson: _distinguishedNamesToJson,
  )
  List<X509Certificate>? get distinguishedNames;

  ///The proxy type of this protection space.
  @JsonKey(fromJson: _proxyTypeFromJson, toJson: _proxyTypeToJson)
  URLProtectionSpaceProxyType? get proxyType;

  ///A Boolean value indicating whether the credentials must be sent securely.
  bool? get receivesCredentialSecurely;
}

SslCertificate? _sslCertificateFromJson(Object? value) => value == null
    ? null
    : SslCertificate.fromMap((value as Map).cast<String, dynamic>());

Object? _sslCertificateToJson(SslCertificate? certificate) =>
    certificate?.toMap();

SslError? _sslErrorFromJson(Object? value) => value == null
    ? null
    : SslError.fromJson((value as Map).cast<String, dynamic>());

Object? _sslErrorToJson(SslError? error) => error?.toJson();

///URLProtectionSpaceAuthenticationMethod wire values are the NSURL strings
///(the old `_value`), which differ from the member names — lookup by value.
const _authenticationMethodWire =
    <String, URLProtectionSpaceAuthenticationMethod>{
      'NSURLAuthenticationMethodClientCertificate':
          URLProtectionSpaceAuthenticationMethod
              .NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE,
      'NSURLAuthenticationMethodNegotiate':
          URLProtectionSpaceAuthenticationMethod
              .NSURL_AUTHENTICATION_METHOD_NEGOTIATE,
      'NSURLAuthenticationMethodNTLM': URLProtectionSpaceAuthenticationMethod
          .NSURL_AUTHENTICATION_METHOD_NTLM,
      'NSURLAuthenticationMethodServerTrust':
          URLProtectionSpaceAuthenticationMethod
              .NSURL_AUTHENTICATION_METHOD_SERVER_TRUST,
    };

URLProtectionSpaceAuthenticationMethod? _authenticationMethodFromJson(
  Object? value,
) => value is String ? _authenticationMethodWire[value] : null;

Object? _authenticationMethodToJson(
  URLProtectionSpaceAuthenticationMethod? authenticationMethod,
) {
  if (authenticationMethod == null) return null;
  for (final entry in _authenticationMethodWire.entries) {
    if (entry.value == authenticationMethod) return entry.key;
  }
  return null;
}

List<X509Certificate>? _distinguishedNamesFromJson(Object? value) {
  if (value is! List) return null;
  final distinguishedNames = <X509Certificate>[];
  for (final data in value) {
    try {
      distinguishedNames.add(X509Certificate.fromData(data: data as Uint8List));
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }
  return distinguishedNames;
}

Object? _distinguishedNamesToJson(List<X509Certificate>? distinguishedNames) =>
    distinguishedNames?.map((e) => e.toMap()).toList();

///URLProtectionSpaceProxyType wire values are the NSURL strings (the old
///`_nativeValue`), which differ from the member names — lookup by value.
const _proxyTypeWire = <String, URLProtectionSpaceProxyType>{
  'NSURLProtectionSpaceHTTPProxy':
      URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTP_PROXY,
  'NSURLProtectionSpaceHTTPSProxy':
      URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTPS_PROXY,
  'NSURLProtectionSpaceFTPProxy':
      URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_FTP_PROXY,
  'NSURLProtectionSpaceSOCKSProxy':
      URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_SOCKS_PROXY,
};

URLProtectionSpaceProxyType? _proxyTypeFromJson(Object? value) =>
    value is String ? _proxyTypeWire[value] : null;

Object? _proxyTypeToJson(URLProtectionSpaceProxyType? proxyType) {
  if (proxyType == null) return null;
  for (final entry in _proxyTypeWire.entries) {
    if (entry.value == proxyType) return entry.key;
  }
  return null;
}
