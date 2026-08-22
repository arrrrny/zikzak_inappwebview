// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaTag _$MetaTagFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MetaTag', json, ($checkedConvert) {
      final val = MetaTag(
        name: $checkedConvert('name', (v) => v as String?),
        content: $checkedConvert('content', (v) => v as String?),
        attrs: $checkedConvert(
          'attrs',
          (v) => (v as List<dynamic>?)
              ?.map((e) => MetaTagAttribute.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MetaTagToJson(MetaTag instance) => <String, dynamic>{
  'name': instance.name,
  'content': instance.content,
  'attrs': instance.attrs?.map((e) => e.toJson()).toList(),
};
