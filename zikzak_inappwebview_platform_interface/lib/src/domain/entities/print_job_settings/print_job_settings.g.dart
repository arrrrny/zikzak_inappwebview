// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintJobSettings _$PrintJobSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PrintJobSettings', json, ($checkedConvert) {
  final val = PrintJobSettings(
    handledByClient: $checkedConvert('handledByClient', (v) => v as bool?),
    jobName: $checkedConvert('jobName', (v) => v as String?),
    detailedErrorReporting: $checkedConvert(
      'detailedErrorReporting',
      (v) => v as bool?,
    ),
    showsPrintPanel: $checkedConvert('showsPrintPanel', (v) => v as bool?),
    showsProgressPanel: $checkedConvert(
      'showsProgressPanel',
      (v) => v as bool?,
    ),
    jobSavingURL: $checkedConvert(
      'jobSavingURL',
      (v) => _jobSavingURLFromJson(v),
    ),
    jobDisposition: $checkedConvert(
      'jobDisposition',
      (v) => _jobDispositionFromJson(v),
    ),
    paperName: $checkedConvert('paperName', (v) => v as String?),
    horizontalPagination: $checkedConvert(
      'horizontalPagination',
      (v) => _horizontalPaginationFromJson(v),
    ),
    verticalPagination: $checkedConvert(
      'verticalPagination',
      (v) => _verticalPaginationFromJson(v),
    ),
    isHorizontallyCentered: $checkedConvert(
      'isHorizontallyCentered',
      (v) => v as bool?,
    ),
    isVerticallyCentered: $checkedConvert(
      'isVerticallyCentered',
      (v) => v as bool?,
    ),
    maximumContentHeight: $checkedConvert(
      'maximumContentHeight',
      (v) => (v as num?)?.toDouble(),
    ),
    maximumContentWidth: $checkedConvert(
      'maximumContentWidth',
      (v) => (v as num?)?.toDouble(),
    ),
    margins: $checkedConvert('margins', (v) => _marginsFromJson(v)),
    firstPage: $checkedConvert('firstPage', (v) => (v as num?)?.toInt()),
    lastPage: $checkedConvert('lastPage', (v) => (v as num?)?.toInt()),
    headerAndFooter: $checkedConvert('headerAndFooter', (v) => v as bool?),
    headerHeight: $checkedConvert(
      'headerHeight',
      (v) => (v as num?)?.toDouble(),
    ),
    footerHeight: $checkedConvert(
      'footerHeight',
      (v) => (v as num?)?.toDouble(),
    ),
    time: $checkedConvert('time', (v) => (v as num?)?.toInt()),
    orientation: $checkedConvert('orientation', (v) => _orientationFromJson(v)),
    colorMode: $checkedConvert('colorMode', (v) => _colorModeFromJson(v)),
    duplexMode: $checkedConvert('duplexMode', (v) => _duplexModeFromJson(v)),
    mediaSize: $checkedConvert('mediaSize', (v) => _mediaSizeFromJson(v)),
    resolution: $checkedConvert('resolution', (v) => _resolutionFromJson(v)),
    faxNumber: $checkedConvert('faxNumber', (v) => v as String?),
    copies: $checkedConvert('copies', (v) => (v as num?)?.toInt()),
    numberOfPages: $checkedConvert(
      'numberOfPages',
      (v) => (v as num?)?.toInt(),
    ),
    mustCollate: $checkedConvert('mustCollate', (v) => v as bool?),
    pagesAcross: $checkedConvert('pagesAcross', (v) => v as String?),
    pagesDown: $checkedConvert('pagesDown', (v) => v as String?),
    showsPreview: $checkedConvert('showsPreview', (v) => v as bool?),
    showsPrintSelection: $checkedConvert(
      'showsPrintSelection',
      (v) => v as bool?,
    ),
    showsPageRange: $checkedConvert('showsPageRange', (v) => v as bool?),
    showsNumberOfCopies: $checkedConvert(
      'showsNumberOfCopies',
      (v) => v as bool?,
    ),
    showsPaperOrientation: $checkedConvert(
      'showsPaperOrientation',
      (v) => v as bool?,
    ),
    showsPaperSelectionForLoadedPapers: $checkedConvert(
      'showsPaperSelectionForLoadedPapers',
      (v) => v as bool?,
    ),
    showsPaperSize: $checkedConvert('showsPaperSize', (v) => v as bool?),
    showsScaling: $checkedConvert('showsScaling', (v) => v as bool?),
    showsPageSetupAccessory: $checkedConvert(
      'showsPageSetupAccessory',
      (v) => v as bool?,
    ),
    scalingFactor: $checkedConvert(
      'scalingFactor',
      (v) => (v as num?)?.toDouble(),
    ),
    forceRenderingQuality: $checkedConvert(
      'forceRenderingQuality',
      (v) => _forceRenderingQualityFromJson(v),
    ),
    animated: $checkedConvert('animated', (v) => v as bool?),
    canSpawnSeparateThread: $checkedConvert(
      'canSpawnSeparateThread',
      (v) => v as bool?,
    ),
    outputType: $checkedConvert('outputType', (v) => _outputTypeFromJson(v)),
    pageOrder: $checkedConvert('pageOrder', (v) => _pageOrderFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$PrintJobSettingsToJson(
  PrintJobSettings instance,
) => <String, dynamic>{
  'handledByClient': instance.handledByClient,
  'jobName': instance.jobName,
  'detailedErrorReporting': instance.detailedErrorReporting,
  'showsPrintPanel': instance.showsPrintPanel,
  'showsProgressPanel': instance.showsProgressPanel,
  'jobSavingURL': _jobSavingURLToJson(instance.jobSavingURL),
  'jobDisposition': _jobDispositionToJson(instance.jobDisposition),
  'paperName': instance.paperName,
  'horizontalPagination': _horizontalPaginationToJson(
    instance.horizontalPagination,
  ),
  'verticalPagination': _verticalPaginationToJson(instance.verticalPagination),
  'isHorizontallyCentered': instance.isHorizontallyCentered,
  'isVerticallyCentered': instance.isVerticallyCentered,
  'maximumContentHeight': instance.maximumContentHeight,
  'maximumContentWidth': instance.maximumContentWidth,
  'margins': _marginsToJson(instance.margins),
  'firstPage': instance.firstPage,
  'lastPage': instance.lastPage,
  'headerAndFooter': instance.headerAndFooter,
  'headerHeight': instance.headerHeight,
  'footerHeight': instance.footerHeight,
  'time': instance.time,
  'orientation': _orientationToJson(instance.orientation),
  'colorMode': _colorModeToJson(instance.colorMode),
  'duplexMode': _duplexModeToJson(instance.duplexMode),
  'mediaSize': _mediaSizeToJson(instance.mediaSize),
  'resolution': _resolutionToJson(instance.resolution),
  'faxNumber': instance.faxNumber,
  'copies': instance.copies,
  'numberOfPages': instance.numberOfPages,
  'mustCollate': instance.mustCollate,
  'pagesAcross': instance.pagesAcross,
  'pagesDown': instance.pagesDown,
  'showsPreview': instance.showsPreview,
  'showsPrintSelection': instance.showsPrintSelection,
  'showsPageRange': instance.showsPageRange,
  'showsNumberOfCopies': instance.showsNumberOfCopies,
  'showsPaperOrientation': instance.showsPaperOrientation,
  'showsPaperSelectionForLoadedPapers':
      instance.showsPaperSelectionForLoadedPapers,
  'showsPaperSize': instance.showsPaperSize,
  'showsScaling': instance.showsScaling,
  'showsPageSetupAccessory': instance.showsPageSetupAccessory,
  'scalingFactor': instance.scalingFactor,
  'forceRenderingQuality': _forceRenderingQualityToJson(
    instance.forceRenderingQuality,
  ),
  'animated': instance.animated,
  'canSpawnSeparateThread': instance.canSpawnSeparateThread,
  'outputType': _outputTypeToJson(instance.outputType),
  'pageOrder': _pageOrderToJson(instance.pageOrder),
};
