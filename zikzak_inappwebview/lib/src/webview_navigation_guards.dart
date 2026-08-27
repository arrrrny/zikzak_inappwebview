import 'dart:async';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview/in_app_webview_controller.dart';

///A `shouldOverrideUrlLoading` helper that keeps user-tapped links inside
///the WebView instead of letting iOS hand them off to the native app via
///universal links.
///
///On iOS, a user-activated navigation to an associated domain
///(`navigationType == LINK_ACTIVATED`) opens the installed native app
///instead of loading in the WebView — fatal for guided flows like session
///recording/replay. Re-issuing the navigation via
///[InAppWebViewController.loadUrl] (script-initiated) bypasses the
///universal-link handoff entirely.
///
///Usage:
///```dart
///InAppWebView(
///  shouldOverrideUrlLoading: keepNavigationInWebView,
///)
///```
Future<NavigationActionPolicy> keepNavigationInWebView(
  InAppWebViewController controller,
  NavigationAction action,
) async {
  final url = action.request.url;
  final isHttp = url != null && (url.isScheme('http') || url.isScheme('https'));
  if (action.isForMainFrame == true &&
      action.navigationType == NavigationType.LINK_ACTIVATED &&
      isHttp) {
    // Fire-and-forget: awaiting loadUrl inside the policy callback can
    // deadlock the navigation decision on some platforms.
    unawaited(controller.loadUrl(urlRequest: URLRequest(url: url)));
    return NavigationActionPolicy.CANCEL;
  }
  return NavigationActionPolicy.ALLOW;
}
