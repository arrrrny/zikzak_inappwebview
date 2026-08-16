// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favicon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favicon _$FaviconFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Favicon', json, ($checkedConvert) {
      final val = Favicon(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        rel: $checkedConvert('rel', (v) => v as String?),
        width: $checkedConvert('width', (v) => (v as num?)?.toInt()),
        height: $checkedConvert('height', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$FaviconToJson(Favicon instance) => <String, dynamic>{
  'url': _urlToJson(instance.url),
  'rel': instance.rel,
  'width': instance.width,
  'height': instance.height,
};
