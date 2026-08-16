// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'server_trust_auth_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ServerTrustAuthResponse {
  ServerTrustAuthResponse({ServerTrustAuthResponseAction? action})
    : this.action = action ?? ServerTrustAuthResponseAction.CANCEL;

  factory ServerTrustAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerTrustAuthResponseFromJson(json);

  @JsonKey(
    defaultValue: ServerTrustAuthResponseAction.CANCEL,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final ServerTrustAuthResponseAction? action;

  ServerTrustAuthResponse copyWith({ServerTrustAuthResponseAction? action}) {
    return ServerTrustAuthResponse(action: action ?? this.action);
  }

  ServerTrustAuthResponse copyWithServerTrustAuthResponse({
    ServerTrustAuthResponseAction? action,
  }) {
    return copyWith(action: action);
  }

  ServerTrustAuthResponse patchWithServerTrustAuthResponse([
    ServerTrustAuthResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? ServerTrustAuthResponsePatch();
    final _patchMap = _patcher.patchMap;
    return ServerTrustAuthResponse(
      action: _patchMap.containsKey(ServerTrustAuthResponse$.action)
          ? (_patchMap[ServerTrustAuthResponse$.action] is Function)
                ? _patchMap[ServerTrustAuthResponse$.action](this.action)
                : (_patchMap[ServerTrustAuthResponse$.action] is Patch)
                ? _patchMap[ServerTrustAuthResponse$.action].applyTo(
                    this.action,
                  )
                : _patchMap[ServerTrustAuthResponse$.action]
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServerTrustAuthResponse && action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(action, 0);
  }

  @override
  String toString() {
    return 'ServerTrustAuthResponse(' + 'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ServerTrustAuthResponseToJson(this);
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

extension ServerTrustAuthResponsePropertyHelpers on ServerTrustAuthResponse {
  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  ServerTrustAuthResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionCANCEL {
    return this.action == ServerTrustAuthResponseAction.CANCEL;
  }

  bool get isActionPROCEED {
    return this.action == ServerTrustAuthResponseAction.PROCEED;
  }
}

extension ServerTrustAuthResponseSerialization on ServerTrustAuthResponse {
  Map<String, dynamic> toJson() {
    return _$ServerTrustAuthResponseToJson(this);
  }
}

enum ServerTrustAuthResponse$ { action }

class ServerTrustAuthResponsePatch
    extends PatchBase<ServerTrustAuthResponse, ServerTrustAuthResponse$> {
  ServerTrustAuthResponse applyTo(ServerTrustAuthResponse entity) {
    return entity.patchWithServerTrustAuthResponse(this);
  }

  ServerTrustAuthResponsePatch withAction(
    ServerTrustAuthResponseAction? value,
  ) {
    patchMap[ServerTrustAuthResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [ServerTrustAuthResponse] query construction
abstract final class ServerTrustAuthResponseFields {
  static const action =
      Field<ServerTrustAuthResponse, ServerTrustAuthResponseAction?>(
        'action',
        _$action,
      );

  static ServerTrustAuthResponseAction? _$action(ServerTrustAuthResponse e) {
    return e.action;
  }
}

extension ServerTrustAuthResponseCompareE on ServerTrustAuthResponse {
  Map<String, dynamic> compareToServerTrustAuthResponse(
    ServerTrustAuthResponse other,
  ) {
    final Map<String, dynamic> diff = {};

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
