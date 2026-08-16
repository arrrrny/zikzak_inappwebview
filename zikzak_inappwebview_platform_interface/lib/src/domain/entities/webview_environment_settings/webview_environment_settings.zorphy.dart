// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'webview_environment_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class VirtualHostMapping {
  VirtualHostMapping({
    required String this.hostName,
    required String this.folderPath,
    HostResourceAccessKind? accessKind,
  }) : this.accessKind = accessKind ?? HostResourceAccessKind.allow;

  factory VirtualHostMapping.fromJson(Map<String, dynamic> json) =>
      _$VirtualHostMappingFromJson(json);

  @JsonKey(toJson: _hostNameToJson, fromJson: _hostNameFromJson)
  final String hostName;

  @JsonKey(toJson: _folderPathToJson, fromJson: _folderPathFromJson)
  final String folderPath;

  @JsonKey(
    defaultValue: HostResourceAccessKind.allow,
    toJson: _accessKindToJson,
    fromJson: _accessKindFromJson,
  )
  final HostResourceAccessKind accessKind;

  VirtualHostMapping copyWith({
    String? hostName,
    String? folderPath,
    HostResourceAccessKind? accessKind,
  }) {
    return VirtualHostMapping(
      hostName: hostName ?? this.hostName,
      folderPath: folderPath ?? this.folderPath,
      accessKind: accessKind ?? this.accessKind,
    );
  }

  VirtualHostMapping copyWithVirtualHostMapping({
    String? hostName,
    String? folderPath,
    HostResourceAccessKind? accessKind,
  }) {
    return copyWith(
      hostName: hostName,
      folderPath: folderPath,
      accessKind: accessKind,
    );
  }

  VirtualHostMapping patchWithVirtualHostMapping([
    VirtualHostMappingPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? VirtualHostMappingPatch();
    final _patchMap = _patcher.patchMap;
    return VirtualHostMapping(
      hostName: _patchMap.containsKey(VirtualHostMapping$.hostName)
          ? (_patchMap[VirtualHostMapping$.hostName] is Function)
                ? _patchMap[VirtualHostMapping$.hostName](this.hostName)
                : (_patchMap[VirtualHostMapping$.hostName] is Patch)
                ? _patchMap[VirtualHostMapping$.hostName].applyTo(this.hostName)
                : _patchMap[VirtualHostMapping$.hostName]
          : this.hostName,
      folderPath: _patchMap.containsKey(VirtualHostMapping$.folderPath)
          ? (_patchMap[VirtualHostMapping$.folderPath] is Function)
                ? _patchMap[VirtualHostMapping$.folderPath](this.folderPath)
                : (_patchMap[VirtualHostMapping$.folderPath] is Patch)
                ? _patchMap[VirtualHostMapping$.folderPath].applyTo(
                    this.folderPath,
                  )
                : _patchMap[VirtualHostMapping$.folderPath]
          : this.folderPath,
      accessKind: _patchMap.containsKey(VirtualHostMapping$.accessKind)
          ? (_patchMap[VirtualHostMapping$.accessKind] is Function)
                ? _patchMap[VirtualHostMapping$.accessKind](this.accessKind)
                : (_patchMap[VirtualHostMapping$.accessKind] is Patch)
                ? _patchMap[VirtualHostMapping$.accessKind].applyTo(
                    this.accessKind,
                  )
                : _patchMap[VirtualHostMapping$.accessKind]
          : this.accessKind,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VirtualHostMapping &&
        hostName == other.hostName &&
        folderPath == other.folderPath &&
        accessKind == other.accessKind;
  }

  @override
  int get hashCode {
    return Object.hash(this.hostName, this.folderPath, this.accessKind);
  }

  @override
  String toString() {
    return 'VirtualHostMapping(' +
        'hostName: ${hostName}' +
        ', ' +
        'folderPath: ${folderPath}' +
        ', ' +
        'accessKind: ${accessKind})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$VirtualHostMappingToJson(this);
    return _sanitizeJson(data);
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

extension VirtualHostMappingPropertyHelpers on VirtualHostMapping {
  bool get hasHostName {
    return this.hostName.isNotEmpty;
  }

  bool get noHostName {
    return this.hostName.isEmpty;
  }

  bool get hasFolderPath {
    return this.folderPath.isNotEmpty;
  }

  bool get noFolderPath {
    return this.folderPath.isEmpty;
  }

  bool get isAccessKindDeny {
    return this.accessKind == HostResourceAccessKind.deny;
  }

  bool get isAccessKindAllow {
    return this.accessKind == HostResourceAccessKind.allow;
  }

  bool get isAccessKindAllowCors {
    return this.accessKind == HostResourceAccessKind.allowCors;
  }
}

extension VirtualHostMappingSerialization on VirtualHostMapping {
  Map<String, dynamic> toJson() {
    return _$VirtualHostMappingToJson(this);
  }
}

enum VirtualHostMapping$ { hostName, folderPath, accessKind }

class VirtualHostMappingPatch
    extends PatchBase<VirtualHostMapping, VirtualHostMapping$> {
  VirtualHostMapping applyTo(VirtualHostMapping entity) {
    return entity.patchWithVirtualHostMapping(this);
  }

  VirtualHostMappingPatch withHostName(String? value) {
    patchMap[VirtualHostMapping$.hostName] = value;
    return this;
  }

  VirtualHostMappingPatch withFolderPath(String? value) {
    patchMap[VirtualHostMapping$.folderPath] = value;
    return this;
  }

  VirtualHostMappingPatch withAccessKind(HostResourceAccessKind? value) {
    patchMap[VirtualHostMapping$.accessKind] = value;
    return this;
  }
}

/// Field descriptors for [VirtualHostMapping] query construction
abstract final class VirtualHostMappingFields {
  static const hostName = Field<VirtualHostMapping, String>(
    'hostName',
    _$hostName,
  );

  static const folderPath = Field<VirtualHostMapping, String>(
    'folderPath',
    _$folderPath,
  );

  static const accessKind = Field<VirtualHostMapping, HostResourceAccessKind>(
    'accessKind',
    _$accessKind,
  );

  static String _$hostName(VirtualHostMapping e) {
    return e.hostName;
  }

  static String _$folderPath(VirtualHostMapping e) {
    return e.folderPath;
  }

  static HostResourceAccessKind _$accessKind(VirtualHostMapping e) {
    return e.accessKind;
  }
}

extension VirtualHostMappingCompareE on VirtualHostMapping {
  Map<String, dynamic> compareToVirtualHostMapping(VirtualHostMapping other) {
    final Map<String, dynamic> diff = {};

    if (hostName != other.hostName) {
      diff['hostName'] = () => other.hostName;
    }

    if (folderPath != other.folderPath) {
      diff['folderPath'] = () => other.folderPath;
    }

    if (accessKind != other.accessKind) {
      diff['accessKind'] = () => other.accessKind;
    }
    return diff;
  }
}

@JsonSerializable(explicitToJson: true, checked: true)
class WebViewEnvironmentSettings {
  WebViewEnvironmentSettings({
    String? this.browserExecutableFolder,
    String? this.userDataFolder,
    String? this.additionalBrowserArguments,
    bool? this.allowSingleSignOnUsingOSPrimaryAccount,
    String? this.language,
    String? this.targetCompatibleBrowserVersion,
    List<VirtualHostMapping>? this.virtualHostMappings,
  });

  factory WebViewEnvironmentSettings.fromJson(Map<String, dynamic> json) =>
      _$WebViewEnvironmentSettingsFromJson(json);

  final String? browserExecutableFolder;

  final String? userDataFolder;

  final String? additionalBrowserArguments;

  final bool? allowSingleSignOnUsingOSPrimaryAccount;

  final String? language;

  final String? targetCompatibleBrowserVersion;

  @JsonKey(
    toJson: _virtualHostMappingsToJson,
    fromJson: _virtualHostMappingsFromJson,
  )
  final List<VirtualHostMapping>? virtualHostMappings;

  WebViewEnvironmentSettings copyWith({
    String? browserExecutableFolder,
    String? userDataFolder,
    String? additionalBrowserArguments,
    bool? allowSingleSignOnUsingOSPrimaryAccount,
    String? language,
    String? targetCompatibleBrowserVersion,
    List<VirtualHostMapping>? virtualHostMappings,
  }) {
    return WebViewEnvironmentSettings(
      browserExecutableFolder:
          browserExecutableFolder ?? this.browserExecutableFolder,
      userDataFolder: userDataFolder ?? this.userDataFolder,
      additionalBrowserArguments:
          additionalBrowserArguments ?? this.additionalBrowserArguments,
      allowSingleSignOnUsingOSPrimaryAccount:
          allowSingleSignOnUsingOSPrimaryAccount ??
          this.allowSingleSignOnUsingOSPrimaryAccount,
      language: language ?? this.language,
      targetCompatibleBrowserVersion:
          targetCompatibleBrowserVersion ?? this.targetCompatibleBrowserVersion,
      virtualHostMappings: virtualHostMappings ?? this.virtualHostMappings,
    );
  }

  WebViewEnvironmentSettings copyWithWebViewEnvironmentSettings({
    String? browserExecutableFolder,
    String? userDataFolder,
    String? additionalBrowserArguments,
    bool? allowSingleSignOnUsingOSPrimaryAccount,
    String? language,
    String? targetCompatibleBrowserVersion,
    List<VirtualHostMapping>? virtualHostMappings,
  }) {
    return copyWith(
      browserExecutableFolder: browserExecutableFolder,
      userDataFolder: userDataFolder,
      additionalBrowserArguments: additionalBrowserArguments,
      allowSingleSignOnUsingOSPrimaryAccount:
          allowSingleSignOnUsingOSPrimaryAccount,
      language: language,
      targetCompatibleBrowserVersion: targetCompatibleBrowserVersion,
      virtualHostMappings: virtualHostMappings,
    );
  }

  WebViewEnvironmentSettings patchWithWebViewEnvironmentSettings([
    WebViewEnvironmentSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebViewEnvironmentSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return WebViewEnvironmentSettings(
      browserExecutableFolder:
          _patchMap.containsKey(
            WebViewEnvironmentSettings$.browserExecutableFolder,
          )
          ? (_patchMap[WebViewEnvironmentSettings$.browserExecutableFolder]
                    is Function)
                ? _patchMap[WebViewEnvironmentSettings$
                      .browserExecutableFolder](this.browserExecutableFolder)
                : (_patchMap[WebViewEnvironmentSettings$
                          .browserExecutableFolder]
                      is Patch)
                ? _patchMap[WebViewEnvironmentSettings$.browserExecutableFolder]
                      .applyTo(this.browserExecutableFolder)
                : _patchMap[WebViewEnvironmentSettings$.browserExecutableFolder]
          : this.browserExecutableFolder,
      userDataFolder:
          _patchMap.containsKey(WebViewEnvironmentSettings$.userDataFolder)
          ? (_patchMap[WebViewEnvironmentSettings$.userDataFolder] is Function)
                ? _patchMap[WebViewEnvironmentSettings$.userDataFolder](
                    this.userDataFolder,
                  )
                : (_patchMap[WebViewEnvironmentSettings$.userDataFolder]
                      is Patch)
                ? _patchMap[WebViewEnvironmentSettings$.userDataFolder].applyTo(
                    this.userDataFolder,
                  )
                : _patchMap[WebViewEnvironmentSettings$.userDataFolder]
          : this.userDataFolder,
      additionalBrowserArguments:
          _patchMap.containsKey(
            WebViewEnvironmentSettings$.additionalBrowserArguments,
          )
          ? (_patchMap[WebViewEnvironmentSettings$.additionalBrowserArguments]
                    is Function)
                ? _patchMap[WebViewEnvironmentSettings$
                      .additionalBrowserArguments](
                    this.additionalBrowserArguments,
                  )
                : (_patchMap[WebViewEnvironmentSettings$
                          .additionalBrowserArguments]
                      is Patch)
                ? _patchMap[WebViewEnvironmentSettings$
                          .additionalBrowserArguments]
                      .applyTo(this.additionalBrowserArguments)
                : _patchMap[WebViewEnvironmentSettings$
                      .additionalBrowserArguments]
          : this.additionalBrowserArguments,
      allowSingleSignOnUsingOSPrimaryAccount:
          _patchMap.containsKey(
            WebViewEnvironmentSettings$.allowSingleSignOnUsingOSPrimaryAccount,
          )
          ? (_patchMap[WebViewEnvironmentSettings$
                        .allowSingleSignOnUsingOSPrimaryAccount]
                    is Function)
                ? _patchMap[WebViewEnvironmentSettings$
                      .allowSingleSignOnUsingOSPrimaryAccount](
                    this.allowSingleSignOnUsingOSPrimaryAccount,
                  )
                : (_patchMap[WebViewEnvironmentSettings$
                          .allowSingleSignOnUsingOSPrimaryAccount]
                      is Patch)
                ? _patchMap[WebViewEnvironmentSettings$
                          .allowSingleSignOnUsingOSPrimaryAccount]
                      .applyTo(this.allowSingleSignOnUsingOSPrimaryAccount)
                : _patchMap[WebViewEnvironmentSettings$
                      .allowSingleSignOnUsingOSPrimaryAccount]
          : this.allowSingleSignOnUsingOSPrimaryAccount,
      language: _patchMap.containsKey(WebViewEnvironmentSettings$.language)
          ? (_patchMap[WebViewEnvironmentSettings$.language] is Function)
                ? _patchMap[WebViewEnvironmentSettings$.language](this.language)
                : (_patchMap[WebViewEnvironmentSettings$.language] is Patch)
                ? _patchMap[WebViewEnvironmentSettings$.language].applyTo(
                    this.language,
                  )
                : _patchMap[WebViewEnvironmentSettings$.language]
          : this.language,
      targetCompatibleBrowserVersion:
          _patchMap.containsKey(
            WebViewEnvironmentSettings$.targetCompatibleBrowserVersion,
          )
          ? (_patchMap[WebViewEnvironmentSettings$
                        .targetCompatibleBrowserVersion]
                    is Function)
                ? _patchMap[WebViewEnvironmentSettings$
                      .targetCompatibleBrowserVersion](
                    this.targetCompatibleBrowserVersion,
                  )
                : (_patchMap[WebViewEnvironmentSettings$
                          .targetCompatibleBrowserVersion]
                      is Patch)
                ? _patchMap[WebViewEnvironmentSettings$
                          .targetCompatibleBrowserVersion]
                      .applyTo(this.targetCompatibleBrowserVersion)
                : _patchMap[WebViewEnvironmentSettings$
                      .targetCompatibleBrowserVersion]
          : this.targetCompatibleBrowserVersion,
      virtualHostMappings:
          _patchMap.containsKey(WebViewEnvironmentSettings$.virtualHostMappings)
          ? (_patchMap[WebViewEnvironmentSettings$.virtualHostMappings]
                    is Function)
                ? _patchMap[WebViewEnvironmentSettings$.virtualHostMappings](
                    this.virtualHostMappings,
                  )
                : (_patchMap[WebViewEnvironmentSettings$.virtualHostMappings]
                      is Patch)
                ? _patchMap[WebViewEnvironmentSettings$.virtualHostMappings]
                      .applyTo(this.virtualHostMappings)
                : _patchMap[WebViewEnvironmentSettings$.virtualHostMappings]
          : this.virtualHostMappings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebViewEnvironmentSettings &&
        browserExecutableFolder == other.browserExecutableFolder &&
        userDataFolder == other.userDataFolder &&
        additionalBrowserArguments == other.additionalBrowserArguments &&
        allowSingleSignOnUsingOSPrimaryAccount ==
            other.allowSingleSignOnUsingOSPrimaryAccount &&
        language == other.language &&
        targetCompatibleBrowserVersion ==
            other.targetCompatibleBrowserVersion &&
        virtualHostMappings == other.virtualHostMappings;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.browserExecutableFolder,
      this.userDataFolder,
      this.additionalBrowserArguments,
      this.allowSingleSignOnUsingOSPrimaryAccount,
      this.language,
      this.targetCompatibleBrowserVersion,
      this.virtualHostMappings,
    );
  }

  @override
  String toString() {
    return 'WebViewEnvironmentSettings(' +
        'browserExecutableFolder: ${browserExecutableFolder}' +
        ', ' +
        'userDataFolder: ${userDataFolder}' +
        ', ' +
        'additionalBrowserArguments: ${additionalBrowserArguments}' +
        ', ' +
        'allowSingleSignOnUsingOSPrimaryAccount: ${allowSingleSignOnUsingOSPrimaryAccount}' +
        ', ' +
        'language: ${language}' +
        ', ' +
        'targetCompatibleBrowserVersion: ${targetCompatibleBrowserVersion}' +
        ', ' +
        'virtualHostMappings: ${virtualHostMappings})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebViewEnvironmentSettingsToJson(this);
    return _sanitizeJson(data);
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

extension WebViewEnvironmentSettingsPropertyHelpers
    on WebViewEnvironmentSettings {
  bool get hasBrowserExecutableFolder {
    return this.browserExecutableFolder?.isNotEmpty == true;
  }

  bool get noBrowserExecutableFolder {
    return this.browserExecutableFolder?.isEmpty ?? true;
  }

  String get browserExecutableFolderRequired {
    return this.browserExecutableFolder ??
        (throw StateError('browserExecutableFolder is required but was null'));
  }

  bool get hasUserDataFolder {
    return this.userDataFolder?.isNotEmpty == true;
  }

  bool get noUserDataFolder {
    return this.userDataFolder?.isEmpty ?? true;
  }

  String get userDataFolderRequired {
    return this.userDataFolder ??
        (throw StateError('userDataFolder is required but was null'));
  }

  bool get hasAdditionalBrowserArguments {
    return this.additionalBrowserArguments?.isNotEmpty == true;
  }

  bool get noAdditionalBrowserArguments {
    return this.additionalBrowserArguments?.isEmpty ?? true;
  }

  String get additionalBrowserArgumentsRequired {
    return this.additionalBrowserArguments ??
        (throw StateError(
          'additionalBrowserArguments is required but was null',
        ));
  }

  bool get hasAllowSingleSignOnUsingOSPrimaryAccount {
    return this.allowSingleSignOnUsingOSPrimaryAccount != null;
  }

  bool get noAllowSingleSignOnUsingOSPrimaryAccount {
    return this.allowSingleSignOnUsingOSPrimaryAccount == null;
  }

  bool get allowSingleSignOnUsingOSPrimaryAccountRequired {
    return this.allowSingleSignOnUsingOSPrimaryAccount ??
        (throw StateError(
          'allowSingleSignOnUsingOSPrimaryAccount is required but was null',
        ));
  }

  bool get hasLanguage {
    return this.language?.isNotEmpty == true;
  }

  bool get noLanguage {
    return this.language?.isEmpty ?? true;
  }

  String get languageRequired {
    return this.language ??
        (throw StateError('language is required but was null'));
  }

  bool get hasTargetCompatibleBrowserVersion {
    return this.targetCompatibleBrowserVersion?.isNotEmpty == true;
  }

  bool get noTargetCompatibleBrowserVersion {
    return this.targetCompatibleBrowserVersion?.isEmpty ?? true;
  }

  String get targetCompatibleBrowserVersionRequired {
    return this.targetCompatibleBrowserVersion ??
        (throw StateError(
          'targetCompatibleBrowserVersion is required but was null',
        ));
  }

  List<VirtualHostMapping> get virtualHostMappingsRequired {
    return this.virtualHostMappings ??
        (throw StateError('virtualHostMappings is required but was null'));
  }

  bool get hasVirtualHostMappings {
    return this.virtualHostMappings?.isNotEmpty ?? false;
  }

  bool get noVirtualHostMappings {
    return this.virtualHostMappings?.isEmpty ?? true;
  }
}

extension WebViewEnvironmentSettingsSerialization
    on WebViewEnvironmentSettings {
  Map<String, dynamic> toJson() {
    return _$WebViewEnvironmentSettingsToJson(this);
  }
}

enum WebViewEnvironmentSettings$ {
  browserExecutableFolder,
  userDataFolder,
  additionalBrowserArguments,
  allowSingleSignOnUsingOSPrimaryAccount,
  language,
  targetCompatibleBrowserVersion,
  virtualHostMappings,
}

class WebViewEnvironmentSettingsPatch
    extends PatchBase<WebViewEnvironmentSettings, WebViewEnvironmentSettings$> {
  WebViewEnvironmentSettings applyTo(WebViewEnvironmentSettings entity) {
    return entity.patchWithWebViewEnvironmentSettings(this);
  }

  WebViewEnvironmentSettingsPatch withBrowserExecutableFolder(String? value) {
    patchMap[WebViewEnvironmentSettings$.browserExecutableFolder] = value;
    return this;
  }

  WebViewEnvironmentSettingsPatch withUserDataFolder(String? value) {
    patchMap[WebViewEnvironmentSettings$.userDataFolder] = value;
    return this;
  }

  WebViewEnvironmentSettingsPatch withAdditionalBrowserArguments(
    String? value,
  ) {
    patchMap[WebViewEnvironmentSettings$.additionalBrowserArguments] = value;
    return this;
  }

  WebViewEnvironmentSettingsPatch withAllowSingleSignOnUsingOSPrimaryAccount(
    bool? value,
  ) {
    patchMap[WebViewEnvironmentSettings$
            .allowSingleSignOnUsingOSPrimaryAccount] =
        value;
    return this;
  }

  WebViewEnvironmentSettingsPatch withLanguage(String? value) {
    patchMap[WebViewEnvironmentSettings$.language] = value;
    return this;
  }

  WebViewEnvironmentSettingsPatch withTargetCompatibleBrowserVersion(
    String? value,
  ) {
    patchMap[WebViewEnvironmentSettings$.targetCompatibleBrowserVersion] =
        value;
    return this;
  }

  WebViewEnvironmentSettingsPatch withVirtualHostMappings(
    List<VirtualHostMapping>? value,
  ) {
    patchMap[WebViewEnvironmentSettings$.virtualHostMappings] = value;
    return this;
  }

  WebViewEnvironmentSettingsPatch updateVirtualHostMappingsAt(
    int index,
    VirtualHostMappingPatch Function(VirtualHostMappingPatch) patch,
  ) {
    patchMap[WebViewEnvironmentSettings$.virtualHostMappings] =
        (List<dynamic> list) {
          var updatedList = List<VirtualHostMapping>.from(list);
          if (index >= 0 && index < updatedList.length) {
            updatedList[index] = patch(
              VirtualHostMappingPatch(),
            ).applyTo(updatedList[index] as VirtualHostMapping);
          }
          return updatedList;
        };
    return this;
  }
}

/// Field descriptors for [WebViewEnvironmentSettings] query construction
abstract final class WebViewEnvironmentSettingsFields {
  static const browserExecutableFolder =
      Field<WebViewEnvironmentSettings, String?>(
        'browserExecutableFolder',
        _$browserExecutableFolder,
      );

  static const userDataFolder = Field<WebViewEnvironmentSettings, String?>(
    'userDataFolder',
    _$userDataFolder,
  );

  static const additionalBrowserArguments =
      Field<WebViewEnvironmentSettings, String?>(
        'additionalBrowserArguments',
        _$additionalBrowserArguments,
      );

  static const allowSingleSignOnUsingOSPrimaryAccount =
      Field<WebViewEnvironmentSettings, bool?>(
        'allowSingleSignOnUsingOSPrimaryAccount',
        _$allowSingleSignOnUsingOSPrimaryAccount,
      );

  static const language = Field<WebViewEnvironmentSettings, String?>(
    'language',
    _$language,
  );

  static const targetCompatibleBrowserVersion =
      Field<WebViewEnvironmentSettings, String?>(
        'targetCompatibleBrowserVersion',
        _$targetCompatibleBrowserVersion,
      );

  static const virtualHostMappings =
      Field<WebViewEnvironmentSettings, List<VirtualHostMapping>?>(
        'virtualHostMappings',
        _$virtualHostMappings,
      );

  static String? _$browserExecutableFolder(WebViewEnvironmentSettings e) {
    return e.browserExecutableFolder;
  }

  static String? _$userDataFolder(WebViewEnvironmentSettings e) {
    return e.userDataFolder;
  }

  static String? _$additionalBrowserArguments(WebViewEnvironmentSettings e) {
    return e.additionalBrowserArguments;
  }

  static bool? _$allowSingleSignOnUsingOSPrimaryAccount(
    WebViewEnvironmentSettings e,
  ) {
    return e.allowSingleSignOnUsingOSPrimaryAccount;
  }

  static String? _$language(WebViewEnvironmentSettings e) {
    return e.language;
  }

  static String? _$targetCompatibleBrowserVersion(
    WebViewEnvironmentSettings e,
  ) {
    return e.targetCompatibleBrowserVersion;
  }

  static List<VirtualHostMapping>? _$virtualHostMappings(
    WebViewEnvironmentSettings e,
  ) {
    return e.virtualHostMappings;
  }
}

extension WebViewEnvironmentSettingsCompareE on WebViewEnvironmentSettings {
  Map<String, dynamic> compareToWebViewEnvironmentSettings(
    WebViewEnvironmentSettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (browserExecutableFolder != other.browserExecutableFolder) {
      diff['browserExecutableFolder'] = () => other.browserExecutableFolder;
    }

    if (userDataFolder != other.userDataFolder) {
      diff['userDataFolder'] = () => other.userDataFolder;
    }

    if (additionalBrowserArguments != other.additionalBrowserArguments) {
      diff['additionalBrowserArguments'] = () =>
          other.additionalBrowserArguments;
    }

    if (allowSingleSignOnUsingOSPrimaryAccount !=
        other.allowSingleSignOnUsingOSPrimaryAccount) {
      diff['allowSingleSignOnUsingOSPrimaryAccount'] = () =>
          other.allowSingleSignOnUsingOSPrimaryAccount;
    }

    if (language != other.language) {
      diff['language'] = () => other.language;
    }

    if (targetCompatibleBrowserVersion !=
        other.targetCompatibleBrowserVersion) {
      diff['targetCompatibleBrowserVersion'] = () =>
          other.targetCompatibleBrowserVersion;
    }

    if (virtualHostMappings != other.virtualHostMappings) {
      diff['virtualHostMappings'] = () => other.virtualHostMappings;
    }
    return diff;
  }
}
