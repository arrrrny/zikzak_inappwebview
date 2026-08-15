// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocation_permission_show_prompt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeolocationPermissionShowPromptResponse
_$GeolocationPermissionShowPromptResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GeolocationPermissionShowPromptResponse', json, (
      $checkedConvert,
    ) {
      final val = GeolocationPermissionShowPromptResponse(
        origin: $checkedConvert('origin', (v) => _originFromJson(v)),
        allow: $checkedConvert('allow', (v) => v as bool?),
        retain: $checkedConvert('retain', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$GeolocationPermissionShowPromptResponseToJson(
  GeolocationPermissionShowPromptResponse instance,
) => <String, dynamic>{
  'origin': _originToJson(instance.origin),
  'allow': instance.allow,
  'retain': instance.retain,
};
