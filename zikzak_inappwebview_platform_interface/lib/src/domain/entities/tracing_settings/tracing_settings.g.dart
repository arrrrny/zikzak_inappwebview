// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracing_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TracingSettings _$TracingSettingsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TracingSettings', json, ($checkedConvert) {
      final val = TracingSettings(
        categories: $checkedConvert(
          'categories',
          (v) => _deserializeCategories(v as List),
        ),
        tracingMode: $checkedConvert(
          'tracingMode',
          (v) => _tracingModeFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TracingSettingsToJson(TracingSettings instance) =>
    <String, dynamic>{
      'categories': _serializeCategories(instance.categories),
      'tracingMode': _tracingModeToJson(instance.tracingMode),
    };
