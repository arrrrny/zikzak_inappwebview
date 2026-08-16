import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../print_job_attributes/print_job_attributes.dart';
import '../enums/print_job_rendering_quality.dart';
import '../enums/print_job_state.dart';
import '../enums/print_job_page_order.dart';
import '../printer/printer.dart';

part 'print_job_info.zorphy.dart';
part 'print_job_info.g.dart';

///Class representing the description of a [PlatformPrintJobController].
///Note that the print jobs state may change over time and this class represents a snapshot of this state.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $PrintJobInfo {
  ///The state of the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  @JsonKey(fromJson: _stateFromJson, toJson: _stateToJson)
  PrintJobState? get state;

  ///How many copies to print.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  int? get copies;

  ///The number of pages to print.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  int? get numberOfPages;

  ///The timestamp when the print job was created.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  int? get creationTime;

  ///The human readable print job label.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  String? get label;

  ///The printer object to be used for printing.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  @JsonKey(fromJson: _printerFromJson, toJson: _printerToJson)
  Printer? get printer;

  ///The page order that will be used to generate the pages in this job.
  ///This is the physical page order of the pages.
  ///It depends on the stacking order of the printer, the capability of the app to reverse page order, etc.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  @JsonKey(fromJson: _pageOrderFromJson, toJson: _pageOrderToJson)
  PrintJobPageOrder? get pageOrder;

  ///The printing quality.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  PrintJobRenderingQuality? get preferredRenderingQuality;

  ///Whether the progress panel is shown during the operation.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? get showsProgressPanel;

  ///Whether the print panel is shown during the operation.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? get showsPrintPanel;

  ///Whether the print operation should spawn a separate thread in which to run itself.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? get canSpawnSeparateThread;

  ///A Boolean value that indicates whether the print operation is an EPS or PDF copy operation.
  ///It's `true` if the receiver is an EPS or PDF copy operation; otherwise, `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? get isCopyingOperation;

  ///The current page number being previewed or printed.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? get currentPage;

  ///An integer value that specifies the first page in the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? get firstPage;

  ///An integer value that specifies the last page in the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? get lastPage;

  ///The attributes of a print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  @JsonKey(fromJson: _attributesFromJson, toJson: _attributesToJson)
  PrintJobAttributes? get attributes;
}

PrintJobState? _stateFromJson(Object? value) =>
    printJobStateFromWire(value as int?);

Object? _stateToJson(PrintJobState? state) => printJobStateToWire(state);

Printer? _printerFromJson(Object? value) => value == null
    ? null
    : Printer.fromJson((value as Map).cast<String, dynamic>());

Object? _printerToJson(Printer? printer) => printer?.toJson();

PrintJobPageOrder? _pageOrderFromJson(Object? value) =>
    printJobPageOrderFromWire(value as int?);

Object? _pageOrderToJson(PrintJobPageOrder? pageOrder) =>
    printJobPageOrderToWire(pageOrder);

PrintJobAttributes? _attributesFromJson(Object? value) => value == null
    ? null
    : PrintJobAttributes.fromJson((value as Map).cast<String, dynamic>());

Object? _attributesToJson(PrintJobAttributes? attributes) =>
    attributes?.toJson();

PrintJobRenderingQuality? _renderingQualityFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobRenderingQuality.values.length
      ? PrintJobRenderingQuality.values[value]
      : null;
}

Object? _renderingQualityToJson(PrintJobRenderingQuality? quality) =>
    quality?.index;
