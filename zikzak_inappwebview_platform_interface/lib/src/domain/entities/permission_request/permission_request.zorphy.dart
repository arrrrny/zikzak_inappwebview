// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'permission_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PermissionRequest {
  PermissionRequest({
    WebUri? this.origin,
    List<PermissionResourceType>? resources,
    FrameInfo? this.frame,
  }) : this.resources = resources ?? const [];

  factory PermissionRequest.fromJson(Map<String, dynamic> json) =>
      _$PermissionRequestFromJson(json);

  @JsonKey(toJson: _originToJson, fromJson: _originFromJson)
  final WebUri? origin;

  @JsonKey(
    defaultValue: const [],
    toJson: _resourcesToJson,
    fromJson: _resourcesFromJson,
  )
  final List<PermissionResourceType>? resources;

  @JsonKey(toJson: _frameToJson, fromJson: _frameFromJson)
  final FrameInfo? frame;

  PermissionRequest copyWith({
    WebUri? origin,
    List<PermissionResourceType>? resources,
    FrameInfo? frame,
  }) {
    return PermissionRequest(
      origin: origin ?? this.origin,
      resources: resources ?? this.resources,
      frame: frame ?? this.frame,
    );
  }

  PermissionRequest copyWithPermissionRequest({
    WebUri? origin,
    List<PermissionResourceType>? resources,
    FrameInfo? frame,
  }) {
    return copyWith(origin: origin, resources: resources, frame: frame);
  }

  PermissionRequest patchWithPermissionRequest([
    PermissionRequestPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PermissionRequestPatch();
    final _patchMap = _patcher.patchMap;
    return PermissionRequest(
      origin: _patchMap.containsKey(PermissionRequest$.origin)
          ? ((_patchMap[PermissionRequest$.origin] is Function)
                    ? _patchMap[PermissionRequest$.origin](this.origin)
                    : (_patchMap[PermissionRequest$.origin] is Patch)
                    ? _patchMap[PermissionRequest$.origin].applyTo(this.origin)
                    : _patchMap[PermissionRequest$.origin])
                as WebUri?
          : this.origin,
      resources: _patchMap.containsKey(PermissionRequest$.resources)
          ? ((_patchMap[PermissionRequest$.resources] is Function)
                    ? _patchMap[PermissionRequest$.resources](this.resources)
                    : (_patchMap[PermissionRequest$.resources] is Patch)
                    ? _patchMap[PermissionRequest$.resources].applyTo(
                        this.resources,
                      )
                    : _patchMap[PermissionRequest$.resources])
                as List<PermissionResourceType>?
          : this.resources,
      frame: _patchMap.containsKey(PermissionRequest$.frame)
          ? ((_patchMap[PermissionRequest$.frame] is Function)
                    ? _patchMap[PermissionRequest$.frame](this.frame)
                    : (_patchMap[PermissionRequest$.frame] is Patch)
                    ? _patchMap[PermissionRequest$.frame].applyTo(this.frame)
                    : _patchMap[PermissionRequest$.frame])
                as FrameInfo?
          : this.frame,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PermissionRequest &&
        origin == other.origin &&
        resources == other.resources &&
        frame == other.frame;
  }

  @override
  int get hashCode {
    return Object.hash(this.origin, this.resources, this.frame);
  }

  @override
  String toString() {
    return 'PermissionRequest(' +
        'origin: ${origin}' +
        ', ' +
        'resources: ${resources}' +
        ', ' +
        'frame: ${frame})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PermissionRequestToJson(this);
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

extension PermissionRequestPropertyHelpers on PermissionRequest {
  bool get hasOrigin {
    return this.origin != null;
  }

  bool get noOrigin {
    return this.origin == null;
  }

  WebUri get originRequired {
    return this.origin ?? (throw StateError('origin is required but was null'));
  }

  List<PermissionResourceType> get resourcesRequired {
    return this.resources ??
        (throw StateError('resources is required but was null'));
  }

  bool get hasResources {
    return this.resources?.isNotEmpty ?? false;
  }

  bool get noResources {
    return this.resources?.isEmpty ?? true;
  }

  bool get hasFrame {
    return this.frame != null;
  }

  bool get noFrame {
    return this.frame == null;
  }

  FrameInfo get frameRequired {
    return this.frame ?? (throw StateError('frame is required but was null'));
  }
}

extension PermissionRequestSerialization on PermissionRequest {
  Map<String, dynamic> toJson() {
    return _$PermissionRequestToJson(this);
  }
}

enum PermissionRequest$ { origin, resources, frame }

class PermissionRequestPatch
    extends PatchBase<PermissionRequest, PermissionRequest$> {
  PermissionRequest applyTo(PermissionRequest entity) {
    return entity.patchWithPermissionRequest(this);
  }

  PermissionRequestPatch withOrigin(WebUri? value) {
    patchMap[PermissionRequest$.origin] = value;
    return this;
  }

  PermissionRequestPatch withResources(List<PermissionResourceType>? value) {
    patchMap[PermissionRequest$.resources] = value;
    return this;
  }

  PermissionRequestPatch withFrame(FrameInfo? value) {
    patchMap[PermissionRequest$.frame] = value;
    return this;
  }

  PermissionRequestPatch withFramePatch(FrameInfoPatch patch) {
    patchMap[PermissionRequest$.frame] = patch;
    return this;
  }

  PermissionRequestPatch withFramePatchFunc(
    FrameInfoPatch Function(FrameInfoPatch) patch,
  ) {
    patchMap[PermissionRequest$.frame] = (dynamic current) {
      var currentPatch = FrameInfoPatch();
      return patch(currentPatch).applyTo(current as FrameInfo);
    };
    return this;
  }
}

/// Field descriptors for [PermissionRequest] query construction
abstract final class PermissionRequestFields {
  static const origin = Field<PermissionRequest, WebUri?>('origin', _$origin);

  static const resources =
      Field<PermissionRequest, List<PermissionResourceType>?>(
        'resources',
        _$resources,
      );

  static const frame = Field<PermissionRequest, FrameInfo?>('frame', _$frame);

  static WebUri? _$origin(PermissionRequest e) {
    return e.origin;
  }

  static List<PermissionResourceType>? _$resources(PermissionRequest e) {
    return e.resources;
  }

  static FrameInfo? _$frame(PermissionRequest e) {
    return e.frame;
  }
}

extension PermissionRequestCompareE on PermissionRequest {
  Map<String, dynamic> compareToPermissionRequest(PermissionRequest other) {
    final Map<String, dynamic> diff = {};

    if (origin != other.origin) {
      diff['origin'] = () => other.origin;
    }

    if (resources != other.resources) {
      diff['resources'] = () => other.resources;
    }

    if (frame != other.frame) {
      diff['frame'] = () => other.frame;
    }
    return diff;
  }
}
