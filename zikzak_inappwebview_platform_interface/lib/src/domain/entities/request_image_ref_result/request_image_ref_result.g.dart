// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_image_ref_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestImageRefResult _$RequestImageRefResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RequestImageRefResult', json, ($checkedConvert) {
  final val = RequestImageRefResult(
    url: $checkedConvert('url', (v) => _urlFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$RequestImageRefResultToJson(
  RequestImageRefResult instance,
) => <String, dynamic>{'url': _urlToJson(instance.url)};
