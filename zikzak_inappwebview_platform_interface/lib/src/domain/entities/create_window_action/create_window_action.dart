// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: flattened super-fields (the fork wire format for
// CreateWindowAction extends NavigationAction) + sibling-entity and
// platform-native NavigationType wire glue.

import 'package:flutter/foundation.dart';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../window_features/window_features.dart';
import '../url_request/url_request.dart';
import '../frame_info/frame_info.dart';
import '../enums/navigation_type.dart';

part 'create_window_action.zorphy.dart';
part 'create_window_action.g.dart';

///Class that represents the navigation request used by the [PlatformWebViewCreationParams.onCreateWindow] event.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $CreateWindowAction {
  ///The window id. Used by `WebView` to create a new WebView.
  int get windowId;

  ///Indicates if the new window should be a dialog, rather than a full-size window.
  bool? get isDialog;

  ///Window features requested by the webpage.
  @JsonKey(fromJson: _windowFeaturesFromJson, toJson: _windowFeaturesToJson)
  WindowFeatures? get windowFeatures;
  @JsonKey(fromJson: _requestFromJson, toJson: _requestToJson)
  URLRequest get request;
  bool get isForMainFrame;
  bool? get hasGesture;
  bool? get isRedirect;
  @JsonKey(fromJson: _navigationTypeFromJson, toJson: _navigationTypeToJson)
  NavigationType? get navigationType;
  @JsonKey(fromJson: _sourceFrameFromJson, toJson: _sourceFrameToJson)
  FrameInfo? get sourceFrame;
  @JsonKey(fromJson: _targetFrameFromJson, toJson: _targetFrameToJson)
  FrameInfo? get targetFrame;
}

WindowFeatures? _windowFeaturesFromJson(Object? value) => value == null
    ? null
    : WindowFeatures.fromJson((value as Map).cast<String, dynamic>());

Object? _windowFeaturesToJson(WindowFeatures? windowFeatures) =>
    windowFeatures?.toJson();

URLRequest _requestFromJson(Object? value) =>
    URLRequest.fromJson((value as Map).cast<String, dynamic>());

Object? _requestToJson(URLRequest? request) => request?.toJson();

FrameInfo? _sourceFrameFromJson(Object? value) => value == null
    ? null
    : FrameInfo.fromJson((value as Map).cast<String, dynamic>());

Object? _sourceFrameToJson(FrameInfo? frame) => frame?.toJson();

FrameInfo? _targetFrameFromJson(Object? value) => value == null
    ? null
    : FrameInfo.fromJson((value as Map).cast<String, dynamic>());

Object? _targetFrameToJson(FrameInfo? frame) => frame?.toJson();

///NavigationType wire values are platform-dependent (the old
///ExchangeableEnum codegen dispatched on `defaultTargetPlatform`): iOS/macOS
///send the `WKNavigationType` raw values, Windows sends the WebView2
///navigation-kind ints, Android sends nothing. These helpers replicate the
///old `toNativeValue`/`fromNativeValue` switch so the wire is unchanged.
NavigationType? _navigationTypeFromJson(Object? value) {
  if (value is String) {
    for (final type in NavigationType.values) {
      if (type.name == value) return type;
    }
    return null;
  }
  if (value is int) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return switch (value) {
          0 => NavigationType.LINK_ACTIVATED,
          1 => NavigationType.FORM_SUBMITTED,
          2 => NavigationType.BACK_FORWARD,
          3 => NavigationType.RELOAD,
          4 => NavigationType.FORM_RESUBMITTED,
          -1 => NavigationType.OTHER,
          _ => null,
        };
      case TargetPlatform.windows:
        return switch (value) {
          0 => NavigationType.LINK_ACTIVATED,
          1 => NavigationType.BACK_FORWARD,
          2 => NavigationType.RELOAD,
          3 => NavigationType.OTHER,
          _ => null,
        };
      default:
        return null;
    }
  }
  return null;
}

Object? _navigationTypeToJson(NavigationType? navigationType) {
  if (navigationType == null) return null;
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return switch (navigationType) {
        NavigationType.LINK_ACTIVATED => 0,
        NavigationType.FORM_SUBMITTED => 1,
        NavigationType.BACK_FORWARD => 2,
        NavigationType.RELOAD => 3,
        NavigationType.FORM_RESUBMITTED => 4,
        NavigationType.OTHER => -1,
      };
    case TargetPlatform.windows:
      return switch (navigationType) {
        NavigationType.LINK_ACTIVATED => 0,
        NavigationType.BACK_FORWARD => 1,
        NavigationType.RELOAD => 2,
        NavigationType.OTHER => 3,
        _ => null,
      };
    default:
      return null;
  }
}
