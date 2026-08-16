// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_protection_space_http_auth_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

URLProtectionSpaceHttpAuthCredentials
_$URLProtectionSpaceHttpAuthCredentialsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('URLProtectionSpaceHttpAuthCredentials', json, (
      $checkedConvert,
    ) {
      final val = URLProtectionSpaceHttpAuthCredentials(
        protectionSpace: $checkedConvert(
          'protectionSpace',
          (v) => _protectionSpaceFromJson(v),
        ),
        credentials: $checkedConvert(
          'credentials',
          (v) => _credentialsFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$URLProtectionSpaceHttpAuthCredentialsToJson(
  URLProtectionSpaceHttpAuthCredentials instance,
) => <String, dynamic>{
  'protectionSpace': _protectionSpaceToJson(instance.protectionSpace),
  'credentials': _credentialsToJson(instance.credentials),
};
