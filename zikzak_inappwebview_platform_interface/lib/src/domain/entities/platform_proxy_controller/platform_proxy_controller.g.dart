// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_proxy_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IOSProxySettings _$IOSProxySettingsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('IOSProxySettings', json, ($checkedConvert) {
      final val = IOSProxySettings(
        proxyUrl: $checkedConvert('proxyUrl', (v) => v as String? ?? ''),
        allowFailover: $checkedConvert(
          'allowFailover',
          (v) => v as bool? ?? false,
        ),
        excludedDomains: $checkedConvert(
          'excludedDomains',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        ),
        matchDomains: $checkedConvert(
          'matchDomains',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        ),
      );
      return val;
    });

Map<String, dynamic> _$IOSProxySettingsToJson(IOSProxySettings instance) =>
    <String, dynamic>{
      'proxyUrl': instance.proxyUrl,
      'allowFailover': instance.allowFailover,
      'excludedDomains': instance.excludedDomains,
      'matchDomains': instance.matchDomains,
    };

AndroidProxySettings _$AndroidProxySettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AndroidProxySettings', json, ($checkedConvert) {
  final val = AndroidProxySettings(
    bypassRules: $checkedConvert(
      'bypassRules',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
    directs: $checkedConvert(
      'directs',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
    proxyRules: $checkedConvert(
      'proxyRules',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => ProxyRule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    ),
    bypassSimpleHostnames: $checkedConvert(
      'bypassSimpleHostnames',
      (v) => v as bool?,
    ),
    removeImplicitRules: $checkedConvert(
      'removeImplicitRules',
      (v) => v as bool?,
    ),
    reverseBypassEnabled: $checkedConvert(
      'reverseBypassEnabled',
      (v) => v as bool? ?? false,
    ),
  );
  return val;
});

Map<String, dynamic> _$AndroidProxySettingsToJson(
  AndroidProxySettings instance,
) => <String, dynamic>{
  'bypassRules': instance.bypassRules,
  'directs': instance.directs,
  'proxyRules': instance.proxyRules.map((e) => e.toJson()).toList(),
  'bypassSimpleHostnames': instance.bypassSimpleHostnames,
  'removeImplicitRules': instance.removeImplicitRules,
  'reverseBypassEnabled': instance.reverseBypassEnabled,
};
