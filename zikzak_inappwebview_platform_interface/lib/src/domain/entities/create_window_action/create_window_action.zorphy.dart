// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'create_window_action.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class CreateWindowAction {
  CreateWindowAction({
    required int this.windowId,
    bool? this.isDialog,
    WindowFeatures? this.windowFeatures,
    required URLRequest this.request,
    required bool this.isForMainFrame,
    bool? this.hasGesture,
    bool? this.isRedirect,
    NavigationType? this.navigationType,
    FrameInfo? this.sourceFrame,
    FrameInfo? this.targetFrame,
  });

  factory CreateWindowAction.fromJson(Map<String, dynamic> json) =>
      _$CreateWindowActionFromJson(json);

  final int windowId;

  final bool? isDialog;

  @JsonKey(toJson: _windowFeaturesToJson, fromJson: _windowFeaturesFromJson)
  final WindowFeatures? windowFeatures;

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

  CreateWindowAction copyWith({
    int? windowId,
    bool? isDialog,
    WindowFeatures? windowFeatures,
    URLRequest? request,
    bool? isForMainFrame,
    bool? hasGesture,
    bool? isRedirect,
    NavigationType? navigationType,
    FrameInfo? sourceFrame,
    FrameInfo? targetFrame,
  }) {
    return CreateWindowAction(
      windowId: windowId ?? this.windowId,
      isDialog: isDialog ?? this.isDialog,
      windowFeatures: windowFeatures ?? this.windowFeatures,
      request: request ?? this.request,
      isForMainFrame: isForMainFrame ?? this.isForMainFrame,
      hasGesture: hasGesture ?? this.hasGesture,
      isRedirect: isRedirect ?? this.isRedirect,
      navigationType: navigationType ?? this.navigationType,
      sourceFrame: sourceFrame ?? this.sourceFrame,
      targetFrame: targetFrame ?? this.targetFrame,
    );
  }

  CreateWindowAction copyWithCreateWindowAction({
    int? windowId,
    bool? isDialog,
    WindowFeatures? windowFeatures,
    URLRequest? request,
    bool? isForMainFrame,
    bool? hasGesture,
    bool? isRedirect,
    NavigationType? navigationType,
    FrameInfo? sourceFrame,
    FrameInfo? targetFrame,
  }) {
    return copyWith(
      windowId: windowId,
      isDialog: isDialog,
      windowFeatures: windowFeatures,
      request: request,
      isForMainFrame: isForMainFrame,
      hasGesture: hasGesture,
      isRedirect: isRedirect,
      navigationType: navigationType,
      sourceFrame: sourceFrame,
      targetFrame: targetFrame,
    );
  }

  CreateWindowAction patchWithCreateWindowAction([
    CreateWindowActionPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? CreateWindowActionPatch();
    final _patchMap = _patcher.patchMap;
    return CreateWindowAction(
      windowId: _patchMap.containsKey(CreateWindowAction$.windowId)
          ? ((_patchMap[CreateWindowAction$.windowId] is Function)
                    ? _patchMap[CreateWindowAction$.windowId](this.windowId)
                    : (_patchMap[CreateWindowAction$.windowId] is Patch)
                    ? _patchMap[CreateWindowAction$.windowId].applyTo(
                        this.windowId,
                      )
                    : _patchMap[CreateWindowAction$.windowId])
                as int
          : this.windowId,
      isDialog: _patchMap.containsKey(CreateWindowAction$.isDialog)
          ? ((_patchMap[CreateWindowAction$.isDialog] is Function)
                    ? _patchMap[CreateWindowAction$.isDialog](this.isDialog)
                    : (_patchMap[CreateWindowAction$.isDialog] is Patch)
                    ? _patchMap[CreateWindowAction$.isDialog].applyTo(
                        this.isDialog,
                      )
                    : _patchMap[CreateWindowAction$.isDialog])
                as bool?
          : this.isDialog,
      windowFeatures: _patchMap.containsKey(CreateWindowAction$.windowFeatures)
          ? ((_patchMap[CreateWindowAction$.windowFeatures] is Function)
                    ? _patchMap[CreateWindowAction$.windowFeatures](
                        this.windowFeatures,
                      )
                    : (_patchMap[CreateWindowAction$.windowFeatures] is Patch)
                    ? _patchMap[CreateWindowAction$.windowFeatures].applyTo(
                        this.windowFeatures,
                      )
                    : _patchMap[CreateWindowAction$.windowFeatures])
                as WindowFeatures?
          : this.windowFeatures,
      request: _patchMap.containsKey(CreateWindowAction$.request)
          ? ((_patchMap[CreateWindowAction$.request] is Function)
                    ? _patchMap[CreateWindowAction$.request](this.request)
                    : (_patchMap[CreateWindowAction$.request] is Patch)
                    ? _patchMap[CreateWindowAction$.request].applyTo(
                        this.request,
                      )
                    : _patchMap[CreateWindowAction$.request])
                as URLRequest
          : this.request,
      isForMainFrame: _patchMap.containsKey(CreateWindowAction$.isForMainFrame)
          ? ((_patchMap[CreateWindowAction$.isForMainFrame] is Function)
                    ? _patchMap[CreateWindowAction$.isForMainFrame](
                        this.isForMainFrame,
                      )
                    : (_patchMap[CreateWindowAction$.isForMainFrame] is Patch)
                    ? _patchMap[CreateWindowAction$.isForMainFrame].applyTo(
                        this.isForMainFrame,
                      )
                    : _patchMap[CreateWindowAction$.isForMainFrame])
                as bool
          : this.isForMainFrame,
      hasGesture: _patchMap.containsKey(CreateWindowAction$.hasGesture)
          ? ((_patchMap[CreateWindowAction$.hasGesture] is Function)
                    ? _patchMap[CreateWindowAction$.hasGesture](this.hasGesture)
                    : (_patchMap[CreateWindowAction$.hasGesture] is Patch)
                    ? _patchMap[CreateWindowAction$.hasGesture].applyTo(
                        this.hasGesture,
                      )
                    : _patchMap[CreateWindowAction$.hasGesture])
                as bool?
          : this.hasGesture,
      isRedirect: _patchMap.containsKey(CreateWindowAction$.isRedirect)
          ? ((_patchMap[CreateWindowAction$.isRedirect] is Function)
                    ? _patchMap[CreateWindowAction$.isRedirect](this.isRedirect)
                    : (_patchMap[CreateWindowAction$.isRedirect] is Patch)
                    ? _patchMap[CreateWindowAction$.isRedirect].applyTo(
                        this.isRedirect,
                      )
                    : _patchMap[CreateWindowAction$.isRedirect])
                as bool?
          : this.isRedirect,
      navigationType: _patchMap.containsKey(CreateWindowAction$.navigationType)
          ? ((_patchMap[CreateWindowAction$.navigationType] is Function)
                    ? _patchMap[CreateWindowAction$.navigationType](
                        this.navigationType,
                      )
                    : (_patchMap[CreateWindowAction$.navigationType] is Patch)
                    ? _patchMap[CreateWindowAction$.navigationType].applyTo(
                        this.navigationType,
                      )
                    : _patchMap[CreateWindowAction$.navigationType])
                as NavigationType?
          : this.navigationType,
      sourceFrame: _patchMap.containsKey(CreateWindowAction$.sourceFrame)
          ? ((_patchMap[CreateWindowAction$.sourceFrame] is Function)
                    ? _patchMap[CreateWindowAction$.sourceFrame](
                        this.sourceFrame,
                      )
                    : (_patchMap[CreateWindowAction$.sourceFrame] is Patch)
                    ? _patchMap[CreateWindowAction$.sourceFrame].applyTo(
                        this.sourceFrame,
                      )
                    : _patchMap[CreateWindowAction$.sourceFrame])
                as FrameInfo?
          : this.sourceFrame,
      targetFrame: _patchMap.containsKey(CreateWindowAction$.targetFrame)
          ? ((_patchMap[CreateWindowAction$.targetFrame] is Function)
                    ? _patchMap[CreateWindowAction$.targetFrame](
                        this.targetFrame,
                      )
                    : (_patchMap[CreateWindowAction$.targetFrame] is Patch)
                    ? _patchMap[CreateWindowAction$.targetFrame].applyTo(
                        this.targetFrame,
                      )
                    : _patchMap[CreateWindowAction$.targetFrame])
                as FrameInfo?
          : this.targetFrame,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateWindowAction &&
        windowId == other.windowId &&
        isDialog == other.isDialog &&
        windowFeatures == other.windowFeatures &&
        request == other.request &&
        isForMainFrame == other.isForMainFrame &&
        hasGesture == other.hasGesture &&
        isRedirect == other.isRedirect &&
        navigationType == other.navigationType &&
        sourceFrame == other.sourceFrame &&
        targetFrame == other.targetFrame;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.windowId,
      this.isDialog,
      this.windowFeatures,
      this.request,
      this.isForMainFrame,
      this.hasGesture,
      this.isRedirect,
      this.navigationType,
      this.sourceFrame,
      this.targetFrame,
    );
  }

  @override
  String toString() {
    return 'CreateWindowAction(' +
        'windowId: ${windowId}' +
        ', ' +
        'isDialog: ${isDialog}' +
        ', ' +
        'windowFeatures: ${windowFeatures}' +
        ', ' +
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
        'targetFrame: ${targetFrame})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$CreateWindowActionToJson(this);
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

extension CreateWindowActionPropertyHelpers on CreateWindowAction {
  bool get hasIsDialog {
    return this.isDialog != null;
  }

  bool get noIsDialog {
    return this.isDialog == null;
  }

  bool get isDialogRequired {
    return this.isDialog ??
        (throw StateError('isDialog is required but was null'));
  }

  bool get hasWindowFeatures {
    return this.windowFeatures != null;
  }

  bool get noWindowFeatures {
    return this.windowFeatures == null;
  }

  WindowFeatures get windowFeaturesRequired {
    return this.windowFeatures ??
        (throw StateError('windowFeatures is required but was null'));
  }

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
}

extension CreateWindowActionSerialization on CreateWindowAction {
  Map<String, dynamic> toJson() {
    return _$CreateWindowActionToJson(this);
  }
}

enum CreateWindowAction$ {
  windowId,
  isDialog,
  windowFeatures,
  request,
  isForMainFrame,
  hasGesture,
  isRedirect,
  navigationType,
  sourceFrame,
  targetFrame,
}

class CreateWindowActionPatch
    extends PatchBase<CreateWindowAction, CreateWindowAction$> {
  CreateWindowAction applyTo(CreateWindowAction entity) {
    return entity.patchWithCreateWindowAction(this);
  }

  CreateWindowActionPatch withWindowId(int? value) {
    patchMap[CreateWindowAction$.windowId] = value;
    return this;
  }

  CreateWindowActionPatch withIsDialog(bool? value) {
    patchMap[CreateWindowAction$.isDialog] = value;
    return this;
  }

  CreateWindowActionPatch withWindowFeatures(WindowFeatures? value) {
    patchMap[CreateWindowAction$.windowFeatures] = value;
    return this;
  }

  CreateWindowActionPatch withWindowFeaturesPatch(WindowFeaturesPatch patch) {
    patchMap[CreateWindowAction$.windowFeatures] = patch;
    return this;
  }

  CreateWindowActionPatch withWindowFeaturesPatchFunc(
    WindowFeaturesPatch Function(WindowFeaturesPatch) patch,
  ) {
    patchMap[CreateWindowAction$.windowFeatures] = (dynamic current) {
      var currentPatch = WindowFeaturesPatch();
      return patch(currentPatch).applyTo(current as WindowFeatures);
    };
    return this;
  }

  CreateWindowActionPatch withRequest(URLRequest? value) {
    patchMap[CreateWindowAction$.request] = value;
    return this;
  }

  CreateWindowActionPatch withRequestPatch(URLRequestPatch patch) {
    patchMap[CreateWindowAction$.request] = patch;
    return this;
  }

  CreateWindowActionPatch withRequestPatchFunc(
    URLRequestPatch Function(URLRequestPatch) patch,
  ) {
    patchMap[CreateWindowAction$.request] = (dynamic current) {
      var currentPatch = URLRequestPatch();
      return patch(currentPatch).applyTo(current as URLRequest);
    };
    return this;
  }

  CreateWindowActionPatch withIsForMainFrame(bool? value) {
    patchMap[CreateWindowAction$.isForMainFrame] = value;
    return this;
  }

  CreateWindowActionPatch withHasGesture(bool? value) {
    patchMap[CreateWindowAction$.hasGesture] = value;
    return this;
  }

  CreateWindowActionPatch withIsRedirect(bool? value) {
    patchMap[CreateWindowAction$.isRedirect] = value;
    return this;
  }

  CreateWindowActionPatch withNavigationType(NavigationType? value) {
    patchMap[CreateWindowAction$.navigationType] = value;
    return this;
  }

  CreateWindowActionPatch withSourceFrame(FrameInfo? value) {
    patchMap[CreateWindowAction$.sourceFrame] = value;
    return this;
  }

  CreateWindowActionPatch withSourceFramePatch(FrameInfoPatch patch) {
    patchMap[CreateWindowAction$.sourceFrame] = patch;
    return this;
  }

  CreateWindowActionPatch withSourceFramePatchFunc(
    FrameInfoPatch Function(FrameInfoPatch) patch,
  ) {
    patchMap[CreateWindowAction$.sourceFrame] = (dynamic current) {
      var currentPatch = FrameInfoPatch();
      return patch(currentPatch).applyTo(current as FrameInfo);
    };
    return this;
  }

  CreateWindowActionPatch withTargetFrame(FrameInfo? value) {
    patchMap[CreateWindowAction$.targetFrame] = value;
    return this;
  }

  CreateWindowActionPatch withTargetFramePatch(FrameInfoPatch patch) {
    patchMap[CreateWindowAction$.targetFrame] = patch;
    return this;
  }

  CreateWindowActionPatch withTargetFramePatchFunc(
    FrameInfoPatch Function(FrameInfoPatch) patch,
  ) {
    patchMap[CreateWindowAction$.targetFrame] = (dynamic current) {
      var currentPatch = FrameInfoPatch();
      return patch(currentPatch).applyTo(current as FrameInfo);
    };
    return this;
  }
}

/// Field descriptors for [CreateWindowAction] query construction
abstract final class CreateWindowActionFields {
  static const windowId = Field<CreateWindowAction, int>(
    'windowId',
    _$windowId,
  );

  static const isDialog = Field<CreateWindowAction, bool?>(
    'isDialog',
    _$isDialog,
  );

  static const windowFeatures = Field<CreateWindowAction, WindowFeatures?>(
    'windowFeatures',
    _$windowFeatures,
  );

  static const request = Field<CreateWindowAction, URLRequest>(
    'request',
    _$request,
  );

  static const isForMainFrame = Field<CreateWindowAction, bool>(
    'isForMainFrame',
    _$isForMainFrame,
  );

  static const hasGesture = Field<CreateWindowAction, bool?>(
    'hasGesture',
    _$hasGesture,
  );

  static const isRedirect = Field<CreateWindowAction, bool?>(
    'isRedirect',
    _$isRedirect,
  );

  static const navigationType = Field<CreateWindowAction, NavigationType?>(
    'navigationType',
    _$navigationType,
  );

  static const sourceFrame = Field<CreateWindowAction, FrameInfo?>(
    'sourceFrame',
    _$sourceFrame,
  );

  static const targetFrame = Field<CreateWindowAction, FrameInfo?>(
    'targetFrame',
    _$targetFrame,
  );

  static int _$windowId(CreateWindowAction e) {
    return e.windowId;
  }

  static bool? _$isDialog(CreateWindowAction e) {
    return e.isDialog;
  }

  static WindowFeatures? _$windowFeatures(CreateWindowAction e) {
    return e.windowFeatures;
  }

  static URLRequest _$request(CreateWindowAction e) {
    return e.request;
  }

  static bool _$isForMainFrame(CreateWindowAction e) {
    return e.isForMainFrame;
  }

  static bool? _$hasGesture(CreateWindowAction e) {
    return e.hasGesture;
  }

  static bool? _$isRedirect(CreateWindowAction e) {
    return e.isRedirect;
  }

  static NavigationType? _$navigationType(CreateWindowAction e) {
    return e.navigationType;
  }

  static FrameInfo? _$sourceFrame(CreateWindowAction e) {
    return e.sourceFrame;
  }

  static FrameInfo? _$targetFrame(CreateWindowAction e) {
    return e.targetFrame;
  }
}

extension CreateWindowActionCompareE on CreateWindowAction {
  Map<String, dynamic> compareToCreateWindowAction(CreateWindowAction other) {
    final Map<String, dynamic> diff = {};

    if (windowId != other.windowId) {
      diff['windowId'] = () => other.windowId;
    }

    if (isDialog != other.isDialog) {
      diff['isDialog'] = () => other.isDialog;
    }

    if (windowFeatures != other.windowFeatures) {
      diff['windowFeatures'] = () => other.windowFeatures;
    }

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
    return diff;
  }
}
