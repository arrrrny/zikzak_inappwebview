// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIImage _$UIImageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UIImage', json, ($checkedConvert) {
      final val = UIImage(
        name: $checkedConvert('name', (v) => v as String?),
        systemName: $checkedConvert('systemName', (v) => v as String?),
        data: $checkedConvert('data', (v) => _dataFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$UIImageToJson(UIImage instance) => <String, dynamic>{
  'name': instance.name,
  'systemName': instance.systemName,
  'data': _dataToJson(instance.data),
};
