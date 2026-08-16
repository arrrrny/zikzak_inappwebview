// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindSession _$FindSessionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FindSession', json, ($checkedConvert) {
      final val = FindSession(
        resultCount: $checkedConvert('resultCount', (v) => (v as num).toInt()),
        highlightedResultIndex: $checkedConvert(
          'highlightedResultIndex',
          (v) => (v as num).toInt(),
        ),
        searchResultDisplayStyle: $checkedConvert(
          'searchResultDisplayStyle',
          (v) => $enumDecode(_$SearchResultDisplayStyleEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FindSessionToJson(FindSession instance) =>
    <String, dynamic>{
      'resultCount': instance.resultCount,
      'highlightedResultIndex': instance.highlightedResultIndex,
      'searchResultDisplayStyle':
          _$SearchResultDisplayStyleEnumMap[instance.searchResultDisplayStyle]!,
    };

const _$SearchResultDisplayStyleEnumMap = {
  SearchResultDisplayStyle.CURRENT_AND_TOTAL: 'CURRENT_AND_TOTAL',
  SearchResultDisplayStyle.TOTAL: 'TOTAL',
  SearchResultDisplayStyle.NONE: 'NONE',
};
