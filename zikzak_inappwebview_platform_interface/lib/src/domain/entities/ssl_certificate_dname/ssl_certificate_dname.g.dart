// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssl_certificate_dname.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SslCertificateDName _$SslCertificateDNameFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SslCertificateDName', json, ($checkedConvert) {
      final val = SslCertificateDName(
        CName: $checkedConvert('CName', (v) => v as String? ?? ''),
        DName: $checkedConvert('DName', (v) => v as String? ?? ''),
        OName: $checkedConvert('OName', (v) => v as String? ?? ''),
        UName: $checkedConvert('UName', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$SslCertificateDNameToJson(
  SslCertificateDName instance,
) => <String, dynamic>{
  'CName': instance.CName,
  'DName': instance.DName,
  'OName': instance.OName,
  'UName': instance.UName,
};
