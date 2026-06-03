// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_window_action.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the navigation request used by the [PlatformWebViewCreationParams.onCreateWindow] event.
class CreateWindowAction extends NavigationAction {
  ///Indicates if the new window should be a dialog, rather than a full-size window.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  bool? isDialog;

  ///Window features requested by the webpage.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKWindowFeatures](https://developer.apple.com/documentation/webkit/wkwindowfeatures))
  ///- MacOS ([Official API - WKWindowFeatures](https://developer.apple.com/documentation/webkit/wkwindowfeatures))
  WindowFeatures? windowFeatures;

  ///The window id. Used by `WebView` to create a new WebView.
  int windowId;
  CreateWindowAction(
      {this.isDialog,
      this.windowFeatures,
      required this.windowId,
      required URLRequest request,
      required bool isForMainFrame,
      bool? hasGesture,
      bool? isRedirect,
      NavigationType? navigationType,
      FrameInfo? sourceFrame,
      FrameInfo? targetFrame,
      bool? shouldPerformDownload})
      : super(
            request: request,
            isForMainFrame: isForMainFrame,
            hasGesture: hasGesture,
            isRedirect: isRedirect,
            navigationType: navigationType,
            sourceFrame: sourceFrame,
            targetFrame: targetFrame,
            shouldPerformDownload: shouldPerformDownload);

  ///Gets a possible [CreateWindowAction] instance from a [Map] value.
  static CreateWindowAction? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = CreateWindowAction(
      request: URLRequest.fromMap(map['request']?.cast<String, dynamic>())!,
      isForMainFrame: map['isForMainFrame'],
      isDialog: map['isDialog'],
      windowFeatures: WindowFeatures.fromMap(
          map['windowFeatures']?.cast<String, dynamic>()),
      windowId: map['windowId'],
    );
    instance.hasGesture = map['hasGesture'];
    instance.isRedirect = map['isRedirect'];
    instance.navigationType =
        NavigationType.fromNativeValue(map['navigationType']);
    instance.sourceFrame =
        FrameInfo.fromMap(map['sourceFrame']?.cast<String, dynamic>());
    instance.targetFrame =
        FrameInfo.fromMap(map['targetFrame']?.cast<String, dynamic>());
    instance.shouldPerformDownload = map['shouldPerformDownload'];
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "request": request.toMap(),
      "isForMainFrame": isForMainFrame,
      "hasGesture": hasGesture,
      "isRedirect": isRedirect,
      "navigationType": navigationType?.toNativeValue(),
      "sourceFrame": sourceFrame?.toMap(),
      "targetFrame": targetFrame?.toMap(),
      "shouldPerformDownload": shouldPerformDownload,
      "isDialog": isDialog,
      "windowFeatures": windowFeatures?.toMap(),
      "windowId": windowId,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CreateWindowAction{request: $request, isForMainFrame: $isForMainFrame, hasGesture: $hasGesture, isRedirect: $isRedirect, navigationType: $navigationType, sourceFrame: $sourceFrame, targetFrame: $targetFrame, shouldPerformDownload: $shouldPerformDownload, isDialog: $isDialog, windowFeatures: $windowFeatures, windowId: $windowId}';
  }
}
