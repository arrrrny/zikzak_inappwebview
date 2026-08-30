// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_storage_origin.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebStorageOrigin {
  WebStorageOrigin({String? this.origin, int? this.quota, int? this.usage});

  factory WebStorageOrigin.fromJson(Map<String, dynamic> json) =>
      _$WebStorageOriginFromJson(json);

  final String? origin;

  final int? quota;

  final int? usage;

  WebStorageOrigin copyWith({String? origin, int? quota, int? usage}) {
    return WebStorageOrigin(
      origin: origin ?? this.origin,
      quota: quota ?? this.quota,
      usage: usage ?? this.usage,
    );
  }

  WebStorageOrigin copyWithWebStorageOrigin({
    String? origin,
    int? quota,
    int? usage,
  }) {
    return copyWith(origin: origin, quota: quota, usage: usage);
  }

  WebStorageOrigin patchWithWebStorageOrigin([
    WebStorageOriginPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebStorageOriginPatch();
    final _patchMap = _patcher.patchMap;
    return WebStorageOrigin(
      origin: _patchMap.containsKey(WebStorageOrigin$.origin)
          ? ((_patchMap[WebStorageOrigin$.origin] is Function)
                    ? _patchMap[WebStorageOrigin$.origin](this.origin)
                    : (_patchMap[WebStorageOrigin$.origin] is Patch)
                    ? _patchMap[WebStorageOrigin$.origin].applyTo(this.origin)
                    : _patchMap[WebStorageOrigin$.origin])
                as String?
          : this.origin,
      quota: _patchMap.containsKey(WebStorageOrigin$.quota)
          ? ((_patchMap[WebStorageOrigin$.quota] is Function)
                    ? _patchMap[WebStorageOrigin$.quota](this.quota)
                    : (_patchMap[WebStorageOrigin$.quota] is Patch)
                    ? _patchMap[WebStorageOrigin$.quota].applyTo(this.quota)
                    : _patchMap[WebStorageOrigin$.quota])
                as int?
          : this.quota,
      usage: _patchMap.containsKey(WebStorageOrigin$.usage)
          ? ((_patchMap[WebStorageOrigin$.usage] is Function)
                    ? _patchMap[WebStorageOrigin$.usage](this.usage)
                    : (_patchMap[WebStorageOrigin$.usage] is Patch)
                    ? _patchMap[WebStorageOrigin$.usage].applyTo(this.usage)
                    : _patchMap[WebStorageOrigin$.usage])
                as int?
          : this.usage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebStorageOrigin &&
        origin == other.origin &&
        quota == other.quota &&
        usage == other.usage;
  }

  @override
  int get hashCode {
    return Object.hash(this.origin, this.quota, this.usage);
  }

  @override
  String toString() {
    return 'WebStorageOrigin(' +
        'origin: ${origin}' +
        ', ' +
        'quota: ${quota}' +
        ', ' +
        'usage: ${usage})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebStorageOriginToJson(this);
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

extension WebStorageOriginPropertyHelpers on WebStorageOrigin {
  bool get hasOrigin {
    return this.origin?.isNotEmpty == true;
  }

  bool get noOrigin {
    return this.origin?.isEmpty ?? true;
  }

  String get originRequired {
    return this.origin ?? (throw StateError('origin is required but was null'));
  }

  bool get hasQuota {
    return this.quota != null;
  }

  bool get noQuota {
    return this.quota == null;
  }

  int get quotaRequired {
    return this.quota ?? (throw StateError('quota is required but was null'));
  }

  bool get hasUsage {
    return this.usage != null;
  }

  bool get noUsage {
    return this.usage == null;
  }

  int get usageRequired {
    return this.usage ?? (throw StateError('usage is required but was null'));
  }
}

extension WebStorageOriginSerialization on WebStorageOrigin {
  Map<String, dynamic> toJson() {
    return _$WebStorageOriginToJson(this);
  }
}

enum WebStorageOrigin$ { origin, quota, usage }

class WebStorageOriginPatch
    extends PatchBase<WebStorageOrigin, WebStorageOrigin$> {
  WebStorageOrigin applyTo(WebStorageOrigin entity) {
    return entity.patchWithWebStorageOrigin(this);
  }

  WebStorageOriginPatch withOrigin(String? value) {
    patchMap[WebStorageOrigin$.origin] = value;
    return this;
  }

  WebStorageOriginPatch withQuota(int? value) {
    patchMap[WebStorageOrigin$.quota] = value;
    return this;
  }

  WebStorageOriginPatch withUsage(int? value) {
    patchMap[WebStorageOrigin$.usage] = value;
    return this;
  }
}

/// Field descriptors for [WebStorageOrigin] query construction
abstract final class WebStorageOriginFields {
  static const origin = Field<WebStorageOrigin, String?>('origin', _$origin);

  static const quota = Field<WebStorageOrigin, int?>('quota', _$quota);

  static const usage = Field<WebStorageOrigin, int?>('usage', _$usage);

  static String? _$origin(WebStorageOrigin e) {
    return e.origin;
  }

  static int? _$quota(WebStorageOrigin e) {
    return e.quota;
  }

  static int? _$usage(WebStorageOrigin e) {
    return e.usage;
  }
}

extension WebStorageOriginCompareE on WebStorageOrigin {
  Map<String, dynamic> compareToWebStorageOrigin(WebStorageOrigin other) {
    final Map<String, dynamic> diff = {};

    if (origin != other.origin) {
      diff['origin'] = () => other.origin;
    }

    if (quota != other.quota) {
      diff['quota'] = () => other.quota;
    }

    if (usage != other.usage) {
      diff['usage'] = () => other.usage;
    }
    return diff;
  }
}
