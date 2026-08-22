// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintJobAttributes _$PrintJobAttributesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PrintJobAttributes', json, ($checkedConvert) {
  final val = PrintJobAttributes(
    colorMode: $checkedConvert('colorMode', (v) => _colorModeFromJson(v)),
    duplexMode: $checkedConvert('duplexMode', (v) => _duplexModeFromJson(v)),
    orientation: $checkedConvert('orientation', (v) => _orientationFromJson(v)),
    mediaSize: $checkedConvert('mediaSize', (v) => _mediaSizeFromJson(v)),
    resolution: $checkedConvert('resolution', (v) => _resolutionFromJson(v)),
    margins: $checkedConvert('margins', (v) => _marginsFromJson(v)),
    footerHeight: $checkedConvert(
      'footerHeight',
      (v) => (v as num?)?.toDouble(),
    ),
    headerHeight: $checkedConvert(
      'headerHeight',
      (v) => (v as num?)?.toDouble(),
    ),
    paperName: $checkedConvert('paperName', (v) => v as String?),
    localizedPaperName: $checkedConvert(
      'localizedPaperName',
      (v) => v as String?,
    ),
    printableRect: $checkedConvert(
      'printableRect',
      (v) => _printableRectFromJson(v),
    ),
    paperRect: $checkedConvert('paperRect', (v) => _paperRectFromJson(v)),
    detailedErrorReporting: $checkedConvert(
      'detailedErrorReporting',
      (v) => v as bool?,
    ),
    faxNumber: $checkedConvert('faxNumber', (v) => v as String?),
    headerAndFooter: $checkedConvert('headerAndFooter', (v) => v as bool?),
    horizontalPagination: $checkedConvert(
      'horizontalPagination',
      (v) => _horizontalPaginationFromJson(v),
    ),
    isHorizontallyCentered: $checkedConvert(
      'isHorizontallyCentered',
      (v) => v as bool?,
    ),
    isVerticallyCentered: $checkedConvert(
      'isVerticallyCentered',
      (v) => v as bool?,
    ),
    jobDisposition: $checkedConvert(
      'jobDisposition',
      (v) => _jobDispositionFromJson(v),
    ),
    jobSavingURL: $checkedConvert(
      'jobSavingURL',
      (v) => _jobSavingURLFromJson(v),
    ),
    verticalPagination: $checkedConvert(
      'verticalPagination',
      (v) => _verticalPaginationFromJson(v),
    ),
    maximumContentHeight: $checkedConvert(
      'maximumContentHeight',
      (v) => (v as num?)?.toDouble(),
    ),
    maximumContentWidth: $checkedConvert(
      'maximumContentWidth',
      (v) => (v as num?)?.toDouble(),
    ),
    firstPage: $checkedConvert('firstPage', (v) => (v as num?)?.toInt()),
    lastPage: $checkedConvert('lastPage', (v) => (v as num?)?.toInt()),
  );
  return val;
});

Map<String, dynamic> _$PrintJobAttributesToJson(
  PrintJobAttributes instance,
) => <String, dynamic>{
  'colorMode': _colorModeToJson(instance.colorMode),
  'duplexMode': _duplexModeToJson(instance.duplexMode),
  'orientation': _orientationToJson(instance.orientation),
  'mediaSize': _mediaSizeToJson(instance.mediaSize),
  'resolution': _resolutionToJson(instance.resolution),
  'margins': _marginsToJson(instance.margins),
  'footerHeight': instance.footerHeight,
  'headerHeight': instance.headerHeight,
  'paperName': instance.paperName,
  'localizedPaperName': instance.localizedPaperName,
  'printableRect': _printableRectToJson(instance.printableRect),
  'paperRect': _paperRectToJson(instance.paperRect),
  'detailedErrorReporting': instance.detailedErrorReporting,
  'faxNumber': instance.faxNumber,
  'headerAndFooter': instance.headerAndFooter,
  'horizontalPagination': _horizontalPaginationToJson(
    instance.horizontalPagination,
  ),
  'isHorizontallyCentered': instance.isHorizontallyCentered,
  'isVerticallyCentered': instance.isVerticallyCentered,
  'jobDisposition': _jobDispositionToJson(instance.jobDisposition),
  'jobSavingURL': _jobSavingURLToJson(instance.jobSavingURL),
  'verticalPagination': _verticalPaginationToJson(instance.verticalPagination),
  'maximumContentHeight': instance.maximumContentHeight,
  'maximumContentWidth': instance.maximumContentWidth,
  'firstPage': instance.firstPage,
  'lastPage': instance.lastPage,
};
