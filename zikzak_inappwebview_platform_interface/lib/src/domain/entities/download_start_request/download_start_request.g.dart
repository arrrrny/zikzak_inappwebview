// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_start_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadStartRequest _$DownloadStartRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DownloadStartRequest', json, ($checkedConvert) {
  final val = DownloadStartRequest(
    url: $checkedConvert('url', (v) => _urlFromJson(v)),
    userAgent: $checkedConvert('userAgent', (v) => v as String?),
    contentDisposition: $checkedConvert(
      'contentDisposition',
      (v) => v as String?,
    ),
    mimeType: $checkedConvert('mimeType', (v) => v as String?),
    contentLength: $checkedConvert('contentLength', (v) => (v as num).toInt()),
    suggestedFilename: $checkedConvert(
      'suggestedFilename',
      (v) => v as String?,
    ),
    textEncodingName: $checkedConvert('textEncodingName', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DownloadStartRequestToJson(
  DownloadStartRequest instance,
) => <String, dynamic>{
  'url': _urlToJson(instance.url),
  'userAgent': instance.userAgent,
  'contentDisposition': instance.contentDisposition,
  'mimeType': instance.mimeType,
  'contentLength': instance.contentLength,
  'suggestedFilename': instance.suggestedFilename,
  'textEncodingName': instance.textEncodingName,
};
