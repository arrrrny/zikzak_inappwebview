// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'tracing_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class TracingSettings {
  TracingSettings({
    required List<dynamic> this.categories,
    TracingMode? this.tracingMode,
  });

  factory TracingSettings.fromJson(Map<String, dynamic> json) =>
      _$TracingSettingsFromJson(json);

  @JsonKey(toJson: _serializeCategories, fromJson: _deserializeCategories)
  final List<dynamic> categories;

  @JsonKey(toJson: _tracingModeToJson, fromJson: _tracingModeFromJson)
  final TracingMode? tracingMode;

  TracingSettings copyWith({
    List<dynamic>? categories,
    TracingMode? tracingMode,
  }) {
    return TracingSettings(
      categories: categories ?? this.categories,
      tracingMode: tracingMode ?? this.tracingMode,
    );
  }

  TracingSettings copyWithTracingSettings({
    List<dynamic>? categories,
    TracingMode? tracingMode,
  }) {
    return copyWith(categories: categories, tracingMode: tracingMode);
  }

  TracingSettings patchWithTracingSettings([TracingSettingsPatch? patchInput]) {
    final _patcher = patchInput ?? TracingSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return TracingSettings(
      categories: _patchMap.containsKey(TracingSettings$.categories)
          ? ((_patchMap[TracingSettings$.categories] is Function)
                    ? _patchMap[TracingSettings$.categories](this.categories)
                    : (_patchMap[TracingSettings$.categories] is Patch)
                    ? _patchMap[TracingSettings$.categories].applyTo(
                        this.categories,
                      )
                    : _patchMap[TracingSettings$.categories])
                as List<dynamic>
          : this.categories,
      tracingMode: _patchMap.containsKey(TracingSettings$.tracingMode)
          ? ((_patchMap[TracingSettings$.tracingMode] is Function)
                    ? _patchMap[TracingSettings$.tracingMode](this.tracingMode)
                    : (_patchMap[TracingSettings$.tracingMode] is Patch)
                    ? _patchMap[TracingSettings$.tracingMode].applyTo(
                        this.tracingMode,
                      )
                    : _patchMap[TracingSettings$.tracingMode])
                as TracingMode?
          : this.tracingMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TracingSettings &&
        categories == other.categories &&
        tracingMode == other.tracingMode;
  }

  @override
  int get hashCode {
    return Object.hash(this.categories, this.tracingMode);
  }

  @override
  String toString() {
    return 'TracingSettings(' +
        'categories: ${categories}' +
        ', ' +
        'tracingMode: ${tracingMode})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$TracingSettingsToJson(this);
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

extension TracingSettingsPropertyHelpers on TracingSettings {
  bool get hasCategories {
    return this.categories.isNotEmpty;
  }

  bool get noCategories {
    return this.categories.isEmpty;
  }

  bool get hasTracingMode {
    return this.tracingMode != null;
  }

  bool get noTracingMode {
    return this.tracingMode == null;
  }

  TracingMode get tracingModeRequired {
    return this.tracingMode ??
        (throw StateError('tracingMode is required but was null'));
  }

  bool get isTracingModeRECORD_UNTIL_FULL {
    return this.tracingMode == TracingMode.RECORD_UNTIL_FULL;
  }

  bool get isTracingModeRECORD_CONTINUOUSLY {
    return this.tracingMode == TracingMode.RECORD_CONTINUOUSLY;
  }
}

extension TracingSettingsSerialization on TracingSettings {
  Map<String, dynamic> toJson() {
    return _$TracingSettingsToJson(this);
  }
}

enum TracingSettings$ { categories, tracingMode }

class TracingSettingsPatch
    extends PatchBase<TracingSettings, TracingSettings$> {
  TracingSettings applyTo(TracingSettings entity) {
    return entity.patchWithTracingSettings(this);
  }

  TracingSettingsPatch withCategories(List<dynamic>? value) {
    patchMap[TracingSettings$.categories] = value;
    return this;
  }

  TracingSettingsPatch withTracingMode(TracingMode? value) {
    patchMap[TracingSettings$.tracingMode] = value;
    return this;
  }
}

/// Field descriptors for [TracingSettings] query construction
abstract final class TracingSettingsFields {
  static const categories = Field<TracingSettings, List<dynamic>>(
    'categories',
    _$categories,
  );

  static const tracingMode = Field<TracingSettings, TracingMode?>(
    'tracingMode',
    _$tracingMode,
  );

  static List<dynamic> _$categories(TracingSettings e) {
    return e.categories;
  }

  static TracingMode? _$tracingMode(TracingSettings e) {
    return e.tracingMode;
  }
}

extension TracingSettingsCompareE on TracingSettings {
  Map<String, dynamic> compareToTracingSettings(TracingSettings other) {
    final Map<String, dynamic> diff = {};

    if (categories != other.categories) {
      diff['categories'] = () => other.categories;
    }

    if (tracingMode != other.tracingMode) {
      diff['tracingMode'] = () => other.tracingMode;
    }
    return diff;
  }
}
