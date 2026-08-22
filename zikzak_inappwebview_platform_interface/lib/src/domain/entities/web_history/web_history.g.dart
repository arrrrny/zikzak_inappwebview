// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebHistory _$WebHistoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebHistory', json, ($checkedConvert) {
      final val = WebHistory(
        list: $checkedConvert(
          'list',
          (v) => (v as List<dynamic>?)
              ?.map((e) => WebHistoryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        currentIndex: $checkedConvert(
          'currentIndex',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WebHistoryToJson(WebHistory instance) =>
    <String, dynamic>{
      'list': instance.list?.map((e) => e.toJson()).toList(),
      'currentIndex': instance.currentIndex,
    };
