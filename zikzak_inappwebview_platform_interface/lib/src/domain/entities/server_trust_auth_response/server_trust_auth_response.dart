// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: int-wire action enum glue + fork default.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../enums/server_trust_auth_response_action.dart';

part 'server_trust_auth_response.zorphy.dart';
part 'server_trust_auth_response.g.dart';

///Class that represents the response used by the [PlatformWebViewCreationParams.onReceivedServerTrustAuthRequest] event.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $ServerTrustAuthResponse {
  ///Indicate the [ServerTrustAuthResponseAction] to take in response of the server trust authentication challenge.
  @JsonKey(
    defaultValue: ServerTrustAuthResponseAction.CANCEL,
    fromJson: _actionFromJson,
    toJson: _actionToJson,
  )
  ServerTrustAuthResponseAction? get action;
}

ServerTrustAuthResponseAction? _actionFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ServerTrustAuthResponseAction.values.length
      ? ServerTrustAuthResponseAction.values[value]
      : null;
}

Object? _actionToJson(ServerTrustAuthResponseAction? action) => action?.index;
