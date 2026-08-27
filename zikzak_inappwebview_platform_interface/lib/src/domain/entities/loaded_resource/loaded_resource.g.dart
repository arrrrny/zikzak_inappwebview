// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loaded_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadedResource _$LoadedResourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoadedResource', json, ($checkedConvert) {
      final val = LoadedResource(
        initiatorType: $checkedConvert('initiatorType', (v) => v as String?),
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        startTime: $checkedConvert('startTime', (v) => (v as num?)?.toDouble()),
        duration: $checkedConvert('duration', (v) => (v as num?)?.toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$LoadedResourceToJson(LoadedResource instance) =>
    <String, dynamic>{
      'initiatorType': instance.initiatorType,
      'url': _urlToJson(instance.url),
      'startTime': instance.startTime,
      'duration': instance.duration,
    };
