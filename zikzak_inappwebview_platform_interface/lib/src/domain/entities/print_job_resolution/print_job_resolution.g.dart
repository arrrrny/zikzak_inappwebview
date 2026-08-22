// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_resolution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintJobResolution _$PrintJobResolutionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PrintJobResolution', json, ($checkedConvert) {
      final val = PrintJobResolution(
        id: $checkedConvert('id', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        verticalDpi: $checkedConvert('verticalDpi', (v) => (v as num).toInt()),
        horizontalDpi: $checkedConvert(
          'horizontalDpi',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PrintJobResolutionToJson(PrintJobResolution instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'verticalDpi': instance.verticalDpi,
      'horizontalDpi': instance.horizontalDpi,
    };
