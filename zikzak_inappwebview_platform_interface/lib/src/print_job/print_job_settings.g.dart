// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_settings.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the settings of a [PlatformPrintJobController].
class PrintJobSettings {
  ///`true` to animate the display of the sheet, `false` to display the sheet immediately.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  bool? animated;

  ///Whether the print operation should spawn a separate thread in which to run itself.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? canSpawnSeparateThread;

  ///The color mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  InvalidType colorMode;

  ///How many copies to print.
  ///The default value is `1`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? copies;

  ///If `true`, produce detailed reports when an error occurs.
  ///The default value is `false`.
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

  ///Force rendering quality.
  ///
  ///**NOTE for iOS**: available only on iOS 14.5+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  InvalidType forceRenderingQuality;

  ///Set this to `true` to handle the [PlatformPrintJobController].
  ///Otherwise, it will be handled and disposed automatically by the system.
  ///The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  bool? handledByClient;

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

  ///The name of the print job.
  ///An application should set this property to a name appropriate to the content being printed.
  ///The default job name is the current webpage title concatenated with the "Document" word at the end.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  String? jobName;

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

  ///The margins for the printed content.
  ///
  ///**Officially Supported Platforms/Implementations**:
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

  ///Specifies whether the results of a print operation should be collated.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? mustCollate;

  ///The number of pages to print.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? numberOfPages;

  ///The orientation of the printed content, portrait or landscape.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  InvalidType orientation;

  ///The type of content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  InvalidType outputType;

  ///The page order.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  InvalidType pageOrder;

  ///The name of the currently selected paper size, suitable for presenting in a user interface.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? pagesAcross;

  ///The name of the currently selected paper size, suitable for presenting in a user interface.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? pagesDown;

  ///The kind of paper used for the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? paperName;

  ///The supported resolution in DPI (dots per inch).
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  InvalidType resolution;

  ///The current scaling factor. From `0.0` to `1.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  double? scalingFactor;

  ///A Boolean value that determines whether the printing settings include the number of copies.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  bool? showsNumberOfCopies;

  ///A Boolean value that determines whether the Print panel includes a set of fields for manipulating the range of pages being printed.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPageRange;

  ///A Boolean value that determines whether the Print panel includes a separate accessory view for manipulating the paper size, orientation, and scaling attributes.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPageSetupAccessory;

  ///A Boolean value that determines whether the printing settings include the paper orientation control when available.
  ///The default value is `true`.
  ///
  ///**NOTE for iOS**: available only on iOS 15.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  bool? showsPaperOrientation;

  ///A Boolean value that determines whether the paper selection menu displays.
  ///The default value of this property is `false`.
  ///Setting the value to `true` enables a paper selection menu on printers that support different types of paper and have more than one paper type loaded.
  ///On printers where only one paper type is available, no paper selection menu is displayed, regardless of the value of this property.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  bool? showsPaperSelectionForLoadedPapers;

  ///A Boolean value that determines whether the print panel includes a control for manipulating the paper size of the printer.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPaperSize;

  ///A Boolean value that determines whether the Print panel displays a built-in preview of the document contents.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPreview;

  ///A Boolean value that determines whether the print operation displays a print panel.
  ///The default value is `true`.
  ///
  ///This property does not affect the display of a progress panel;
  ///that operation is controlled by the [showsProgressPanel] property.
  ///Operations that generate EPS or PDF data do no display a progress panel, regardless of the value in the flag parameter.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPrintPanel;

  ///A Boolean value that determines whether the Print panel includes an additional selection option for paper range.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPrintSelection;

  ///A Boolean value that determines whether the print operation displays a progress panel.
  ///The default value is `true`.
  ///
  ///This property does not affect the display of a print panel;
  ///that operation is controlled by the [showsPrintPanel] property.
  ///Operations that generate EPS or PDF data do no display a progress panel, regardless of the value in the flag parameter.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsProgressPanel;

  ///A Boolean value that determines whether the Print panel includes a control for scaling the printed output.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsScaling;

  ///A timestamp that specifies the time at which printing should begin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? time;

  ///The vertical pagination to the specified mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InvalidType verticalPagination;
  PrintJobSettings();

