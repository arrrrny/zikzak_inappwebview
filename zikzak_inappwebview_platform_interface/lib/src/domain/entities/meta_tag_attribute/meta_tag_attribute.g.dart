// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_tag_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaTagAttribute _$MetaTagAttributeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MetaTagAttribute', json, ($checkedConvert) {
      final val = MetaTagAttribute(
        name: $checkedConvert('name', (v) => v as String?),
        value: $checkedConvert('value', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MetaTagAttributeToJson(MetaTagAttribute instance) =>
    <String, dynamic>{'name': instance.name, 'value': instance.value};
