import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import '../web_uri.dart';

part 'js_alert_request.g.dart';

///Class that represents the request of the [PlatformWebViewCreationParams.onJsAlert] event.
@ExchangeableObject()
class JsAlertRequest_ {
  ///The url of the page requesting the dialog.
  WebUri? url;

  ///Message to be displayed in the window.
  String? message;

  ///Indicates whether the request was made for the main frame.
  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  bool? isMainFrame;

  JsAlertRequest_({this.url, this.message, this.isMainFrame});
}
