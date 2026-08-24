// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'url_protection_space.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class URLProtectionSpace {
  URLProtectionSpace({
    required String this.host,
    String? this.protocol,
    String? this.realm,
    int? this.port,
    SslCertificate? this.sslCertificate,
    SslError? this.sslError,
    URLProtectionSpaceAuthenticationMethod? this.authenticationMethod,
    List<X509Certificate>? this.distinguishedNames,
    URLProtectionSpaceProxyType? this.proxyType,
    bool? this.receivesCredentialSecurely,
  });

  factory URLProtectionSpace.fromJson(Map<String, dynamic> json) =>
      _$URLProtectionSpaceFromJson(json);

  final String host;

  final String? protocol;

  final String? realm;

  final int? port;

  @JsonKey(toJson: _sslCertificateToJson, fromJson: _sslCertificateFromJson)
  final SslCertificate? sslCertificate;

  @JsonKey(toJson: _sslErrorToJson, fromJson: _sslErrorFromJson)
  final SslError? sslError;

  @JsonKey(
    toJson: _authenticationMethodToJson,
    fromJson: _authenticationMethodFromJson,
  )
  final URLProtectionSpaceAuthenticationMethod? authenticationMethod;

  @JsonKey(
    toJson: _distinguishedNamesToJson,
    fromJson: _distinguishedNamesFromJson,
  )
  final List<X509Certificate>? distinguishedNames;

  @JsonKey(toJson: _proxyTypeToJson, fromJson: _proxyTypeFromJson)
  final URLProtectionSpaceProxyType? proxyType;

  final bool? receivesCredentialSecurely;

  URLProtectionSpace copyWith({
    String? host,
    String? protocol,
    String? realm,
    int? port,
    SslCertificate? sslCertificate,
    SslError? sslError,
    URLProtectionSpaceAuthenticationMethod? authenticationMethod,
    List<X509Certificate>? distinguishedNames,
    URLProtectionSpaceProxyType? proxyType,
    bool? receivesCredentialSecurely,
  }) {
    return URLProtectionSpace(
      host: host ?? this.host,
      protocol: protocol ?? this.protocol,
      realm: realm ?? this.realm,
      port: port ?? this.port,
      sslCertificate: sslCertificate ?? this.sslCertificate,
      sslError: sslError ?? this.sslError,
      authenticationMethod: authenticationMethod ?? this.authenticationMethod,
      distinguishedNames: distinguishedNames ?? this.distinguishedNames,
      proxyType: proxyType ?? this.proxyType,
      receivesCredentialSecurely:
          receivesCredentialSecurely ?? this.receivesCredentialSecurely,
    );
  }

  URLProtectionSpace copyWithURLProtectionSpace({
    String? host,
    String? protocol,
    String? realm,
    int? port,
    SslCertificate? sslCertificate,
    SslError? sslError,
    URLProtectionSpaceAuthenticationMethod? authenticationMethod,
    List<X509Certificate>? distinguishedNames,
    URLProtectionSpaceProxyType? proxyType,
    bool? receivesCredentialSecurely,
  }) {
    return copyWith(
      host: host,
      protocol: protocol,
      realm: realm,
      port: port,
      sslCertificate: sslCertificate,
      sslError: sslError,
      authenticationMethod: authenticationMethod,
      distinguishedNames: distinguishedNames,
      proxyType: proxyType,
      receivesCredentialSecurely: receivesCredentialSecurely,
    );
  }

  URLProtectionSpace patchWithURLProtectionSpace([
    URLProtectionSpacePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? URLProtectionSpacePatch();
    final _patchMap = _patcher.patchMap;
    return URLProtectionSpace(
      host: _patchMap.containsKey(URLProtectionSpace$.host)
          ? ((_patchMap[URLProtectionSpace$.host] is Function)
                    ? _patchMap[URLProtectionSpace$.host](this.host)
                    : (_patchMap[URLProtectionSpace$.host] is Patch)
                    ? _patchMap[URLProtectionSpace$.host].applyTo(this.host)
                    : _patchMap[URLProtectionSpace$.host])
                as String
          : this.host,
      protocol: _patchMap.containsKey(URLProtectionSpace$.protocol)
          ? ((_patchMap[URLProtectionSpace$.protocol] is Function)
                    ? _patchMap[URLProtectionSpace$.protocol](this.protocol)
                    : (_patchMap[URLProtectionSpace$.protocol] is Patch)
                    ? _patchMap[URLProtectionSpace$.protocol].applyTo(
                        this.protocol,
                      )
                    : _patchMap[URLProtectionSpace$.protocol])
                as String?
          : this.protocol,
      realm: _patchMap.containsKey(URLProtectionSpace$.realm)
          ? ((_patchMap[URLProtectionSpace$.realm] is Function)
                    ? _patchMap[URLProtectionSpace$.realm](this.realm)
                    : (_patchMap[URLProtectionSpace$.realm] is Patch)
                    ? _patchMap[URLProtectionSpace$.realm].applyTo(this.realm)
                    : _patchMap[URLProtectionSpace$.realm])
                as String?
          : this.realm,
      port: _patchMap.containsKey(URLProtectionSpace$.port)
          ? ((_patchMap[URLProtectionSpace$.port] is Function)
                    ? _patchMap[URLProtectionSpace$.port](this.port)
                    : (_patchMap[URLProtectionSpace$.port] is Patch)
                    ? _patchMap[URLProtectionSpace$.port].applyTo(this.port)
                    : _patchMap[URLProtectionSpace$.port])
                as int?
          : this.port,
      sslCertificate: _patchMap.containsKey(URLProtectionSpace$.sslCertificate)
          ? ((_patchMap[URLProtectionSpace$.sslCertificate] is Function)
                    ? _patchMap[URLProtectionSpace$.sslCertificate](
                        this.sslCertificate,
                      )
                    : (_patchMap[URLProtectionSpace$.sslCertificate] is Patch)
                    ? _patchMap[URLProtectionSpace$.sslCertificate].applyTo(
                        this.sslCertificate,
                      )
                    : _patchMap[URLProtectionSpace$.sslCertificate])
                as SslCertificate?
          : this.sslCertificate,
      sslError: _patchMap.containsKey(URLProtectionSpace$.sslError)
          ? ((_patchMap[URLProtectionSpace$.sslError] is Function)
                    ? _patchMap[URLProtectionSpace$.sslError](this.sslError)
                    : (_patchMap[URLProtectionSpace$.sslError] is Patch)
                    ? _patchMap[URLProtectionSpace$.sslError].applyTo(
                        this.sslError,
                      )
                    : _patchMap[URLProtectionSpace$.sslError])
                as SslError?
          : this.sslError,
      authenticationMethod:
          _patchMap.containsKey(URLProtectionSpace$.authenticationMethod)
          ? ((_patchMap[URLProtectionSpace$.authenticationMethod] is Function)
                    ? _patchMap[URLProtectionSpace$.authenticationMethod](
                        this.authenticationMethod,
                      )
                    : (_patchMap[URLProtectionSpace$.authenticationMethod]
                          is Patch)
                    ? _patchMap[URLProtectionSpace$.authenticationMethod]
                          .applyTo(this.authenticationMethod)
                    : _patchMap[URLProtectionSpace$.authenticationMethod])
                as URLProtectionSpaceAuthenticationMethod?
          : this.authenticationMethod,
      distinguishedNames:
          _patchMap.containsKey(URLProtectionSpace$.distinguishedNames)
          ? ((_patchMap[URLProtectionSpace$.distinguishedNames] is Function)
                    ? _patchMap[URLProtectionSpace$.distinguishedNames](
                        this.distinguishedNames,
                      )
                    : (_patchMap[URLProtectionSpace$.distinguishedNames]
                          is Patch)
                    ? _patchMap[URLProtectionSpace$.distinguishedNames].applyTo(
                        this.distinguishedNames,
                      )
                    : _patchMap[URLProtectionSpace$.distinguishedNames])
                as List<X509Certificate>?
          : this.distinguishedNames,
      proxyType: _patchMap.containsKey(URLProtectionSpace$.proxyType)
          ? ((_patchMap[URLProtectionSpace$.proxyType] is Function)
                    ? _patchMap[URLProtectionSpace$.proxyType](this.proxyType)
                    : (_patchMap[URLProtectionSpace$.proxyType] is Patch)
                    ? _patchMap[URLProtectionSpace$.proxyType].applyTo(
                        this.proxyType,
                      )
                    : _patchMap[URLProtectionSpace$.proxyType])
                as URLProtectionSpaceProxyType?
          : this.proxyType,
      receivesCredentialSecurely:
          _patchMap.containsKey(URLProtectionSpace$.receivesCredentialSecurely)
          ? ((_patchMap[URLProtectionSpace$.receivesCredentialSecurely]
                        is Function)
                    ? _patchMap[URLProtectionSpace$.receivesCredentialSecurely](
                        this.receivesCredentialSecurely,
                      )
                    : (_patchMap[URLProtectionSpace$.receivesCredentialSecurely]
                          is Patch)
                    ? _patchMap[URLProtectionSpace$.receivesCredentialSecurely]
                          .applyTo(this.receivesCredentialSecurely)
                    : _patchMap[URLProtectionSpace$.receivesCredentialSecurely])
                as bool?
          : this.receivesCredentialSecurely,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is URLProtectionSpace &&
        host == other.host &&
        protocol == other.protocol &&
        realm == other.realm &&
        port == other.port &&
        sslCertificate == other.sslCertificate &&
        sslError == other.sslError &&
        authenticationMethod == other.authenticationMethod &&
        distinguishedNames == other.distinguishedNames &&
        proxyType == other.proxyType &&
        receivesCredentialSecurely == other.receivesCredentialSecurely;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.host,
      this.protocol,
      this.realm,
      this.port,
      this.sslCertificate,
      this.sslError,
      this.authenticationMethod,
      this.distinguishedNames,
      this.proxyType,
      this.receivesCredentialSecurely,
    );
  }

  @override
  String toString() {
    return 'URLProtectionSpace(' +
        'host: ${host}' +
        ', ' +
        'protocol: ${protocol}' +
        ', ' +
        'realm: ${realm}' +
        ', ' +
        'port: ${port}' +
        ', ' +
        'sslCertificate: ${sslCertificate}' +
        ', ' +
        'sslError: ${sslError}' +
        ', ' +
        'authenticationMethod: ${authenticationMethod}' +
        ', ' +
        'distinguishedNames: ${distinguishedNames}' +
        ', ' +
        'proxyType: ${proxyType}' +
        ', ' +
        'receivesCredentialSecurely: ${receivesCredentialSecurely})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$URLProtectionSpaceToJson(this);
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

extension URLProtectionSpacePropertyHelpers on URLProtectionSpace {
  bool get hasHost {
    return this.host.isNotEmpty;
  }

  bool get noHost {
    return this.host.isEmpty;
  }

  bool get hasProtocol {
    return this.protocol?.isNotEmpty == true;
  }

  bool get noProtocol {
    return this.protocol?.isEmpty ?? true;
  }

  String get protocolRequired {
    return this.protocol ??
        (throw StateError('protocol is required but was null'));
  }

  bool get hasRealm {
    return this.realm?.isNotEmpty == true;
  }

  bool get noRealm {
    return this.realm?.isEmpty ?? true;
  }

  String get realmRequired {
    return this.realm ?? (throw StateError('realm is required but was null'));
  }

  bool get hasPort {
    return this.port != null;
  }

  bool get noPort {
    return this.port == null;
  }

  int get portRequired {
    return this.port ?? (throw StateError('port is required but was null'));
  }

  bool get hasSslCertificate {
    return this.sslCertificate != null;
  }

  bool get noSslCertificate {
    return this.sslCertificate == null;
  }

  SslCertificate get sslCertificateRequired {
    return this.sslCertificate ??
        (throw StateError('sslCertificate is required but was null'));
  }

  bool get hasSslError {
    return this.sslError != null;
  }

  bool get noSslError {
    return this.sslError == null;
  }

  SslError get sslErrorRequired {
    return this.sslError ??
        (throw StateError('sslError is required but was null'));
  }

  bool get hasAuthenticationMethod {
    return this.authenticationMethod != null;
  }

  bool get noAuthenticationMethod {
    return this.authenticationMethod == null;
  }

  URLProtectionSpaceAuthenticationMethod get authenticationMethodRequired {
    return this.authenticationMethod ??
        (throw StateError('authenticationMethod is required but was null'));
  }

  bool
  get isAuthenticationMethodNSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE {
    return this.authenticationMethod ==
        URLProtectionSpaceAuthenticationMethod
            .NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE;
  }

  bool get isAuthenticationMethodNSURL_AUTHENTICATION_METHOD_NEGOTIATE {
    return this.authenticationMethod ==
        URLProtectionSpaceAuthenticationMethod
            .NSURL_AUTHENTICATION_METHOD_NEGOTIATE;
  }

  bool get isAuthenticationMethodNSURL_AUTHENTICATION_METHOD_NTLM {
    return this.authenticationMethod ==
        URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_NTLM;
  }

  bool get isAuthenticationMethodNSURL_AUTHENTICATION_METHOD_SERVER_TRUST {
    return this.authenticationMethod ==
        URLProtectionSpaceAuthenticationMethod
            .NSURL_AUTHENTICATION_METHOD_SERVER_TRUST;
  }

  List<X509Certificate> get distinguishedNamesRequired {
    return this.distinguishedNames ??
        (throw StateError('distinguishedNames is required but was null'));
  }

  bool get hasDistinguishedNames {
    return this.distinguishedNames?.isNotEmpty ?? false;
  }

  bool get noDistinguishedNames {
    return this.distinguishedNames?.isEmpty ?? true;
  }

  bool get hasProxyType {
    return this.proxyType != null;
  }

  bool get noProxyType {
    return this.proxyType == null;
  }

  URLProtectionSpaceProxyType get proxyTypeRequired {
    return this.proxyType ??
        (throw StateError('proxyType is required but was null'));
  }

  bool get isProxyTypeURL_PROTECTION_SPACE_HTTP_PROXY {
    return this.proxyType ==
        URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTP_PROXY;
  }

  bool get isProxyTypeURL_PROTECTION_SPACE_HTTPS_PROXY {
    return this.proxyType ==
        URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTPS_PROXY;
  }

  bool get isProxyTypeURL_PROTECTION_SPACE_FTP_PROXY {
    return this.proxyType ==
        URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_FTP_PROXY;
  }

  bool get isProxyTypeURL_PROTECTION_SPACE_SOCKS_PROXY {
    return this.proxyType ==
        URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_SOCKS_PROXY;
  }

  bool get hasReceivesCredentialSecurely {
    return this.receivesCredentialSecurely != null;
  }

  bool get noReceivesCredentialSecurely {
    return this.receivesCredentialSecurely == null;
  }

  bool get receivesCredentialSecurelyRequired {
    return this.receivesCredentialSecurely ??
        (throw StateError(
          'receivesCredentialSecurely is required but was null',
        ));
  }
}

extension URLProtectionSpaceSerialization on URLProtectionSpace {
  Map<String, dynamic> toJson() {
    return _$URLProtectionSpaceToJson(this);
  }
}

enum URLProtectionSpace$ {
  host,
  protocol,
  realm,
  port,
  sslCertificate,
  sslError,
  authenticationMethod,
  distinguishedNames,
  proxyType,
  receivesCredentialSecurely,
}

class URLProtectionSpacePatch
    extends PatchBase<URLProtectionSpace, URLProtectionSpace$> {
  URLProtectionSpace applyTo(URLProtectionSpace entity) {
    return entity.patchWithURLProtectionSpace(this);
  }

  URLProtectionSpacePatch withHost(String? value) {
    patchMap[URLProtectionSpace$.host] = value;
    return this;
  }

  URLProtectionSpacePatch withProtocol(String? value) {
    patchMap[URLProtectionSpace$.protocol] = value;
    return this;
  }

  URLProtectionSpacePatch withRealm(String? value) {
    patchMap[URLProtectionSpace$.realm] = value;
    return this;
  }

  URLProtectionSpacePatch withPort(int? value) {
    patchMap[URLProtectionSpace$.port] = value;
    return this;
  }

  URLProtectionSpacePatch withSslCertificate(SslCertificate? value) {
    patchMap[URLProtectionSpace$.sslCertificate] = value;
    return this;
  }

  URLProtectionSpacePatch withSslError(SslError? value) {
    patchMap[URLProtectionSpace$.sslError] = value;
    return this;
  }

  URLProtectionSpacePatch withSslErrorPatch(SslErrorPatch patch) {
    patchMap[URLProtectionSpace$.sslError] = patch;
    return this;
  }

  URLProtectionSpacePatch withSslErrorPatchFunc(
    SslErrorPatch Function(SslErrorPatch) patch,
  ) {
    patchMap[URLProtectionSpace$.sslError] = (dynamic current) {
      var currentPatch = SslErrorPatch();
      return patch(currentPatch).applyTo(current as SslError);
    };
    return this;
  }

  URLProtectionSpacePatch withAuthenticationMethod(
    URLProtectionSpaceAuthenticationMethod? value,
  ) {
    patchMap[URLProtectionSpace$.authenticationMethod] = value;
    return this;
  }

  URLProtectionSpacePatch withDistinguishedNames(List<X509Certificate>? value) {
    patchMap[URLProtectionSpace$.distinguishedNames] = value;
    return this;
  }

  URLProtectionSpacePatch withProxyType(URLProtectionSpaceProxyType? value) {
    patchMap[URLProtectionSpace$.proxyType] = value;
    return this;
  }

  URLProtectionSpacePatch withReceivesCredentialSecurely(bool? value) {
    patchMap[URLProtectionSpace$.receivesCredentialSecurely] = value;
    return this;
  }
}

/// Field descriptors for [URLProtectionSpace] query construction
abstract final class URLProtectionSpaceFields {
  static const host = Field<URLProtectionSpace, String>('host', _$host);

  static const protocol = Field<URLProtectionSpace, String?>(
    'protocol',
    _$protocol,
  );

  static const realm = Field<URLProtectionSpace, String?>('realm', _$realm);

  static const port = Field<URLProtectionSpace, int?>('port', _$port);

  static const sslCertificate = Field<URLProtectionSpace, SslCertificate?>(
    'sslCertificate',
    _$sslCertificate,
  );

  static const sslError = Field<URLProtectionSpace, SslError?>(
    'sslError',
    _$sslError,
  );

  static const authenticationMethod =
      Field<URLProtectionSpace, URLProtectionSpaceAuthenticationMethod?>(
        'authenticationMethod',
        _$authenticationMethod,
      );

  static const distinguishedNames =
      Field<URLProtectionSpace, List<X509Certificate>?>(
        'distinguishedNames',
        _$distinguishedNames,
      );

  static const proxyType =
      Field<URLProtectionSpace, URLProtectionSpaceProxyType?>(
        'proxyType',
        _$proxyType,
      );

  static const receivesCredentialSecurely = Field<URLProtectionSpace, bool?>(
    'receivesCredentialSecurely',
    _$receivesCredentialSecurely,
  );

  static String _$host(URLProtectionSpace e) {
    return e.host;
  }

  static String? _$protocol(URLProtectionSpace e) {
    return e.protocol;
  }

  static String? _$realm(URLProtectionSpace e) {
    return e.realm;
  }

  static int? _$port(URLProtectionSpace e) {
    return e.port;
  }

  static SslCertificate? _$sslCertificate(URLProtectionSpace e) {
    return e.sslCertificate;
  }

  static SslError? _$sslError(URLProtectionSpace e) {
    return e.sslError;
  }

  static URLProtectionSpaceAuthenticationMethod? _$authenticationMethod(
    URLProtectionSpace e,
  ) {
    return e.authenticationMethod;
  }

  static List<X509Certificate>? _$distinguishedNames(URLProtectionSpace e) {
    return e.distinguishedNames;
  }

  static URLProtectionSpaceProxyType? _$proxyType(URLProtectionSpace e) {
    return e.proxyType;
  }

  static bool? _$receivesCredentialSecurely(URLProtectionSpace e) {
    return e.receivesCredentialSecurely;
  }
}

extension URLProtectionSpaceCompareE on URLProtectionSpace {
  Map<String, dynamic> compareToURLProtectionSpace(URLProtectionSpace other) {
    final Map<String, dynamic> diff = {};

    if (host != other.host) {
      diff['host'] = () => other.host;
    }

    if (protocol != other.protocol) {
      diff['protocol'] = () => other.protocol;
    }

    if (realm != other.realm) {
      diff['realm'] = () => other.realm;
    }

    if (port != other.port) {
      diff['port'] = () => other.port;
    }

    if (sslCertificate != other.sslCertificate) {
      diff['sslCertificate'] = () => other.sslCertificate;
    }

    if (sslError != other.sslError) {
      diff['sslError'] = () => other.sslError;
    }

    if (authenticationMethod != other.authenticationMethod) {
      diff['authenticationMethod'] = () => other.authenticationMethod;
    }

    if (distinguishedNames != other.distinguishedNames) {
      diff['distinguishedNames'] = () => other.distinguishedNames;
    }

    if (proxyType != other.proxyType) {
      diff['proxyType'] = () => other.proxyType;
    }

    if (receivesCredentialSecurely != other.receivesCredentialSecurely) {
      diff['receivesCredentialSecurely'] = () =>
          other.receivesCredentialSecurely;
    }
    return diff;
  }
}
