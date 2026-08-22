// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the ctor-less field-bag class as manual).
// Wire matches the old codegen: enums as their wire ints (colorMode 1-based,
// pageOrder -1/0/1/2, others .index), mediaSize/resolution nested, EdgeInsets
// via the fork's MapEdgeInsets, WebUri as string.

import 'package:flutter/rendering.dart';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../types/main.dart';
import '../../../util.dart';
import '../../../web_uri.dart';
import '../enums/print_job_color_mode.dart';
import '../enums/print_job_disposition.dart';
import '../enums/print_job_duplex_mode.dart';
import '../enums/print_job_orientation.dart';
import '../enums/print_job_output_type.dart';
import '../enums/print_job_page_order.dart';
import '../enums/print_job_pagination_mode.dart';
import '../enums/print_job_rendering_quality.dart';
import '../print_job_media_size/print_job_media_size.dart';
import '../print_job_resolution/print_job_resolution.dart';

part 'print_job_settings.zorphy.dart';
part 'print_job_settings.g.dart';

///Class that represents the settings of a print job.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $PrintJobSettings {
  bool? get handledByClient;
  String? get jobName;
  bool? get detailedErrorReporting;
  bool? get showsPrintPanel;
  bool? get showsProgressPanel;
  @JsonKey(fromJson: _jobSavingURLFromJson, toJson: _jobSavingURLToJson)
  WebUri? get jobSavingURL;
  @JsonKey(fromJson: _jobDispositionFromJson, toJson: _jobDispositionToJson)
  PrintJobDisposition? get jobDisposition;
  String? get paperName;
  @JsonKey(
    fromJson: _horizontalPaginationFromJson,
    toJson: _horizontalPaginationToJson,
  )
  PrintJobPaginationMode? get horizontalPagination;
  @JsonKey(
    fromJson: _verticalPaginationFromJson,
    toJson: _verticalPaginationToJson,
  )
  PrintJobPaginationMode? get verticalPagination;
  bool? get isHorizontallyCentered;
  bool? get isVerticallyCentered;
  double? get maximumContentHeight;
  double? get maximumContentWidth;
  @JsonKey(fromJson: _marginsFromJson, toJson: _marginsToJson)
  EdgeInsets? get margins;
  int? get firstPage;
  int? get lastPage;
  bool? get headerAndFooter;
  double? get headerHeight;
  double? get footerHeight;
  int? get time;
  @JsonKey(fromJson: _orientationFromJson, toJson: _orientationToJson)
  PrintJobOrientation? get orientation;
  @JsonKey(fromJson: _colorModeFromJson, toJson: _colorModeToJson)
  PrintJobColorMode? get colorMode;
  @JsonKey(fromJson: _duplexModeFromJson, toJson: _duplexModeToJson)
  PrintJobDuplexMode? get duplexMode;
  @JsonKey(fromJson: _mediaSizeFromJson, toJson: _mediaSizeToJson)
  PrintJobMediaSize? get mediaSize;
  @JsonKey(fromJson: _resolutionFromJson, toJson: _resolutionToJson)
  PrintJobResolution? get resolution;
  String? get faxNumber;
  int? get copies;
  int? get numberOfPages;
  bool? get mustCollate;
  String? get pagesAcross;
  String? get pagesDown;
  bool? get showsPreview;
  bool? get showsPrintSelection;
  bool? get showsPageRange;
  bool? get showsNumberOfCopies;
  bool? get showsPaperOrientation;
  bool? get showsPaperSelectionForLoadedPapers;
  bool? get showsPaperSize;
  bool? get showsScaling;
  bool? get showsPageSetupAccessory;
  double? get scalingFactor;
  @JsonKey(
    fromJson: _forceRenderingQualityFromJson,
    toJson: _forceRenderingQualityToJson,
  )
  PrintJobRenderingQuality? get forceRenderingQuality;
  bool? get animated;
  bool? get canSpawnSeparateThread;
  @JsonKey(fromJson: _outputTypeFromJson, toJson: _outputTypeToJson)
  PrintJobOutputType? get outputType;
  @JsonKey(fromJson: _pageOrderFromJson, toJson: _pageOrderToJson)
  PrintJobPageOrder? get pageOrder;
}

WebUri? _jobSavingURLFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _jobSavingURLToJson(WebUri? url) => url?.toString();

PrintJobDisposition? _jobDispositionFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobDisposition.values.length
      ? PrintJobDisposition.values[value]
      : null;
}

Object? _jobDispositionToJson(PrintJobDisposition? disposition) =>
    disposition?.index;

PrintJobPaginationMode? _horizontalPaginationFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobPaginationMode.values.length
      ? PrintJobPaginationMode.values[value]
      : null;
}

Object? _horizontalPaginationToJson(PrintJobPaginationMode? pagination) =>
    pagination?.index;

PrintJobPaginationMode? _verticalPaginationFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobPaginationMode.values.length
      ? PrintJobPaginationMode.values[value]
      : null;
}

Object? _verticalPaginationToJson(PrintJobPaginationMode? pagination) =>
    pagination?.index;

EdgeInsets? _marginsFromJson(Object? value) => value == null
    ? null
    : MapEdgeInsets.fromMap((value as Map).cast<String, dynamic>());

Object? _marginsToJson(EdgeInsets? margins) => margins?.toMap();

PrintJobOrientation? _orientationFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobOrientation.values.length
      ? PrintJobOrientation.values[value]
      : null;
}

Object? _orientationToJson(PrintJobOrientation? orientation) =>
    orientation?.index;

PrintJobColorMode? _colorModeFromJson(Object? value) =>
    printJobColorModeFromWire(value as int?);

Object? _colorModeToJson(PrintJobColorMode? colorMode) =>
    printJobColorModeToWire(colorMode);

PrintJobDuplexMode? _duplexModeFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobDuplexMode.values.length
      ? PrintJobDuplexMode.values[value]
      : null;
}

Object? _duplexModeToJson(PrintJobDuplexMode? duplexMode) => duplexMode?.index;

PrintJobMediaSize? _mediaSizeFromJson(Object? value) => value == null
    ? null
    : PrintJobMediaSize.fromJson((value as Map).cast<String, dynamic>());

Object? _mediaSizeToJson(PrintJobMediaSize? mediaSize) => mediaSize?.toJson();

PrintJobResolution? _resolutionFromJson(Object? value) => value == null
    ? null
    : PrintJobResolution.fromJson((value as Map).cast<String, dynamic>());

Object? _resolutionToJson(PrintJobResolution? resolution) =>
    resolution?.toJson();

PrintJobRenderingQuality? _forceRenderingQualityFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobRenderingQuality.values.length
      ? PrintJobRenderingQuality.values[value]
      : null;
}

Object? _forceRenderingQualityToJson(PrintJobRenderingQuality? quality) =>
    quality?.index;

PrintJobOutputType? _outputTypeFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobOutputType.values.length
      ? PrintJobOutputType.values[value]
      : null;
}

Object? _outputTypeToJson(PrintJobOutputType? outputType) => outputType?.index;

PrintJobPageOrder? _pageOrderFromJson(Object? value) =>
    printJobPageOrderFromWire(value as int?);

Object? _pageOrderToJson(PrintJobPageOrder? pageOrder) =>
    printJobPageOrderToWire(pageOrder);
