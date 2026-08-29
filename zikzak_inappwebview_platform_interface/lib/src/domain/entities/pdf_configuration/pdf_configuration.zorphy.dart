// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'pdf_configuration.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PDFConfiguration {
  PDFConfiguration({
    InAppWebViewRect? this.rect,
    Size? this.pageSize,
    EdgeInsets? this.margins,
    PrintJobOrientation? this.orientation,
  });

  factory PDFConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PDFConfigurationFromJson(json);

  @JsonKey(toJson: _rectToJson, fromJson: _rectFromJson)
  final InAppWebViewRect? rect;

  @JsonKey(toJson: _pageSizeToJson, fromJson: _pageSizeFromJson)
  final Size? pageSize;

  @JsonKey(toJson: _marginsToJson, fromJson: _marginsFromJson)
  final EdgeInsets? margins;

  @JsonKey(toJson: _orientationToJson, fromJson: _orientationFromJson)
  final PrintJobOrientation? orientation;

  PDFConfiguration copyWith({
    InAppWebViewRect? rect,
    Size? pageSize,
    EdgeInsets? margins,
    PrintJobOrientation? orientation,
  }) {
    return PDFConfiguration(
      rect: rect ?? this.rect,
      pageSize: pageSize ?? this.pageSize,
      margins: margins ?? this.margins,
      orientation: orientation ?? this.orientation,
    );
  }

  PDFConfiguration copyWithPDFConfiguration({
    InAppWebViewRect? rect,
    Size? pageSize,
    EdgeInsets? margins,
    PrintJobOrientation? orientation,
  }) {
    return copyWith(
      rect: rect,
      pageSize: pageSize,
      margins: margins,
      orientation: orientation,
    );
  }

  PDFConfiguration patchWithPDFConfiguration([
    PDFConfigurationPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PDFConfigurationPatch();
    final _patchMap = _patcher.patchMap;
    return PDFConfiguration(
      rect: _patchMap.containsKey(PDFConfiguration$.rect)
          ? ((_patchMap[PDFConfiguration$.rect] is Function)
                    ? _patchMap[PDFConfiguration$.rect](this.rect)
                    : (_patchMap[PDFConfiguration$.rect] is Patch)
                    ? _patchMap[PDFConfiguration$.rect].applyTo(this.rect)
                    : _patchMap[PDFConfiguration$.rect])
                as InAppWebViewRect?
          : this.rect,
      pageSize: _patchMap.containsKey(PDFConfiguration$.pageSize)
          ? ((_patchMap[PDFConfiguration$.pageSize] is Function)
                    ? _patchMap[PDFConfiguration$.pageSize](this.pageSize)
                    : (_patchMap[PDFConfiguration$.pageSize] is Patch)
                    ? _patchMap[PDFConfiguration$.pageSize].applyTo(
                        this.pageSize,
                      )
                    : _patchMap[PDFConfiguration$.pageSize])
                as Size?
          : this.pageSize,
      margins: _patchMap.containsKey(PDFConfiguration$.margins)
          ? ((_patchMap[PDFConfiguration$.margins] is Function)
                    ? _patchMap[PDFConfiguration$.margins](this.margins)
                    : (_patchMap[PDFConfiguration$.margins] is Patch)
                    ? _patchMap[PDFConfiguration$.margins].applyTo(this.margins)
                    : _patchMap[PDFConfiguration$.margins])
                as EdgeInsets?
          : this.margins,
      orientation: _patchMap.containsKey(PDFConfiguration$.orientation)
          ? ((_patchMap[PDFConfiguration$.orientation] is Function)
                    ? _patchMap[PDFConfiguration$.orientation](this.orientation)
                    : (_patchMap[PDFConfiguration$.orientation] is Patch)
                    ? _patchMap[PDFConfiguration$.orientation].applyTo(
                        this.orientation,
                      )
                    : _patchMap[PDFConfiguration$.orientation])
                as PrintJobOrientation?
          : this.orientation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PDFConfiguration &&
        rect == other.rect &&
        pageSize == other.pageSize &&
        margins == other.margins &&
        orientation == other.orientation;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.rect,
      this.pageSize,
      this.margins,
      this.orientation,
    );
  }

  @override
  String toString() {
    return 'PDFConfiguration(' +
        'rect: ${rect}' +
        ', ' +
        'pageSize: ${pageSize}' +
        ', ' +
        'margins: ${margins}' +
        ', ' +
        'orientation: ${orientation})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PDFConfigurationToJson(this);
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

extension PDFConfigurationPropertyHelpers on PDFConfiguration {
  bool get hasRect {
    return this.rect != null;
  }

  bool get noRect {
    return this.rect == null;
  }

  InAppWebViewRect get rectRequired {
    return this.rect ?? (throw StateError('rect is required but was null'));
  }

  bool get hasPageSize {
    return this.pageSize != null;
  }

  bool get noPageSize {
    return this.pageSize == null;
  }

  Size get pageSizeRequired {
    return this.pageSize ??
        (throw StateError('pageSize is required but was null'));
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
}

extension PDFConfigurationSerialization on PDFConfiguration {
  Map<String, dynamic> toJson() {
    return _$PDFConfigurationToJson(this);
  }
}

enum PDFConfiguration$ { rect, pageSize, margins, orientation }

class PDFConfigurationPatch
    extends PatchBase<PDFConfiguration, PDFConfiguration$> {
  PDFConfiguration applyTo(PDFConfiguration entity) {
    return entity.patchWithPDFConfiguration(this);
  }

  PDFConfigurationPatch withRect(InAppWebViewRect? value) {
    patchMap[PDFConfiguration$.rect] = value;
    return this;
  }

  PDFConfigurationPatch withRectPatch(InAppWebViewRectPatch patch) {
    patchMap[PDFConfiguration$.rect] = patch;
    return this;
  }

  PDFConfigurationPatch withRectPatchFunc(
    InAppWebViewRectPatch Function(InAppWebViewRectPatch) patch,
  ) {
    patchMap[PDFConfiguration$.rect] = (dynamic current) {
      var currentPatch = InAppWebViewRectPatch();
      return patch(currentPatch).applyTo(current as InAppWebViewRect);
    };
    return this;
  }

  PDFConfigurationPatch withPageSize(Size? value) {
    patchMap[PDFConfiguration$.pageSize] = value;
    return this;
  }

  PDFConfigurationPatch withMargins(EdgeInsets? value) {
    patchMap[PDFConfiguration$.margins] = value;
    return this;
  }

  PDFConfigurationPatch withOrientation(PrintJobOrientation? value) {
    patchMap[PDFConfiguration$.orientation] = value;
    return this;
  }
}

/// Field descriptors for [PDFConfiguration] query construction
abstract final class PDFConfigurationFields {
  static const rect = Field<PDFConfiguration, InAppWebViewRect?>(
    'rect',
    _$rect,
  );

  static const pageSize = Field<PDFConfiguration, Size?>(
    'pageSize',
    _$pageSize,
  );

  static const margins = Field<PDFConfiguration, EdgeInsets?>(
    'margins',
    _$margins,
  );

  static const orientation = Field<PDFConfiguration, PrintJobOrientation?>(
    'orientation',
    _$orientation,
  );

  static InAppWebViewRect? _$rect(PDFConfiguration e) {
    return e.rect;
  }

  static Size? _$pageSize(PDFConfiguration e) {
    return e.pageSize;
  }

  static EdgeInsets? _$margins(PDFConfiguration e) {
    return e.margins;
  }

  static PrintJobOrientation? _$orientation(PDFConfiguration e) {
    return e.orientation;
  }
}

extension PDFConfigurationCompareE on PDFConfiguration {
  Map<String, dynamic> compareToPDFConfiguration(PDFConfiguration other) {
    final Map<String, dynamic> diff = {};

    if (rect != other.rect) {
      diff['rect'] = () => other.rect;
    }

    if (pageSize != other.pageSize) {
      diff['pageSize'] = () => other.pageSize;
    }

    if (margins != other.margins) {
      diff['margins'] = () => other.margins;
    }

    if (orientation != other.orientation) {
      diff['orientation'] = () => other.orientation;
    }
    return diff;
  }
}
