// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'css_link_html_tag_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CSSLinkHtmlTagAttributes _$CSSLinkHtmlTagAttributesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CSSLinkHtmlTagAttributes', json, ($checkedConvert) {
  final val = CSSLinkHtmlTagAttributes(
    id: $checkedConvert('id', (v) => v as String?),
    media: $checkedConvert('media', (v) => v as String?),
    crossOrigin: $checkedConvert('crossOrigin', (v) => _crossOriginFromJson(v)),
    integrity: $checkedConvert('integrity', (v) => v as String?),
    referrerPolicy: $checkedConvert(
      'referrerPolicy',
      (v) => _referrerPolicyFromJson(v),
    ),
    disabled: $checkedConvert('disabled', (v) => v as bool?),
    alternate: $checkedConvert('alternate', (v) => v as bool?),
    title: $checkedConvert('title', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$CSSLinkHtmlTagAttributesToJson(
  CSSLinkHtmlTagAttributes instance,
) => <String, dynamic>{
  'id': instance.id,
  'media': instance.media,
  'crossOrigin': _crossOriginToJson(instance.crossOrigin),
  'integrity': instance.integrity,
  'referrerPolicy': _referrerPolicyToJson(instance.referrerPolicy),
  'disabled': instance.disabled,
  'alternate': instance.alternate,
  'title': instance.title,
};
