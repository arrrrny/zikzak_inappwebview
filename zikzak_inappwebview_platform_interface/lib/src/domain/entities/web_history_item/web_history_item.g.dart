// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebHistoryItem _$WebHistoryItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebHistoryItem', json, ($checkedConvert) {
      final val = WebHistoryItem(
        originalUrl: $checkedConvert(
          'originalUrl',
          (v) => _originalUrlFromJson(v),
        ),
        title: $checkedConvert('title', (v) => v as String?),
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        index: $checkedConvert('index', (v) => (v as num?)?.toInt()),
        offset: $checkedConvert('offset', (v) => (v as num?)?.toInt()),
        entryId: $checkedConvert('entryId', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$WebHistoryItemToJson(WebHistoryItem instance) =>
    <String, dynamic>{
      'originalUrl': _originalUrlToJson(instance.originalUrl),
      'title': instance.title,
      'url': _urlToJson(instance.url),
      'index': instance.index,
      'offset': instance.offset,
      'entryId': instance.entryId,
    };
