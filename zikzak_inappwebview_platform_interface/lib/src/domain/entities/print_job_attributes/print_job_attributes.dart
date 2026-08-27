// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the ctor-less field-bag class as manual).
// Wire matches the old codegen: enums as their wire ints (colorMode 1-based,
// others .index), mediaSize/resolution nested, EdgeInsets via the fork's
// MapEdgeInsets, WebUri as string, InAppWebViewRect via its still-codegen
// fromMap/toMap.

import 'package:flutter/rendering.dart';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../types/main.dart';
import '../../../util.dart';
import '../../../web_uri.dart';
import '../enums/print_job_color_mode.dart';
import '../enums/print_job_disposition.dart';
import '../enums/print_job_duplex_mode.dart';
import '../enums/print_job_orientation.dart';
import '../enums/print_job_pagination_mode.dart';
import '../print_job_media_size/print_job_media_size.dart';
import '../print_job_resolution/print_job_resolution.dart';

part 'print_job_attributes.zorphy.dart';
part 'print_job_attributes.g.dart';

///Class that represents the attributes of a print job.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $PrintJobAttributes {
  @JsonKey(fromJson: _colorModeFromJson, toJson: _colorModeToJson)
  PrintJobColorMode? get colorMode;
  @JsonKey(fromJson: _duplexModeFromJson, toJson: _duplexModeToJson)
  PrintJobDuplexMode? get duplexMode;
  @JsonKey(fromJson: _orientationFromJson, toJson: _orientationToJson)
  PrintJobOrientation? get orientation;
  @JsonKey(fromJson: _mediaSizeFromJson, toJson: _mediaSizeToJson)
  PrintJobMediaSize? get mediaSize;
  @JsonKey(fromJson: _resolutionFromJson, toJson: _resolutionToJson)
  PrintJobResolution? get resolution;
  @JsonKey(fromJson: _marginsFromJson, toJson: _marginsToJson)
  EdgeInsets? get margins;
  double? get footerHeight;
  double? get headerHeight;
  String? get paperName;
  String? get localizedPaperName;
  @JsonKey(fromJson: _printableRectFromJson, toJson: _printableRectToJson)
  InAppWebViewRect? get printableRect;
  @JsonKey(fromJson: _paperRectFromJson, toJson: _paperRectToJson)
  InAppWebViewRect? get paperRect;
  bool? get detailedErrorReporting;
  String? get faxNumber;
  bool? get headerAndFooter;
  @JsonKey(
    fromJson: _horizontalPaginationFromJson,
    toJson: _horizontalPaginationToJson,
  )
  PrintJobPaginationMode? get horizontalPagination;
  bool? get isHorizontallyCentered;
  bool? get isVerticallyCentered;
  @JsonKey(fromJson: _jobDispositionFromJson, toJson: _jobDispositionToJson)
  PrintJobDisposition? get jobDisposition;
  @JsonKey(fromJson: _jobSavingURLFromJson, toJson: _jobSavingURLToJson)
  WebUri? get jobSavingURL;
  @JsonKey(
    fromJson: _verticalPaginationFromJson,
    toJson: _verticalPaginationToJson,
  )
  PrintJobPaginationMode? get verticalPagination;
  double? get maximumContentHeight;
  double? get maximumContentWidth;
  int? get firstPage;
  int? get lastPage;
}

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

PrintJobOrientation? _orientationFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobOrientation.values.length
      ? PrintJobOrientation.values[value]
      : null;
}

Object? _orientationToJson(PrintJobOrientation? orientation) =>
    orientation?.index;

PrintJobMediaSize? _mediaSizeFromJson(Object? value) => value == null
    ? null
    : PrintJobMediaSize.fromJson((value as Map).cast<String, dynamic>());

Object? _mediaSizeToJson(PrintJobMediaSize? mediaSize) => mediaSize?.toJson();

PrintJobResolution? _resolutionFromJson(Object? value) => value == null
    ? null
    : PrintJobResolution.fromJson((value as Map).cast<String, dynamic>());

Object? _resolutionToJson(PrintJobResolution? resolution) =>
    resolution?.toJson();

EdgeInsets? _marginsFromJson(Object? value) => value == null
    ? null
    : MapEdgeInsets.fromMap((value as Map).cast<String, dynamic>());

Object? _marginsToJson(EdgeInsets? margins) => margins?.toJson();

InAppWebViewRect? _printableRectFromJson(Object? value) => value == null
    ? null
    : InAppWebViewRect.fromJson((value as Map).cast<String, dynamic>());

Object? _printableRectToJson(InAppWebViewRect? rect) => rect?.toJson();

InAppWebViewRect? _paperRectFromJson(Object? value) => value == null
    ? null
    : InAppWebViewRect.fromJson((value as Map).cast<String, dynamic>());

Object? _paperRectToJson(InAppWebViewRect? rect) => rect?.toJson();

PrintJobPaginationMode? _horizontalPaginationFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobPaginationMode.values.length
      ? PrintJobPaginationMode.values[value]
      : null;
}

Object? _horizontalPaginationToJson(PrintJobPaginationMode? pagination) =>
    pagination?.index;

PrintJobDisposition? _jobDispositionFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobDisposition.values.length
      ? PrintJobDisposition.values[value]
      : null;
}

Object? _jobDispositionToJson(PrintJobDisposition? disposition) =>
    disposition?.index;

WebUri? _jobSavingURLFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _jobSavingURLToJson(WebUri? url) => url?.toString();

PrintJobPaginationMode? _verticalPaginationFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobPaginationMode.values.length
      ? PrintJobPaginationMode.values[value]
      : null;
}

Object? _verticalPaginationToJson(PrintJobPaginationMode? pagination) =>
    pagination?.index;
