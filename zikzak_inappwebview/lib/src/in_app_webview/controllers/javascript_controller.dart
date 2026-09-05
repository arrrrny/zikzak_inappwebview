import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

///Domain-specific facade of [InAppWebViewController] for JavaScript
///evaluation, JavaScript handlers and user script management.
///
///Part of the domain controller split (issue #161, P3). Every method
///delegates straight to the underlying platform controller
///([InAppWebViewController.platform]); the monolith routes grouped calls
///back through this facade (see FR-002).
class JavaScriptController {
  final InAppWebViewController _controller;

  ///Creates a [JavaScriptController] bound to the given controller.
  const JavaScriptController(this._controller);

  ///Evaluates the given JavaScript [source].
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) => _controller.platform.evaluateJavascript(
    source: source,
    contentWorld: contentWorld,
  );

  ///Calls the given async JavaScript [functionBody].
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    ContentWorld? contentWorld,
  }) => _controller.platform.callAsyncJavaScript(
    functionBody: functionBody,
    arguments: arguments,
    contentWorld: contentWorld,
  );

  ///Injects a JavaScript file from the given [urlFile] into the page.
  Future<void> injectJavascriptFileFromUrl({
    required WebUri urlFile,
    ScriptHtmlTagAttributes? scriptHtmlTagAttributes,
  }) => _controller.platform.injectJavascriptFileFromUrl(
    urlFile: urlFile,
    scriptHtmlTagAttributes: scriptHtmlTagAttributes,
  );

  ///Injects a JavaScript file from the app assets into the page.
  Future<dynamic> injectJavascriptFileFromAsset({
    required String assetFilePath,
  }) => _controller.platform.injectJavascriptFileFromAsset(
    assetFilePath: assetFilePath,
  );

  ///Registers a JavaScript handler with the given [handlerName].
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) => _controller.platform.addJavaScriptHandler(
    handlerName: handlerName,
    callback: callback,
  );

  ///Removes the JavaScript handler with the given [handlerName].
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) => _controller.platform.removeJavaScriptHandler(handlerName: handlerName);

  ///Whether a JavaScript handler with the given [handlerName] exists.
  bool hasJavaScriptHandler({required String handlerName}) =>
      _controller.platform.hasJavaScriptHandler(handlerName: handlerName);

  ///Adds the given [userScript].
  Future<void> addUserScript({required UserScript userScript}) =>
      _controller.platform.addUserScript(userScript: userScript);

  ///Adds the given [userScripts].
  Future<void> addUserScripts({required List<UserScript> userScripts}) =>
      _controller.platform.addUserScripts(userScripts: userScripts);

  ///Removes the given [userScript].
  Future<bool> removeUserScript({required UserScript userScript}) =>
      _controller.platform.removeUserScript(userScript: userScript);

  ///Removes the given [userScripts].
  Future<void> removeUserScripts({required List<UserScript> userScripts}) =>
      _controller.platform.removeUserScripts(userScripts: userScripts);

  ///Removes all user scripts of the given [groupName].
  Future<void> removeUserScriptsByGroupName({required String groupName}) =>
      _controller.platform.removeUserScriptsByGroupName(groupName: groupName);

  ///Removes all user scripts.
  Future<void> removeAllUserScripts() =>
      _controller.platform.removeAllUserScripts();

  ///Whether the given [userScript] is currently injected.
  bool hasUserScript({required UserScript userScript}) =>
      _controller.platform.hasUserScript(userScript: userScript);
}
