// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'client_cert_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ClientCertResponse {
  ClientCertResponse({
    required String this.certificatePath,
    String? certificatePassword,
    String? keyStoreType,
    ClientCertResponseAction? action,
  }) : this.certificatePassword = certificatePassword ?? "",
       this.keyStoreType = keyStoreType ?? "PKCS12",
       this.action = action ?? ClientCertResponseAction.CANCEL;

  factory ClientCertResponse.fromJson(Map<String, dynamic> json) =>
      _$ClientCertResponseFromJson(json);

  final String certificatePath;

  @JsonKey(defaultValue: "")
  final String? certificatePassword;

  @JsonKey(defaultValue: "PKCS12")
  final String? keyStoreType;

  @JsonKey(
    defaultValue: ClientCertResponseAction.CANCEL,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final ClientCertResponseAction? action;

  ClientCertResponse copyWith({
    String? certificatePath,
    String? certificatePassword,
    String? keyStoreType,
    ClientCertResponseAction? action,
  }) {
    return ClientCertResponse(
      certificatePath: certificatePath ?? this.certificatePath,
      certificatePassword: certificatePassword ?? this.certificatePassword,
      keyStoreType: keyStoreType ?? this.keyStoreType,
      action: action ?? this.action,
    );
  }

  ClientCertResponse copyWithClientCertResponse({
    String? certificatePath,
    String? certificatePassword,
    String? keyStoreType,
    ClientCertResponseAction? action,
  }) {
    return copyWith(
      certificatePath: certificatePath,
      certificatePassword: certificatePassword,
      keyStoreType: keyStoreType,
      action: action,
    );
  }

  ClientCertResponse patchWithClientCertResponse([
    ClientCertResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? ClientCertResponsePatch();
    final _patchMap = _patcher.patchMap;
    return ClientCertResponse(
      certificatePath:
          _patchMap.containsKey(ClientCertResponse$.certificatePath)
          ? ((_patchMap[ClientCertResponse$.certificatePath] is Function)
                    ? _patchMap[ClientCertResponse$.certificatePath](
                        this.certificatePath,
                      )
                    : (_patchMap[ClientCertResponse$.certificatePath] is Patch)
                    ? _patchMap[ClientCertResponse$.certificatePath].applyTo(
                        this.certificatePath,
                      )
                    : _patchMap[ClientCertResponse$.certificatePath])
                as String
          : this.certificatePath,
      certificatePassword:
          _patchMap.containsKey(ClientCertResponse$.certificatePassword)
          ? ((_patchMap[ClientCertResponse$.certificatePassword] is Function)
                    ? _patchMap[ClientCertResponse$.certificatePassword](
                        this.certificatePassword,
                      )
                    : (_patchMap[ClientCertResponse$.certificatePassword]
                          is Patch)
                    ? _patchMap[ClientCertResponse$.certificatePassword]
                          .applyTo(this.certificatePassword)
                    : _patchMap[ClientCertResponse$.certificatePassword])
                as String?
          : this.certificatePassword,
      keyStoreType: _patchMap.containsKey(ClientCertResponse$.keyStoreType)
          ? ((_patchMap[ClientCertResponse$.keyStoreType] is Function)
                    ? _patchMap[ClientCertResponse$.keyStoreType](
                        this.keyStoreType,
                      )
                    : (_patchMap[ClientCertResponse$.keyStoreType] is Patch)
                    ? _patchMap[ClientCertResponse$.keyStoreType].applyTo(
                        this.keyStoreType,
                      )
                    : _patchMap[ClientCertResponse$.keyStoreType])
                as String?
          : this.keyStoreType,
      action: _patchMap.containsKey(ClientCertResponse$.action)
          ? ((_patchMap[ClientCertResponse$.action] is Function)
                    ? _patchMap[ClientCertResponse$.action](this.action)
                    : (_patchMap[ClientCertResponse$.action] is Patch)
                    ? _patchMap[ClientCertResponse$.action].applyTo(this.action)
                    : _patchMap[ClientCertResponse$.action])
                as ClientCertResponseAction?
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClientCertResponse &&
        certificatePath == other.certificatePath &&
        certificatePassword == other.certificatePassword &&
        keyStoreType == other.keyStoreType &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.certificatePath,
      this.certificatePassword,
      this.keyStoreType,
      this.action,
    );
  }

  @override
  String toString() {
    return 'ClientCertResponse(' +
        'certificatePath: ${certificatePath}' +
        ', ' +
        'certificatePassword: ${certificatePassword}' +
        ', ' +
        'keyStoreType: ${keyStoreType}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ClientCertResponseToJson(this);
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

extension ClientCertResponsePropertyHelpers on ClientCertResponse {
  bool get hasCertificatePath {
    return this.certificatePath.isNotEmpty;
  }

  bool get noCertificatePath {
    return this.certificatePath.isEmpty;
  }

  bool get hasCertificatePassword {
    return this.certificatePassword?.isNotEmpty == true;
  }

  bool get noCertificatePassword {
    return this.certificatePassword?.isEmpty ?? true;
  }

  String get certificatePasswordRequired {
    return this.certificatePassword ??
        (throw StateError('certificatePassword is required but was null'));
  }

  bool get hasKeyStoreType {
    return this.keyStoreType?.isNotEmpty == true;
  }

  bool get noKeyStoreType {
    return this.keyStoreType?.isEmpty ?? true;
  }

  String get keyStoreTypeRequired {
    return this.keyStoreType ??
        (throw StateError('keyStoreType is required but was null'));
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  ClientCertResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionCANCEL {
    return this.action == ClientCertResponseAction.CANCEL;
  }

  bool get isActionPROCEED {
    return this.action == ClientCertResponseAction.PROCEED;
  }

  bool get isActionIGNORE {
    return this.action == ClientCertResponseAction.IGNORE;
  }
}

extension ClientCertResponseSerialization on ClientCertResponse {
  Map<String, dynamic> toJson() {
    return _$ClientCertResponseToJson(this);
  }
}

enum ClientCertResponse$ {
  certificatePath,
  certificatePassword,
  keyStoreType,
  action,
}

class ClientCertResponsePatch
    extends PatchBase<ClientCertResponse, ClientCertResponse$> {
  ClientCertResponse applyTo(ClientCertResponse entity) {
    return entity.patchWithClientCertResponse(this);
  }

  ClientCertResponsePatch withCertificatePath(String? value) {
    patchMap[ClientCertResponse$.certificatePath] = value;
    return this;
  }

  ClientCertResponsePatch withCertificatePassword(String? value) {
    patchMap[ClientCertResponse$.certificatePassword] = value;
    return this;
  }

  ClientCertResponsePatch withKeyStoreType(String? value) {
    patchMap[ClientCertResponse$.keyStoreType] = value;
    return this;
  }

  ClientCertResponsePatch withAction(ClientCertResponseAction? value) {
    patchMap[ClientCertResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [ClientCertResponse] query construction
abstract final class ClientCertResponseFields {
  static const certificatePath = Field<ClientCertResponse, String>(
    'certificatePath',
    _$certificatePath,
  );

  static const certificatePassword = Field<ClientCertResponse, String?>(
    'certificatePassword',
    _$certificatePassword,
  );

  static const keyStoreType = Field<ClientCertResponse, String?>(
    'keyStoreType',
    _$keyStoreType,
  );

  static const action = Field<ClientCertResponse, ClientCertResponseAction?>(
    'action',
    _$action,
  );

  static String _$certificatePath(ClientCertResponse e) {
    return e.certificatePath;
  }

  static String? _$certificatePassword(ClientCertResponse e) {
    return e.certificatePassword;
  }

  static String? _$keyStoreType(ClientCertResponse e) {
    return e.keyStoreType;
  }

  static ClientCertResponseAction? _$action(ClientCertResponse e) {
    return e.action;
  }
}

extension ClientCertResponseCompareE on ClientCertResponse {
  Map<String, dynamic> compareToClientCertResponse(ClientCertResponse other) {
    final Map<String, dynamic> diff = {};

    if (certificatePath != other.certificatePath) {
      diff['certificatePath'] = () => other.certificatePath;
    }

    if (certificatePassword != other.certificatePassword) {
      diff['certificatePassword'] = () => other.certificatePassword;
    }

    if (keyStoreType != other.keyStoreType) {
      diff['keyStoreType'] = () => other.keyStoreType;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
