// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_alert_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsAlertResponse _$JsAlertResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JsAlertResponse', json, ($checkedConvert) {
      final val = JsAlertResponse(
        message: $checkedConvert('message', (v) => v as String? ?? ''),
        confirmButtonTitle: $checkedConvert(
          'confirmButtonTitle',
          (v) => v as String? ?? '',
        ),
        handledByClient: $checkedConvert(
          'handledByClient',
          (v) => v as bool? ?? false,
        ),
        action: $checkedConvert(
          'action',
          (v) => v == null ? JsAlertResponseAction.CONFIRM : _actionFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JsAlertResponseToJson(JsAlertResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'confirmButtonTitle': instance.confirmButtonTitle,
      'handledByClient': instance.handledByClient,
      'action': _actionToJson(instance.action),
    };
