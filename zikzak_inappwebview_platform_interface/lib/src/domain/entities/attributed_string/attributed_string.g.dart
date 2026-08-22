// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributed_string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributedString _$AttributedStringFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AttributedString', json, ($checkedConvert) {
  final val = AttributedString(
    string: $checkedConvert('string', (v) => v as String),
    backgroundColor: $checkedConvert(
      'backgroundColor',
      (v) => _backgroundColorFromJson(v),
    ),
    baselineOffset: $checkedConvert(
      'baselineOffset',
      (v) => (v as num?)?.toDouble(),
    ),
    expansion: $checkedConvert('expansion', (v) => (v as num?)?.toDouble()),
    foregroundColor: $checkedConvert(
      'foregroundColor',
      (v) => _foregroundColorFromJson(v),
    ),
    kern: $checkedConvert('kern', (v) => (v as num?)?.toDouble()),
    ligature: $checkedConvert('ligature', (v) => (v as num?)?.toInt()),
    obliqueness: $checkedConvert('obliqueness', (v) => (v as num?)?.toDouble()),
    strikethroughColor: $checkedConvert(
      'strikethroughColor',
      (v) => _strikethroughColorFromJson(v),
    ),
    strikethroughStyle: $checkedConvert(
      'strikethroughStyle',
      (v) => _strikethroughStyleFromJson(v),
    ),
    strokeColor: $checkedConvert('strokeColor', (v) => _strokeColorFromJson(v)),
    strokeWidth: $checkedConvert('strokeWidth', (v) => (v as num?)?.toDouble()),
    textEffect: $checkedConvert(
      'textEffect',
      (v) => $enumDecodeNullable(_$AttributedStringTextEffectStyleEnumMap, v),
    ),
    underlineColor: $checkedConvert(
      'underlineColor',
      (v) => _underlineColorFromJson(v),
    ),
    underlineStyle: $checkedConvert(
      'underlineStyle',
      (v) => $enumDecodeNullable(_$UnderlineStyleEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$AttributedStringToJson(
  AttributedString instance,
) => <String, dynamic>{
  'string': instance.string,
  'backgroundColor': _backgroundColorToJson(instance.backgroundColor),
  'baselineOffset': instance.baselineOffset,
  'expansion': instance.expansion,
  'foregroundColor': _foregroundColorToJson(instance.foregroundColor),
  'kern': instance.kern,
  'ligature': instance.ligature,
  'obliqueness': instance.obliqueness,
  'strikethroughColor': _strikethroughColorToJson(instance.strikethroughColor),
  'strikethroughStyle': _strikethroughStyleToJson(instance.strikethroughStyle),
  'strokeColor': _strokeColorToJson(instance.strokeColor),
  'strokeWidth': instance.strokeWidth,
  'textEffect': _$AttributedStringTextEffectStyleEnumMap[instance.textEffect],
  'underlineColor': _underlineColorToJson(instance.underlineColor),
  'underlineStyle': _$UnderlineStyleEnumMap[instance.underlineStyle],
};

const _$AttributedStringTextEffectStyleEnumMap = {
  AttributedStringTextEffectStyle.LETTERPRESS_STYLE: 'LETTERPRESS_STYLE',
};

const _$UnderlineStyleEnumMap = {
  UnderlineStyle.STYLE_NONE: 'STYLE_NONE',
  UnderlineStyle.SINGLE: 'SINGLE',
  UnderlineStyle.THICK: 'THICK',
  UnderlineStyle.DOUBLE: 'DOUBLE',
  UnderlineStyle.PATTERN_DOT: 'PATTERN_DOT',
  UnderlineStyle.PATTERN_DASH: 'PATTERN_DASH',
  UnderlineStyle.PATTERN_DASH_DOT: 'PATTERN_DASH_DOT',
  UnderlineStyle.PATTERN_DASH_DOT_DOT: 'PATTERN_DASH_DOT_DOT',
  UnderlineStyle.BY_WORD: 'BY_WORD',
};
