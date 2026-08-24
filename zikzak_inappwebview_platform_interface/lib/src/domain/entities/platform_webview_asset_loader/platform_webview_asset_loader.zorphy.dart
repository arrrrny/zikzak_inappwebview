// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'platform_webview_asset_loader.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebViewAssetLoader {
  WebViewAssetLoader({
    String? this.domain,
    bool? this.httpAllowed,
    List<PlatformPathHandler>? this.pathHandlers,
  });

  factory WebViewAssetLoader.fromJson(Map<String, dynamic> json) =>
      _$WebViewAssetLoaderFromJson(json);

  final String? domain;

  final bool? httpAllowed;

  @JsonKey(toJson: _pathHandlersToJson, fromJson: _pathHandlersFromJson)
  final List<PlatformPathHandler>? pathHandlers;

  WebViewAssetLoader copyWith({
    String? domain,
    bool? httpAllowed,
    List<PlatformPathHandler>? pathHandlers,
  }) {
    return WebViewAssetLoader(
      domain: domain ?? this.domain,
      httpAllowed: httpAllowed ?? this.httpAllowed,
      pathHandlers: pathHandlers ?? this.pathHandlers,
    );
  }

  WebViewAssetLoader copyWithWebViewAssetLoader({
    String? domain,
    bool? httpAllowed,
    List<PlatformPathHandler>? pathHandlers,
  }) {
    return copyWith(
      domain: domain,
      httpAllowed: httpAllowed,
      pathHandlers: pathHandlers,
    );
  }

  WebViewAssetLoader patchWithWebViewAssetLoader([
    WebViewAssetLoaderPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebViewAssetLoaderPatch();
    final _patchMap = _patcher.patchMap;
    return WebViewAssetLoader(
      domain: _patchMap.containsKey(WebViewAssetLoader$.domain)
          ? ((_patchMap[WebViewAssetLoader$.domain] is Function)
                    ? _patchMap[WebViewAssetLoader$.domain](this.domain)
                    : (_patchMap[WebViewAssetLoader$.domain] is Patch)
                    ? _patchMap[WebViewAssetLoader$.domain].applyTo(this.domain)
                    : _patchMap[WebViewAssetLoader$.domain])
                as String?
          : this.domain,
      httpAllowed: _patchMap.containsKey(WebViewAssetLoader$.httpAllowed)
          ? ((_patchMap[WebViewAssetLoader$.httpAllowed] is Function)
                    ? _patchMap[WebViewAssetLoader$.httpAllowed](
                        this.httpAllowed,
                      )
                    : (_patchMap[WebViewAssetLoader$.httpAllowed] is Patch)
                    ? _patchMap[WebViewAssetLoader$.httpAllowed].applyTo(
                        this.httpAllowed,
                      )
                    : _patchMap[WebViewAssetLoader$.httpAllowed])
                as bool?
          : this.httpAllowed,
      pathHandlers: _patchMap.containsKey(WebViewAssetLoader$.pathHandlers)
          ? ((_patchMap[WebViewAssetLoader$.pathHandlers] is Function)
                    ? _patchMap[WebViewAssetLoader$.pathHandlers](
                        this.pathHandlers,
                      )
                    : (_patchMap[WebViewAssetLoader$.pathHandlers] is Patch)
                    ? _patchMap[WebViewAssetLoader$.pathHandlers].applyTo(
                        this.pathHandlers,
                      )
                    : _patchMap[WebViewAssetLoader$.pathHandlers])
                as List<PlatformPathHandler>?
          : this.pathHandlers,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebViewAssetLoader &&
        domain == other.domain &&
        httpAllowed == other.httpAllowed &&
        pathHandlers == other.pathHandlers;
  }

  @override
  int get hashCode {
    return Object.hash(this.domain, this.httpAllowed, this.pathHandlers);
  }

  @override
  String toString() {
    return 'WebViewAssetLoader(' +
        'domain: ${domain}' +
        ', ' +
        'httpAllowed: ${httpAllowed}' +
        ', ' +
        'pathHandlers: ${pathHandlers})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebViewAssetLoaderToJson(this);
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

extension WebViewAssetLoaderPropertyHelpers on WebViewAssetLoader {
  bool get hasDomain {
    return this.domain?.isNotEmpty == true;
  }

  bool get noDomain {
    return this.domain?.isEmpty ?? true;
  }

  String get domainRequired {
    return this.domain ?? (throw StateError('domain is required but was null'));
  }

  bool get hasHttpAllowed {
    return this.httpAllowed != null;
  }

  bool get noHttpAllowed {
    return this.httpAllowed == null;
  }

  bool get httpAllowedRequired {
    return this.httpAllowed ??
        (throw StateError('httpAllowed is required but was null'));
  }

  List<PlatformPathHandler> get pathHandlersRequired {
    return this.pathHandlers ??
        (throw StateError('pathHandlers is required but was null'));
  }

  bool get hasPathHandlers {
    return this.pathHandlers?.isNotEmpty ?? false;
  }

  bool get noPathHandlers {
    return this.pathHandlers?.isEmpty ?? true;
  }
}

extension WebViewAssetLoaderSerialization on WebViewAssetLoader {
  Map<String, dynamic> toJson() {
    return _$WebViewAssetLoaderToJson(this);
  }
}

enum WebViewAssetLoader$ { domain, httpAllowed, pathHandlers }

class WebViewAssetLoaderPatch
    extends PatchBase<WebViewAssetLoader, WebViewAssetLoader$> {
  WebViewAssetLoader applyTo(WebViewAssetLoader entity) {
    return entity.patchWithWebViewAssetLoader(this);
  }

  WebViewAssetLoaderPatch withDomain(String? value) {
    patchMap[WebViewAssetLoader$.domain] = value;
    return this;
  }

  WebViewAssetLoaderPatch withHttpAllowed(bool? value) {
    patchMap[WebViewAssetLoader$.httpAllowed] = value;
    return this;
  }

  WebViewAssetLoaderPatch withPathHandlers(List<PlatformPathHandler>? value) {
    patchMap[WebViewAssetLoader$.pathHandlers] = value;
    return this;
  }
}

/// Field descriptors for [WebViewAssetLoader] query construction
abstract final class WebViewAssetLoaderFields {
  static const domain = Field<WebViewAssetLoader, String?>('domain', _$domain);

  static const httpAllowed = Field<WebViewAssetLoader, bool?>(
    'httpAllowed',
    _$httpAllowed,
  );

  static const pathHandlers =
      Field<WebViewAssetLoader, List<PlatformPathHandler>?>(
        'pathHandlers',
        _$pathHandlers,
      );

  static String? _$domain(WebViewAssetLoader e) {
    return e.domain;
  }

  static bool? _$httpAllowed(WebViewAssetLoader e) {
    return e.httpAllowed;
  }

  static List<PlatformPathHandler>? _$pathHandlers(WebViewAssetLoader e) {
    return e.pathHandlers;
  }
}

extension WebViewAssetLoaderCompareE on WebViewAssetLoader {
  Map<String, dynamic> compareToWebViewAssetLoader(WebViewAssetLoader other) {
    final Map<String, dynamic> diff = {};

    if (domain != other.domain) {
      diff['domain'] = () => other.domain;
    }

    if (httpAllowed != other.httpAllowed) {
      diff['httpAllowed'] = () => other.httpAllowed;
    }

    if (pathHandlers != other.pathHandlers) {
      diff['pathHandlers'] = () => other.pathHandlers;
    }
    return diff;
  }
}
