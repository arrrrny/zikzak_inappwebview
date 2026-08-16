// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationAction _$NavigationActionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NavigationAction', json, ($checkedConvert) {
  final val = NavigationAction(
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
    shouldPerformDownload: $checkedConvert(
      'shouldPerformDownload',
      (v) => v as bool?,
    ),
  );
  return val;
});

Map<String, dynamic> _$NavigationActionToJson(NavigationAction instance) =>
    <String, dynamic>{
      'request': _requestToJson(instance.request),
      'isForMainFrame': instance.isForMainFrame,
      'hasGesture': instance.hasGesture,
      'isRedirect': instance.isRedirect,
      'navigationType': _navigationTypeToJson(instance.navigationType),
      'sourceFrame': _sourceFrameToJson(instance.sourceFrame),
      'targetFrame': _targetFrameToJson(instance.targetFrame),
      'shouldPerformDownload': instance.shouldPerformDownload,
    };
