// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'geolocation_permission_show_prompt_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class GeolocationPermissionShowPromptResponse {
  GeolocationPermissionShowPromptResponse({
    WebUri? this.origin,
    bool? this.allow,
    bool? retain,
  }) : this.retain = retain ?? false;

  factory GeolocationPermissionShowPromptResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GeolocationPermissionShowPromptResponseFromJson(json);

  @JsonKey(toJson: _originToJson, fromJson: _originFromJson)
  final WebUri? origin;

  final bool? allow;

  @JsonKey(defaultValue: false)
  final bool? retain;

  GeolocationPermissionShowPromptResponse copyWith({
    WebUri? origin,
    bool? allow,
    bool? retain,
  }) {
    return GeolocationPermissionShowPromptResponse(
      origin: origin ?? this.origin,
      allow: allow ?? this.allow,
      retain: retain ?? this.retain,
    );
  }

  GeolocationPermissionShowPromptResponse
  copyWithGeolocationPermissionShowPromptResponse({
    WebUri? origin,
    bool? allow,
    bool? retain,
  }) {
    return copyWith(origin: origin, allow: allow, retain: retain);
  }

  GeolocationPermissionShowPromptResponse
  patchWithGeolocationPermissionShowPromptResponse([
    GeolocationPermissionShowPromptResponsePatch? patchInput,
  ]) {
    final _patcher =
        patchInput ?? GeolocationPermissionShowPromptResponsePatch();
    final _patchMap = _patcher.patchMap;
    return GeolocationPermissionShowPromptResponse(
      origin:
          _patchMap.containsKey(GeolocationPermissionShowPromptResponse$.origin)
          ? (_patchMap[GeolocationPermissionShowPromptResponse$.origin]
                    is Function)
                ? _patchMap[GeolocationPermissionShowPromptResponse$.origin](
                    this.origin,
                  )
                : (_patchMap[GeolocationPermissionShowPromptResponse$.origin]
                      is Patch)
                ? _patchMap[GeolocationPermissionShowPromptResponse$.origin]
                      .applyTo(this.origin)
                : _patchMap[GeolocationPermissionShowPromptResponse$.origin]
          : this.origin,
      allow:
          _patchMap.containsKey(GeolocationPermissionShowPromptResponse$.allow)
          ? (_patchMap[GeolocationPermissionShowPromptResponse$.allow]
                    is Function)
                ? _patchMap[GeolocationPermissionShowPromptResponse$.allow](
                    this.allow,
                  )
                : (_patchMap[GeolocationPermissionShowPromptResponse$.allow]
                      is Patch)
                ? _patchMap[GeolocationPermissionShowPromptResponse$.allow]
                      .applyTo(this.allow)
                : _patchMap[GeolocationPermissionShowPromptResponse$.allow]
          : this.allow,
      retain:
          _patchMap.containsKey(GeolocationPermissionShowPromptResponse$.retain)
          ? (_patchMap[GeolocationPermissionShowPromptResponse$.retain]
                    is Function)
                ? _patchMap[GeolocationPermissionShowPromptResponse$.retain](
                    this.retain,
                  )
                : (_patchMap[GeolocationPermissionShowPromptResponse$.retain]
                      is Patch)
                ? _patchMap[GeolocationPermissionShowPromptResponse$.retain]
                      .applyTo(this.retain)
                : _patchMap[GeolocationPermissionShowPromptResponse$.retain]
          : this.retain,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeolocationPermissionShowPromptResponse &&
        origin == other.origin &&
        allow == other.allow &&
        retain == other.retain;
  }

  @override
  int get hashCode {
    return Object.hash(this.origin, this.allow, this.retain);
  }

  @override
  String toString() {
    return 'GeolocationPermissionShowPromptResponse(' +
        'origin: ${origin}' +
        ', ' +
        'allow: ${allow}' +
        ', ' +
        'retain: ${retain})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data =
        _$GeolocationPermissionShowPromptResponseToJson(this);
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

extension GeolocationPermissionShowPromptResponsePropertyHelpers
    on GeolocationPermissionShowPromptResponse {
  bool get hasOrigin {
    return this.origin != null;
  }

  bool get noOrigin {
    return this.origin == null;
  }

  WebUri get originRequired {
    return this.origin ?? (throw StateError('origin is required but was null'));
  }

  bool get hasAllow {
    return this.allow != null;
  }

  bool get noAllow {
    return this.allow == null;
  }

  bool get allowRequired {
    return this.allow ?? (throw StateError('allow is required but was null'));
  }

  bool get hasRetain {
    return this.retain != null;
  }

  bool get noRetain {
    return this.retain == null;
  }

  bool get retainRequired {
    return this.retain ?? (throw StateError('retain is required but was null'));
  }
}

extension GeolocationPermissionShowPromptResponseSerialization
    on GeolocationPermissionShowPromptResponse {
  Map<String, dynamic> toJson() {
    return _$GeolocationPermissionShowPromptResponseToJson(this);
  }
}

enum GeolocationPermissionShowPromptResponse$ { origin, allow, retain }

class GeolocationPermissionShowPromptResponsePatch
    extends
        PatchBase<
          GeolocationPermissionShowPromptResponse,
          GeolocationPermissionShowPromptResponse$
        > {
  GeolocationPermissionShowPromptResponse applyTo(
    GeolocationPermissionShowPromptResponse entity,
  ) {
    return entity.patchWithGeolocationPermissionShowPromptResponse(this);
  }

  GeolocationPermissionShowPromptResponsePatch withOrigin(WebUri? value) {
    patchMap[GeolocationPermissionShowPromptResponse$.origin] = value;
    return this;
  }

  GeolocationPermissionShowPromptResponsePatch withAllow(bool? value) {
    patchMap[GeolocationPermissionShowPromptResponse$.allow] = value;
    return this;
  }

  GeolocationPermissionShowPromptResponsePatch withRetain(bool? value) {
    patchMap[GeolocationPermissionShowPromptResponse$.retain] = value;
    return this;
  }
}

/// Field descriptors for [GeolocationPermissionShowPromptResponse] query construction
abstract final class GeolocationPermissionShowPromptResponseFields {
  static const origin = Field<GeolocationPermissionShowPromptResponse, WebUri?>(
    'origin',
    _$origin,
  );

  static const allow = Field<GeolocationPermissionShowPromptResponse, bool?>(
    'allow',
    _$allow,
  );

  static const retain = Field<GeolocationPermissionShowPromptResponse, bool?>(
    'retain',
    _$retain,
  );

  static WebUri? _$origin(GeolocationPermissionShowPromptResponse e) {
    return e.origin;
  }

  static bool? _$allow(GeolocationPermissionShowPromptResponse e) {
    return e.allow;
  }

  static bool? _$retain(GeolocationPermissionShowPromptResponse e) {
    return e.retain;
  }
}

extension GeolocationPermissionShowPromptResponseCompareE
    on GeolocationPermissionShowPromptResponse {
  Map<String, dynamic> compareToGeolocationPermissionShowPromptResponse(
    GeolocationPermissionShowPromptResponse other,
  ) {
    final Map<String, dynamic> diff = {};

    if (origin != other.origin) {
      diff['origin'] = () => other.origin;
    }

    if (allow != other.allow) {
      diff['allow'] = () => other.allow;
    }

    if (retain != other.retain) {
      diff['retain'] = () => other.retain;
    }
    return diff;
  }
}
