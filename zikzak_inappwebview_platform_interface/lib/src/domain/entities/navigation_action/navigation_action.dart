// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: sibling-entity (URLRequest/FrameInfo) + platform-
// native NavigationType wire glue.

import 'package:flutter/foundation.dart';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../url_request/url_request.dart';
import '../enums/navigation_type.dart';
import '../frame_info/frame_info.dart';

part 'navigation_action.zorphy.dart';
part 'navigation_action.g.dart';

///An object that contains information about an action that causes navigation to occur.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $NavigationAction {
  ///The URL request object associated with the navigation action.
  ///
  ///**NOTE for Android**: If the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event
  ///and the window has been created using JavaScript, [request.url] will be `null`,
  ///the [request.method] is always `GET`, and [request.headers] value is always `null`.
  ///Also, on Android < 21, the [request.method]  is always `GET` and [request.headers] value is always `null`.
  @JsonKey(fromJson: _requestFromJson, toJson: _requestToJson)
  URLRequest get request;

  ///Indicates whether the request was made for the main frame.
  ///
  ///**NOTE for Android**: If the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event, this is always `true`.
  ///Also, on Android < 21, this is always `true`.
  bool get isForMainFrame;

  ///Gets whether a gesture (such as a click) was associated with the request.
  ///For security reasons in certain situations this method may return `false` even though
  ///the sequence of events which caused the request to be created was initiated by a user
  ///gesture.
  bool? get hasGesture;

  ///Gets whether the request was a result of a server-side redirect.
  ///
  ///**NOTE**: If the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event, this is always `false`.
  ///Also, on Android < 21, this is always `false`.
  bool? get isRedirect;

  ///The type of action triggering the navigation.
  @JsonKey(fromJson: _navigationTypeFromJson, toJson: _navigationTypeToJson)
  NavigationType? get navigationType;

  ///The frame that requested the navigation.
  @JsonKey(fromJson: _sourceFrameFromJson, toJson: _sourceFrameToJson)
  FrameInfo? get sourceFrame;

  ///The frame in which to display the new content.
  @JsonKey(fromJson: _targetFrameFromJson, toJson: _targetFrameToJson)
  FrameInfo? get targetFrame;

  ///A value indicating whether the web content used a download attribute to indicate that this should be downloaded.
  bool? get shouldPerformDownload;
}

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
