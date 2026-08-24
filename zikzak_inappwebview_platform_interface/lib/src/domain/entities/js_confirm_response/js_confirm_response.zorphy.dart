// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_confirm_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsConfirmResponse {
  JsConfirmResponse({
    String? message,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    JsConfirmResponseAction? action,
  }) : this.message = message ?? '',
       this.confirmButtonTitle = confirmButtonTitle ?? '',
       this.cancelButtonTitle = cancelButtonTitle ?? '',
       this.handledByClient = handledByClient ?? false,
       this.action = action ?? JsConfirmResponseAction.CANCEL;

  factory JsConfirmResponse.fromJson(Map<String, dynamic> json) =>
      _$JsConfirmResponseFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(defaultValue: '')
  final String confirmButtonTitle;

  @JsonKey(defaultValue: '')
  final String cancelButtonTitle;

  @JsonKey(defaultValue: false)
  final bool handledByClient;

  @JsonKey(
    defaultValue: JsConfirmResponseAction.CANCEL,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final JsConfirmResponseAction? action;

  JsConfirmResponse copyWith({
    String? message,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    JsConfirmResponseAction? action,
  }) {
    return JsConfirmResponse(
      message: message ?? this.message,
      confirmButtonTitle: confirmButtonTitle ?? this.confirmButtonTitle,
      cancelButtonTitle: cancelButtonTitle ?? this.cancelButtonTitle,
      handledByClient: handledByClient ?? this.handledByClient,
      action: action ?? this.action,
    );
  }

  JsConfirmResponse copyWithJsConfirmResponse({
    String? message,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    JsConfirmResponseAction? action,
  }) {
    return copyWith(
      message: message,
      confirmButtonTitle: confirmButtonTitle,
      cancelButtonTitle: cancelButtonTitle,
      handledByClient: handledByClient,
      action: action,
    );
  }

  JsConfirmResponse patchWithJsConfirmResponse([
    JsConfirmResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? JsConfirmResponsePatch();
    final _patchMap = _patcher.patchMap;
    return JsConfirmResponse(
      message: _patchMap.containsKey(JsConfirmResponse$.message)
          ? ((_patchMap[JsConfirmResponse$.message] is Function)
                    ? _patchMap[JsConfirmResponse$.message](this.message)
                    : (_patchMap[JsConfirmResponse$.message] is Patch)
                    ? _patchMap[JsConfirmResponse$.message].applyTo(
                        this.message,
                      )
                    : _patchMap[JsConfirmResponse$.message])
                as String
          : this.message,
      confirmButtonTitle:
          _patchMap.containsKey(JsConfirmResponse$.confirmButtonTitle)
          ? ((_patchMap[JsConfirmResponse$.confirmButtonTitle] is Function)
                    ? _patchMap[JsConfirmResponse$.confirmButtonTitle](
                        this.confirmButtonTitle,
                      )
                    : (_patchMap[JsConfirmResponse$.confirmButtonTitle]
                          is Patch)
                    ? _patchMap[JsConfirmResponse$.confirmButtonTitle].applyTo(
                        this.confirmButtonTitle,
                      )
                    : _patchMap[JsConfirmResponse$.confirmButtonTitle])
                as String
          : this.confirmButtonTitle,
      cancelButtonTitle:
          _patchMap.containsKey(JsConfirmResponse$.cancelButtonTitle)
          ? ((_patchMap[JsConfirmResponse$.cancelButtonTitle] is Function)
                    ? _patchMap[JsConfirmResponse$.cancelButtonTitle](
                        this.cancelButtonTitle,
                      )
                    : (_patchMap[JsConfirmResponse$.cancelButtonTitle] is Patch)
                    ? _patchMap[JsConfirmResponse$.cancelButtonTitle].applyTo(
                        this.cancelButtonTitle,
                      )
                    : _patchMap[JsConfirmResponse$.cancelButtonTitle])
                as String
          : this.cancelButtonTitle,
      handledByClient: _patchMap.containsKey(JsConfirmResponse$.handledByClient)
          ? ((_patchMap[JsConfirmResponse$.handledByClient] is Function)
                    ? _patchMap[JsConfirmResponse$.handledByClient](
                        this.handledByClient,
                      )
                    : (_patchMap[JsConfirmResponse$.handledByClient] is Patch)
                    ? _patchMap[JsConfirmResponse$.handledByClient].applyTo(
                        this.handledByClient,
                      )
                    : _patchMap[JsConfirmResponse$.handledByClient])
                as bool
          : this.handledByClient,
      action: _patchMap.containsKey(JsConfirmResponse$.action)
          ? ((_patchMap[JsConfirmResponse$.action] is Function)
                    ? _patchMap[JsConfirmResponse$.action](this.action)
                    : (_patchMap[JsConfirmResponse$.action] is Patch)
                    ? _patchMap[JsConfirmResponse$.action].applyTo(this.action)
                    : _patchMap[JsConfirmResponse$.action])
                as JsConfirmResponseAction?
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsConfirmResponse &&
        message == other.message &&
        confirmButtonTitle == other.confirmButtonTitle &&
        cancelButtonTitle == other.cancelButtonTitle &&
        handledByClient == other.handledByClient &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.message,
      this.confirmButtonTitle,
      this.cancelButtonTitle,
      this.handledByClient,
      this.action,
    );
  }

  @override
  String toString() {
    return 'JsConfirmResponse(' +
        'message: ${message}' +
        ', ' +
        'confirmButtonTitle: ${confirmButtonTitle}' +
        ', ' +
        'cancelButtonTitle: ${cancelButtonTitle}' +
        ', ' +
        'handledByClient: ${handledByClient}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$JsConfirmResponseToJson(this);
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

extension JsConfirmResponsePropertyHelpers on JsConfirmResponse {
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

  bool get hasCancelButtonTitle {
    return this.cancelButtonTitle.isNotEmpty;
  }

  bool get noCancelButtonTitle {
    return this.cancelButtonTitle.isEmpty;
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  JsConfirmResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionCONFIRM {
    return this.action == JsConfirmResponseAction.CONFIRM;
  }

  bool get isActionCANCEL {
    return this.action == JsConfirmResponseAction.CANCEL;
  }
}

extension JsConfirmResponseSerialization on JsConfirmResponse {
  Map<String, dynamic> toJson() {
    return _$JsConfirmResponseToJson(this);
  }
}

enum JsConfirmResponse$ {
  message,
  confirmButtonTitle,
  cancelButtonTitle,
  handledByClient,
  action,
}

class JsConfirmResponsePatch
    extends PatchBase<JsConfirmResponse, JsConfirmResponse$> {
  JsConfirmResponse applyTo(JsConfirmResponse entity) {
    return entity.patchWithJsConfirmResponse(this);
  }

  JsConfirmResponsePatch withMessage(String? value) {
    patchMap[JsConfirmResponse$.message] = value;
    return this;
  }

  JsConfirmResponsePatch withConfirmButtonTitle(String? value) {
    patchMap[JsConfirmResponse$.confirmButtonTitle] = value;
    return this;
  }

  JsConfirmResponsePatch withCancelButtonTitle(String? value) {
    patchMap[JsConfirmResponse$.cancelButtonTitle] = value;
    return this;
  }

  JsConfirmResponsePatch withHandledByClient(bool? value) {
    patchMap[JsConfirmResponse$.handledByClient] = value;
    return this;
  }

  JsConfirmResponsePatch withAction(JsConfirmResponseAction? value) {
    patchMap[JsConfirmResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [JsConfirmResponse] query construction
abstract final class JsConfirmResponseFields {
  static const message = Field<JsConfirmResponse, String>('message', _$message);

  static const confirmButtonTitle = Field<JsConfirmResponse, String>(
    'confirmButtonTitle',
    _$confirmButtonTitle,
  );

  static const cancelButtonTitle = Field<JsConfirmResponse, String>(
    'cancelButtonTitle',
    _$cancelButtonTitle,
  );

  static const handledByClient = Field<JsConfirmResponse, bool>(
    'handledByClient',
    _$handledByClient,
  );

  static const action = Field<JsConfirmResponse, JsConfirmResponseAction?>(
    'action',
    _$action,
  );

  static String _$message(JsConfirmResponse e) {
    return e.message;
  }

  static String _$confirmButtonTitle(JsConfirmResponse e) {
    return e.confirmButtonTitle;
  }

  static String _$cancelButtonTitle(JsConfirmResponse e) {
    return e.cancelButtonTitle;
  }

  static bool _$handledByClient(JsConfirmResponse e) {
    return e.handledByClient;
  }

  static JsConfirmResponseAction? _$action(JsConfirmResponse e) {
    return e.action;
  }
}

extension JsConfirmResponseCompareE on JsConfirmResponse {
  Map<String, dynamic> compareToJsConfirmResponse(JsConfirmResponse other) {
    final Map<String, dynamic> diff = {};

    if (message != other.message) {
      diff['message'] = () => other.message;
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

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
