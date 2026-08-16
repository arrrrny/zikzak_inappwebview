// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionRequest _$PermissionRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PermissionRequest', json, ($checkedConvert) {
      final val = PermissionRequest(
        origin: $checkedConvert('origin', (v) => _originFromJson(v)),
        resources: $checkedConvert(
          'resources',
          (v) => v == null ? [] : _resourcesFromJson(v),
        ),
        frame: $checkedConvert('frame', (v) => _frameFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$PermissionRequestToJson(PermissionRequest instance) =>
    <String, dynamic>{
      'origin': _originToJson(instance.origin),
      'resources': _resourcesToJson(instance.resources),
      'frame': _frameToJson(instance.frame),
    };
