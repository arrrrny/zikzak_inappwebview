// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserScript _$UserScriptFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserScript', json, ($checkedConvert) {
      final val = UserScript(
        allowedOriginRules: $checkedConvert(
          'allowedOriginRules',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toSet() ?? {'*'},
        ),
        contentWorld: $checkedConvert(
          'contentWorld',
          (v) => _contentWorldFromJson(v),
        ),
        forMainFrameOnly: $checkedConvert(
          'forMainFrameOnly',
          (v) => v as bool? ?? true,
        ),
        groupName: $checkedConvert('groupName', (v) => v as String?),
        injectionTime: $checkedConvert(
          'injectionTime',
          (v) => _injectionTimeFromJson(v),
        ),
        source: $checkedConvert('source', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$UserScriptToJson(UserScript instance) =>
    <String, dynamic>{
      'allowedOriginRules': instance.allowedOriginRules.toList(),
      'contentWorld': _contentWorldToJson(instance.contentWorld),
      'forMainFrameOnly': instance.forMainFrameOnly,
      'groupName': instance.groupName,
      'injectionTime': _injectionTimeToJson(instance.injectionTime),
      'source': instance.source,
    };
