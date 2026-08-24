// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'pdf_configuration.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PDFConfiguration {
  PDFConfiguration({InAppWebViewRect? this.rect});

  factory PDFConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PDFConfigurationFromJson(json);

  @JsonKey(toJson: _rectToJson, fromJson: _rectFromJson)
  final InAppWebViewRect? rect;

  PDFConfiguration copyWith({InAppWebViewRect? rect}) {
    return PDFConfiguration(rect: rect ?? this.rect);
  }

  PDFConfiguration copyWithPDFConfiguration({InAppWebViewRect? rect}) {
    return copyWith(rect: rect);
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
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PDFConfiguration && rect == other.rect;
  }

  @override
  int get hashCode {
    return Object.hash(rect, 0);
  }

  @override
  String toString() {
    return 'PDFConfiguration(' + 'rect: ${rect})';
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
}

extension PDFConfigurationSerialization on PDFConfiguration {
  Map<String, dynamic> toJson() {
    return _$PDFConfigurationToJson(this);
  }
}

enum PDFConfiguration$ { rect }

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
}

/// Field descriptors for [PDFConfiguration] query construction
abstract final class PDFConfigurationFields {
  static const rect = Field<PDFConfiguration, InAppWebViewRect?>(
    'rect',
    _$rect,
  );

  static InAppWebViewRect? _$rect(PDFConfiguration e) {
    return e.rect;
  }
}

extension PDFConfigurationCompareE on PDFConfiguration {
  Map<String, dynamic> compareToPDFConfiguration(PDFConfiguration other) {
    final Map<String, dynamic> diff = {};

    if (rect != other.rect) {
      diff['rect'] = () => other.rect;
    }
    return diff;
  }
}
