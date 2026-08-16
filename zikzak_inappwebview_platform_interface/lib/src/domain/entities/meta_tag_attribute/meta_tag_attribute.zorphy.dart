// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'meta_tag_attribute.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class MetaTagAttribute {
  MetaTagAttribute({String? this.name, String? this.value});

  factory MetaTagAttribute.fromJson(Map<String, dynamic> json) =>
      _$MetaTagAttributeFromJson(json);

  final String? name;

  final String? value;

  MetaTagAttribute copyWith({String? name, String? value}) {
    return MetaTagAttribute(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  MetaTagAttribute copyWithMetaTagAttribute({String? name, String? value}) {
    return copyWith(name: name, value: value);
  }

  MetaTagAttribute patchWithMetaTagAttribute([
    MetaTagAttributePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? MetaTagAttributePatch();
    final _patchMap = _patcher.patchMap;
    return MetaTagAttribute(
      name: _patchMap.containsKey(MetaTagAttribute$.name_)
          ? (_patchMap[MetaTagAttribute$.name_] is Function)
                ? _patchMap[MetaTagAttribute$.name_](this.name)
                : (_patchMap[MetaTagAttribute$.name_] is Patch)
                ? _patchMap[MetaTagAttribute$.name_].applyTo(this.name)
                : _patchMap[MetaTagAttribute$.name_]
          : this.name,
      value: _patchMap.containsKey(MetaTagAttribute$.value)
          ? (_patchMap[MetaTagAttribute$.value] is Function)
                ? _patchMap[MetaTagAttribute$.value](this.value)
                : (_patchMap[MetaTagAttribute$.value] is Patch)
                ? _patchMap[MetaTagAttribute$.value].applyTo(this.value)
                : _patchMap[MetaTagAttribute$.value]
          : this.value,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MetaTagAttribute &&
        name == other.name &&
        value == other.value;
  }

  @override
  int get hashCode {
    return Object.hash(this.name, this.value);
  }

  @override
  String toString() {
    return 'MetaTagAttribute(' + 'name: ${name}' + ', ' + 'value: ${value})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$MetaTagAttributeToJson(this);
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

extension MetaTagAttributePropertyHelpers on MetaTagAttribute {
  bool get hasName {
    return this.name?.isNotEmpty == true;
  }

  bool get noName {
    return this.name?.isEmpty ?? true;
  }

  String get nameRequired {
    return this.name ?? (throw StateError('name is required but was null'));
  }

  bool get hasValue {
    return this.value?.isNotEmpty == true;
  }

  bool get noValue {
    return this.value?.isEmpty ?? true;
  }

  String get valueRequired {
    return this.value ?? (throw StateError('value is required but was null'));
  }
}

extension MetaTagAttributeSerialization on MetaTagAttribute {
  Map<String, dynamic> toJson() {
    return _$MetaTagAttributeToJson(this);
  }
}

enum MetaTagAttribute$ { name_, value }

class MetaTagAttributePatch
    extends PatchBase<MetaTagAttribute, MetaTagAttribute$> {
  MetaTagAttribute applyTo(MetaTagAttribute entity) {
    return entity.patchWithMetaTagAttribute(this);
  }

  MetaTagAttributePatch withName(String? value) {
    patchMap[MetaTagAttribute$.name_] = value;
    return this;
  }

  MetaTagAttributePatch withValue(String? value) {
    patchMap[MetaTagAttribute$.value] = value;
    return this;
  }
}

/// Field descriptors for [MetaTagAttribute] query construction
abstract final class MetaTagAttributeFields {
  static const name = Field<MetaTagAttribute, String?>('name', _$name);

  static const value = Field<MetaTagAttribute, String?>('value', _$value);

  static String? _$name(MetaTagAttribute e) {
    return e.name;
  }

  static String? _$value(MetaTagAttribute e) {
    return e.value;
  }
}

extension MetaTagAttributeCompareE on MetaTagAttribute {
  Map<String, dynamic> compareToMetaTagAttribute(MetaTagAttribute other) {
    final Map<String, dynamic> diff = {};

    if (name != other.name) {
      diff['name'] = () => other.name;
    }

    if (value != other.value) {
      diff['value'] = () => other.value;
    }
    return diff;
  }
}
