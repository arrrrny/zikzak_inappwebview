// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'login_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class LoginRequest {
  LoginRequest({
    required String this.realm,
    String? this.account,
    required String this.args,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  final String realm;

  final String? account;

  final String args;

  LoginRequest copyWith({String? realm, String? account, String? args}) {
    return LoginRequest(
      realm: realm ?? this.realm,
      account: account ?? this.account,
      args: args ?? this.args,
    );
  }

  LoginRequest copyWithLoginRequest({
    String? realm,
    String? account,
    String? args,
  }) {
    return copyWith(realm: realm, account: account, args: args);
  }

  LoginRequest patchWithLoginRequest([LoginRequestPatch? patchInput]) {
    final _patcher = patchInput ?? LoginRequestPatch();
    final _patchMap = _patcher.patchMap;
    return LoginRequest(
      realm: _patchMap.containsKey(LoginRequest$.realm)
          ? (_patchMap[LoginRequest$.realm] is Function)
                ? _patchMap[LoginRequest$.realm](this.realm)
                : (_patchMap[LoginRequest$.realm] is Patch)
                ? _patchMap[LoginRequest$.realm].applyTo(this.realm)
                : _patchMap[LoginRequest$.realm]
          : this.realm,
      account: _patchMap.containsKey(LoginRequest$.account)
          ? (_patchMap[LoginRequest$.account] is Function)
                ? _patchMap[LoginRequest$.account](this.account)
                : (_patchMap[LoginRequest$.account] is Patch)
                ? _patchMap[LoginRequest$.account].applyTo(this.account)
                : _patchMap[LoginRequest$.account]
          : this.account,
      args: _patchMap.containsKey(LoginRequest$.args)
          ? (_patchMap[LoginRequest$.args] is Function)
                ? _patchMap[LoginRequest$.args](this.args)
                : (_patchMap[LoginRequest$.args] is Patch)
                ? _patchMap[LoginRequest$.args].applyTo(this.args)
                : _patchMap[LoginRequest$.args]
          : this.args,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        realm == other.realm &&
        account == other.account &&
        args == other.args;
  }

  @override
  int get hashCode {
    return Object.hash(this.realm, this.account, this.args);
  }

  @override
  String toString() {
    return 'LoginRequest(' +
        'realm: ${realm}' +
        ', ' +
        'account: ${account}' +
        ', ' +
        'args: ${args})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$LoginRequestToJson(this);
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

extension LoginRequestPropertyHelpers on LoginRequest {
  bool get hasRealm {
    return this.realm.isNotEmpty;
  }

  bool get noRealm {
    return this.realm.isEmpty;
  }

  bool get hasAccount {
    return this.account?.isNotEmpty == true;
  }

  bool get noAccount {
    return this.account?.isEmpty ?? true;
  }

  String get accountRequired {
    return this.account ??
        (throw StateError('account is required but was null'));
  }

  bool get hasArgs {
    return this.args.isNotEmpty;
  }

  bool get noArgs {
    return this.args.isEmpty;
  }
}

extension LoginRequestSerialization on LoginRequest {
  Map<String, dynamic> toJson() {
    return _$LoginRequestToJson(this);
  }
}

enum LoginRequest$ { realm, account, args }

class LoginRequestPatch extends PatchBase<LoginRequest, LoginRequest$> {
  LoginRequest applyTo(LoginRequest entity) {
    return entity.patchWithLoginRequest(this);
  }

  LoginRequestPatch withRealm(String? value) {
    patchMap[LoginRequest$.realm] = value;
    return this;
  }

  LoginRequestPatch withAccount(String? value) {
    patchMap[LoginRequest$.account] = value;
    return this;
  }

  LoginRequestPatch withArgs(String? value) {
    patchMap[LoginRequest$.args] = value;
    return this;
  }
}

/// Field descriptors for [LoginRequest] query construction
abstract final class LoginRequestFields {
  static const realm = Field<LoginRequest, String>('realm', _$realm);

  static const account = Field<LoginRequest, String?>('account', _$account);

  static const args = Field<LoginRequest, String>('args', _$args);

  static String _$realm(LoginRequest e) {
    return e.realm;
  }

  static String? _$account(LoginRequest e) {
    return e.account;
  }

  static String _$args(LoginRequest e) {
    return e.args;
  }
}

extension LoginRequestCompareE on LoginRequest {
  Map<String, dynamic> compareToLoginRequest(LoginRequest other) {
    final Map<String, dynamic> diff = {};

    if (realm != other.realm) {
      diff['realm'] = () => other.realm;
    }

    if (account != other.account) {
      diff['account'] = () => other.account;
    }

    if (args != other.args) {
      diff['args'] = () => other.args;
    }
    return diff;
  }
}
