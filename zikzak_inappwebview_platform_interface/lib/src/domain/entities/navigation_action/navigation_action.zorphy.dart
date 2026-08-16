// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'navigation_action.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class NavigationAction {
  NavigationAction({
    required URLRequest this.request,
    required bool this.isForMainFrame,
    bool? this.hasGesture,
    bool? this.isRedirect,
    NavigationType? this.navigationType,
    FrameInfo? this.sourceFrame,
    FrameInfo? this.targetFrame,
    bool? this.shouldPerformDownload,
  });

  factory NavigationAction.fromJson(Map<String, dynamic> json) =>
      _$NavigationActionFromJson(json);

  @JsonKey(toJson: _requestToJson, fromJson: _requestFromJson)
  final URLRequest request;

  final bool isForMainFrame;

  final bool? hasGesture;

  final bool? isRedirect;

  @JsonKey(toJson: _navigationTypeToJson, fromJson: _navigationTypeFromJson)
  final NavigationType? navigationType;

  @JsonKey(toJson: _sourceFrameToJson, fromJson: _sourceFrameFromJson)
  final FrameInfo? sourceFrame;

  @JsonKey(toJson: _targetFrameToJson, fromJson: _targetFrameFromJson)
  final FrameInfo? targetFrame;

  final bool? shouldPerformDownload;

  NavigationAction copyWith({
    URLRequest? request,
    bool? isForMainFrame,
    bool? hasGesture,
    bool? isRedirect,
    NavigationType? navigationType,
    FrameInfo? sourceFrame,
    FrameInfo? targetFrame,
    bool? shouldPerformDownload,
  }) {
    return NavigationAction(
      request: request ?? this.request,
      isForMainFrame: isForMainFrame ?? this.isForMainFrame,
      hasGesture: hasGesture ?? this.hasGesture,
      isRedirect: isRedirect ?? this.isRedirect,
      navigationType: navigationType ?? this.navigationType,
      sourceFrame: sourceFrame ?? this.sourceFrame,
      targetFrame: targetFrame ?? this.targetFrame,
      shouldPerformDownload:
          shouldPerformDownload ?? this.shouldPerformDownload,
    );
  }

  NavigationAction copyWithNavigationAction({
    URLRequest? request,
    bool? isForMainFrame,
    bool? hasGesture,
    bool? isRedirect,
    NavigationType? navigationType,
    FrameInfo? sourceFrame,
    FrameInfo? targetFrame,
    bool? shouldPerformDownload,
  }) {
    return copyWith(
      request: request,
      isForMainFrame: isForMainFrame,
      hasGesture: hasGesture,
      isRedirect: isRedirect,
      navigationType: navigationType,
      sourceFrame: sourceFrame,
      targetFrame: targetFrame,
      shouldPerformDownload: shouldPerformDownload,
    );
  }

  NavigationAction patchWithNavigationAction([
    NavigationActionPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? NavigationActionPatch();
    final _patchMap = _patcher.patchMap;
    return NavigationAction(
      request: _patchMap.containsKey(NavigationAction$.request)
          ? (_patchMap[NavigationAction$.request] is Function)
                ? _patchMap[NavigationAction$.request](this.request)
                : (_patchMap[NavigationAction$.request] is Patch)
                ? _patchMap[NavigationAction$.request].applyTo(this.request)
                : _patchMap[NavigationAction$.request]
          : this.request,
      isForMainFrame: _patchMap.containsKey(NavigationAction$.isForMainFrame)
          ? (_patchMap[NavigationAction$.isForMainFrame] is Function)
                ? _patchMap[NavigationAction$.isForMainFrame](
                    this.isForMainFrame,
                  )
                : (_patchMap[NavigationAction$.isForMainFrame] is Patch)
                ? _patchMap[NavigationAction$.isForMainFrame].applyTo(
                    this.isForMainFrame,
                  )
                : _patchMap[NavigationAction$.isForMainFrame]
          : this.isForMainFrame,
      hasGesture: _patchMap.containsKey(NavigationAction$.hasGesture)
          ? (_patchMap[NavigationAction$.hasGesture] is Function)
                ? _patchMap[NavigationAction$.hasGesture](this.hasGesture)
                : (_patchMap[NavigationAction$.hasGesture] is Patch)
                ? _patchMap[NavigationAction$.hasGesture].applyTo(
                    this.hasGesture,
                  )
                : _patchMap[NavigationAction$.hasGesture]
          : this.hasGesture,
      isRedirect: _patchMap.containsKey(NavigationAction$.isRedirect)
          ? (_patchMap[NavigationAction$.isRedirect] is Function)
                ? _patchMap[NavigationAction$.isRedirect](this.isRedirect)
                : (_patchMap[NavigationAction$.isRedirect] is Patch)
                ? _patchMap[NavigationAction$.isRedirect].applyTo(
                    this.isRedirect,
                  )
                : _patchMap[NavigationAction$.isRedirect]
          : this.isRedirect,
      navigationType: _patchMap.containsKey(NavigationAction$.navigationType)
          ? (_patchMap[NavigationAction$.navigationType] is Function)
                ? _patchMap[NavigationAction$.navigationType](
                    this.navigationType,
                  )
                : (_patchMap[NavigationAction$.navigationType] is Patch)
                ? _patchMap[NavigationAction$.navigationType].applyTo(
                    this.navigationType,
                  )
                : _patchMap[NavigationAction$.navigationType]
          : this.navigationType,
      sourceFrame: _patchMap.containsKey(NavigationAction$.sourceFrame)
          ? (_patchMap[NavigationAction$.sourceFrame] is Function)
                ? _patchMap[NavigationAction$.sourceFrame](this.sourceFrame)
                : (_patchMap[NavigationAction$.sourceFrame] is Patch)
                ? _patchMap[NavigationAction$.sourceFrame].applyTo(
                    this.sourceFrame,
                  )
                : _patchMap[NavigationAction$.sourceFrame]
          : this.sourceFrame,
      targetFrame: _patchMap.containsKey(NavigationAction$.targetFrame)
          ? (_patchMap[NavigationAction$.targetFrame] is Function)
                ? _patchMap[NavigationAction$.targetFrame](this.targetFrame)
                : (_patchMap[NavigationAction$.targetFrame] is Patch)
                ? _patchMap[NavigationAction$.targetFrame].applyTo(
                    this.targetFrame,
                  )
                : _patchMap[NavigationAction$.targetFrame]
          : this.targetFrame,
      shouldPerformDownload:
          _patchMap.containsKey(NavigationAction$.shouldPerformDownload)
          ? (_patchMap[NavigationAction$.shouldPerformDownload] is Function)
                ? _patchMap[NavigationAction$.shouldPerformDownload](
                    this.shouldPerformDownload,
                  )
                : (_patchMap[NavigationAction$.shouldPerformDownload] is Patch)
                ? _patchMap[NavigationAction$.shouldPerformDownload].applyTo(
                    this.shouldPerformDownload,
                  )
                : _patchMap[NavigationAction$.shouldPerformDownload]
          : this.shouldPerformDownload,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationAction &&
        request == other.request &&
        isForMainFrame == other.isForMainFrame &&
        hasGesture == other.hasGesture &&
        isRedirect == other.isRedirect &&
        navigationType == other.navigationType &&
        sourceFrame == other.sourceFrame &&
        targetFrame == other.targetFrame &&
        shouldPerformDownload == other.shouldPerformDownload;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.request,
      this.isForMainFrame,
      this.hasGesture,
      this.isRedirect,
      this.navigationType,
      this.sourceFrame,
      this.targetFrame,
      this.shouldPerformDownload,
    );
  }

  @override
  String toString() {
    return 'NavigationAction(' +
        'request: ${request}' +
        ', ' +
        'isForMainFrame: ${isForMainFrame}' +
        ', ' +
        'hasGesture: ${hasGesture}' +
        ', ' +
        'isRedirect: ${isRedirect}' +
        ', ' +
        'navigationType: ${navigationType}' +
        ', ' +
        'sourceFrame: ${sourceFrame}' +
        ', ' +
        'targetFrame: ${targetFrame}' +
        ', ' +
        'shouldPerformDownload: ${shouldPerformDownload})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$NavigationActionToJson(this);
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

extension NavigationActionPropertyHelpers on NavigationAction {
  bool get hasHasGesture {
    return this.hasGesture != null;
  }

  bool get noHasGesture {
    return this.hasGesture == null;
  }

  bool get hasGestureRequired {
    return this.hasGesture ??
        (throw StateError('hasGesture is required but was null'));
  }

  bool get hasIsRedirect {
    return this.isRedirect != null;
  }

  bool get noIsRedirect {
    return this.isRedirect == null;
  }

  bool get isRedirectRequired {
    return this.isRedirect ??
        (throw StateError('isRedirect is required but was null'));
  }

  bool get hasNavigationType {
    return this.navigationType != null;
  }

  bool get noNavigationType {
    return this.navigationType == null;
  }

  NavigationType get navigationTypeRequired {
    return this.navigationType ??
        (throw StateError('navigationType is required but was null'));
  }

  bool get isNavigationTypeLINK_ACTIVATED {
    return this.navigationType == NavigationType.LINK_ACTIVATED;
  }

  bool get isNavigationTypeFORM_SUBMITTED {
    return this.navigationType == NavigationType.FORM_SUBMITTED;
  }

  bool get isNavigationTypeBACK_FORWARD {
    return this.navigationType == NavigationType.BACK_FORWARD;
  }

  bool get isNavigationTypeRELOAD {
    return this.navigationType == NavigationType.RELOAD;
  }

  bool get isNavigationTypeFORM_RESUBMITTED {
    return this.navigationType == NavigationType.FORM_RESUBMITTED;
  }

  bool get isNavigationTypeOTHER {
    return this.navigationType == NavigationType.OTHER;
  }

  bool get hasSourceFrame {
    return this.sourceFrame != null;
  }

  bool get noSourceFrame {
    return this.sourceFrame == null;
  }

  FrameInfo get sourceFrameRequired {
    return this.sourceFrame ??
        (throw StateError('sourceFrame is required but was null'));
  }

  bool get hasTargetFrame {
    return this.targetFrame != null;
  }

  bool get noTargetFrame {
    return this.targetFrame == null;
  }

  FrameInfo get targetFrameRequired {
    return this.targetFrame ??
        (throw StateError('targetFrame is required but was null'));
  }

  bool get hasShouldPerformDownload {
    return this.shouldPerformDownload != null;
  }

  bool get noShouldPerformDownload {
    return this.shouldPerformDownload == null;
  }

  bool get shouldPerformDownloadRequired {
    return this.shouldPerformDownload ??
        (throw StateError('shouldPerformDownload is required but was null'));
  }
}

extension NavigationActionSerialization on NavigationAction {
  Map<String, dynamic> toJson() {
    return _$NavigationActionToJson(this);
  }
}

enum NavigationAction$ {
  request,
  isForMainFrame,
  hasGesture,
  isRedirect,
  navigationType,
  sourceFrame,
  targetFrame,
  shouldPerformDownload,
}

class NavigationActionPatch
    extends PatchBase<NavigationAction, NavigationAction$> {
  NavigationAction applyTo(NavigationAction entity) {
    return entity.patchWithNavigationAction(this);
  }

  NavigationActionPatch withRequest(URLRequest? value) {
    patchMap[NavigationAction$.request] = value;
    return this;
  }

  NavigationActionPatch withRequestPatch(URLRequestPatch patch) {
    patchMap[NavigationAction$.request] = patch;
    return this;
  }

  NavigationActionPatch withRequestPatchFunc(
    URLRequestPatch Function(URLRequestPatch) patch,
  ) {
    patchMap[NavigationAction$.request] = (dynamic current) {
      var currentPatch = URLRequestPatch();
      return patch(currentPatch).applyTo(current as URLRequest);
    };
    return this;
  }

  NavigationActionPatch withIsForMainFrame(bool? value) {
    patchMap[NavigationAction$.isForMainFrame] = value;
    return this;
  }

  NavigationActionPatch withHasGesture(bool? value) {
    patchMap[NavigationAction$.hasGesture] = value;
    return this;
  }

  NavigationActionPatch withIsRedirect(bool? value) {
    patchMap[NavigationAction$.isRedirect] = value;
    return this;
  }

  NavigationActionPatch withNavigationType(NavigationType? value) {
    patchMap[NavigationAction$.navigationType] = value;
    return this;
  }

  NavigationActionPatch withSourceFrame(FrameInfo? value) {
    patchMap[NavigationAction$.sourceFrame] = value;
    return this;
  }

  NavigationActionPatch withSourceFramePatch(FrameInfoPatch patch) {
    patchMap[NavigationAction$.sourceFrame] = patch;
    return this;
  }

  NavigationActionPatch withSourceFramePatchFunc(
    FrameInfoPatch Function(FrameInfoPatch) patch,
  ) {
    patchMap[NavigationAction$.sourceFrame] = (dynamic current) {
      var currentPatch = FrameInfoPatch();
      return patch(currentPatch).applyTo(current as FrameInfo);
    };
    return this;
  }

  NavigationActionPatch withTargetFrame(FrameInfo? value) {
    patchMap[NavigationAction$.targetFrame] = value;
    return this;
  }

  NavigationActionPatch withTargetFramePatch(FrameInfoPatch patch) {
    patchMap[NavigationAction$.targetFrame] = patch;
    return this;
  }

  NavigationActionPatch withTargetFramePatchFunc(
    FrameInfoPatch Function(FrameInfoPatch) patch,
  ) {
    patchMap[NavigationAction$.targetFrame] = (dynamic current) {
      var currentPatch = FrameInfoPatch();
      return patch(currentPatch).applyTo(current as FrameInfo);
    };
    return this;
  }

  NavigationActionPatch withShouldPerformDownload(bool? value) {
    patchMap[NavigationAction$.shouldPerformDownload] = value;
    return this;
  }
}

/// Field descriptors for [NavigationAction] query construction
abstract final class NavigationActionFields {
  static const request = Field<NavigationAction, URLRequest>(
    'request',
    _$request,
  );

  static const isForMainFrame = Field<NavigationAction, bool>(
    'isForMainFrame',
    _$isForMainFrame,
  );

  static const hasGesture = Field<NavigationAction, bool?>(
    'hasGesture',
    _$hasGesture,
  );

  static const isRedirect = Field<NavigationAction, bool?>(
    'isRedirect',
    _$isRedirect,
  );

  static const navigationType = Field<NavigationAction, NavigationType?>(
    'navigationType',
    _$navigationType,
  );

  static const sourceFrame = Field<NavigationAction, FrameInfo?>(
    'sourceFrame',
    _$sourceFrame,
  );

  static const targetFrame = Field<NavigationAction, FrameInfo?>(
    'targetFrame',
    _$targetFrame,
  );

  static const shouldPerformDownload = Field<NavigationAction, bool?>(
    'shouldPerformDownload',
    _$shouldPerformDownload,
  );

  static URLRequest _$request(NavigationAction e) {
    return e.request;
  }

  static bool _$isForMainFrame(NavigationAction e) {
    return e.isForMainFrame;
  }

  static bool? _$hasGesture(NavigationAction e) {
    return e.hasGesture;
  }

  static bool? _$isRedirect(NavigationAction e) {
    return e.isRedirect;
  }

  static NavigationType? _$navigationType(NavigationAction e) {
    return e.navigationType;
  }

  static FrameInfo? _$sourceFrame(NavigationAction e) {
    return e.sourceFrame;
  }

  static FrameInfo? _$targetFrame(NavigationAction e) {
    return e.targetFrame;
  }

  static bool? _$shouldPerformDownload(NavigationAction e) {
    return e.shouldPerformDownload;
  }
}

extension NavigationActionCompareE on NavigationAction {
  Map<String, dynamic> compareToNavigationAction(NavigationAction other) {
    final Map<String, dynamic> diff = {};

    if (request != other.request) {
      diff['request'] = () => other.request;
    }

    if (isForMainFrame != other.isForMainFrame) {
      diff['isForMainFrame'] = () => other.isForMainFrame;
    }

    if (hasGesture != other.hasGesture) {
      diff['hasGesture'] = () => other.hasGesture;
    }

    if (isRedirect != other.isRedirect) {
      diff['isRedirect'] = () => other.isRedirect;
    }

    if (navigationType != other.navigationType) {
      diff['navigationType'] = () => other.navigationType;
    }

    if (sourceFrame != other.sourceFrame) {
      diff['sourceFrame'] = () => other.sourceFrame;
    }

    if (targetFrame != other.targetFrame) {
      diff['targetFrame'] = () => other.targetFrame;
    }

    if (shouldPerformDownload != other.shouldPerformDownload) {
      diff['shouldPerformDownload'] = () => other.shouldPerformDownload;
    }
    return diff;
  }
}
