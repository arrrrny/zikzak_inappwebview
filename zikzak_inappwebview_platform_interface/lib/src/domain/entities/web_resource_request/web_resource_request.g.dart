// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_resource_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebResourceRequest _$WebResourceRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebResourceRequest', json, ($checkedConvert) {
      final val = WebResourceRequest(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        headers: $checkedConvert('headers', (v) => _headersFromJson(v)),
        method: $checkedConvert('method', (v) => v as String?),
        hasGesture: $checkedConvert('hasGesture', (v) => v as bool?),
        isForMainFrame: $checkedConvert('isForMainFrame', (v) => v as bool?),
        isRedirect: $checkedConvert('isRedirect', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$WebResourceRequestToJson(WebResourceRequest instance) =>
    <String, dynamic>{
      'url': _urlToJson(instance.url),
      'headers': _headersToJson(instance.headers),
      'method': instance.method,
      'hasGesture': instance.hasGesture,
      'isForMainFrame': instance.isForMainFrame,
      'isRedirect': instance.isRedirect,
    };
