// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssl_error.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents an SSL Error.
class SslError {
  ///Primary code error associated to the server SSL certificate.
  ///It represents the most severe SSL error.
  SslErrorType? code;

  ///The message associated to the [code].
  String? message;
  SslError({this.code, this.message});

  ///Gets a possible [SslError] instance from a [Map] value.
  static SslError? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = SslError(
      code: SslErrorType.fromNativeValue(map['code']),
      message: map['message'],
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"code": code?.toNativeValue(), "message": message};
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'SslError{code: $code, message: $message}';
  }
}
