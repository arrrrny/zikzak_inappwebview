// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'website_data_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebsiteDataRecord _$WebsiteDataRecordFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebsiteDataRecord', json, ($checkedConvert) {
      final val = WebsiteDataRecord(
        displayName: $checkedConvert('displayName', (v) => v as String?),
        dataTypes: $checkedConvert('dataTypes', (v) => _dataTypesFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$WebsiteDataRecordToJson(WebsiteDataRecord instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'dataTypes': _dataTypesToJson(instance.dataTypes),
    };
