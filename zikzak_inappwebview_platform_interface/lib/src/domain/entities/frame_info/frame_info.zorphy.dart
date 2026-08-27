// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'frame_info.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class FrameInfo {
  FrameInfo({
    required bool this.isMainFrame,
    URLRequest? this.request,
    SecurityOrigin? this.securityOrigin,
  });

  factory FrameInfo.fromJson(Map<String, dynamic> json) =>
      _$FrameInfoFromJson(json);

  final bool isMainFrame;

  @JsonKey(toJson: _requestToJson, fromJson: _requestFromJson)
  final URLRequest? request;

  @JsonKey(toJson: _securityOriginToJson, fromJson: _securityOriginFromJson)
  final SecurityOrigin? securityOrigin;

  FrameInfo copyWith({
    bool? isMainFrame,
    URLRequest? request,
    SecurityOrigin? securityOrigin,
  }) {
    return FrameInfo(
      isMainFrame: isMainFrame ?? this.isMainFrame,
      request: request ?? this.request,
      securityOrigin: securityOrigin ?? this.securityOrigin,
    );
  }

  FrameInfo copyWithFrameInfo({
    bool? isMainFrame,
    URLRequest? request,
    SecurityOrigin? securityOrigin,
  }) {
    return copyWith(
      isMainFrame: isMainFrame,
      request: request,
      securityOrigin: securityOrigin,
    );
  }

  FrameInfo patchWithFrameInfo([FrameInfoPatch? patchInput]) {
    final _patcher = patchInput ?? FrameInfoPatch();
    final _patchMap = _patcher.patchMap;
    return FrameInfo(
      isMainFrame: _patchMap.containsKey(FrameInfo$.isMainFrame)
          ? (_patchMap[FrameInfo$.isMainFrame] is Function)
                ? _patchMap[FrameInfo$.isMainFrame](this.isMainFrame)
                : (_patchMap[FrameInfo$.isMainFrame] is Patch)
                ? _patchMap[FrameInfo$.isMainFrame].applyTo(this.isMainFrame)
                : _patchMap[FrameInfo$.isMainFrame]
          : this.isMainFrame,
      request: _patchMap.containsKey(FrameInfo$.request)
          ? (_patchMap[FrameInfo$.request] is Function)
                ? _patchMap[FrameInfo$.request](this.request)
                : (_patchMap[FrameInfo$.request] is Patch)
                ? _patchMap[FrameInfo$.request].applyTo(this.request)
                : _patchMap[FrameInfo$.request]
          : this.request,
      securityOrigin: _patchMap.containsKey(FrameInfo$.securityOrigin)
          ? (_patchMap[FrameInfo$.securityOrigin] is Function)
                ? _patchMap[FrameInfo$.securityOrigin](this.securityOrigin)
                : (_patchMap[FrameInfo$.securityOrigin] is Patch)
                ? _patchMap[FrameInfo$.securityOrigin].applyTo(
                    this.securityOrigin,
                  )
                : _patchMap[FrameInfo$.securityOrigin]
          : this.securityOrigin,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FrameInfo &&
        isMainFrame == other.isMainFrame &&
        request == other.request &&
        securityOrigin == other.securityOrigin;
  }

  @override
  int get hashCode {
    return Object.hash(this.isMainFrame, this.request, this.securityOrigin);
  }

  @override
  String toString() {
    return 'FrameInfo(' +
        'isMainFrame: ${isMainFrame}' +
        ', ' +
        'request: ${request}' +
        ', ' +
        'securityOrigin: ${securityOrigin})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$FrameInfoToJson(this);
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

extension FrameInfoPropertyHelpers on FrameInfo {
  bool get hasRequest {
    return this.request != null;
  }

  bool get noRequest {
    return this.request == null;
  }

  URLRequest get requestRequired {
    return this.request ??
        (throw StateError('request is required but was null'));
  }

  bool get hasSecurityOrigin {
    return this.securityOrigin != null;
  }

  bool get noSecurityOrigin {
    return this.securityOrigin == null;
  }

  SecurityOrigin get securityOriginRequired {
    return this.securityOrigin ??
        (throw StateError('securityOrigin is required but was null'));
  }
}

extension FrameInfoSerialization on FrameInfo {
  Map<String, dynamic> toJson() {
    return _$FrameInfoToJson(this);
  }
}

enum FrameInfo$ { isMainFrame, request, securityOrigin }

class FrameInfoPatch extends PatchBase<FrameInfo, FrameInfo$> {
  FrameInfo applyTo(FrameInfo entity) {
    return entity.patchWithFrameInfo(this);
  }

  FrameInfoPatch withIsMainFrame(bool? value) {
    patchMap[FrameInfo$.isMainFrame] = value;
    return this;
  }

  FrameInfoPatch withRequest(URLRequest? value) {
    patchMap[FrameInfo$.request] = value;
    return this;
  }

  FrameInfoPatch withRequestPatch(URLRequestPatch patch) {
    patchMap[FrameInfo$.request] = patch;
    return this;
  }

  FrameInfoPatch withRequestPatchFunc(
    URLRequestPatch Function(URLRequestPatch) patch,
  ) {
    patchMap[FrameInfo$.request] = (dynamic current) {
      var currentPatch = URLRequestPatch();
      return patch(currentPatch).applyTo(current as URLRequest);
    };
    return this;
  }

  FrameInfoPatch withSecurityOrigin(SecurityOrigin? value) {
    patchMap[FrameInfo$.securityOrigin] = value;
    return this;
  }

  FrameInfoPatch withSecurityOriginPatch(SecurityOriginPatch patch) {
    patchMap[FrameInfo$.securityOrigin] = patch;
    return this;
  }

  FrameInfoPatch withSecurityOriginPatchFunc(
    SecurityOriginPatch Function(SecurityOriginPatch) patch,
  ) {
    patchMap[FrameInfo$.securityOrigin] = (dynamic current) {
      var currentPatch = SecurityOriginPatch();
      return patch(currentPatch).applyTo(current as SecurityOrigin);
    };
    return this;
  }
}

/// Field descriptors for [FrameInfo] query construction
abstract final class FrameInfoFields {
  static const isMainFrame = Field<FrameInfo, bool>(
    'isMainFrame',
    _$isMainFrame,
  );

  static const request = Field<FrameInfo, URLRequest?>('request', _$request);

  static const securityOrigin = Field<FrameInfo, SecurityOrigin?>(
    'securityOrigin',
    _$securityOrigin,
  );

  static bool _$isMainFrame(FrameInfo e) {
    return e.isMainFrame;
  }

  static URLRequest? _$request(FrameInfo e) {
    return e.request;
  }

  static SecurityOrigin? _$securityOrigin(FrameInfo e) {
    return e.securityOrigin;
  }
}

extension FrameInfoCompareE on FrameInfo {
  Map<String, dynamic> compareToFrameInfo(FrameInfo other) {
    final Map<String, dynamic> diff = {};

    if (isMainFrame != other.isMainFrame) {
      diff['isMainFrame'] = () => other.isMainFrame;
    }

    if (request != other.request) {
      diff['request'] = () => other.request;
    }

    if (securityOrigin != other.securityOrigin) {
      diff['securityOrigin'] = () => other.securityOrigin;
    }
    return diff;
  }
}
