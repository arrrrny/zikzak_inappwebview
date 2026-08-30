// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'url_credential.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class URLCredential {
  URLCredential({
    String? this.username,
    String? this.password,
    List<X509Certificate>? this.certificates,
    URLCredentialPersistence? this.persistence,
  });

  factory URLCredential.fromJson(Map<String, dynamic> json) =>
      _$URLCredentialFromJson(json);

  final String? username;

  final String? password;

  @JsonKey(toJson: _certificatesToJson, fromJson: _certificatesFromJson)
  final List<X509Certificate>? certificates;

  @JsonKey(toJson: _persistenceToJson, fromJson: _persistenceFromJson)
  final URLCredentialPersistence? persistence;

  URLCredential copyWith({
    String? username,
    String? password,
    List<X509Certificate>? certificates,
    URLCredentialPersistence? persistence,
  }) {
    return URLCredential(
      username: username ?? this.username,
      password: password ?? this.password,
      certificates: certificates ?? this.certificates,
      persistence: persistence ?? this.persistence,
    );
  }

  URLCredential copyWithURLCredential({
    String? username,
    String? password,
    List<X509Certificate>? certificates,
    URLCredentialPersistence? persistence,
  }) {
    return copyWith(
      username: username,
      password: password,
      certificates: certificates,
      persistence: persistence,
    );
  }

  URLCredential patchWithURLCredential([URLCredentialPatch? patchInput]) {
    final _patcher = patchInput ?? URLCredentialPatch();
    final _patchMap = _patcher.patchMap;
    return URLCredential(
      username: _patchMap.containsKey(URLCredential$.username)
          ? ((_patchMap[URLCredential$.username] is Function)
                    ? _patchMap[URLCredential$.username](this.username)
                    : (_patchMap[URLCredential$.username] is Patch)
                    ? _patchMap[URLCredential$.username].applyTo(this.username)
                    : _patchMap[URLCredential$.username])
                as String?
          : this.username,
      password: _patchMap.containsKey(URLCredential$.password)
          ? ((_patchMap[URLCredential$.password] is Function)
                    ? _patchMap[URLCredential$.password](this.password)
                    : (_patchMap[URLCredential$.password] is Patch)
                    ? _patchMap[URLCredential$.password].applyTo(this.password)
                    : _patchMap[URLCredential$.password])
                as String?
          : this.password,
      certificates: _patchMap.containsKey(URLCredential$.certificates)
          ? ((_patchMap[URLCredential$.certificates] is Function)
                    ? _patchMap[URLCredential$.certificates](this.certificates)
                    : (_patchMap[URLCredential$.certificates] is Patch)
                    ? _patchMap[URLCredential$.certificates].applyTo(
                        this.certificates,
                      )
                    : _patchMap[URLCredential$.certificates])
                as List<X509Certificate>?
          : this.certificates,
      persistence: _patchMap.containsKey(URLCredential$.persistence)
          ? ((_patchMap[URLCredential$.persistence] is Function)
                    ? _patchMap[URLCredential$.persistence](this.persistence)
                    : (_patchMap[URLCredential$.persistence] is Patch)
                    ? _patchMap[URLCredential$.persistence].applyTo(
                        this.persistence,
                      )
                    : _patchMap[URLCredential$.persistence])
                as URLCredentialPersistence?
          : this.persistence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is URLCredential &&
        username == other.username &&
        password == other.password &&
        certificates == other.certificates &&
        persistence == other.persistence;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.username,
      this.password,
      this.certificates,
      this.persistence,
    );
  }

  @override
  String toString() {
    return 'URLCredential(' +
        'username: ${username}' +
        ', ' +
        'password: ${password}' +
        ', ' +
        'certificates: ${certificates}' +
        ', ' +
        'persistence: ${persistence})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$URLCredentialToJson(this);
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

extension URLCredentialPropertyHelpers on URLCredential {
  bool get hasUsername {
    return this.username?.isNotEmpty == true;
  }

  bool get noUsername {
    return this.username?.isEmpty ?? true;
  }

  String get usernameRequired {
    return this.username ??
        (throw StateError('username is required but was null'));
  }

  bool get hasPassword {
    return this.password?.isNotEmpty == true;
  }

  bool get noPassword {
    return this.password?.isEmpty ?? true;
  }

  String get passwordRequired {
    return this.password ??
        (throw StateError('password is required but was null'));
  }

  List<X509Certificate> get certificatesRequired {
    return this.certificates ??
        (throw StateError('certificates is required but was null'));
  }

  bool get hasCertificates {
    return this.certificates?.isNotEmpty ?? false;
  }

  bool get noCertificates {
    return this.certificates?.isEmpty ?? true;
  }

  bool get hasPersistence {
    return this.persistence != null;
  }

  bool get noPersistence {
    return this.persistence == null;
  }

  URLCredentialPersistence get persistenceRequired {
    return this.persistence ??
        (throw StateError('persistence is required but was null'));
  }

  bool get isPersistenceNONE {
    return this.persistence == URLCredentialPersistence.NONE;
  }

  bool get isPersistenceFOR_SESSION {
    return this.persistence == URLCredentialPersistence.FOR_SESSION;
  }

  bool get isPersistencePERMANENT {
    return this.persistence == URLCredentialPersistence.PERMANENT;
  }

  bool get isPersistenceSYNCHRONIZABLE {
    return this.persistence == URLCredentialPersistence.SYNCHRONIZABLE;
  }
}

extension URLCredentialSerialization on URLCredential {
  Map<String, dynamic> toJson() {
    return _$URLCredentialToJson(this);
  }
}

enum URLCredential$ { username, password, certificates, persistence }

class URLCredentialPatch extends PatchBase<URLCredential, URLCredential$> {
  URLCredential applyTo(URLCredential entity) {
    return entity.patchWithURLCredential(this);
  }

  URLCredentialPatch withUsername(String? value) {
    patchMap[URLCredential$.username] = value;
    return this;
  }

  URLCredentialPatch withPassword(String? value) {
    patchMap[URLCredential$.password] = value;
    return this;
  }

  URLCredentialPatch withCertificates(List<X509Certificate>? value) {
    patchMap[URLCredential$.certificates] = value;
    return this;
  }

  URLCredentialPatch withPersistence(URLCredentialPersistence? value) {
    patchMap[URLCredential$.persistence] = value;
    return this;
  }
}

/// Field descriptors for [URLCredential] query construction
abstract final class URLCredentialFields {
  static const username = Field<URLCredential, String?>('username', _$username);

  static const password = Field<URLCredential, String?>('password', _$password);

  static const certificates = Field<URLCredential, List<X509Certificate>?>(
    'certificates',
    _$certificates,
  );

  static const persistence = Field<URLCredential, URLCredentialPersistence?>(
    'persistence',
    _$persistence,
  );

  static String? _$username(URLCredential e) {
    return e.username;
  }

  static String? _$password(URLCredential e) {
    return e.password;
  }

  static List<X509Certificate>? _$certificates(URLCredential e) {
    return e.certificates;
  }

  static URLCredentialPersistence? _$persistence(URLCredential e) {
    return e.persistence;
  }
}

extension URLCredentialCompareE on URLCredential {
  Map<String, dynamic> compareToURLCredential(URLCredential other) {
    final Map<String, dynamic> diff = {};

    if (username != other.username) {
      diff['username'] = () => other.username;
    }

    if (password != other.password) {
      diff['password'] = () => other.password;
    }

    if (certificates != other.certificates) {
      diff['certificates'] = () => other.certificates;
    }

    if (persistence != other.persistence) {
      diff['persistence'] = () => other.persistence;
    }
    return diff;
  }
}
