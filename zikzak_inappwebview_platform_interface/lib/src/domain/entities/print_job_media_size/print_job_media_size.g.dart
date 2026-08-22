// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_media_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintJobMediaSize _$PrintJobMediaSizeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PrintJobMediaSize', json, ($checkedConvert) {
      final val = PrintJobMediaSize(
        id: $checkedConvert('id', (v) => v as String),
        widthMils: $checkedConvert('widthMils', (v) => (v as num).toInt()),
        heightMils: $checkedConvert('heightMils', (v) => (v as num).toInt()),
        label: $checkedConvert('label', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PrintJobMediaSizeToJson(PrintJobMediaSize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'widthMils': instance.widthMils,
      'heightMils': instance.heightMils,
      'label': instance.label,
    };
