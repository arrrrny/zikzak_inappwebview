// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_prompt_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsPromptRequest _$JsPromptRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JsPromptRequest', json, ($checkedConvert) {
      final val = JsPromptRequest(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        message: $checkedConvert('message', (v) => v as String?),
        defaultValue: $checkedConvert('defaultValue', (v) => v as String?),
        isMainFrame: $checkedConvert('isMainFrame', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$JsPromptRequestToJson(JsPromptRequest instance) =>
    <String, dynamic>{
      'url': _urlToJson(instance.url),
      'message': instance.message,
      'defaultValue': instance.defaultValue,
      'isMainFrame': instance.isMainFrame,
    };
