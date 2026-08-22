// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_storage_origin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebStorageOrigin _$WebStorageOriginFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebStorageOrigin', json, ($checkedConvert) {
      final val = WebStorageOrigin(
        origin: $checkedConvert('origin', (v) => v as String?),
        quota: $checkedConvert('quota', (v) => (v as num?)?.toInt()),
        usage: $checkedConvert('usage', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$WebStorageOriginToJson(WebStorageOrigin instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'quota': instance.quota,
      'usage': instance.usage,
    };
