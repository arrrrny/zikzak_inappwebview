// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'js_before_unload_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class JsBeforeUnloadResponse {
  JsBeforeUnloadResponse({
    String? message,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    JsBeforeUnloadResponseAction? action,
  }) : this.message = message ?? '',
       this.confirmButtonTitle = confirmButtonTitle ?? '',
       this.cancelButtonTitle = cancelButtonTitle ?? '',
       this.handledByClient = handledByClient ?? false,
       this.action = action ?? JsBeforeUnloadResponseAction.CONFIRM;

  factory JsBeforeUnloadResponse.fromJson(Map<String, dynamic> json) =>
      _$JsBeforeUnloadResponseFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(defaultValue: '')
  final String confirmButtonTitle;

  @JsonKey(defaultValue: '')
  final String cancelButtonTitle;

  @JsonKey(defaultValue: false)
  final bool handledByClient;

  @JsonKey(
    defaultValue: JsBeforeUnloadResponseAction.CONFIRM,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final JsBeforeUnloadResponseAction? action;

  JsBeforeUnloadResponse copyWith({
    String? message,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    JsBeforeUnloadResponseAction? action,
  }) {
    return JsBeforeUnloadResponse(
      message: message ?? this.message,
      confirmButtonTitle: confirmButtonTitle ?? this.confirmButtonTitle,
      cancelButtonTitle: cancelButtonTitle ?? this.cancelButtonTitle,
      handledByClient: handledByClient ?? this.handledByClient,
      action: action ?? this.action,
    );
  }

  JsBeforeUnloadResponse copyWithJsBeforeUnloadResponse({
    String? message,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    bool? handledByClient,
    JsBeforeUnloadResponseAction? action,
  }) {
    return copyWith(
      message: message,
      confirmButtonTitle: confirmButtonTitle,
      cancelButtonTitle: cancelButtonTitle,
      handledByClient: handledByClient,
      action: action,
    );
  }

  JsBeforeUnloadResponse patchWithJsBeforeUnloadResponse([
    JsBeforeUnloadResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? JsBeforeUnloadResponsePatch();
    final _patchMap = _patcher.patchMap;
    return JsBeforeUnloadResponse(
      message: _patchMap.containsKey(JsBeforeUnloadResponse$.message)
          ? (_patchMap[JsBeforeUnloadResponse$.message] is Function)
                ? _patchMap[JsBeforeUnloadResponse$.message](this.message)
                : (_patchMap[JsBeforeUnloadResponse$.message] is Patch)
                ? _patchMap[JsBeforeUnloadResponse$.message].applyTo(
                    this.message,
                  )
                : _patchMap[JsBeforeUnloadResponse$.message]
          : this.message,
      confirmButtonTitle:
          _patchMap.containsKey(JsBeforeUnloadResponse$.confirmButtonTitle)
          ? (_patchMap[JsBeforeUnloadResponse$.confirmButtonTitle] is Function)
                ? _patchMap[JsBeforeUnloadResponse$.confirmButtonTitle](
                    this.confirmButtonTitle,
                  )
                : (_patchMap[JsBeforeUnloadResponse$.confirmButtonTitle]
                      is Patch)
                ? _patchMap[JsBeforeUnloadResponse$.confirmButtonTitle].applyTo(
                    this.confirmButtonTitle,
                  )
                : _patchMap[JsBeforeUnloadResponse$.confirmButtonTitle]
          : this.confirmButtonTitle,
      cancelButtonTitle:
          _patchMap.containsKey(JsBeforeUnloadResponse$.cancelButtonTitle)
          ? (_patchMap[JsBeforeUnloadResponse$.cancelButtonTitle] is Function)
                ? _patchMap[JsBeforeUnloadResponse$.cancelButtonTitle](
                    this.cancelButtonTitle,
                  )
                : (_patchMap[JsBeforeUnloadResponse$.cancelButtonTitle]
                      is Patch)
                ? _patchMap[JsBeforeUnloadResponse$.cancelButtonTitle].applyTo(
                    this.cancelButtonTitle,
                  )
                : _patchMap[JsBeforeUnloadResponse$.cancelButtonTitle]
          : this.cancelButtonTitle,
      handledByClient:
          _patchMap.containsKey(JsBeforeUnloadResponse$.handledByClient)
          ? (_patchMap[JsBeforeUnloadResponse$.handledByClient] is Function)
                ? _patchMap[JsBeforeUnloadResponse$.handledByClient](
                    this.handledByClient,
                  )
                : (_patchMap[JsBeforeUnloadResponse$.handledByClient] is Patch)
                ? _patchMap[JsBeforeUnloadResponse$.handledByClient].applyTo(
                    this.handledByClient,
                  )
                : _patchMap[JsBeforeUnloadResponse$.handledByClient]
          : this.handledByClient,
      action: _patchMap.containsKey(JsBeforeUnloadResponse$.action)
          ? (_patchMap[JsBeforeUnloadResponse$.action] is Function)
                ? _patchMap[JsBeforeUnloadResponse$.action](this.action)
                : (_patchMap[JsBeforeUnloadResponse$.action] is Patch)
                ? _patchMap[JsBeforeUnloadResponse$.action].applyTo(this.action)
                : _patchMap[JsBeforeUnloadResponse$.action]
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsBeforeUnloadResponse &&
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
    return 'JsBeforeUnloadResponse(' +
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
    final Map<String, dynamic> data = _$JsBeforeUnloadResponseToJson(this);
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

extension JsBeforeUnloadResponsePropertyHelpers on JsBeforeUnloadResponse {
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

  JsBeforeUnloadResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionCONFIRM {
    return this.action == JsBeforeUnloadResponseAction.CONFIRM;
  }

  bool get isActionCANCEL {
    return this.action == JsBeforeUnloadResponseAction.CANCEL;
  }
}

extension JsBeforeUnloadResponseSerialization on JsBeforeUnloadResponse {
  Map<String, dynamic> toJson() {
    return _$JsBeforeUnloadResponseToJson(this);
  }
}

enum JsBeforeUnloadResponse$ {
  message,
  confirmButtonTitle,
  cancelButtonTitle,
  handledByClient,
  action,
}

class JsBeforeUnloadResponsePatch
    extends PatchBase<JsBeforeUnloadResponse, JsBeforeUnloadResponse$> {
  JsBeforeUnloadResponse applyTo(JsBeforeUnloadResponse entity) {
    return entity.patchWithJsBeforeUnloadResponse(this);
  }

  JsBeforeUnloadResponsePatch withMessage(String? value) {
    patchMap[JsBeforeUnloadResponse$.message] = value;
    return this;
  }

  JsBeforeUnloadResponsePatch withConfirmButtonTitle(String? value) {
    patchMap[JsBeforeUnloadResponse$.confirmButtonTitle] = value;
    return this;
  }

  JsBeforeUnloadResponsePatch withCancelButtonTitle(String? value) {
    patchMap[JsBeforeUnloadResponse$.cancelButtonTitle] = value;
    return this;
  }

  JsBeforeUnloadResponsePatch withHandledByClient(bool? value) {
    patchMap[JsBeforeUnloadResponse$.handledByClient] = value;
    return this;
  }

  JsBeforeUnloadResponsePatch withAction(JsBeforeUnloadResponseAction? value) {
    patchMap[JsBeforeUnloadResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [JsBeforeUnloadResponse] query construction
abstract final class JsBeforeUnloadResponseFields {
  static const message = Field<JsBeforeUnloadResponse, String>(
    'message',
    _$message,
  );

  static const confirmButtonTitle = Field<JsBeforeUnloadResponse, String>(
    'confirmButtonTitle',
    _$confirmButtonTitle,
  );

  static const cancelButtonTitle = Field<JsBeforeUnloadResponse, String>(
    'cancelButtonTitle',
    _$cancelButtonTitle,
  );

  static const handledByClient = Field<JsBeforeUnloadResponse, bool>(
    'handledByClient',
    _$handledByClient,
  );

  static const action =
      Field<JsBeforeUnloadResponse, JsBeforeUnloadResponseAction?>(
        'action',
        _$action,
      );

  static String _$message(JsBeforeUnloadResponse e) {
    return e.message;
  }

  static String _$confirmButtonTitle(JsBeforeUnloadResponse e) {
    return e.confirmButtonTitle;
  }

  static String _$cancelButtonTitle(JsBeforeUnloadResponse e) {
    return e.cancelButtonTitle;
  }

  static bool _$handledByClient(JsBeforeUnloadResponse e) {
    return e.handledByClient;
  }

  static JsBeforeUnloadResponseAction? _$action(JsBeforeUnloadResponse e) {
    return e.action;
  }
}

extension JsBeforeUnloadResponseCompareE on JsBeforeUnloadResponse {
  Map<String, dynamic> compareToJsBeforeUnloadResponse(
    JsBeforeUnloadResponse other,
  ) {
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
