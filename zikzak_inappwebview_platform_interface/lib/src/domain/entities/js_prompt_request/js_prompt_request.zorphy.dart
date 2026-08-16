// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_prompt_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsPromptRequest {
  JsPromptRequest({
    WebUri? this.url,
    String? this.message,
    String? this.defaultValue,
    bool? this.isMainFrame,
  });

  factory JsPromptRequest.fromJson(Map<String, dynamic> json) =>
      _$JsPromptRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final String? message;

  final String? defaultValue;

  final bool? isMainFrame;

  JsPromptRequest copyWith({
    WebUri? url,
    String? message,
    String? defaultValue,
    bool? isMainFrame,
  }) {
    return JsPromptRequest(
      url: url ?? this.url,
      message: message ?? this.message,
      defaultValue: defaultValue ?? this.defaultValue,
      isMainFrame: isMainFrame ?? this.isMainFrame,
    );
  }

  JsPromptRequest copyWithJsPromptRequest({
    WebUri? url,
    String? message,
    String? defaultValue,
    bool? isMainFrame,
  }) {
    return copyWith(
      url: url,
      message: message,
      defaultValue: defaultValue,
      isMainFrame: isMainFrame,
    );
  }

  JsPromptRequest patchWithJsPromptRequest([JsPromptRequestPatch? patchInput]) {
    final _patcher = patchInput ?? JsPromptRequestPatch();
    final _patchMap = _patcher.patchMap;
    return JsPromptRequest(
      url: _patchMap.containsKey(JsPromptRequest$.url)
          ? (_patchMap[JsPromptRequest$.url] is Function)
                ? _patchMap[JsPromptRequest$.url](this.url)
                : (_patchMap[JsPromptRequest$.url] is Patch)
                ? _patchMap[JsPromptRequest$.url].applyTo(this.url)
                : _patchMap[JsPromptRequest$.url]
          : this.url,
      message: _patchMap.containsKey(JsPromptRequest$.message)
          ? (_patchMap[JsPromptRequest$.message] is Function)
                ? _patchMap[JsPromptRequest$.message](this.message)
                : (_patchMap[JsPromptRequest$.message] is Patch)
                ? _patchMap[JsPromptRequest$.message].applyTo(this.message)
                : _patchMap[JsPromptRequest$.message]
          : this.message,
      defaultValue: _patchMap.containsKey(JsPromptRequest$.defaultValue)
          ? (_patchMap[JsPromptRequest$.defaultValue] is Function)
                ? _patchMap[JsPromptRequest$.defaultValue](this.defaultValue)
                : (_patchMap[JsPromptRequest$.defaultValue] is Patch)
                ? _patchMap[JsPromptRequest$.defaultValue].applyTo(
                    this.defaultValue,
                  )
                : _patchMap[JsPromptRequest$.defaultValue]
          : this.defaultValue,
      isMainFrame: _patchMap.containsKey(JsPromptRequest$.isMainFrame)
          ? (_patchMap[JsPromptRequest$.isMainFrame] is Function)
                ? _patchMap[JsPromptRequest$.isMainFrame](this.isMainFrame)
                : (_patchMap[JsPromptRequest$.isMainFrame] is Patch)
                ? _patchMap[JsPromptRequest$.isMainFrame].applyTo(
                    this.isMainFrame,
                  )
                : _patchMap[JsPromptRequest$.isMainFrame]
          : this.isMainFrame,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsPromptRequest &&
        url == other.url &&
        message == other.message &&
        defaultValue == other.defaultValue &&
        isMainFrame == other.isMainFrame;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.url,
      this.message,
      this.defaultValue,
      this.isMainFrame,
    );
  }

  @override
  String toString() {
    return 'JsPromptRequest(' +
        'url: ${url}' +
        ', ' +
        'message: ${message}' +
        ', ' +
        'defaultValue: ${defaultValue}' +
        ', ' +
        'isMainFrame: ${isMainFrame})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$JsPromptRequestToJson(this);
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

extension JsPromptRequestPropertyHelpers on JsPromptRequest {
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

  bool get hasDefaultValue {
    return this.defaultValue?.isNotEmpty == true;
  }

  bool get noDefaultValue {
    return this.defaultValue?.isEmpty ?? true;
  }

  String get defaultValueRequired {
    return this.defaultValue ??
        (throw StateError('defaultValue is required but was null'));
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

extension JsPromptRequestSerialization on JsPromptRequest {
  Map<String, dynamic> toJson() {
    return _$JsPromptRequestToJson(this);
  }
}

enum JsPromptRequest$ { url, message, defaultValue, isMainFrame }

class JsPromptRequestPatch
    extends PatchBase<JsPromptRequest, JsPromptRequest$> {
  JsPromptRequest applyTo(JsPromptRequest entity) {
    return entity.patchWithJsPromptRequest(this);
  }

  JsPromptRequestPatch withUrl(WebUri? value) {
    patchMap[JsPromptRequest$.url] = value;
    return this;
  }

  JsPromptRequestPatch withMessage(String? value) {
    patchMap[JsPromptRequest$.message] = value;
    return this;
  }

  JsPromptRequestPatch withDefaultValue(String? value) {
    patchMap[JsPromptRequest$.defaultValue] = value;
    return this;
  }

  JsPromptRequestPatch withIsMainFrame(bool? value) {
    patchMap[JsPromptRequest$.isMainFrame] = value;
    return this;
  }
}

/// Field descriptors for [JsPromptRequest] query construction
abstract final class JsPromptRequestFields {
  static const url = Field<JsPromptRequest, WebUri?>('url', _$url);

  static const message = Field<JsPromptRequest, String?>('message', _$message);

  static const defaultValue = Field<JsPromptRequest, String?>(
    'defaultValue',
    _$defaultValue,
  );

  static const isMainFrame = Field<JsPromptRequest, bool?>(
    'isMainFrame',
    _$isMainFrame,
  );

  static WebUri? _$url(JsPromptRequest e) {
    return e.url;
  }

  static String? _$message(JsPromptRequest e) {
    return e.message;
  }

  static String? _$defaultValue(JsPromptRequest e) {
    return e.defaultValue;
  }

  static bool? _$isMainFrame(JsPromptRequest e) {
    return e.isMainFrame;
  }
}

extension JsPromptRequestCompareE on JsPromptRequest {
  Map<String, dynamic> compareToJsPromptRequest(JsPromptRequest other) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (message != other.message) {
      diff['message'] = () => other.message;
    }

    if (defaultValue != other.defaultValue) {
      diff['defaultValue'] = () => other.defaultValue;
    }

    if (isMainFrame != other.isMainFrame) {
      diff['isMainFrame'] = () => other.isMainFrame;
    }
    return diff;
  }
}
