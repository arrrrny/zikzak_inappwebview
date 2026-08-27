// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

URLCredential _$URLCredentialFromJson(Map<String, dynamic> json) =>
    $checkedCreate('URLCredential', json, ($checkedConvert) {
      final val = URLCredential(
        username: $checkedConvert('username', (v) => v as String?),
        password: $checkedConvert('password', (v) => v as String?),
        certificates: $checkedConvert(
          'certificates',
          (v) => _certificatesFromJson(v),
        ),
        persistence: $checkedConvert(
          'persistence',
          (v) => _persistenceFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$URLCredentialToJson(URLCredential instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'certificates': _certificatesToJson(instance.certificates),
      'persistence': _persistenceToJson(instance.persistence),
    };
