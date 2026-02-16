import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../web_message/main.dart';
import '../web_storage/web_storage.dart';

import '../print_job/print_job_controller.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController}
class InAppWebViewController {
  /// Constructs a [InAppWebViewController].
  ///
  /// See [InAppWebViewController.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  InAppWebViewController.fromPlatformCreationParams({
    required PlatformInAppWebViewControllerCreationParams params,
  }) : this.fromPlatform(platform: PlatformInAppWebViewController(params));

  /// Constructs a [InAppWebViewController] from a specific platform implementation.
  InAppWebViewController.fromPlatform({required this.platform});

  /// Implementation of [PlatformInAppWebViewController] for the current platform.
  final PlatformInAppWebViewController platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.webStorage}
  WebStorage get webStorage =>
      WebStorage.fromPlatform(platform: platform.webStorage);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getUrl}
  Future<WebUri?> getUrl() => platform.getUrl();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getTitle}
  Future<String?> getTitle() => platform.getTitle();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getProgress}
  Future<int?> getProgress() => platform.getProgress();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getHtml}
  Future<String?> getHtml() => platform.getHtml();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getFavicons}
  Future<List<Favicon>> getFavicons() => platform.getFavicons();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.loadUrl}
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) => platform.loadUrl(
    urlRequest: urlRequest,
    allowingReadAccessTo: allowingReadAccessTo,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.postUrl}
  Future<void> postUrl({required WebUri url, required Uint8List postData}) =>
      platform.postUrl(url: url, postData: postData);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.loadData}
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) => platform.loadData(
    data: data,
    mimeType: mimeType,
    encoding: encoding,
    baseUrl: baseUrl,
    historyUrl: historyUrl,
    allowingReadAccessTo: allowingReadAccessTo,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.loadFile}
  Future<void> loadFile({required String assetFilePath}) =>
      platform.loadFile(assetFilePath: assetFilePath);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.reload}
  Future<void> reload() => platform.reload();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goBack}
  Future<void> goBack() => platform.goBack();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canGoBack}
  Future<bool> canGoBack() => platform.canGoBack();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goForward}
  Future<void> goForward() => platform.goForward();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canGoForward}
  Future<bool> canGoForward() => platform.canGoForward();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goBackOrForward}
  Future<void> goBackOrForward({required int steps}) =>
      platform.goBackOrForward(steps: steps);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canGoBackOrForward}
  Future<bool> canGoBackOrForward({required int steps}) =>
      platform.canGoBackOrForward(steps: steps);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goTo}
  Future<void> goTo({required WebHistoryItem historyItem}) =>
      platform.goTo(historyItem: historyItem);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.isLoading}
  Future<bool> isLoading() => platform.isLoading();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.stopLoading}
  Future<void> stopLoading() => platform.stopLoading();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.evaluateJavascript}
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) => platform.evaluateJavascript(source: source, contentWorld: contentWorld);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectJavascriptFileFromUrl}
  Future<void> injectJavascriptFileFromUrl({
    required WebUri urlFile,
    ScriptHtmlTagAttributes? scriptHtmlTagAttributes,
  }) => platform.injectJavascriptFileFromUrl(
    urlFile: urlFile,
    scriptHtmlTagAttributes: scriptHtmlTagAttributes,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectJavascriptFileFromAsset}
  Future<dynamic> injectJavascriptFileFromAsset({
    required String assetFilePath,
  }) => platform.injectJavascriptFileFromAsset(assetFilePath: assetFilePath);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSCode}
  Future<void> injectCSSCode({required String source}) =>
      platform.injectCSSCode(source: source);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSFileFromUrl}
  Future<void> injectCSSFileFromUrl({
    required WebUri urlFile,
    CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes,
  }) => platform.injectCSSFileFromUrl(
    urlFile: urlFile,
    cssLinkHtmlTagAttributes: cssLinkHtmlTagAttributes,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.injectCSSFileFromAsset}
  Future<void> injectCSSFileFromAsset({required String assetFilePath}) =>
      platform.injectCSSFileFromAsset(assetFilePath: assetFilePath);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.addJavaScriptHandler}
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) => platform.addJavaScriptHandler(
    handlerName: handlerName,
    callback: callback,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeJavaScriptHandler}
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) => platform.removeJavaScriptHandler(handlerName: handlerName);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.hasJavaScriptHandler}
  bool hasJavaScriptHandler({required String handlerName}) =>
      platform.hasJavaScriptHandler(handlerName: handlerName);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.takeScreenshot}
  Future<Uint8List?> takeScreenshot({
    ScreenshotConfiguration? screenshotConfiguration,
  }) =>
      platform.takeScreenshot(screenshotConfiguration: screenshotConfiguration);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setSettings}
  Future<void> setSettings({required InAppWebViewSettings settings}) =>
      platform.setSettings(settings: settings);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getSettings}
  Future<InAppWebViewSettings?> getSettings() => platform.getSettings();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getCopyBackForwardList}
  Future<WebHistory?> getCopyBackForwardList() =>
      platform.getCopyBackForwardList();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.scrollTo}
  Future<void> scrollTo({
    required int x,
    required int y,
    bool animated = false,
  }) => platform.scrollTo(x: x, y: y, animated: animated);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.scrollBy}
  Future<void> scrollBy({
    required int x,
    required int y,
    bool animated = false,
  }) => platform.scrollBy(x: x, y: y, animated: animated);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.pauseTimers}
  Future<void> pauseTimers() => platform.pauseTimers();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.resumeTimers}
  Future<void> resumeTimers() => platform.resumeTimers();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.printCurrentPage}
  Future<PrintJobController?> printCurrentPage({
    PrintJobSettings? settings,
  }) async {
    final printJobControllerPlatform = await platform.printCurrentPage(
      settings: settings,
    );
    if (printJobControllerPlatform == null) {
      return null;
    }
    return PrintJobController.fromPlatform(
      platform: printJobControllerPlatform,
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getContentHeight}
  Future<int?> getContentHeight() => platform.getContentHeight();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getContentWidth}
  Future<int?> getContentWidth() => platform.getContentWidth();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.zoomBy}
  Future<void> zoomBy({required double zoomFactor, bool animated = false}) =>
      platform.zoomBy(zoomFactor: zoomFactor, animated: animated);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getOriginalUrl}
  Future<WebUri?> getOriginalUrl() => platform.getOriginalUrl();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getZoomScale}
  Future<double?> getZoomScale() => platform.getZoomScale();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getSelectedText}
  Future<String?> getSelectedText() => platform.getSelectedText();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getHitTestResult}
  Future<InAppWebViewHitTestResult?> getHitTestResult() =>
      platform.getHitTestResult();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.clearFocus}
  Future<void> clearFocus() => platform.clearFocus();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setContextMenu}
  Future<void> setContextMenu(ContextMenu? contextMenu) =>
      platform.setContextMenu(contextMenu);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.requestFocusNodeHref}
  Future<RequestFocusNodeHrefResult?> requestFocusNodeHref() =>
      platform.requestFocusNodeHref();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.requestImageRef}
  Future<RequestImageRefResult?> requestImageRef() =>
      platform.requestImageRef();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getMetaTags}
  Future<List<MetaTag>> getMetaTags() => platform.getMetaTags();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getMetaThemeColor}
  Future<Color?> getMetaThemeColor() => platform.getMetaThemeColor();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getScrollX}
  Future<int?> getScrollX() => platform.getScrollX();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getScrollY}
  Future<int?> getScrollY() => platform.getScrollY();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getCertificate}
  Future<SslCertificate?> getCertificate() => platform.getCertificate();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.addUserScript}
  Future<void> addUserScript({required UserScript userScript}) =>
      platform.addUserScript(userScript: userScript);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.addUserScripts}
  Future<void> addUserScripts({required List<UserScript> userScripts}) =>
      platform.addUserScripts(userScripts: userScripts);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeUserScript}
  Future<bool> removeUserScript({required UserScript userScript}) =>
      platform.removeUserScript(userScript: userScript);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeUserScriptsByGroupName}
  Future<void> removeUserScriptsByGroupName({required String groupName}) =>
      platform.removeUserScriptsByGroupName(groupName: groupName);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeUserScripts}
  Future<void> removeUserScripts({required List<UserScript> userScripts}) =>
      platform.removeUserScripts(userScripts: userScripts);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeAllUserScripts}
  Future<void> removeAllUserScripts() => platform.removeAllUserScripts();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.hasUserScript}
  bool hasUserScript({required UserScript userScript}) =>
      platform.hasUserScript(userScript: userScript);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.callAsyncJavaScript}
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    ContentWorld? contentWorld,
  }) => platform.callAsyncJavaScript(
    functionBody: functionBody,
    arguments: arguments,
    contentWorld: contentWorld,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.saveWebArchive}
  Future<String?> saveWebArchive({
    required String filePath,
    bool autoname = false,
  }) => platform.saveWebArchive(filePath: filePath, autoname: autoname);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.isSecureContext}
  Future<bool> isSecureContext() => platform.isSecureContext();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.createWebMessageChannel}
  Future<WebMessageChannel?> createWebMessageChannel() async {
    final webMessagePlatform = await platform.createWebMessageChannel();
    if (webMessagePlatform == null) {
      return null;
    }
    return WebMessageChannel.fromPlatform(platform: webMessagePlatform);
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.postWebMessage}
  Future<void> postWebMessage({
    required WebMessage message,
    WebUri? targetOrigin,
  }) => platform.postWebMessage(message: message, targetOrigin: targetOrigin);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.addWebMessageListener}
  Future<void> addWebMessageListener(WebMessageListener webMessageListener) =>
      platform.addWebMessageListener(webMessageListener.platform);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.hasWebMessageListener}
  bool hasWebMessageListener(WebMessageListener webMessageListener) =>
      platform.hasWebMessageListener(webMessageListener.platform);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canScrollVertically}
  Future<bool> canScrollVertically() => platform.canScrollVertically();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canScrollHorizontally}
  Future<bool> canScrollHorizontally() => platform.canScrollHorizontally();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.startSafeBrowsing}
  Future<bool> startSafeBrowsing() => platform.startSafeBrowsing();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.clearSslPreferences}
  Future<void> clearSslPreferences() => platform.clearSslPreferences();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.pause}
  Future<void> pause() => platform.pause();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.resume}
  Future<void> resume() => platform.resume();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.pageDown}
  Future<bool> pageDown({required bool bottom}) =>
      platform.pageDown(bottom: bottom);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.pageUp}
  Future<bool> pageUp({required bool top}) => platform.pageUp(top: top);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.zoomIn}
  Future<bool> zoomIn() => platform.zoomIn();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.zoomOut}
  Future<bool> zoomOut() => platform.zoomOut();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.clearHistory}
  Future<void> clearHistory() => platform.clearHistory();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.reloadFromOrigin}
  Future<void> reloadFromOrigin() => platform.reloadFromOrigin();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.createPdf}
  Future<Uint8List?> createPdf({PDFConfiguration? pdfConfiguration}) =>
      platform.createPdf(pdfConfiguration: pdfConfiguration);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.createWebArchiveData}
  Future<Uint8List?> createWebArchiveData() => platform.createWebArchiveData();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.hasOnlySecureContent}
  Future<bool> hasOnlySecureContent() => platform.hasOnlySecureContent();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.pauseAllMediaPlayback}
  Future<void> pauseAllMediaPlayback() => platform.pauseAllMediaPlayback();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setAllMediaPlaybackSuspended}
  Future<void> setAllMediaPlaybackSuspended({required bool suspended}) =>
      platform.setAllMediaPlaybackSuspended(suspended: suspended);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.closeAllMediaPresentations}
  Future<void> closeAllMediaPresentations() =>
      platform.closeAllMediaPresentations();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.requestMediaPlaybackState}
  Future<MediaPlaybackState?> requestMediaPlaybackState() =>
      platform.requestMediaPlaybackState();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.isInFullscreen}
  Future<bool> isInFullscreen() => platform.isInFullscreen();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.clearFormData}
  Future<void> clearFormData() => platform.clearFormData();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getCameraCaptureState}
  Future<MediaCaptureState?> getCameraCaptureState() =>
      platform.getCameraCaptureState();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setCameraCaptureState}
  Future<void> setCameraCaptureState({required MediaCaptureState state}) =>
      platform.setCameraCaptureState(state: state);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getMicrophoneCaptureState}
  Future<MediaCaptureState?> getMicrophoneCaptureState() =>
      platform.getMicrophoneCaptureState();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setMicrophoneCaptureState}
  Future<void> setMicrophoneCaptureState({required MediaCaptureState state}) =>
      platform.setMicrophoneCaptureState(state: state);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.loadSimulatedRequest}
  Future<void> loadSimulatedRequest({
    required URLRequest urlRequest,
    required Uint8List data,
    URLResponse? urlResponse,
  }) => platform.loadSimulatedRequest(urlRequest: urlRequest, data: data);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.openDevTools}
  Future<void> openDevTools() => platform.openDevTools();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.callDevToolsProtocolMethod}
  Future<dynamic> callDevToolsProtocolMethod({
    required String methodName,
    Map<String, dynamic>? parameters,
  }) => platform.callDevToolsProtocolMethod(
    methodName: methodName,
    parameters: parameters,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.addDevToolsProtocolEventListener}
  Future<void> addDevToolsProtocolEventListener({
    required String eventName,
    required Function(dynamic data) callback,
  }) => platform.addDevToolsProtocolEventListener(
    eventName: eventName,
    callback: callback,
  );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.removeDevToolsProtocolEventListener}
  Future<void> removeDevToolsProtocolEventListener({
    required String eventName,
  }) => platform.removeDevToolsProtocolEventListener(eventName: eventName);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getIFrameId}
  Future<String?> getIFrameId() => platform.getIFrameId();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getDefaultUserAgent}
  static Future<String> getDefaultUserAgent() =>
      PlatformInAppWebViewController.static().getDefaultUserAgent();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.clearClientCertPreferences}
  static Future<void> clearClientCertPreferences() =>
      PlatformInAppWebViewController.static().clearClientCertPreferences();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getSafeBrowsingPrivacyPolicyUrl}
  static Future<WebUri?> getSafeBrowsingPrivacyPolicyUrl() =>
      PlatformInAppWebViewController.static().getSafeBrowsingPrivacyPolicyUrl();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setSafeBrowsingAllowlist}
  static Future<bool> setSafeBrowsingAllowlist({required List<String> hosts}) =>
      PlatformInAppWebViewController.static().setSafeBrowsingAllowlist(
        hosts: hosts,
      );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getCurrentWebViewPackage}
  static Future<WebViewPackageInfo?> getCurrentWebViewPackage() =>
      PlatformInAppWebViewController.static().getCurrentWebViewPackage();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setWebContentsDebuggingEnabled}
  static Future<void> setWebContentsDebuggingEnabled(bool debuggingEnabled) =>
      PlatformInAppWebViewController.static().setWebContentsDebuggingEnabled(
        debuggingEnabled,
      );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getVariationsHeader}
  static Future<String?> getVariationsHeader() =>
      PlatformInAppWebViewController.static().getVariationsHeader();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.isMultiProcessEnabled}
  static Future<bool> isMultiProcessEnabled() =>
      PlatformInAppWebViewController.static().isMultiProcessEnabled();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.disableWebView}
  static Future<void> disableWebView() =>
      PlatformInAppWebViewController.static().disableWebView();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.handlesURLScheme}
  static Future<bool> handlesURLScheme(String urlScheme) =>
      PlatformInAppWebViewController.static().handlesURLScheme(urlScheme);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.disposeKeepAlive}
  static Future<void> disposeKeepAlive(InAppWebViewKeepAlive keepAlive) =>
      PlatformInAppWebViewController.static().disposeKeepAlive(keepAlive);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.clearAllCache}
  static Future<void> clearAllCache({bool includeDiskFiles = true}) =>
      PlatformInAppWebViewController.static().clearAllCache(
        includeDiskFiles: includeDiskFiles,
      );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.tRexRunnerHtml}
  static Future<String> get tRexRunnerHtml =>
      PlatformInAppWebViewController.static().tRexRunnerHtml;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.tRexRunnerCss}
  static Future<String> get tRexRunnerCss =>
      PlatformInAppWebViewController.static().tRexRunnerCss;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getViewId}
  dynamic getViewId() => platform.getViewId();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.dispose}
  void dispose({bool isKeepAlive = false}) =>
      platform.dispose(isKeepAlive: isKeepAlive);
}
