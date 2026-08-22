// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: int-wire action enum glue + fork defaults.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../enums/http_auth_response_action.dart';

part 'http_auth_response.zorphy.dart';
part 'http_auth_response.g.dart';

///Class that represents the response used by the [PlatformWebViewCreationParams.onReceivedHttpAuthRequest] event.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $HttpAuthResponse {
  ///Represents the username used for the authentication if the [action] corresponds to [HttpAuthResponseAction.PROCEED]
  @JsonKey(defaultValue: "")
  String get username;

  ///Represents the password used for the authentication if the [action] corresponds to [HttpAuthResponseAction.PROCEED]
  @JsonKey(defaultValue: "")
  String get password;

  ///Indicate if the given credentials need to be saved permanently.
  @JsonKey(defaultValue: false)
  bool get permanentPersistence;

  ///Indicate the [HttpAuthResponseAction] to take in response of the authentication challenge.
  @JsonKey(
    defaultValue: HttpAuthResponseAction.CANCEL,
    fromJson: _actionFromJson,
    toJson: _actionToJson,
  )
  HttpAuthResponseAction? get action;
}

HttpAuthResponseAction? _actionFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < HttpAuthResponseAction.values.length
      ? HttpAuthResponseAction.values[value]
      : null;
}

Object? _actionToJson(HttpAuthResponseAction? action) => action?.index;
