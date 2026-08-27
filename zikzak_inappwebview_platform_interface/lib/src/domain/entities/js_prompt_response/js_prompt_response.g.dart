// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_prompt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsPromptResponse _$JsPromptResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JsPromptResponse', json, ($checkedConvert) {
      final val = JsPromptResponse(
        message: $checkedConvert('message', (v) => v as String? ?? ''),
        defaultValue: $checkedConvert(
          'defaultValue',
          (v) => v as String? ?? '',
        ),
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
        value: $checkedConvert('value', (v) => v as String?),
        action: $checkedConvert(
          'action',
          (v) => v == null ? JsPromptResponseAction.CANCEL : _actionFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JsPromptResponseToJson(JsPromptResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'defaultValue': instance.defaultValue,
      'confirmButtonTitle': instance.confirmButtonTitle,
      'cancelButtonTitle': instance.cancelButtonTitle,
      'handledByClient': instance.handledByClient,
      'value': instance.value,
      'action': _actionToJson(instance.action),
    };
