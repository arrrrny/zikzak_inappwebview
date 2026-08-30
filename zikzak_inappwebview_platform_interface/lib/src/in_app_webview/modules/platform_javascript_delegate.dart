import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../web_uri.dart';
import '../../types/main.dart';

/// Delegate for JavaScript-related methods of [PlatformInAppWebViewController].
///
/// Part of the domain-controller split (issue #229, P3): JavaScript
/// evaluation, handler management and asset injection are grouped behind
/// this focused facade so the main [PlatformInAppWebViewController] stays
/// easy to reason about.
///
/// Platform implementations override the [PlatformInAppWebViewController.javaScriptDelegate]
/// getter to return a concrete instance. The default getter returns `null`,
/// preserving backward compatibility for implementations that have not yet
/// been migrated.
abstract class PlatformJavaScriptDelegate extends PlatformInterface {
  /// Creates a new [PlatformJavaScriptDelegate].
  PlatformJavaScriptDelegate({required Object token}) : super(token: token);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.evaluateJavascript}
  Future<dynamic> evaluateJavascript({required String source}) {
    throw UnimplementedError(
      'evaluateJavascript is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.callAsyncJavaScript}
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    ContentWorld? contentWorld,
  }) {
    throw UnimplementedError(
      'callAsyncJavaScript is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectJavascriptFileFromUrl}
  Future<void> injectJavascriptFileFromUrl({
    required WebUri urlFile,
    ScriptHtmlTagAttributes? scriptHtmlTagAttributes,
  }) {
    throw UnimplementedError(
      'injectJavascriptFileFromUrl is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectJavascriptFileFromAsset}
  Future<dynamic> injectJavascriptFileFromAsset({
    required String assetFilePath,
  }) {
    throw UnimplementedError(
      'injectJavascriptFileFromAsset is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSFileFromUrl}
  Future<void> injectCSSFileFromUrl({
    required WebUri urlFile,
    CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes,
  }) {
    throw UnimplementedError(
      'injectCSSFileFromUrl is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSFileFromAsset}
  Future<void> injectCSSFileFromAsset({required String assetFilePath}) {
    throw UnimplementedError(
      'injectCSSFileFromAsset is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSCode}
  Future<void> injectCSSCode({required String source}) {
    throw UnimplementedError(
      'injectCSSCode is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.addJavaScriptHandler}
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    throw UnimplementedError(
      'addJavaScriptHandler is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeJavaScriptHandler}
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) {
    throw UnimplementedError(
      'removeJavaScriptHandler is not implemented on the current platform',
    );
  }
}
