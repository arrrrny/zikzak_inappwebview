// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'print_job_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PrintJobSettings {
  PrintJobSettings({
    bool? this.handledByClient,
    String? this.jobName,
    bool? this.detailedErrorReporting,
    bool? this.showsPrintPanel,
    bool? this.showsProgressPanel,
    WebUri? this.jobSavingURL,
    PrintJobDisposition? this.jobDisposition,
    String? this.paperName,
    PrintJobPaginationMode? this.horizontalPagination,
    PrintJobPaginationMode? this.verticalPagination,
    bool? this.isHorizontallyCentered,
    bool? this.isVerticallyCentered,
    double? this.maximumContentHeight,
    double? this.maximumContentWidth,
    EdgeInsets? this.margins,
    int? this.firstPage,
    int? this.lastPage,
    bool? this.headerAndFooter,
    double? this.headerHeight,
    double? this.footerHeight,
    int? this.time,
    PrintJobOrientation? this.orientation,
    PrintJobColorMode? this.colorMode,
    PrintJobDuplexMode? this.duplexMode,
    PrintJobMediaSize? this.mediaSize,
    PrintJobResolution? this.resolution,
    String? this.faxNumber,
    int? this.copies,
    int? this.numberOfPages,
    bool? this.mustCollate,
    String? this.pagesAcross,
    String? this.pagesDown,
    bool? this.showsPreview,
    bool? this.showsPrintSelection,
    bool? this.showsPageRange,
    bool? this.showsNumberOfCopies,
    bool? this.showsPaperOrientation,
    bool? this.showsPaperSelectionForLoadedPapers,
    bool? this.showsPaperSize,
    bool? this.showsScaling,
    bool? this.showsPageSetupAccessory,
    double? this.scalingFactor,
    PrintJobRenderingQuality? this.forceRenderingQuality,
    bool? this.animated,
    bool? this.canSpawnSeparateThread,
    PrintJobOutputType? this.outputType,
    PrintJobPageOrder? this.pageOrder,
  });

  factory PrintJobSettings.fromJson(Map<String, dynamic> json) =>
      _$PrintJobSettingsFromJson(json);

  final bool? handledByClient;

  final String? jobName;

  final bool? detailedErrorReporting;

  final bool? showsPrintPanel;

  final bool? showsProgressPanel;

  @JsonKey(toJson: _jobSavingURLToJson, fromJson: _jobSavingURLFromJson)
  final WebUri? jobSavingURL;

  @JsonKey(toJson: _jobDispositionToJson, fromJson: _jobDispositionFromJson)
  final PrintJobDisposition? jobDisposition;

  final String? paperName;

  @JsonKey(
    toJson: _horizontalPaginationToJson,
    fromJson: _horizontalPaginationFromJson,
  )
  final PrintJobPaginationMode? horizontalPagination;

  @JsonKey(
    toJson: _verticalPaginationToJson,
    fromJson: _verticalPaginationFromJson,
  )
  final PrintJobPaginationMode? verticalPagination;

  final bool? isHorizontallyCentered;

  final bool? isVerticallyCentered;

  final double? maximumContentHeight;

  final double? maximumContentWidth;

  @JsonKey(toJson: _marginsToJson, fromJson: _marginsFromJson)
  final EdgeInsets? margins;

  final int? firstPage;

  final int? lastPage;

  final bool? headerAndFooter;

  final double? headerHeight;

  final double? footerHeight;

  final int? time;

  @JsonKey(toJson: _orientationToJson, fromJson: _orientationFromJson)
  final PrintJobOrientation? orientation;

  @JsonKey(toJson: _colorModeToJson, fromJson: _colorModeFromJson)
  final PrintJobColorMode? colorMode;

  @JsonKey(toJson: _duplexModeToJson, fromJson: _duplexModeFromJson)
  final PrintJobDuplexMode? duplexMode;

  @JsonKey(toJson: _mediaSizeToJson, fromJson: _mediaSizeFromJson)
  final PrintJobMediaSize? mediaSize;

  @JsonKey(toJson: _resolutionToJson, fromJson: _resolutionFromJson)
  final PrintJobResolution? resolution;

  final String? faxNumber;

  final int? copies;

  final int? numberOfPages;

  final bool? mustCollate;

  final String? pagesAcross;

  final String? pagesDown;

  final bool? showsPreview;

  final bool? showsPrintSelection;

  final bool? showsPageRange;

  final bool? showsNumberOfCopies;

  final bool? showsPaperOrientation;

  final bool? showsPaperSelectionForLoadedPapers;

  final bool? showsPaperSize;

  final bool? showsScaling;

  final bool? showsPageSetupAccessory;

  final double? scalingFactor;

  @JsonKey(
    toJson: _forceRenderingQualityToJson,
    fromJson: _forceRenderingQualityFromJson,
  )
  final PrintJobRenderingQuality? forceRenderingQuality;

  final bool? animated;

  final bool? canSpawnSeparateThread;

  @JsonKey(toJson: _outputTypeToJson, fromJson: _outputTypeFromJson)
  final PrintJobOutputType? outputType;

  @JsonKey(toJson: _pageOrderToJson, fromJson: _pageOrderFromJson)
  final PrintJobPageOrder? pageOrder;

  PrintJobSettings copyWith({
    bool? handledByClient,
    String? jobName,
    bool? detailedErrorReporting,
    bool? showsPrintPanel,
    bool? showsProgressPanel,
    WebUri? jobSavingURL,
    PrintJobDisposition? jobDisposition,
    String? paperName,
    PrintJobPaginationMode? horizontalPagination,
    PrintJobPaginationMode? verticalPagination,
    bool? isHorizontallyCentered,
    bool? isVerticallyCentered,
    double? maximumContentHeight,
    double? maximumContentWidth,
    EdgeInsets? margins,
    int? firstPage,
    int? lastPage,
    bool? headerAndFooter,
    double? headerHeight,
    double? footerHeight,
    int? time,
    PrintJobOrientation? orientation,
    PrintJobColorMode? colorMode,
    PrintJobDuplexMode? duplexMode,
    PrintJobMediaSize? mediaSize,
    PrintJobResolution? resolution,
    String? faxNumber,
    int? copies,
    int? numberOfPages,
    bool? mustCollate,
    String? pagesAcross,
    String? pagesDown,
    bool? showsPreview,
    bool? showsPrintSelection,
    bool? showsPageRange,
    bool? showsNumberOfCopies,
    bool? showsPaperOrientation,
    bool? showsPaperSelectionForLoadedPapers,
    bool? showsPaperSize,
    bool? showsScaling,
    bool? showsPageSetupAccessory,
    double? scalingFactor,
    PrintJobRenderingQuality? forceRenderingQuality,
    bool? animated,
    bool? canSpawnSeparateThread,
    PrintJobOutputType? outputType,
    PrintJobPageOrder? pageOrder,
  }) {
    return PrintJobSettings(
      handledByClient: handledByClient ?? this.handledByClient,
      jobName: jobName ?? this.jobName,
      detailedErrorReporting:
          detailedErrorReporting ?? this.detailedErrorReporting,
      showsPrintPanel: showsPrintPanel ?? this.showsPrintPanel,
      showsProgressPanel: showsProgressPanel ?? this.showsProgressPanel,
      jobSavingURL: jobSavingURL ?? this.jobSavingURL,
      jobDisposition: jobDisposition ?? this.jobDisposition,
      paperName: paperName ?? this.paperName,
      horizontalPagination: horizontalPagination ?? this.horizontalPagination,
      verticalPagination: verticalPagination ?? this.verticalPagination,
      isHorizontallyCentered:
          isHorizontallyCentered ?? this.isHorizontallyCentered,
      isVerticallyCentered: isVerticallyCentered ?? this.isVerticallyCentered,
      maximumContentHeight: maximumContentHeight ?? this.maximumContentHeight,
      maximumContentWidth: maximumContentWidth ?? this.maximumContentWidth,
      margins: margins ?? this.margins,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      headerAndFooter: headerAndFooter ?? this.headerAndFooter,
      headerHeight: headerHeight ?? this.headerHeight,
      footerHeight: footerHeight ?? this.footerHeight,
      time: time ?? this.time,
      orientation: orientation ?? this.orientation,
      colorMode: colorMode ?? this.colorMode,
      duplexMode: duplexMode ?? this.duplexMode,
      mediaSize: mediaSize ?? this.mediaSize,
      resolution: resolution ?? this.resolution,
      faxNumber: faxNumber ?? this.faxNumber,
      copies: copies ?? this.copies,
      numberOfPages: numberOfPages ?? this.numberOfPages,
      mustCollate: mustCollate ?? this.mustCollate,
      pagesAcross: pagesAcross ?? this.pagesAcross,
      pagesDown: pagesDown ?? this.pagesDown,
      showsPreview: showsPreview ?? this.showsPreview,
      showsPrintSelection: showsPrintSelection ?? this.showsPrintSelection,
      showsPageRange: showsPageRange ?? this.showsPageRange,
      showsNumberOfCopies: showsNumberOfCopies ?? this.showsNumberOfCopies,
      showsPaperOrientation:
          showsPaperOrientation ?? this.showsPaperOrientation,
      showsPaperSelectionForLoadedPapers:
          showsPaperSelectionForLoadedPapers ??
          this.showsPaperSelectionForLoadedPapers,
      showsPaperSize: showsPaperSize ?? this.showsPaperSize,
      showsScaling: showsScaling ?? this.showsScaling,
      showsPageSetupAccessory:
          showsPageSetupAccessory ?? this.showsPageSetupAccessory,
      scalingFactor: scalingFactor ?? this.scalingFactor,
      forceRenderingQuality:
          forceRenderingQuality ?? this.forceRenderingQuality,
      animated: animated ?? this.animated,
      canSpawnSeparateThread:
          canSpawnSeparateThread ?? this.canSpawnSeparateThread,
      outputType: outputType ?? this.outputType,
      pageOrder: pageOrder ?? this.pageOrder,
    );
  }

  PrintJobSettings copyWithPrintJobSettings({
    bool? handledByClient,
    String? jobName,
    bool? detailedErrorReporting,
    bool? showsPrintPanel,
    bool? showsProgressPanel,
    WebUri? jobSavingURL,
    PrintJobDisposition? jobDisposition,
    String? paperName,
    PrintJobPaginationMode? horizontalPagination,
    PrintJobPaginationMode? verticalPagination,
    bool? isHorizontallyCentered,
    bool? isVerticallyCentered,
    double? maximumContentHeight,
    double? maximumContentWidth,
    EdgeInsets? margins,
    int? firstPage,
    int? lastPage,
    bool? headerAndFooter,
    double? headerHeight,
    double? footerHeight,
    int? time,
    PrintJobOrientation? orientation,
    PrintJobColorMode? colorMode,
    PrintJobDuplexMode? duplexMode,
    PrintJobMediaSize? mediaSize,
    PrintJobResolution? resolution,
    String? faxNumber,
    int? copies,
    int? numberOfPages,
    bool? mustCollate,
    String? pagesAcross,
    String? pagesDown,
    bool? showsPreview,
    bool? showsPrintSelection,
    bool? showsPageRange,
    bool? showsNumberOfCopies,
    bool? showsPaperOrientation,
    bool? showsPaperSelectionForLoadedPapers,
    bool? showsPaperSize,
    bool? showsScaling,
    bool? showsPageSetupAccessory,
    double? scalingFactor,
    PrintJobRenderingQuality? forceRenderingQuality,
    bool? animated,
    bool? canSpawnSeparateThread,
    PrintJobOutputType? outputType,
    PrintJobPageOrder? pageOrder,
  }) {
    return copyWith(
      handledByClient: handledByClient,
      jobName: jobName,
      detailedErrorReporting: detailedErrorReporting,
      showsPrintPanel: showsPrintPanel,
      showsProgressPanel: showsProgressPanel,
      jobSavingURL: jobSavingURL,
      jobDisposition: jobDisposition,
      paperName: paperName,
      horizontalPagination: horizontalPagination,
      verticalPagination: verticalPagination,
      isHorizontallyCentered: isHorizontallyCentered,
      isVerticallyCentered: isVerticallyCentered,
      maximumContentHeight: maximumContentHeight,
      maximumContentWidth: maximumContentWidth,
      margins: margins,
      firstPage: firstPage,
      lastPage: lastPage,
      headerAndFooter: headerAndFooter,
      headerHeight: headerHeight,
      footerHeight: footerHeight,
      time: time,
      orientation: orientation,
      colorMode: colorMode,
      duplexMode: duplexMode,
      mediaSize: mediaSize,
      resolution: resolution,
      faxNumber: faxNumber,
      copies: copies,
      numberOfPages: numberOfPages,
      mustCollate: mustCollate,
      pagesAcross: pagesAcross,
      pagesDown: pagesDown,
      showsPreview: showsPreview,
      showsPrintSelection: showsPrintSelection,
      showsPageRange: showsPageRange,
      showsNumberOfCopies: showsNumberOfCopies,
      showsPaperOrientation: showsPaperOrientation,
      showsPaperSelectionForLoadedPapers: showsPaperSelectionForLoadedPapers,
      showsPaperSize: showsPaperSize,
      showsScaling: showsScaling,
      showsPageSetupAccessory: showsPageSetupAccessory,
      scalingFactor: scalingFactor,
      forceRenderingQuality: forceRenderingQuality,
      animated: animated,
      canSpawnSeparateThread: canSpawnSeparateThread,
      outputType: outputType,
      pageOrder: pageOrder,
    );
  }

  PrintJobSettings patchWithPrintJobSettings([
    PrintJobSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PrintJobSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return PrintJobSettings(
      handledByClient: _patchMap.containsKey(PrintJobSettings$.handledByClient)
          ? ((_patchMap[PrintJobSettings$.handledByClient] is Function)
                    ? _patchMap[PrintJobSettings$.handledByClient](
                        this.handledByClient,
                      )
                    : (_patchMap[PrintJobSettings$.handledByClient] is Patch)
                    ? _patchMap[PrintJobSettings$.handledByClient].applyTo(
                        this.handledByClient,
                      )
                    : _patchMap[PrintJobSettings$.handledByClient])
                as bool?
          : this.handledByClient,
      jobName: _patchMap.containsKey(PrintJobSettings$.jobName)
          ? ((_patchMap[PrintJobSettings$.jobName] is Function)
                    ? _patchMap[PrintJobSettings$.jobName](this.jobName)
                    : (_patchMap[PrintJobSettings$.jobName] is Patch)
                    ? _patchMap[PrintJobSettings$.jobName].applyTo(this.jobName)
                    : _patchMap[PrintJobSettings$.jobName])
                as String?
          : this.jobName,
      detailedErrorReporting:
          _patchMap.containsKey(PrintJobSettings$.detailedErrorReporting)
          ? ((_patchMap[PrintJobSettings$.detailedErrorReporting] is Function)
                    ? _patchMap[PrintJobSettings$.detailedErrorReporting](
                        this.detailedErrorReporting,
                      )
                    : (_patchMap[PrintJobSettings$.detailedErrorReporting]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.detailedErrorReporting]
                          .applyTo(this.detailedErrorReporting)
                    : _patchMap[PrintJobSettings$.detailedErrorReporting])
                as bool?
          : this.detailedErrorReporting,
      showsPrintPanel: _patchMap.containsKey(PrintJobSettings$.showsPrintPanel)
          ? ((_patchMap[PrintJobSettings$.showsPrintPanel] is Function)
                    ? _patchMap[PrintJobSettings$.showsPrintPanel](
                        this.showsPrintPanel,
                      )
                    : (_patchMap[PrintJobSettings$.showsPrintPanel] is Patch)
                    ? _patchMap[PrintJobSettings$.showsPrintPanel].applyTo(
                        this.showsPrintPanel,
                      )
                    : _patchMap[PrintJobSettings$.showsPrintPanel])
                as bool?
          : this.showsPrintPanel,
      showsProgressPanel:
          _patchMap.containsKey(PrintJobSettings$.showsProgressPanel)
          ? ((_patchMap[PrintJobSettings$.showsProgressPanel] is Function)
                    ? _patchMap[PrintJobSettings$.showsProgressPanel](
                        this.showsProgressPanel,
                      )
                    : (_patchMap[PrintJobSettings$.showsProgressPanel] is Patch)
                    ? _patchMap[PrintJobSettings$.showsProgressPanel].applyTo(
                        this.showsProgressPanel,
                      )
                    : _patchMap[PrintJobSettings$.showsProgressPanel])
                as bool?
          : this.showsProgressPanel,
      jobSavingURL: _patchMap.containsKey(PrintJobSettings$.jobSavingURL)
          ? ((_patchMap[PrintJobSettings$.jobSavingURL] is Function)
                    ? _patchMap[PrintJobSettings$.jobSavingURL](
                        this.jobSavingURL,
                      )
                    : (_patchMap[PrintJobSettings$.jobSavingURL] is Patch)
                    ? _patchMap[PrintJobSettings$.jobSavingURL].applyTo(
                        this.jobSavingURL,
                      )
                    : _patchMap[PrintJobSettings$.jobSavingURL])
                as WebUri?
          : this.jobSavingURL,
      jobDisposition: _patchMap.containsKey(PrintJobSettings$.jobDisposition)
          ? ((_patchMap[PrintJobSettings$.jobDisposition] is Function)
                    ? _patchMap[PrintJobSettings$.jobDisposition](
                        this.jobDisposition,
                      )
                    : (_patchMap[PrintJobSettings$.jobDisposition] is Patch)
                    ? _patchMap[PrintJobSettings$.jobDisposition].applyTo(
                        this.jobDisposition,
                      )
                    : _patchMap[PrintJobSettings$.jobDisposition])
                as PrintJobDisposition?
          : this.jobDisposition,
      paperName: _patchMap.containsKey(PrintJobSettings$.paperName)
          ? ((_patchMap[PrintJobSettings$.paperName] is Function)
                    ? _patchMap[PrintJobSettings$.paperName](this.paperName)
                    : (_patchMap[PrintJobSettings$.paperName] is Patch)
                    ? _patchMap[PrintJobSettings$.paperName].applyTo(
                        this.paperName,
                      )
                    : _patchMap[PrintJobSettings$.paperName])
                as String?
          : this.paperName,
      horizontalPagination:
          _patchMap.containsKey(PrintJobSettings$.horizontalPagination)
          ? ((_patchMap[PrintJobSettings$.horizontalPagination] is Function)
                    ? _patchMap[PrintJobSettings$.horizontalPagination](
                        this.horizontalPagination,
                      )
                    : (_patchMap[PrintJobSettings$.horizontalPagination]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.horizontalPagination].applyTo(
                        this.horizontalPagination,
                      )
                    : _patchMap[PrintJobSettings$.horizontalPagination])
                as PrintJobPaginationMode?
          : this.horizontalPagination,
      verticalPagination:
          _patchMap.containsKey(PrintJobSettings$.verticalPagination)
          ? ((_patchMap[PrintJobSettings$.verticalPagination] is Function)
                    ? _patchMap[PrintJobSettings$.verticalPagination](
                        this.verticalPagination,
                      )
                    : (_patchMap[PrintJobSettings$.verticalPagination] is Patch)
                    ? _patchMap[PrintJobSettings$.verticalPagination].applyTo(
                        this.verticalPagination,
                      )
                    : _patchMap[PrintJobSettings$.verticalPagination])
                as PrintJobPaginationMode?
          : this.verticalPagination,
      isHorizontallyCentered:
          _patchMap.containsKey(PrintJobSettings$.isHorizontallyCentered)
          ? ((_patchMap[PrintJobSettings$.isHorizontallyCentered] is Function)
                    ? _patchMap[PrintJobSettings$.isHorizontallyCentered](
                        this.isHorizontallyCentered,
                      )
                    : (_patchMap[PrintJobSettings$.isHorizontallyCentered]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.isHorizontallyCentered]
                          .applyTo(this.isHorizontallyCentered)
                    : _patchMap[PrintJobSettings$.isHorizontallyCentered])
                as bool?
          : this.isHorizontallyCentered,
      isVerticallyCentered:
          _patchMap.containsKey(PrintJobSettings$.isVerticallyCentered)
          ? ((_patchMap[PrintJobSettings$.isVerticallyCentered] is Function)
                    ? _patchMap[PrintJobSettings$.isVerticallyCentered](
                        this.isVerticallyCentered,
                      )
                    : (_patchMap[PrintJobSettings$.isVerticallyCentered]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.isVerticallyCentered].applyTo(
                        this.isVerticallyCentered,
                      )
                    : _patchMap[PrintJobSettings$.isVerticallyCentered])
                as bool?
          : this.isVerticallyCentered,
      maximumContentHeight:
          _patchMap.containsKey(PrintJobSettings$.maximumContentHeight)
          ? ((_patchMap[PrintJobSettings$.maximumContentHeight] is Function)
                    ? _patchMap[PrintJobSettings$.maximumContentHeight](
                        this.maximumContentHeight,
                      )
                    : (_patchMap[PrintJobSettings$.maximumContentHeight]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.maximumContentHeight].applyTo(
                        this.maximumContentHeight,
                      )
                    : _patchMap[PrintJobSettings$.maximumContentHeight])
                as double?
          : this.maximumContentHeight,
      maximumContentWidth:
          _patchMap.containsKey(PrintJobSettings$.maximumContentWidth)
          ? ((_patchMap[PrintJobSettings$.maximumContentWidth] is Function)
                    ? _patchMap[PrintJobSettings$.maximumContentWidth](
                        this.maximumContentWidth,
                      )
                    : (_patchMap[PrintJobSettings$.maximumContentWidth]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.maximumContentWidth].applyTo(
                        this.maximumContentWidth,
                      )
                    : _patchMap[PrintJobSettings$.maximumContentWidth])
                as double?
          : this.maximumContentWidth,
      margins: _patchMap.containsKey(PrintJobSettings$.margins)
          ? ((_patchMap[PrintJobSettings$.margins] is Function)
                    ? _patchMap[PrintJobSettings$.margins](this.margins)
                    : (_patchMap[PrintJobSettings$.margins] is Patch)
                    ? _patchMap[PrintJobSettings$.margins].applyTo(this.margins)
                    : _patchMap[PrintJobSettings$.margins])
                as EdgeInsets?
          : this.margins,
      firstPage: _patchMap.containsKey(PrintJobSettings$.firstPage)
          ? ((_patchMap[PrintJobSettings$.firstPage] is Function)
                    ? _patchMap[PrintJobSettings$.firstPage](this.firstPage)
                    : (_patchMap[PrintJobSettings$.firstPage] is Patch)
                    ? _patchMap[PrintJobSettings$.firstPage].applyTo(
                        this.firstPage,
                      )
                    : _patchMap[PrintJobSettings$.firstPage])
                as int?
          : this.firstPage,
      lastPage: _patchMap.containsKey(PrintJobSettings$.lastPage)
          ? ((_patchMap[PrintJobSettings$.lastPage] is Function)
                    ? _patchMap[PrintJobSettings$.lastPage](this.lastPage)
                    : (_patchMap[PrintJobSettings$.lastPage] is Patch)
                    ? _patchMap[PrintJobSettings$.lastPage].applyTo(
                        this.lastPage,
                      )
                    : _patchMap[PrintJobSettings$.lastPage])
                as int?
          : this.lastPage,
      headerAndFooter: _patchMap.containsKey(PrintJobSettings$.headerAndFooter)
          ? ((_patchMap[PrintJobSettings$.headerAndFooter] is Function)
                    ? _patchMap[PrintJobSettings$.headerAndFooter](
                        this.headerAndFooter,
                      )
                    : (_patchMap[PrintJobSettings$.headerAndFooter] is Patch)
                    ? _patchMap[PrintJobSettings$.headerAndFooter].applyTo(
                        this.headerAndFooter,
                      )
                    : _patchMap[PrintJobSettings$.headerAndFooter])
                as bool?
          : this.headerAndFooter,
      headerHeight: _patchMap.containsKey(PrintJobSettings$.headerHeight)
          ? ((_patchMap[PrintJobSettings$.headerHeight] is Function)
                    ? _patchMap[PrintJobSettings$.headerHeight](
                        this.headerHeight,
                      )
                    : (_patchMap[PrintJobSettings$.headerHeight] is Patch)
                    ? _patchMap[PrintJobSettings$.headerHeight].applyTo(
                        this.headerHeight,
                      )
                    : _patchMap[PrintJobSettings$.headerHeight])
                as double?
          : this.headerHeight,
      footerHeight: _patchMap.containsKey(PrintJobSettings$.footerHeight)
          ? ((_patchMap[PrintJobSettings$.footerHeight] is Function)
                    ? _patchMap[PrintJobSettings$.footerHeight](
                        this.footerHeight,
                      )
                    : (_patchMap[PrintJobSettings$.footerHeight] is Patch)
                    ? _patchMap[PrintJobSettings$.footerHeight].applyTo(
                        this.footerHeight,
                      )
                    : _patchMap[PrintJobSettings$.footerHeight])
                as double?
          : this.footerHeight,
      time: _patchMap.containsKey(PrintJobSettings$.time)
          ? ((_patchMap[PrintJobSettings$.time] is Function)
                    ? _patchMap[PrintJobSettings$.time](this.time)
                    : (_patchMap[PrintJobSettings$.time] is Patch)
                    ? _patchMap[PrintJobSettings$.time].applyTo(this.time)
                    : _patchMap[PrintJobSettings$.time])
                as int?
          : this.time,
      orientation: _patchMap.containsKey(PrintJobSettings$.orientation)
          ? ((_patchMap[PrintJobSettings$.orientation] is Function)
                    ? _patchMap[PrintJobSettings$.orientation](this.orientation)
                    : (_patchMap[PrintJobSettings$.orientation] is Patch)
                    ? _patchMap[PrintJobSettings$.orientation].applyTo(
                        this.orientation,
                      )
                    : _patchMap[PrintJobSettings$.orientation])
                as PrintJobOrientation?
          : this.orientation,
      colorMode: _patchMap.containsKey(PrintJobSettings$.colorMode)
          ? ((_patchMap[PrintJobSettings$.colorMode] is Function)
                    ? _patchMap[PrintJobSettings$.colorMode](this.colorMode)
                    : (_patchMap[PrintJobSettings$.colorMode] is Patch)
                    ? _patchMap[PrintJobSettings$.colorMode].applyTo(
                        this.colorMode,
                      )
                    : _patchMap[PrintJobSettings$.colorMode])
                as PrintJobColorMode?
          : this.colorMode,
      duplexMode: _patchMap.containsKey(PrintJobSettings$.duplexMode)
          ? ((_patchMap[PrintJobSettings$.duplexMode] is Function)
                    ? _patchMap[PrintJobSettings$.duplexMode](this.duplexMode)
                    : (_patchMap[PrintJobSettings$.duplexMode] is Patch)
                    ? _patchMap[PrintJobSettings$.duplexMode].applyTo(
                        this.duplexMode,
                      )
                    : _patchMap[PrintJobSettings$.duplexMode])
                as PrintJobDuplexMode?
          : this.duplexMode,
      mediaSize: _patchMap.containsKey(PrintJobSettings$.mediaSize)
          ? ((_patchMap[PrintJobSettings$.mediaSize] is Function)
                    ? _patchMap[PrintJobSettings$.mediaSize](this.mediaSize)
                    : (_patchMap[PrintJobSettings$.mediaSize] is Patch)
                    ? _patchMap[PrintJobSettings$.mediaSize].applyTo(
                        this.mediaSize,
                      )
                    : _patchMap[PrintJobSettings$.mediaSize])
                as PrintJobMediaSize?
          : this.mediaSize,
      resolution: _patchMap.containsKey(PrintJobSettings$.resolution)
          ? ((_patchMap[PrintJobSettings$.resolution] is Function)
                    ? _patchMap[PrintJobSettings$.resolution](this.resolution)
                    : (_patchMap[PrintJobSettings$.resolution] is Patch)
                    ? _patchMap[PrintJobSettings$.resolution].applyTo(
                        this.resolution,
                      )
                    : _patchMap[PrintJobSettings$.resolution])
                as PrintJobResolution?
          : this.resolution,
      faxNumber: _patchMap.containsKey(PrintJobSettings$.faxNumber)
          ? ((_patchMap[PrintJobSettings$.faxNumber] is Function)
                    ? _patchMap[PrintJobSettings$.faxNumber](this.faxNumber)
                    : (_patchMap[PrintJobSettings$.faxNumber] is Patch)
                    ? _patchMap[PrintJobSettings$.faxNumber].applyTo(
                        this.faxNumber,
                      )
                    : _patchMap[PrintJobSettings$.faxNumber])
                as String?
          : this.faxNumber,
      copies: _patchMap.containsKey(PrintJobSettings$.copies)
          ? ((_patchMap[PrintJobSettings$.copies] is Function)
                    ? _patchMap[PrintJobSettings$.copies](this.copies)
                    : (_patchMap[PrintJobSettings$.copies] is Patch)
                    ? _patchMap[PrintJobSettings$.copies].applyTo(this.copies)
                    : _patchMap[PrintJobSettings$.copies])
                as int?
          : this.copies,
      numberOfPages: _patchMap.containsKey(PrintJobSettings$.numberOfPages)
          ? ((_patchMap[PrintJobSettings$.numberOfPages] is Function)
                    ? _patchMap[PrintJobSettings$.numberOfPages](
                        this.numberOfPages,
                      )
                    : (_patchMap[PrintJobSettings$.numberOfPages] is Patch)
                    ? _patchMap[PrintJobSettings$.numberOfPages].applyTo(
                        this.numberOfPages,
                      )
                    : _patchMap[PrintJobSettings$.numberOfPages])
                as int?
          : this.numberOfPages,
      mustCollate: _patchMap.containsKey(PrintJobSettings$.mustCollate)
          ? ((_patchMap[PrintJobSettings$.mustCollate] is Function)
                    ? _patchMap[PrintJobSettings$.mustCollate](this.mustCollate)
                    : (_patchMap[PrintJobSettings$.mustCollate] is Patch)
                    ? _patchMap[PrintJobSettings$.mustCollate].applyTo(
                        this.mustCollate,
                      )
                    : _patchMap[PrintJobSettings$.mustCollate])
                as bool?
          : this.mustCollate,
      pagesAcross: _patchMap.containsKey(PrintJobSettings$.pagesAcross)
          ? ((_patchMap[PrintJobSettings$.pagesAcross] is Function)
                    ? _patchMap[PrintJobSettings$.pagesAcross](this.pagesAcross)
                    : (_patchMap[PrintJobSettings$.pagesAcross] is Patch)
                    ? _patchMap[PrintJobSettings$.pagesAcross].applyTo(
                        this.pagesAcross,
                      )
                    : _patchMap[PrintJobSettings$.pagesAcross])
                as String?
          : this.pagesAcross,
      pagesDown: _patchMap.containsKey(PrintJobSettings$.pagesDown)
          ? ((_patchMap[PrintJobSettings$.pagesDown] is Function)
                    ? _patchMap[PrintJobSettings$.pagesDown](this.pagesDown)
                    : (_patchMap[PrintJobSettings$.pagesDown] is Patch)
                    ? _patchMap[PrintJobSettings$.pagesDown].applyTo(
                        this.pagesDown,
                      )
                    : _patchMap[PrintJobSettings$.pagesDown])
                as String?
          : this.pagesDown,
      showsPreview: _patchMap.containsKey(PrintJobSettings$.showsPreview)
          ? ((_patchMap[PrintJobSettings$.showsPreview] is Function)
                    ? _patchMap[PrintJobSettings$.showsPreview](
                        this.showsPreview,
                      )
                    : (_patchMap[PrintJobSettings$.showsPreview] is Patch)
                    ? _patchMap[PrintJobSettings$.showsPreview].applyTo(
                        this.showsPreview,
                      )
                    : _patchMap[PrintJobSettings$.showsPreview])
                as bool?
          : this.showsPreview,
      showsPrintSelection:
          _patchMap.containsKey(PrintJobSettings$.showsPrintSelection)
          ? ((_patchMap[PrintJobSettings$.showsPrintSelection] is Function)
                    ? _patchMap[PrintJobSettings$.showsPrintSelection](
                        this.showsPrintSelection,
                      )
                    : (_patchMap[PrintJobSettings$.showsPrintSelection]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.showsPrintSelection].applyTo(
                        this.showsPrintSelection,
                      )
                    : _patchMap[PrintJobSettings$.showsPrintSelection])
                as bool?
          : this.showsPrintSelection,
      showsPageRange: _patchMap.containsKey(PrintJobSettings$.showsPageRange)
          ? ((_patchMap[PrintJobSettings$.showsPageRange] is Function)
                    ? _patchMap[PrintJobSettings$.showsPageRange](
                        this.showsPageRange,
                      )
                    : (_patchMap[PrintJobSettings$.showsPageRange] is Patch)
                    ? _patchMap[PrintJobSettings$.showsPageRange].applyTo(
                        this.showsPageRange,
                      )
                    : _patchMap[PrintJobSettings$.showsPageRange])
                as bool?
          : this.showsPageRange,
      showsNumberOfCopies:
          _patchMap.containsKey(PrintJobSettings$.showsNumberOfCopies)
          ? ((_patchMap[PrintJobSettings$.showsNumberOfCopies] is Function)
                    ? _patchMap[PrintJobSettings$.showsNumberOfCopies](
                        this.showsNumberOfCopies,
                      )
                    : (_patchMap[PrintJobSettings$.showsNumberOfCopies]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.showsNumberOfCopies].applyTo(
                        this.showsNumberOfCopies,
                      )
                    : _patchMap[PrintJobSettings$.showsNumberOfCopies])
                as bool?
          : this.showsNumberOfCopies,
      showsPaperOrientation:
          _patchMap.containsKey(PrintJobSettings$.showsPaperOrientation)
          ? ((_patchMap[PrintJobSettings$.showsPaperOrientation] is Function)
                    ? _patchMap[PrintJobSettings$.showsPaperOrientation](
                        this.showsPaperOrientation,
                      )
                    : (_patchMap[PrintJobSettings$.showsPaperOrientation]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.showsPaperOrientation]
                          .applyTo(this.showsPaperOrientation)
                    : _patchMap[PrintJobSettings$.showsPaperOrientation])
                as bool?
          : this.showsPaperOrientation,
      showsPaperSelectionForLoadedPapers:
          _patchMap.containsKey(
            PrintJobSettings$.showsPaperSelectionForLoadedPapers,
          )
          ? ((_patchMap[PrintJobSettings$.showsPaperSelectionForLoadedPapers]
                        is Function)
                    ? _patchMap[PrintJobSettings$
                          .showsPaperSelectionForLoadedPapers](
                        this.showsPaperSelectionForLoadedPapers,
                      )
                    : (_patchMap[PrintJobSettings$
                              .showsPaperSelectionForLoadedPapers]
                          is Patch)
                    ? _patchMap[PrintJobSettings$
                              .showsPaperSelectionForLoadedPapers]
                          .applyTo(this.showsPaperSelectionForLoadedPapers)
                    : _patchMap[PrintJobSettings$
                          .showsPaperSelectionForLoadedPapers])
                as bool?
          : this.showsPaperSelectionForLoadedPapers,
      showsPaperSize: _patchMap.containsKey(PrintJobSettings$.showsPaperSize)
          ? ((_patchMap[PrintJobSettings$.showsPaperSize] is Function)
                    ? _patchMap[PrintJobSettings$.showsPaperSize](
                        this.showsPaperSize,
                      )
                    : (_patchMap[PrintJobSettings$.showsPaperSize] is Patch)
                    ? _patchMap[PrintJobSettings$.showsPaperSize].applyTo(
                        this.showsPaperSize,
                      )
                    : _patchMap[PrintJobSettings$.showsPaperSize])
                as bool?
          : this.showsPaperSize,
      showsScaling: _patchMap.containsKey(PrintJobSettings$.showsScaling)
          ? ((_patchMap[PrintJobSettings$.showsScaling] is Function)
                    ? _patchMap[PrintJobSettings$.showsScaling](
                        this.showsScaling,
                      )
                    : (_patchMap[PrintJobSettings$.showsScaling] is Patch)
                    ? _patchMap[PrintJobSettings$.showsScaling].applyTo(
                        this.showsScaling,
                      )
                    : _patchMap[PrintJobSettings$.showsScaling])
                as bool?
          : this.showsScaling,
      showsPageSetupAccessory:
          _patchMap.containsKey(PrintJobSettings$.showsPageSetupAccessory)
          ? ((_patchMap[PrintJobSettings$.showsPageSetupAccessory] is Function)
                    ? _patchMap[PrintJobSettings$.showsPageSetupAccessory](
                        this.showsPageSetupAccessory,
                      )
                    : (_patchMap[PrintJobSettings$.showsPageSetupAccessory]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.showsPageSetupAccessory]
                          .applyTo(this.showsPageSetupAccessory)
                    : _patchMap[PrintJobSettings$.showsPageSetupAccessory])
                as bool?
          : this.showsPageSetupAccessory,
      scalingFactor: _patchMap.containsKey(PrintJobSettings$.scalingFactor)
          ? ((_patchMap[PrintJobSettings$.scalingFactor] is Function)
                    ? _patchMap[PrintJobSettings$.scalingFactor](
                        this.scalingFactor,
                      )
                    : (_patchMap[PrintJobSettings$.scalingFactor] is Patch)
                    ? _patchMap[PrintJobSettings$.scalingFactor].applyTo(
                        this.scalingFactor,
                      )
                    : _patchMap[PrintJobSettings$.scalingFactor])
                as double?
          : this.scalingFactor,
      forceRenderingQuality:
          _patchMap.containsKey(PrintJobSettings$.forceRenderingQuality)
          ? ((_patchMap[PrintJobSettings$.forceRenderingQuality] is Function)
                    ? _patchMap[PrintJobSettings$.forceRenderingQuality](
                        this.forceRenderingQuality,
                      )
                    : (_patchMap[PrintJobSettings$.forceRenderingQuality]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.forceRenderingQuality]
                          .applyTo(this.forceRenderingQuality)
                    : _patchMap[PrintJobSettings$.forceRenderingQuality])
                as PrintJobRenderingQuality?
          : this.forceRenderingQuality,
      animated: _patchMap.containsKey(PrintJobSettings$.animated)
          ? ((_patchMap[PrintJobSettings$.animated] is Function)
                    ? _patchMap[PrintJobSettings$.animated](this.animated)
                    : (_patchMap[PrintJobSettings$.animated] is Patch)
                    ? _patchMap[PrintJobSettings$.animated].applyTo(
                        this.animated,
                      )
                    : _patchMap[PrintJobSettings$.animated])
                as bool?
          : this.animated,
      canSpawnSeparateThread:
          _patchMap.containsKey(PrintJobSettings$.canSpawnSeparateThread)
          ? ((_patchMap[PrintJobSettings$.canSpawnSeparateThread] is Function)
                    ? _patchMap[PrintJobSettings$.canSpawnSeparateThread](
                        this.canSpawnSeparateThread,
                      )
                    : (_patchMap[PrintJobSettings$.canSpawnSeparateThread]
                          is Patch)
                    ? _patchMap[PrintJobSettings$.canSpawnSeparateThread]
                          .applyTo(this.canSpawnSeparateThread)
                    : _patchMap[PrintJobSettings$.canSpawnSeparateThread])
                as bool?
          : this.canSpawnSeparateThread,
      outputType: _patchMap.containsKey(PrintJobSettings$.outputType)
          ? ((_patchMap[PrintJobSettings$.outputType] is Function)
                    ? _patchMap[PrintJobSettings$.outputType](this.outputType)
                    : (_patchMap[PrintJobSettings$.outputType] is Patch)
                    ? _patchMap[PrintJobSettings$.outputType].applyTo(
                        this.outputType,
                      )
                    : _patchMap[PrintJobSettings$.outputType])
                as PrintJobOutputType?
          : this.outputType,
      pageOrder: _patchMap.containsKey(PrintJobSettings$.pageOrder)
          ? ((_patchMap[PrintJobSettings$.pageOrder] is Function)
                    ? _patchMap[PrintJobSettings$.pageOrder](this.pageOrder)
                    : (_patchMap[PrintJobSettings$.pageOrder] is Patch)
                    ? _patchMap[PrintJobSettings$.pageOrder].applyTo(
                        this.pageOrder,
                      )
                    : _patchMap[PrintJobSettings$.pageOrder])
                as PrintJobPageOrder?
          : this.pageOrder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrintJobSettings &&
        handledByClient == other.handledByClient &&
        jobName == other.jobName &&
        detailedErrorReporting == other.detailedErrorReporting &&
        showsPrintPanel == other.showsPrintPanel &&
        showsProgressPanel == other.showsProgressPanel &&
        jobSavingURL == other.jobSavingURL &&
        jobDisposition == other.jobDisposition &&
        paperName == other.paperName &&
        horizontalPagination == other.horizontalPagination &&
        verticalPagination == other.verticalPagination &&
        isHorizontallyCentered == other.isHorizontallyCentered &&
        isVerticallyCentered == other.isVerticallyCentered &&
        maximumContentHeight == other.maximumContentHeight &&
        maximumContentWidth == other.maximumContentWidth &&
        margins == other.margins &&
        firstPage == other.firstPage &&
        lastPage == other.lastPage &&
        headerAndFooter == other.headerAndFooter &&
        headerHeight == other.headerHeight &&
        footerHeight == other.footerHeight &&
        time == other.time &&
        orientation == other.orientation &&
        colorMode == other.colorMode &&
        duplexMode == other.duplexMode &&
        mediaSize == other.mediaSize &&
        resolution == other.resolution &&
        faxNumber == other.faxNumber &&
        copies == other.copies &&
        numberOfPages == other.numberOfPages &&
        mustCollate == other.mustCollate &&
        pagesAcross == other.pagesAcross &&
        pagesDown == other.pagesDown &&
        showsPreview == other.showsPreview &&
        showsPrintSelection == other.showsPrintSelection &&
        showsPageRange == other.showsPageRange &&
        showsNumberOfCopies == other.showsNumberOfCopies &&
        showsPaperOrientation == other.showsPaperOrientation &&
        showsPaperSelectionForLoadedPapers ==
            other.showsPaperSelectionForLoadedPapers &&
        showsPaperSize == other.showsPaperSize &&
        showsScaling == other.showsScaling &&
        showsPageSetupAccessory == other.showsPageSetupAccessory &&
        scalingFactor == other.scalingFactor &&
        forceRenderingQuality == other.forceRenderingQuality &&
        animated == other.animated &&
        canSpawnSeparateThread == other.canSpawnSeparateThread &&
        outputType == other.outputType &&
        pageOrder == other.pageOrder;
  }

  @override
  int get hashCode {
    return Object.hash(
          this.handledByClient,
          this.jobName,
          this.detailedErrorReporting,
          this.showsPrintPanel,
          this.showsProgressPanel,
          this.jobSavingURL,
          this.jobDisposition,
          this.paperName,
          this.horizontalPagination,
          this.verticalPagination,
          this.isHorizontallyCentered,
          this.isVerticallyCentered,
          this.maximumContentHeight,
          this.maximumContentWidth,
          this.margins,
          this.firstPage,
          this.lastPage,
          this.headerAndFooter,
          this.headerHeight,
          this.footerHeight,
        ) ^
        Object.hash(
          this.time,
          this.orientation,
          this.colorMode,
          this.duplexMode,
          this.mediaSize,
          this.resolution,
          this.faxNumber,
          this.copies,
          this.numberOfPages,
          this.mustCollate,
          this.pagesAcross,
          this.pagesDown,
          this.showsPreview,
          this.showsPrintSelection,
          this.showsPageRange,
          this.showsNumberOfCopies,
          this.showsPaperOrientation,
          this.showsPaperSelectionForLoadedPapers,
          this.showsPaperSize,
          this.showsScaling,
        ) ^
        Object.hash(
          this.showsPageSetupAccessory,
          this.scalingFactor,
          this.forceRenderingQuality,
          this.animated,
          this.canSpawnSeparateThread,
          this.outputType,
          this.pageOrder,
        );
  }

  @override
  String toString() {
    return 'PrintJobSettings(' +
        'handledByClient: ${handledByClient}' +
        ', ' +
        'jobName: ${jobName}' +
        ', ' +
        'detailedErrorReporting: ${detailedErrorReporting}' +
        ', ' +
        'showsPrintPanel: ${showsPrintPanel}' +
        ', ' +
        'showsProgressPanel: ${showsProgressPanel}' +
        ', ' +
        'jobSavingURL: ${jobSavingURL}' +
        ', ' +
        'jobDisposition: ${jobDisposition}' +
        ', ' +
        'paperName: ${paperName}' +
        ', ' +
        'horizontalPagination: ${horizontalPagination}' +
        ', ' +
        'verticalPagination: ${verticalPagination}' +
        ', ' +
        'isHorizontallyCentered: ${isHorizontallyCentered}' +
        ', ' +
        'isVerticallyCentered: ${isVerticallyCentered}' +
        ', ' +
        'maximumContentHeight: ${maximumContentHeight}' +
        ', ' +
        'maximumContentWidth: ${maximumContentWidth}' +
        ', ' +
        'margins: ${margins}' +
        ', ' +
        'firstPage: ${firstPage}' +
        ', ' +
        'lastPage: ${lastPage}' +
        ', ' +
        'headerAndFooter: ${headerAndFooter}' +
        ', ' +
        'headerHeight: ${headerHeight}' +
        ', ' +
        'footerHeight: ${footerHeight}' +
        ', ' +
        'time: ${time}' +
        ', ' +
        'orientation: ${orientation}' +
        ', ' +
        'colorMode: ${colorMode}' +
        ', ' +
        'duplexMode: ${duplexMode}' +
        ', ' +
        'mediaSize: ${mediaSize}' +
        ', ' +
        'resolution: ${resolution}' +
        ', ' +
        'faxNumber: ${faxNumber}' +
        ', ' +
        'copies: ${copies}' +
        ', ' +
        'numberOfPages: ${numberOfPages}' +
        ', ' +
        'mustCollate: ${mustCollate}' +
        ', ' +
        'pagesAcross: ${pagesAcross}' +
        ', ' +
        'pagesDown: ${pagesDown}' +
        ', ' +
        'showsPreview: ${showsPreview}' +
        ', ' +
        'showsPrintSelection: ${showsPrintSelection}' +
        ', ' +
        'showsPageRange: ${showsPageRange}' +
        ', ' +
        'showsNumberOfCopies: ${showsNumberOfCopies}' +
        ', ' +
        'showsPaperOrientation: ${showsPaperOrientation}' +
        ', ' +
        'showsPaperSelectionForLoadedPapers: ${showsPaperSelectionForLoadedPapers}' +
        ', ' +
        'showsPaperSize: ${showsPaperSize}' +
        ', ' +
        'showsScaling: ${showsScaling}' +
        ', ' +
        'showsPageSetupAccessory: ${showsPageSetupAccessory}' +
        ', ' +
        'scalingFactor: ${scalingFactor}' +
        ', ' +
        'forceRenderingQuality: ${forceRenderingQuality}' +
        ', ' +
        'animated: ${animated}' +
        ', ' +
        'canSpawnSeparateThread: ${canSpawnSeparateThread}' +
        ', ' +
        'outputType: ${outputType}' +
        ', ' +
        'pageOrder: ${pageOrder})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PrintJobSettingsToJson(this);
    _sanitizeJson(data);
    return data;
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension PrintJobSettingsPropertyHelpers on PrintJobSettings {
  bool get hasHandledByClient {
    return this.handledByClient != null;
  }

  bool get noHandledByClient {
    return this.handledByClient == null;
  }

  bool get handledByClientRequired {
    return this.handledByClient ??
        (throw StateError('handledByClient is required but was null'));
  }

  bool get hasJobName {
    return this.jobName?.isNotEmpty == true;
  }

  bool get noJobName {
    return this.jobName?.isEmpty ?? true;
  }

  String get jobNameRequired {
    return this.jobName ??
        (throw StateError('jobName is required but was null'));
  }

  bool get hasDetailedErrorReporting {
    return this.detailedErrorReporting != null;
  }

  bool get noDetailedErrorReporting {
    return this.detailedErrorReporting == null;
  }

  bool get detailedErrorReportingRequired {
    return this.detailedErrorReporting ??
        (throw StateError('detailedErrorReporting is required but was null'));
  }

  bool get hasShowsPrintPanel {
    return this.showsPrintPanel != null;
  }

  bool get noShowsPrintPanel {
    return this.showsPrintPanel == null;
  }

  bool get showsPrintPanelRequired {
    return this.showsPrintPanel ??
        (throw StateError('showsPrintPanel is required but was null'));
  }

  bool get hasShowsProgressPanel {
    return this.showsProgressPanel != null;
  }

  bool get noShowsProgressPanel {
    return this.showsProgressPanel == null;
  }

  bool get showsProgressPanelRequired {
    return this.showsProgressPanel ??
        (throw StateError('showsProgressPanel is required but was null'));
  }

  bool get hasJobSavingURL {
    return this.jobSavingURL != null;
  }

  bool get noJobSavingURL {
    return this.jobSavingURL == null;
  }

  WebUri get jobSavingURLRequired {
    return this.jobSavingURL ??
        (throw StateError('jobSavingURL is required but was null'));
  }

  bool get hasJobDisposition {
    return this.jobDisposition != null;
  }

  bool get noJobDisposition {
    return this.jobDisposition == null;
  }

  PrintJobDisposition get jobDispositionRequired {
    return this.jobDisposition ??
        (throw StateError('jobDisposition is required but was null'));
  }

  bool get isJobDispositionSPOOL {
    return this.jobDisposition == PrintJobDisposition.SPOOL;
  }

  bool get isJobDispositionPREVIEW {
    return this.jobDisposition == PrintJobDisposition.PREVIEW;
  }

  bool get isJobDispositionSAVE {
    return this.jobDisposition == PrintJobDisposition.SAVE;
  }

  bool get isJobDispositionCANCEL {
    return this.jobDisposition == PrintJobDisposition.CANCEL;
  }

  bool get hasPaperName {
    return this.paperName?.isNotEmpty == true;
  }

  bool get noPaperName {
    return this.paperName?.isEmpty ?? true;
  }

  String get paperNameRequired {
    return this.paperName ??
        (throw StateError('paperName is required but was null'));
  }

  bool get hasHorizontalPagination {
    return this.horizontalPagination != null;
  }

  bool get noHorizontalPagination {
    return this.horizontalPagination == null;
  }

  PrintJobPaginationMode get horizontalPaginationRequired {
    return this.horizontalPagination ??
        (throw StateError('horizontalPagination is required but was null'));
  }

  bool get isHorizontalPaginationAUTOMATIC {
    return this.horizontalPagination == PrintJobPaginationMode.AUTOMATIC;
  }

  bool get isHorizontalPaginationFIT {
    return this.horizontalPagination == PrintJobPaginationMode.FIT;
  }

  bool get isHorizontalPaginationCLIP {
    return this.horizontalPagination == PrintJobPaginationMode.CLIP;
  }

  bool get hasVerticalPagination {
    return this.verticalPagination != null;
  }

  bool get noVerticalPagination {
    return this.verticalPagination == null;
  }

  PrintJobPaginationMode get verticalPaginationRequired {
    return this.verticalPagination ??
        (throw StateError('verticalPagination is required but was null'));
  }

  bool get isVerticalPaginationAUTOMATIC {
    return this.verticalPagination == PrintJobPaginationMode.AUTOMATIC;
  }

  bool get isVerticalPaginationFIT {
    return this.verticalPagination == PrintJobPaginationMode.FIT;
  }

  bool get isVerticalPaginationCLIP {
    return this.verticalPagination == PrintJobPaginationMode.CLIP;
  }

  bool get hasIsHorizontallyCentered {
    return this.isHorizontallyCentered != null;
  }

  bool get noIsHorizontallyCentered {
    return this.isHorizontallyCentered == null;
  }

  bool get isHorizontallyCenteredRequired {
    return this.isHorizontallyCentered ??
        (throw StateError('isHorizontallyCentered is required but was null'));
  }

  bool get hasIsVerticallyCentered {
    return this.isVerticallyCentered != null;
  }

  bool get noIsVerticallyCentered {
    return this.isVerticallyCentered == null;
  }

  bool get isVerticallyCenteredRequired {
    return this.isVerticallyCentered ??
        (throw StateError('isVerticallyCentered is required but was null'));
  }

  bool get hasMaximumContentHeight {
    return this.maximumContentHeight != null;
  }

  bool get noMaximumContentHeight {
    return this.maximumContentHeight == null;
  }

  double get maximumContentHeightRequired {
    return this.maximumContentHeight ??
        (throw StateError('maximumContentHeight is required but was null'));
  }

  bool get hasMaximumContentWidth {
    return this.maximumContentWidth != null;
  }

  bool get noMaximumContentWidth {
    return this.maximumContentWidth == null;
  }

  double get maximumContentWidthRequired {
    return this.maximumContentWidth ??
        (throw StateError('maximumContentWidth is required but was null'));
  }

  bool get hasMargins {
    return this.margins != null;
  }

  bool get noMargins {
    return this.margins == null;
  }

  EdgeInsets get marginsRequired {
    return this.margins ??
        (throw StateError('margins is required but was null'));
  }

  bool get hasFirstPage {
    return this.firstPage != null;
  }

  bool get noFirstPage {
    return this.firstPage == null;
  }

  int get firstPageRequired {
    return this.firstPage ??
        (throw StateError('firstPage is required but was null'));
  }

  bool get hasLastPage {
    return this.lastPage != null;
  }

  bool get noLastPage {
    return this.lastPage == null;
  }

  int get lastPageRequired {
    return this.lastPage ??
        (throw StateError('lastPage is required but was null'));
  }

  bool get hasHeaderAndFooter {
    return this.headerAndFooter != null;
  }

  bool get noHeaderAndFooter {
    return this.headerAndFooter == null;
  }

  bool get headerAndFooterRequired {
    return this.headerAndFooter ??
        (throw StateError('headerAndFooter is required but was null'));
  }

  bool get hasHeaderHeight {
    return this.headerHeight != null;
  }

  bool get noHeaderHeight {
    return this.headerHeight == null;
  }

  double get headerHeightRequired {
    return this.headerHeight ??
        (throw StateError('headerHeight is required but was null'));
  }

  bool get hasFooterHeight {
    return this.footerHeight != null;
  }

  bool get noFooterHeight {
    return this.footerHeight == null;
  }

  double get footerHeightRequired {
    return this.footerHeight ??
        (throw StateError('footerHeight is required but was null'));
  }

  bool get hasTime {
    return this.time != null;
  }

  bool get noTime {
    return this.time == null;
  }

  int get timeRequired {
    return this.time ?? (throw StateError('time is required but was null'));
  }

  bool get hasOrientation {
    return this.orientation != null;
  }

  bool get noOrientation {
    return this.orientation == null;
  }

  PrintJobOrientation get orientationRequired {
    return this.orientation ??
        (throw StateError('orientation is required but was null'));
  }

  bool get isOrientationPORTRAIT {
    return this.orientation == PrintJobOrientation.PORTRAIT;
  }

  bool get isOrientationLANDSCAPE {
    return this.orientation == PrintJobOrientation.LANDSCAPE;
  }

  bool get hasColorMode {
    return this.colorMode != null;
  }

  bool get noColorMode {
    return this.colorMode == null;
  }

  PrintJobColorMode get colorModeRequired {
    return this.colorMode ??
        (throw StateError('colorMode is required but was null'));
  }

  bool get isColorModeMONOCHROME {
    return this.colorMode == PrintJobColorMode.MONOCHROME;
  }

  bool get isColorModeCOLOR {
    return this.colorMode == PrintJobColorMode.COLOR;
  }

  bool get hasDuplexMode {
    return this.duplexMode != null;
  }

  bool get noDuplexMode {
    return this.duplexMode == null;
  }

  PrintJobDuplexMode get duplexModeRequired {
    return this.duplexMode ??
        (throw StateError('duplexMode is required but was null'));
  }

  bool get isDuplexModeNONE {
    return this.duplexMode == PrintJobDuplexMode.NONE;
  }

  bool get isDuplexModeLONG_EDGE {
    return this.duplexMode == PrintJobDuplexMode.LONG_EDGE;
  }

  bool get isDuplexModeSHORT_EDGE {
    return this.duplexMode == PrintJobDuplexMode.SHORT_EDGE;
  }

  bool get hasMediaSize {
    return this.mediaSize != null;
  }

  bool get noMediaSize {
    return this.mediaSize == null;
  }

  PrintJobMediaSize get mediaSizeRequired {
    return this.mediaSize ??
        (throw StateError('mediaSize is required but was null'));
  }

  bool get hasResolution {
    return this.resolution != null;
  }

  bool get noResolution {
    return this.resolution == null;
  }

  PrintJobResolution get resolutionRequired {
    return this.resolution ??
        (throw StateError('resolution is required but was null'));
  }

  bool get hasFaxNumber {
    return this.faxNumber?.isNotEmpty == true;
  }

  bool get noFaxNumber {
    return this.faxNumber?.isEmpty ?? true;
  }

  String get faxNumberRequired {
    return this.faxNumber ??
        (throw StateError('faxNumber is required but was null'));
  }

  bool get hasCopies {
    return this.copies != null;
  }

  bool get noCopies {
    return this.copies == null;
  }

  int get copiesRequired {
    return this.copies ?? (throw StateError('copies is required but was null'));
  }

  bool get hasNumberOfPages {
    return this.numberOfPages != null;
  }

  bool get noNumberOfPages {
    return this.numberOfPages == null;
  }

  int get numberOfPagesRequired {
    return this.numberOfPages ??
        (throw StateError('numberOfPages is required but was null'));
  }

  bool get hasMustCollate {
    return this.mustCollate != null;
  }

  bool get noMustCollate {
    return this.mustCollate == null;
  }

  bool get mustCollateRequired {
    return this.mustCollate ??
        (throw StateError('mustCollate is required but was null'));
  }

  bool get hasPagesAcross {
    return this.pagesAcross?.isNotEmpty == true;
  }

  bool get noPagesAcross {
    return this.pagesAcross?.isEmpty ?? true;
  }

  String get pagesAcrossRequired {
    return this.pagesAcross ??
        (throw StateError('pagesAcross is required but was null'));
  }

  bool get hasPagesDown {
    return this.pagesDown?.isNotEmpty == true;
  }

  bool get noPagesDown {
    return this.pagesDown?.isEmpty ?? true;
  }

  String get pagesDownRequired {
    return this.pagesDown ??
        (throw StateError('pagesDown is required but was null'));
  }

  bool get hasShowsPreview {
    return this.showsPreview != null;
  }

  bool get noShowsPreview {
    return this.showsPreview == null;
  }

  bool get showsPreviewRequired {
    return this.showsPreview ??
        (throw StateError('showsPreview is required but was null'));
  }

  bool get hasShowsPrintSelection {
    return this.showsPrintSelection != null;
  }

  bool get noShowsPrintSelection {
    return this.showsPrintSelection == null;
  }

  bool get showsPrintSelectionRequired {
    return this.showsPrintSelection ??
        (throw StateError('showsPrintSelection is required but was null'));
  }

  bool get hasShowsPageRange {
    return this.showsPageRange != null;
  }

  bool get noShowsPageRange {
    return this.showsPageRange == null;
  }

  bool get showsPageRangeRequired {
    return this.showsPageRange ??
        (throw StateError('showsPageRange is required but was null'));
  }

  bool get hasShowsNumberOfCopies {
    return this.showsNumberOfCopies != null;
  }

  bool get noShowsNumberOfCopies {
    return this.showsNumberOfCopies == null;
  }

  bool get showsNumberOfCopiesRequired {
    return this.showsNumberOfCopies ??
        (throw StateError('showsNumberOfCopies is required but was null'));
  }

  bool get hasShowsPaperOrientation {
    return this.showsPaperOrientation != null;
  }

  bool get noShowsPaperOrientation {
    return this.showsPaperOrientation == null;
  }

  bool get showsPaperOrientationRequired {
    return this.showsPaperOrientation ??
        (throw StateError('showsPaperOrientation is required but was null'));
  }

  bool get hasShowsPaperSelectionForLoadedPapers {
    return this.showsPaperSelectionForLoadedPapers != null;
  }

  bool get noShowsPaperSelectionForLoadedPapers {
    return this.showsPaperSelectionForLoadedPapers == null;
  }

  bool get showsPaperSelectionForLoadedPapersRequired {
    return this.showsPaperSelectionForLoadedPapers ??
        (throw StateError(
          'showsPaperSelectionForLoadedPapers is required but was null',
        ));
  }

  bool get hasShowsPaperSize {
    return this.showsPaperSize != null;
  }

  bool get noShowsPaperSize {
    return this.showsPaperSize == null;
  }

  bool get showsPaperSizeRequired {
    return this.showsPaperSize ??
        (throw StateError('showsPaperSize is required but was null'));
  }

  bool get hasShowsScaling {
    return this.showsScaling != null;
  }

  bool get noShowsScaling {
    return this.showsScaling == null;
  }

  bool get showsScalingRequired {
    return this.showsScaling ??
        (throw StateError('showsScaling is required but was null'));
  }

  bool get hasShowsPageSetupAccessory {
    return this.showsPageSetupAccessory != null;
  }

  bool get noShowsPageSetupAccessory {
    return this.showsPageSetupAccessory == null;
  }

  bool get showsPageSetupAccessoryRequired {
    return this.showsPageSetupAccessory ??
        (throw StateError('showsPageSetupAccessory is required but was null'));
  }

  bool get hasScalingFactor {
    return this.scalingFactor != null;
  }

  bool get noScalingFactor {
    return this.scalingFactor == null;
  }

  double get scalingFactorRequired {
    return this.scalingFactor ??
        (throw StateError('scalingFactor is required but was null'));
  }

  bool get hasForceRenderingQuality {
    return this.forceRenderingQuality != null;
  }

  bool get noForceRenderingQuality {
    return this.forceRenderingQuality == null;
  }

  PrintJobRenderingQuality get forceRenderingQualityRequired {
    return this.forceRenderingQuality ??
        (throw StateError('forceRenderingQuality is required but was null'));
  }

  bool get isForceRenderingQualityBEST {
    return this.forceRenderingQuality == PrintJobRenderingQuality.BEST;
  }

  bool get isForceRenderingQualityRESPONSIVE {
    return this.forceRenderingQuality == PrintJobRenderingQuality.RESPONSIVE;
  }

  bool get hasAnimated {
    return this.animated != null;
  }

  bool get noAnimated {
    return this.animated == null;
  }

  bool get animatedRequired {
    return this.animated ??
        (throw StateError('animated is required but was null'));
  }

  bool get hasCanSpawnSeparateThread {
    return this.canSpawnSeparateThread != null;
  }

  bool get noCanSpawnSeparateThread {
    return this.canSpawnSeparateThread == null;
  }

  bool get canSpawnSeparateThreadRequired {
    return this.canSpawnSeparateThread ??
        (throw StateError('canSpawnSeparateThread is required but was null'));
  }

  bool get hasOutputType {
    return this.outputType != null;
  }

  bool get noOutputType {
    return this.outputType == null;
  }

  PrintJobOutputType get outputTypeRequired {
    return this.outputType ??
        (throw StateError('outputType is required but was null'));
  }

  bool get isOutputTypeGENERAL {
    return this.outputType == PrintJobOutputType.GENERAL;
  }

  bool get isOutputTypePHOTO {
    return this.outputType == PrintJobOutputType.PHOTO;
  }

  bool get isOutputTypeGRAYSCALE {
    return this.outputType == PrintJobOutputType.GRAYSCALE;
  }

  bool get isOutputTypePHOTO_GRAYSCALE {
    return this.outputType == PrintJobOutputType.PHOTO_GRAYSCALE;
  }

  bool get hasPageOrder {
    return this.pageOrder != null;
  }

  bool get noPageOrder {
    return this.pageOrder == null;
  }

  PrintJobPageOrder get pageOrderRequired {
    return this.pageOrder ??
        (throw StateError('pageOrder is required but was null'));
  }

  bool get isPageOrderDESCENDING {
    return this.pageOrder == PrintJobPageOrder.DESCENDING;
  }

  bool get isPageOrderSPECIAL {
    return this.pageOrder == PrintJobPageOrder.SPECIAL;
  }

  bool get isPageOrderASCENDING {
    return this.pageOrder == PrintJobPageOrder.ASCENDING;
  }

  bool get isPageOrderUNKNOWN {
    return this.pageOrder == PrintJobPageOrder.UNKNOWN;
  }
}

extension PrintJobSettingsSerialization on PrintJobSettings {
  Map<String, dynamic> toJson() {
    return _$PrintJobSettingsToJson(this);
  }
}

enum PrintJobSettings$ {
  handledByClient,
  jobName,
  detailedErrorReporting,
  showsPrintPanel,
  showsProgressPanel,
  jobSavingURL,
  jobDisposition,
  paperName,
  horizontalPagination,
  verticalPagination,
  isHorizontallyCentered,
  isVerticallyCentered,
  maximumContentHeight,
  maximumContentWidth,
  margins,
  firstPage,
  lastPage,
  headerAndFooter,
  headerHeight,
  footerHeight,
  time,
  orientation,
  colorMode,
  duplexMode,
  mediaSize,
  resolution,
  faxNumber,
  copies,
  numberOfPages,
  mustCollate,
  pagesAcross,
  pagesDown,
  showsPreview,
  showsPrintSelection,
  showsPageRange,
  showsNumberOfCopies,
  showsPaperOrientation,
  showsPaperSelectionForLoadedPapers,
  showsPaperSize,
  showsScaling,
  showsPageSetupAccessory,
  scalingFactor,
  forceRenderingQuality,
  animated,
  canSpawnSeparateThread,
  outputType,
  pageOrder,
}

class PrintJobSettingsPatch
    extends PatchBase<PrintJobSettings, PrintJobSettings$> {
  PrintJobSettings applyTo(PrintJobSettings entity) {
    return entity.patchWithPrintJobSettings(this);
  }

  PrintJobSettingsPatch withHandledByClient(bool? value) {
    patchMap[PrintJobSettings$.handledByClient] = value;
    return this;
  }

  PrintJobSettingsPatch withJobName(String? value) {
    patchMap[PrintJobSettings$.jobName] = value;
    return this;
  }

  PrintJobSettingsPatch withDetailedErrorReporting(bool? value) {
    patchMap[PrintJobSettings$.detailedErrorReporting] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPrintPanel(bool? value) {
    patchMap[PrintJobSettings$.showsPrintPanel] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsProgressPanel(bool? value) {
    patchMap[PrintJobSettings$.showsProgressPanel] = value;
    return this;
  }

  PrintJobSettingsPatch withJobSavingURL(WebUri? value) {
    patchMap[PrintJobSettings$.jobSavingURL] = value;
    return this;
  }

  PrintJobSettingsPatch withJobDisposition(PrintJobDisposition? value) {
    patchMap[PrintJobSettings$.jobDisposition] = value;
    return this;
  }

  PrintJobSettingsPatch withPaperName(String? value) {
    patchMap[PrintJobSettings$.paperName] = value;
    return this;
  }

  PrintJobSettingsPatch withHorizontalPagination(
    PrintJobPaginationMode? value,
  ) {
    patchMap[PrintJobSettings$.horizontalPagination] = value;
    return this;
  }

  PrintJobSettingsPatch withVerticalPagination(PrintJobPaginationMode? value) {
    patchMap[PrintJobSettings$.verticalPagination] = value;
    return this;
  }

  PrintJobSettingsPatch withIsHorizontallyCentered(bool? value) {
    patchMap[PrintJobSettings$.isHorizontallyCentered] = value;
    return this;
  }

  PrintJobSettingsPatch withIsVerticallyCentered(bool? value) {
    patchMap[PrintJobSettings$.isVerticallyCentered] = value;
    return this;
  }

  PrintJobSettingsPatch withMaximumContentHeight(double? value) {
    patchMap[PrintJobSettings$.maximumContentHeight] = value;
    return this;
  }

  PrintJobSettingsPatch withMaximumContentWidth(double? value) {
    patchMap[PrintJobSettings$.maximumContentWidth] = value;
    return this;
  }

  PrintJobSettingsPatch withMargins(EdgeInsets? value) {
    patchMap[PrintJobSettings$.margins] = value;
    return this;
  }

  PrintJobSettingsPatch withFirstPage(int? value) {
    patchMap[PrintJobSettings$.firstPage] = value;
    return this;
  }

  PrintJobSettingsPatch withLastPage(int? value) {
    patchMap[PrintJobSettings$.lastPage] = value;
    return this;
  }

  PrintJobSettingsPatch withHeaderAndFooter(bool? value) {
    patchMap[PrintJobSettings$.headerAndFooter] = value;
    return this;
  }

  PrintJobSettingsPatch withHeaderHeight(double? value) {
    patchMap[PrintJobSettings$.headerHeight] = value;
    return this;
  }

  PrintJobSettingsPatch withFooterHeight(double? value) {
    patchMap[PrintJobSettings$.footerHeight] = value;
    return this;
  }

  PrintJobSettingsPatch withTime(int? value) {
    patchMap[PrintJobSettings$.time] = value;
    return this;
  }

  PrintJobSettingsPatch withOrientation(PrintJobOrientation? value) {
    patchMap[PrintJobSettings$.orientation] = value;
    return this;
  }

  PrintJobSettingsPatch withColorMode(PrintJobColorMode? value) {
    patchMap[PrintJobSettings$.colorMode] = value;
    return this;
  }

  PrintJobSettingsPatch withDuplexMode(PrintJobDuplexMode? value) {
    patchMap[PrintJobSettings$.duplexMode] = value;
    return this;
  }

  PrintJobSettingsPatch withMediaSize(PrintJobMediaSize? value) {
    patchMap[PrintJobSettings$.mediaSize] = value;
    return this;
  }

  PrintJobSettingsPatch withMediaSizePatch(PrintJobMediaSizePatch patch) {
    patchMap[PrintJobSettings$.mediaSize] = patch;
    return this;
  }

  PrintJobSettingsPatch withMediaSizePatchFunc(
    PrintJobMediaSizePatch Function(PrintJobMediaSizePatch) patch,
  ) {
    patchMap[PrintJobSettings$.mediaSize] = (dynamic current) {
      var currentPatch = PrintJobMediaSizePatch();
      return patch(currentPatch).applyTo(current as PrintJobMediaSize);
    };
    return this;
  }

  PrintJobSettingsPatch withResolution(PrintJobResolution? value) {
    patchMap[PrintJobSettings$.resolution] = value;
    return this;
  }

  PrintJobSettingsPatch withResolutionPatch(PrintJobResolutionPatch patch) {
    patchMap[PrintJobSettings$.resolution] = patch;
    return this;
  }

  PrintJobSettingsPatch withResolutionPatchFunc(
    PrintJobResolutionPatch Function(PrintJobResolutionPatch) patch,
  ) {
    patchMap[PrintJobSettings$.resolution] = (dynamic current) {
      var currentPatch = PrintJobResolutionPatch();
      return patch(currentPatch).applyTo(current as PrintJobResolution);
    };
    return this;
  }

  PrintJobSettingsPatch withFaxNumber(String? value) {
    patchMap[PrintJobSettings$.faxNumber] = value;
    return this;
  }

  PrintJobSettingsPatch withCopies(int? value) {
    patchMap[PrintJobSettings$.copies] = value;
    return this;
  }

  PrintJobSettingsPatch withNumberOfPages(int? value) {
    patchMap[PrintJobSettings$.numberOfPages] = value;
    return this;
  }

  PrintJobSettingsPatch withMustCollate(bool? value) {
    patchMap[PrintJobSettings$.mustCollate] = value;
    return this;
  }

  PrintJobSettingsPatch withPagesAcross(String? value) {
    patchMap[PrintJobSettings$.pagesAcross] = value;
    return this;
  }

  PrintJobSettingsPatch withPagesDown(String? value) {
    patchMap[PrintJobSettings$.pagesDown] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPreview(bool? value) {
    patchMap[PrintJobSettings$.showsPreview] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPrintSelection(bool? value) {
    patchMap[PrintJobSettings$.showsPrintSelection] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPageRange(bool? value) {
    patchMap[PrintJobSettings$.showsPageRange] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsNumberOfCopies(bool? value) {
    patchMap[PrintJobSettings$.showsNumberOfCopies] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPaperOrientation(bool? value) {
    patchMap[PrintJobSettings$.showsPaperOrientation] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPaperSelectionForLoadedPapers(bool? value) {
    patchMap[PrintJobSettings$.showsPaperSelectionForLoadedPapers] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPaperSize(bool? value) {
    patchMap[PrintJobSettings$.showsPaperSize] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsScaling(bool? value) {
    patchMap[PrintJobSettings$.showsScaling] = value;
    return this;
  }

  PrintJobSettingsPatch withShowsPageSetupAccessory(bool? value) {
    patchMap[PrintJobSettings$.showsPageSetupAccessory] = value;
    return this;
  }

  PrintJobSettingsPatch withScalingFactor(double? value) {
    patchMap[PrintJobSettings$.scalingFactor] = value;
    return this;
  }

  PrintJobSettingsPatch withForceRenderingQuality(
    PrintJobRenderingQuality? value,
  ) {
    patchMap[PrintJobSettings$.forceRenderingQuality] = value;
    return this;
  }

  PrintJobSettingsPatch withAnimated(bool? value) {
    patchMap[PrintJobSettings$.animated] = value;
    return this;
  }

  PrintJobSettingsPatch withCanSpawnSeparateThread(bool? value) {
    patchMap[PrintJobSettings$.canSpawnSeparateThread] = value;
    return this;
  }

  PrintJobSettingsPatch withOutputType(PrintJobOutputType? value) {
    patchMap[PrintJobSettings$.outputType] = value;
    return this;
  }

  PrintJobSettingsPatch withPageOrder(PrintJobPageOrder? value) {
    patchMap[PrintJobSettings$.pageOrder] = value;
    return this;
  }
}

/// Field descriptors for [PrintJobSettings] query construction
abstract final class PrintJobSettingsFields {
  static const handledByClient = Field<PrintJobSettings, bool?>(
    'handledByClient',
    _$handledByClient,
  );

  static const jobName = Field<PrintJobSettings, String?>('jobName', _$jobName);

  static const detailedErrorReporting = Field<PrintJobSettings, bool?>(
    'detailedErrorReporting',
    _$detailedErrorReporting,
  );

  static const showsPrintPanel = Field<PrintJobSettings, bool?>(
    'showsPrintPanel',
    _$showsPrintPanel,
  );

  static const showsProgressPanel = Field<PrintJobSettings, bool?>(
    'showsProgressPanel',
    _$showsProgressPanel,
  );

  static const jobSavingURL = Field<PrintJobSettings, WebUri?>(
    'jobSavingURL',
    _$jobSavingURL,
  );

  static const jobDisposition = Field<PrintJobSettings, PrintJobDisposition?>(
    'jobDisposition',
    _$jobDisposition,
  );

  static const paperName = Field<PrintJobSettings, String?>(
    'paperName',
    _$paperName,
  );

  static const horizontalPagination =
      Field<PrintJobSettings, PrintJobPaginationMode?>(
        'horizontalPagination',
        _$horizontalPagination,
      );

  static const verticalPagination =
      Field<PrintJobSettings, PrintJobPaginationMode?>(
        'verticalPagination',
        _$verticalPagination,
      );

  static const isHorizontallyCentered = Field<PrintJobSettings, bool?>(
    'isHorizontallyCentered',
    _$isHorizontallyCentered,
  );

  static const isVerticallyCentered = Field<PrintJobSettings, bool?>(
    'isVerticallyCentered',
    _$isVerticallyCentered,
  );

  static const maximumContentHeight = Field<PrintJobSettings, double?>(
    'maximumContentHeight',
    _$maximumContentHeight,
  );

  static const maximumContentWidth = Field<PrintJobSettings, double?>(
    'maximumContentWidth',
    _$maximumContentWidth,
  );

  static const margins = Field<PrintJobSettings, EdgeInsets?>(
    'margins',
    _$margins,
  );

  static const firstPage = Field<PrintJobSettings, int?>(
    'firstPage',
    _$firstPage,
  );

  static const lastPage = Field<PrintJobSettings, int?>('lastPage', _$lastPage);

  static const headerAndFooter = Field<PrintJobSettings, bool?>(
    'headerAndFooter',
    _$headerAndFooter,
  );

  static const headerHeight = Field<PrintJobSettings, double?>(
    'headerHeight',
    _$headerHeight,
  );

  static const footerHeight = Field<PrintJobSettings, double?>(
    'footerHeight',
    _$footerHeight,
  );

  static const time = Field<PrintJobSettings, int?>('time', _$time);

  static const orientation = Field<PrintJobSettings, PrintJobOrientation?>(
    'orientation',
    _$orientation,
  );

  static const colorMode = Field<PrintJobSettings, PrintJobColorMode?>(
    'colorMode',
    _$colorMode,
  );

  static const duplexMode = Field<PrintJobSettings, PrintJobDuplexMode?>(
    'duplexMode',
    _$duplexMode,
  );

  static const mediaSize = Field<PrintJobSettings, PrintJobMediaSize?>(
    'mediaSize',
    _$mediaSize,
  );

  static const resolution = Field<PrintJobSettings, PrintJobResolution?>(
    'resolution',
    _$resolution,
  );

  static const faxNumber = Field<PrintJobSettings, String?>(
    'faxNumber',
    _$faxNumber,
  );

  static const copies = Field<PrintJobSettings, int?>('copies', _$copies);

  static const numberOfPages = Field<PrintJobSettings, int?>(
    'numberOfPages',
    _$numberOfPages,
  );

  static const mustCollate = Field<PrintJobSettings, bool?>(
    'mustCollate',
    _$mustCollate,
  );

  static const pagesAcross = Field<PrintJobSettings, String?>(
    'pagesAcross',
    _$pagesAcross,
  );

  static const pagesDown = Field<PrintJobSettings, String?>(
    'pagesDown',
    _$pagesDown,
  );

  static const showsPreview = Field<PrintJobSettings, bool?>(
    'showsPreview',
    _$showsPreview,
  );

  static const showsPrintSelection = Field<PrintJobSettings, bool?>(
    'showsPrintSelection',
    _$showsPrintSelection,
  );

  static const showsPageRange = Field<PrintJobSettings, bool?>(
    'showsPageRange',
    _$showsPageRange,
  );

  static const showsNumberOfCopies = Field<PrintJobSettings, bool?>(
    'showsNumberOfCopies',
    _$showsNumberOfCopies,
  );

  static const showsPaperOrientation = Field<PrintJobSettings, bool?>(
    'showsPaperOrientation',
    _$showsPaperOrientation,
  );

  static const showsPaperSelectionForLoadedPapers =
      Field<PrintJobSettings, bool?>(
        'showsPaperSelectionForLoadedPapers',
        _$showsPaperSelectionForLoadedPapers,
      );

  static const showsPaperSize = Field<PrintJobSettings, bool?>(
    'showsPaperSize',
    _$showsPaperSize,
  );

  static const showsScaling = Field<PrintJobSettings, bool?>(
    'showsScaling',
    _$showsScaling,
  );

  static const showsPageSetupAccessory = Field<PrintJobSettings, bool?>(
    'showsPageSetupAccessory',
    _$showsPageSetupAccessory,
  );

  static const scalingFactor = Field<PrintJobSettings, double?>(
    'scalingFactor',
    _$scalingFactor,
  );

  static const forceRenderingQuality =
      Field<PrintJobSettings, PrintJobRenderingQuality?>(
        'forceRenderingQuality',
        _$forceRenderingQuality,
      );

  static const animated = Field<PrintJobSettings, bool?>(
    'animated',
    _$animated,
  );

  static const canSpawnSeparateThread = Field<PrintJobSettings, bool?>(
    'canSpawnSeparateThread',
    _$canSpawnSeparateThread,
  );

  static const outputType = Field<PrintJobSettings, PrintJobOutputType?>(
    'outputType',
    _$outputType,
  );

  static const pageOrder = Field<PrintJobSettings, PrintJobPageOrder?>(
    'pageOrder',
    _$pageOrder,
  );

  static bool? _$handledByClient(PrintJobSettings e) {
    return e.handledByClient;
  }

  static String? _$jobName(PrintJobSettings e) {
    return e.jobName;
  }

  static bool? _$detailedErrorReporting(PrintJobSettings e) {
    return e.detailedErrorReporting;
  }

  static bool? _$showsPrintPanel(PrintJobSettings e) {
    return e.showsPrintPanel;
  }

  static bool? _$showsProgressPanel(PrintJobSettings e) {
    return e.showsProgressPanel;
  }

  static WebUri? _$jobSavingURL(PrintJobSettings e) {
    return e.jobSavingURL;
  }

  static PrintJobDisposition? _$jobDisposition(PrintJobSettings e) {
    return e.jobDisposition;
  }

  static String? _$paperName(PrintJobSettings e) {
    return e.paperName;
  }

  static PrintJobPaginationMode? _$horizontalPagination(PrintJobSettings e) {
    return e.horizontalPagination;
  }

  static PrintJobPaginationMode? _$verticalPagination(PrintJobSettings e) {
    return e.verticalPagination;
  }

  static bool? _$isHorizontallyCentered(PrintJobSettings e) {
    return e.isHorizontallyCentered;
  }

  static bool? _$isVerticallyCentered(PrintJobSettings e) {
    return e.isVerticallyCentered;
  }

  static double? _$maximumContentHeight(PrintJobSettings e) {
    return e.maximumContentHeight;
  }

  static double? _$maximumContentWidth(PrintJobSettings e) {
    return e.maximumContentWidth;
  }

  static EdgeInsets? _$margins(PrintJobSettings e) {
    return e.margins;
  }

  static int? _$firstPage(PrintJobSettings e) {
    return e.firstPage;
  }

  static int? _$lastPage(PrintJobSettings e) {
    return e.lastPage;
  }

  static bool? _$headerAndFooter(PrintJobSettings e) {
    return e.headerAndFooter;
  }

  static double? _$headerHeight(PrintJobSettings e) {
    return e.headerHeight;
  }

  static double? _$footerHeight(PrintJobSettings e) {
    return e.footerHeight;
  }

  static int? _$time(PrintJobSettings e) {
    return e.time;
  }

  static PrintJobOrientation? _$orientation(PrintJobSettings e) {
    return e.orientation;
  }

  static PrintJobColorMode? _$colorMode(PrintJobSettings e) {
    return e.colorMode;
  }

  static PrintJobDuplexMode? _$duplexMode(PrintJobSettings e) {
    return e.duplexMode;
  }

  static PrintJobMediaSize? _$mediaSize(PrintJobSettings e) {
    return e.mediaSize;
  }

  static PrintJobResolution? _$resolution(PrintJobSettings e) {
    return e.resolution;
  }

  static String? _$faxNumber(PrintJobSettings e) {
    return e.faxNumber;
  }

  static int? _$copies(PrintJobSettings e) {
    return e.copies;
  }

  static int? _$numberOfPages(PrintJobSettings e) {
    return e.numberOfPages;
  }

  static bool? _$mustCollate(PrintJobSettings e) {
    return e.mustCollate;
  }

  static String? _$pagesAcross(PrintJobSettings e) {
    return e.pagesAcross;
  }

  static String? _$pagesDown(PrintJobSettings e) {
    return e.pagesDown;
  }

  static bool? _$showsPreview(PrintJobSettings e) {
    return e.showsPreview;
  }

  static bool? _$showsPrintSelection(PrintJobSettings e) {
    return e.showsPrintSelection;
  }

  static bool? _$showsPageRange(PrintJobSettings e) {
    return e.showsPageRange;
  }

  static bool? _$showsNumberOfCopies(PrintJobSettings e) {
    return e.showsNumberOfCopies;
  }

  static bool? _$showsPaperOrientation(PrintJobSettings e) {
    return e.showsPaperOrientation;
  }

  static bool? _$showsPaperSelectionForLoadedPapers(PrintJobSettings e) {
    return e.showsPaperSelectionForLoadedPapers;
  }

  static bool? _$showsPaperSize(PrintJobSettings e) {
    return e.showsPaperSize;
  }

  static bool? _$showsScaling(PrintJobSettings e) {
    return e.showsScaling;
  }

  static bool? _$showsPageSetupAccessory(PrintJobSettings e) {
    return e.showsPageSetupAccessory;
  }

  static double? _$scalingFactor(PrintJobSettings e) {
    return e.scalingFactor;
  }

  static PrintJobRenderingQuality? _$forceRenderingQuality(PrintJobSettings e) {
    return e.forceRenderingQuality;
  }

  static bool? _$animated(PrintJobSettings e) {
    return e.animated;
  }

  static bool? _$canSpawnSeparateThread(PrintJobSettings e) {
    return e.canSpawnSeparateThread;
  }

  static PrintJobOutputType? _$outputType(PrintJobSettings e) {
    return e.outputType;
  }

  static PrintJobPageOrder? _$pageOrder(PrintJobSettings e) {
    return e.pageOrder;
  }
}

extension PrintJobSettingsCompareE on PrintJobSettings {
  Map<String, dynamic> compareToPrintJobSettings(PrintJobSettings other) {
    final Map<String, dynamic> diff = {};

    if (handledByClient != other.handledByClient) {
      diff['handledByClient'] = () => other.handledByClient;
    }

    if (jobName != other.jobName) {
      diff['jobName'] = () => other.jobName;
    }

    if (detailedErrorReporting != other.detailedErrorReporting) {
      diff['detailedErrorReporting'] = () => other.detailedErrorReporting;
    }

    if (showsPrintPanel != other.showsPrintPanel) {
      diff['showsPrintPanel'] = () => other.showsPrintPanel;
    }

    if (showsProgressPanel != other.showsProgressPanel) {
      diff['showsProgressPanel'] = () => other.showsProgressPanel;
    }

    if (jobSavingURL != other.jobSavingURL) {
      diff['jobSavingURL'] = () => other.jobSavingURL;
    }

    if (jobDisposition != other.jobDisposition) {
      diff['jobDisposition'] = () => other.jobDisposition;
    }

    if (paperName != other.paperName) {
      diff['paperName'] = () => other.paperName;
    }

    if (horizontalPagination != other.horizontalPagination) {
      diff['horizontalPagination'] = () => other.horizontalPagination;
    }

    if (verticalPagination != other.verticalPagination) {
      diff['verticalPagination'] = () => other.verticalPagination;
    }

    if (isHorizontallyCentered != other.isHorizontallyCentered) {
      diff['isHorizontallyCentered'] = () => other.isHorizontallyCentered;
    }

    if (isVerticallyCentered != other.isVerticallyCentered) {
      diff['isVerticallyCentered'] = () => other.isVerticallyCentered;
    }

    if (maximumContentHeight != other.maximumContentHeight) {
      diff['maximumContentHeight'] = () => other.maximumContentHeight;
    }

    if (maximumContentWidth != other.maximumContentWidth) {
      diff['maximumContentWidth'] = () => other.maximumContentWidth;
    }

    if (margins != other.margins) {
      diff['margins'] = () => other.margins;
    }

    if (firstPage != other.firstPage) {
      diff['firstPage'] = () => other.firstPage;
    }

    if (lastPage != other.lastPage) {
      diff['lastPage'] = () => other.lastPage;
    }

    if (headerAndFooter != other.headerAndFooter) {
      diff['headerAndFooter'] = () => other.headerAndFooter;
    }

    if (headerHeight != other.headerHeight) {
      diff['headerHeight'] = () => other.headerHeight;
    }

    if (footerHeight != other.footerHeight) {
      diff['footerHeight'] = () => other.footerHeight;
    }

    if (time != other.time) {
      diff['time'] = () => other.time;
    }

    if (orientation != other.orientation) {
      diff['orientation'] = () => other.orientation;
    }

    if (colorMode != other.colorMode) {
      diff['colorMode'] = () => other.colorMode;
    }

    if (duplexMode != other.duplexMode) {
      diff['duplexMode'] = () => other.duplexMode;
    }

    if (mediaSize != other.mediaSize) {
      diff['mediaSize'] = () => other.mediaSize;
    }

    if (resolution != other.resolution) {
      diff['resolution'] = () => other.resolution;
    }

    if (faxNumber != other.faxNumber) {
      diff['faxNumber'] = () => other.faxNumber;
    }

    if (copies != other.copies) {
      diff['copies'] = () => other.copies;
    }

    if (numberOfPages != other.numberOfPages) {
      diff['numberOfPages'] = () => other.numberOfPages;
    }

    if (mustCollate != other.mustCollate) {
      diff['mustCollate'] = () => other.mustCollate;
    }

    if (pagesAcross != other.pagesAcross) {
      diff['pagesAcross'] = () => other.pagesAcross;
    }

    if (pagesDown != other.pagesDown) {
      diff['pagesDown'] = () => other.pagesDown;
    }

    if (showsPreview != other.showsPreview) {
      diff['showsPreview'] = () => other.showsPreview;
    }

    if (showsPrintSelection != other.showsPrintSelection) {
      diff['showsPrintSelection'] = () => other.showsPrintSelection;
    }

    if (showsPageRange != other.showsPageRange) {
      diff['showsPageRange'] = () => other.showsPageRange;
    }

    if (showsNumberOfCopies != other.showsNumberOfCopies) {
      diff['showsNumberOfCopies'] = () => other.showsNumberOfCopies;
    }

    if (showsPaperOrientation != other.showsPaperOrientation) {
      diff['showsPaperOrientation'] = () => other.showsPaperOrientation;
    }

    if (showsPaperSelectionForLoadedPapers !=
        other.showsPaperSelectionForLoadedPapers) {
      diff['showsPaperSelectionForLoadedPapers'] = () =>
          other.showsPaperSelectionForLoadedPapers;
    }

    if (showsPaperSize != other.showsPaperSize) {
      diff['showsPaperSize'] = () => other.showsPaperSize;
    }

    if (showsScaling != other.showsScaling) {
      diff['showsScaling'] = () => other.showsScaling;
    }

    if (showsPageSetupAccessory != other.showsPageSetupAccessory) {
      diff['showsPageSetupAccessory'] = () => other.showsPageSetupAccessory;
    }

    if (scalingFactor != other.scalingFactor) {
      diff['scalingFactor'] = () => other.scalingFactor;
    }

    if (forceRenderingQuality != other.forceRenderingQuality) {
      diff['forceRenderingQuality'] = () => other.forceRenderingQuality;
    }

    if (animated != other.animated) {
      diff['animated'] = () => other.animated;
    }

    if (canSpawnSeparateThread != other.canSpawnSeparateThread) {
      diff['canSpawnSeparateThread'] = () => other.canSpawnSeparateThread;
    }

    if (outputType != other.outputType) {
      diff['outputType'] = () => other.outputType;
    }

    if (pageOrder != other.pageOrder) {
      diff['pageOrder'] = () => other.pageOrder;
    }
    return diff;
  }
}
