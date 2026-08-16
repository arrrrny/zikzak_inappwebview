import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'login_request.zorphy.dart';
part 'login_request.g.dart';

///Class used by [PlatformWebViewCreationParams.onReceivedLoginRequest] event.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $LoginRequest {
  ///The account realm used to look up accounts.
  String get realm;

  ///An optional account. If not `null`, the account should be checked against accounts on the device.
  ///If it is a valid account, it should be used to log in the user. This value may be `null`.
  String? get account;

  ///Authenticator specific arguments used to log in the user.
  String get args;
}
