// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'user_script.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class UserScript {
  UserScript({
    Set<String>? allowedOriginRules,
    ContentWorld? this.contentWorld,
    bool? forMainFrameOnly,
    String? this.groupName,
    required UserScriptInjectionTime this.injectionTime,
    required String this.source,
  }) : this.allowedOriginRules = allowedOriginRules ?? const {'*'},
       this.forMainFrameOnly = forMainFrameOnly ?? true;

  factory UserScript.fromJson(Map<String, dynamic> json) =>
      _$UserScriptFromJson(json);

  @JsonKey(defaultValue: {'*'})
  final Set<String> allowedOriginRules;

  @JsonKey(toJson: _contentWorldToJson, fromJson: _contentWorldFromJson)
  final ContentWorld? contentWorld;

  @JsonKey(defaultValue: true)
  final bool forMainFrameOnly;

  final String? groupName;

  @JsonKey(toJson: _injectionTimeToJson, fromJson: _injectionTimeFromJson)
  final UserScriptInjectionTime injectionTime;

  final String source;

  UserScript copyWith({
    Set<String>? allowedOriginRules,
    ContentWorld? contentWorld,
    bool? forMainFrameOnly,
    String? groupName,
    UserScriptInjectionTime? injectionTime,
    String? source,
  }) {
    return UserScript(
      allowedOriginRules: allowedOriginRules ?? this.allowedOriginRules,
      contentWorld: contentWorld ?? this.contentWorld,
      forMainFrameOnly: forMainFrameOnly ?? this.forMainFrameOnly,
      groupName: groupName ?? this.groupName,
      injectionTime: injectionTime ?? this.injectionTime,
      source: source ?? this.source,
    );
  }

  UserScript copyWithUserScript({
    Set<String>? allowedOriginRules,
    ContentWorld? contentWorld,
    bool? forMainFrameOnly,
    String? groupName,
    UserScriptInjectionTime? injectionTime,
    String? source,
  }) {
    return copyWith(
      allowedOriginRules: allowedOriginRules,
      contentWorld: contentWorld,
      forMainFrameOnly: forMainFrameOnly,
      groupName: groupName,
      injectionTime: injectionTime,
      source: source,
    );
  }

  UserScript patchWithUserScript([UserScriptPatch? patchInput]) {
    final _patcher = patchInput ?? UserScriptPatch();
    final _patchMap = _patcher.patchMap;
    return UserScript(
      allowedOriginRules: _patchMap.containsKey(UserScript$.allowedOriginRules)
          ? ((_patchMap[UserScript$.allowedOriginRules] is Function)
                    ? _patchMap[UserScript$.allowedOriginRules](
                        this.allowedOriginRules,
                      )
                    : (_patchMap[UserScript$.allowedOriginRules] is Patch)
                    ? _patchMap[UserScript$.allowedOriginRules].applyTo(
                        this.allowedOriginRules,
                      )
                    : _patchMap[UserScript$.allowedOriginRules])
                as Set<String>
          : this.allowedOriginRules,
      contentWorld: _patchMap.containsKey(UserScript$.contentWorld)
          ? ((_patchMap[UserScript$.contentWorld] is Function)
                    ? _patchMap[UserScript$.contentWorld](this.contentWorld)
                    : (_patchMap[UserScript$.contentWorld] is Patch)
                    ? _patchMap[UserScript$.contentWorld].applyTo(
                        this.contentWorld,
                      )
                    : _patchMap[UserScript$.contentWorld])
                as ContentWorld?
          : this.contentWorld,
      forMainFrameOnly: _patchMap.containsKey(UserScript$.forMainFrameOnly)
          ? ((_patchMap[UserScript$.forMainFrameOnly] is Function)
                    ? _patchMap[UserScript$.forMainFrameOnly](
                        this.forMainFrameOnly,
                      )
                    : (_patchMap[UserScript$.forMainFrameOnly] is Patch)
                    ? _patchMap[UserScript$.forMainFrameOnly].applyTo(
                        this.forMainFrameOnly,
                      )
                    : _patchMap[UserScript$.forMainFrameOnly])
                as bool
          : this.forMainFrameOnly,
      groupName: _patchMap.containsKey(UserScript$.groupName)
          ? ((_patchMap[UserScript$.groupName] is Function)
                    ? _patchMap[UserScript$.groupName](this.groupName)
                    : (_patchMap[UserScript$.groupName] is Patch)
                    ? _patchMap[UserScript$.groupName].applyTo(this.groupName)
                    : _patchMap[UserScript$.groupName])
                as String?
          : this.groupName,
      injectionTime: _patchMap.containsKey(UserScript$.injectionTime)
          ? ((_patchMap[UserScript$.injectionTime] is Function)
                    ? _patchMap[UserScript$.injectionTime](this.injectionTime)
                    : (_patchMap[UserScript$.injectionTime] is Patch)
                    ? _patchMap[UserScript$.injectionTime].applyTo(
                        this.injectionTime,
                      )
                    : _patchMap[UserScript$.injectionTime])
                as UserScriptInjectionTime
          : this.injectionTime,
      source: _patchMap.containsKey(UserScript$.source)
          ? ((_patchMap[UserScript$.source] is Function)
                    ? _patchMap[UserScript$.source](this.source)
                    : (_patchMap[UserScript$.source] is Patch)
                    ? _patchMap[UserScript$.source].applyTo(this.source)
                    : _patchMap[UserScript$.source])
                as String
          : this.source,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserScript &&
        allowedOriginRules == other.allowedOriginRules &&
        contentWorld == other.contentWorld &&
        forMainFrameOnly == other.forMainFrameOnly &&
        groupName == other.groupName &&
        injectionTime == other.injectionTime &&
        source == other.source;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.allowedOriginRules,
      this.contentWorld,
      this.forMainFrameOnly,
      this.groupName,
      this.injectionTime,
      this.source,
    );
  }

  @override
  String toString() {
    return 'UserScript(' +
        'allowedOriginRules: ${allowedOriginRules}' +
        ', ' +
        'contentWorld: ${contentWorld}' +
        ', ' +
        'forMainFrameOnly: ${forMainFrameOnly}' +
        ', ' +
        'groupName: ${groupName}' +
        ', ' +
        'injectionTime: ${injectionTime}' +
        ', ' +
        'source: ${source})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$UserScriptToJson(this);
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

extension UserScriptPropertyHelpers on UserScript {
  bool get hasAllowedOriginRules {
    return this.allowedOriginRules.isNotEmpty;
  }

  bool get noAllowedOriginRules {
    return this.allowedOriginRules.isEmpty;
  }

  bool get hasContentWorld {
    return this.contentWorld != null;
  }

  bool get noContentWorld {
    return this.contentWorld == null;
  }

  ContentWorld get contentWorldRequired {
    return this.contentWorld ??
        (throw StateError('contentWorld is required but was null'));
  }

  bool get hasGroupName {
    return this.groupName?.isNotEmpty == true;
  }

  bool get noGroupName {
    return this.groupName?.isEmpty ?? true;
  }

  String get groupNameRequired {
    return this.groupName ??
        (throw StateError('groupName is required but was null'));
  }

  bool get isInjectionTimeAT_DOCUMENT_START {
    return this.injectionTime == UserScriptInjectionTime.AT_DOCUMENT_START;
  }

  bool get isInjectionTimeAT_DOCUMENT_END {
    return this.injectionTime == UserScriptInjectionTime.AT_DOCUMENT_END;
  }

  bool get hasSource {
    return this.source.isNotEmpty;
  }

  bool get noSource {
    return this.source.isEmpty;
  }
}

extension UserScriptSerialization on UserScript {
  Map<String, dynamic> toJson() {
    return _$UserScriptToJson(this);
  }
}

enum UserScript$ {
  allowedOriginRules,
  contentWorld,
  forMainFrameOnly,
  groupName,
  injectionTime,
  source,
}

class UserScriptPatch extends PatchBase<UserScript, UserScript$> {
  UserScript applyTo(UserScript entity) {
    return entity.patchWithUserScript(this);
  }

  UserScriptPatch withAllowedOriginRules(Set<String>? value) {
    patchMap[UserScript$.allowedOriginRules] = value;
    return this;
  }

  UserScriptPatch withContentWorld(ContentWorld? value) {
    patchMap[UserScript$.contentWorld] = value;
    return this;
  }

  UserScriptPatch withForMainFrameOnly(bool? value) {
    patchMap[UserScript$.forMainFrameOnly] = value;
    return this;
  }

  UserScriptPatch withGroupName(String? value) {
    patchMap[UserScript$.groupName] = value;
    return this;
  }

  UserScriptPatch withInjectionTime(UserScriptInjectionTime? value) {
    patchMap[UserScript$.injectionTime] = value;
    return this;
  }

  UserScriptPatch withSource(String? value) {
    patchMap[UserScript$.source] = value;
    return this;
  }
}

/// Field descriptors for [UserScript] query construction
abstract final class UserScriptFields {
  static const allowedOriginRules = Field<UserScript, Set<String>>(
    'allowedOriginRules',
    _$allowedOriginRules,
  );

  static const contentWorld = Field<UserScript, ContentWorld?>(
    'contentWorld',
    _$contentWorld,
  );

  static const forMainFrameOnly = Field<UserScript, bool>(
    'forMainFrameOnly',
    _$forMainFrameOnly,
  );

  static const groupName = Field<UserScript, String?>('groupName', _$groupName);

  static const injectionTime = Field<UserScript, UserScriptInjectionTime>(
    'injectionTime',
    _$injectionTime,
  );

  static const source = Field<UserScript, String>('source', _$source);

  static Set<String> _$allowedOriginRules(UserScript e) {
    return e.allowedOriginRules;
  }

  static ContentWorld? _$contentWorld(UserScript e) {
    return e.contentWorld;
  }

  static bool _$forMainFrameOnly(UserScript e) {
    return e.forMainFrameOnly;
  }

  static String? _$groupName(UserScript e) {
    return e.groupName;
  }

  static UserScriptInjectionTime _$injectionTime(UserScript e) {
    return e.injectionTime;
  }

  static String _$source(UserScript e) {
    return e.source;
  }
}

extension UserScriptCompareE on UserScript {
  Map<String, dynamic> compareToUserScript(UserScript other) {
    final Map<String, dynamic> diff = {};

    if (allowedOriginRules != other.allowedOriginRules) {
      diff['allowedOriginRules'] = () => other.allowedOriginRules;
    }

    if (contentWorld != other.contentWorld) {
      diff['contentWorld'] = () => other.contentWorld;
    }

    if (forMainFrameOnly != other.forMainFrameOnly) {
      diff['forMainFrameOnly'] = () => other.forMainFrameOnly;
    }

    if (groupName != other.groupName) {
      diff['groupName'] = () => other.groupName;
    }

    if (injectionTime != other.injectionTime) {
      diff['injectionTime'] = () => other.injectionTime;
    }

    if (source != other.source) {
      diff['source'] = () => other.source;
    }
    return diff;
  }
}
