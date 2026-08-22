// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'loaded_resource.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class LoadedResource {
  LoadedResource({
    String? this.initiatorType,
    WebUri? this.url,
    double? this.startTime,
    double? this.duration,
  });

  factory LoadedResource.fromJson(Map<String, dynamic> json) =>
      _$LoadedResourceFromJson(json);

  final String? initiatorType;

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final double? startTime;

  final double? duration;

  LoadedResource copyWith({
    String? initiatorType,
    WebUri? url,
    double? startTime,
    double? duration,
  }) {
    return LoadedResource(
      initiatorType: initiatorType ?? this.initiatorType,
      url: url ?? this.url,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
    );
  }

  LoadedResource copyWithLoadedResource({
    String? initiatorType,
    WebUri? url,
    double? startTime,
    double? duration,
  }) {
    return copyWith(
      initiatorType: initiatorType,
      url: url,
      startTime: startTime,
      duration: duration,
    );
  }

  LoadedResource patchWithLoadedResource([LoadedResourcePatch? patchInput]) {
    final _patcher = patchInput ?? LoadedResourcePatch();
    final _patchMap = _patcher.patchMap;
    return LoadedResource(
      initiatorType: _patchMap.containsKey(LoadedResource$.initiatorType)
          ? (_patchMap[LoadedResource$.initiatorType] is Function)
                ? _patchMap[LoadedResource$.initiatorType](this.initiatorType)
                : (_patchMap[LoadedResource$.initiatorType] is Patch)
                ? _patchMap[LoadedResource$.initiatorType].applyTo(
                    this.initiatorType,
                  )
                : _patchMap[LoadedResource$.initiatorType]
          : this.initiatorType,
      url: _patchMap.containsKey(LoadedResource$.url)
          ? (_patchMap[LoadedResource$.url] is Function)
                ? _patchMap[LoadedResource$.url](this.url)
                : (_patchMap[LoadedResource$.url] is Patch)
                ? _patchMap[LoadedResource$.url].applyTo(this.url)
                : _patchMap[LoadedResource$.url]
          : this.url,
      startTime: _patchMap.containsKey(LoadedResource$.startTime)
          ? (_patchMap[LoadedResource$.startTime] is Function)
                ? _patchMap[LoadedResource$.startTime](this.startTime)
                : (_patchMap[LoadedResource$.startTime] is Patch)
                ? _patchMap[LoadedResource$.startTime].applyTo(this.startTime)
                : _patchMap[LoadedResource$.startTime]
          : this.startTime,
      duration: _patchMap.containsKey(LoadedResource$.duration)
          ? (_patchMap[LoadedResource$.duration] is Function)
                ? _patchMap[LoadedResource$.duration](this.duration)
                : (_patchMap[LoadedResource$.duration] is Patch)
                ? _patchMap[LoadedResource$.duration].applyTo(this.duration)
                : _patchMap[LoadedResource$.duration]
          : this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoadedResource &&
        initiatorType == other.initiatorType &&
        url == other.url &&
        startTime == other.startTime &&
        duration == other.duration;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.initiatorType,
      this.url,
      this.startTime,
      this.duration,
    );
  }

  @override
  String toString() {
    return 'LoadedResource(' +
        'initiatorType: ${initiatorType}' +
        ', ' +
        'url: ${url}' +
        ', ' +
        'startTime: ${startTime}' +
        ', ' +
        'duration: ${duration})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$LoadedResourceToJson(this);
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

extension LoadedResourcePropertyHelpers on LoadedResource {
  bool get hasInitiatorType {
    return this.initiatorType?.isNotEmpty == true;
  }

  bool get noInitiatorType {
    return this.initiatorType?.isEmpty ?? true;
  }

  String get initiatorTypeRequired {
    return this.initiatorType ??
        (throw StateError('initiatorType is required but was null'));
  }

  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
  }

  bool get hasStartTime {
    return this.startTime != null;
  }

  bool get noStartTime {
    return this.startTime == null;
  }

  double get startTimeRequired {
    return this.startTime ??
        (throw StateError('startTime is required but was null'));
  }

  bool get hasDuration {
    return this.duration != null;
  }

  bool get noDuration {
    return this.duration == null;
  }

  double get durationRequired {
    return this.duration ??
        (throw StateError('duration is required but was null'));
  }
}

extension LoadedResourceSerialization on LoadedResource {
  Map<String, dynamic> toJson() {
    return _$LoadedResourceToJson(this);
  }
}

enum LoadedResource$ { initiatorType, url, startTime, duration }

class LoadedResourcePatch extends PatchBase<LoadedResource, LoadedResource$> {
  LoadedResource applyTo(LoadedResource entity) {
    return entity.patchWithLoadedResource(this);
  }

  LoadedResourcePatch withInitiatorType(String? value) {
    patchMap[LoadedResource$.initiatorType] = value;
    return this;
  }

  LoadedResourcePatch withUrl(WebUri? value) {
    patchMap[LoadedResource$.url] = value;
    return this;
  }

  LoadedResourcePatch withStartTime(double? value) {
    patchMap[LoadedResource$.startTime] = value;
    return this;
  }

  LoadedResourcePatch withDuration(double? value) {
    patchMap[LoadedResource$.duration] = value;
    return this;
  }
}

/// Field descriptors for [LoadedResource] query construction
abstract final class LoadedResourceFields {
  static const initiatorType = Field<LoadedResource, String?>(
    'initiatorType',
    _$initiatorType,
  );

  static const url = Field<LoadedResource, WebUri?>('url', _$url);

  static const startTime = Field<LoadedResource, double?>(
    'startTime',
    _$startTime,
  );

  static const duration = Field<LoadedResource, double?>(
    'duration',
    _$duration,
  );

  static String? _$initiatorType(LoadedResource e) {
    return e.initiatorType;
  }

  static WebUri? _$url(LoadedResource e) {
    return e.url;
  }

  static double? _$startTime(LoadedResource e) {
    return e.startTime;
  }

  static double? _$duration(LoadedResource e) {
    return e.duration;
  }
}

extension LoadedResourceCompareE on LoadedResource {
  Map<String, dynamic> compareToLoadedResource(LoadedResource other) {
    final Map<String, dynamic> diff = {};

    if (initiatorType != other.initiatorType) {
      diff['initiatorType'] = () => other.initiatorType;
    }

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (startTime != other.startTime) {
      diff['startTime'] = () => other.startTime;
    }

    if (duration != other.duration) {
      diff['duration'] = () => other.duration;
    }
    return diff;
  }
}
