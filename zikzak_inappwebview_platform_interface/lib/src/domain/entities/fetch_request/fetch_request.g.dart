// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchRequest _$FetchRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FetchRequest', json, ($checkedConvert) {
      final val = FetchRequest(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        method: $checkedConvert('method', (v) => v as String?),
        headers: $checkedConvert('headers', (v) => _headersFromJson(v)),
        body: $checkedConvert('body', (v) => v),
        mode: $checkedConvert('mode', (v) => v as String?),
        credentials: $checkedConvert(
          'credentials',
          (v) => _credentialsFromJson(v),
        ),
        cache: $checkedConvert('cache', (v) => v as String?),
        redirect: $checkedConvert('redirect', (v) => v as String?),
        referrer: $checkedConvert('referrer', (v) => v as String?),
        referrerPolicy: $checkedConvert(
          'referrerPolicy',
          (v) => _referrerPolicyFromJson(v),
        ),
        integrity: $checkedConvert('integrity', (v) => v as String?),
        keepalive: $checkedConvert('keepalive', (v) => v as bool?),
        action: $checkedConvert(
          'action',
          (v) => v == null ? FetchRequestAction.PROCEED : _actionFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FetchRequestToJson(FetchRequest instance) =>
    <String, dynamic>{
      'url': _urlToJson(instance.url),
      'method': instance.method,
      'headers': _headersToJson(instance.headers),
      'body': instance.body,
      'mode': instance.mode,
      'credentials': _credentialsToJson(instance.credentials),
      'cache': instance.cache,
      'redirect': instance.redirect,
      'referrer': instance.referrer,
      'referrerPolicy': _referrerPolicyToJson(instance.referrerPolicy),
      'integrity': instance.integrity,
      'keepalive': instance.keepalive,
      'action': _actionToJson(instance.action),
    };
