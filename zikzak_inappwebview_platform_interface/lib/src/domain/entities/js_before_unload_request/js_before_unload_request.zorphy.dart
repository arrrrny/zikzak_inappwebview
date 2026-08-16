// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_before_unload_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsBeforeUnloadRequest {
  JsBeforeUnloadRequest({WebUri? this.url, String? this.message});

  factory JsBeforeUnloadRequest.fromJson(Map<String, dynamic> json) =>
      _$JsBeforeUnloadRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final String? message;

  JsBeforeUnloadRequest copyWith({WebUri? url, String? message}) {
    return JsBeforeUnloadRequest(
      url: url ?? this.url,
      message: message ?? this.message,
    );
  }

  JsBeforeUnloadRequest copyWithJsBeforeUnloadRequest({
    WebUri? url,
    String? message,
  }) {
    return copyWith(url: url, message: message);
  }

  JsBeforeUnloadRequest patchWithJsBeforeUnloadRequest([
    JsBeforeUnloadRequestPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? JsBeforeUnloadRequestPatch();
    final _patchMap = _patcher.patchMap;
    return JsBeforeUnloadRequest(
      url: _patchMap.containsKey(JsBeforeUnloadRequest$.url)
          ? (_patchMap[JsBeforeUnloadRequest$.url] is Function)
                ? _patchMap[JsBeforeUnloadRequest$.url](this.url)
                : (_patchMap[JsBeforeUnloadRequest$.url] is Patch)
                ? _patchMap[JsBeforeUnloadRequest$.url].applyTo(this.url)
                : _patchMap[JsBeforeUnloadRequest$.url]
          : this.url,
      message: _patchMap.containsKey(JsBeforeUnloadRequest$.message)
          ? (_patchMap[JsBeforeUnloadRequest$.message] is Function)
                ? _patchMap[JsBeforeUnloadRequest$.message](this.message)
                : (_patchMap[JsBeforeUnloadRequest$.message] is Patch)
                ? _patchMap[JsBeforeUnloadRequest$.message].applyTo(
                    this.message,
                  )
                : _patchMap[JsBeforeUnloadRequest$.message]
          : this.message,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsBeforeUnloadRequest &&
        url == other.url &&
        message == other.message;
  }

  @override
  int get hashCode {
    return Object.hash(this.url, this.message);
  }

  @override
  String toString() {
    return 'JsBeforeUnloadRequest(' +
        'url: ${url}' +
        ', ' +
        'message: ${message})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$JsBeforeUnloadRequestToJson(this);
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

extension JsBeforeUnloadRequestPropertyHelpers on JsBeforeUnloadRequest {
  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
  }

  bool get hasMessage {
    return this.message?.isNotEmpty == true;
  }

  bool get noMessage {
    return this.message?.isEmpty ?? true;
  }

  String get messageRequired {
    return this.message ??
        (throw StateError('message is required but was null'));
  }
}

extension JsBeforeUnloadRequestSerialization on JsBeforeUnloadRequest {
  Map<String, dynamic> toJson() {
    return _$JsBeforeUnloadRequestToJson(this);
  }
}

enum JsBeforeUnloadRequest$ { url, message }

class JsBeforeUnloadRequestPatch
    extends PatchBase<JsBeforeUnloadRequest, JsBeforeUnloadRequest$> {
  JsBeforeUnloadRequest applyTo(JsBeforeUnloadRequest entity) {
    return entity.patchWithJsBeforeUnloadRequest(this);
  }

  JsBeforeUnloadRequestPatch withUrl(WebUri? value) {
    patchMap[JsBeforeUnloadRequest$.url] = value;
    return this;
  }

  JsBeforeUnloadRequestPatch withMessage(String? value) {
    patchMap[JsBeforeUnloadRequest$.message] = value;
    return this;
  }
}

/// Field descriptors for [JsBeforeUnloadRequest] query construction
abstract final class JsBeforeUnloadRequestFields {
  static const url = Field<JsBeforeUnloadRequest, WebUri?>('url', _$url);

  static const message = Field<JsBeforeUnloadRequest, String?>(
    'message',
    _$message,
  );

  static WebUri? _$url(JsBeforeUnloadRequest e) {
    return e.url;
  }

  static String? _$message(JsBeforeUnloadRequest e) {
    return e.message;
  }
}

extension JsBeforeUnloadRequestCompareE on JsBeforeUnloadRequest {
  Map<String, dynamic> compareToJsBeforeUnloadRequest(
    JsBeforeUnloadRequest other,
  ) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (message != other.message) {
      diff['message'] = () => other.message;
    }
    return diff;
  }
}
