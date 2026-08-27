// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_event_attribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIEventAttribution _$UIEventAttributionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UIEventAttribution', json, ($checkedConvert) {
      final val = UIEventAttribution(
        sourceIdentifier: $checkedConvert(
          'sourceIdentifier',
          (v) => (v as num).toInt(),
        ),
        destinationURL: $checkedConvert(
          'destinationURL',
          (v) => _destinationURLFromJson(v),
        ),
        sourceDescription: $checkedConvert(
          'sourceDescription',
          (v) => v as String,
        ),
        purchaser: $checkedConvert('purchaser', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$UIEventAttributionToJson(UIEventAttribution instance) =>
    <String, dynamic>{
      'sourceIdentifier': instance.sourceIdentifier,
      'destinationURL': _destinationURLToJson(instance.destinationURL),
      'sourceDescription': instance.sourceDescription,
      'purchaser': instance.purchaser,
    };
