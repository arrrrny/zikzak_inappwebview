// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_async_javascript_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallAsyncJavaScriptResult _$CallAsyncJavaScriptResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CallAsyncJavaScriptResult', json, ($checkedConvert) {
  final val = CallAsyncJavaScriptResult(
    value: $checkedConvert('value', (v) => v),
    error: $checkedConvert('error', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$CallAsyncJavaScriptResultToJson(
  CallAsyncJavaScriptResult instance,
) => <String, dynamic>{'value': instance.value, 'error': instance.error};
