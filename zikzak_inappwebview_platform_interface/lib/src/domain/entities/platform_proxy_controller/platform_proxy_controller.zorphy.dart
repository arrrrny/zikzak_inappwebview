// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'platform_proxy_controller.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class IOSProxySettings {
  IOSProxySettings({
    String? proxyUrl,
    bool? allowFailover,
    List<String>? excludedDomains,
    List<String>? matchDomains,
  }) : this.proxyUrl = proxyUrl ?? '',
       this.allowFailover = allowFailover ?? false,
       this.excludedDomains = excludedDomains ?? const [],
       this.matchDomains = matchDomains ?? const [];

  factory IOSProxySettings.fromJson(Map<String, dynamic> json) =>
      _$IOSProxySettingsFromJson(json);

  @JsonKey(defaultValue: '')
  final String proxyUrl;

  @JsonKey(defaultValue: false)
  final bool allowFailover;

  @JsonKey(defaultValue: const [])
  final List<String> excludedDomains;

  @JsonKey(defaultValue: const [])
  final List<String> matchDomains;

  IOSProxySettings copyWith({
    String? proxyUrl,
    bool? allowFailover,
    List<String>? excludedDomains,
    List<String>? matchDomains,
  }) {
    return IOSProxySettings(
      proxyUrl: proxyUrl ?? this.proxyUrl,
      allowFailover: allowFailover ?? this.allowFailover,
      excludedDomains: excludedDomains ?? this.excludedDomains,
      matchDomains: matchDomains ?? this.matchDomains,
    );
  }

  IOSProxySettings copyWithIOSProxySettings({
    String? proxyUrl,
    bool? allowFailover,
    List<String>? excludedDomains,
    List<String>? matchDomains,
  }) {
    return copyWith(
      proxyUrl: proxyUrl,
      allowFailover: allowFailover,
      excludedDomains: excludedDomains,
      matchDomains: matchDomains,
    );
  }

  IOSProxySettings patchWithIOSProxySettings([
    IOSProxySettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? IOSProxySettingsPatch();
    final _patchMap = _patcher.patchMap;
    return IOSProxySettings(
      proxyUrl: _patchMap.containsKey(IOSProxySettings$.proxyUrl)
          ? ((_patchMap[IOSProxySettings$.proxyUrl] is Function)
                    ? _patchMap[IOSProxySettings$.proxyUrl](this.proxyUrl)
                    : (_patchMap[IOSProxySettings$.proxyUrl] is Patch)
                    ? _patchMap[IOSProxySettings$.proxyUrl].applyTo(
                        this.proxyUrl,
                      )
                    : _patchMap[IOSProxySettings$.proxyUrl])
                as String
          : this.proxyUrl,
      allowFailover: _patchMap.containsKey(IOSProxySettings$.allowFailover)
          ? ((_patchMap[IOSProxySettings$.allowFailover] is Function)
                    ? _patchMap[IOSProxySettings$.allowFailover](
                        this.allowFailover,
                      )
                    : (_patchMap[IOSProxySettings$.allowFailover] is Patch)
                    ? _patchMap[IOSProxySettings$.allowFailover].applyTo(
                        this.allowFailover,
                      )
                    : _patchMap[IOSProxySettings$.allowFailover])
                as bool
          : this.allowFailover,
      excludedDomains: _patchMap.containsKey(IOSProxySettings$.excludedDomains)
          ? ((_patchMap[IOSProxySettings$.excludedDomains] is Function)
                    ? _patchMap[IOSProxySettings$.excludedDomains](
                        this.excludedDomains,
                      )
                    : (_patchMap[IOSProxySettings$.excludedDomains] is Patch)
                    ? _patchMap[IOSProxySettings$.excludedDomains].applyTo(
                        this.excludedDomains,
                      )
                    : _patchMap[IOSProxySettings$.excludedDomains])
                as List<String>
          : this.excludedDomains,
      matchDomains: _patchMap.containsKey(IOSProxySettings$.matchDomains)
          ? ((_patchMap[IOSProxySettings$.matchDomains] is Function)
                    ? _patchMap[IOSProxySettings$.matchDomains](
                        this.matchDomains,
                      )
                    : (_patchMap[IOSProxySettings$.matchDomains] is Patch)
                    ? _patchMap[IOSProxySettings$.matchDomains].applyTo(
                        this.matchDomains,
                      )
                    : _patchMap[IOSProxySettings$.matchDomains])
                as List<String>
          : this.matchDomains,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IOSProxySettings &&
        proxyUrl == other.proxyUrl &&
        allowFailover == other.allowFailover &&
        excludedDomains == other.excludedDomains &&
        matchDomains == other.matchDomains;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.proxyUrl,
      this.allowFailover,
      this.excludedDomains,
      this.matchDomains,
    );
  }

  @override
  String toString() {
    return 'IOSProxySettings(' +
        'proxyUrl: ${proxyUrl}' +
        ', ' +
        'allowFailover: ${allowFailover}' +
        ', ' +
        'excludedDomains: ${excludedDomains}' +
        ', ' +
        'matchDomains: ${matchDomains})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$IOSProxySettingsToJson(this);
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

extension IOSProxySettingsPropertyHelpers on IOSProxySettings {
  bool get hasProxyUrl {
    return this.proxyUrl.isNotEmpty;
  }

  bool get noProxyUrl {
    return this.proxyUrl.isEmpty;
  }

  bool get hasExcludedDomains {
    return this.excludedDomains.isNotEmpty;
  }

  bool get noExcludedDomains {
    return this.excludedDomains.isEmpty;
  }

  bool get hasMatchDomains {
    return this.matchDomains.isNotEmpty;
  }

  bool get noMatchDomains {
    return this.matchDomains.isEmpty;
  }
}

extension IOSProxySettingsSerialization on IOSProxySettings {
  Map<String, dynamic> toJson() {
    return _$IOSProxySettingsToJson(this);
  }
}

enum IOSProxySettings$ {
  proxyUrl,
  allowFailover,
  excludedDomains,
  matchDomains,
}

class IOSProxySettingsPatch
    extends PatchBase<IOSProxySettings, IOSProxySettings$> {
  IOSProxySettings applyTo(IOSProxySettings entity) {
    return entity.patchWithIOSProxySettings(this);
  }

  IOSProxySettingsPatch withProxyUrl(String? value) {
    patchMap[IOSProxySettings$.proxyUrl] = value;
    return this;
  }

  IOSProxySettingsPatch withAllowFailover(bool? value) {
    patchMap[IOSProxySettings$.allowFailover] = value;
    return this;
  }

  IOSProxySettingsPatch withExcludedDomains(List<String>? value) {
    patchMap[IOSProxySettings$.excludedDomains] = value;
    return this;
  }

  IOSProxySettingsPatch withMatchDomains(List<String>? value) {
    patchMap[IOSProxySettings$.matchDomains] = value;
    return this;
  }
}

/// Field descriptors for [IOSProxySettings] query construction
abstract final class IOSProxySettingsFields {
  static const proxyUrl = Field<IOSProxySettings, String>(
    'proxyUrl',
    _$proxyUrl,
  );

  static const allowFailover = Field<IOSProxySettings, bool>(
    'allowFailover',
    _$allowFailover,
  );

  static const excludedDomains = Field<IOSProxySettings, List<String>>(
    'excludedDomains',
    _$excludedDomains,
  );

  static const matchDomains = Field<IOSProxySettings, List<String>>(
    'matchDomains',
    _$matchDomains,
  );

  static String _$proxyUrl(IOSProxySettings e) {
    return e.proxyUrl;
  }

  static bool _$allowFailover(IOSProxySettings e) {
    return e.allowFailover;
  }

  static List<String> _$excludedDomains(IOSProxySettings e) {
    return e.excludedDomains;
  }

  static List<String> _$matchDomains(IOSProxySettings e) {
    return e.matchDomains;
  }
}

extension IOSProxySettingsCompareE on IOSProxySettings {
  Map<String, dynamic> compareToIOSProxySettings(IOSProxySettings other) {
    final Map<String, dynamic> diff = {};

    if (proxyUrl != other.proxyUrl) {
      diff['proxyUrl'] = () => other.proxyUrl;
    }

    if (allowFailover != other.allowFailover) {
      diff['allowFailover'] = () => other.allowFailover;
    }

    if (excludedDomains != other.excludedDomains) {
      diff['excludedDomains'] = () => other.excludedDomains;
    }

    if (matchDomains != other.matchDomains) {
      diff['matchDomains'] = () => other.matchDomains;
    }
    return diff;
  }
}

@JsonSerializable(explicitToJson: true, checked: true)
class AndroidProxySettings {
  AndroidProxySettings({
    List<String>? bypassRules,
    List<String>? directs,
    List<ProxyRule>? proxyRules,
    bool? this.bypassSimpleHostnames,
    bool? this.removeImplicitRules,
    bool? reverseBypassEnabled,
  }) : this.bypassRules = bypassRules ?? const [],
       this.directs = directs ?? const [],
       this.proxyRules = proxyRules ?? const [],
       this.reverseBypassEnabled = reverseBypassEnabled ?? false;

  factory AndroidProxySettings.fromJson(Map<String, dynamic> json) =>
      _$AndroidProxySettingsFromJson(json);

  @JsonKey(defaultValue: const [])
  final List<String> bypassRules;

  @JsonKey(defaultValue: const [])
  final List<String> directs;

  @JsonKey(defaultValue: const [])
  final List<ProxyRule> proxyRules;

  final bool? bypassSimpleHostnames;

  final bool? removeImplicitRules;

  @JsonKey(defaultValue: false)
  final bool reverseBypassEnabled;

  AndroidProxySettings copyWith({
    List<String>? bypassRules,
    List<String>? directs,
    List<ProxyRule>? proxyRules,
    bool? bypassSimpleHostnames,
    bool? removeImplicitRules,
    bool? reverseBypassEnabled,
  }) {
    return AndroidProxySettings(
      bypassRules: bypassRules ?? this.bypassRules,
      directs: directs ?? this.directs,
      proxyRules: proxyRules ?? this.proxyRules,
      bypassSimpleHostnames:
          bypassSimpleHostnames ?? this.bypassSimpleHostnames,
      removeImplicitRules: removeImplicitRules ?? this.removeImplicitRules,
      reverseBypassEnabled: reverseBypassEnabled ?? this.reverseBypassEnabled,
    );
  }

  AndroidProxySettings copyWithAndroidProxySettings({
    List<String>? bypassRules,
    List<String>? directs,
    List<ProxyRule>? proxyRules,
    bool? bypassSimpleHostnames,
    bool? removeImplicitRules,
    bool? reverseBypassEnabled,
  }) {
    return copyWith(
      bypassRules: bypassRules,
      directs: directs,
      proxyRules: proxyRules,
      bypassSimpleHostnames: bypassSimpleHostnames,
      removeImplicitRules: removeImplicitRules,
      reverseBypassEnabled: reverseBypassEnabled,
    );
  }

  AndroidProxySettings patchWithAndroidProxySettings([
    AndroidProxySettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? AndroidProxySettingsPatch();
    final _patchMap = _patcher.patchMap;
    return AndroidProxySettings(
      bypassRules: _patchMap.containsKey(AndroidProxySettings$.bypassRules)
          ? ((_patchMap[AndroidProxySettings$.bypassRules] is Function)
                    ? _patchMap[AndroidProxySettings$.bypassRules](
                        this.bypassRules,
                      )
                    : (_patchMap[AndroidProxySettings$.bypassRules] is Patch)
                    ? _patchMap[AndroidProxySettings$.bypassRules].applyTo(
                        this.bypassRules,
                      )
                    : _patchMap[AndroidProxySettings$.bypassRules])
                as List<String>
          : this.bypassRules,
      directs: _patchMap.containsKey(AndroidProxySettings$.directs)
          ? ((_patchMap[AndroidProxySettings$.directs] is Function)
                    ? _patchMap[AndroidProxySettings$.directs](this.directs)
                    : (_patchMap[AndroidProxySettings$.directs] is Patch)
                    ? _patchMap[AndroidProxySettings$.directs].applyTo(
                        this.directs,
                      )
                    : _patchMap[AndroidProxySettings$.directs])
                as List<String>
          : this.directs,
      proxyRules: _patchMap.containsKey(AndroidProxySettings$.proxyRules)
          ? ((_patchMap[AndroidProxySettings$.proxyRules] is Function)
                    ? _patchMap[AndroidProxySettings$.proxyRules](
                        this.proxyRules,
                      )
                    : (_patchMap[AndroidProxySettings$.proxyRules] is Patch)
                    ? _patchMap[AndroidProxySettings$.proxyRules].applyTo(
                        this.proxyRules,
                      )
                    : _patchMap[AndroidProxySettings$.proxyRules])
                as List<ProxyRule>
          : this.proxyRules,
      bypassSimpleHostnames:
          _patchMap.containsKey(AndroidProxySettings$.bypassSimpleHostnames)
          ? ((_patchMap[AndroidProxySettings$.bypassSimpleHostnames]
                        is Function)
                    ? _patchMap[AndroidProxySettings$.bypassSimpleHostnames](
                        this.bypassSimpleHostnames,
                      )
                    : (_patchMap[AndroidProxySettings$.bypassSimpleHostnames]
                          is Patch)
                    ? _patchMap[AndroidProxySettings$.bypassSimpleHostnames]
                          .applyTo(this.bypassSimpleHostnames)
                    : _patchMap[AndroidProxySettings$.bypassSimpleHostnames])
                as bool?
          : this.bypassSimpleHostnames,
      removeImplicitRules:
          _patchMap.containsKey(AndroidProxySettings$.removeImplicitRules)
          ? ((_patchMap[AndroidProxySettings$.removeImplicitRules] is Function)
                    ? _patchMap[AndroidProxySettings$.removeImplicitRules](
                        this.removeImplicitRules,
                      )
                    : (_patchMap[AndroidProxySettings$.removeImplicitRules]
                          is Patch)
                    ? _patchMap[AndroidProxySettings$.removeImplicitRules]
                          .applyTo(this.removeImplicitRules)
                    : _patchMap[AndroidProxySettings$.removeImplicitRules])
                as bool?
          : this.removeImplicitRules,
      reverseBypassEnabled:
          _patchMap.containsKey(AndroidProxySettings$.reverseBypassEnabled)
          ? ((_patchMap[AndroidProxySettings$.reverseBypassEnabled] is Function)
                    ? _patchMap[AndroidProxySettings$.reverseBypassEnabled](
                        this.reverseBypassEnabled,
                      )
                    : (_patchMap[AndroidProxySettings$.reverseBypassEnabled]
                          is Patch)
                    ? _patchMap[AndroidProxySettings$.reverseBypassEnabled]
                          .applyTo(this.reverseBypassEnabled)
                    : _patchMap[AndroidProxySettings$.reverseBypassEnabled])
                as bool
          : this.reverseBypassEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AndroidProxySettings &&
        bypassRules == other.bypassRules &&
        directs == other.directs &&
        proxyRules == other.proxyRules &&
        bypassSimpleHostnames == other.bypassSimpleHostnames &&
        removeImplicitRules == other.removeImplicitRules &&
        reverseBypassEnabled == other.reverseBypassEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.bypassRules,
      this.directs,
      this.proxyRules,
      this.bypassSimpleHostnames,
      this.removeImplicitRules,
      this.reverseBypassEnabled,
    );
  }

  @override
  String toString() {
    return 'AndroidProxySettings(' +
        'bypassRules: ${bypassRules}' +
        ', ' +
        'directs: ${directs}' +
        ', ' +
        'proxyRules: ${proxyRules}' +
        ', ' +
        'bypassSimpleHostnames: ${bypassSimpleHostnames}' +
        ', ' +
        'removeImplicitRules: ${removeImplicitRules}' +
        ', ' +
        'reverseBypassEnabled: ${reverseBypassEnabled})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$AndroidProxySettingsToJson(this);
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

extension AndroidProxySettingsPropertyHelpers on AndroidProxySettings {
  bool get hasBypassRules {
    return this.bypassRules.isNotEmpty;
  }

  bool get noBypassRules {
    return this.bypassRules.isEmpty;
  }

  bool get hasDirects {
    return this.directs.isNotEmpty;
  }

  bool get noDirects {
    return this.directs.isEmpty;
  }

  bool get hasProxyRules {
    return this.proxyRules.isNotEmpty;
  }

  bool get noProxyRules {
    return this.proxyRules.isEmpty;
  }

  bool get hasBypassSimpleHostnames {
    return this.bypassSimpleHostnames != null;
  }

  bool get noBypassSimpleHostnames {
    return this.bypassSimpleHostnames == null;
  }

  bool get bypassSimpleHostnamesRequired {
    return this.bypassSimpleHostnames ??
        (throw StateError('bypassSimpleHostnames is required but was null'));
  }

  bool get hasRemoveImplicitRules {
    return this.removeImplicitRules != null;
  }

  bool get noRemoveImplicitRules {
    return this.removeImplicitRules == null;
  }

  bool get removeImplicitRulesRequired {
    return this.removeImplicitRules ??
        (throw StateError('removeImplicitRules is required but was null'));
  }
}

extension AndroidProxySettingsSerialization on AndroidProxySettings {
  Map<String, dynamic> toJson() {
    return _$AndroidProxySettingsToJson(this);
  }
}

enum AndroidProxySettings$ {
  bypassRules,
  directs,
  proxyRules,
  bypassSimpleHostnames,
  removeImplicitRules,
  reverseBypassEnabled,
}

class AndroidProxySettingsPatch
    extends PatchBase<AndroidProxySettings, AndroidProxySettings$> {
  AndroidProxySettings applyTo(AndroidProxySettings entity) {
    return entity.patchWithAndroidProxySettings(this);
  }

  AndroidProxySettingsPatch withBypassRules(List<String>? value) {
    patchMap[AndroidProxySettings$.bypassRules] = value;
    return this;
  }

  AndroidProxySettingsPatch withDirects(List<String>? value) {
    patchMap[AndroidProxySettings$.directs] = value;
    return this;
  }

  AndroidProxySettingsPatch withProxyRules(List<ProxyRule>? value) {
    patchMap[AndroidProxySettings$.proxyRules] = value;
    return this;
  }

  AndroidProxySettingsPatch updateProxyRulesAt(
    int index,
    ProxyRulePatch Function(ProxyRulePatch) patch,
  ) {
    patchMap[AndroidProxySettings$.proxyRules] = (List<dynamic> list) {
      var updatedList = List<ProxyRule>.from(list);
      if (index >= 0 && index < updatedList.length) {
        updatedList[index] = patch(
          ProxyRulePatch(),
        ).applyTo(updatedList[index] as ProxyRule);
      }
      return updatedList;
    };
    return this;
  }

  AndroidProxySettingsPatch withBypassSimpleHostnames(bool? value) {
    patchMap[AndroidProxySettings$.bypassSimpleHostnames] = value;
    return this;
  }

  AndroidProxySettingsPatch withRemoveImplicitRules(bool? value) {
    patchMap[AndroidProxySettings$.removeImplicitRules] = value;
    return this;
  }

  AndroidProxySettingsPatch withReverseBypassEnabled(bool? value) {
    patchMap[AndroidProxySettings$.reverseBypassEnabled] = value;
    return this;
  }
}

/// Field descriptors for [AndroidProxySettings] query construction
abstract final class AndroidProxySettingsFields {
  static const bypassRules = Field<AndroidProxySettings, List<String>>(
    'bypassRules',
    _$bypassRules,
  );

  static const directs = Field<AndroidProxySettings, List<String>>(
    'directs',
    _$directs,
  );

  static const proxyRules = Field<AndroidProxySettings, List<ProxyRule>>(
    'proxyRules',
    _$proxyRules,
  );

  static const bypassSimpleHostnames = Field<AndroidProxySettings, bool?>(
    'bypassSimpleHostnames',
    _$bypassSimpleHostnames,
  );

  static const removeImplicitRules = Field<AndroidProxySettings, bool?>(
    'removeImplicitRules',
    _$removeImplicitRules,
  );

  static const reverseBypassEnabled = Field<AndroidProxySettings, bool>(
    'reverseBypassEnabled',
    _$reverseBypassEnabled,
  );

  static List<String> _$bypassRules(AndroidProxySettings e) {
    return e.bypassRules;
  }

  static List<String> _$directs(AndroidProxySettings e) {
    return e.directs;
  }

  static List<ProxyRule> _$proxyRules(AndroidProxySettings e) {
    return e.proxyRules;
  }

  static bool? _$bypassSimpleHostnames(AndroidProxySettings e) {
    return e.bypassSimpleHostnames;
  }

  static bool? _$removeImplicitRules(AndroidProxySettings e) {
    return e.removeImplicitRules;
  }

  static bool _$reverseBypassEnabled(AndroidProxySettings e) {
    return e.reverseBypassEnabled;
  }
}

extension AndroidProxySettingsCompareE on AndroidProxySettings {
  Map<String, dynamic> compareToAndroidProxySettings(
    AndroidProxySettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (bypassRules != other.bypassRules) {
      diff['bypassRules'] = () => other.bypassRules;
    }

    if (directs != other.directs) {
      diff['directs'] = () => other.directs;
    }

    if (proxyRules != other.proxyRules) {
      diff['proxyRules'] = () => other.proxyRules;
    }

    if (bypassSimpleHostnames != other.bypassSimpleHostnames) {
      diff['bypassSimpleHostnames'] = () => other.bypassSimpleHostnames;
    }

    if (removeImplicitRules != other.removeImplicitRules) {
      diff['removeImplicitRules'] = () => other.removeImplicitRules;
    }

    if (reverseBypassEnabled != other.reverseBypassEnabled) {
      diff['reverseBypassEnabled'] = () => other.reverseBypassEnabled;
    }
    return diff;
  }
}
