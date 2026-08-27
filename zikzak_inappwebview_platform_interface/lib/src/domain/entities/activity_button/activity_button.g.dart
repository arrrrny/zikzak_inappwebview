// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityButton _$ActivityButtonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ActivityButton', json, ($checkedConvert) {
      final val = ActivityButton(
        templateImage: $checkedConvert(
          'templateImage',
          (v) => _templateImageFromJson(v),
        ),
        extensionIdentifier: $checkedConvert(
          'extensionIdentifier',
          (v) => v as String,
        ),
      );
      return val;
    });

Map<String, dynamic> _$ActivityButtonToJson(ActivityButton instance) =>
    <String, dynamic>{
      'templateImage': _templateImageToJson(instance.templateImage),
      'extensionIdentifier': instance.extensionIdentifier,
    };
