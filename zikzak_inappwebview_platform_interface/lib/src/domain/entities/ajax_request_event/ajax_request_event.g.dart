// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ajax_request_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AjaxRequestEvent _$AjaxRequestEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AjaxRequestEvent', json, ($checkedConvert) {
      final val = AjaxRequestEvent(
        type: $checkedConvert('type', (v) => _typeFromJson(v)),
        lengthComputable: $checkedConvert(
          'lengthComputable',
          (v) => v as bool?,
        ),
        loaded: $checkedConvert('loaded', (v) => (v as num?)?.toInt()),
        total: $checkedConvert('total', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AjaxRequestEventToJson(AjaxRequestEvent instance) =>
    <String, dynamic>{
      'type': _typeToJson(instance.type),
      'lengthComputable': instance.lengthComputable,
      'loaded': instance.loaded,
      'total': instance.total,
    };
