// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'ssl_error.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class SslError {
  SslError({SslErrorType? this.code, String? this.message});

  factory SslError.fromJson(Map<String, dynamic> json) =>
      _$SslErrorFromJson(json);

  @JsonKey(toJson: _codeToJson, fromJson: _codeFromJson)
  final SslErrorType? code;

  final String? message;

  SslError copyWith({SslErrorType? code, String? message}) {
    return SslError(code: code ?? this.code, message: message ?? this.message);
  }

  SslError copyWithSslError({SslErrorType? code, String? message}) {
    return copyWith(code: code, message: message);
  }

  SslError patchWithSslError([SslErrorPatch? patchInput]) {
    final _patcher = patchInput ?? SslErrorPatch();
    final _patchMap = _patcher.patchMap;
    return SslError(
      code: _patchMap.containsKey(SslError$.code)
          ? (_patchMap[SslError$.code] is Function)
                ? _patchMap[SslError$.code](this.code)
                : (_patchMap[SslError$.code] is Patch)
                ? _patchMap[SslError$.code].applyTo(this.code)
                : _patchMap[SslError$.code]
          : this.code,
      message: _patchMap.containsKey(SslError$.message)
          ? (_patchMap[SslError$.message] is Function)
                ? _patchMap[SslError$.message](this.message)
                : (_patchMap[SslError$.message] is Patch)
                ? _patchMap[SslError$.message].applyTo(this.message)
                : _patchMap[SslError$.message]
          : this.message,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SslError && code == other.code && message == other.message;
  }

  @override
  int get hashCode {
    return Object.hash(this.code, this.message);
  }

  @override
  String toString() {
    return 'SslError(' + 'code: ${code}' + ', ' + 'message: ${message})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$SslErrorToJson(this);
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

extension SslErrorPropertyHelpers on SslError {
  bool get hasCode {
    return this.code != null;
  }

  bool get noCode {
    return this.code == null;
  }

  SslErrorType get codeRequired {
    return this.code ?? (throw StateError('code is required but was null'));
  }

  bool get isCodeNOT_YET_VALID {
    return this.code == SslErrorType.NOT_YET_VALID;
  }

  bool get isCodeEXPIRED {
    return this.code == SslErrorType.EXPIRED;
  }

  bool get isCodeIDMISMATCH {
    return this.code == SslErrorType.IDMISMATCH;
  }

  bool get isCodeUNTRUSTED {
    return this.code == SslErrorType.UNTRUSTED;
  }

  bool get isCodeDATE_INVALID {
    return this.code == SslErrorType.DATE_INVALID;
  }

  bool get isCodeINVALID {
    return this.code == SslErrorType.INVALID;
  }

  bool get isCodeDENY {
    return this.code == SslErrorType.DENY;
  }

  bool get isCodeUNSPECIFIED {
    return this.code == SslErrorType.UNSPECIFIED;
  }

  bool get isCodeRECOVERABLE_TRUST_FAILURE {
    return this.code == SslErrorType.RECOVERABLE_TRUST_FAILURE;
  }

  bool get isCodeFATAL_TRUST_FAILURE {
    return this.code == SslErrorType.FATAL_TRUST_FAILURE;
  }

  bool get isCodeOTHER_ERROR {
    return this.code == SslErrorType.OTHER_ERROR;
  }

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
}

extension SslErrorSerialization on SslError {
  Map<String, dynamic> toJson() {
    return _$SslErrorToJson(this);
  }
}

enum SslError$ { code, message }

class SslErrorPatch extends PatchBase<SslError, SslError$> {
  SslError applyTo(SslError entity) {
    return entity.patchWithSslError(this);
  }

  SslErrorPatch withCode(SslErrorType? value) {
    patchMap[SslError$.code] = value;
    return this;
  }

  SslErrorPatch withMessage(String? value) {
    patchMap[SslError$.message] = value;
    return this;
  }
}

/// Field descriptors for [SslError] query construction
abstract final class SslErrorFields {
  static const code = Field<SslError, SslErrorType?>('code', _$code);

  static const message = Field<SslError, String?>('message', _$message);

  static SslErrorType? _$code(SslError e) {
    return e.code;
  }

  static String? _$message(SslError e) {
    return e.message;
  }
}

extension SslErrorCompareE on SslError {
  Map<String, dynamic> compareToSslError(SslError other) {
    final Map<String, dynamic> diff = {};

    if (code != other.code) {
      diff['code'] = () => other.code;
    }

    if (message != other.message) {
      diff['message'] = () => other.message;
    }
    return diff;
  }
}
