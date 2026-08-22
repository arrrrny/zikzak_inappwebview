// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'render_process_gone_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenderProcessGoneDetail _$RenderProcessGoneDetailFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RenderProcessGoneDetail', json, ($checkedConvert) {
  final val = RenderProcessGoneDetail(
    didCrash: $checkedConvert('didCrash', (v) => v as bool),
    rendererPriorityAtExit: $checkedConvert(
      'rendererPriorityAtExit',
      (v) => _rendererPriorityAtExitFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$RenderProcessGoneDetailToJson(
  RenderProcessGoneDetail instance,
) => <String, dynamic>{
  'didCrash': instance.didCrash,
  'rendererPriorityAtExit': _rendererPriorityAtExitToJson(
    instance.rendererPriorityAtExit,
  ),
};