  ///Gets a possible [PrintJobSettings] instance from a [Map] value.
  static PrintJobSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PrintJobSettings();
    instance.animated = map['animated'];
    instance.canSpawnSeparateThread = map['canSpawnSeparateThread'];
    instance.colorMode = map['colorMode'];
    instance.copies = map['copies'];
    instance.detailedErrorReporting = map['detailedErrorReporting'];
    instance.duplexMode = map['duplexMode'];
    instance.faxNumber = map['faxNumber'];
    instance.firstPage = map['firstPage'];
    instance.footerHeight = map['footerHeight'];
    instance.forceRenderingQuality = map['forceRenderingQuality'];
    instance.handledByClient = map['handledByClient'];
    instance.headerAndFooter = map['headerAndFooter'];
    instance.headerHeight = map['headerHeight'];
    instance.horizontalPagination = map['horizontalPagination'];
    instance.isHorizontallyCentered = map['isHorizontallyCentered'];
    instance.isVerticallyCentered = map['isVerticallyCentered'];
    instance.jobDisposition = map['jobDisposition'];
    instance.jobName = map['jobName'];
    instance.jobSavingURL =
        map['jobSavingURL'] != null ? WebUri(map['jobSavingURL']) : null;
    instance.lastPage = map['lastPage'];
    instance.margins =
        MapEdgeInsets.fromMap(map['margins']?.cast<String, dynamic>());
    instance.maximumContentHeight = map['maximumContentHeight'];
    instance.maximumContentWidth = map['maximumContentWidth'];
    instance.mediaSize = map['mediaSize'];
    instance.mustCollate = map['mustCollate'];
    instance.numberOfPages = map['numberOfPages'];
    instance.orientation = map['orientation'];
    instance.outputType = map['outputType'];
    instance.pageOrder = map['pageOrder'];
    instance.pagesAcross = map['pagesAcross'];
    instance.pagesDown = map['pagesDown'];
    instance.paperName = map['paperName'];
    instance.resolution = map['resolution'];
    instance.scalingFactor = map['scalingFactor'];
    instance.showsNumberOfCopies = map['showsNumberOfCopies'];
    instance.showsPageRange = map['showsPageRange'];
    instance.showsPageSetupAccessory = map['showsPageSetupAccessory'];
    instance.showsPaperOrientation = map['showsPaperOrientation'];
    instance.showsPaperSelectionForLoadedPapers =
        map['showsPaperSelectionForLoadedPapers'];
    instance.showsPaperSize = map['showsPaperSize'];
    instance.showsPreview = map['showsPreview'];
    instance.showsPrintPanel = map['showsPrintPanel'];
    instance.showsPrintSelection = map['showsPrintSelection'];
    instance.showsProgressPanel = map['showsProgressPanel'];
    instance.showsScaling = map['showsScaling'];
    instance.time = map['time'];
    instance.verticalPagination = map['verticalPagination'];
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "animated": animated,
      "canSpawnSeparateThread": canSpawnSeparateThread,
      "colorMode": colorMode,
      "copies": copies,
      "detailedErrorReporting": detailedErrorReporting,
      "duplexMode": duplexMode,
      "faxNumber": faxNumber,
      "firstPage": firstPage,
      "footerHeight": footerHeight,
      "forceRenderingQuality": forceRenderingQuality,
      "handledByClient": handledByClient,
      "headerAndFooter": headerAndFooter,
      "headerHeight": headerHeight,
      "horizontalPagination": horizontalPagination,
      "isHorizontallyCentered": isHorizontallyCentered,
      "isVerticallyCentered": isVerticallyCentered,
      "jobDisposition": jobDisposition,
      "jobName": jobName,
      "jobSavingURL": jobSavingURL?.toString(),
      "lastPage": lastPage,
      "margins": margins?.toMap(),
      "maximumContentHeight": maximumContentHeight,
      "maximumContentWidth": maximumContentWidth,
      "mediaSize": mediaSize,
      "mustCollate": mustCollate,
      "numberOfPages": numberOfPages,
      "orientation": orientation,
      "outputType": outputType,
      "pageOrder": pageOrder,
      "pagesAcross": pagesAcross,
      "pagesDown": pagesDown,
      "paperName": paperName,
      "resolution": resolution,
      "scalingFactor": scalingFactor,
      "showsNumberOfCopies": showsNumberOfCopies,
      "showsPageRange": showsPageRange,
      "showsPageSetupAccessory": showsPageSetupAccessory,
      "showsPaperOrientation": showsPaperOrientation,
      "showsPaperSelectionForLoadedPapers": showsPaperSelectionForLoadedPapers,
      "showsPaperSize": showsPaperSize,
      "showsPreview": showsPreview,
      "showsPrintPanel": showsPrintPanel,
      "showsPrintSelection": showsPrintSelection,
      "showsProgressPanel": showsProgressPanel,
      "showsScaling": showsScaling,
      "time": time,
      "verticalPagination": verticalPagination,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PrintJobSettings{animated: $animated, canSpawnSeparateThread: $canSpawnSeparateThread, colorMode: $colorMode, copies: $copies, detailedErrorReporting: $detailedErrorReporting, duplexMode: $duplexMode, faxNumber: $faxNumber, firstPage: $firstPage, footerHeight: $footerHeight, forceRenderingQuality: $forceRenderingQuality, handledByClient: $handledByClient, headerAndFooter: $headerAndFooter, headerHeight: $headerHeight, horizontalPagination: $horizontalPagination, isHorizontallyCentered: $isHorizontallyCentered, isVerticallyCentered: $isVerticallyCentered, jobDisposition: $jobDisposition, jobName: $jobName, jobSavingURL: $jobSavingURL, lastPage: $lastPage, margins: $margins, maximumContentHeight: $maximumContentHeight, maximumContentWidth: $maximumContentWidth, mediaSize: $mediaSize, mustCollate: $mustCollate, numberOfPages: $numberOfPages, orientation: $orientation, outputType: $outputType, pageOrder: $pageOrder, pagesAcross: $pagesAcross, pagesDown: $pagesDown, paperName: $paperName, resolution: $resolution, scalingFactor: $scalingFactor, showsNumberOfCopies: $showsNumberOfCopies, showsPageRange: $showsPageRange, showsPageSetupAccessory: $showsPageSetupAccessory, showsPaperOrientation: $showsPaperOrientation, showsPaperSelectionForLoadedPapers: $showsPaperSelectionForLoadedPapers, showsPaperSize: $showsPaperSize, showsPreview: $showsPreview, showsPrintPanel: $showsPrintPanel, showsPrintSelection: $showsPrintSelection, showsProgressPanel: $showsProgressPanel, showsScaling: $showsScaling, time: $time, verticalPagination: $verticalPagination}';
  }
}
