import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

/// Android implementation of [PlatformJavaScriptDelegate].
///
/// Forwards every call to the parent [AndroidInAppWebViewController].
/// Behavior is identical to calling the controller directly — this is a
/// focused facade, not a separate implementation. Part of the
/// domain-controller split (issue #229, P3).
class AndroidJavaScriptDelegate extends PlatformJavaScriptDelegate {
  /// Creates a new [AndroidJavaScriptDelegate] bound to [_controller].
  AndroidJavaScriptDelegate(this._controller) : super(token: _token);

  static final Object _token = Object();

  final AndroidInAppWebViewController _controller;

  @override
  Future<dynamic> evaluateJavascript({required String source}) =>
      _controller.evaluateJavascript(source: source);

  @override
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    ContentWorld? contentWorld,
  }) => _controller.callAsyncJavaScript(
    functionBody: functionBody,
    arguments: arguments,
    contentWorld: contentWorld,
  );

  @override
  Future<void> injectJavascriptFileFromUrl({
    required WebUri urlFile,
    ScriptHtmlTagAttributes? scriptHtmlTagAttributes,
  }) => _controller.injectJavascriptFileFromUrl(
    urlFile: urlFile,
    scriptHtmlTagAttributes: scriptHtmlTagAttributes,
  );

  @override
  Future<void> injectJavascriptFileFromAsset({required String assetFilePath}) =>
      _controller.injectJavascriptFileFromAsset(assetFilePath: assetFilePath);

  @override
  Future<void> injectCSSFileFromUrl({
    required WebUri urlFile,
    CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes,
  }) => _controller.injectCSSFileFromUrl(
    urlFile: urlFile,
    cssLinkHtmlTagAttributes: cssLinkHtmlTagAttributes,
  );

  @override
  Future<void> injectCSSFileFromAsset({required String assetFilePath}) =>
      _controller.injectCSSFileFromAsset(assetFilePath: assetFilePath);

  @override
  Future<void> injectCSSCode({required String source}) =>
      _controller.injectCSSCode(source: source);

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) => _controller.addJavaScriptHandler(
    handlerName: handlerName,
    callback: callback,
  );

  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) => _controller.removeJavaScriptHandler(handlerName: handlerName);
}
