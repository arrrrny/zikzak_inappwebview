// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameInfo _$FrameInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FrameInfo', json, ($checkedConvert) {
      final val = FrameInfo(
        isMainFrame: $checkedConvert('isMainFrame', (v) => v as bool),
        request: $checkedConvert('request', (v) => _requestFromJson(v)),
        securityOrigin: $checkedConvert(
          'securityOrigin',
          (v) => _securityOriginFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FrameInfoToJson(FrameInfo instance) => <String, dynamic>{
  'isMainFrame': instance.isMainFrame,
  'request': _requestToJson(instance.request),
  'securityOrigin': _securityOriginToJson(instance.securityOrigin),
};
