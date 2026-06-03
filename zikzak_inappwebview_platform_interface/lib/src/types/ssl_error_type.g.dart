// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssl_error_type.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that represents the SSL Primary error associated to the server SSL certificate.
///Used by the [ServerTrustChallenge] class.
class SslErrorType {
  final String _value;
  final int? _nativeValue;
  const SslErrorType._internal(this._value, this._nativeValue);
  // ignore: unused_element
  factory SslErrorType._internalMultiPlatform(
    String value,
    Function nativeValue,
  ) => SslErrorType._internal(value, nativeValue());

  ///The date of the certificate is invalid.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - SslError.DATE_INVALID](https://developer.android.com/reference/android/net/http/SslError#SSL_DATE_INVALID))
  static final DATE_INVALID = SslErrorType._internalMultiPlatform(
    'DATE_INVALID',
    () {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return 4;
        default:
          break;
      }
      return null;
    },
  );

  ///The user specified that the certificate should not be trusted.
  ///
  ///This value indicates that the user explicitly chose to not trust a certificate in the chain,
  ///usually by clicking the appropriate button in a certificate trust panel.
  ///Your app should not trust the chain.
  ///The Keychain Access utility refers to this value as "Never Trust."
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - SecTrustResultType.deny](https://developer.apple.com/documentation/security/sectrustresulttype/deny))
  ///- MacOS ([Official API - SecTrustResultType.deny](https://developer.apple.com/documentation/security/sectrustresulttype/deny))
  static final DENY = SslErrorType._internalMultiPlatform('DENY', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 3;
      case TargetPlatform.macOS:
        return 3;
      default:
        break;
    }
    return null;
  });

  ///The certificate has expired.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - SslError.SSL_EXPIRED](https://developer.android.com/reference/android/net/http/SslError#SSL_EXPIRED))
  static final EXPIRED = SslErrorType._internalMultiPlatform('EXPIRED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      default:
        break;
    }
    return null;
  });

  ///Trust is denied and no simple fix is available.
  ///
  ///This value indicates that evaluation failed because a certificate in the chain is defective.
  ///This usually represents a fundamental defect in the certificate data, such as an invalid encoding for a critical subjectAltName extension,
  ///an unsupported critical extension, or some other critical portion of the certificate that couldn’t be interpreted.
  ///Changing parameter values and reevaluating is unlikely to succeed unless you provide different certificates.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - SecTrustResultType.fatalTrustFailure](https://developer.apple.com/documentation/security/sectrustresulttype/fataltrustfailure))
  ///- MacOS ([Official API - SecTrustResultType.fatalTrustFailure](https://developer.apple.com/documentation/security/sectrustresulttype/fataltrustfailure))
  static final FATAL_TRUST_FAILURE = SslErrorType._internalMultiPlatform(
    'FATAL_TRUST_FAILURE',
    () {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          return 6;
        case TargetPlatform.macOS:
          return 6;
        default:
          break;
      }
      return null;
    },
  );

  ///Hostname mismatch.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - SslError.SSL_IDMISMATCH](https://developer.android.com/reference/android/net/http/SslError#SSL_IDMISMATCH))
  static final IDMISMATCH = SslErrorType._internalMultiPlatform(
    'IDMISMATCH',
    () {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return 2;
        default:
          break;
      }
      return null;
    },
  );

  ///Indicates an invalid setting or result. A generic error occurred.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - SslError.SSL_INVALID](https://developer.android.com/reference/android/net/http/SslError#SSL_INVALID))
  ///- iOS ([Official API - SecTrustResultType.invalid](https://developer.apple.com/documentation/security/sectrustresulttype/invalid))
  ///- MacOS ([Official API - SecTrustResultType.invalid](https://developer.apple.com/documentation/security/sectrustresulttype/invalid))
  static final INVALID = SslErrorType._internalMultiPlatform('INVALID', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 5;
      case TargetPlatform.iOS:
        return 0;
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  ///The certificate is not yet valid.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - SslError.SSL_NOTYETVALID](https://developer.android.com/reference/android/net/http/SslError#SSL_NOTYETVALID))
  static final NOT_YET_VALID = SslErrorType._internalMultiPlatform(
    'NOT_YET_VALID',
    () {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return 0;
        default:
          break;
      }
      return null;
    },
  );

  ///Indicates a failure other than that of trust evaluation.
  ///
  ///This value indicates that evaluation failed for some other reason.
  ///This can be caused by either a revoked certificate or by OS-level errors that are unrelated to the certificates themselves.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - SecTrustResultType.otherError](https://developer.apple.com/documentation/security/sectrustresulttype/othererror))
  ///- MacOS ([Official API - SecTrustResultType.otherError](https://developer.apple.com/documentation/security/sectrustresulttype/othererror))
  static final OTHER_ERROR = SslErrorType._internalMultiPlatform(
    'OTHER_ERROR',
    () {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          return 7;
        case TargetPlatform.macOS:
          return 7;
        default:
          break;
      }
      return null;
    },
  );

  ///Trust is denied, but recovery may be possible.
  ///
  ///This value indicates that you should not trust the chain as is,
  ///but that the chain could be trusted with some minor change to the evaluation context,
  ///such as ignoring expired certificates or adding another anchor to the set of trusted anchors.
  ///
  ///The way you handle this depends on the situation.
  ///For example, if you are performing signature validation and you know when the message was originally received,
  ///you should check again using that date to see if the message was valid when you originally received it.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - SecTrustResultType.recoverableTrustFailure](https://developer.apple.com/documentation/security/sectrustresulttype/recoverabletrustfailure))
  ///- MacOS ([Official API - SecTrustResultType.recoverableTrustFailure](https://developer.apple.com/documentation/security/sectrustresulttype/recoverabletrustfailure))
  static final RECOVERABLE_TRUST_FAILURE = SslErrorType._internalMultiPlatform(
    'RECOVERABLE_TRUST_FAILURE',
    () {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          return 5;
        case TargetPlatform.macOS:
          return 5;
        default:
          break;
      }
      return null;
    },
  );

  ///Indicates the evaluation succeeded and the certificate is implicitly trusted, but user intent was not explicitly specified.
  ///
  ///This value indicates that evaluation reached an (implicitly trusted) anchor certificate without any evaluation failures,
  ///but never encountered any explicitly stated user-trust preference.
  ///This is the most common return value.
  ///The Keychain Access utility refers to this value as the “Use System Policy,” which is the default user setting.
  ///
  ///When receiving this value, most apps should trust the chain.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - SecTrustResultType.unspecified](https://developer.apple.com/documentation/security/sectrustresulttype/unspecified))
  ///- MacOS ([Official API - SecTrustResultType.unspecified](https://developer.apple.com/documentation/security/sectrustresulttype/unspecified))
  static final UNSPECIFIED = SslErrorType._internalMultiPlatform(
    'UNSPECIFIED',
    () {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          return 4;
        case TargetPlatform.macOS:
          return 4;
        default:
          break;
      }
      return null;
    },
  );

  ///The certificate authority is not trusted.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - SslError.SSL_UNTRUSTED](https://developer.android.com/reference/android/net/http/SslError#SSL_UNTRUSTED))
  static final UNTRUSTED = SslErrorType._internalMultiPlatform('UNTRUSTED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 3;
      default:
        break;
    }
    return null;
  });

  ///Set of all values of [SslErrorType].
  static final Set<SslErrorType> values = [
    SslErrorType.DATE_INVALID,
    SslErrorType.DENY,
    SslErrorType.EXPIRED,
    SslErrorType.FATAL_TRUST_FAILURE,
    SslErrorType.IDMISMATCH,
    SslErrorType.INVALID,
    SslErrorType.NOT_YET_VALID,
    SslErrorType.OTHER_ERROR,
    SslErrorType.RECOVERABLE_TRUST_FAILURE,
    SslErrorType.UNSPECIFIED,
    SslErrorType.UNTRUSTED,
  ].toSet();

  ///Gets a possible [SslErrorType] instance from [String] value.
  static SslErrorType? fromValue(String? value) {
    if (value != null) {
      try {
        return SslErrorType.values.firstWhere(
          (element) => element.toValue() == value,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [SslErrorType] instance from a native value.
  static SslErrorType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return SslErrorType.values.firstWhere(
          (element) => element.toNativeValue() == value,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets [String] value.
  String toValue() => _value;

  ///Gets [int?] native value.
  int? toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
