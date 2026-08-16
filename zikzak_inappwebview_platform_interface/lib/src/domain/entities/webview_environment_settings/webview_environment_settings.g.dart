// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webview_environment_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VirtualHostMapping _$VirtualHostMappingFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VirtualHostMapping', json, ($checkedConvert) {
      final val = VirtualHostMapping(
        hostName: $checkedConvert('hostName', (v) => _hostNameFromJson(v)),
        folderPath: $checkedConvert(
          'folderPath',
          (v) => _folderPathFromJson(v),
        ),
        accessKind: $checkedConvert(
          'accessKind',
          (v) =>
              v == null ? HostResourceAccessKind.allow : _accessKindFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VirtualHostMappingToJson(VirtualHostMapping instance) =>
    <String, dynamic>{
      'hostName': _hostNameToJson(instance.hostName),
      'folderPath': _folderPathToJson(instance.folderPath),
      'accessKind': _accessKindToJson(instance.accessKind),
    };

WebViewEnvironmentSettings _$WebViewEnvironmentSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WebViewEnvironmentSettings', json, ($checkedConvert) {
  final val = WebViewEnvironmentSettings(
    browserExecutableFolder: $checkedConvert(
      'browserExecutableFolder',
      (v) => v as String?,
    ),
    userDataFolder: $checkedConvert('userDataFolder', (v) => v as String?),
    additionalBrowserArguments: $checkedConvert(
      'additionalBrowserArguments',
      (v) => v as String?,
    ),
    allowSingleSignOnUsingOSPrimaryAccount: $checkedConvert(
      'allowSingleSignOnUsingOSPrimaryAccount',
      (v) => v as bool?,
    ),
    language: $checkedConvert('language', (v) => v as String?),
    targetCompatibleBrowserVersion: $checkedConvert(
      'targetCompatibleBrowserVersion',
      (v) => v as String?,
    ),
    virtualHostMappings: $checkedConvert(
      'virtualHostMappings',
      (v) => _virtualHostMappingsFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$WebViewEnvironmentSettingsToJson(
  WebViewEnvironmentSettings instance,
) => <String, dynamic>{
  'browserExecutableFolder': instance.browserExecutableFolder,
  'userDataFolder': instance.userDataFolder,
  'additionalBrowserArguments': instance.additionalBrowserArguments,
  'allowSingleSignOnUsingOSPrimaryAccount':
      instance.allowSingleSignOnUsingOSPrimaryAccount,
  'language': instance.language,
  'targetCompatibleBrowserVersion': instance.targetCompatibleBrowserVersion,
  'virtualHostMappings': _virtualHostMappingsToJson(
    instance.virtualHostMappings,
  ),
};
