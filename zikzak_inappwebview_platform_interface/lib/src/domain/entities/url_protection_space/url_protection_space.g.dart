// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_protection_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

URLProtectionSpace _$URLProtectionSpaceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('URLProtectionSpace', json, ($checkedConvert) {
      final val = URLProtectionSpace(
        host: $checkedConvert('host', (v) => v as String),
        protocol: $checkedConvert('protocol', (v) => v as String?),
        realm: $checkedConvert('realm', (v) => v as String?),
        port: $checkedConvert('port', (v) => (v as num?)?.toInt()),
        sslCertificate: $checkedConvert(
          'sslCertificate',
          (v) => _sslCertificateFromJson(v),
        ),
        sslError: $checkedConvert('sslError', (v) => _sslErrorFromJson(v)),
        authenticationMethod: $checkedConvert(
          'authenticationMethod',
          (v) => _authenticationMethodFromJson(v),
        ),
        distinguishedNames: $checkedConvert(
          'distinguishedNames',
          (v) => _distinguishedNamesFromJson(v),
        ),
        proxyType: $checkedConvert('proxyType', (v) => _proxyTypeFromJson(v)),
        receivesCredentialSecurely: $checkedConvert(
          'receivesCredentialSecurely',
          (v) => v as bool?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$URLProtectionSpaceToJson(
  URLProtectionSpace instance,
) => <String, dynamic>{
  'host': instance.host,
  'protocol': instance.protocol,
  'realm': instance.realm,
  'port': instance.port,
  'sslCertificate': _sslCertificateToJson(instance.sslCertificate),
  'sslError': _sslErrorToJson(instance.sslError),
  'authenticationMethod': _authenticationMethodToJson(
    instance.authenticationMethod,
  ),
  'distinguishedNames': _distinguishedNamesToJson(instance.distinguishedNames),
  'proxyType': _proxyTypeToJson(instance.proxyType),
  'receivesCredentialSecurely': instance.receivesCredentialSecurely,
};
