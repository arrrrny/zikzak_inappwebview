// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'request_image_ref_result.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class RequestImageRefResult {
  RequestImageRefResult({WebUri? this.url});

  factory RequestImageRefResult.fromJson(Map<String, dynamic> json) =>
      _$RequestImageRefResultFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  RequestImageRefResult copyWith({WebUri? url}) {
    return RequestImageRefResult(url: url ?? this.url);
  }

  RequestImageRefResult copyWithRequestImageRefResult({WebUri? url}) {
    return copyWith(url: url);
  }

  RequestImageRefResult patchWithRequestImageRefResult([
    RequestImageRefResultPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? RequestImageRefResultPatch();
    final _patchMap = _patcher.patchMap;
    return RequestImageRefResult(
      url: _patchMap.containsKey(RequestImageRefResult$.url)
          ? (_patchMap[RequestImageRefResult$.url] is Function)
                ? _patchMap[RequestImageRefResult$.url](this.url)
                : (_patchMap[RequestImageRefResult$.url] is Patch)
                ? _patchMap[RequestImageRefResult$.url].applyTo(this.url)
                : _patchMap[RequestImageRefResult$.url]
          : this.url,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestImageRefResult && url == other.url;
  }

  @override
  int get hashCode {
    return Object.hash(url, 0);
  }

  @override
  String toString() {
    return 'RequestImageRefResult(' + 'url: ${url})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$RequestImageRefResultToJson(this);
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

extension RequestImageRefResultPropertyHelpers on RequestImageRefResult {
  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
  }
}

extension RequestImageRefResultSerialization on RequestImageRefResult {
  Map<String, dynamic> toJson() {
    return _$RequestImageRefResultToJson(this);
  }
}

enum RequestImageRefResult$ { url }

class RequestImageRefResultPatch
    extends PatchBase<RequestImageRefResult, RequestImageRefResult$> {
  RequestImageRefResult applyTo(RequestImageRefResult entity) {
    return entity.patchWithRequestImageRefResult(this);
  }

  RequestImageRefResultPatch withUrl(WebUri? value) {
    patchMap[RequestImageRefResult$.url] = value;
    return this;
  }
}

/// Field descriptors for [RequestImageRefResult] query construction
abstract final class RequestImageRefResultFields {
  static const url = Field<RequestImageRefResult, WebUri?>('url', _$url);

  static WebUri? _$url(RequestImageRefResult e) {
    return e.url;
  }
}

extension RequestImageRefResultCompareE on RequestImageRefResult {
  Map<String, dynamic> compareToRequestImageRefResult(
    RequestImageRefResult other,
  ) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }
    return diff;
  }
}
