// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_prompt_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsPromptResponse {
  JsPromptResponse({
    String? message,
    String? defaultValue,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    String? this.value,
    JsPromptResponseAction? action,
  }) : this.message = message ?? '',
       this.defaultValue = defaultValue ?? '',
       this.confirmButtonTitle = confirmButtonTitle ?? '',
       this.cancelButtonTitle = cancelButtonTitle ?? '',
       this.handledByClient = handledByClient ?? false,
       this.action = action ?? JsPromptResponseAction.CANCEL;

  factory JsPromptResponse.fromJson(Map<String, dynamic> json) =>
      _$JsPromptResponseFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(defaultValue: '')
  final String defaultValue;

  @JsonKey(defaultValue: '')
  final String confirmButtonTitle;

  @JsonKey(defaultValue: '')
  final String cancelButtonTitle;

  @JsonKey(defaultValue: false)
  final bool handledByClient;

  final String? value;

  @JsonKey(
    defaultValue: JsPromptResponseAction.CANCEL,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final JsPromptResponseAction? action;

  JsPromptResponse copyWith({
    String? message,
    String? defaultValue,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    String? value,
    JsPromptResponseAction? action,
  }) {
    return JsPromptResponse(
      message: message ?? this.message,
      defaultValue: defaultValue ?? this.defaultValue,
      confirmButtonTitle: confirmButtonTitle ?? this.confirmButtonTitle,
      cancelButtonTitle: cancelButtonTitle ?? this.cancelButtonTitle,
      handledByClient: handledByClient ?? this.handledByClient,
      value: value ?? this.value,
      action: action ?? this.action,
    );
  }

  JsPromptResponse copyWithJsPromptResponse({
    String? message,
    String? defaultValue,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    String? value,
    JsPromptResponseAction? action,
  }) {
    return copyWith(
      message: message,
      defaultValue: defaultValue,
      confirmButtonTitle: confirmButtonTitle,
      cancelButtonTitle: cancelButtonTitle,
      handledByClient: handledByClient,
      value: value,
      action: action,
    );
  }

  JsPromptResponse patchWithJsPromptResponse([
    JsPromptResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? JsPromptResponsePatch();
    final _patchMap = _patcher.patchMap;
    return JsPromptResponse(
      message: _patchMap.containsKey(JsPromptResponse$.message)
          ? ((_patchMap[JsPromptResponse$.message] is Function)
                    ? _patchMap[JsPromptResponse$.message](this.message)
                    : (_patchMap[JsPromptResponse$.message] is Patch)
                    ? _patchMap[JsPromptResponse$.message].applyTo(this.message)
                    : _patchMap[JsPromptResponse$.message])
                as String
          : this.message,
      defaultValue: _patchMap.containsKey(JsPromptResponse$.defaultValue)
          ? ((_patchMap[JsPromptResponse$.defaultValue] is Function)
                    ? _patchMap[JsPromptResponse$.defaultValue](
                        this.defaultValue,
                      )
                    : (_patchMap[JsPromptResponse$.defaultValue] is Patch)
                    ? _patchMap[JsPromptResponse$.defaultValue].applyTo(
                        this.defaultValue,
                      )
                    : _patchMap[JsPromptResponse$.defaultValue])
                as String
          : this.defaultValue,
      confirmButtonTitle:
          _patchMap.containsKey(JsPromptResponse$.confirmButtonTitle)
          ? ((_patchMap[JsPromptResponse$.confirmButtonTitle] is Function)
                    ? _patchMap[JsPromptResponse$.confirmButtonTitle](
                        this.confirmButtonTitle,
                      )
                    : (_patchMap[JsPromptResponse$.confirmButtonTitle] is Patch)
                    ? _patchMap[JsPromptResponse$.confirmButtonTitle].applyTo(
                        this.confirmButtonTitle,
                      )
                    : _patchMap[JsPromptResponse$.confirmButtonTitle])
                as String
          : this.confirmButtonTitle,
      cancelButtonTitle:
          _patchMap.containsKey(JsPromptResponse$.cancelButtonTitle)
          ? ((_patchMap[JsPromptResponse$.cancelButtonTitle] is Function)
                    ? _patchMap[JsPromptResponse$.cancelButtonTitle](
                        this.cancelButtonTitle,
                      )
                    : (_patchMap[JsPromptResponse$.cancelButtonTitle] is Patch)
                    ? _patchMap[JsPromptResponse$.cancelButtonTitle].applyTo(
                        this.cancelButtonTitle,
                      )
                    : _patchMap[JsPromptResponse$.cancelButtonTitle])
                as String
          : this.cancelButtonTitle,
      handledByClient: _patchMap.containsKey(JsPromptResponse$.handledByClient)
          ? ((_patchMap[JsPromptResponse$.handledByClient] is Function)
                    ? _patchMap[JsPromptResponse$.handledByClient](
                        this.handledByClient,
                      )
                    : (_patchMap[JsPromptResponse$.handledByClient] is Patch)
                    ? _patchMap[JsPromptResponse$.handledByClient].applyTo(
                        this.handledByClient,
                      )
                    : _patchMap[JsPromptResponse$.handledByClient])
                as bool
          : this.handledByClient,
      value: _patchMap.containsKey(JsPromptResponse$.value)
          ? ((_patchMap[JsPromptResponse$.value] is Function)
                    ? _patchMap[JsPromptResponse$.value](this.value)
                    : (_patchMap[JsPromptResponse$.value] is Patch)
                    ? _patchMap[JsPromptResponse$.value].applyTo(this.value)
                    : _patchMap[JsPromptResponse$.value])
                as String?
          : this.value,
      action: _patchMap.containsKey(JsPromptResponse$.action)
          ? ((_patchMap[JsPromptResponse$.action] is Function)
                    ? _patchMap[JsPromptResponse$.action](this.action)
                    : (_patchMap[JsPromptResponse$.action] is Patch)
                    ? _patchMap[JsPromptResponse$.action].applyTo(this.action)
                    : _patchMap[JsPromptResponse$.action])
                as JsPromptResponseAction?
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsPromptResponse &&
        message == other.message &&
        defaultValue == other.defaultValue &&
        confirmButtonTitle == other.confirmButtonTitle &&
        cancelButtonTitle == other.cancelButtonTitle &&
        handledByClient == other.handledByClient &&
        value == other.value &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.message,
      this.defaultValue,
      this.confirmButtonTitle,
      this.cancelButtonTitle,
      this.handledByClient,
      this.value,
      this.action,
    );
  }

  @override
  String toString() {
    return 'JsPromptResponse(' +
        'message: ${message}' +
        ', ' +
        'defaultValue: ${defaultValue}' +
        ', ' +
        'confirmButtonTitle: ${confirmButtonTitle}' +
        ', ' +
        'cancelButtonTitle: ${cancelButtonTitle}' +
        ', ' +
        'handledByClient: ${handledByClient}' +
        ', ' +
        'value: ${value}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$JsPromptResponseToJson(this);
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

extension JsPromptResponsePropertyHelpers on JsPromptResponse {
  bool get hasMessage {
    return this.message.isNotEmpty;
  }

  bool get noMessage {
    return this.message.isEmpty;
  }

  bool get hasDefaultValue {
    return this.defaultValue.isNotEmpty;
  }

  bool get noDefaultValue {
    return this.defaultValue.isEmpty;
  }

  bool get hasConfirmButtonTitle {
    return this.confirmButtonTitle.isNotEmpty;
  }

  bool get noConfirmButtonTitle {
    return this.confirmButtonTitle.isEmpty;
  }

  bool get hasCancelButtonTitle {
    return this.cancelButtonTitle.isNotEmpty;
  }

  bool get noCancelButtonTitle {
    return this.cancelButtonTitle.isEmpty;
  }

  bool get hasValue {
    return this.value?.isNotEmpty == true;
  }

  bool get noValue {
    return this.value?.isEmpty ?? true;
  }

  String get valueRequired {
    return this.value ?? (throw StateError('value is required but was null'));
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  JsPromptResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionCONFIRM {
    return this.action == JsPromptResponseAction.CONFIRM;
  }

  bool get isActionCANCEL {
    return this.action == JsPromptResponseAction.CANCEL;
  }
}

extension JsPromptResponseSerialization on JsPromptResponse {
  Map<String, dynamic> toJson() {
    return _$JsPromptResponseToJson(this);
  }
}

enum JsPromptResponse$ {
  message,
  defaultValue,
  confirmButtonTitle,
  cancelButtonTitle,
  handledByClient,
  value,
  action,
}

class JsPromptResponsePatch
    extends PatchBase<JsPromptResponse, JsPromptResponse$> {
  JsPromptResponse applyTo(JsPromptResponse entity) {
    return entity.patchWithJsPromptResponse(this);
  }

  JsPromptResponsePatch withMessage(String? value) {
    patchMap[JsPromptResponse$.message] = value;
    return this;
  }

  JsPromptResponsePatch withDefaultValue(String? value) {
    patchMap[JsPromptResponse$.defaultValue] = value;
    return this;
  }

  JsPromptResponsePatch withConfirmButtonTitle(String? value) {
    patchMap[JsPromptResponse$.confirmButtonTitle] = value;
    return this;
  }

  JsPromptResponsePatch withCancelButtonTitle(String? value) {
    patchMap[JsPromptResponse$.cancelButtonTitle] = value;
    return this;
  }

  JsPromptResponsePatch withHandledByClient(bool? value) {
    patchMap[JsPromptResponse$.handledByClient] = value;
    return this;
  }

  JsPromptResponsePatch withValue(String? value) {
    patchMap[JsPromptResponse$.value] = value;
    return this;
  }

  JsPromptResponsePatch withAction(JsPromptResponseAction? value) {
    patchMap[JsPromptResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [JsPromptResponse] query construction
abstract final class JsPromptResponseFields {
  static const message = Field<JsPromptResponse, String>('message', _$message);

  static const defaultValue = Field<JsPromptResponse, String>(
    'defaultValue',
    _$defaultValue,
  );

  static const confirmButtonTitle = Field<JsPromptResponse, String>(
    'confirmButtonTitle',
    _$confirmButtonTitle,
  );

  static const cancelButtonTitle = Field<JsPromptResponse, String>(
    'cancelButtonTitle',
    _$cancelButtonTitle,
  );

  static const handledByClient = Field<JsPromptResponse, bool>(
    'handledByClient',
    _$handledByClient,
  );

  static const value = Field<JsPromptResponse, String?>('value', _$value);

  static const action = Field<JsPromptResponse, JsPromptResponseAction?>(
    'action',
    _$action,
  );

  static String _$message(JsPromptResponse e) {
    return e.message;
  }

  static String _$defaultValue(JsPromptResponse e) {
    return e.defaultValue;
  }

  static String _$confirmButtonTitle(JsPromptResponse e) {
    return e.confirmButtonTitle;
  }

  static String _$cancelButtonTitle(JsPromptResponse e) {
    return e.cancelButtonTitle;
  }

  static bool _$handledByClient(JsPromptResponse e) {
    return e.handledByClient;
  }

  static String? _$value(JsPromptResponse e) {
    return e.value;
  }

  static JsPromptResponseAction? _$action(JsPromptResponse e) {
    return e.action;
  }
}

extension JsPromptResponseCompareE on JsPromptResponse {
  Map<String, dynamic> compareToJsPromptResponse(JsPromptResponse other) {
    final Map<String, dynamic> diff = {};

    if (message != other.message) {
      diff['message'] = () => other.message;
    }

    if (defaultValue != other.defaultValue) {
      diff['defaultValue'] = () => other.defaultValue;
    }

    if (confirmButtonTitle != other.confirmButtonTitle) {
      diff['confirmButtonTitle'] = () => other.confirmButtonTitle;
    }

    if (cancelButtonTitle != other.cancelButtonTitle) {
      diff['cancelButtonTitle'] = () => other.cancelButtonTitle;
    }

    if (handledByClient != other.handledByClient) {
      diff['handledByClient'] = () => other.handledByClient;
    }

    if (value != other.value) {
      diff['value'] = () => other.value;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
