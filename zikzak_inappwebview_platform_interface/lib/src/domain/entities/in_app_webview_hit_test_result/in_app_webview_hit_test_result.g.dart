// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_webview_hit_test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppWebViewHitTestResult _$InAppWebViewHitTestResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InAppWebViewHitTestResult', json, ($checkedConvert) {
  final val = InAppWebViewHitTestResult(
    type: $checkedConvert('type', (v) => _typeFromJson(v)),
    extra: $checkedConvert('extra', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$InAppWebViewHitTestResultToJson(
  InAppWebViewHitTestResult instance,
) => <String, dynamic>{
  'type': _typeToJson(instance.type),
  'extra': instance.extra,
};
