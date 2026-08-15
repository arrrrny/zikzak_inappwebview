// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_confirm_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsConfirmResponse _$JsConfirmResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JsConfirmResponse', json, ($checkedConvert) {
      final val = JsConfirmResponse(
        message: $checkedConvert('message', (v) => v as String? ?? ''),
        confirmButtonTitle: $checkedConvert(
          'confirmButtonTitle',
          (v) => v as String? ?? '',
        ),
        cancelButtonTitle: $checkedConvert(
          'cancelButtonTitle',
          (v) => v as String? ?? '',
        ),
        handledByClient: $checkedConvert(
          'handledByClient',
          (v) => v as bool? ?? false,
        ),
        action: $checkedConvert(
          'action',
          (v) =>
              v == null ? JsConfirmResponseAction.CANCEL : _actionFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JsConfirmResponseToJson(JsConfirmResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'confirmButtonTitle': instance.confirmButtonTitle,
      'cancelButtonTitle': instance.cancelButtonTitle,
      'handledByClient': instance.handledByClient,
      'action': _actionToJson(instance.action),
    };
