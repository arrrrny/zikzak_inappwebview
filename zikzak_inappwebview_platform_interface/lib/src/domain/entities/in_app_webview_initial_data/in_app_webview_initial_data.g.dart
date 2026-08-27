// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_webview_initial_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppWebViewInitialData _$InAppWebViewInitialDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InAppWebViewInitialData', json, ($checkedConvert) {
  final val = InAppWebViewInitialData(
    data: $checkedConvert('data', (v) => v as String),
    mimeType: $checkedConvert('mimeType', (v) => v as String? ?? 'text/html'),
    encoding: $checkedConvert('encoding', (v) => v as String? ?? 'utf8'),
    baseUrl: $checkedConvert('baseUrl', (v) => _baseUrlFromJson(v)),
    historyUrl: $checkedConvert('historyUrl', (v) => _historyUrlFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$InAppWebViewInitialDataToJson(
  InAppWebViewInitialData instance,
) => <String, dynamic>{
  'data': instance.data,
  'mimeType': instance.mimeType,
  'encoding': instance.encoding,
  'baseUrl': _baseUrlToJson(instance.baseUrl),
  'historyUrl': _historyUrlToJson(instance.historyUrl),
};
