// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_authenticate_session_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebAuthenticationSessionSettings _$WebAuthenticationSessionSettingsFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('WebAuthenticationSessionSettings', json, ($checkedConvert) {
      final val = WebAuthenticationSessionSettings(
        prefersEphemeralWebBrowserSession: $checkedConvert(
          'prefersEphemeralWebBrowserSession',
          (v) => v as bool? ?? false,
        ),
        additionalHeaderFields: $checkedConvert(
          'additionalHeaderFields',
          (v) => _additionalHeaderFieldsFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WebAuthenticationSessionSettingsToJson(
  WebAuthenticationSessionSettings instance,
) => <String, dynamic>{
  'prefersEphemeralWebBrowserSession':
      instance.prefersEphemeralWebBrowserSession,
  'additionalHeaderFields': _additionalHeaderFieldsToJson(
    instance.additionalHeaderFields,
  ),
};
