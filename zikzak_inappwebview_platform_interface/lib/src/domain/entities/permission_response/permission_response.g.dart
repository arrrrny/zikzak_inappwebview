// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionResponse _$PermissionResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PermissionResponse', json, ($checkedConvert) {
      final val = PermissionResponse(
        resources: $checkedConvert(
          'resources',
          (v) => v == null ? [] : _resourcesFromJson(v),
        ),
        action: $checkedConvert(
          'action',
          (v) => v == null ? PermissionResponseAction.DENY : _actionFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PermissionResponseToJson(PermissionResponse instance) =>
    <String, dynamic>{
      'resources': _resourcesToJson(instance.resources),
      'action': _actionToJson(instance.action),
    };
