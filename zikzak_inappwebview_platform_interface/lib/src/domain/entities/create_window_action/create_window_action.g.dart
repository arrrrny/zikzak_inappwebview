// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_window_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWindowAction _$CreateWindowActionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateWindowAction', json, ($checkedConvert) {
  final val = CreateWindowAction(
    windowId: $checkedConvert('windowId', (v) => (v as num).toInt()),
    isDialog: $checkedConvert('isDialog', (v) => v as bool?),
    windowFeatures: $checkedConvert(
      'windowFeatures',
      (v) => _windowFeaturesFromJson(v),
    ),
    request: $checkedConvert('request', (v) => _requestFromJson(v)),
    isForMainFrame: $checkedConvert('isForMainFrame', (v) => v as bool),
    hasGesture: $checkedConvert('hasGesture', (v) => v as bool?),
    isRedirect: $checkedConvert('isRedirect', (v) => v as bool?),
    navigationType: $checkedConvert(
      'navigationType',
      (v) => _navigationTypeFromJson(v),
    ),
    sourceFrame: $checkedConvert('sourceFrame', (v) => _sourceFrameFromJson(v)),
    targetFrame: $checkedConvert('targetFrame', (v) => _targetFrameFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$CreateWindowActionToJson(CreateWindowAction instance) =>
    <String, dynamic>{
      'windowId': instance.windowId,
      'isDialog': instance.isDialog,
      'windowFeatures': _windowFeaturesToJson(instance.windowFeatures),
      'request': _requestToJson(instance.request),
      'isForMainFrame': instance.isForMainFrame,
      'hasGesture': instance.hasGesture,
      'isRedirect': instance.isRedirect,
      'navigationType': _navigationTypeToJson(instance.navigationType),
      'sourceFrame': _sourceFrameToJson(instance.sourceFrame),
      'targetFrame': _targetFrameToJson(instance.targetFrame),
    };
