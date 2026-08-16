// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_resource_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebResourceResponse _$WebResourceResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebResourceResponse', json, ($checkedConvert) {
      final val = WebResourceResponse(
        contentType: $checkedConvert('contentType', (v) => v as String? ?? ''),
        contentEncoding: $checkedConvert(
          'contentEncoding',
          (v) => v as String? ?? 'utf-8',
        ),
        data: $checkedConvert('data', (v) => _dataFromJson(v)),
        headers: $checkedConvert('headers', (v) => _headersFromJson(v)),
        statusCode: $checkedConvert('statusCode', (v) => (v as num?)?.toInt()),
        reasonPhrase: $checkedConvert('reasonPhrase', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$WebResourceResponseToJson(
  WebResourceResponse instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'contentEncoding': instance.contentEncoding,
  'data': _dataToJson(instance.data),
  'headers': _headersToJson(instance.headers),
  'statusCode': instance.statusCode,
  'reasonPhrase': instance.reasonPhrase,
};
