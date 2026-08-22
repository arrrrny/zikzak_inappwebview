// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'favicon.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class Favicon {
  Favicon({
    required WebUri this.url,
    String? this.rel,
    int? this.width,
    int? this.height,
  });

  factory Favicon.fromJson(Map<String, dynamic> json) =>
      _$FaviconFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri url;

  final String? rel;

  final int? width;

  final int? height;

  Favicon copyWith({WebUri? url, String? rel, int? width, int? height}) {
    return Favicon(
      url: url ?? this.url,
      rel: rel ?? this.rel,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Favicon copyWithFavicon({WebUri? url, String? rel, int? width, int? height}) {
    return copyWith(url: url, rel: rel, width: width, height: height);
  }

  Favicon patchWithFavicon([FaviconPatch? patchInput]) {
    final _patcher = patchInput ?? FaviconPatch();
    final _patchMap = _patcher.patchMap;
    return Favicon(
      url: _patchMap.containsKey(Favicon$.url)
          ? (_patchMap[Favicon$.url] is Function)
                ? _patchMap[Favicon$.url](this.url)
                : (_patchMap[Favicon$.url] is Patch)
                ? _patchMap[Favicon$.url].applyTo(this.url)
                : _patchMap[Favicon$.url]
          : this.url,
      rel: _patchMap.containsKey(Favicon$.rel)
          ? (_patchMap[Favicon$.rel] is Function)
                ? _patchMap[Favicon$.rel](this.rel)
                : (_patchMap[Favicon$.rel] is Patch)
                ? _patchMap[Favicon$.rel].applyTo(this.rel)
                : _patchMap[Favicon$.rel]
          : this.rel,
      width: _patchMap.containsKey(Favicon$.width)
          ? (_patchMap[Favicon$.width] is Function)
                ? _patchMap[Favicon$.width](this.width)
                : (_patchMap[Favicon$.width] is Patch)
                ? _patchMap[Favicon$.width].applyTo(this.width)
                : _patchMap[Favicon$.width]
          : this.width,
      height: _patchMap.containsKey(Favicon$.height)
          ? (_patchMap[Favicon$.height] is Function)
                ? _patchMap[Favicon$.height](this.height)
                : (_patchMap[Favicon$.height] is Patch)
                ? _patchMap[Favicon$.height].applyTo(this.height)
                : _patchMap[Favicon$.height]
          : this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favicon &&
        url == other.url &&
        rel == other.rel &&
        width == other.width &&
        height == other.height;
  }

  @override
  int get hashCode {
    return Object.hash(this.url, this.rel, this.width, this.height);
  }

  @override
  String toString() {
    return 'Favicon(' +
        'url: ${url}' +
        ', ' +
        'rel: ${rel}' +
        ', ' +
        'width: ${width}' +
        ', ' +
        'height: ${height})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$FaviconToJson(this);
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

extension FaviconPropertyHelpers on Favicon {
  bool get hasRel {
    return this.rel?.isNotEmpty == true;
  }

  bool get noRel {
    return this.rel?.isEmpty ?? true;
  }

  String get relRequired {
    return this.rel ?? (throw StateError('rel is required but was null'));
  }

  bool get hasWidth {
    return this.width != null;
  }

  bool get noWidth {
    return this.width == null;
  }

  int get widthRequired {
    return this.width ?? (throw StateError('width is required but was null'));
  }

  bool get hasHeight {
    return this.height != null;
  }

  bool get noHeight {
    return this.height == null;
  }

  int get heightRequired {
    return this.height ?? (throw StateError('height is required but was null'));
  }
}

extension FaviconSerialization on Favicon {
  Map<String, dynamic> toJson() {
    return _$FaviconToJson(this);
  }
}

enum Favicon$ { url, rel, width, height }

class FaviconPatch extends PatchBase<Favicon, Favicon$> {
  Favicon applyTo(Favicon entity) {
    return entity.patchWithFavicon(this);
  }

  FaviconPatch withUrl(WebUri? value) {
    patchMap[Favicon$.url] = value;
    return this;
  }

  FaviconPatch withRel(String? value) {
    patchMap[Favicon$.rel] = value;
    return this;
  }

  FaviconPatch withWidth(int? value) {
    patchMap[Favicon$.width] = value;
    return this;
  }

  FaviconPatch withHeight(int? value) {
    patchMap[Favicon$.height] = value;
    return this;
  }
}

/// Field descriptors for [Favicon] query construction
abstract final class FaviconFields {
  static const url = Field<Favicon, WebUri>('url', _$url);

  static const rel = Field<Favicon, String?>('rel', _$rel);

  static const width = Field<Favicon, int?>('width', _$width);

  static const height = Field<Favicon, int?>('height', _$height);

  static WebUri _$url(Favicon e) {
    return e.url;
  }

  static String? _$rel(Favicon e) {
    return e.rel;
  }

  static int? _$width(Favicon e) {
    return e.width;
  }

  static int? _$height(Favicon e) {
    return e.height;
  }
}

extension FaviconCompareE on Favicon {
  Map<String, dynamic> compareToFavicon(Favicon other) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (rel != other.rel) {
      diff['rel'] = () => other.rel;
    }

    if (width != other.width) {
      diff['width'] = () => other.width;
    }

    if (height != other.height) {
      diff['height'] = () => other.height;
    }
    return diff;
  }
}
