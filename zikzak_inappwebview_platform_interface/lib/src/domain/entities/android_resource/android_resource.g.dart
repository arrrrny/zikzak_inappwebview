// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AndroidResource _$AndroidResourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AndroidResource', json, ($checkedConvert) {
      final val = AndroidResource(
        name: $checkedConvert('name', (v) => v as String),
        defType: $checkedConvert('defType', (v) => v as String?),
        defPackage: $checkedConvert('defPackage', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AndroidResourceToJson(AndroidResource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'defType': instance.defType,
      'defPackage': instance.defPackage,
    };
