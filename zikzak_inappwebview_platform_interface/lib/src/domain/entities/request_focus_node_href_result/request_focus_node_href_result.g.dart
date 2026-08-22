// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_focus_node_href_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestFocusNodeHrefResult _$RequestFocusNodeHrefResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RequestFocusNodeHrefResult', json, ($checkedConvert) {
  final val = RequestFocusNodeHrefResult(
    url: $checkedConvert('url', (v) => _urlFromJson(v)),
    title: $checkedConvert('title', (v) => v as String?),
    src: $checkedConvert('src', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RequestFocusNodeHrefResultToJson(
  RequestFocusNodeHrefResult instance,
) => <String, dynamic>{
  'url': _urlToJson(instance.url),
  'title': instance.title,
  'src': instance.src,
};
