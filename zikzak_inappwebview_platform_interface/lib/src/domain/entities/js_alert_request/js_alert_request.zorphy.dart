// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_alert_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsAlertRequest {
  JsAlertRequest({
    WebUri? this.url,
    String? this.message,
    bool? this.isMainFrame,
  });

  factory JsAlertRequest.fromJson(Map<String, dynamic> json) =>
      _$JsAlertRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final String? message;

  final bool? isMainFrame;

  JsAlertRequest copyWith({WebUri? url, String? message, bool? isMainFrame}) {
    return JsAlertRequest(
      url: url ?? this.url,
      message: message ?? this.message,
      isMainFrame: isMainFrame ?? this.isMainFrame,
    );
  }

  JsAlertRequest copyWithJsAlertRequest({
    WebUri? url,
    String? message,
    bool? isMainFrame,
  }) {
    return copyWith(url: url, message: message, isMainFrame: isMainFrame);
  }

  JsAlertRequest patchWithJsAlertRequest([JsAlertRequestPatch? patchInput]) {
    final _patcher = patchInput ?? JsAlertRequestPatch();
    final _patchMap = _patcher.patchMap;
    return JsAlertRequest(
      url: _patchMap.containsKey(JsAlertRequest$.url)
          ? (_patchMap[JsAlertRequest$.url] is Function)
                ? _patchMap[JsAlertRequest$.url](this.url)
                : (_patchMap[JsAlertRequest$.url] is Patch)
                ? _patchMap[JsAlertRequest$.url].applyTo(this.url)
                : _patchMap[JsAlertRequest$.url]
          : this.url,
      message: _patchMap.containsKey(JsAlertRequest$.message)
          ? (_patchMap[JsAlertRequest$.message] is Function)
                ? _patchMap[JsAlertRequest$.message](this.message)
                : (_patchMap[JsAlertRequest$.message] is Patch)
                ? _patchMap[JsAlertRequest$.message].applyTo(this.message)
                : _patchMap[JsAlertRequest$.message]
          : this.message,
      isMainFrame: _patchMap.containsKey(JsAlertRequest$.isMainFrame)
          ? (_patchMap[JsAlertRequest$.isMainFrame] is Function)
                ? _patchMap[JsAlertRequest$.isMainFrame](this.isMainFrame)
                : (_patchMap[JsAlertRequest$.isMainFrame] is Patch)
                ? _patchMap[JsAlertRequest$.isMainFrame].applyTo(
                    this.isMainFrame,
                  )
                : _patchMap[JsAlertRequest$.isMainFrame]
          : this.isMainFrame,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsAlertRequest &&
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
    return 'JsAlertRequest(' +
        'url: ${url}' +
        ', ' +
        'message: ${message}' +
        ', ' +
        'isMainFrame: ${isMainFrame})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$JsAlertRequestToJson(this);
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

extension JsAlertRequestPropertyHelpers on JsAlertRequest {
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

extension JsAlertRequestSerialization on JsAlertRequest {
  Map<String, dynamic> toJson() {
    return _$JsAlertRequestToJson(this);
  }
}

enum JsAlertRequest$ { url, message, isMainFrame }

class JsAlertRequestPatch extends PatchBase<JsAlertRequest, JsAlertRequest$> {
  JsAlertRequest applyTo(JsAlertRequest entity) {
    return entity.patchWithJsAlertRequest(this);
  }

  JsAlertRequestPatch withUrl(WebUri? value) {
    patchMap[JsAlertRequest$.url] = value;
    return this;
  }

  JsAlertRequestPatch withMessage(String? value) {
    patchMap[JsAlertRequest$.message] = value;
    return this;
  }

  JsAlertRequestPatch withIsMainFrame(bool? value) {
    patchMap[JsAlertRequest$.isMainFrame] = value;
    return this;
  }
}

/// Field descriptors for [JsAlertRequest] query construction
abstract final class JsAlertRequestFields {
  static const url = Field<JsAlertRequest, WebUri?>('url', _$url);

  static const message = Field<JsAlertRequest, String?>('message', _$message);

  static const isMainFrame = Field<JsAlertRequest, bool?>(
    'isMainFrame',
    _$isMainFrame,
  );

  static WebUri? _$url(JsAlertRequest e) {
    return e.url;
  }

  static String? _$message(JsAlertRequest e) {
    return e.message;
  }

  static bool? _$isMainFrame(JsAlertRequest e) {
    return e.isMainFrame;
  }
}

extension JsAlertRequestCompareE on JsAlertRequest {
  Map<String, dynamic> compareToJsAlertRequest(JsAlertRequest other) {
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
