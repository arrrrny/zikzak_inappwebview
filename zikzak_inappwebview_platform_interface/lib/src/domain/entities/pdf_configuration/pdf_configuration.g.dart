// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDFConfiguration _$PDFConfigurationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PDFConfiguration', json, ($checkedConvert) {
      final val = PDFConfiguration(
        rect: $checkedConvert('rect', (v) => _rectFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$PDFConfigurationToJson(PDFConfiguration instance) =>
    <String, dynamic>{'rect': _rectToJson(instance.rect)};
