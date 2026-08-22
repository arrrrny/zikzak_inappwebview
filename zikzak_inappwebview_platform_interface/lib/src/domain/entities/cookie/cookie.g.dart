// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cookie _$CookieFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Cookie',
  json,
  ($checkedConvert) {
    final val = Cookie(
      name: $checkedConvert('name', (v) => v as String),
      value: $checkedConvert('value', (v) => v),
      expiresDate: $checkedConvert('expiresDate', (v) => (v as num?)?.toInt()),
      isSessionOnly: $checkedConvert('isSessionOnly', (v) => v as bool?),
      domain: $checkedConvert('domain', (v) => v as String?),
      sameSite: $checkedConvert('sameSite', (v) => _sameSiteFromJson(v)),
      isSecure: $checkedConvert('isSecure', (v) => v as bool?),
      isHttpOnly: $checkedConvert('isHttpOnly', (v) => v as bool?),
      path: $checkedConvert('path', (v) => v as String?),
    );
    return val;
  },
);

Map<String, dynamic> _$CookieToJson(Cookie instance) => <String, dynamic>{
  'name': instance.name,
  'value': instance.value,
  'expiresDate': instance.expiresDate,
  'isSessionOnly': instance.isSessionOnly,
  'domain': instance.domain,
  'sameSite': _sameSiteToJson(instance.sameSite),
  'isSecure': instance.isSecure,
  'isHttpOnly': instance.isHttpOnly,
  'path': instance.path,
};
