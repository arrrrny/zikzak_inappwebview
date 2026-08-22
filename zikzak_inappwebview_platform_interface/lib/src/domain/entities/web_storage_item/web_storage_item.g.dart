// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_storage_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebStorageItem _$WebStorageItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebStorageItem', json, ($checkedConvert) {
      final val = WebStorageItem(
        key: $checkedConvert('key', (v) => v as String?),
        value: $checkedConvert('value', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$WebStorageItemToJson(WebStorageItem instance) =>
    <String, dynamic>{'key': instance.key, 'value': instance.value};
