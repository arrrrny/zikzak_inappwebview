// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'request_focus_node_href_result.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class RequestFocusNodeHrefResult {
  RequestFocusNodeHrefResult({
    WebUri? this.url,
    String? this.title,
    String? this.src,
  });

  factory RequestFocusNodeHrefResult.fromJson(Map<String, dynamic> json) =>
      _$RequestFocusNodeHrefResultFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final String? title;

  final String? src;

  RequestFocusNodeHrefResult copyWith({
    WebUri? url,
    String? title,
    String? src,
  }) {
    return RequestFocusNodeHrefResult(
      url: url ?? this.url,
      title: title ?? this.title,
      src: src ?? this.src,
    );
  }

  RequestFocusNodeHrefResult copyWithRequestFocusNodeHrefResult({
    WebUri? url,
    String? title,
    String? src,
  }) {
    return copyWith(url: url, title: title, src: src);
  }

  RequestFocusNodeHrefResult patchWithRequestFocusNodeHrefResult([
    RequestFocusNodeHrefResultPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? RequestFocusNodeHrefResultPatch();
    final _patchMap = _patcher.patchMap;
    return RequestFocusNodeHrefResult(
      url: _patchMap.containsKey(RequestFocusNodeHrefResult$.url)
          ? (_patchMap[RequestFocusNodeHrefResult$.url] is Function)
                ? _patchMap[RequestFocusNodeHrefResult$.url](this.url)
                : (_patchMap[RequestFocusNodeHrefResult$.url] is Patch)
                ? _patchMap[RequestFocusNodeHrefResult$.url].applyTo(this.url)
                : _patchMap[RequestFocusNodeHrefResult$.url]
          : this.url,
      title: _patchMap.containsKey(RequestFocusNodeHrefResult$.title)
          ? (_patchMap[RequestFocusNodeHrefResult$.title] is Function)
                ? _patchMap[RequestFocusNodeHrefResult$.title](this.title)
                : (_patchMap[RequestFocusNodeHrefResult$.title] is Patch)
                ? _patchMap[RequestFocusNodeHrefResult$.title].applyTo(
                    this.title,
                  )
                : _patchMap[RequestFocusNodeHrefResult$.title]
          : this.title,
      src: _patchMap.containsKey(RequestFocusNodeHrefResult$.src)
          ? (_patchMap[RequestFocusNodeHrefResult$.src] is Function)
                ? _patchMap[RequestFocusNodeHrefResult$.src](this.src)
                : (_patchMap[RequestFocusNodeHrefResult$.src] is Patch)
                ? _patchMap[RequestFocusNodeHrefResult$.src].applyTo(this.src)
                : _patchMap[RequestFocusNodeHrefResult$.src]
          : this.src,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestFocusNodeHrefResult &&
        url == other.url &&
        title == other.title &&
        src == other.src;
  }

  @override
  int get hashCode {
    return Object.hash(this.url, this.title, this.src);
  }

  @override
  String toString() {
    return 'RequestFocusNodeHrefResult(' +
        'url: ${url}' +
        ', ' +
        'title: ${title}' +
        ', ' +
        'src: ${src})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$RequestFocusNodeHrefResultToJson(this);
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

extension RequestFocusNodeHrefResultPropertyHelpers
    on RequestFocusNodeHrefResult {
  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
  }

  bool get hasTitle {
    return this.title?.isNotEmpty == true;
  }

  bool get noTitle {
    return this.title?.isEmpty ?? true;
  }

  String get titleRequired {
    return this.title ?? (throw StateError('title is required but was null'));
  }

  bool get hasSrc {
    return this.src?.isNotEmpty == true;
  }

  bool get noSrc {
    return this.src?.isEmpty ?? true;
  }

  String get srcRequired {
    return this.src ?? (throw StateError('src is required but was null'));
  }
}

extension RequestFocusNodeHrefResultSerialization
    on RequestFocusNodeHrefResult {
  Map<String, dynamic> toJson() {
    return _$RequestFocusNodeHrefResultToJson(this);
  }
}

enum RequestFocusNodeHrefResult$ { url, title, src }

class RequestFocusNodeHrefResultPatch
    extends PatchBase<RequestFocusNodeHrefResult, RequestFocusNodeHrefResult$> {
  RequestFocusNodeHrefResult applyTo(RequestFocusNodeHrefResult entity) {
    return entity.patchWithRequestFocusNodeHrefResult(this);
  }

  RequestFocusNodeHrefResultPatch withUrl(WebUri? value) {
    patchMap[RequestFocusNodeHrefResult$.url] = value;
    return this;
  }

  RequestFocusNodeHrefResultPatch withTitle(String? value) {
    patchMap[RequestFocusNodeHrefResult$.title] = value;
    return this;
  }

  RequestFocusNodeHrefResultPatch withSrc(String? value) {
    patchMap[RequestFocusNodeHrefResult$.src] = value;
    return this;
  }
}

/// Field descriptors for [RequestFocusNodeHrefResult] query construction
abstract final class RequestFocusNodeHrefResultFields {
  static const url = Field<RequestFocusNodeHrefResult, WebUri?>('url', _$url);

  static const title = Field<RequestFocusNodeHrefResult, String?>(
    'title',
    _$title,
  );

  static const src = Field<RequestFocusNodeHrefResult, String?>('src', _$src);

  static WebUri? _$url(RequestFocusNodeHrefResult e) {
    return e.url;
  }

  static String? _$title(RequestFocusNodeHrefResult e) {
    return e.title;
  }

  static String? _$src(RequestFocusNodeHrefResult e) {
    return e.src;
  }
}

extension RequestFocusNodeHrefResultCompareE on RequestFocusNodeHrefResult {
  Map<String, dynamic> compareToRequestFocusNodeHrefResult(
    RequestFocusNodeHrefResult other,
  ) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (title != other.title) {
      diff['title'] = () => other.title;
    }

    if (src != other.src) {
      diff['src'] = () => other.src;
    }
    return diff;
  }
}
