// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the custom @ExchangeableObjectProperty
// deserializer as manual): X509Certificate data deserializer + int-wire
// persistence glue replicate the old wire.

import 'dart:typed_data';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../x509_certificate/x509_certificate.dart';
import '../enums/url_credential_persistence.dart';

part 'url_credential.zorphy.dart';
part 'url_credential.g.dart';

///Class that represents a server or client credential.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $URLCredential {
  ///The credential’s user name.
  String? get username;

  ///The credential’s password.
  String? get password;

  ///The intermediate certificates of the credential, if it is a client certificate credential.
  @JsonKey(fromJson: _certificatesFromJson, toJson: _certificatesToJson)
  List<X509Certificate>? get certificates;

  ///The credential’s persistence setting.
  @JsonKey(fromJson: _persistenceFromJson, toJson: _persistenceToJson)
  URLCredentialPersistence? get persistence;
}

List<X509Certificate>? _certificatesFromJson(Object? value) {
  if (value is! List) return null;
  final certificates = <X509Certificate>[];
  for (final data in value) {
    try {
      certificates.add(X509Certificate.fromData(data: data as Uint8List));
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }
  return certificates;
}

Object? _certificatesToJson(List<X509Certificate>? certificates) =>
    certificates?.map((e) => e.toMap()).toList();

URLCredentialPersistence? _persistenceFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < URLCredentialPersistence.values.length
      ? URLCredentialPersistence.values[value]
      : null;
}

Object? _persistenceToJson(URLCredentialPersistence? persistence) =>
    persistence?.index;
