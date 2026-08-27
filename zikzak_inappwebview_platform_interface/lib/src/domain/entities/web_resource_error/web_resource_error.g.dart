// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_resource_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebResourceError _$WebResourceErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebResourceError', json, ($checkedConvert) {
      final val = WebResourceError(
        type: $checkedConvert('type', (v) => _typeFromJson(v)),
        description: $checkedConvert('description', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$WebResourceErrorToJson(WebResourceError instance) =>
    <String, dynamic>{
      'type': _typeToJson(instance.type),
      'description': instance.description,
    };
