// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'pull_to_refresh_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PullToRefreshSettings {
  PullToRefreshSettings({
    bool? enabled,
    Color? this.color,
    Color? this.backgroundColor,
    int? this.distanceToTriggerSync,
    int? this.slingshotDistance,
    PullToRefreshSize? this.size,
    AttributedString? this.attributedTitle,
  }) : this.enabled = enabled ?? true;

  factory PullToRefreshSettings.fromJson(Map<String, dynamic> json) =>
      _$PullToRefreshSettingsFromJson(json);

  @JsonKey(defaultValue: true)
  final bool? enabled;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? color;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? backgroundColor;

  final int? distanceToTriggerSync;

  final int? slingshotDistance;

  @JsonKey(toJson: _sizeToJson, fromJson: _sizeFromJson)
  final PullToRefreshSize? size;

  @JsonKey(toJson: _attributedTitleToJson, fromJson: _attributedTitleFromJson)
  final AttributedString? attributedTitle;

  PullToRefreshSettings copyWith({
    bool? enabled,
    Color? color,
    Color? backgroundColor,
    int? distanceToTriggerSync,
    int? slingshotDistance,
    PullToRefreshSize? size,
    AttributedString? attributedTitle,
  }) {
    return PullToRefreshSettings(
      enabled: enabled ?? this.enabled,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      distanceToTriggerSync:
          distanceToTriggerSync ?? this.distanceToTriggerSync,
      slingshotDistance: slingshotDistance ?? this.slingshotDistance,
      size: size ?? this.size,
      attributedTitle: attributedTitle ?? this.attributedTitle,
    );
  }

  PullToRefreshSettings copyWithPullToRefreshSettings({
    bool? enabled,
    Color? color,
    Color? backgroundColor,
    int? distanceToTriggerSync,
    int? slingshotDistance,
    PullToRefreshSize? size,
    AttributedString? attributedTitle,
  }) {
    return copyWith(
      enabled: enabled,
      color: color,
      backgroundColor: backgroundColor,
      distanceToTriggerSync: distanceToTriggerSync,
      slingshotDistance: slingshotDistance,
      size: size,
      attributedTitle: attributedTitle,
    );
  }

  PullToRefreshSettings patchWithPullToRefreshSettings([
    PullToRefreshSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PullToRefreshSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return PullToRefreshSettings(
      enabled: _patchMap.containsKey(PullToRefreshSettings$.enabled)
          ? (_patchMap[PullToRefreshSettings$.enabled] is Function)
                ? _patchMap[PullToRefreshSettings$.enabled](this.enabled)
                : (_patchMap[PullToRefreshSettings$.enabled] is Patch)
                ? _patchMap[PullToRefreshSettings$.enabled].applyTo(
                    this.enabled,
                  )
                : _patchMap[PullToRefreshSettings$.enabled]
          : this.enabled,
      color: _patchMap.containsKey(PullToRefreshSettings$.color)
          ? (_patchMap[PullToRefreshSettings$.color] is Function)
                ? _patchMap[PullToRefreshSettings$.color](this.color)
                : (_patchMap[PullToRefreshSettings$.color] is Patch)
                ? _patchMap[PullToRefreshSettings$.color].applyTo(this.color)
                : _patchMap[PullToRefreshSettings$.color]
          : this.color,
      backgroundColor:
          _patchMap.containsKey(PullToRefreshSettings$.backgroundColor)
          ? (_patchMap[PullToRefreshSettings$.backgroundColor] is Function)
                ? _patchMap[PullToRefreshSettings$.backgroundColor](
                    this.backgroundColor,
                  )
                : (_patchMap[PullToRefreshSettings$.backgroundColor] is Patch)
                ? _patchMap[PullToRefreshSettings$.backgroundColor].applyTo(
                    this.backgroundColor,
                  )
                : _patchMap[PullToRefreshSettings$.backgroundColor]
          : this.backgroundColor,
      distanceToTriggerSync:
          _patchMap.containsKey(PullToRefreshSettings$.distanceToTriggerSync)
          ? (_patchMap[PullToRefreshSettings$.distanceToTriggerSync]
                    is Function)
                ? _patchMap[PullToRefreshSettings$.distanceToTriggerSync](
                    this.distanceToTriggerSync,
                  )
                : (_patchMap[PullToRefreshSettings$.distanceToTriggerSync]
                      is Patch)
                ? _patchMap[PullToRefreshSettings$.distanceToTriggerSync]
                      .applyTo(this.distanceToTriggerSync)
                : _patchMap[PullToRefreshSettings$.distanceToTriggerSync]
          : this.distanceToTriggerSync,
      slingshotDistance:
          _patchMap.containsKey(PullToRefreshSettings$.slingshotDistance)
          ? (_patchMap[PullToRefreshSettings$.slingshotDistance] is Function)
                ? _patchMap[PullToRefreshSettings$.slingshotDistance](
                    this.slingshotDistance,
                  )
                : (_patchMap[PullToRefreshSettings$.slingshotDistance] is Patch)
                ? _patchMap[PullToRefreshSettings$.slingshotDistance].applyTo(
                    this.slingshotDistance,
                  )
                : _patchMap[PullToRefreshSettings$.slingshotDistance]
          : this.slingshotDistance,
      size: _patchMap.containsKey(PullToRefreshSettings$.size)
          ? (_patchMap[PullToRefreshSettings$.size] is Function)
                ? _patchMap[PullToRefreshSettings$.size](this.size)
                : (_patchMap[PullToRefreshSettings$.size] is Patch)
                ? _patchMap[PullToRefreshSettings$.size].applyTo(this.size)
                : _patchMap[PullToRefreshSettings$.size]
          : this.size,
      attributedTitle:
          _patchMap.containsKey(PullToRefreshSettings$.attributedTitle)
          ? (_patchMap[PullToRefreshSettings$.attributedTitle] is Function)
                ? _patchMap[PullToRefreshSettings$.attributedTitle](
                    this.attributedTitle,
                  )
                : (_patchMap[PullToRefreshSettings$.attributedTitle] is Patch)
                ? _patchMap[PullToRefreshSettings$.attributedTitle].applyTo(
                    this.attributedTitle,
                  )
                : _patchMap[PullToRefreshSettings$.attributedTitle]
          : this.attributedTitle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PullToRefreshSettings &&
        enabled == other.enabled &&
        color == other.color &&
        backgroundColor == other.backgroundColor &&
        distanceToTriggerSync == other.distanceToTriggerSync &&
        slingshotDistance == other.slingshotDistance &&
        size == other.size &&
        attributedTitle == other.attributedTitle;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.enabled,
      this.color,
      this.backgroundColor,
      this.distanceToTriggerSync,
      this.slingshotDistance,
      this.size,
      this.attributedTitle,
    );
  }

  @override
  String toString() {
    return 'PullToRefreshSettings(' +
        'enabled: ${enabled}' +
        ', ' +
        'color: ${color}' +
        ', ' +
        'backgroundColor: ${backgroundColor}' +
        ', ' +
        'distanceToTriggerSync: ${distanceToTriggerSync}' +
        ', ' +
        'slingshotDistance: ${slingshotDistance}' +
        ', ' +
        'size: ${size}' +
        ', ' +
        'attributedTitle: ${attributedTitle})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PullToRefreshSettingsToJson(this);
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

extension PullToRefreshSettingsPropertyHelpers on PullToRefreshSettings {
  bool get hasEnabled {
    return this.enabled != null;
  }

  bool get noEnabled {
    return this.enabled == null;
  }

  bool get enabledRequired {
    return this.enabled ??
        (throw StateError('enabled is required but was null'));
  }

  bool get hasColor {
    return this.color != null;
  }

  bool get noColor {
    return this.color == null;
  }

  Color get colorRequired {
    return this.color ?? (throw StateError('color is required but was null'));
  }

  bool get hasBackgroundColor {
    return this.backgroundColor != null;
  }

  bool get noBackgroundColor {
    return this.backgroundColor == null;
  }

  Color get backgroundColorRequired {
    return this.backgroundColor ??
        (throw StateError('backgroundColor is required but was null'));
  }

  bool get hasDistanceToTriggerSync {
    return this.distanceToTriggerSync != null;
  }

  bool get noDistanceToTriggerSync {
    return this.distanceToTriggerSync == null;
  }

  int get distanceToTriggerSyncRequired {
    return this.distanceToTriggerSync ??
        (throw StateError('distanceToTriggerSync is required but was null'));
  }

  bool get hasSlingshotDistance {
    return this.slingshotDistance != null;
  }

  bool get noSlingshotDistance {
    return this.slingshotDistance == null;
  }

  int get slingshotDistanceRequired {
    return this.slingshotDistance ??
        (throw StateError('slingshotDistance is required but was null'));
  }

  bool get hasSize {
    return this.size != null;
  }

  bool get noSize {
    return this.size == null;
  }

  PullToRefreshSize get sizeRequired {
    return this.size ?? (throw StateError('size is required but was null'));
  }

  bool get isSizeDEFAULT {
    return this.size == PullToRefreshSize.DEFAULT;
  }

  bool get isSizeLARGE {
    return this.size == PullToRefreshSize.LARGE;
  }

  bool get hasAttributedTitle {
    return this.attributedTitle != null;
  }

  bool get noAttributedTitle {
    return this.attributedTitle == null;
  }

  AttributedString get attributedTitleRequired {
    return this.attributedTitle ??
        (throw StateError('attributedTitle is required but was null'));
  }
}

extension PullToRefreshSettingsSerialization on PullToRefreshSettings {
  Map<String, dynamic> toJson() {
    return _$PullToRefreshSettingsToJson(this);
  }
}

enum PullToRefreshSettings$ {
  enabled,
  color,
  backgroundColor,
  distanceToTriggerSync,
  slingshotDistance,
  size,
  attributedTitle,
}

class PullToRefreshSettingsPatch
    extends PatchBase<PullToRefreshSettings, PullToRefreshSettings$> {
  PullToRefreshSettings applyTo(PullToRefreshSettings entity) {
    return entity.patchWithPullToRefreshSettings(this);
  }

  PullToRefreshSettingsPatch withEnabled(bool? value) {
    patchMap[PullToRefreshSettings$.enabled] = value;
    return this;
  }

  PullToRefreshSettingsPatch withColor(Color? value) {
    patchMap[PullToRefreshSettings$.color] = value;
    return this;
  }

  PullToRefreshSettingsPatch withBackgroundColor(Color? value) {
    patchMap[PullToRefreshSettings$.backgroundColor] = value;
    return this;
  }

  PullToRefreshSettingsPatch withDistanceToTriggerSync(int? value) {
    patchMap[PullToRefreshSettings$.distanceToTriggerSync] = value;
    return this;
  }

  PullToRefreshSettingsPatch withSlingshotDistance(int? value) {
    patchMap[PullToRefreshSettings$.slingshotDistance] = value;
    return this;
  }

  PullToRefreshSettingsPatch withSize(PullToRefreshSize? value) {
    patchMap[PullToRefreshSettings$.size] = value;
    return this;
  }

  PullToRefreshSettingsPatch withAttributedTitle(AttributedString? value) {
    patchMap[PullToRefreshSettings$.attributedTitle] = value;
    return this;
  }

  PullToRefreshSettingsPatch withAttributedTitlePatch(
    AttributedStringPatch patch,
  ) {
    patchMap[PullToRefreshSettings$.attributedTitle] = patch;
    return this;
  }

  PullToRefreshSettingsPatch withAttributedTitlePatchFunc(
    AttributedStringPatch Function(AttributedStringPatch) patch,
  ) {
    patchMap[PullToRefreshSettings$.attributedTitle] = (dynamic current) {
      var currentPatch = AttributedStringPatch();
      return patch(currentPatch).applyTo(current as AttributedString);
    };
    return this;
  }
}

/// Field descriptors for [PullToRefreshSettings] query construction
abstract final class PullToRefreshSettingsFields {
  static const enabled = Field<PullToRefreshSettings, bool?>(
    'enabled',
    _$enabled,
  );

  static const color = Field<PullToRefreshSettings, Color?>('color', _$color);

  static const backgroundColor = Field<PullToRefreshSettings, Color?>(
    'backgroundColor',
    _$backgroundColor,
  );

  static const distanceToTriggerSync = Field<PullToRefreshSettings, int?>(
    'distanceToTriggerSync',
    _$distanceToTriggerSync,
  );

  static const slingshotDistance = Field<PullToRefreshSettings, int?>(
    'slingshotDistance',
    _$slingshotDistance,
  );

  static const size = Field<PullToRefreshSettings, PullToRefreshSize?>(
    'size',
    _$size,
  );

  static const attributedTitle =
      Field<PullToRefreshSettings, AttributedString?>(
        'attributedTitle',
        _$attributedTitle,
      );

  static bool? _$enabled(PullToRefreshSettings e) {
    return e.enabled;
  }

  static Color? _$color(PullToRefreshSettings e) {
    return e.color;
  }

  static Color? _$backgroundColor(PullToRefreshSettings e) {
    return e.backgroundColor;
  }

  static int? _$distanceToTriggerSync(PullToRefreshSettings e) {
    return e.distanceToTriggerSync;
  }

  static int? _$slingshotDistance(PullToRefreshSettings e) {
    return e.slingshotDistance;
  }

  static PullToRefreshSize? _$size(PullToRefreshSettings e) {
    return e.size;
  }

  static AttributedString? _$attributedTitle(PullToRefreshSettings e) {
    return e.attributedTitle;
  }
}

extension PullToRefreshSettingsCompareE on PullToRefreshSettings {
  Map<String, dynamic> compareToPullToRefreshSettings(
    PullToRefreshSettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (enabled != other.enabled) {
      diff['enabled'] = () => other.enabled;
    }

    if (color != other.color) {
      diff['color'] = () => other.color;
    }

    if (backgroundColor != other.backgroundColor) {
      diff['backgroundColor'] = () => other.backgroundColor;
    }

    if (distanceToTriggerSync != other.distanceToTriggerSync) {
      diff['distanceToTriggerSync'] = () => other.distanceToTriggerSync;
    }

    if (slingshotDistance != other.slingshotDistance) {
      diff['slingshotDistance'] = () => other.slingshotDistance;
    }

    if (size != other.size) {
      diff['size'] = () => other.size;
    }

    if (attributedTitle != other.attributedTitle) {
      diff['attributedTitle'] = () => other.attributedTitle;
    }
    return diff;
  }
}
