// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renderer_priority_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RendererPriorityPolicy _$RendererPriorityPolicyFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RendererPriorityPolicy', json, ($checkedConvert) {
  final val = RendererPriorityPolicy(
    rendererRequestedPriority: $checkedConvert(
      'rendererRequestedPriority',
      (v) => _rendererRequestedPriorityFromJson(v),
    ),
    waivedWhenNotVisible: $checkedConvert(
      'waivedWhenNotVisible',
      (v) => v as bool,
    ),
  );
  return val;
});

Map<String, dynamic> _$RendererPriorityPolicyToJson(
  RendererPriorityPolicy instance,
) => <String, dynamic>{
  'rendererRequestedPriority': _rendererRequestedPriorityToJson(
    instance.rendererRequestedPriority,
  ),
  'waivedWhenNotVisible': instance.waivedWhenNotVisible,
};
