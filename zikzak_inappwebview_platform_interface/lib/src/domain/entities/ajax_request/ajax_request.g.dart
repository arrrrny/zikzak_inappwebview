// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ajax_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AjaxRequest _$AjaxRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AjaxRequest', json, ($checkedConvert) {
  final val = AjaxRequest(
    data: $checkedConvert('data', (v) => v),
    method: $checkedConvert('method', (v) => v as String?),
    url: $checkedConvert('url', (v) => _urlFromJson(v)),
    isAsync: $checkedConvert('isAsync', (v) => v as bool?),
    user: $checkedConvert('user', (v) => v as String?),
    password: $checkedConvert('password', (v) => v as String?),
    withCredentials: $checkedConvert('withCredentials', (v) => v as bool?),
    headers: $checkedConvert('headers', (v) => _headersFromJson(v)),
    readyState: $checkedConvert('readyState', (v) => _readyStateFromJson(v)),
    status: $checkedConvert('status', (v) => (v as num?)?.toInt()),
    responseURL: $checkedConvert('responseURL', (v) => _responseURLFromJson(v)),
    responseType: $checkedConvert('responseType', (v) => v as String?),
    response: $checkedConvert('response', (v) => v),
    responseText: $checkedConvert('responseText', (v) => v as String?),
    responseXML: $checkedConvert('responseXML', (v) => v as String?),
    statusText: $checkedConvert('statusText', (v) => v as String?),
    responseHeaders: $checkedConvert(
      'responseHeaders',
      (v) => _responseHeadersFromJson(v),
    ),
    event: $checkedConvert('event', (v) => _eventFromJson(v)),
    action: $checkedConvert(
      'action',
      (v) => v == null ? AjaxRequestAction.PROCEED : _actionFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$AjaxRequestToJson(AjaxRequest instance) =>
    <String, dynamic>{
      'data': instance.data,
      'method': instance.method,
      'url': _urlToJson(instance.url),
      'isAsync': instance.isAsync,
      'user': instance.user,
      'password': instance.password,
      'withCredentials': instance.withCredentials,
      'headers': _headersToJson(instance.headers),
      'readyState': _readyStateToJson(instance.readyState),
      'status': instance.status,
      'responseURL': _responseURLToJson(instance.responseURL),
      'responseType': instance.responseType,
      'response': instance.response,
      'responseText': instance.responseText,
      'responseXML': instance.responseXML,
      'statusText': instance.statusText,
      'responseHeaders': _responseHeadersToJson(instance.responseHeaders),
      'event': _eventToJson(instance.event),
      'action': _actionToJson(instance.action),
    };
