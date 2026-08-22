// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: sibling-entity (URLProtectionSpace + URLCredential
// list) wire glue.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../url_protection_space/url_protection_space.dart';
import '../url_credential/url_credential.dart';
import '../../../platform_http_auth_credentials_database.dart';

part 'url_protection_space_http_auth_credentials.zorphy.dart';
part 'url_protection_space_http_auth_credentials.g.dart';

///Class that represents a [URLProtectionSpace] with all of its [URLCredential]s.
///It used by [PlatformHttpAuthCredentialDatabase.getAllAuthCredentials].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $URLProtectionSpaceHttpAuthCredentials {
  ///The protection space.
  @JsonKey(fromJson: _protectionSpaceFromJson, toJson: _protectionSpaceToJson)
  URLProtectionSpace? get protectionSpace;

  ///The list of all its http authentication credentials.
  @JsonKey(fromJson: _credentialsFromJson, toJson: _credentialsToJson)
  List<URLCredential>? get credentials;
}

URLProtectionSpace? _protectionSpaceFromJson(Object? value) => value == null
    ? null
    : URLProtectionSpace.fromJson((value as Map).cast<String, dynamic>());

Object? _protectionSpaceToJson(URLProtectionSpace? protectionSpace) =>
    protectionSpace?.toJson();

List<URLCredential>? _credentialsFromJson(Object? value) {
  if (value is! List) return null;
  return value
      .map((e) => URLCredential.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

Object? _credentialsToJson(List<URLCredential>? credentials) =>
    credentials?.map((e) => e.toJson()).toList();
