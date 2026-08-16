// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssl_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SslError _$SslErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SslError', json, ($checkedConvert) {
      final val = SslError(
        code: $checkedConvert('code', (v) => _codeFromJson(v)),
        message: $checkedConvert('message', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SslErrorToJson(SslError instance) => <String, dynamic>{
  'code': _codeToJson(instance.code),
  'message': instance.message,
};
