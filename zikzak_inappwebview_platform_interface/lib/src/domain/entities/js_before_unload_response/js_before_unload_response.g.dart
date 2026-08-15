// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_before_unload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsBeforeUnloadResponse _$JsBeforeUnloadResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('JsBeforeUnloadResponse', json, ($checkedConvert) {
  final val = JsBeforeUnloadResponse(
    message: $checkedConvert('message', (v) => v as String? ?? ''),
    confirmButtonTitle: $checkedConvert(
      'confirmButtonTitle',
      (v) => v as String? ?? '',
    ),
    cancelButtonTitle: $checkedConvert(
      'cancelButtonTitle',
      (v) => v as String? ?? '',
    ),
    handledByClient: $checkedConvert(
      'handledByClient',
      (v) => v as bool? ?? false,
    ),
    action: $checkedConvert(
      'action',
      (v) =>
          v == null ? JsBeforeUnloadResponseAction.CONFIRM : _actionFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$JsBeforeUnloadResponseToJson(
  JsBeforeUnloadResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'confirmButtonTitle': instance.confirmButtonTitle,
  'cancelButtonTitle': instance.cancelButtonTitle,
  'handledByClient': instance.handledByClient,
  'action': _actionToJson(instance.action),
};
