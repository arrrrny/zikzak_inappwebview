// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'android_resource.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class AndroidResource {
  AndroidResource({
    required String this.name,
    String? this.defType,
    String? this.defPackage,
  });

  factory AndroidResource.fromJson(Map<String, dynamic> json) =>
      _$AndroidResourceFromJson(json);

  final String name;

  final String? defType;

  final String? defPackage;

  AndroidResource copyWith({
    String? name,
    String? defType,
    String? defPackage,
  }) {
    return AndroidResource(
      name: name ?? this.name,
      defType: defType ?? this.defType,
      defPackage: defPackage ?? this.defPackage,
    );
  }

  AndroidResource copyWithAndroidResource({
    String? name,
    String? defType,
    String? defPackage,
  }) {
    return copyWith(name: name, defType: defType, defPackage: defPackage);
  }

  AndroidResource patchWithAndroidResource([AndroidResourcePatch? patchInput]) {
    final _patcher = patchInput ?? AndroidResourcePatch();
    final _patchMap = _patcher.patchMap;
    return AndroidResource(
      name: _patchMap.containsKey(AndroidResource$.name_)
          ? (_patchMap[AndroidResource$.name_] is Function)
                ? _patchMap[AndroidResource$.name_](this.name)
                : (_patchMap[AndroidResource$.name_] is Patch)
                ? _patchMap[AndroidResource$.name_].applyTo(this.name)
                : _patchMap[AndroidResource$.name_]
          : this.name,
      defType: _patchMap.containsKey(AndroidResource$.defType)
          ? (_patchMap[AndroidResource$.defType] is Function)
                ? _patchMap[AndroidResource$.defType](this.defType)
                : (_patchMap[AndroidResource$.defType] is Patch)
                ? _patchMap[AndroidResource$.defType].applyTo(this.defType)
                : _patchMap[AndroidResource$.defType]
          : this.defType,
      defPackage: _patchMap.containsKey(AndroidResource$.defPackage)
          ? (_patchMap[AndroidResource$.defPackage] is Function)
                ? _patchMap[AndroidResource$.defPackage](this.defPackage)
                : (_patchMap[AndroidResource$.defPackage] is Patch)
                ? _patchMap[AndroidResource$.defPackage].applyTo(
                    this.defPackage,
                  )
                : _patchMap[AndroidResource$.defPackage]
          : this.defPackage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AndroidResource &&
        name == other.name &&
        defType == other.defType &&
        defPackage == other.defPackage;
  }

  @override
  int get hashCode {
    return Object.hash(this.name, this.defType, this.defPackage);
  }

  @override
  String toString() {
    return 'AndroidResource(' +
        'name: ${name}' +
        ', ' +
        'defType: ${defType}' +
        ', ' +
        'defPackage: ${defPackage})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$AndroidResourceToJson(this);
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

extension AndroidResourcePropertyHelpers on AndroidResource {
  bool get hasName {
    return this.name.isNotEmpty;
  }

  bool get noName {
    return this.name.isEmpty;
  }

  bool get hasDefType {
    return this.defType?.isNotEmpty == true;
  }

  bool get noDefType {
    return this.defType?.isEmpty ?? true;
  }

  String get defTypeRequired {
    return this.defType ??
        (throw StateError('defType is required but was null'));
  }

  bool get hasDefPackage {
    return this.defPackage?.isNotEmpty == true;
  }

  bool get noDefPackage {
    return this.defPackage?.isEmpty ?? true;
  }

  String get defPackageRequired {
    return this.defPackage ??
        (throw StateError('defPackage is required but was null'));
  }
}

extension AndroidResourceSerialization on AndroidResource {
  Map<String, dynamic> toJson() {
    return _$AndroidResourceToJson(this);
  }
}

enum AndroidResource$ { name_, defType, defPackage }

class AndroidResourcePatch
    extends PatchBase<AndroidResource, AndroidResource$> {
  AndroidResource applyTo(AndroidResource entity) {
    return entity.patchWithAndroidResource(this);
  }

  AndroidResourcePatch withName(String? value) {
    patchMap[AndroidResource$.name_] = value;
    return this;
  }

  AndroidResourcePatch withDefType(String? value) {
    patchMap[AndroidResource$.defType] = value;
    return this;
  }

  AndroidResourcePatch withDefPackage(String? value) {
    patchMap[AndroidResource$.defPackage] = value;
    return this;
  }
}

/// Field descriptors for [AndroidResource] query construction
abstract final class AndroidResourceFields {
  static const name = Field<AndroidResource, String>('name', _$name);

  static const defType = Field<AndroidResource, String?>('defType', _$defType);

  static const defPackage = Field<AndroidResource, String?>(
    'defPackage',
    _$defPackage,
  );

  static String _$name(AndroidResource e) {
    return e.name;
  }

  static String? _$defType(AndroidResource e) {
    return e.defType;
  }

  static String? _$defPackage(AndroidResource e) {
    return e.defPackage;
  }
}

extension AndroidResourceCompareE on AndroidResource {
  Map<String, dynamic> compareToAndroidResource(AndroidResource other) {
    final Map<String, dynamic> diff = {};

    if (name != other.name) {
      diff['name'] = () => other.name;
    }

    if (defType != other.defType) {
      diff['defType'] = () => other.defType;
    }

    if (defPackage != other.defPackage) {
      diff['defPackage'] = () => other.defPackage;
    }
    return diff;
  }
}
