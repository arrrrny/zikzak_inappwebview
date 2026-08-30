// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'print_job_attributes.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PrintJobAttributes {
  PrintJobAttributes({
    PrintJobColorMode? this.colorMode,
    PrintJobDuplexMode? this.duplexMode,
    PrintJobOrientation? this.orientation,
    PrintJobMediaSize? this.mediaSize,
    PrintJobResolution? this.resolution,
    EdgeInsets? this.margins,
    double? this.footerHeight,
    double? this.headerHeight,
    String? this.paperName,
    String? this.localizedPaperName,
    InAppWebViewRect? this.printableRect,
    InAppWebViewRect? this.paperRect,
    bool? this.detailedErrorReporting,
    String? this.faxNumber,
    bool? this.headerAndFooter,
    PrintJobPaginationMode? this.horizontalPagination,
    bool? this.isHorizontallyCentered,
    bool? this.isVerticallyCentered,
    PrintJobDisposition? this.jobDisposition,
    WebUri? this.jobSavingURL,
    PrintJobPaginationMode? this.verticalPagination,
    double? this.maximumContentHeight,
    double? this.maximumContentWidth,
    int? this.firstPage,
    int? this.lastPage,
  });

  factory PrintJobAttributes.fromJson(Map<String, dynamic> json) =>
      _$PrintJobAttributesFromJson(json);

  @JsonKey(toJson: _colorModeToJson, fromJson: _colorModeFromJson)
  final PrintJobColorMode? colorMode;

  @JsonKey(toJson: _duplexModeToJson, fromJson: _duplexModeFromJson)
  final PrintJobDuplexMode? duplexMode;

  @JsonKey(toJson: _orientationToJson, fromJson: _orientationFromJson)
  final PrintJobOrientation? orientation;

  @JsonKey(toJson: _mediaSizeToJson, fromJson: _mediaSizeFromJson)
  final PrintJobMediaSize? mediaSize;

  @JsonKey(toJson: _resolutionToJson, fromJson: _resolutionFromJson)
  final PrintJobResolution? resolution;

  @JsonKey(toJson: _marginsToJson, fromJson: _marginsFromJson)
  final EdgeInsets? margins;

  final double? footerHeight;

  final double? headerHeight;

  final String? paperName;

  final String? localizedPaperName;

  @JsonKey(toJson: _printableRectToJson, fromJson: _printableRectFromJson)
  final InAppWebViewRect? printableRect;

  @JsonKey(toJson: _paperRectToJson, fromJson: _paperRectFromJson)
  final InAppWebViewRect? paperRect;

  final bool? detailedErrorReporting;

  final String? faxNumber;

  final bool? headerAndFooter;

  @JsonKey(
    toJson: _horizontalPaginationToJson,
    fromJson: _horizontalPaginationFromJson,
  )
  final PrintJobPaginationMode? horizontalPagination;

  final bool? isHorizontallyCentered;

  final bool? isVerticallyCentered;

  @JsonKey(toJson: _jobDispositionToJson, fromJson: _jobDispositionFromJson)
  final PrintJobDisposition? jobDisposition;

  @JsonKey(toJson: _jobSavingURLToJson, fromJson: _jobSavingURLFromJson)
  final WebUri? jobSavingURL;

  @JsonKey(
    toJson: _verticalPaginationToJson,
    fromJson: _verticalPaginationFromJson,
  )
  final PrintJobPaginationMode? verticalPagination;

  final double? maximumContentHeight;

  final double? maximumContentWidth;

  final int? firstPage;

  final int? lastPage;

  PrintJobAttributes copyWith({
    PrintJobColorMode? colorMode,
    PrintJobDuplexMode? duplexMode,
    PrintJobOrientation? orientation,
    PrintJobMediaSize? mediaSize,
    PrintJobResolution? resolution,
    EdgeInsets? margins,
    double? footerHeight,
    double? headerHeight,
    String? paperName,
    String? localizedPaperName,
    InAppWebViewRect? printableRect,
    InAppWebViewRect? paperRect,
    bool? detailedErrorReporting,
    String? faxNumber,
    bool? headerAndFooter,
    PrintJobPaginationMode? horizontalPagination,
    bool? isHorizontallyCentered,
    bool? isVerticallyCentered,
    PrintJobDisposition? jobDisposition,
    WebUri? jobSavingURL,
    PrintJobPaginationMode? verticalPagination,
    double? maximumContentHeight,
    double? maximumContentWidth,
    int? firstPage,
    int? lastPage,
  }) {
    return PrintJobAttributes(
      colorMode: colorMode ?? this.colorMode,
      duplexMode: duplexMode ?? this.duplexMode,
      orientation: orientation ?? this.orientation,
      mediaSize: mediaSize ?? this.mediaSize,
      resolution: resolution ?? this.resolution,
      margins: margins ?? this.margins,
      footerHeight: footerHeight ?? this.footerHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      paperName: paperName ?? this.paperName,
      localizedPaperName: localizedPaperName ?? this.localizedPaperName,
      printableRect: printableRect ?? this.printableRect,
      paperRect: paperRect ?? this.paperRect,
      detailedErrorReporting:
          detailedErrorReporting ?? this.detailedErrorReporting,
      faxNumber: faxNumber ?? this.faxNumber,
      headerAndFooter: headerAndFooter ?? this.headerAndFooter,
      horizontalPagination: horizontalPagination ?? this.horizontalPagination,
      isHorizontallyCentered:
          isHorizontallyCentered ?? this.isHorizontallyCentered,
      isVerticallyCentered: isVerticallyCentered ?? this.isVerticallyCentered,
      jobDisposition: jobDisposition ?? this.jobDisposition,
      jobSavingURL: jobSavingURL ?? this.jobSavingURL,
      verticalPagination: verticalPagination ?? this.verticalPagination,
      maximumContentHeight: maximumContentHeight ?? this.maximumContentHeight,
      maximumContentWidth: maximumContentWidth ?? this.maximumContentWidth,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
    );
  }

  PrintJobAttributes copyWithPrintJobAttributes({
    PrintJobColorMode? colorMode,
    PrintJobDuplexMode? duplexMode,
    PrintJobOrientation? orientation,
    PrintJobMediaSize? mediaSize,
    PrintJobResolution? resolution,
    EdgeInsets? margins,
    double? footerHeight,
    double? headerHeight,
    String? paperName,
    String? localizedPaperName,
    InAppWebViewRect? printableRect,
    InAppWebViewRect? paperRect,
    bool? detailedErrorReporting,
    String? faxNumber,
    bool? headerAndFooter,
    PrintJobPaginationMode? horizontalPagination,
    bool? isHorizontallyCentered,
    bool? isVerticallyCentered,
    PrintJobDisposition? jobDisposition,
    WebUri? jobSavingURL,
    PrintJobPaginationMode? verticalPagination,
    double? maximumContentHeight,
    double? maximumContentWidth,
    int? firstPage,
    int? lastPage,
  }) {
    return copyWith(
      colorMode: colorMode,
      duplexMode: duplexMode,
      orientation: orientation,
      mediaSize: mediaSize,
      resolution: resolution,
      margins: margins,
      footerHeight: footerHeight,
      headerHeight: headerHeight,
      paperName: paperName,
      localizedPaperName: localizedPaperName,
      printableRect: printableRect,
      paperRect: paperRect,
      detailedErrorReporting: detailedErrorReporting,
      faxNumber: faxNumber,
      headerAndFooter: headerAndFooter,
      horizontalPagination: horizontalPagination,
      isHorizontallyCentered: isHorizontallyCentered,
      isVerticallyCentered: isVerticallyCentered,
      jobDisposition: jobDisposition,
      jobSavingURL: jobSavingURL,
      verticalPagination: verticalPagination,
      maximumContentHeight: maximumContentHeight,
      maximumContentWidth: maximumContentWidth,
      firstPage: firstPage,
      lastPage: lastPage,
    );
  }

  PrintJobAttributes patchWithPrintJobAttributes([
    PrintJobAttributesPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PrintJobAttributesPatch();
    final _patchMap = _patcher.patchMap;
    return PrintJobAttributes(
      colorMode: _patchMap.containsKey(PrintJobAttributes$.colorMode)
          ? ((_patchMap[PrintJobAttributes$.colorMode] is Function)
                    ? _patchMap[PrintJobAttributes$.colorMode](this.colorMode)
                    : (_patchMap[PrintJobAttributes$.colorMode] is Patch)
                    ? _patchMap[PrintJobAttributes$.colorMode].applyTo(
                        this.colorMode,
                      )
                    : _patchMap[PrintJobAttributes$.colorMode])
                as PrintJobColorMode?
          : this.colorMode,
      duplexMode: _patchMap.containsKey(PrintJobAttributes$.duplexMode)
          ? ((_patchMap[PrintJobAttributes$.duplexMode] is Function)
                    ? _patchMap[PrintJobAttributes$.duplexMode](this.duplexMode)
                    : (_patchMap[PrintJobAttributes$.duplexMode] is Patch)
                    ? _patchMap[PrintJobAttributes$.duplexMode].applyTo(
                        this.duplexMode,
                      )
                    : _patchMap[PrintJobAttributes$.duplexMode])
                as PrintJobDuplexMode?
          : this.duplexMode,
      orientation: _patchMap.containsKey(PrintJobAttributes$.orientation)
          ? ((_patchMap[PrintJobAttributes$.orientation] is Function)
                    ? _patchMap[PrintJobAttributes$.orientation](
                        this.orientation,
                      )
                    : (_patchMap[PrintJobAttributes$.orientation] is Patch)
                    ? _patchMap[PrintJobAttributes$.orientation].applyTo(
                        this.orientation,
                      )
                    : _patchMap[PrintJobAttributes$.orientation])
                as PrintJobOrientation?
          : this.orientation,
      mediaSize: _patchMap.containsKey(PrintJobAttributes$.mediaSize)
          ? ((_patchMap[PrintJobAttributes$.mediaSize] is Function)
                    ? _patchMap[PrintJobAttributes$.mediaSize](this.mediaSize)
                    : (_patchMap[PrintJobAttributes$.mediaSize] is Patch)
                    ? _patchMap[PrintJobAttributes$.mediaSize].applyTo(
                        this.mediaSize,
                      )
                    : _patchMap[PrintJobAttributes$.mediaSize])
                as PrintJobMediaSize?
          : this.mediaSize,
      resolution: _patchMap.containsKey(PrintJobAttributes$.resolution)
          ? ((_patchMap[PrintJobAttributes$.resolution] is Function)
                    ? _patchMap[PrintJobAttributes$.resolution](this.resolution)
                    : (_patchMap[PrintJobAttributes$.resolution] is Patch)
                    ? _patchMap[PrintJobAttributes$.resolution].applyTo(
                        this.resolution,
                      )
                    : _patchMap[PrintJobAttributes$.resolution])
                as PrintJobResolution?
          : this.resolution,
      margins: _patchMap.containsKey(PrintJobAttributes$.margins)
          ? ((_patchMap[PrintJobAttributes$.margins] is Function)
                    ? _patchMap[PrintJobAttributes$.margins](this.margins)
                    : (_patchMap[PrintJobAttributes$.margins] is Patch)
                    ? _patchMap[PrintJobAttributes$.margins].applyTo(
                        this.margins,
                      )
                    : _patchMap[PrintJobAttributes$.margins])
                as EdgeInsets?
          : this.margins,
      footerHeight: _patchMap.containsKey(PrintJobAttributes$.footerHeight)
          ? ((_patchMap[PrintJobAttributes$.footerHeight] is Function)
                    ? _patchMap[PrintJobAttributes$.footerHeight](
                        this.footerHeight,
                      )
                    : (_patchMap[PrintJobAttributes$.footerHeight] is Patch)
                    ? _patchMap[PrintJobAttributes$.footerHeight].applyTo(
                        this.footerHeight,
                      )
                    : _patchMap[PrintJobAttributes$.footerHeight])
                as double?
          : this.footerHeight,
      headerHeight: _patchMap.containsKey(PrintJobAttributes$.headerHeight)
          ? ((_patchMap[PrintJobAttributes$.headerHeight] is Function)
                    ? _patchMap[PrintJobAttributes$.headerHeight](
                        this.headerHeight,
                      )
                    : (_patchMap[PrintJobAttributes$.headerHeight] is Patch)
                    ? _patchMap[PrintJobAttributes$.headerHeight].applyTo(
                        this.headerHeight,
                      )
                    : _patchMap[PrintJobAttributes$.headerHeight])
                as double?
          : this.headerHeight,
      paperName: _patchMap.containsKey(PrintJobAttributes$.paperName)
          ? ((_patchMap[PrintJobAttributes$.paperName] is Function)
                    ? _patchMap[PrintJobAttributes$.paperName](this.paperName)
                    : (_patchMap[PrintJobAttributes$.paperName] is Patch)
                    ? _patchMap[PrintJobAttributes$.paperName].applyTo(
                        this.paperName,
                      )
                    : _patchMap[PrintJobAttributes$.paperName])
                as String?
          : this.paperName,
      localizedPaperName:
          _patchMap.containsKey(PrintJobAttributes$.localizedPaperName)
          ? ((_patchMap[PrintJobAttributes$.localizedPaperName] is Function)
                    ? _patchMap[PrintJobAttributes$.localizedPaperName](
                        this.localizedPaperName,
                      )
                    : (_patchMap[PrintJobAttributes$.localizedPaperName]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.localizedPaperName].applyTo(
                        this.localizedPaperName,
                      )
                    : _patchMap[PrintJobAttributes$.localizedPaperName])
                as String?
          : this.localizedPaperName,
      printableRect: _patchMap.containsKey(PrintJobAttributes$.printableRect)
          ? ((_patchMap[PrintJobAttributes$.printableRect] is Function)
                    ? _patchMap[PrintJobAttributes$.printableRect](
                        this.printableRect,
                      )
                    : (_patchMap[PrintJobAttributes$.printableRect] is Patch)
                    ? _patchMap[PrintJobAttributes$.printableRect].applyTo(
                        this.printableRect,
                      )
                    : _patchMap[PrintJobAttributes$.printableRect])
                as InAppWebViewRect?
          : this.printableRect,
      paperRect: _patchMap.containsKey(PrintJobAttributes$.paperRect)
          ? ((_patchMap[PrintJobAttributes$.paperRect] is Function)
                    ? _patchMap[PrintJobAttributes$.paperRect](this.paperRect)
                    : (_patchMap[PrintJobAttributes$.paperRect] is Patch)
                    ? _patchMap[PrintJobAttributes$.paperRect].applyTo(
                        this.paperRect,
                      )
                    : _patchMap[PrintJobAttributes$.paperRect])
                as InAppWebViewRect?
          : this.paperRect,
      detailedErrorReporting:
          _patchMap.containsKey(PrintJobAttributes$.detailedErrorReporting)
          ? ((_patchMap[PrintJobAttributes$.detailedErrorReporting] is Function)
                    ? _patchMap[PrintJobAttributes$.detailedErrorReporting](
                        this.detailedErrorReporting,
                      )
                    : (_patchMap[PrintJobAttributes$.detailedErrorReporting]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.detailedErrorReporting]
                          .applyTo(this.detailedErrorReporting)
                    : _patchMap[PrintJobAttributes$.detailedErrorReporting])
                as bool?
          : this.detailedErrorReporting,
      faxNumber: _patchMap.containsKey(PrintJobAttributes$.faxNumber)
          ? ((_patchMap[PrintJobAttributes$.faxNumber] is Function)
                    ? _patchMap[PrintJobAttributes$.faxNumber](this.faxNumber)
                    : (_patchMap[PrintJobAttributes$.faxNumber] is Patch)
                    ? _patchMap[PrintJobAttributes$.faxNumber].applyTo(
                        this.faxNumber,
                      )
                    : _patchMap[PrintJobAttributes$.faxNumber])
                as String?
          : this.faxNumber,
      headerAndFooter:
          _patchMap.containsKey(PrintJobAttributes$.headerAndFooter)
          ? ((_patchMap[PrintJobAttributes$.headerAndFooter] is Function)
                    ? _patchMap[PrintJobAttributes$.headerAndFooter](
                        this.headerAndFooter,
                      )
                    : (_patchMap[PrintJobAttributes$.headerAndFooter] is Patch)
                    ? _patchMap[PrintJobAttributes$.headerAndFooter].applyTo(
                        this.headerAndFooter,
                      )
                    : _patchMap[PrintJobAttributes$.headerAndFooter])
                as bool?
          : this.headerAndFooter,
      horizontalPagination:
          _patchMap.containsKey(PrintJobAttributes$.horizontalPagination)
          ? ((_patchMap[PrintJobAttributes$.horizontalPagination] is Function)
                    ? _patchMap[PrintJobAttributes$.horizontalPagination](
                        this.horizontalPagination,
                      )
                    : (_patchMap[PrintJobAttributes$.horizontalPagination]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.horizontalPagination]
                          .applyTo(this.horizontalPagination)
                    : _patchMap[PrintJobAttributes$.horizontalPagination])
                as PrintJobPaginationMode?
          : this.horizontalPagination,
      isHorizontallyCentered:
          _patchMap.containsKey(PrintJobAttributes$.isHorizontallyCentered)
          ? ((_patchMap[PrintJobAttributes$.isHorizontallyCentered] is Function)
                    ? _patchMap[PrintJobAttributes$.isHorizontallyCentered](
                        this.isHorizontallyCentered,
                      )
                    : (_patchMap[PrintJobAttributes$.isHorizontallyCentered]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.isHorizontallyCentered]
                          .applyTo(this.isHorizontallyCentered)
                    : _patchMap[PrintJobAttributes$.isHorizontallyCentered])
                as bool?
          : this.isHorizontallyCentered,
      isVerticallyCentered:
          _patchMap.containsKey(PrintJobAttributes$.isVerticallyCentered)
          ? ((_patchMap[PrintJobAttributes$.isVerticallyCentered] is Function)
                    ? _patchMap[PrintJobAttributes$.isVerticallyCentered](
                        this.isVerticallyCentered,
                      )
                    : (_patchMap[PrintJobAttributes$.isVerticallyCentered]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.isVerticallyCentered]
                          .applyTo(this.isVerticallyCentered)
                    : _patchMap[PrintJobAttributes$.isVerticallyCentered])
                as bool?
          : this.isVerticallyCentered,
      jobDisposition: _patchMap.containsKey(PrintJobAttributes$.jobDisposition)
          ? ((_patchMap[PrintJobAttributes$.jobDisposition] is Function)
                    ? _patchMap[PrintJobAttributes$.jobDisposition](
                        this.jobDisposition,
                      )
                    : (_patchMap[PrintJobAttributes$.jobDisposition] is Patch)
                    ? _patchMap[PrintJobAttributes$.jobDisposition].applyTo(
                        this.jobDisposition,
                      )
                    : _patchMap[PrintJobAttributes$.jobDisposition])
                as PrintJobDisposition?
          : this.jobDisposition,
      jobSavingURL: _patchMap.containsKey(PrintJobAttributes$.jobSavingURL)
          ? ((_patchMap[PrintJobAttributes$.jobSavingURL] is Function)
                    ? _patchMap[PrintJobAttributes$.jobSavingURL](
                        this.jobSavingURL,
                      )
                    : (_patchMap[PrintJobAttributes$.jobSavingURL] is Patch)
                    ? _patchMap[PrintJobAttributes$.jobSavingURL].applyTo(
                        this.jobSavingURL,
                      )
                    : _patchMap[PrintJobAttributes$.jobSavingURL])
                as WebUri?
          : this.jobSavingURL,
      verticalPagination:
          _patchMap.containsKey(PrintJobAttributes$.verticalPagination)
          ? ((_patchMap[PrintJobAttributes$.verticalPagination] is Function)
                    ? _patchMap[PrintJobAttributes$.verticalPagination](
                        this.verticalPagination,
                      )
                    : (_patchMap[PrintJobAttributes$.verticalPagination]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.verticalPagination].applyTo(
                        this.verticalPagination,
                      )
                    : _patchMap[PrintJobAttributes$.verticalPagination])
                as PrintJobPaginationMode?
          : this.verticalPagination,
      maximumContentHeight:
          _patchMap.containsKey(PrintJobAttributes$.maximumContentHeight)
          ? ((_patchMap[PrintJobAttributes$.maximumContentHeight] is Function)
                    ? _patchMap[PrintJobAttributes$.maximumContentHeight](
                        this.maximumContentHeight,
                      )
                    : (_patchMap[PrintJobAttributes$.maximumContentHeight]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.maximumContentHeight]
                          .applyTo(this.maximumContentHeight)
                    : _patchMap[PrintJobAttributes$.maximumContentHeight])
                as double?
          : this.maximumContentHeight,
      maximumContentWidth:
          _patchMap.containsKey(PrintJobAttributes$.maximumContentWidth)
          ? ((_patchMap[PrintJobAttributes$.maximumContentWidth] is Function)
                    ? _patchMap[PrintJobAttributes$.maximumContentWidth](
                        this.maximumContentWidth,
                      )
                    : (_patchMap[PrintJobAttributes$.maximumContentWidth]
                          is Patch)
                    ? _patchMap[PrintJobAttributes$.maximumContentWidth]
                          .applyTo(this.maximumContentWidth)
                    : _patchMap[PrintJobAttributes$.maximumContentWidth])
                as double?
          : this.maximumContentWidth,
      firstPage: _patchMap.containsKey(PrintJobAttributes$.firstPage)
          ? ((_patchMap[PrintJobAttributes$.firstPage] is Function)
                    ? _patchMap[PrintJobAttributes$.firstPage](this.firstPage)
                    : (_patchMap[PrintJobAttributes$.firstPage] is Patch)
                    ? _patchMap[PrintJobAttributes$.firstPage].applyTo(
                        this.firstPage,
                      )
                    : _patchMap[PrintJobAttributes$.firstPage])
                as int?
          : this.firstPage,
      lastPage: _patchMap.containsKey(PrintJobAttributes$.lastPage)
          ? ((_patchMap[PrintJobAttributes$.lastPage] is Function)
                    ? _patchMap[PrintJobAttributes$.lastPage](this.lastPage)
                    : (_patchMap[PrintJobAttributes$.lastPage] is Patch)
                    ? _patchMap[PrintJobAttributes$.lastPage].applyTo(
                        this.lastPage,
                      )
                    : _patchMap[PrintJobAttributes$.lastPage])
                as int?
          : this.lastPage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrintJobAttributes &&
        colorMode == other.colorMode &&
        duplexMode == other.duplexMode &&
        orientation == other.orientation &&
        mediaSize == other.mediaSize &&
        resolution == other.resolution &&
        margins == other.margins &&
        footerHeight == other.footerHeight &&
        headerHeight == other.headerHeight &&
        paperName == other.paperName &&
        localizedPaperName == other.localizedPaperName &&
        printableRect == other.printableRect &&
        paperRect == other.paperRect &&
        detailedErrorReporting == other.detailedErrorReporting &&
        faxNumber == other.faxNumber &&
        headerAndFooter == other.headerAndFooter &&
        horizontalPagination == other.horizontalPagination &&
        isHorizontallyCentered == other.isHorizontallyCentered &&
        isVerticallyCentered == other.isVerticallyCentered &&
        jobDisposition == other.jobDisposition &&
        jobSavingURL == other.jobSavingURL &&
        verticalPagination == other.verticalPagination &&
        maximumContentHeight == other.maximumContentHeight &&
        maximumContentWidth == other.maximumContentWidth &&
        firstPage == other.firstPage &&
        lastPage == other.lastPage;
  }

  @override
  int get hashCode {
    return Object.hash(
          this.colorMode,
          this.duplexMode,
          this.orientation,
          this.mediaSize,
          this.resolution,
          this.margins,
          this.footerHeight,
          this.headerHeight,
          this.paperName,
          this.localizedPaperName,
          this.printableRect,
          this.paperRect,
          this.detailedErrorReporting,
          this.faxNumber,
          this.headerAndFooter,
          this.horizontalPagination,
          this.isHorizontallyCentered,
          this.isVerticallyCentered,
          this.jobDisposition,
          this.jobSavingURL,
        ) ^
        Object.hash(
          this.verticalPagination,
          this.maximumContentHeight,
          this.maximumContentWidth,
          this.firstPage,
          this.lastPage,
        );
  }

  @override
  String toString() {
    return 'PrintJobAttributes(' +
        'colorMode: ${colorMode}' +
        ', ' +
        'duplexMode: ${duplexMode}' +
        ', ' +
        'orientation: ${orientation}' +
        ', ' +
        'mediaSize: ${mediaSize}' +
        ', ' +
        'resolution: ${resolution}' +
        ', ' +
        'margins: ${margins}' +
        ', ' +
        'footerHeight: ${footerHeight}' +
        ', ' +
        'headerHeight: ${headerHeight}' +
        ', ' +
        'paperName: ${paperName}' +
        ', ' +
        'localizedPaperName: ${localizedPaperName}' +
        ', ' +
        'printableRect: ${printableRect}' +
        ', ' +
        'paperRect: ${paperRect}' +
        ', ' +
        'detailedErrorReporting: ${detailedErrorReporting}' +
        ', ' +
        'faxNumber: ${faxNumber}' +
        ', ' +
        'headerAndFooter: ${headerAndFooter}' +
        ', ' +
        'horizontalPagination: ${horizontalPagination}' +
        ', ' +
        'isHorizontallyCentered: ${isHorizontallyCentered}' +
        ', ' +
        'isVerticallyCentered: ${isVerticallyCentered}' +
        ', ' +
        'jobDisposition: ${jobDisposition}' +
        ', ' +
        'jobSavingURL: ${jobSavingURL}' +
        ', ' +
        'verticalPagination: ${verticalPagination}' +
        ', ' +
        'maximumContentHeight: ${maximumContentHeight}' +
        ', ' +
        'maximumContentWidth: ${maximumContentWidth}' +
        ', ' +
        'firstPage: ${firstPage}' +
        ', ' +
        'lastPage: ${lastPage})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PrintJobAttributesToJson(this);
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

extension PrintJobAttributesPropertyHelpers on PrintJobAttributes {
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

  bool get hasLocalizedPaperName {
    return this.localizedPaperName?.isNotEmpty == true;
  }

  bool get noLocalizedPaperName {
    return this.localizedPaperName?.isEmpty ?? true;
  }

  String get localizedPaperNameRequired {
    return this.localizedPaperName ??
        (throw StateError('localizedPaperName is required but was null'));
  }

  bool get hasPrintableRect {
    return this.printableRect != null;
  }

  bool get noPrintableRect {
    return this.printableRect == null;
  }

  InAppWebViewRect get printableRectRequired {
    return this.printableRect ??
        (throw StateError('printableRect is required but was null'));
  }

  bool get hasPaperRect {
    return this.paperRect != null;
  }

  bool get noPaperRect {
    return this.paperRect == null;
  }

  InAppWebViewRect get paperRectRequired {
    return this.paperRect ??
        (throw StateError('paperRect is required but was null'));
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
}

extension PrintJobAttributesSerialization on PrintJobAttributes {
  Map<String, dynamic> toJson() {
    return _$PrintJobAttributesToJson(this);
  }
}

enum PrintJobAttributes$ {
  colorMode,
  duplexMode,
  orientation,
  mediaSize,
  resolution,
  margins,
  footerHeight,
  headerHeight,
  paperName,
  localizedPaperName,
  printableRect,
  paperRect,
  detailedErrorReporting,
  faxNumber,
  headerAndFooter,
  horizontalPagination,
  isHorizontallyCentered,
  isVerticallyCentered,
  jobDisposition,
  jobSavingURL,
  verticalPagination,
  maximumContentHeight,
  maximumContentWidth,
  firstPage,
  lastPage,
}

class PrintJobAttributesPatch
    extends PatchBase<PrintJobAttributes, PrintJobAttributes$> {
  PrintJobAttributes applyTo(PrintJobAttributes entity) {
    return entity.patchWithPrintJobAttributes(this);
  }

  PrintJobAttributesPatch withColorMode(PrintJobColorMode? value) {
    patchMap[PrintJobAttributes$.colorMode] = value;
    return this;
  }

  PrintJobAttributesPatch withDuplexMode(PrintJobDuplexMode? value) {
    patchMap[PrintJobAttributes$.duplexMode] = value;
    return this;
  }

  PrintJobAttributesPatch withOrientation(PrintJobOrientation? value) {
    patchMap[PrintJobAttributes$.orientation] = value;
    return this;
  }

  PrintJobAttributesPatch withMediaSize(PrintJobMediaSize? value) {
    patchMap[PrintJobAttributes$.mediaSize] = value;
    return this;
  }

  PrintJobAttributesPatch withMediaSizePatch(PrintJobMediaSizePatch patch) {
    patchMap[PrintJobAttributes$.mediaSize] = patch;
    return this;
  }

  PrintJobAttributesPatch withMediaSizePatchFunc(
    PrintJobMediaSizePatch Function(PrintJobMediaSizePatch) patch,
  ) {
    patchMap[PrintJobAttributes$.mediaSize] = (dynamic current) {
      var currentPatch = PrintJobMediaSizePatch();
      return patch(currentPatch).applyTo(current as PrintJobMediaSize);
    };
    return this;
  }

  PrintJobAttributesPatch withResolution(PrintJobResolution? value) {
    patchMap[PrintJobAttributes$.resolution] = value;
    return this;
  }

  PrintJobAttributesPatch withResolutionPatch(PrintJobResolutionPatch patch) {
    patchMap[PrintJobAttributes$.resolution] = patch;
    return this;
  }

  PrintJobAttributesPatch withResolutionPatchFunc(
    PrintJobResolutionPatch Function(PrintJobResolutionPatch) patch,
  ) {
    patchMap[PrintJobAttributes$.resolution] = (dynamic current) {
      var currentPatch = PrintJobResolutionPatch();
      return patch(currentPatch).applyTo(current as PrintJobResolution);
    };
    return this;
  }

  PrintJobAttributesPatch withMargins(EdgeInsets? value) {
    patchMap[PrintJobAttributes$.margins] = value;
    return this;
  }

  PrintJobAttributesPatch withFooterHeight(double? value) {
    patchMap[PrintJobAttributes$.footerHeight] = value;
    return this;
  }

  PrintJobAttributesPatch withHeaderHeight(double? value) {
    patchMap[PrintJobAttributes$.headerHeight] = value;
    return this;
  }

  PrintJobAttributesPatch withPaperName(String? value) {
    patchMap[PrintJobAttributes$.paperName] = value;
    return this;
  }

  PrintJobAttributesPatch withLocalizedPaperName(String? value) {
    patchMap[PrintJobAttributes$.localizedPaperName] = value;
    return this;
  }

  PrintJobAttributesPatch withPrintableRect(InAppWebViewRect? value) {
    patchMap[PrintJobAttributes$.printableRect] = value;
    return this;
  }

  PrintJobAttributesPatch withPaperRect(InAppWebViewRect? value) {
    patchMap[PrintJobAttributes$.paperRect] = value;
    return this;
  }

  PrintJobAttributesPatch withDetailedErrorReporting(bool? value) {
    patchMap[PrintJobAttributes$.detailedErrorReporting] = value;
    return this;
  }

  PrintJobAttributesPatch withFaxNumber(String? value) {
    patchMap[PrintJobAttributes$.faxNumber] = value;
    return this;
  }

  PrintJobAttributesPatch withHeaderAndFooter(bool? value) {
    patchMap[PrintJobAttributes$.headerAndFooter] = value;
    return this;
  }

  PrintJobAttributesPatch withHorizontalPagination(
    PrintJobPaginationMode? value,
  ) {
    patchMap[PrintJobAttributes$.horizontalPagination] = value;
    return this;
  }

  PrintJobAttributesPatch withIsHorizontallyCentered(bool? value) {
    patchMap[PrintJobAttributes$.isHorizontallyCentered] = value;
    return this;
  }

  PrintJobAttributesPatch withIsVerticallyCentered(bool? value) {
    patchMap[PrintJobAttributes$.isVerticallyCentered] = value;
    return this;
  }

  PrintJobAttributesPatch withJobDisposition(PrintJobDisposition? value) {
    patchMap[PrintJobAttributes$.jobDisposition] = value;
    return this;
  }

  PrintJobAttributesPatch withJobSavingURL(WebUri? value) {
    patchMap[PrintJobAttributes$.jobSavingURL] = value;
    return this;
  }

  PrintJobAttributesPatch withVerticalPagination(
    PrintJobPaginationMode? value,
  ) {
    patchMap[PrintJobAttributes$.verticalPagination] = value;
    return this;
  }

  PrintJobAttributesPatch withMaximumContentHeight(double? value) {
    patchMap[PrintJobAttributes$.maximumContentHeight] = value;
    return this;
  }

  PrintJobAttributesPatch withMaximumContentWidth(double? value) {
    patchMap[PrintJobAttributes$.maximumContentWidth] = value;
    return this;
  }

  PrintJobAttributesPatch withFirstPage(int? value) {
    patchMap[PrintJobAttributes$.firstPage] = value;
    return this;
  }

  PrintJobAttributesPatch withLastPage(int? value) {
    patchMap[PrintJobAttributes$.lastPage] = value;
    return this;
  }
}

/// Field descriptors for [PrintJobAttributes] query construction
abstract final class PrintJobAttributesFields {
  static const colorMode = Field<PrintJobAttributes, PrintJobColorMode?>(
    'colorMode',
    _$colorMode,
  );

  static const duplexMode = Field<PrintJobAttributes, PrintJobDuplexMode?>(
    'duplexMode',
    _$duplexMode,
  );

  static const orientation = Field<PrintJobAttributes, PrintJobOrientation?>(
    'orientation',
    _$orientation,
  );

  static const mediaSize = Field<PrintJobAttributes, PrintJobMediaSize?>(
    'mediaSize',
    _$mediaSize,
  );

  static const resolution = Field<PrintJobAttributes, PrintJobResolution?>(
    'resolution',
    _$resolution,
  );

  static const margins = Field<PrintJobAttributes, EdgeInsets?>(
    'margins',
    _$margins,
  );

  static const footerHeight = Field<PrintJobAttributes, double?>(
    'footerHeight',
    _$footerHeight,
  );

  static const headerHeight = Field<PrintJobAttributes, double?>(
    'headerHeight',
    _$headerHeight,
  );

  static const paperName = Field<PrintJobAttributes, String?>(
    'paperName',
    _$paperName,
  );

  static const localizedPaperName = Field<PrintJobAttributes, String?>(
    'localizedPaperName',
    _$localizedPaperName,
  );

  static const printableRect = Field<PrintJobAttributes, InAppWebViewRect?>(
    'printableRect',
    _$printableRect,
  );

  static const paperRect = Field<PrintJobAttributes, InAppWebViewRect?>(
    'paperRect',
    _$paperRect,
  );

  static const detailedErrorReporting = Field<PrintJobAttributes, bool?>(
    'detailedErrorReporting',
    _$detailedErrorReporting,
  );

  static const faxNumber = Field<PrintJobAttributes, String?>(
    'faxNumber',
    _$faxNumber,
  );

  static const headerAndFooter = Field<PrintJobAttributes, bool?>(
    'headerAndFooter',
    _$headerAndFooter,
  );

  static const horizontalPagination =
      Field<PrintJobAttributes, PrintJobPaginationMode?>(
        'horizontalPagination',
        _$horizontalPagination,
      );

  static const isHorizontallyCentered = Field<PrintJobAttributes, bool?>(
    'isHorizontallyCentered',
    _$isHorizontallyCentered,
  );

  static const isVerticallyCentered = Field<PrintJobAttributes, bool?>(
    'isVerticallyCentered',
    _$isVerticallyCentered,
  );

  static const jobDisposition = Field<PrintJobAttributes, PrintJobDisposition?>(
    'jobDisposition',
    _$jobDisposition,
  );

  static const jobSavingURL = Field<PrintJobAttributes, WebUri?>(
    'jobSavingURL',
    _$jobSavingURL,
  );

  static const verticalPagination =
      Field<PrintJobAttributes, PrintJobPaginationMode?>(
        'verticalPagination',
        _$verticalPagination,
      );

  static const maximumContentHeight = Field<PrintJobAttributes, double?>(
    'maximumContentHeight',
    _$maximumContentHeight,
  );

  static const maximumContentWidth = Field<PrintJobAttributes, double?>(
    'maximumContentWidth',
    _$maximumContentWidth,
  );

  static const firstPage = Field<PrintJobAttributes, int?>(
    'firstPage',
    _$firstPage,
  );

  static const lastPage = Field<PrintJobAttributes, int?>(
    'lastPage',
    _$lastPage,
  );

  static PrintJobColorMode? _$colorMode(PrintJobAttributes e) {
    return e.colorMode;
  }

  static PrintJobDuplexMode? _$duplexMode(PrintJobAttributes e) {
    return e.duplexMode;
  }

  static PrintJobOrientation? _$orientation(PrintJobAttributes e) {
    return e.orientation;
  }

  static PrintJobMediaSize? _$mediaSize(PrintJobAttributes e) {
    return e.mediaSize;
  }

  static PrintJobResolution? _$resolution(PrintJobAttributes e) {
    return e.resolution;
  }

  static EdgeInsets? _$margins(PrintJobAttributes e) {
    return e.margins;
  }

  static double? _$footerHeight(PrintJobAttributes e) {
    return e.footerHeight;
  }

  static double? _$headerHeight(PrintJobAttributes e) {
    return e.headerHeight;
  }

  static String? _$paperName(PrintJobAttributes e) {
    return e.paperName;
  }

  static String? _$localizedPaperName(PrintJobAttributes e) {
    return e.localizedPaperName;
  }

  static InAppWebViewRect? _$printableRect(PrintJobAttributes e) {
    return e.printableRect;
  }

  static InAppWebViewRect? _$paperRect(PrintJobAttributes e) {
    return e.paperRect;
  }

  static bool? _$detailedErrorReporting(PrintJobAttributes e) {
    return e.detailedErrorReporting;
  }

  static String? _$faxNumber(PrintJobAttributes e) {
    return e.faxNumber;
  }

  static bool? _$headerAndFooter(PrintJobAttributes e) {
    return e.headerAndFooter;
  }

  static PrintJobPaginationMode? _$horizontalPagination(PrintJobAttributes e) {
    return e.horizontalPagination;
  }

  static bool? _$isHorizontallyCentered(PrintJobAttributes e) {
    return e.isHorizontallyCentered;
  }

  static bool? _$isVerticallyCentered(PrintJobAttributes e) {
    return e.isVerticallyCentered;
  }

  static PrintJobDisposition? _$jobDisposition(PrintJobAttributes e) {
    return e.jobDisposition;
  }

  static WebUri? _$jobSavingURL(PrintJobAttributes e) {
    return e.jobSavingURL;
  }

  static PrintJobPaginationMode? _$verticalPagination(PrintJobAttributes e) {
    return e.verticalPagination;
  }

  static double? _$maximumContentHeight(PrintJobAttributes e) {
    return e.maximumContentHeight;
  }

  static double? _$maximumContentWidth(PrintJobAttributes e) {
    return e.maximumContentWidth;
  }

  static int? _$firstPage(PrintJobAttributes e) {
    return e.firstPage;
  }

  static int? _$lastPage(PrintJobAttributes e) {
    return e.lastPage;
  }
}

extension PrintJobAttributesCompareE on PrintJobAttributes {
  Map<String, dynamic> compareToPrintJobAttributes(PrintJobAttributes other) {
    final Map<String, dynamic> diff = {};

    if (colorMode != other.colorMode) {
      diff['colorMode'] = () => other.colorMode;
    }

    if (duplexMode != other.duplexMode) {
      diff['duplexMode'] = () => other.duplexMode;
    }

    if (orientation != other.orientation) {
      diff['orientation'] = () => other.orientation;
    }

    if (mediaSize != other.mediaSize) {
      diff['mediaSize'] = () => other.mediaSize;
    }

    if (resolution != other.resolution) {
      diff['resolution'] = () => other.resolution;
    }

    if (margins != other.margins) {
      diff['margins'] = () => other.margins;
    }

    if (footerHeight != other.footerHeight) {
      diff['footerHeight'] = () => other.footerHeight;
    }

    if (headerHeight != other.headerHeight) {
      diff['headerHeight'] = () => other.headerHeight;
    }

    if (paperName != other.paperName) {
      diff['paperName'] = () => other.paperName;
    }

    if (localizedPaperName != other.localizedPaperName) {
      diff['localizedPaperName'] = () => other.localizedPaperName;
    }

    if (printableRect != other.printableRect) {
      diff['printableRect'] = () => other.printableRect;
    }

    if (paperRect != other.paperRect) {
      diff['paperRect'] = () => other.paperRect;
    }

    if (detailedErrorReporting != other.detailedErrorReporting) {
      diff['detailedErrorReporting'] = () => other.detailedErrorReporting;
    }

    if (faxNumber != other.faxNumber) {
      diff['faxNumber'] = () => other.faxNumber;
    }

    if (headerAndFooter != other.headerAndFooter) {
      diff['headerAndFooter'] = () => other.headerAndFooter;
    }

    if (horizontalPagination != other.horizontalPagination) {
      diff['horizontalPagination'] = () => other.horizontalPagination;
    }

    if (isHorizontallyCentered != other.isHorizontallyCentered) {
      diff['isHorizontallyCentered'] = () => other.isHorizontallyCentered;
    }

    if (isVerticallyCentered != other.isVerticallyCentered) {
      diff['isVerticallyCentered'] = () => other.isVerticallyCentered;
    }

    if (jobDisposition != other.jobDisposition) {
      diff['jobDisposition'] = () => other.jobDisposition;
    }

    if (jobSavingURL != other.jobSavingURL) {
      diff['jobSavingURL'] = () => other.jobSavingURL;
    }

    if (verticalPagination != other.verticalPagination) {
      diff['verticalPagination'] = () => other.verticalPagination;
    }

    if (maximumContentHeight != other.maximumContentHeight) {
      diff['maximumContentHeight'] = () => other.maximumContentHeight;
    }

    if (maximumContentWidth != other.maximumContentWidth) {
      diff['maximumContentWidth'] = () => other.maximumContentWidth;
    }

    if (firstPage != other.firstPage) {
      diff['firstPage'] = () => other.firstPage;
    }

    if (lastPage != other.lastPage) {
      diff['lastPage'] = () => other.lastPage;
    }
    return diff;
  }
}
