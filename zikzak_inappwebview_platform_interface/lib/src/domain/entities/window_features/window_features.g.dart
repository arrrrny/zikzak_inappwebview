// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'window_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WindowFeatures _$WindowFeaturesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WindowFeatures', json, ($checkedConvert) {
      final val = WindowFeatures(
        allowsResizing: $checkedConvert('allowsResizing', (v) => v as bool?),
        height: $checkedConvert('height', (v) => (v as num?)?.toDouble()),
        menuBarVisibility: $checkedConvert(
          'menuBarVisibility',
          (v) => v as bool?,
        ),
        statusBarVisibility: $checkedConvert(
          'statusBarVisibility',
          (v) => v as bool?,
        ),
        toolbarsVisibility: $checkedConvert(
          'toolbarsVisibility',
          (v) => v as bool?,
        ),
        width: $checkedConvert('width', (v) => (v as num?)?.toDouble()),
        x: $checkedConvert('x', (v) => (v as num?)?.toDouble()),
        y: $checkedConvert('y', (v) => (v as num?)?.toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$WindowFeaturesToJson(WindowFeatures instance) =>
    <String, dynamic>{
      'allowsResizing': instance.allowsResizing,
      'height': instance.height,
      'menuBarVisibility': instance.menuBarVisibility,
      'statusBarVisibility': instance.statusBarVisibility,
      'toolbarsVisibility': instance.toolbarsVisibility,
      'width': instance.width,
      'x': instance.x,
      'y': instance.y,
    };
