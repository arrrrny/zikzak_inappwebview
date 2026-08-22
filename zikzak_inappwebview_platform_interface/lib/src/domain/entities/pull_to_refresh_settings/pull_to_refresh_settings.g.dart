// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_to_refresh_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PullToRefreshSettings _$PullToRefreshSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PullToRefreshSettings', json, ($checkedConvert) {
  final val = PullToRefreshSettings(
    enabled: $checkedConvert('enabled', (v) => v as bool? ?? true),
    color: $checkedConvert('color', (v) => _colorFromJson(v)),
    backgroundColor: $checkedConvert(
      'backgroundColor',
      (v) => _colorFromJson(v),
    ),
    distanceToTriggerSync: $checkedConvert(
      'distanceToTriggerSync',
      (v) => (v as num?)?.toInt(),
    ),
    slingshotDistance: $checkedConvert(
      'slingshotDistance',
      (v) => (v as num?)?.toInt(),
    ),
    size: $checkedConvert('size', (v) => _sizeFromJson(v)),
    attributedTitle: $checkedConvert(
      'attributedTitle',
      (v) => _attributedTitleFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$PullToRefreshSettingsToJson(
  PullToRefreshSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'color': _colorToJson(instance.color),
  'backgroundColor': _colorToJson(instance.backgroundColor),
  'distanceToTriggerSync': instance.distanceToTriggerSync,
  'slingshotDistance': instance.slingshotDistance,
  'size': _sizeToJson(instance.size),
  'attributedTitle': _attributedTitleToJson(instance.attributedTitle),
};
