// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginRequest', json, ($checkedConvert) {
      final val = LoginRequest(
        realm: $checkedConvert('realm', (v) => v as String),
        account: $checkedConvert('account', (v) => v as String?),
        args: $checkedConvert('args', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'realm': instance.realm,
      'account': instance.account,
      'args': instance.args,
    };
