// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

URLResponse _$URLResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('URLResponse', json, ($checkedConvert) {
      final val = URLResponse(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        expectedContentLength: $checkedConvert(
          'expectedContentLength',
          (v) => (v as num).toInt(),
        ),
        mimeType: $checkedConvert('mimeType', (v) => v as String?),
        suggestedFilename: $checkedConvert(
          'suggestedFilename',
          (v) => v as String?,
        ),
        textEncodingName: $checkedConvert(
          'textEncodingName',
          (v) => v as String?,
        ),
        headers: $checkedConvert('headers', (v) => _headersFromJson(v)),
        statusCode: $checkedConvert('statusCode', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$URLResponseToJson(URLResponse instance) =>
    <String, dynamic>{
      'url': _urlToJson(instance.url),
      'expectedContentLength': instance.expectedContentLength,
      'mimeType': instance.mimeType,
      'suggestedFilename': instance.suggestedFilename,
      'textEncodingName': instance.textEncodingName,
      'headers': _headersToJson(instance.headers),
      'statusCode': instance.statusCode,
    };
