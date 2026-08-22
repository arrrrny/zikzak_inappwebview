// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'url_protection_space_http_auth_credentials.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class URLProtectionSpaceHttpAuthCredentials {
  URLProtectionSpaceHttpAuthCredentials({
    URLProtectionSpace? this.protectionSpace,
    List<URLCredential>? this.credentials,
  });

  factory URLProtectionSpaceHttpAuthCredentials.fromJson(
    Map<String, dynamic> json,
  ) => _$URLProtectionSpaceHttpAuthCredentialsFromJson(json);

  @JsonKey(toJson: _protectionSpaceToJson, fromJson: _protectionSpaceFromJson)
  final URLProtectionSpace? protectionSpace;

  @JsonKey(toJson: _credentialsToJson, fromJson: _credentialsFromJson)
  final List<URLCredential>? credentials;

  URLProtectionSpaceHttpAuthCredentials copyWith({
    URLProtectionSpace? protectionSpace,
    List<URLCredential>? credentials,
  }) {
    return URLProtectionSpaceHttpAuthCredentials(
      protectionSpace: protectionSpace ?? this.protectionSpace,
      credentials: credentials ?? this.credentials,
    );
  }

  URLProtectionSpaceHttpAuthCredentials
  copyWithURLProtectionSpaceHttpAuthCredentials({
    URLProtectionSpace? protectionSpace,
    List<URLCredential>? credentials,
  }) {
    return copyWith(protectionSpace: protectionSpace, credentials: credentials);
  }

  URLProtectionSpaceHttpAuthCredentials
  patchWithURLProtectionSpaceHttpAuthCredentials([
    URLProtectionSpaceHttpAuthCredentialsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? URLProtectionSpaceHttpAuthCredentialsPatch();
    final _patchMap = _patcher.patchMap;
    return URLProtectionSpaceHttpAuthCredentials(
      protectionSpace:
          _patchMap.containsKey(
            URLProtectionSpaceHttpAuthCredentials$.protectionSpace,
          )
          ? (_patchMap[URLProtectionSpaceHttpAuthCredentials$.protectionSpace]
                    is Function)
                ? _patchMap[URLProtectionSpaceHttpAuthCredentials$
                      .protectionSpace](this.protectionSpace)
                : (_patchMap[URLProtectionSpaceHttpAuthCredentials$
                          .protectionSpace]
                      is Patch)
                ? _patchMap[URLProtectionSpaceHttpAuthCredentials$
                          .protectionSpace]
                      .applyTo(this.protectionSpace)
                : _patchMap[URLProtectionSpaceHttpAuthCredentials$
                      .protectionSpace]
          : this.protectionSpace,
      credentials:
          _patchMap.containsKey(
            URLProtectionSpaceHttpAuthCredentials$.credentials,
          )
          ? (_patchMap[URLProtectionSpaceHttpAuthCredentials$.credentials]
                    is Function)
                ? _patchMap[URLProtectionSpaceHttpAuthCredentials$.credentials](
                    this.credentials,
                  )
                : (_patchMap[URLProtectionSpaceHttpAuthCredentials$.credentials]
                      is Patch)
                ? _patchMap[URLProtectionSpaceHttpAuthCredentials$.credentials]
                      .applyTo(this.credentials)
                : _patchMap[URLProtectionSpaceHttpAuthCredentials$.credentials]
          : this.credentials,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is URLProtectionSpaceHttpAuthCredentials &&
        protectionSpace == other.protectionSpace &&
        credentials == other.credentials;
  }

  @override
  int get hashCode {
    return Object.hash(this.protectionSpace, this.credentials);
  }

  @override
  String toString() {
    return 'URLProtectionSpaceHttpAuthCredentials(' +
        'protectionSpace: ${protectionSpace}' +
        ', ' +
        'credentials: ${credentials})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data =
        _$URLProtectionSpaceHttpAuthCredentialsToJson(this);
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

extension URLProtectionSpaceHttpAuthCredentialsPropertyHelpers
    on URLProtectionSpaceHttpAuthCredentials {
  bool get hasProtectionSpace {
    return this.protectionSpace != null;
  }

  bool get noProtectionSpace {
    return this.protectionSpace == null;
  }

  URLProtectionSpace get protectionSpaceRequired {
    return this.protectionSpace ??
        (throw StateError('protectionSpace is required but was null'));
  }

  List<URLCredential> get credentialsRequired {
    return this.credentials ??
        (throw StateError('credentials is required but was null'));
  }

  bool get hasCredentials {
    return this.credentials?.isNotEmpty ?? false;
  }

  bool get noCredentials {
    return this.credentials?.isEmpty ?? true;
  }
}

extension URLProtectionSpaceHttpAuthCredentialsSerialization
    on URLProtectionSpaceHttpAuthCredentials {
  Map<String, dynamic> toJson() {
    return _$URLProtectionSpaceHttpAuthCredentialsToJson(this);
  }
}

enum URLProtectionSpaceHttpAuthCredentials$ { protectionSpace, credentials }

class URLProtectionSpaceHttpAuthCredentialsPatch
    extends
        PatchBase<
          URLProtectionSpaceHttpAuthCredentials,
          URLProtectionSpaceHttpAuthCredentials$
        > {
  URLProtectionSpaceHttpAuthCredentials applyTo(
    URLProtectionSpaceHttpAuthCredentials entity,
  ) {
    return entity.patchWithURLProtectionSpaceHttpAuthCredentials(this);
  }

  URLProtectionSpaceHttpAuthCredentialsPatch withProtectionSpace(
    URLProtectionSpace? value,
  ) {
    patchMap[URLProtectionSpaceHttpAuthCredentials$.protectionSpace] = value;
    return this;
  }

  URLProtectionSpaceHttpAuthCredentialsPatch withProtectionSpacePatch(
    URLProtectionSpacePatch patch,
  ) {
    patchMap[URLProtectionSpaceHttpAuthCredentials$.protectionSpace] = patch;
    return this;
  }

  URLProtectionSpaceHttpAuthCredentialsPatch withProtectionSpacePatchFunc(
    URLProtectionSpacePatch Function(URLProtectionSpacePatch) patch,
  ) {
    patchMap[URLProtectionSpaceHttpAuthCredentials$.protectionSpace] =
        (dynamic current) {
          var currentPatch = URLProtectionSpacePatch();
          return patch(currentPatch).applyTo(current as URLProtectionSpace);
        };
    return this;
  }

  URLProtectionSpaceHttpAuthCredentialsPatch withCredentials(
    List<URLCredential>? value,
  ) {
    patchMap[URLProtectionSpaceHttpAuthCredentials$.credentials] = value;
    return this;
  }

  URLProtectionSpaceHttpAuthCredentialsPatch updateCredentialsAt(
    int index,
    URLCredentialPatch Function(URLCredentialPatch) patch,
  ) {
    patchMap[URLProtectionSpaceHttpAuthCredentials$.credentials] =
        (List<dynamic> list) {
          var updatedList = List<URLCredential>.from(list);
          if (index >= 0 && index < updatedList.length) {
            updatedList[index] = patch(
              URLCredentialPatch(),
            ).applyTo(updatedList[index] as URLCredential);
          }
          return updatedList;
        };
    return this;
  }
}

/// Field descriptors for [URLProtectionSpaceHttpAuthCredentials] query construction
abstract final class URLProtectionSpaceHttpAuthCredentialsFields {
  static const protectionSpace =
      Field<URLProtectionSpaceHttpAuthCredentials, URLProtectionSpace?>(
        'protectionSpace',
        _$protectionSpace,
      );

  static const credentials =
      Field<URLProtectionSpaceHttpAuthCredentials, List<URLCredential>?>(
        'credentials',
        _$credentials,
      );

  static URLProtectionSpace? _$protectionSpace(
    URLProtectionSpaceHttpAuthCredentials e,
  ) {
    return e.protectionSpace;
  }

  static List<URLCredential>? _$credentials(
    URLProtectionSpaceHttpAuthCredentials e,
  ) {
    return e.credentials;
  }
}

extension URLProtectionSpaceHttpAuthCredentialsCompareE
    on URLProtectionSpaceHttpAuthCredentials {
  Map<String, dynamic> compareToURLProtectionSpaceHttpAuthCredentials(
    URLProtectionSpaceHttpAuthCredentials other,
  ) {
    final Map<String, dynamic> diff = {};

    if (protectionSpace != other.protectionSpace) {
      diff['protectionSpace'] = () => other.protectionSpace;
    }

    if (credentials != other.credentials) {
      diff['credentials'] = () => other.credentials;
    }
    return diff;
  }
}
