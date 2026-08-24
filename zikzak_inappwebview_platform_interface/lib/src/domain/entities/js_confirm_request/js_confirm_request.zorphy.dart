// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_confirm_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsConfirmRequest {
  JsConfirmRequest({
    WebUri? this.url,
    String? this.message,
    bool? this.isMainFrame,
  });

  factory JsConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$JsConfirmRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final String? message;

  final bool? isMainFrame;

  JsConfirmRequest copyWith({WebUri? url, String? message, bool? isMainFrame}) {
    return JsConfirmRequest(
      url: url ?? this.url,
      message: message ?? this.message,
      isMainFrame: isMainFrame ?? this.isMainFrame,
    );
  }

  JsConfirmRequest copyWithJsConfirmRequest({
    WebUri? url,
    String? message,
    bool? isMainFrame,
  }) {
    return copyWith(url: url, message: message, isMainFrame: isMainFrame);
  }

  JsConfirmRequest patchWithJsConfirmRequest([
    JsConfirmRequestPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? JsConfirmRequestPatch();
    final _patchMap = _patcher.patchMap;
    return JsConfirmRequest(
      url: _patchMap.containsKey(JsConfirmRequest$.url)
          ? ((_patchMap[JsConfirmRequest$.url] is Function)
                    ? _patchMap[JsConfirmRequest$.url](this.url)
                    : (_patchMap[JsConfirmRequest$.url] is Patch)
                    ? _patchMap[JsConfirmRequest$.url].applyTo(this.url)
                    : _patchMap[JsConfirmRequest$.url])
                as WebUri?
          : this.url,
      message: _patchMap.containsKey(JsConfirmRequest$.message)
          ? ((_patchMap[JsConfirmRequest$.message] is Function)
                    ? _patchMap[JsConfirmRequest$.message](this.message)
                    : (_patchMap[JsConfirmRequest$.message] is Patch)
                    ? _patchMap[JsConfirmRequest$.message].applyTo(this.message)
                    : _patchMap[JsConfirmRequest$.message])
                as String?
          : this.message,
      isMainFrame: _patchMap.containsKey(JsConfirmRequest$.isMainFrame)
          ? ((_patchMap[JsConfirmRequest$.isMainFrame] is Function)
                    ? _patchMap[JsConfirmRequest$.isMainFrame](this.isMainFrame)
                    : (_patchMap[JsConfirmRequest$.isMainFrame] is Patch)
                    ? _patchMap[JsConfirmRequest$.isMainFrame].applyTo(
                        this.isMainFrame,
                      )
                    : _patchMap[JsConfirmRequest$.isMainFrame])
                as bool?
          : this.isMainFrame,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsConfirmRequest &&
        url == other.url &&
        message == other.message &&
        isMainFrame == other.isMainFrame;
  }

  @override
  int get hashCode {
    return Object.hash(this.url, this.message, this.isMainFrame);
  }

  @override
  String toString() {
    return 'JsConfirmRequest(' +
        'url: ${url}' +
        ', ' +
        'message: ${message}' +
        ', ' +
        'isMainFrame: ${isMainFrame})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$JsConfirmRequestToJson(this);
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

extension JsConfirmRequestPropertyHelpers on JsConfirmRequest {
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

  bool get hasIsMainFrame {
    return this.isMainFrame != null;
  }

  bool get noIsMainFrame {
    return this.isMainFrame == null;
  }

  bool get isMainFrameRequired {
    return this.isMainFrame ??
        (throw StateError('isMainFrame is required but was null'));
  }
}

extension JsConfirmRequestSerialization on JsConfirmRequest {
  Map<String, dynamic> toJson() {
    return _$JsConfirmRequestToJson(this);
  }
}

enum JsConfirmRequest$ { url, message, isMainFrame }

class JsConfirmRequestPatch
    extends PatchBase<JsConfirmRequest, JsConfirmRequest$> {
  JsConfirmRequest applyTo(JsConfirmRequest entity) {
    return entity.patchWithJsConfirmRequest(this);
  }

  JsConfirmRequestPatch withUrl(WebUri? value) {
    patchMap[JsConfirmRequest$.url] = value;
    return this;
  }

  JsConfirmRequestPatch withMessage(String? value) {
    patchMap[JsConfirmRequest$.message] = value;
    return this;
  }

  JsConfirmRequestPatch withIsMainFrame(bool? value) {
    patchMap[JsConfirmRequest$.isMainFrame] = value;
    return this;
  }
}

/// Field descriptors for [JsConfirmRequest] query construction
abstract final class JsConfirmRequestFields {
  static const url = Field<JsConfirmRequest, WebUri?>('url', _$url);

  static const message = Field<JsConfirmRequest, String?>('message', _$message);

  static const isMainFrame = Field<JsConfirmRequest, bool?>(
    'isMainFrame',
    _$isMainFrame,
  );

  static WebUri? _$url(JsConfirmRequest e) {
    return e.url;
  }

  static String? _$message(JsConfirmRequest e) {
    return e.message;
  }

  static bool? _$isMainFrame(JsConfirmRequest e) {
    return e.isMainFrame;
  }
}

extension JsConfirmRequestCompareE on JsConfirmRequest {
  Map<String, dynamic> compareToJsConfirmRequest(JsConfirmRequest other) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (message != other.message) {
      diff['message'] = () => other.message;
    }

    if (isMainFrame != other.isMainFrame) {
      diff['isMainFrame'] = () => other.isMainFrame;
    }
    return diff;
  }
}
