// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_cert_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientCertResponse _$ClientCertResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ClientCertResponse', json, ($checkedConvert) {
      final val = ClientCertResponse(
        certificatePath: $checkedConvert('certificatePath', (v) => v as String),
        certificatePassword: $checkedConvert(
          'certificatePassword',
          (v) => v as String? ?? '',
        ),
        keyStoreType: $checkedConvert(
          'keyStoreType',
          (v) => v as String? ?? 'PKCS12',
        ),
        action: $checkedConvert(
          'action',
          (v) =>
              v == null ? ClientCertResponseAction.CANCEL : _actionFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ClientCertResponseToJson(ClientCertResponse instance) =>
    <String, dynamic>{
      'certificatePath': instance.certificatePath,
      'certificatePassword': instance.certificatePassword,
      'keyStoreType': instance.keyStoreType,
      'action': _actionToJson(instance.action),
    };
