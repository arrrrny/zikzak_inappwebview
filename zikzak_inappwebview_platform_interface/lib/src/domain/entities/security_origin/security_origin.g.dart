// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_origin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityOrigin _$SecurityOriginFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SecurityOrigin', json, ($checkedConvert) {
      final val = SecurityOrigin(
        host: $checkedConvert('host', (v) => v as String),
        port: $checkedConvert('port', (v) => (v as num).toInt()),
        protocol: $checkedConvert('protocol', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SecurityOriginToJson(SecurityOrigin instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'protocol': instance.protocol,
    };
