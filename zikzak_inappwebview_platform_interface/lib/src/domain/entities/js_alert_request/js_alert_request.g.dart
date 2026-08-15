// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_alert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsAlertRequest _$JsAlertRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JsAlertRequest', json, ($checkedConvert) {
      final val = JsAlertRequest(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        message: $checkedConvert('message', (v) => v as String?),
        isMainFrame: $checkedConvert('isMainFrame', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$JsAlertRequestToJson(JsAlertRequest instance) =>
    <String, dynamic>{
      'url': _urlToJson(instance.url),
      'message': instance.message,
      'isMainFrame': instance.isMainFrame,
    };
