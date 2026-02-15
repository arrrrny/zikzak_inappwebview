import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../web_uri.dart';
import '../../types/main.dart';

/// Delegate for JavaScript-related methods of [PlatformInAppWebViewController].
abstract class PlatformJavaScriptDelegate extends PlatformInterface {
  /// Creates a new [PlatformJavaScriptDelegate]
  PlatformJavaScriptDelegate({required Object token}) : super(token: token);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.evaluateJavascript}
  Future<dynamic> evaluateJavascript({required String source}) {
    throw UnimplementedError(
        'evaluateJavascript is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.callAsyncJavaScript}
  Future<String?> callAsyncJavaScript(
      {required String functionBody,
      Map<String, dynamic> arguments = const <String, dynamic>{},
      ContentWorld? contentWorld}) {
    throw UnimplementedError(
        'callAsyncJavaScript is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectJavascriptFileFromUrl}
  Future<void> injectJavascriptFileFromUrl(
      {required WebUri urlFile,
      ScriptHtmlTagAttributes? scriptHtmlTagAttributes}) {
    throw UnimplementedError(
        'injectJavascriptFileFromUrl is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectJavascriptFileFromAsset}
  Future<void> injectJavascriptFileFromAsset(
      {required String assetFilePath}) {
    throw UnimplementedError(
        'injectJavascriptFileFromAsset is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSFileFromUrl}
  Future<void> injectCSSFileFromUrl(
      {required WebUri urlFile,
      CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes}) {
    throw UnimplementedError(
        'injectCSSFileFromUrl is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSFileFromAsset}
  Future<void> injectCSSFileFromAsset(
      {required String assetFilePath}) {
    throw UnimplementedError(
        'injectCSSFileFromAsset is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSCode}
  Future<void> injectCSSCode({required String source}) {
    throw UnimplementedError(
        'injectCSSCode is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.addJavaScriptHandler}
  void addJavaScriptHandler(
      {required String handlerName,
      required JavaScriptHandlerCallback callback}) {
    throw UnimplementedError(
        'addJavaScriptHandler is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeJavaScriptHandler}
  Future<JavaScriptHandlerCallback?> removeJavaScriptHandler(
      {required String handlerName}) {
    throw UnimplementedError(
        'removeJavaScriptHandler is not implemented on the current platform');
  }
}
