import 'dart:typed_data';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

///Domain-specific facade of [InAppWebViewController] for navigation,
///page loading and history management.
///
///Part of the domain controller split (issue #161, P3): related operations
///are grouped behind focused facades so the main controller stays easy to
///reason about. Every method delegates to the parent
///[InAppWebViewController] — behavior is identical to calling it directly.
class NavigationController {
  final InAppWebViewController _controller;

  ///Creates a [NavigationController] bound to the given controller.
  const NavigationController(this._controller);

  ///The current URL of the WebView.
  Future<WebUri?> getUrl() => _controller.getUrl();

  ///Loads the given [urlRequest].
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) => _controller.loadUrl(
    urlRequest: urlRequest,
    allowingReadAccessTo: allowingReadAccessTo,
  );

  ///Loads the given [url] with POST method using [postData].
  Future<void> postUrl({required WebUri url, required Uint8List postData}) =>
      _controller.postUrl(url: url, postData: postData);

  ///Loads the given [data] as HTML content.
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) => _controller.loadData(
    data: data,
    mimeType: mimeType,
    encoding: encoding,
    baseUrl: baseUrl,
    historyUrl: historyUrl,
    allowingReadAccessTo: allowingReadAccessTo,
  );

  ///Loads the given [assetFilePath].
  Future<void> loadFile({required String assetFilePath}) =>
      _controller.loadFile(assetFilePath: assetFilePath);

  ///Loads a simulated request with the given [data] payload.
  Future<void> loadSimulatedRequest({
    required URLRequest urlRequest,
    required Uint8List data,
    URLResponse? urlResponse,
  }) => _controller.loadSimulatedRequest(
    urlRequest: urlRequest,
    data: data,
    urlResponse: urlResponse,
  );

  ///Reloads the current page.
  Future<void> reload() => _controller.reload();

  ///Reloads the current page from the origin, bypassing the cache.
  Future<void> reloadFromOrigin() => _controller.reloadFromOrigin();

  ///Stops the current page load.
  Future<void> stopLoading() => _controller.stopLoading();

  ///Whether the WebView is currently loading a page.
  Future<bool> isLoading() => _controller.isLoading();

  ///Goes back in the navigation history.
  Future<void> goBack() => _controller.goBack();

  ///Goes forward in the navigation history.
  Future<void> goForward() => _controller.goForward();

  ///Moves [steps] through the navigation history (negative goes back).
  Future<void> goBackOrForward({required int steps}) =>
      _controller.goBackOrForward(steps: steps);

  ///Whether there is a back item in the navigation history.
  Future<bool> canGoBack() => _controller.canGoBack();

  ///Whether there is a forward item in the navigation history.
  Future<bool> canGoForward() => _controller.canGoForward();

  ///Whether [steps] can be taken through the navigation history.
  Future<bool> canGoBackOrForward({required int steps}) =>
      _controller.canGoBackOrForward(steps: steps);

  ///Goes to the given [historyItem].
  Future<void> goTo({required WebHistoryItem historyItem}) =>
      _controller.goTo(historyItem: historyItem);

  ///A copy of the back/forward navigation list.
  Future<WebHistory?> getCopyBackForwardList() =>
      _controller.getCopyBackForwardList();

  ///Clears the navigation history.
  Future<void> clearHistory() => _controller.clearHistory();
}
