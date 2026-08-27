// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'print_job_resolution.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PrintJobResolution {
  PrintJobResolution({
    required String this.id,
    required String this.label,
    required int this.verticalDpi,
    required int this.horizontalDpi,
  });

  factory PrintJobResolution.fromJson(Map<String, dynamic> json) =>
      _$PrintJobResolutionFromJson(json);

  final String id;

  final String label;

  final int verticalDpi;

  final int horizontalDpi;

  PrintJobResolution copyWith({
    String? id,
    String? label,
    int? verticalDpi,
    int? horizontalDpi,
  }) {
    return PrintJobResolution(
      id: id ?? this.id,
      label: label ?? this.label,
      verticalDpi: verticalDpi ?? this.verticalDpi,
      horizontalDpi: horizontalDpi ?? this.horizontalDpi,
    );
  }

  PrintJobResolution copyWithPrintJobResolution({
    String? id,
    String? label,
    int? verticalDpi,
    int? horizontalDpi,
  }) {
    return copyWith(
      id: id,
      label: label,
      verticalDpi: verticalDpi,
      horizontalDpi: horizontalDpi,
    );
  }

  PrintJobResolution patchWithPrintJobResolution([
    PrintJobResolutionPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PrintJobResolutionPatch();
    final _patchMap = _patcher.patchMap;
    return PrintJobResolution(
      id: _patchMap.containsKey(PrintJobResolution$.id)
          ? (_patchMap[PrintJobResolution$.id] is Function)
                ? _patchMap[PrintJobResolution$.id](this.id)
                : (_patchMap[PrintJobResolution$.id] is Patch)
                ? _patchMap[PrintJobResolution$.id].applyTo(this.id)
                : _patchMap[PrintJobResolution$.id]
          : this.id,
      label: _patchMap.containsKey(PrintJobResolution$.label)
          ? (_patchMap[PrintJobResolution$.label] is Function)
                ? _patchMap[PrintJobResolution$.label](this.label)
                : (_patchMap[PrintJobResolution$.label] is Patch)
                ? _patchMap[PrintJobResolution$.label].applyTo(this.label)
                : _patchMap[PrintJobResolution$.label]
          : this.label,
      verticalDpi: _patchMap.containsKey(PrintJobResolution$.verticalDpi)
          ? (_patchMap[PrintJobResolution$.verticalDpi] is Function)
                ? _patchMap[PrintJobResolution$.verticalDpi](this.verticalDpi)
                : (_patchMap[PrintJobResolution$.verticalDpi] is Patch)
                ? _patchMap[PrintJobResolution$.verticalDpi].applyTo(
                    this.verticalDpi,
                  )
                : _patchMap[PrintJobResolution$.verticalDpi]
          : this.verticalDpi,
      horizontalDpi: _patchMap.containsKey(PrintJobResolution$.horizontalDpi)
          ? (_patchMap[PrintJobResolution$.horizontalDpi] is Function)
                ? _patchMap[PrintJobResolution$.horizontalDpi](
                    this.horizontalDpi,
                  )
                : (_patchMap[PrintJobResolution$.horizontalDpi] is Patch)
                ? _patchMap[PrintJobResolution$.horizontalDpi].applyTo(
                    this.horizontalDpi,
                  )
                : _patchMap[PrintJobResolution$.horizontalDpi]
          : this.horizontalDpi,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrintJobResolution &&
        id == other.id &&
        label == other.label &&
        verticalDpi == other.verticalDpi &&
        horizontalDpi == other.horizontalDpi;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.id,
      this.label,
      this.verticalDpi,
      this.horizontalDpi,
    );
  }

  @override
  String toString() {
    return 'PrintJobResolution(' +
        'id: ${id}' +
        ', ' +
        'label: ${label}' +
        ', ' +
        'verticalDpi: ${verticalDpi}' +
        ', ' +
        'horizontalDpi: ${horizontalDpi})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PrintJobResolutionToJson(this);
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

extension PrintJobResolutionPropertyHelpers on PrintJobResolution {
  bool get hasId {
    return this.id.isNotEmpty;
  }

  bool get noId {
    return this.id.isEmpty;
  }

  bool get hasLabel {
    return this.label.isNotEmpty;
  }

  bool get noLabel {
    return this.label.isEmpty;
  }
}

extension PrintJobResolutionSerialization on PrintJobResolution {
  Map<String, dynamic> toJson() {
    return _$PrintJobResolutionToJson(this);
  }
}

enum PrintJobResolution$ { id, label, verticalDpi, horizontalDpi }

class PrintJobResolutionPatch
    extends PatchBase<PrintJobResolution, PrintJobResolution$> {
  PrintJobResolution applyTo(PrintJobResolution entity) {
    return entity.patchWithPrintJobResolution(this);
  }

  PrintJobResolutionPatch withId(String? value) {
    patchMap[PrintJobResolution$.id] = value;
    return this;
  }

  PrintJobResolutionPatch withLabel(String? value) {
    patchMap[PrintJobResolution$.label] = value;
    return this;
  }

  PrintJobResolutionPatch withVerticalDpi(int? value) {
    patchMap[PrintJobResolution$.verticalDpi] = value;
    return this;
  }

  PrintJobResolutionPatch withHorizontalDpi(int? value) {
    patchMap[PrintJobResolution$.horizontalDpi] = value;
    return this;
  }
}

/// Field descriptors for [PrintJobResolution] query construction
abstract final class PrintJobResolutionFields {
  static const id = Field<PrintJobResolution, String>('id', _$id);

  static const label = Field<PrintJobResolution, String>('label', _$label);

  static const verticalDpi = Field<PrintJobResolution, int>(
    'verticalDpi',
    _$verticalDpi,
  );

  static const horizontalDpi = Field<PrintJobResolution, int>(
    'horizontalDpi',
    _$horizontalDpi,
  );

  static String _$id(PrintJobResolution e) {
    return e.id;
  }

  static String _$label(PrintJobResolution e) {
    return e.label;
  }

  static int _$verticalDpi(PrintJobResolution e) {
    return e.verticalDpi;
  }

  static int _$horizontalDpi(PrintJobResolution e) {
    return e.horizontalDpi;
  }
}

extension PrintJobResolutionCompareE on PrintJobResolution {
  Map<String, dynamic> compareToPrintJobResolution(PrintJobResolution other) {
    final Map<String, dynamic> diff = {};

    if (id != other.id) {
      diff['id'] = () => other.id;
    }

    if (label != other.label) {
      diff['label'] = () => other.label;
    }

    if (verticalDpi != other.verticalDpi) {
      diff['verticalDpi'] = () => other.verticalDpi;
    }

    if (horizontalDpi != other.horizontalDpi) {
      diff['horizontalDpi'] = () => other.horizontalDpi;
    }
    return diff;
  }
}
