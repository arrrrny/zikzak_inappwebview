import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import 'navigation_action.dart';
import 'window_features.dart';
import 'url_request.dart';
import 'frame_info.dart';
import 'navigation_type.dart';
import '../in_app_webview/platform_webview.dart';

part 'create_window_action.g.dart';

///Class that represents the navigation request used by the [PlatformWebViewCreationParams.onCreateWindow] event.
@ExchangeableObject()
class CreateWindowAction_ extends NavigationAction_ {
  ///The window id. Used by `WebView` to create a new WebView.
  int windowId;

  ///Indicates if the new window should be a dialog, rather than a full-size window.
  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? isDialog;

  ///Window features requested by the webpage.
  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWindowFeatures",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwindowfeatures"),
    MacOSPlatform(
        apiName: "WKWindowFeatures",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwindowfeatures")
  ])
  WindowFeatures_? windowFeatures;

  CreateWindowAction_(
      {required this.windowId,
      this.isDialog,
      this.windowFeatures,
      required URLRequest_ request,
      required bool isForMainFrame,
      bool? hasGesture,
      bool? isRedirect,
      NavigationType_? navigationType,
      FrameInfo_? sourceFrame,
      FrameInfo_? targetFrame})
      : super(
            request: request,
            isForMainFrame: isForMainFrame,
            hasGesture: hasGesture,
            isRedirect: isRedirect,
            navigationType: navigationType,
            sourceFrame: sourceFrame,
            targetFrame: targetFrame);
}
