// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'platform_process_global_config.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ProcessGlobalConfigSettings {
  ProcessGlobalConfigSettings({
    String? this.dataDirectorySuffix,
    ProcessGlobalConfigDirectoryBasePaths? this.directoryBasePaths,
  });

  factory ProcessGlobalConfigSettings.fromJson(Map<String, dynamic> json) =>
      _$ProcessGlobalConfigSettingsFromJson(json);

  final String? dataDirectorySuffix;

  final ProcessGlobalConfigDirectoryBasePaths? directoryBasePaths;

  ProcessGlobalConfigSettings copyWith({
    String? dataDirectorySuffix,
    ProcessGlobalConfigDirectoryBasePaths? directoryBasePaths,
  }) {
    return ProcessGlobalConfigSettings(
      dataDirectorySuffix: dataDirectorySuffix ?? this.dataDirectorySuffix,
      directoryBasePaths: directoryBasePaths ?? this.directoryBasePaths,
    );
  }

  ProcessGlobalConfigSettings copyWithProcessGlobalConfigSettings({
    String? dataDirectorySuffix,
    ProcessGlobalConfigDirectoryBasePaths? directoryBasePaths,
  }) {
    return copyWith(
      dataDirectorySuffix: dataDirectorySuffix,
      directoryBasePaths: directoryBasePaths,
    );
  }

  ProcessGlobalConfigSettings patchWithProcessGlobalConfigSettings([
    ProcessGlobalConfigSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? ProcessGlobalConfigSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return ProcessGlobalConfigSettings(
      dataDirectorySuffix:
          _patchMap.containsKey(
            ProcessGlobalConfigSettings$.dataDirectorySuffix,
          )
          ? ((_patchMap[ProcessGlobalConfigSettings$.dataDirectorySuffix]
                        is Function)
                    ? _patchMap[ProcessGlobalConfigSettings$
                          .dataDirectorySuffix](this.dataDirectorySuffix)
                    : (_patchMap[ProcessGlobalConfigSettings$
                              .dataDirectorySuffix]
                          is Patch)
                    ? _patchMap[ProcessGlobalConfigSettings$
                              .dataDirectorySuffix]
                          .applyTo(this.dataDirectorySuffix)
                    : _patchMap[ProcessGlobalConfigSettings$
                          .dataDirectorySuffix])
                as String?
          : this.dataDirectorySuffix,
      directoryBasePaths:
          _patchMap.containsKey(ProcessGlobalConfigSettings$.directoryBasePaths)
          ? ((_patchMap[ProcessGlobalConfigSettings$.directoryBasePaths]
                        is Function)
                    ? _patchMap[ProcessGlobalConfigSettings$
                          .directoryBasePaths](this.directoryBasePaths)
                    : (_patchMap[ProcessGlobalConfigSettings$
                              .directoryBasePaths]
                          is Patch)
                    ? _patchMap[ProcessGlobalConfigSettings$.directoryBasePaths]
                          .applyTo(this.directoryBasePaths)
                    : _patchMap[ProcessGlobalConfigSettings$
                          .directoryBasePaths])
                as ProcessGlobalConfigDirectoryBasePaths?
          : this.directoryBasePaths,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProcessGlobalConfigSettings &&
        dataDirectorySuffix == other.dataDirectorySuffix &&
        directoryBasePaths == other.directoryBasePaths;
  }

  @override
  int get hashCode {
    return Object.hash(this.dataDirectorySuffix, this.directoryBasePaths);
  }

  @override
  String toString() {
    return 'ProcessGlobalConfigSettings(' +
        'dataDirectorySuffix: ${dataDirectorySuffix}' +
        ', ' +
        'directoryBasePaths: ${directoryBasePaths})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ProcessGlobalConfigSettingsToJson(this);
    _sanitizeJson(data);
    return data;
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension ProcessGlobalConfigSettingsPropertyHelpers
    on ProcessGlobalConfigSettings {
  bool get hasDataDirectorySuffix {
    return this.dataDirectorySuffix?.isNotEmpty == true;
  }

  bool get noDataDirectorySuffix {
    return this.dataDirectorySuffix?.isEmpty ?? true;
  }

  String get dataDirectorySuffixRequired {
    return this.dataDirectorySuffix ??
        (throw StateError('dataDirectorySuffix is required but was null'));
  }

  bool get hasDirectoryBasePaths {
    return this.directoryBasePaths != null;
  }

  bool get noDirectoryBasePaths {
    return this.directoryBasePaths == null;
  }

  ProcessGlobalConfigDirectoryBasePaths get directoryBasePathsRequired {
    return this.directoryBasePaths ??
        (throw StateError('directoryBasePaths is required but was null'));
  }
}

extension ProcessGlobalConfigSettingsSerialization
    on ProcessGlobalConfigSettings {
  Map<String, dynamic> toJson() {
    return _$ProcessGlobalConfigSettingsToJson(this);
  }
}

enum ProcessGlobalConfigSettings$ { dataDirectorySuffix, directoryBasePaths }

class ProcessGlobalConfigSettingsPatch
    extends
        PatchBase<ProcessGlobalConfigSettings, ProcessGlobalConfigSettings$> {
  ProcessGlobalConfigSettings applyTo(ProcessGlobalConfigSettings entity) {
    return entity.patchWithProcessGlobalConfigSettings(this);
  }

  ProcessGlobalConfigSettingsPatch withDataDirectorySuffix(String? value) {
    patchMap[ProcessGlobalConfigSettings$.dataDirectorySuffix] = value;
    return this;
  }

  ProcessGlobalConfigSettingsPatch withDirectoryBasePaths(
    ProcessGlobalConfigDirectoryBasePaths? value,
  ) {
    patchMap[ProcessGlobalConfigSettings$.directoryBasePaths] = value;
    return this;
  }

  ProcessGlobalConfigSettingsPatch withDirectoryBasePathsPatch(
    ProcessGlobalConfigDirectoryBasePathsPatch patch,
  ) {
    patchMap[ProcessGlobalConfigSettings$.directoryBasePaths] = patch;
    return this;
  }

  ProcessGlobalConfigSettingsPatch withDirectoryBasePathsPatchFunc(
    ProcessGlobalConfigDirectoryBasePathsPatch Function(
      ProcessGlobalConfigDirectoryBasePathsPatch,
    )
    patch,
  ) {
    patchMap[ProcessGlobalConfigSettings$.directoryBasePaths] =
        (dynamic current) {
          var currentPatch = ProcessGlobalConfigDirectoryBasePathsPatch();
          return patch(
            currentPatch,
          ).applyTo(current as ProcessGlobalConfigDirectoryBasePaths);
        };
    return this;
  }
}

/// Field descriptors for [ProcessGlobalConfigSettings] query construction
abstract final class ProcessGlobalConfigSettingsFields {
  static const dataDirectorySuffix =
      Field<ProcessGlobalConfigSettings, String?>(
        'dataDirectorySuffix',
        _$dataDirectorySuffix,
      );

  static const directoryBasePaths =
      Field<
        ProcessGlobalConfigSettings,
        ProcessGlobalConfigDirectoryBasePaths?
      >('directoryBasePaths', _$directoryBasePaths);

  static String? _$dataDirectorySuffix(ProcessGlobalConfigSettings e) {
    return e.dataDirectorySuffix;
  }

  static ProcessGlobalConfigDirectoryBasePaths? _$directoryBasePaths(
    ProcessGlobalConfigSettings e,
  ) {
    return e.directoryBasePaths;
  }
}

extension ProcessGlobalConfigSettingsCompareE on ProcessGlobalConfigSettings {
  Map<String, dynamic> compareToProcessGlobalConfigSettings(
    ProcessGlobalConfigSettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (dataDirectorySuffix != other.dataDirectorySuffix) {
      diff['dataDirectorySuffix'] = () => other.dataDirectorySuffix;
    }

    if (directoryBasePaths != other.directoryBasePaths) {
      diff['directoryBasePaths'] = () => other.directoryBasePaths;
    }
    return diff;
  }
}

@JsonSerializable(explicitToJson: true, checked: true)
class ProcessGlobalConfigDirectoryBasePaths {
  ProcessGlobalConfigDirectoryBasePaths({
    required String this.dataDirectoryBasePath,
    required String this.cacheDirectoryBasePath,
  });

  factory ProcessGlobalConfigDirectoryBasePaths.fromJson(
    Map<String, dynamic> json,
  ) => _$ProcessGlobalConfigDirectoryBasePathsFromJson(json);

  final String dataDirectoryBasePath;

  final String cacheDirectoryBasePath;

  ProcessGlobalConfigDirectoryBasePaths copyWith({
    String? dataDirectoryBasePath,
    String? cacheDirectoryBasePath,
  }) {
    return ProcessGlobalConfigDirectoryBasePaths(
      dataDirectoryBasePath:
          dataDirectoryBasePath ?? this.dataDirectoryBasePath,
      cacheDirectoryBasePath:
          cacheDirectoryBasePath ?? this.cacheDirectoryBasePath,
    );
  }

  ProcessGlobalConfigDirectoryBasePaths
  copyWithProcessGlobalConfigDirectoryBasePaths({
    String? dataDirectoryBasePath,
    String? cacheDirectoryBasePath,
  }) {
    return copyWith(
      dataDirectoryBasePath: dataDirectoryBasePath,
      cacheDirectoryBasePath: cacheDirectoryBasePath,
    );
  }

  ProcessGlobalConfigDirectoryBasePaths
  patchWithProcessGlobalConfigDirectoryBasePaths([
    ProcessGlobalConfigDirectoryBasePathsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? ProcessGlobalConfigDirectoryBasePathsPatch();
    final _patchMap = _patcher.patchMap;
    return ProcessGlobalConfigDirectoryBasePaths(
      dataDirectoryBasePath:
          _patchMap.containsKey(
            ProcessGlobalConfigDirectoryBasePaths$.dataDirectoryBasePath,
          )
          ? ((_patchMap[ProcessGlobalConfigDirectoryBasePaths$
                            .dataDirectoryBasePath]
                        is Function)
                    ? _patchMap[ProcessGlobalConfigDirectoryBasePaths$
                          .dataDirectoryBasePath](this.dataDirectoryBasePath)
                    : (_patchMap[ProcessGlobalConfigDirectoryBasePaths$
                              .dataDirectoryBasePath]
                          is Patch)
                    ? _patchMap[ProcessGlobalConfigDirectoryBasePaths$
                              .dataDirectoryBasePath]
                          .applyTo(this.dataDirectoryBasePath)
                    : _patchMap[ProcessGlobalConfigDirectoryBasePaths$
                          .dataDirectoryBasePath])
                as String
          : this.dataDirectoryBasePath,
      cacheDirectoryBasePath:
          _patchMap.containsKey(
            ProcessGlobalConfigDirectoryBasePaths$.cacheDirectoryBasePath,
          )
          ? ((_patchMap[ProcessGlobalConfigDirectoryBasePaths$
                            .cacheDirectoryBasePath]
                        is Function)
                    ? _patchMap[ProcessGlobalConfigDirectoryBasePaths$
                          .cacheDirectoryBasePath](this.cacheDirectoryBasePath)
                    : (_patchMap[ProcessGlobalConfigDirectoryBasePaths$
                              .cacheDirectoryBasePath]
                          is Patch)
                    ? _patchMap[ProcessGlobalConfigDirectoryBasePaths$
                              .cacheDirectoryBasePath]
                          .applyTo(this.cacheDirectoryBasePath)
                    : _patchMap[ProcessGlobalConfigDirectoryBasePaths$
                          .cacheDirectoryBasePath])
                as String
          : this.cacheDirectoryBasePath,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProcessGlobalConfigDirectoryBasePaths &&
        dataDirectoryBasePath == other.dataDirectoryBasePath &&
        cacheDirectoryBasePath == other.cacheDirectoryBasePath;
  }

  @override
  int get hashCode {
    return Object.hash(this.dataDirectoryBasePath, this.cacheDirectoryBasePath);
  }

  @override
  String toString() {
    return 'ProcessGlobalConfigDirectoryBasePaths(' +
        'dataDirectoryBasePath: ${dataDirectoryBasePath}' +
        ', ' +
        'cacheDirectoryBasePath: ${cacheDirectoryBasePath})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data =
        _$ProcessGlobalConfigDirectoryBasePathsToJson(this);
    _sanitizeJson(data);
    return data;
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension ProcessGlobalConfigDirectoryBasePathsPropertyHelpers
    on ProcessGlobalConfigDirectoryBasePaths {
  bool get hasDataDirectoryBasePath {
    return this.dataDirectoryBasePath.isNotEmpty;
  }

  bool get noDataDirectoryBasePath {
    return this.dataDirectoryBasePath.isEmpty;
  }

  bool get hasCacheDirectoryBasePath {
    return this.cacheDirectoryBasePath.isNotEmpty;
  }

  bool get noCacheDirectoryBasePath {
    return this.cacheDirectoryBasePath.isEmpty;
  }
}

extension ProcessGlobalConfigDirectoryBasePathsSerialization
    on ProcessGlobalConfigDirectoryBasePaths {
  Map<String, dynamic> toJson() {
    return _$ProcessGlobalConfigDirectoryBasePathsToJson(this);
  }
}

enum ProcessGlobalConfigDirectoryBasePaths$ {
  dataDirectoryBasePath,
  cacheDirectoryBasePath,
}

class ProcessGlobalConfigDirectoryBasePathsPatch
    extends
        PatchBase<
          ProcessGlobalConfigDirectoryBasePaths,
          ProcessGlobalConfigDirectoryBasePaths$
        > {
  ProcessGlobalConfigDirectoryBasePaths applyTo(
    ProcessGlobalConfigDirectoryBasePaths entity,
  ) {
    return entity.patchWithProcessGlobalConfigDirectoryBasePaths(this);
  }

  ProcessGlobalConfigDirectoryBasePathsPatch withDataDirectoryBasePath(
    String? value,
  ) {
    patchMap[ProcessGlobalConfigDirectoryBasePaths$.dataDirectoryBasePath] =
        value;
    return this;
  }

  ProcessGlobalConfigDirectoryBasePathsPatch withCacheDirectoryBasePath(
    String? value,
  ) {
    patchMap[ProcessGlobalConfigDirectoryBasePaths$.cacheDirectoryBasePath] =
        value;
    return this;
  }
}

/// Field descriptors for [ProcessGlobalConfigDirectoryBasePaths] query construction
abstract final class ProcessGlobalConfigDirectoryBasePathsFields {
  static const dataDirectoryBasePath =
      Field<ProcessGlobalConfigDirectoryBasePaths, String>(
        'dataDirectoryBasePath',
        _$dataDirectoryBasePath,
      );

  static const cacheDirectoryBasePath =
      Field<ProcessGlobalConfigDirectoryBasePaths, String>(
        'cacheDirectoryBasePath',
        _$cacheDirectoryBasePath,
      );

  static String _$dataDirectoryBasePath(
    ProcessGlobalConfigDirectoryBasePaths e,
  ) {
    return e.dataDirectoryBasePath;
  }

  static String _$cacheDirectoryBasePath(
    ProcessGlobalConfigDirectoryBasePaths e,
  ) {
    return e.cacheDirectoryBasePath;
  }
}

extension ProcessGlobalConfigDirectoryBasePathsCompareE
    on ProcessGlobalConfigDirectoryBasePaths {
  Map<String, dynamic> compareToProcessGlobalConfigDirectoryBasePaths(
    ProcessGlobalConfigDirectoryBasePaths other,
  ) {
    final Map<String, dynamic> diff = {};

    if (dataDirectoryBasePath != other.dataDirectoryBasePath) {
      diff['dataDirectoryBasePath'] = () => other.dataDirectoryBasePath;
    }

    if (cacheDirectoryBasePath != other.cacheDirectoryBasePath) {
      diff['cacheDirectoryBasePath'] = () => other.cacheDirectoryBasePath;
    }
    return diff;
  }
}
