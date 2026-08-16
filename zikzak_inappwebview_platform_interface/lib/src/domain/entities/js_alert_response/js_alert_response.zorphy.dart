// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_alert_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsAlertResponse {
  JsAlertResponse({
    String? message,
    String? confirmButtonTitle,
    bool? handledByClient,
    JsAlertResponseAction? action,
  }) : this.message = message ?? '',
       this.confirmButtonTitle = confirmButtonTitle ?? '',
       this.handledByClient = handledByClient ?? false,
       this.action = action ?? JsAlertResponseAction.CONFIRM;

  factory JsAlertResponse.fromJson(Map<String, dynamic> json) =>
      _$JsAlertResponseFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(defaultValue: '')
  final String confirmButtonTitle;

  @JsonKey(defaultValue: false)
  final bool handledByClient;

  @JsonKey(
    defaultValue: JsAlertResponseAction.CONFIRM,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final JsAlertResponseAction? action;

  JsAlertResponse copyWith({
    String? message,
    String? confirmButtonTitle,
    bool? handledByClient,
    JsAlertResponseAction? action,
  }) {
    return JsAlertResponse(
      message: message ?? this.message,
      confirmButtonTitle: confirmButtonTitle ?? this.confirmButtonTitle,
      handledByClient: handledByClient ?? this.handledByClient,
      action: action ?? this.action,
    );
  }

  JsAlertResponse copyWithJsAlertResponse({
    String? message,
    String? confirmButtonTitle,
    bool? handledByClient,
    JsAlertResponseAction? action,
  }) {
    return copyWith(
      message: message,
      confirmButtonTitle: confirmButtonTitle,
      handledByClient: handledByClient,
      action: action,
    );
  }

  JsAlertResponse patchWithJsAlertResponse([JsAlertResponsePatch? patchInput]) {
    final _patcher = patchInput ?? JsAlertResponsePatch();
    final _patchMap = _patcher.patchMap;
    return JsAlertResponse(
      message: _patchMap.containsKey(JsAlertResponse$.message)
          ? (_patchMap[JsAlertResponse$.message] is Function)
                ? _patchMap[JsAlertResponse$.message](this.message)
                : (_patchMap[JsAlertResponse$.message] is Patch)
                ? _patchMap[JsAlertResponse$.message].applyTo(this.message)
                : _patchMap[JsAlertResponse$.message]
          : this.message,
      confirmButtonTitle:
          _patchMap.containsKey(JsAlertResponse$.confirmButtonTitle)
          ? (_patchMap[JsAlertResponse$.confirmButtonTitle] is Function)
                ? _patchMap[JsAlertResponse$.confirmButtonTitle](
                    this.confirmButtonTitle,
                  )
                : (_patchMap[JsAlertResponse$.confirmButtonTitle] is Patch)
                ? _patchMap[JsAlertResponse$.confirmButtonTitle].applyTo(
                    this.confirmButtonTitle,
                  )
                : _patchMap[JsAlertResponse$.confirmButtonTitle]
          : this.confirmButtonTitle,
      handledByClient: _patchMap.containsKey(JsAlertResponse$.handledByClient)
          ? (_patchMap[JsAlertResponse$.handledByClient] is Function)
                ? _patchMap[JsAlertResponse$.handledByClient](
                    this.handledByClient,
                  )
                : (_patchMap[JsAlertResponse$.handledByClient] is Patch)
                ? _patchMap[JsAlertResponse$.handledByClient].applyTo(
                    this.handledByClient,
                  )
                : _patchMap[JsAlertResponse$.handledByClient]
          : this.handledByClient,
      action: _patchMap.containsKey(JsAlertResponse$.action)
          ? (_patchMap[JsAlertResponse$.action] is Function)
                ? _patchMap[JsAlertResponse$.action](this.action)
                : (_patchMap[JsAlertResponse$.action] is Patch)
                ? _patchMap[JsAlertResponse$.action].applyTo(this.action)
                : _patchMap[JsAlertResponse$.action]
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsAlertResponse &&
        message == other.message &&
        confirmButtonTitle == other.confirmButtonTitle &&
        handledByClient == other.handledByClient &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.message,
      this.confirmButtonTitle,
      this.handledByClient,
      this.action,
    );
  }

  @override
  String toString() {
    return 'JsAlertResponse(' +
        'message: ${message}' +
        ', ' +
        'confirmButtonTitle: ${confirmButtonTitle}' +
        ', ' +
        'handledByClient: ${handledByClient}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$JsAlertResponseToJson(this);
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

extension JsAlertResponsePropertyHelpers on JsAlertResponse {
  bool get hasMessage {
    return this.message.isNotEmpty;
  }

  bool get noMessage {
    return this.message.isEmpty;
  }

  bool get hasConfirmButtonTitle {
    return this.confirmButtonTitle.isNotEmpty;
  }

  bool get noConfirmButtonTitle {
    return this.confirmButtonTitle.isEmpty;
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  JsAlertResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionCONFIRM {
    return this.action == JsAlertResponseAction.CONFIRM;
  }
}

extension JsAlertResponseSerialization on JsAlertResponse {
  Map<String, dynamic> toJson() {
    return _$JsAlertResponseToJson(this);
  }
}

enum JsAlertResponse$ { message, confirmButtonTitle, handledByClient, action }

class JsAlertResponsePatch
    extends PatchBase<JsAlertResponse, JsAlertResponse$> {
  JsAlertResponse applyTo(JsAlertResponse entity) {
    return entity.patchWithJsAlertResponse(this);
  }

  JsAlertResponsePatch withMessage(String? value) {
    patchMap[JsAlertResponse$.message] = value;
    return this;
  }

  JsAlertResponsePatch withConfirmButtonTitle(String? value) {
    patchMap[JsAlertResponse$.confirmButtonTitle] = value;
    return this;
  }

  JsAlertResponsePatch withHandledByClient(bool? value) {
    patchMap[JsAlertResponse$.handledByClient] = value;
    return this;
  }

  JsAlertResponsePatch withAction(JsAlertResponseAction? value) {
    patchMap[JsAlertResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [JsAlertResponse] query construction
abstract final class JsAlertResponseFields {
  static const message = Field<JsAlertResponse, String>('message', _$message);

  static const confirmButtonTitle = Field<JsAlertResponse, String>(
    'confirmButtonTitle',
    _$confirmButtonTitle,
  );

  static const handledByClient = Field<JsAlertResponse, bool>(
    'handledByClient',
    _$handledByClient,
  );

  static const action = Field<JsAlertResponse, JsAlertResponseAction?>(
    'action',
    _$action,
  );

  static String _$message(JsAlertResponse e) {
    return e.message;
  }

  static String _$confirmButtonTitle(JsAlertResponse e) {
    return e.confirmButtonTitle;
  }

  static bool _$handledByClient(JsAlertResponse e) {
    return e.handledByClient;
  }

  static JsAlertResponseAction? _$action(JsAlertResponse e) {
    return e.action;
  }
}

extension JsAlertResponseCompareE on JsAlertResponse {
  Map<String, dynamic> compareToJsAlertResponse(JsAlertResponse other) {
    final Map<String, dynamic> diff = {};

    if (message != other.message) {
      diff['message'] = () => other.message;
    }

    if (confirmButtonTitle != other.confirmButtonTitle) {
      diff['confirmButtonTitle'] = () => other.confirmButtonTitle;
    }

    if (handledByClient != other.handledByClient) {
      diff['handledByClient'] = () => other.handledByClient;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
