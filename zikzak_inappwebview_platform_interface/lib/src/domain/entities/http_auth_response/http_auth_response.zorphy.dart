// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'http_auth_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class HttpAuthResponse {
  HttpAuthResponse({
    String? username,
    String? password,
    bool? permanentPersistence,
    HttpAuthResponseAction? action,
  }) : this.username = username ?? "",
       this.password = password ?? "",
       this.permanentPersistence = permanentPersistence ?? false,
       this.action = action ?? HttpAuthResponseAction.CANCEL;

  factory HttpAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$HttpAuthResponseFromJson(json);

  @JsonKey(defaultValue: "")
  final String username;

  @JsonKey(defaultValue: "")
  final String password;

  @JsonKey(defaultValue: false)
  final bool permanentPersistence;

  @JsonKey(
    defaultValue: HttpAuthResponseAction.CANCEL,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final HttpAuthResponseAction? action;

  HttpAuthResponse copyWith({
    String? username,
    String? password,
    bool? permanentPersistence,
    HttpAuthResponseAction? action,
  }) {
    return HttpAuthResponse(
      username: username ?? this.username,
      password: password ?? this.password,
      permanentPersistence: permanentPersistence ?? this.permanentPersistence,
      action: action ?? this.action,
    );
  }

  HttpAuthResponse copyWithHttpAuthResponse({
    String? username,
    String? password,
    bool? permanentPersistence,
    HttpAuthResponseAction? action,
  }) {
    return copyWith(
      username: username,
      password: password,
      permanentPersistence: permanentPersistence,
      action: action,
    );
  }

  HttpAuthResponse patchWithHttpAuthResponse([
    HttpAuthResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? HttpAuthResponsePatch();
    final _patchMap = _patcher.patchMap;
    return HttpAuthResponse(
      username: _patchMap.containsKey(HttpAuthResponse$.username)
          ? ((_patchMap[HttpAuthResponse$.username] is Function)
                    ? _patchMap[HttpAuthResponse$.username](this.username)
                    : (_patchMap[HttpAuthResponse$.username] is Patch)
                    ? _patchMap[HttpAuthResponse$.username].applyTo(
                        this.username,
                      )
                    : _patchMap[HttpAuthResponse$.username])
                as String
          : this.username,
      password: _patchMap.containsKey(HttpAuthResponse$.password)
          ? ((_patchMap[HttpAuthResponse$.password] is Function)
                    ? _patchMap[HttpAuthResponse$.password](this.password)
                    : (_patchMap[HttpAuthResponse$.password] is Patch)
                    ? _patchMap[HttpAuthResponse$.password].applyTo(
                        this.password,
                      )
                    : _patchMap[HttpAuthResponse$.password])
                as String
          : this.password,
      permanentPersistence:
          _patchMap.containsKey(HttpAuthResponse$.permanentPersistence)
          ? ((_patchMap[HttpAuthResponse$.permanentPersistence] is Function)
                    ? _patchMap[HttpAuthResponse$.permanentPersistence](
                        this.permanentPersistence,
                      )
                    : (_patchMap[HttpAuthResponse$.permanentPersistence]
                          is Patch)
                    ? _patchMap[HttpAuthResponse$.permanentPersistence].applyTo(
                        this.permanentPersistence,
                      )
                    : _patchMap[HttpAuthResponse$.permanentPersistence])
                as bool
          : this.permanentPersistence,
      action: _patchMap.containsKey(HttpAuthResponse$.action)
          ? ((_patchMap[HttpAuthResponse$.action] is Function)
                    ? _patchMap[HttpAuthResponse$.action](this.action)
                    : (_patchMap[HttpAuthResponse$.action] is Patch)
                    ? _patchMap[HttpAuthResponse$.action].applyTo(this.action)
                    : _patchMap[HttpAuthResponse$.action])
                as HttpAuthResponseAction?
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HttpAuthResponse &&
        username == other.username &&
        password == other.password &&
        permanentPersistence == other.permanentPersistence &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.username,
      this.password,
      this.permanentPersistence,
      this.action,
    );
  }

  @override
  String toString() {
    return 'HttpAuthResponse(' +
        'username: ${username}' +
        ', ' +
        'password: ${password}' +
        ', ' +
        'permanentPersistence: ${permanentPersistence}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$HttpAuthResponseToJson(this);
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

extension HttpAuthResponsePropertyHelpers on HttpAuthResponse {
  bool get hasUsername {
    return this.username.isNotEmpty;
  }

  bool get noUsername {
    return this.username.isEmpty;
  }

  bool get hasPassword {
    return this.password.isNotEmpty;
  }

  bool get noPassword {
    return this.password.isEmpty;
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  HttpAuthResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionCANCEL {
    return this.action == HttpAuthResponseAction.CANCEL;
  }

  bool get isActionPROCEED {
    return this.action == HttpAuthResponseAction.PROCEED;
  }

  bool get isActionUSE_SAVED_HTTP_AUTH_CREDENTIALS {
    return this.action ==
        HttpAuthResponseAction.USE_SAVED_HTTP_AUTH_CREDENTIALS;
  }
}

extension HttpAuthResponseSerialization on HttpAuthResponse {
  Map<String, dynamic> toJson() {
    return _$HttpAuthResponseToJson(this);
  }
}

enum HttpAuthResponse$ { username, password, permanentPersistence, action }

class HttpAuthResponsePatch
    extends PatchBase<HttpAuthResponse, HttpAuthResponse$> {
  HttpAuthResponse applyTo(HttpAuthResponse entity) {
    return entity.patchWithHttpAuthResponse(this);
  }

  HttpAuthResponsePatch withUsername(String? value) {
    patchMap[HttpAuthResponse$.username] = value;
    return this;
  }

  HttpAuthResponsePatch withPassword(String? value) {
    patchMap[HttpAuthResponse$.password] = value;
    return this;
  }

  HttpAuthResponsePatch withPermanentPersistence(bool? value) {
    patchMap[HttpAuthResponse$.permanentPersistence] = value;
    return this;
  }

  HttpAuthResponsePatch withAction(HttpAuthResponseAction? value) {
    patchMap[HttpAuthResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [HttpAuthResponse] query construction
abstract final class HttpAuthResponseFields {
  static const username = Field<HttpAuthResponse, String>(
    'username',
    _$username,
  );

  static const password = Field<HttpAuthResponse, String>(
    'password',
    _$password,
  );

  static const permanentPersistence = Field<HttpAuthResponse, bool>(
    'permanentPersistence',
    _$permanentPersistence,
  );

  static const action = Field<HttpAuthResponse, HttpAuthResponseAction?>(
    'action',
    _$action,
  );

  static String _$username(HttpAuthResponse e) {
    return e.username;
  }

  static String _$password(HttpAuthResponse e) {
    return e.password;
  }

  static bool _$permanentPersistence(HttpAuthResponse e) {
    return e.permanentPersistence;
  }

  static HttpAuthResponseAction? _$action(HttpAuthResponse e) {
    return e.action;
  }
}

extension HttpAuthResponseCompareE on HttpAuthResponse {
  Map<String, dynamic> compareToHttpAuthResponse(HttpAuthResponse other) {
    final Map<String, dynamic> diff = {};

    if (username != other.username) {
      diff['username'] = () => other.username;
    }

    if (password != other.password) {
      diff['password'] = () => other.password;
    }

    if (permanentPersistence != other.permanentPersistence) {
      diff['permanentPersistence'] = () => other.permanentPersistence;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
