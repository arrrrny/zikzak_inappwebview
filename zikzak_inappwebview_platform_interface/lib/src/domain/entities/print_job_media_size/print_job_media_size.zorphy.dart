// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'print_job_media_size.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PrintJobMediaSize {
  PrintJobMediaSize({
    required String this.id,
    required int this.widthMils,
    required int this.heightMils,
    String? this.label,
  });

  factory PrintJobMediaSize.fromJson(Map<String, dynamic> json) =>
      _$PrintJobMediaSizeFromJson(json);

  final String id;

  final int widthMils;

  final int heightMils;

  final String? label;

  PrintJobMediaSize copyWith({
    String? id,
    int? widthMils,
    int? heightMils,
    String? label,
  }) {
    return PrintJobMediaSize(
      id: id ?? this.id,
      widthMils: widthMils ?? this.widthMils,
      heightMils: heightMils ?? this.heightMils,
      label: label ?? this.label,
    );
  }

  PrintJobMediaSize copyWithPrintJobMediaSize({
    String? id,
    int? widthMils,
    int? heightMils,
    String? label,
  }) {
    return copyWith(
      id: id,
      widthMils: widthMils,
      heightMils: heightMils,
      label: label,
    );
  }

  PrintJobMediaSize patchWithPrintJobMediaSize([
    PrintJobMediaSizePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PrintJobMediaSizePatch();
    final _patchMap = _patcher.patchMap;
    return PrintJobMediaSize(
      id: _patchMap.containsKey(PrintJobMediaSize$.id)
          ? (_patchMap[PrintJobMediaSize$.id] is Function)
                ? _patchMap[PrintJobMediaSize$.id](this.id)
                : (_patchMap[PrintJobMediaSize$.id] is Patch)
                ? _patchMap[PrintJobMediaSize$.id].applyTo(this.id)
                : _patchMap[PrintJobMediaSize$.id]
          : this.id,
      widthMils: _patchMap.containsKey(PrintJobMediaSize$.widthMils)
          ? (_patchMap[PrintJobMediaSize$.widthMils] is Function)
                ? _patchMap[PrintJobMediaSize$.widthMils](this.widthMils)
                : (_patchMap[PrintJobMediaSize$.widthMils] is Patch)
                ? _patchMap[PrintJobMediaSize$.widthMils].applyTo(
                    this.widthMils,
                  )
                : _patchMap[PrintJobMediaSize$.widthMils]
          : this.widthMils,
      heightMils: _patchMap.containsKey(PrintJobMediaSize$.heightMils)
          ? (_patchMap[PrintJobMediaSize$.heightMils] is Function)
                ? _patchMap[PrintJobMediaSize$.heightMils](this.heightMils)
                : (_patchMap[PrintJobMediaSize$.heightMils] is Patch)
                ? _patchMap[PrintJobMediaSize$.heightMils].applyTo(
                    this.heightMils,
                  )
                : _patchMap[PrintJobMediaSize$.heightMils]
          : this.heightMils,
      label: _patchMap.containsKey(PrintJobMediaSize$.label)
          ? (_patchMap[PrintJobMediaSize$.label] is Function)
                ? _patchMap[PrintJobMediaSize$.label](this.label)
                : (_patchMap[PrintJobMediaSize$.label] is Patch)
                ? _patchMap[PrintJobMediaSize$.label].applyTo(this.label)
                : _patchMap[PrintJobMediaSize$.label]
          : this.label,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrintJobMediaSize &&
        id == other.id &&
        widthMils == other.widthMils &&
        heightMils == other.heightMils &&
        label == other.label;
  }

  @override
  int get hashCode {
    return Object.hash(this.id, this.widthMils, this.heightMils, this.label);
  }

  @override
  String toString() {
    return 'PrintJobMediaSize(' +
        'id: ${id}' +
        ', ' +
        'widthMils: ${widthMils}' +
        ', ' +
        'heightMils: ${heightMils}' +
        ', ' +
        'label: ${label})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PrintJobMediaSizeToJson(this);
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

extension PrintJobMediaSizePropertyHelpers on PrintJobMediaSize {
  bool get hasId {
    return this.id.isNotEmpty;
  }

  bool get noId {
    return this.id.isEmpty;
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
}

extension PrintJobMediaSizeSerialization on PrintJobMediaSize {
  Map<String, dynamic> toJson() {
    return _$PrintJobMediaSizeToJson(this);
  }
}

enum PrintJobMediaSize$ { id, widthMils, heightMils, label }

class PrintJobMediaSizePatch
    extends PatchBase<PrintJobMediaSize, PrintJobMediaSize$> {
  PrintJobMediaSize applyTo(PrintJobMediaSize entity) {
    return entity.patchWithPrintJobMediaSize(this);
  }

  PrintJobMediaSizePatch withId(String? value) {
    patchMap[PrintJobMediaSize$.id] = value;
    return this;
  }

  PrintJobMediaSizePatch withWidthMils(int? value) {
    patchMap[PrintJobMediaSize$.widthMils] = value;
    return this;
  }

  PrintJobMediaSizePatch withHeightMils(int? value) {
    patchMap[PrintJobMediaSize$.heightMils] = value;
    return this;
  }

  PrintJobMediaSizePatch withLabel(String? value) {
    patchMap[PrintJobMediaSize$.label] = value;
    return this;
  }
}

/// Field descriptors for [PrintJobMediaSize] query construction
abstract final class PrintJobMediaSizeFields {
  static const id = Field<PrintJobMediaSize, String>('id', _$id);

  static const widthMils = Field<PrintJobMediaSize, int>(
    'widthMils',
    _$widthMils,
  );

  static const heightMils = Field<PrintJobMediaSize, int>(
    'heightMils',
    _$heightMils,
  );

  static const label = Field<PrintJobMediaSize, String?>('label', _$label);

  static String _$id(PrintJobMediaSize e) {
    return e.id;
  }

  static int _$widthMils(PrintJobMediaSize e) {
    return e.widthMils;
  }

  static int _$heightMils(PrintJobMediaSize e) {
    return e.heightMils;
  }

  static String? _$label(PrintJobMediaSize e) {
    return e.label;
  }
}

extension PrintJobMediaSizeCompareE on PrintJobMediaSize {
  Map<String, dynamic> compareToPrintJobMediaSize(PrintJobMediaSize other) {
    final Map<String, dynamic> diff = {};

    if (id != other.id) {
      diff['id'] = () => other.id;
    }

    if (widthMils != other.widthMils) {
      diff['widthMils'] = () => other.widthMils;
    }

    if (heightMils != other.heightMils) {
      diff['heightMils'] = () => other.heightMils;
    }

    if (label != other.label) {
      diff['label'] = () => other.label;
    }
    return diff;
  }
}
