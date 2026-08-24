// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'console_message.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ConsoleMessage {
  ConsoleMessage({String? message, ConsoleMessageLevel? messageLevel})
    : this.message = message ?? '',
      this.messageLevel = messageLevel ?? ConsoleMessageLevel.LOG;

  factory ConsoleMessage.fromJson(Map<String, dynamic> json) =>
      _$ConsoleMessageFromJson(json);

  @JsonKey(defaultValue: '')
  final String? message;

  @JsonKey(
    defaultValue: ConsoleMessageLevel.LOG,
    toJson: _messageLevelToJson,
    fromJson: _messageLevelFromJson,
  )
  final ConsoleMessageLevel? messageLevel;

  ConsoleMessage copyWith({
    String? message,
    ConsoleMessageLevel? messageLevel,
  }) {
    return ConsoleMessage(
      message: message ?? this.message,
      messageLevel: messageLevel ?? this.messageLevel,
    );
  }

  ConsoleMessage copyWithConsoleMessage({
    String? message,
    ConsoleMessageLevel? messageLevel,
  }) {
    return copyWith(message: message, messageLevel: messageLevel);
  }

  ConsoleMessage patchWithConsoleMessage([ConsoleMessagePatch? patchInput]) {
    final _patcher = patchInput ?? ConsoleMessagePatch();
    final _patchMap = _patcher.patchMap;
    return ConsoleMessage(
      message: _patchMap.containsKey(ConsoleMessage$.message)
          ? ((_patchMap[ConsoleMessage$.message] is Function)
                    ? _patchMap[ConsoleMessage$.message](this.message)
                    : (_patchMap[ConsoleMessage$.message] is Patch)
                    ? _patchMap[ConsoleMessage$.message].applyTo(this.message)
                    : _patchMap[ConsoleMessage$.message])
                as String?
          : this.message,
      messageLevel: _patchMap.containsKey(ConsoleMessage$.messageLevel)
          ? ((_patchMap[ConsoleMessage$.messageLevel] is Function)
                    ? _patchMap[ConsoleMessage$.messageLevel](this.messageLevel)
                    : (_patchMap[ConsoleMessage$.messageLevel] is Patch)
                    ? _patchMap[ConsoleMessage$.messageLevel].applyTo(
                        this.messageLevel,
                      )
                    : _patchMap[ConsoleMessage$.messageLevel])
                as ConsoleMessageLevel?
          : this.messageLevel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsoleMessage &&
        message == other.message &&
        messageLevel == other.messageLevel;
  }

  @override
  int get hashCode {
    return Object.hash(this.message, this.messageLevel);
  }

  @override
  String toString() {
    return 'ConsoleMessage(' +
        'message: ${message}' +
        ', ' +
        'messageLevel: ${messageLevel})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ConsoleMessageToJson(this);
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

extension ConsoleMessagePropertyHelpers on ConsoleMessage {
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

  bool get hasMessageLevel {
    return this.messageLevel != null;
  }

  bool get noMessageLevel {
    return this.messageLevel == null;
  }

  ConsoleMessageLevel get messageLevelRequired {
    return this.messageLevel ??
        (throw StateError('messageLevel is required but was null'));
  }

  bool get isMessageLevelTIP {
    return this.messageLevel == ConsoleMessageLevel.TIP;
  }

  bool get isMessageLevelLOG {
    return this.messageLevel == ConsoleMessageLevel.LOG;
  }

  bool get isMessageLevelWARNING {
    return this.messageLevel == ConsoleMessageLevel.WARNING;
  }

  bool get isMessageLevelERROR {
    return this.messageLevel == ConsoleMessageLevel.ERROR;
  }

  bool get isMessageLevelDEBUG {
    return this.messageLevel == ConsoleMessageLevel.DEBUG;
  }
}

extension ConsoleMessageSerialization on ConsoleMessage {
  Map<String, dynamic> toJson() {
    return _$ConsoleMessageToJson(this);
  }
}

enum ConsoleMessage$ { message, messageLevel }

class ConsoleMessagePatch extends PatchBase<ConsoleMessage, ConsoleMessage$> {
  ConsoleMessage applyTo(ConsoleMessage entity) {
    return entity.patchWithConsoleMessage(this);
  }

  ConsoleMessagePatch withMessage(String? value) {
    patchMap[ConsoleMessage$.message] = value;
    return this;
  }

  ConsoleMessagePatch withMessageLevel(ConsoleMessageLevel? value) {
    patchMap[ConsoleMessage$.messageLevel] = value;
    return this;
  }
}

/// Field descriptors for [ConsoleMessage] query construction
abstract final class ConsoleMessageFields {
  static const message = Field<ConsoleMessage, String?>('message', _$message);

  static const messageLevel = Field<ConsoleMessage, ConsoleMessageLevel?>(
    'messageLevel',
    _$messageLevel,
  );

  static String? _$message(ConsoleMessage e) {
    return e.message;
  }

  static ConsoleMessageLevel? _$messageLevel(ConsoleMessage e) {
    return e.messageLevel;
  }
}

extension ConsoleMessageCompareE on ConsoleMessage {
  Map<String, dynamic> compareToConsoleMessage(ConsoleMessage other) {
    final Map<String, dynamic> diff = {};

    if (message != other.message) {
      diff['message'] = () => other.message;
    }

    if (messageLevel != other.messageLevel) {
      diff['messageLevel'] = () => other.messageLevel;
    }
    return diff;
  }
}
