// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_scheme_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomSchemeResponse _$CustomSchemeResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CustomSchemeResponse', json, ($checkedConvert) {
  final val = CustomSchemeResponse(
    data: $checkedConvert('data', (v) => _dataFromJson(v)),
    contentType: $checkedConvert('contentType', (v) => v as String),
    contentEncoding: $checkedConvert(
      'contentEncoding',
      (v) => v as String? ?? 'utf-8',
    ),
  );
  return val;
});

Map<String, dynamic> _$CustomSchemeResponseToJson(
  CustomSchemeResponse instance,
) => <String, dynamic>{
  'data': _dataToJson(instance.data),
  'contentType': instance.contentType,
  'contentEncoding': instance.contentEncoding,
};
