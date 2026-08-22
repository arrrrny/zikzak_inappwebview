// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_trust_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerTrustAuthResponse _$ServerTrustAuthResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ServerTrustAuthResponse', json, ($checkedConvert) {
  final val = ServerTrustAuthResponse(
    action: $checkedConvert(
      'action',
      (v) =>
          v == null ? ServerTrustAuthResponseAction.CANCEL : _actionFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$ServerTrustAuthResponseToJson(
  ServerTrustAuthResponse instance,
) => <String, dynamic>{'action': _actionToJson(instance.action)};
