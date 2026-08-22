// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'print_job_info.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PrintJobInfo {
  PrintJobInfo({
    PrintJobState? this.state,
    int? this.copies,
    int? this.numberOfPages,
    int? this.creationTime,
    String? this.label,
    Printer? this.printer,
    PrintJobPageOrder? this.pageOrder,
    PrintJobRenderingQuality? this.preferredRenderingQuality,
    bool? this.showsProgressPanel,
    bool? this.showsPrintPanel,
    bool? this.canSpawnSeparateThread,
    bool? this.isCopyingOperation,
    int? this.currentPage,
    int? this.firstPage,
    int? this.lastPage,
    PrintJobAttributes? this.attributes,
  });

  factory PrintJobInfo.fromJson(Map<String, dynamic> json) =>
      _$PrintJobInfoFromJson(json);

  @JsonKey(toJson: _stateToJson, fromJson: _stateFromJson)
  final PrintJobState? state;

  final int? copies;

  final int? numberOfPages;

  final int? creationTime;

  final String? label;

  @JsonKey(toJson: _printerToJson, fromJson: _printerFromJson)
  final Printer? printer;

  @JsonKey(toJson: _pageOrderToJson, fromJson: _pageOrderFromJson)
  final PrintJobPageOrder? pageOrder;

  final PrintJobRenderingQuality? preferredRenderingQuality;

  final bool? showsProgressPanel;

  final bool? showsPrintPanel;

  final bool? canSpawnSeparateThread;

  final bool? isCopyingOperation;

  final int? currentPage;

  final int? firstPage;

  final int? lastPage;

  @JsonKey(toJson: _attributesToJson, fromJson: _attributesFromJson)
  final PrintJobAttributes? attributes;

  PrintJobInfo copyWith({
    PrintJobState? state,
    int? copies,
    int? numberOfPages,
    int? creationTime,
    String? label,
    Printer? printer,
    PrintJobPageOrder? pageOrder,
    PrintJobRenderingQuality? preferredRenderingQuality,
    bool? showsProgressPanel,
    bool? showsPrintPanel,
    bool? canSpawnSeparateThread,
    bool? isCopyingOperation,
    int? currentPage,
    int? firstPage,
    int? lastPage,
    PrintJobAttributes? attributes,
  }) {
    return PrintJobInfo(
      state: state ?? this.state,
      copies: copies ?? this.copies,
      numberOfPages: numberOfPages ?? this.numberOfPages,
      creationTime: creationTime ?? this.creationTime,
      label: label ?? this.label,
      printer: printer ?? this.printer,
      pageOrder: pageOrder ?? this.pageOrder,
      preferredRenderingQuality:
          preferredRenderingQuality ?? this.preferredRenderingQuality,
      showsProgressPanel: showsProgressPanel ?? this.showsProgressPanel,
      showsPrintPanel: showsPrintPanel ?? this.showsPrintPanel,
      canSpawnSeparateThread:
          canSpawnSeparateThread ?? this.canSpawnSeparateThread,
      isCopyingOperation: isCopyingOperation ?? this.isCopyingOperation,
      currentPage: currentPage ?? this.currentPage,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      attributes: attributes ?? this.attributes,
    );
  }

  PrintJobInfo copyWithPrintJobInfo({
    PrintJobState? state,
    int? copies,
    int? numberOfPages,
    int? creationTime,
    String? label,
    Printer? printer,
    PrintJobPageOrder? pageOrder,
    PrintJobRenderingQuality? preferredRenderingQuality,
    bool? showsProgressPanel,
    bool? showsPrintPanel,
    bool? canSpawnSeparateThread,
    bool? isCopyingOperation,
    int? currentPage,
    int? firstPage,
    int? lastPage,
    PrintJobAttributes? attributes,
  }) {
    return copyWith(
      state: state,
      copies: copies,
      numberOfPages: numberOfPages,
      creationTime: creationTime,
      label: label,
      printer: printer,
      pageOrder: pageOrder,
      preferredRenderingQuality: preferredRenderingQuality,
      showsProgressPanel: showsProgressPanel,
      showsPrintPanel: showsPrintPanel,
      canSpawnSeparateThread: canSpawnSeparateThread,
      isCopyingOperation: isCopyingOperation,
      currentPage: currentPage,
      firstPage: firstPage,
      lastPage: lastPage,
      attributes: attributes,
    );
  }

  PrintJobInfo patchWithPrintJobInfo([PrintJobInfoPatch? patchInput]) {
    final _patcher = patchInput ?? PrintJobInfoPatch();
    final _patchMap = _patcher.patchMap;
    return PrintJobInfo(
      state: _patchMap.containsKey(PrintJobInfo$.state)
          ? (_patchMap[PrintJobInfo$.state] is Function)
                ? _patchMap[PrintJobInfo$.state](this.state)
                : (_patchMap[PrintJobInfo$.state] is Patch)
                ? _patchMap[PrintJobInfo$.state].applyTo(this.state)
                : _patchMap[PrintJobInfo$.state]
          : this.state,
      copies: _patchMap.containsKey(PrintJobInfo$.copies)
          ? (_patchMap[PrintJobInfo$.copies] is Function)
                ? _patchMap[PrintJobInfo$.copies](this.copies)
                : (_patchMap[PrintJobInfo$.copies] is Patch)
                ? _patchMap[PrintJobInfo$.copies].applyTo(this.copies)
                : _patchMap[PrintJobInfo$.copies]
          : this.copies,
      numberOfPages: _patchMap.containsKey(PrintJobInfo$.numberOfPages)
          ? (_patchMap[PrintJobInfo$.numberOfPages] is Function)
                ? _patchMap[PrintJobInfo$.numberOfPages](this.numberOfPages)
                : (_patchMap[PrintJobInfo$.numberOfPages] is Patch)
                ? _patchMap[PrintJobInfo$.numberOfPages].applyTo(
                    this.numberOfPages,
                  )
                : _patchMap[PrintJobInfo$.numberOfPages]
          : this.numberOfPages,
      creationTime: _patchMap.containsKey(PrintJobInfo$.creationTime)
          ? (_patchMap[PrintJobInfo$.creationTime] is Function)
                ? _patchMap[PrintJobInfo$.creationTime](this.creationTime)
                : (_patchMap[PrintJobInfo$.creationTime] is Patch)
                ? _patchMap[PrintJobInfo$.creationTime].applyTo(
                    this.creationTime,
                  )
                : _patchMap[PrintJobInfo$.creationTime]
          : this.creationTime,
      label: _patchMap.containsKey(PrintJobInfo$.label)
          ? (_patchMap[PrintJobInfo$.label] is Function)
                ? _patchMap[PrintJobInfo$.label](this.label)
                : (_patchMap[PrintJobInfo$.label] is Patch)
                ? _patchMap[PrintJobInfo$.label].applyTo(this.label)
                : _patchMap[PrintJobInfo$.label]
          : this.label,
      printer: _patchMap.containsKey(PrintJobInfo$.printer)
          ? (_patchMap[PrintJobInfo$.printer] is Function)
                ? _patchMap[PrintJobInfo$.printer](this.printer)
                : (_patchMap[PrintJobInfo$.printer] is Patch)
                ? _patchMap[PrintJobInfo$.printer].applyTo(this.printer)
                : _patchMap[PrintJobInfo$.printer]
          : this.printer,
      pageOrder: _patchMap.containsKey(PrintJobInfo$.pageOrder)
          ? (_patchMap[PrintJobInfo$.pageOrder] is Function)
                ? _patchMap[PrintJobInfo$.pageOrder](this.pageOrder)
                : (_patchMap[PrintJobInfo$.pageOrder] is Patch)
                ? _patchMap[PrintJobInfo$.pageOrder].applyTo(this.pageOrder)
                : _patchMap[PrintJobInfo$.pageOrder]
          : this.pageOrder,
      preferredRenderingQuality:
          _patchMap.containsKey(PrintJobInfo$.preferredRenderingQuality)
          ? (_patchMap[PrintJobInfo$.preferredRenderingQuality] is Function)
                ? _patchMap[PrintJobInfo$.preferredRenderingQuality](
                    this.preferredRenderingQuality,
                  )
                : (_patchMap[PrintJobInfo$.preferredRenderingQuality] is Patch)
                ? _patchMap[PrintJobInfo$.preferredRenderingQuality].applyTo(
                    this.preferredRenderingQuality,
                  )
                : _patchMap[PrintJobInfo$.preferredRenderingQuality]
          : this.preferredRenderingQuality,
      showsProgressPanel:
          _patchMap.containsKey(PrintJobInfo$.showsProgressPanel)
          ? (_patchMap[PrintJobInfo$.showsProgressPanel] is Function)
                ? _patchMap[PrintJobInfo$.showsProgressPanel](
                    this.showsProgressPanel,
                  )
                : (_patchMap[PrintJobInfo$.showsProgressPanel] is Patch)
                ? _patchMap[PrintJobInfo$.showsProgressPanel].applyTo(
                    this.showsProgressPanel,
                  )
                : _patchMap[PrintJobInfo$.showsProgressPanel]
          : this.showsProgressPanel,
      showsPrintPanel: _patchMap.containsKey(PrintJobInfo$.showsPrintPanel)
          ? (_patchMap[PrintJobInfo$.showsPrintPanel] is Function)
                ? _patchMap[PrintJobInfo$.showsPrintPanel](this.showsPrintPanel)
                : (_patchMap[PrintJobInfo$.showsPrintPanel] is Patch)
                ? _patchMap[PrintJobInfo$.showsPrintPanel].applyTo(
                    this.showsPrintPanel,
                  )
                : _patchMap[PrintJobInfo$.showsPrintPanel]
          : this.showsPrintPanel,
      canSpawnSeparateThread:
          _patchMap.containsKey(PrintJobInfo$.canSpawnSeparateThread)
          ? (_patchMap[PrintJobInfo$.canSpawnSeparateThread] is Function)
                ? _patchMap[PrintJobInfo$.canSpawnSeparateThread](
                    this.canSpawnSeparateThread,
                  )
                : (_patchMap[PrintJobInfo$.canSpawnSeparateThread] is Patch)
                ? _patchMap[PrintJobInfo$.canSpawnSeparateThread].applyTo(
                    this.canSpawnSeparateThread,
                  )
                : _patchMap[PrintJobInfo$.canSpawnSeparateThread]
          : this.canSpawnSeparateThread,
      isCopyingOperation:
          _patchMap.containsKey(PrintJobInfo$.isCopyingOperation)
          ? (_patchMap[PrintJobInfo$.isCopyingOperation] is Function)
                ? _patchMap[PrintJobInfo$.isCopyingOperation](
                    this.isCopyingOperation,
                  )
                : (_patchMap[PrintJobInfo$.isCopyingOperation] is Patch)
                ? _patchMap[PrintJobInfo$.isCopyingOperation].applyTo(
                    this.isCopyingOperation,
                  )
                : _patchMap[PrintJobInfo$.isCopyingOperation]
          : this.isCopyingOperation,
      currentPage: _patchMap.containsKey(PrintJobInfo$.currentPage)
          ? (_patchMap[PrintJobInfo$.currentPage] is Function)
                ? _patchMap[PrintJobInfo$.currentPage](this.currentPage)
                : (_patchMap[PrintJobInfo$.currentPage] is Patch)
                ? _patchMap[PrintJobInfo$.currentPage].applyTo(this.currentPage)
                : _patchMap[PrintJobInfo$.currentPage]
          : this.currentPage,
      firstPage: _patchMap.containsKey(PrintJobInfo$.firstPage)
          ? (_patchMap[PrintJobInfo$.firstPage] is Function)
                ? _patchMap[PrintJobInfo$.firstPage](this.firstPage)
                : (_patchMap[PrintJobInfo$.firstPage] is Patch)
                ? _patchMap[PrintJobInfo$.firstPage].applyTo(this.firstPage)
                : _patchMap[PrintJobInfo$.firstPage]
          : this.firstPage,
      lastPage: _patchMap.containsKey(PrintJobInfo$.lastPage)
          ? (_patchMap[PrintJobInfo$.lastPage] is Function)
                ? _patchMap[PrintJobInfo$.lastPage](this.lastPage)
                : (_patchMap[PrintJobInfo$.lastPage] is Patch)
                ? _patchMap[PrintJobInfo$.lastPage].applyTo(this.lastPage)
                : _patchMap[PrintJobInfo$.lastPage]
          : this.lastPage,
      attributes: _patchMap.containsKey(PrintJobInfo$.attributes)
          ? (_patchMap[PrintJobInfo$.attributes] is Function)
                ? _patchMap[PrintJobInfo$.attributes](this.attributes)
                : (_patchMap[PrintJobInfo$.attributes] is Patch)
                ? _patchMap[PrintJobInfo$.attributes].applyTo(this.attributes)
                : _patchMap[PrintJobInfo$.attributes]
          : this.attributes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrintJobInfo &&
        state == other.state &&
        copies == other.copies &&
        numberOfPages == other.numberOfPages &&
        creationTime == other.creationTime &&
        label == other.label &&
        printer == other.printer &&
        pageOrder == other.pageOrder &&
        preferredRenderingQuality == other.preferredRenderingQuality &&
        showsProgressPanel == other.showsProgressPanel &&
        showsPrintPanel == other.showsPrintPanel &&
        canSpawnSeparateThread == other.canSpawnSeparateThread &&
        isCopyingOperation == other.isCopyingOperation &&
        currentPage == other.currentPage &&
        firstPage == other.firstPage &&
        lastPage == other.lastPage &&
        attributes == other.attributes;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.state,
      this.copies,
      this.numberOfPages,
      this.creationTime,
      this.label,
      this.printer,
      this.pageOrder,
      this.preferredRenderingQuality,
      this.showsProgressPanel,
      this.showsPrintPanel,
      this.canSpawnSeparateThread,
      this.isCopyingOperation,
      this.currentPage,
      this.firstPage,
      this.lastPage,
      this.attributes,
    );
  }

  @override
  String toString() {
    return 'PrintJobInfo(' +
        'state: ${state}' +
        ', ' +
        'copies: ${copies}' +
        ', ' +
        'numberOfPages: ${numberOfPages}' +
        ', ' +
        'creationTime: ${creationTime}' +
        ', ' +
        'label: ${label}' +
        ', ' +
        'printer: ${printer}' +
        ', ' +
        'pageOrder: ${pageOrder}' +
        ', ' +
        'preferredRenderingQuality: ${preferredRenderingQuality}' +
        ', ' +
        'showsProgressPanel: ${showsProgressPanel}' +
        ', ' +
        'showsPrintPanel: ${showsPrintPanel}' +
        ', ' +
        'canSpawnSeparateThread: ${canSpawnSeparateThread}' +
        ', ' +
        'isCopyingOperation: ${isCopyingOperation}' +
        ', ' +
        'currentPage: ${currentPage}' +
        ', ' +
        'firstPage: ${firstPage}' +
        ', ' +
        'lastPage: ${lastPage}' +
        ', ' +
        'attributes: ${attributes})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PrintJobInfoToJson(this);
    return _sanitizeJson(data);
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

extension PrintJobInfoPropertyHelpers on PrintJobInfo {
  bool get hasState {
    return this.state != null;
  }

  bool get noState {
    return this.state == null;
  }

  PrintJobState get stateRequired {
    return this.state ?? (throw StateError('state is required but was null'));
  }

  bool get isStateCREATED {
    return this.state == PrintJobState.CREATED;
  }

  bool get isStateQUEUED {
    return this.state == PrintJobState.QUEUED;
  }

  bool get isStateSTARTED {
    return this.state == PrintJobState.STARTED;
  }

  bool get isStateBLOCKED {
    return this.state == PrintJobState.BLOCKED;
  }

  bool get isStateCOMPLETED {
    return this.state == PrintJobState.COMPLETED;
  }

  bool get isStateFAILED {
    return this.state == PrintJobState.FAILED;
  }

  bool get isStateCANCELED {
    return this.state == PrintJobState.CANCELED;
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

  bool get hasCreationTime {
    return this.creationTime != null;
  }

  bool get noCreationTime {
    return this.creationTime == null;
  }

  int get creationTimeRequired {
    return this.creationTime ??
        (throw StateError('creationTime is required but was null'));
  }

  bool get hasLabel {
    return this.label?.isNotEmpty == true;
  }

  bool get noLabel {
    return this.label?.isEmpty ?? true;
  }

  String get labelRequired {
    return this.label ?? (throw StateError('label is required but was null'));
  }

  bool get hasPrinter {
    return this.printer != null;
  }

  bool get noPrinter {
    return this.printer == null;
  }

  Printer get printerRequired {
    return this.printer ??
        (throw StateError('printer is required but was null'));
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

  bool get hasPreferredRenderingQuality {
    return this.preferredRenderingQuality != null;
  }

  bool get noPreferredRenderingQuality {
    return this.preferredRenderingQuality == null;
  }

  PrintJobRenderingQuality get preferredRenderingQualityRequired {
    return this.preferredRenderingQuality ??
        (throw StateError(
          'preferredRenderingQuality is required but was null',
        ));
  }

  bool get isPreferredRenderingQualityBEST {
    return this.preferredRenderingQuality == PrintJobRenderingQuality.BEST;
  }

  bool get isPreferredRenderingQualityRESPONSIVE {
    return this.preferredRenderingQuality ==
        PrintJobRenderingQuality.RESPONSIVE;
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

  bool get hasIsCopyingOperation {
    return this.isCopyingOperation != null;
  }

  bool get noIsCopyingOperation {
    return this.isCopyingOperation == null;
  }

  bool get isCopyingOperationRequired {
    return this.isCopyingOperation ??
        (throw StateError('isCopyingOperation is required but was null'));
  }

  bool get hasCurrentPage {
    return this.currentPage != null;
  }

  bool get noCurrentPage {
    return this.currentPage == null;
  }

  int get currentPageRequired {
    return this.currentPage ??
        (throw StateError('currentPage is required but was null'));
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

  bool get hasAttributes {
    return this.attributes != null;
  }

  bool get noAttributes {
    return this.attributes == null;
  }

  PrintJobAttributes get attributesRequired {
    return this.attributes ??
        (throw StateError('attributes is required but was null'));
  }
}

extension PrintJobInfoSerialization on PrintJobInfo {
  Map<String, dynamic> toJson() {
    return _$PrintJobInfoToJson(this);
  }
}

enum PrintJobInfo$ {
  state,
  copies,
  numberOfPages,
  creationTime,
  label,
  printer,
  pageOrder,
  preferredRenderingQuality,
  showsProgressPanel,
  showsPrintPanel,
  canSpawnSeparateThread,
  isCopyingOperation,
  currentPage,
  firstPage,
  lastPage,
  attributes,
}

class PrintJobInfoPatch extends PatchBase<PrintJobInfo, PrintJobInfo$> {
  PrintJobInfo applyTo(PrintJobInfo entity) {
    return entity.patchWithPrintJobInfo(this);
  }

  PrintJobInfoPatch withState(PrintJobState? value) {
    patchMap[PrintJobInfo$.state] = value;
    return this;
  }

  PrintJobInfoPatch withCopies(int? value) {
    patchMap[PrintJobInfo$.copies] = value;
    return this;
  }

  PrintJobInfoPatch withNumberOfPages(int? value) {
    patchMap[PrintJobInfo$.numberOfPages] = value;
    return this;
  }

  PrintJobInfoPatch withCreationTime(int? value) {
    patchMap[PrintJobInfo$.creationTime] = value;
    return this;
  }

  PrintJobInfoPatch withLabel(String? value) {
    patchMap[PrintJobInfo$.label] = value;
    return this;
  }

  PrintJobInfoPatch withPrinter(Printer? value) {
    patchMap[PrintJobInfo$.printer] = value;
    return this;
  }

  PrintJobInfoPatch withPrinterPatch(PrinterPatch patch) {
    patchMap[PrintJobInfo$.printer] = patch;
    return this;
  }

  PrintJobInfoPatch withPrinterPatchFunc(
    PrinterPatch Function(PrinterPatch) patch,
  ) {
    patchMap[PrintJobInfo$.printer] = (dynamic current) {
      var currentPatch = PrinterPatch();
      return patch(currentPatch).applyTo(current as Printer);
    };
    return this;
  }

  PrintJobInfoPatch withPageOrder(PrintJobPageOrder? value) {
    patchMap[PrintJobInfo$.pageOrder] = value;
    return this;
  }

  PrintJobInfoPatch withPreferredRenderingQuality(
    PrintJobRenderingQuality? value,
  ) {
    patchMap[PrintJobInfo$.preferredRenderingQuality] = value;
    return this;
  }

  PrintJobInfoPatch withShowsProgressPanel(bool? value) {
    patchMap[PrintJobInfo$.showsProgressPanel] = value;
    return this;
  }

  PrintJobInfoPatch withShowsPrintPanel(bool? value) {
    patchMap[PrintJobInfo$.showsPrintPanel] = value;
    return this;
  }

  PrintJobInfoPatch withCanSpawnSeparateThread(bool? value) {
    patchMap[PrintJobInfo$.canSpawnSeparateThread] = value;
    return this;
  }

  PrintJobInfoPatch withIsCopyingOperation(bool? value) {
    patchMap[PrintJobInfo$.isCopyingOperation] = value;
    return this;
  }

  PrintJobInfoPatch withCurrentPage(int? value) {
    patchMap[PrintJobInfo$.currentPage] = value;
    return this;
  }

  PrintJobInfoPatch withFirstPage(int? value) {
    patchMap[PrintJobInfo$.firstPage] = value;
    return this;
  }

  PrintJobInfoPatch withLastPage(int? value) {
    patchMap[PrintJobInfo$.lastPage] = value;
    return this;
  }

  PrintJobInfoPatch withAttributes(PrintJobAttributes? value) {
    patchMap[PrintJobInfo$.attributes] = value;
    return this;
  }

  PrintJobInfoPatch withAttributesPatch(PrintJobAttributesPatch patch) {
    patchMap[PrintJobInfo$.attributes] = patch;
    return this;
  }

  PrintJobInfoPatch withAttributesPatchFunc(
    PrintJobAttributesPatch Function(PrintJobAttributesPatch) patch,
  ) {
    patchMap[PrintJobInfo$.attributes] = (dynamic current) {
      var currentPatch = PrintJobAttributesPatch();
      return patch(currentPatch).applyTo(current as PrintJobAttributes);
    };
    return this;
  }
}

/// Field descriptors for [PrintJobInfo] query construction
abstract final class PrintJobInfoFields {
  static const state = Field<PrintJobInfo, PrintJobState?>('state', _$state);

  static const copies = Field<PrintJobInfo, int?>('copies', _$copies);

  static const numberOfPages = Field<PrintJobInfo, int?>(
    'numberOfPages',
    _$numberOfPages,
  );

  static const creationTime = Field<PrintJobInfo, int?>(
    'creationTime',
    _$creationTime,
  );

  static const label = Field<PrintJobInfo, String?>('label', _$label);

  static const printer = Field<PrintJobInfo, Printer?>('printer', _$printer);

  static const pageOrder = Field<PrintJobInfo, PrintJobPageOrder?>(
    'pageOrder',
    _$pageOrder,
  );

  static const preferredRenderingQuality =
      Field<PrintJobInfo, PrintJobRenderingQuality?>(
        'preferredRenderingQuality',
        _$preferredRenderingQuality,
      );

  static const showsProgressPanel = Field<PrintJobInfo, bool?>(
    'showsProgressPanel',
    _$showsProgressPanel,
  );

  static const showsPrintPanel = Field<PrintJobInfo, bool?>(
    'showsPrintPanel',
    _$showsPrintPanel,
  );

  static const canSpawnSeparateThread = Field<PrintJobInfo, bool?>(
    'canSpawnSeparateThread',
    _$canSpawnSeparateThread,
  );

  static const isCopyingOperation = Field<PrintJobInfo, bool?>(
    'isCopyingOperation',
    _$isCopyingOperation,
  );

  static const currentPage = Field<PrintJobInfo, int?>(
    'currentPage',
    _$currentPage,
  );

  static const firstPage = Field<PrintJobInfo, int?>('firstPage', _$firstPage);

  static const lastPage = Field<PrintJobInfo, int?>('lastPage', _$lastPage);

  static const attributes = Field<PrintJobInfo, PrintJobAttributes?>(
    'attributes',
    _$attributes,
  );

  static PrintJobState? _$state(PrintJobInfo e) {
    return e.state;
  }

  static int? _$copies(PrintJobInfo e) {
    return e.copies;
  }

  static int? _$numberOfPages(PrintJobInfo e) {
    return e.numberOfPages;
  }

  static int? _$creationTime(PrintJobInfo e) {
    return e.creationTime;
  }

  static String? _$label(PrintJobInfo e) {
    return e.label;
  }

  static Printer? _$printer(PrintJobInfo e) {
    return e.printer;
  }

  static PrintJobPageOrder? _$pageOrder(PrintJobInfo e) {
    return e.pageOrder;
  }

  static PrintJobRenderingQuality? _$preferredRenderingQuality(PrintJobInfo e) {
    return e.preferredRenderingQuality;
  }

  static bool? _$showsProgressPanel(PrintJobInfo e) {
    return e.showsProgressPanel;
  }

  static bool? _$showsPrintPanel(PrintJobInfo e) {
    return e.showsPrintPanel;
  }

  static bool? _$canSpawnSeparateThread(PrintJobInfo e) {
    return e.canSpawnSeparateThread;
  }

  static bool? _$isCopyingOperation(PrintJobInfo e) {
    return e.isCopyingOperation;
  }

  static int? _$currentPage(PrintJobInfo e) {
    return e.currentPage;
  }

  static int? _$firstPage(PrintJobInfo e) {
    return e.firstPage;
  }

  static int? _$lastPage(PrintJobInfo e) {
    return e.lastPage;
  }

  static PrintJobAttributes? _$attributes(PrintJobInfo e) {
    return e.attributes;
  }
}

extension PrintJobInfoCompareE on PrintJobInfo {
  Map<String, dynamic> compareToPrintJobInfo(PrintJobInfo other) {
    final Map<String, dynamic> diff = {};

    if (state != other.state) {
      diff['state'] = () => other.state;
    }

    if (copies != other.copies) {
      diff['copies'] = () => other.copies;
    }

    if (numberOfPages != other.numberOfPages) {
      diff['numberOfPages'] = () => other.numberOfPages;
    }

    if (creationTime != other.creationTime) {
      diff['creationTime'] = () => other.creationTime;
    }

    if (label != other.label) {
      diff['label'] = () => other.label;
    }

    if (printer != other.printer) {
      diff['printer'] = () => other.printer;
    }

    if (pageOrder != other.pageOrder) {
      diff['pageOrder'] = () => other.pageOrder;
    }

    if (preferredRenderingQuality != other.preferredRenderingQuality) {
      diff['preferredRenderingQuality'] = () => other.preferredRenderingQuality;
    }

    if (showsProgressPanel != other.showsProgressPanel) {
      diff['showsProgressPanel'] = () => other.showsProgressPanel;
    }

    if (showsPrintPanel != other.showsPrintPanel) {
      diff['showsPrintPanel'] = () => other.showsPrintPanel;
    }

    if (canSpawnSeparateThread != other.canSpawnSeparateThread) {
      diff['canSpawnSeparateThread'] = () => other.canSpawnSeparateThread;
    }

    if (isCopyingOperation != other.isCopyingOperation) {
      diff['isCopyingOperation'] = () => other.isCopyingOperation;
    }

    if (currentPage != other.currentPage) {
      diff['currentPage'] = () => other.currentPage;
    }

    if (firstPage != other.firstPage) {
      diff['firstPage'] = () => other.firstPage;
    }

    if (lastPage != other.lastPage) {
      diff['lastPage'] = () => other.lastPage;
    }

    if (attributes != other.attributes) {
      diff['attributes'] = () => other.attributes;
    }
    return diff;
  }
}
