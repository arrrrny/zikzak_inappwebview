// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_before_unload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsBeforeUnloadRequest _$JsBeforeUnloadRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('JsBeforeUnloadRequest', json, ($checkedConvert) {
  final val = JsBeforeUnloadRequest(
    url: $checkedConvert('url', (v) => _urlFromJson(v)),
    message: $checkedConvert('message', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$JsBeforeUnloadRequestToJson(
  JsBeforeUnloadRequest instance,
) => <String, dynamic>{
  'url': _urlToJson(instance.url),
  'message': instance.message,
};
