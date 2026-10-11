// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDFConfiguration _$PDFConfigurationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PDFConfiguration', json, ($checkedConvert) {
      final val = PDFConfiguration(
        rect: $checkedConvert('rect', (v) => _rectFromJson(v)),
        pageSize: $checkedConvert('pageSize', (v) => _pageSizeFromJson(v)),
        margins: $checkedConvert('margins', (v) => _marginsFromJson(v)),
        orientation: $checkedConvert(
          'orientation',
          (v) => _orientationFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PDFConfigurationToJson(PDFConfiguration instance) =>
    <String, dynamic>{
      'rect': _rectToJson(instance.rect),
      'pageSize': _pageSizeToJson(instance.pageSize),
      'margins': _marginsToJson(instance.margins),
      'orientation': _orientationToJson(instance.orientation),
    };
