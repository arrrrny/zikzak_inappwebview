// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_confirm_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsConfirmRequest _$JsConfirmRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JsConfirmRequest', json, ($checkedConvert) {
      final val = JsConfirmRequest(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        message: $checkedConvert('message', (v) => v as String?),
        isMainFrame: $checkedConvert('isMainFrame', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$JsConfirmRequestToJson(JsConfirmRequest instance) =>
    <String, dynamic>{
      'url': _urlToJson(instance.url),
      'message': instance.message,
      'isMainFrame': instance.isMainFrame,
    };
