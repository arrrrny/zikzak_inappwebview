// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'printer.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class Printer {
  Printer({
    String? this.id,
    String? this.type,
    int? this.languageLevel,
    String? this.name,
  });

  factory Printer.fromJson(Map<String, dynamic> json) =>
      _$PrinterFromJson(json);

  final String? id;

  final String? type;

  final int? languageLevel;

  final String? name;

  Printer copyWith({
    String? id,
    String? type,
    int? languageLevel,
    String? name,
  }) {
    return Printer(
      id: id ?? this.id,
      type: type ?? this.type,
      languageLevel: languageLevel ?? this.languageLevel,
      name: name ?? this.name,
    );
  }

  Printer copyWithPrinter({
    String? id,
    String? type,
    int? languageLevel,
    String? name,
  }) {
    return copyWith(
      id: id,
      type: type,
      languageLevel: languageLevel,
      name: name,
    );
  }

  Printer patchWithPrinter([PrinterPatch? patchInput]) {
    final _patcher = patchInput ?? PrinterPatch();
    final _patchMap = _patcher.patchMap;
    return Printer(
      id: _patchMap.containsKey(Printer$.id)
          ? (_patchMap[Printer$.id] is Function)
                ? _patchMap[Printer$.id](this.id)
                : (_patchMap[Printer$.id] is Patch)
                ? _patchMap[Printer$.id].applyTo(this.id)
                : _patchMap[Printer$.id]
          : this.id,
      type: _patchMap.containsKey(Printer$.type)
          ? (_patchMap[Printer$.type] is Function)
                ? _patchMap[Printer$.type](this.type)
                : (_patchMap[Printer$.type] is Patch)
                ? _patchMap[Printer$.type].applyTo(this.type)
                : _patchMap[Printer$.type]
          : this.type,
      languageLevel: _patchMap.containsKey(Printer$.languageLevel)
          ? (_patchMap[Printer$.languageLevel] is Function)
                ? _patchMap[Printer$.languageLevel](this.languageLevel)
                : (_patchMap[Printer$.languageLevel] is Patch)
                ? _patchMap[Printer$.languageLevel].applyTo(this.languageLevel)
                : _patchMap[Printer$.languageLevel]
          : this.languageLevel,
      name: _patchMap.containsKey(Printer$.name_)
          ? (_patchMap[Printer$.name_] is Function)
                ? _patchMap[Printer$.name_](this.name)
                : (_patchMap[Printer$.name_] is Patch)
                ? _patchMap[Printer$.name_].applyTo(this.name)
                : _patchMap[Printer$.name_]
          : this.name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Printer &&
        id == other.id &&
        type == other.type &&
        languageLevel == other.languageLevel &&
        name == other.name;
  }

  @override
  int get hashCode {
    return Object.hash(this.id, this.type, this.languageLevel, this.name);
  }

  @override
  String toString() {
    return 'Printer(' +
        'id: ${id}' +
        ', ' +
        'type: ${type}' +
        ', ' +
        'languageLevel: ${languageLevel}' +
        ', ' +
        'name: ${name})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PrinterToJson(this);
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

extension PrinterPropertyHelpers on Printer {
  bool get hasId {
    return this.id?.isNotEmpty == true;
  }

  bool get noId {
    return this.id?.isEmpty ?? true;
  }

  String get idRequired {
    return this.id ?? (throw StateError('id is required but was null'));
  }

  bool get hasType {
    return this.type?.isNotEmpty == true;
  }

  bool get noType {
    return this.type?.isEmpty ?? true;
  }

  String get typeRequired {
    return this.type ?? (throw StateError('type is required but was null'));
  }

  bool get hasLanguageLevel {
    return this.languageLevel != null;
  }

  bool get noLanguageLevel {
    return this.languageLevel == null;
  }

  int get languageLevelRequired {
    return this.languageLevel ??
        (throw StateError('languageLevel is required but was null'));
  }

  bool get hasName {
    return this.name?.isNotEmpty == true;
  }

  bool get noName {
    return this.name?.isEmpty ?? true;
  }

  String get nameRequired {
    return this.name ?? (throw StateError('name is required but was null'));
  }
}

extension PrinterSerialization on Printer {
  Map<String, dynamic> toJson() {
    return _$PrinterToJson(this);
  }
}

enum Printer$ { id, type, languageLevel, name_ }

class PrinterPatch extends PatchBase<Printer, Printer$> {
  Printer applyTo(Printer entity) {
    return entity.patchWithPrinter(this);
  }

  PrinterPatch withId(String? value) {
    patchMap[Printer$.id] = value;
    return this;
  }

  PrinterPatch withType(String? value) {
    patchMap[Printer$.type] = value;
    return this;
  }

  PrinterPatch withLanguageLevel(int? value) {
    patchMap[Printer$.languageLevel] = value;
    return this;
  }

  PrinterPatch withName(String? value) {
    patchMap[Printer$.name_] = value;
    return this;
  }
}

/// Field descriptors for [Printer] query construction
abstract final class PrinterFields {
  static const id = Field<Printer, String?>('id', _$id);

  static const type = Field<Printer, String?>('type', _$type);

  static const languageLevel = Field<Printer, int?>(
    'languageLevel',
    _$languageLevel,
  );

  static const name = Field<Printer, String?>('name', _$name);

  static String? _$id(Printer e) {
    return e.id;
  }

  static String? _$type(Printer e) {
    return e.type;
  }

  static int? _$languageLevel(Printer e) {
    return e.languageLevel;
  }

  static String? _$name(Printer e) {
    return e.name;
  }
}

extension PrinterCompareE on Printer {
  Map<String, dynamic> compareToPrinter(Printer other) {
    final Map<String, dynamic> diff = {};

    if (id != other.id) {
      diff['id'] = () => other.id;
    }

    if (type != other.type) {
      diff['type'] = () => other.type;
    }

    if (languageLevel != other.languageLevel) {
      diff['languageLevel'] = () => other.languageLevel;
    }

    if (name != other.name) {
      diff['name'] = () => other.name;
    }
    return diff;
  }
}
