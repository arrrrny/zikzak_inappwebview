// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_storage_item.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebStorageItem {
  WebStorageItem({String? this.key, dynamic this.value});

  factory WebStorageItem.fromJson(Map<String, dynamic> json) =>
      _$WebStorageItemFromJson(json);

  final String? key;

  final dynamic value;

  WebStorageItem copyWith({String? key, dynamic value}) {
    return WebStorageItem(key: key ?? this.key, value: value ?? this.value);
  }

  WebStorageItem copyWithWebStorageItem({String? key, dynamic value}) {
    return copyWith(key: key, value: value);
  }

  WebStorageItem patchWithWebStorageItem([WebStorageItemPatch? patchInput]) {
    final _patcher = patchInput ?? WebStorageItemPatch();
    final _patchMap = _patcher.patchMap;
    return WebStorageItem(
      key: _patchMap.containsKey(WebStorageItem$.key)
          ? ((_patchMap[WebStorageItem$.key] is Function)
                    ? _patchMap[WebStorageItem$.key](this.key)
                    : (_patchMap[WebStorageItem$.key] is Patch)
                    ? _patchMap[WebStorageItem$.key].applyTo(this.key)
                    : _patchMap[WebStorageItem$.key])
                as String?
          : this.key,
      value: _patchMap.containsKey(WebStorageItem$.value)
          ? ((_patchMap[WebStorageItem$.value] is Function)
                    ? _patchMap[WebStorageItem$.value](this.value)
                    : (_patchMap[WebStorageItem$.value] is Patch)
                    ? _patchMap[WebStorageItem$.value].applyTo(this.value)
                    : _patchMap[WebStorageItem$.value])
                as dynamic
          : this.value,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebStorageItem && key == other.key && value == other.value;
  }

  @override
  int get hashCode {
    return Object.hash(this.key, this.value);
  }

  @override
  String toString() {
    return 'WebStorageItem(' + 'key: ${key}' + ', ' + 'value: ${value})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebStorageItemToJson(this);
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

extension WebStorageItemPropertyHelpers on WebStorageItem {
  bool get hasKey {
    return this.key?.isNotEmpty == true;
  }

  bool get noKey {
    return this.key?.isEmpty ?? true;
  }

  String get keyRequired {
    return this.key ?? (throw StateError('key is required but was null'));
  }
}

extension WebStorageItemSerialization on WebStorageItem {
  Map<String, dynamic> toJson() {
    return _$WebStorageItemToJson(this);
  }
}

enum WebStorageItem$ { key, value }

class WebStorageItemPatch extends PatchBase<WebStorageItem, WebStorageItem$> {
  WebStorageItem applyTo(WebStorageItem entity) {
    return entity.patchWithWebStorageItem(this);
  }

  WebStorageItemPatch withKey(String? value) {
    patchMap[WebStorageItem$.key] = value;
    return this;
  }

  WebStorageItemPatch withValue(dynamic value) {
    patchMap[WebStorageItem$.value] = value;
    return this;
  }
}

/// Field descriptors for [WebStorageItem] query construction
abstract final class WebStorageItemFields {
  static const key = Field<WebStorageItem, String?>('key', _$key);

  static const value = Field<WebStorageItem, dynamic>('value', _$value);

  static String? _$key(WebStorageItem e) {
    return e.key;
  }

  static dynamic _$value(WebStorageItem e) {
    return e.value;
  }
}

extension WebStorageItemCompareE on WebStorageItem {
  Map<String, dynamic> compareToWebStorageItem(WebStorageItem other) {
    final Map<String, dynamic> diff = {};

    if (key != other.key) {
      diff['key'] = () => other.key;
    }

    if (value != other.value) {
      diff['value'] = () => other.value;
    }
    return diff;
  }
}
