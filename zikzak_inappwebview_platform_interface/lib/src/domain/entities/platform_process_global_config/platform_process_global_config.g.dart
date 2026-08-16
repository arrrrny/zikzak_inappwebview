// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_process_global_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessGlobalConfigSettings _$ProcessGlobalConfigSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ProcessGlobalConfigSettings', json, ($checkedConvert) {
  final val = ProcessGlobalConfigSettings(
    dataDirectorySuffix: $checkedConvert(
      'dataDirectorySuffix',
      (v) => v as String?,
    ),
    directoryBasePaths: $checkedConvert(
      'directoryBasePaths',
      (v) => v == null
          ? null
          : ProcessGlobalConfigDirectoryBasePaths.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
  );
  return val;
});

Map<String, dynamic> _$ProcessGlobalConfigSettingsToJson(
  ProcessGlobalConfigSettings instance,
) => <String, dynamic>{
  'dataDirectorySuffix': instance.dataDirectorySuffix,
  'directoryBasePaths': instance.directoryBasePaths?.toJson(),
};

ProcessGlobalConfigDirectoryBasePaths
_$ProcessGlobalConfigDirectoryBasePathsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProcessGlobalConfigDirectoryBasePaths', json, (
      $checkedConvert,
    ) {
      final val = ProcessGlobalConfigDirectoryBasePaths(
        dataDirectoryBasePath: $checkedConvert(
          'dataDirectoryBasePath',
          (v) => v as String,
        ),
        cacheDirectoryBasePath: $checkedConvert(
          'cacheDirectoryBasePath',
          (v) => v as String,
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProcessGlobalConfigDirectoryBasePathsToJson(
  ProcessGlobalConfigDirectoryBasePaths instance,
) => <String, dynamic>{
  'dataDirectoryBasePath': instance.dataDirectoryBasePath,
  'cacheDirectoryBasePath': instance.cacheDirectoryBasePath,
};
