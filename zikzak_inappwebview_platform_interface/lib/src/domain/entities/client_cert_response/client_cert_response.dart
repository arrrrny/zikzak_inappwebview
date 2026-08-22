// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the custom @ExchangeableObjectConstructor as
// manual): fork constructor defaults are preserved via @JsonKey
// defaultValue; the constructor asserts (dev-time validation only) are
// dropped.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../enums/client_cert_response_action.dart';

part 'client_cert_response.zorphy.dart';
part 'client_cert_response.g.dart';

///Class that represents the response used by the [PlatformWebViewCreationParams.onReceivedClientCertRequest] event.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $ClientCertResponse {
  ///The file path of the certificate to use.
  String get certificatePath;

  ///The certificate password.
  @JsonKey(defaultValue: "")
  String? get certificatePassword;

  ///An Android-specific property used by Java [KeyStore](https://developer.android.com/reference/java/security/KeyStore) class to get the instance.
  @JsonKey(defaultValue: "PKCS12")
  String? get keyStoreType;

  ///Indicate the [ClientCertResponseAction] to take in response of the client certificate challenge.
  @JsonKey(
    defaultValue: ClientCertResponseAction.CANCEL,
    fromJson: _actionFromJson,
    toJson: _actionToJson,
  )
  ClientCertResponseAction? get action;
}

ClientCertResponseAction? _actionFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ClientCertResponseAction.values.length
      ? ClientCertResponseAction.values[value]
      : null;
}

Object? _actionToJson(ClientCertResponseAction? action) => action?.index;
