// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'ui_image.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class UIImage {
  UIImage({String? this.name, String? this.systemName, Uint8List? this.data});

  factory UIImage.fromJson(Map<String, dynamic> json) =>
      _$UIImageFromJson(json);

  final String? name;

  final String? systemName;

  @JsonKey(toJson: _dataToJson, fromJson: _dataFromJson)
  final Uint8List? data;

  UIImage copyWith({String? name, String? systemName, Uint8List? data}) {
    return UIImage(
      name: name ?? this.name,
      systemName: systemName ?? this.systemName,
      data: data ?? this.data,
    );
  }

  UIImage copyWithUIImage({String? name, String? systemName, Uint8List? data}) {
    return copyWith(name: name, systemName: systemName, data: data);
  }

  UIImage patchWithUIImage([UIImagePatch? patchInput]) {
    final _patcher = patchInput ?? UIImagePatch();
    final _patchMap = _patcher.patchMap;
    return UIImage(
      name: _patchMap.containsKey(UIImage$.name_)
          ? (_patchMap[UIImage$.name_] is Function)
                ? _patchMap[UIImage$.name_](this.name)
                : (_patchMap[UIImage$.name_] is Patch)
                ? _patchMap[UIImage$.name_].applyTo(this.name)
                : _patchMap[UIImage$.name_]
          : this.name,
      systemName: _patchMap.containsKey(UIImage$.systemName)
          ? (_patchMap[UIImage$.systemName] is Function)
                ? _patchMap[UIImage$.systemName](this.systemName)
                : (_patchMap[UIImage$.systemName] is Patch)
                ? _patchMap[UIImage$.systemName].applyTo(this.systemName)
                : _patchMap[UIImage$.systemName]
          : this.systemName,
      data: _patchMap.containsKey(UIImage$.data)
          ? (_patchMap[UIImage$.data] is Function)
                ? _patchMap[UIImage$.data](this.data)
                : (_patchMap[UIImage$.data] is Patch)
                ? _patchMap[UIImage$.data].applyTo(this.data)
                : _patchMap[UIImage$.data]
          : this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UIImage &&
        name == other.name &&
        systemName == other.systemName &&
        data == other.data;
  }

  @override
  int get hashCode {
    return Object.hash(this.name, this.systemName, this.data);
  }

  @override
  String toString() {
    return 'UIImage(' +
        'name: ${name}' +
        ', ' +
        'systemName: ${systemName}' +
        ', ' +
        'data: ${data})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$UIImageToJson(this);
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

extension UIImagePropertyHelpers on UIImage {
  bool get hasName {
    return this.name?.isNotEmpty == true;
  }

  bool get noName {
    return this.name?.isEmpty ?? true;
  }

  String get nameRequired {
    return this.name ?? (throw StateError('name is required but was null'));
  }

  bool get hasSystemName {
    return this.systemName?.isNotEmpty == true;
  }

  bool get noSystemName {
    return this.systemName?.isEmpty ?? true;
  }

  String get systemNameRequired {
    return this.systemName ??
        (throw StateError('systemName is required but was null'));
  }

  bool get hasData {
    return this.data != null;
  }

  bool get noData {
    return this.data == null;
  }

  Uint8List get dataRequired {
    return this.data ?? (throw StateError('data is required but was null'));
  }
}

extension UIImageSerialization on UIImage {
  Map<String, dynamic> toJson() {
    return _$UIImageToJson(this);
  }
}

enum UIImage$ { name_, systemName, data }

class UIImagePatch extends PatchBase<UIImage, UIImage$> {
  UIImage applyTo(UIImage entity) {
    return entity.patchWithUIImage(this);
  }

  UIImagePatch withName(String? value) {
    patchMap[UIImage$.name_] = value;
    return this;
  }

  UIImagePatch withSystemName(String? value) {
    patchMap[UIImage$.systemName] = value;
    return this;
  }

  UIImagePatch withData(Uint8List? value) {
    patchMap[UIImage$.data] = value;
    return this;
  }
}

/// Field descriptors for [UIImage] query construction
abstract final class UIImageFields {
  static const name = Field<UIImage, String?>('name', _$name);

  static const systemName = Field<UIImage, String?>('systemName', _$systemName);

  static const data = Field<UIImage, Uint8List?>('data', _$data);

  static String? _$name(UIImage e) {
    return e.name;
  }

  static String? _$systemName(UIImage e) {
    return e.systemName;
  }

  static Uint8List? _$data(UIImage e) {
    return e.data;
  }
}

extension UIImageCompareE on UIImage {
  Map<String, dynamic> compareToUIImage(UIImage other) {
    final Map<String, dynamic> diff = {};

    if (name != other.name) {
      diff['name'] = () => other.name;
    }

    if (systemName != other.systemName) {
      diff['systemName'] = () => other.systemName;
    }

    if (data != other.data) {
      diff['data'] = () => other.data;
    }
    return diff;
  }
}
