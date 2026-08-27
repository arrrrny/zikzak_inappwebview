// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationResponse _$NavigationResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NavigationResponse', json, ($checkedConvert) {
      final val = NavigationResponse(
        response: $checkedConvert('response', (v) => _responseFromJson(v)),
        isForMainFrame: $checkedConvert('isForMainFrame', (v) => v as bool),
        canShowMIMEType: $checkedConvert('canShowMIMEType', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$NavigationResponseToJson(NavigationResponse instance) =>
    <String, dynamic>{
      'response': _responseToJson(instance.response),
      'isForMainFrame': instance.isForMainFrame,
      'canShowMIMEType': instance.canShowMIMEType,
    };
