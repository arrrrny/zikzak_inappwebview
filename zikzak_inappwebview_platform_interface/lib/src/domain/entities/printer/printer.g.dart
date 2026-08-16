// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Printer _$PrinterFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Printer', json, ($checkedConvert) {
      final val = Printer(
        id: $checkedConvert('id', (v) => v as String?),
        type: $checkedConvert('type', (v) => v as String?),
        languageLevel: $checkedConvert(
          'languageLevel',
          (v) => (v as num?)?.toInt(),
        ),
        name: $checkedConvert('name', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PrinterToJson(Printer instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'languageLevel': instance.languageLevel,
  'name': instance.name,
};
