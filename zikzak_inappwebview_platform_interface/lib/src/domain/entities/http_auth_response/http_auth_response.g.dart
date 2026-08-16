// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpAuthResponse _$HttpAuthResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HttpAuthResponse', json, ($checkedConvert) {
      final val = HttpAuthResponse(
        username: $checkedConvert('username', (v) => v as String? ?? ''),
        password: $checkedConvert('password', (v) => v as String? ?? ''),
        permanentPersistence: $checkedConvert(
          'permanentPersistence',
          (v) => v as bool? ?? false,
        ),
        action: $checkedConvert(
          'action',
          (v) => v == null ? HttpAuthResponseAction.CANCEL : _actionFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HttpAuthResponseToJson(HttpAuthResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'permanentPersistence': instance.permanentPersistence,
      'action': _actionToJson(instance.action),
    };
