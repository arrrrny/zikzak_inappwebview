// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_resource_error.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebResourceError {
  WebResourceError({WebResourceErrorType? this.type, String? this.description});

  factory WebResourceError.fromJson(Map<String, dynamic> json) =>
      _$WebResourceErrorFromJson(json);

  @JsonKey(toJson: _typeToJson, fromJson: _typeFromJson)
  final WebResourceErrorType? type;

  final String? description;

  WebResourceError copyWith({WebResourceErrorType? type, String? description}) {
    return WebResourceError(
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  WebResourceError copyWithWebResourceError({
    WebResourceErrorType? type,
    String? description,
  }) {
    return copyWith(type: type, description: description);
  }

  WebResourceError patchWithWebResourceError([
    WebResourceErrorPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebResourceErrorPatch();
    final _patchMap = _patcher.patchMap;
    return WebResourceError(
      type: _patchMap.containsKey(WebResourceError$.type)
          ? ((_patchMap[WebResourceError$.type] is Function)
                    ? _patchMap[WebResourceError$.type](this.type)
                    : (_patchMap[WebResourceError$.type] is Patch)
                    ? _patchMap[WebResourceError$.type].applyTo(this.type)
                    : _patchMap[WebResourceError$.type])
                as WebResourceErrorType?
          : this.type,
      description: _patchMap.containsKey(WebResourceError$.description)
          ? ((_patchMap[WebResourceError$.description] is Function)
                    ? _patchMap[WebResourceError$.description](this.description)
                    : (_patchMap[WebResourceError$.description] is Patch)
                    ? _patchMap[WebResourceError$.description].applyTo(
                        this.description,
                      )
                    : _patchMap[WebResourceError$.description])
                as String?
          : this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebResourceError &&
        type == other.type &&
        description == other.description;
  }

  @override
  int get hashCode {
    return Object.hash(this.type, this.description);
  }

  @override
  String toString() {
    return 'WebResourceError(' +
        'type: ${type}' +
        ', ' +
        'description: ${description})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebResourceErrorToJson(this);
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

extension WebResourceErrorPropertyHelpers on WebResourceError {
  bool get hasType {
    return this.type != null;
  }

  bool get noType {
    return this.type == null;
  }

  WebResourceErrorType get typeRequired {
    return this.type ?? (throw StateError('type is required but was null'));
  }

  bool get isTypeUSER_AUTHENTICATION_FAILED {
    return this.type == WebResourceErrorType.USER_AUTHENTICATION_FAILED;
  }

  bool get isTypeBAD_URL {
    return this.type == WebResourceErrorType.BAD_URL;
  }

  bool get isTypeCANNOT_CONNECT_TO_HOST {
    return this.type == WebResourceErrorType.CANNOT_CONNECT_TO_HOST;
  }

  bool get isTypeFAILED_SSL_HANDSHAKE {
    return this.type == WebResourceErrorType.FAILED_SSL_HANDSHAKE;
  }

  bool get isTypeGENERIC_FILE_ERROR {
    return this.type == WebResourceErrorType.GENERIC_FILE_ERROR;
  }

  bool get isTypeFILE_NOT_FOUND {
    return this.type == WebResourceErrorType.FILE_NOT_FOUND;
  }

  bool get isTypeHOST_LOOKUP {
    return this.type == WebResourceErrorType.HOST_LOOKUP;
  }

  bool get isTypeIO {
    return this.type == WebResourceErrorType.IO;
  }

  bool get isTypePROXY_AUTHENTICATION {
    return this.type == WebResourceErrorType.PROXY_AUTHENTICATION;
  }

  bool get isTypeTOO_MANY_REDIRECTS {
    return this.type == WebResourceErrorType.TOO_MANY_REDIRECTS;
  }

  bool get isTypeTIMEOUT {
    return this.type == WebResourceErrorType.TIMEOUT;
  }

  bool get isTypeTOO_MANY_REQUESTS {
    return this.type == WebResourceErrorType.TOO_MANY_REQUESTS;
  }

  bool get isTypeUNKNOWN {
    return this.type == WebResourceErrorType.UNKNOWN;
  }

  bool get isTypeUNSAFE_RESOURCE {
    return this.type == WebResourceErrorType.UNSAFE_RESOURCE;
  }

  bool get isTypeUNSUPPORTED_AUTH_SCHEME {
    return this.type == WebResourceErrorType.UNSUPPORTED_AUTH_SCHEME;
  }

  bool get isTypeUNSUPPORTED_SCHEME {
    return this.type == WebResourceErrorType.UNSUPPORTED_SCHEME;
  }

  bool get isTypeCANCELLED {
    return this.type == WebResourceErrorType.CANCELLED;
  }

  bool get isTypeNETWORK_CONNECTION_LOST {
    return this.type == WebResourceErrorType.NETWORK_CONNECTION_LOST;
  }

  bool get isTypeRESOURCE_UNAVAILABLE {
    return this.type == WebResourceErrorType.RESOURCE_UNAVAILABLE;
  }

  bool get isTypeNOT_CONNECTED_TO_INTERNET {
    return this.type == WebResourceErrorType.NOT_CONNECTED_TO_INTERNET;
  }

  bool get isTypeREDIRECT_TO_NON_EXISTENT_LOCATION {
    return this.type == WebResourceErrorType.REDIRECT_TO_NON_EXISTENT_LOCATION;
  }

  bool get isTypeBAD_SERVER_RESPONSE {
    return this.type == WebResourceErrorType.BAD_SERVER_RESPONSE;
  }

  bool get isTypeUSER_CANCELLED_AUTHENTICATION {
    return this.type == WebResourceErrorType.USER_CANCELLED_AUTHENTICATION;
  }

  bool get isTypeUSER_AUTHENTICATION_REQUIRED {
    return this.type == WebResourceErrorType.USER_AUTHENTICATION_REQUIRED;
  }

  bool get isTypeZERO_BYTE_RESOURCE {
    return this.type == WebResourceErrorType.ZERO_BYTE_RESOURCE;
  }

  bool get isTypeCANNOT_DECODE_RAW_DATA {
    return this.type == WebResourceErrorType.CANNOT_DECODE_RAW_DATA;
  }

  bool get isTypeCANNOT_DECODE_CONTENT_DATA {
    return this.type == WebResourceErrorType.CANNOT_DECODE_CONTENT_DATA;
  }

  bool get isTypeCANNOT_PARSE_RESPONSE {
    return this.type == WebResourceErrorType.CANNOT_PARSE_RESPONSE;
  }

  bool get isTypeAPP_TRANSPORT_SECURITY_REQUIRES_SECURE_CONNECTION {
    return this.type ==
        WebResourceErrorType.APP_TRANSPORT_SECURITY_REQUIRES_SECURE_CONNECTION;
  }

  bool get isTypeFILE_IS_DIRECTORY {
    return this.type == WebResourceErrorType.FILE_IS_DIRECTORY;
  }

  bool get isTypeNO_PERMISSIONS_TO_READ_FILE {
    return this.type == WebResourceErrorType.NO_PERMISSIONS_TO_READ_FILE;
  }

  bool get isTypeDATA_LENGTH_EXCEEDS_MAXIMUM {
    return this.type == WebResourceErrorType.DATA_LENGTH_EXCEEDS_MAXIMUM;
  }

  bool get isTypeSECURE_CONNECTION_FAILED {
    return this.type == WebResourceErrorType.SECURE_CONNECTION_FAILED;
  }

  bool get isTypeSERVER_CERTIFICATE_HAS_BAD_DATE {
    return this.type == WebResourceErrorType.SERVER_CERTIFICATE_HAS_BAD_DATE;
  }

  bool get isTypeSERVER_CERTIFICATE_UNTRUSTED {
    return this.type == WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED;
  }

  bool get isTypeSERVER_CERTIFICATE_HAS_UNKNOWN_ROOT {
    return this.type ==
        WebResourceErrorType.SERVER_CERTIFICATE_HAS_UNKNOWN_ROOT;
  }

  bool get isTypeSERVER_CERTIFICATE_NOT_YET_VALID {
    return this.type == WebResourceErrorType.SERVER_CERTIFICATE_NOT_YET_VALID;
  }

  bool get isTypeCLIENT_CERTIFICATE_REJECTED {
    return this.type == WebResourceErrorType.CLIENT_CERTIFICATE_REJECTED;
  }

  bool get isTypeCLIENT_CERTIFICATE_REQUIRED {
    return this.type == WebResourceErrorType.CLIENT_CERTIFICATE_REQUIRED;
  }

  bool get isTypeCANNOT_LOAD_FROM_NETWORK {
    return this.type == WebResourceErrorType.CANNOT_LOAD_FROM_NETWORK;
  }

  bool get isTypeCANNOT_CREATE_FILE {
    return this.type == WebResourceErrorType.CANNOT_CREATE_FILE;
  }

  bool get isTypeCANNOT_OPEN_FILE {
    return this.type == WebResourceErrorType.CANNOT_OPEN_FILE;
  }

  bool get isTypeCANNOT_CLOSE_FILE {
    return this.type == WebResourceErrorType.CANNOT_CLOSE_FILE;
  }

  bool get isTypeCANNOT_WRITE_TO_FILE {
    return this.type == WebResourceErrorType.CANNOT_WRITE_TO_FILE;
  }

  bool get isTypeCANNOT_REMOVE_FILE {
    return this.type == WebResourceErrorType.CANNOT_REMOVE_FILE;
  }

  bool get isTypeCANNOT_MOVE_FILE {
    return this.type == WebResourceErrorType.CANNOT_MOVE_FILE;
  }

  bool get isTypeDOWNLOAD_DECODING_FAILED_MID_STREAM {
    return this.type ==
        WebResourceErrorType.DOWNLOAD_DECODING_FAILED_MID_STREAM;
  }

  bool get isTypeDOWNLOAD_DECODING_FAILED_TO_COMPLETE {
    return this.type ==
        WebResourceErrorType.DOWNLOAD_DECODING_FAILED_TO_COMPLETE;
  }

  bool get isTypeINTERNATIONAL_ROAMING_OFF {
    return this.type == WebResourceErrorType.INTERNATIONAL_ROAMING_OFF;
  }

  bool get isTypeCALL_IS_ACTIVE {
    return this.type == WebResourceErrorType.CALL_IS_ACTIVE;
  }

  bool get isTypeDATA_NOT_ALLOWED {
    return this.type == WebResourceErrorType.DATA_NOT_ALLOWED;
  }

  bool get isTypeREQUEST_BODY_STREAM_EXHAUSTED {
    return this.type == WebResourceErrorType.REQUEST_BODY_STREAM_EXHAUSTED;
  }

  bool get isTypeBACKGROUND_SESSION_REQUIRES_SHARED_CONTAINER {
    return this.type ==
        WebResourceErrorType.BACKGROUND_SESSION_REQUIRES_SHARED_CONTAINER;
  }

  bool get isTypeBACKGROUND_SESSION_IN_USE_BY_ANOTHER_PROCESS {
    return this.type ==
        WebResourceErrorType.BACKGROUND_SESSION_IN_USE_BY_ANOTHER_PROCESS;
  }

  bool get isTypeBACKGROUND_SESSION_WAS_DISCONNECTED {
    return this.type ==
        WebResourceErrorType.BACKGROUND_SESSION_WAS_DISCONNECTED;
  }

  bool get isTypeSERVER_UNREACHABLE {
    return this.type == WebResourceErrorType.SERVER_UNREACHABLE;
  }

  bool get isTypeCONNECTION_ABORTED {
    return this.type == WebResourceErrorType.CONNECTION_ABORTED;
  }

  bool get isTypeRESET {
    return this.type == WebResourceErrorType.RESET;
  }

  bool get isTypeREDIRECT_FAILED {
    return this.type == WebResourceErrorType.REDIRECT_FAILED;
  }

  bool get isTypeUNEXPECTED_ERROR {
    return this.type == WebResourceErrorType.UNEXPECTED_ERROR;
  }

  bool get isTypeVALID_PROXY_AUTHENTICATION_REQUIRED {
    return this.type ==
        WebResourceErrorType.VALID_PROXY_AUTHENTICATION_REQUIRED;
  }

  bool get hasDescription {
    return this.description?.isNotEmpty == true;
  }

  bool get noDescription {
    return this.description?.isEmpty ?? true;
  }

  String get descriptionRequired {
    return this.description ??
        (throw StateError('description is required but was null'));
  }
}

extension WebResourceErrorSerialization on WebResourceError {
  Map<String, dynamic> toJson() {
    return _$WebResourceErrorToJson(this);
  }
}

enum WebResourceError$ { type, description }

class WebResourceErrorPatch
    extends PatchBase<WebResourceError, WebResourceError$> {
  WebResourceError applyTo(WebResourceError entity) {
    return entity.patchWithWebResourceError(this);
  }

  WebResourceErrorPatch withType(WebResourceErrorType? value) {
    patchMap[WebResourceError$.type] = value;
    return this;
  }

  WebResourceErrorPatch withDescription(String? value) {
    patchMap[WebResourceError$.description] = value;
    return this;
  }
}

/// Field descriptors for [WebResourceError] query construction
abstract final class WebResourceErrorFields {
  static const type = Field<WebResourceError, WebResourceErrorType?>(
    'type',
    _$type,
  );

  static const description = Field<WebResourceError, String?>(
    'description',
    _$description,
  );

  static WebResourceErrorType? _$type(WebResourceError e) {
    return e.type;
  }

  static String? _$description(WebResourceError e) {
    return e.description;
  }
}

extension WebResourceErrorCompareE on WebResourceError {
  Map<String, dynamic> compareToWebResourceError(WebResourceError other) {
    final Map<String, dynamic> diff = {};

    if (type != other.type) {
      diff['type'] = () => other.type;
    }

    if (description != other.description) {
      diff['description'] = () => other.description;
    }
    return diff;
  }
}
