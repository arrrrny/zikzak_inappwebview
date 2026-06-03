// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_attributes.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class representing the attributes of a [PlatformPrintJobController].
///These attributes describe how the printed content should be laid out.
class PrintJobAttributes {
  ///The color mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  InvalidType colorMode;

  ///If `true`, produce detailed reports when an error occurs.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? detailedErrorReporting;

  ///The duplex mode to use for the print job.
  ///
  ///**NOTE for Android native WebView**: available only on Android 23+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  InvalidType duplexMode;

  ///A fax number.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? faxNumber;

  ///An integer value that specifies the first page in the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? firstPage;

  ///The height of the page footer.
  ///
  ///The footer is measured in points from the bottom of [printableRect] and is below the content area.
  ///The default footer height is `0.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  double? footerHeight;

  ///If `true`, a standard header and footer are added outside the margins of each page.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? headerAndFooter;

  ///The height of the page header.
  ///
  ///The header is measured in points from the top of [printableRect] and is above the content area.
  ///The default header height is `0.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  double? headerHeight;

  ///The horizontal pagination mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InvalidType horizontalPagination;

  ///Indicates whether the image is centered horizontally.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? isHorizontallyCentered;

  ///Indicates whether the image is centered vertically.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? isVerticallyCentered;

  ///The action specified for the job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InvalidType jobDisposition;

  ///An URL containing the location to which the job file will be saved when the [jobDisposition] is [PrintJobDisposition.SAVE].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  WebUri? jobSavingURL;

  ///An integer value that specifies the last page in the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? lastPage;

  ///The name of the currently selected paper size, suitable for presenting in a user interface.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? localizedPaperName;

  ///The margins for the printed content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  EdgeInsets? margins;

  ///The maximum height of the content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  double? maximumContentHeight;

  ///The maximum width of the content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  double? maximumContentWidth;

  ///The media size.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  InvalidType mediaSize;

  ///The orientation of the printed content, portrait or landscape.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  InvalidType orientation;

  ///The kind of paper used for the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? paperName;

  ///The size and position of the paper.
  ///
  ///The value of this property is a rectangle that defines the size and position of the paper.
  ///The origin is (0,0).
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InvalidType paperRect;

  ///The area in which printing can occur.
  ///
  ///The value of this property is a rectangle that defines the area in which the printer can print content.
  ///Sometimes this area is smaller than the [paperRect].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InvalidType printableRect;

  ///The supported resolution in DPI (dots per inch).
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  InvalidType resolution;

  ///The vertical pagination mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InvalidType verticalPagination;
  PrintJobAttributes();

  ///Gets a possible [PrintJobAttributes] instance from a [Map] value.
  static PrintJobAttributes? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PrintJobAttributes();
    instance.colorMode = map['colorMode'];
    instance.detailedErrorReporting = map['detailedErrorReporting'];
    instance.duplexMode = map['duplexMode'];
    instance.faxNumber = map['faxNumber'];
    instance.firstPage = map['firstPage'];
    instance.footerHeight = map['footerHeight'];
    instance.headerAndFooter = map['headerAndFooter'];
    instance.headerHeight = map['headerHeight'];
    instance.horizontalPagination = map['horizontalPagination'];
    instance.isHorizontallyCentered = map['isHorizontallyCentered'];
    instance.isVerticallyCentered = map['isVerticallyCentered'];
    instance.jobDisposition = map['jobDisposition'];
    instance.jobSavingURL =
        map['jobSavingURL'] != null ? WebUri(map['jobSavingURL']) : null;
    instance.lastPage = map['lastPage'];
    instance.localizedPaperName = map['localizedPaperName'];
    instance.margins =
        MapEdgeInsets.fromMap(map['margins']?.cast<String, dynamic>());
    instance.maximumContentHeight = map['maximumContentHeight'];
    instance.maximumContentWidth = map['maximumContentWidth'];
    instance.mediaSize = map['mediaSize'];
    instance.orientation = map['orientation'];
    instance.paperName = map['paperName'];
    instance.paperRect = map['paperRect'];
    instance.printableRect = map['printableRect'];
    instance.resolution = map['resolution'];
    instance.verticalPagination = map['verticalPagination'];
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "colorMode": colorMode,
      "detailedErrorReporting": detailedErrorReporting,
      "duplexMode": duplexMode,
      "faxNumber": faxNumber,
      "firstPage": firstPage,
      "footerHeight": footerHeight,
      "headerAndFooter": headerAndFooter,
      "headerHeight": headerHeight,
      "horizontalPagination": horizontalPagination,
      "isHorizontallyCentered": isHorizontallyCentered,
      "isVerticallyCentered": isVerticallyCentered,
      "jobDisposition": jobDisposition,
      "jobSavingURL": jobSavingURL?.toString(),
      "lastPage": lastPage,
      "localizedPaperName": localizedPaperName,
      "margins": margins?.toMap(),
      "maximumContentHeight": maximumContentHeight,
      "maximumContentWidth": maximumContentWidth,
      "mediaSize": mediaSize,
      "orientation": orientation,
      "paperName": paperName,
      "paperRect": paperRect,
      "printableRect": printableRect,
      "resolution": resolution,
      "verticalPagination": verticalPagination,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PrintJobAttributes{colorMode: $colorMode, detailedErrorReporting: $detailedErrorReporting, duplexMode: $duplexMode, faxNumber: $faxNumber, firstPage: $firstPage, footerHeight: $footerHeight, headerAndFooter: $headerAndFooter, headerHeight: $headerHeight, horizontalPagination: $horizontalPagination, isHorizontallyCentered: $isHorizontallyCentered, isVerticallyCentered: $isVerticallyCentered, jobDisposition: $jobDisposition, jobSavingURL: $jobSavingURL, lastPage: $lastPage, localizedPaperName: $localizedPaperName, margins: $margins, maximumContentHeight: $maximumContentHeight, maximumContentWidth: $maximumContentWidth, mediaSize: $mediaSize, orientation: $orientation, paperName: $paperName, paperRect: $paperRect, printableRect: $printableRect, resolution: $resolution, verticalPagination: $verticalPagination}';
  }
}
