// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: platform-native SslErrorType wire glue.

import 'package:flutter/foundation.dart';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../enums/ssl_error_type.dart';

part 'ssl_error.zorphy.dart';
part 'ssl_error.g.dart';

///Class that represents an SSL Error.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $SslError {
  ///Primary code error associated to the server SSL certificate.
  ///It represents the most severe SSL error.
  @JsonKey(fromJson: _codeFromJson, toJson: _codeToJson)
  SslErrorType? get code;

  ///The message associated to the [code].
  String? get message;
}

///SslErrorType wire values are platform-dependent (the old ExchangeableEnum
///codegen dispatched on `defaultTargetPlatform`): iOS/macOS send the
///`SecTrustResultType`-derived ints, Android sends the `SSL_ERROR_*` ints.
///These helpers replicate the old `toNativeValue`/`fromNativeValue` switch so
///the wire is unchanged.
SslErrorType? _codeFromJson(Object? value) {
  if (value is! int) return null;
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return switch (value) {
        0 => SslErrorType.INVALID,
        3 => SslErrorType.DENY,
        4 => SslErrorType.UNSPECIFIED,
        5 => SslErrorType.RECOVERABLE_TRUST_FAILURE,
        6 => SslErrorType.FATAL_TRUST_FAILURE,
        7 => SslErrorType.OTHER_ERROR,
        _ => null,
      };
    case TargetPlatform.android:
      return switch (value) {
        0 => SslErrorType.NOT_YET_VALID,
        1 => SslErrorType.EXPIRED,
        2 => SslErrorType.IDMISMATCH,
        3 => SslErrorType.UNTRUSTED,
        4 => SslErrorType.DATE_INVALID,
        5 => SslErrorType.INVALID,
        _ => null,
      };
    default:
      return null;
  }
}

Object? _codeToJson(SslErrorType? code) {
  if (code == null) return null;
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return switch (code) {
        SslErrorType.INVALID => 0,
        SslErrorType.DENY => 3,
        SslErrorType.UNSPECIFIED => 4,
        SslErrorType.RECOVERABLE_TRUST_FAILURE => 5,
        SslErrorType.FATAL_TRUST_FAILURE => 6,
        SslErrorType.OTHER_ERROR => 7,
        _ => null,
      };
    case TargetPlatform.android:
      return switch (code) {
        SslErrorType.NOT_YET_VALID => 0,
        SslErrorType.EXPIRED => 1,
        SslErrorType.IDMISMATCH => 2,
        SslErrorType.UNTRUSTED => 3,
        SslErrorType.DATE_INVALID => 4,
        SslErrorType.INVALID => 5,
        _ => null,
      };
    default:
      return null;
  }
}
