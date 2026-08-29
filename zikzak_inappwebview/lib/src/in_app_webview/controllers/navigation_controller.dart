import 'dart:typed_data';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

///Domain-specific facade of [InAppWebViewController] for navigation,
///page loading and history management.
///
///Part of the domain controller split (issue #161, P3): related operations
///are grouped behind focused facades so the main controller stays easy to
///reason about. Every method delegates straight to the underlying platform
///controller ([InAppWebViewController.platform]) — behavior is identical to
///calling the monolith directly, and the monolith itself routes grouped calls
///back through this facade (see FR-002).
class NavigationController {
  final InAppWebViewController _controller;

  ///Creates a [NavigationController] bound to the given controller.
  const NavigationController(this._controller);

  ///The current URL of the WebView.
  Future<WebUri?> getUrl() => _controller.platform.getUrl();

  ///Loads the given [urlRequest].
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) => _controller.platform.loadUrl(
    urlRequest: urlRequest,
    allowingReadAccessTo: allowingReadAccessTo,
  );

  ///Loads the given [url] with POST method using [postData].
  Future<void> postUrl({required WebUri url, required Uint8List postData}) =>
      _controller.platform.postUrl(url: url, postData: postData);

  ///Loads the given [data] as HTML content.
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) => _controller.platform.loadData(
    data: data,
    mimeType: mimeType,
    encoding: encoding,
    baseUrl: baseUrl,
    historyUrl: historyUrl,
    allowingReadAccessTo: allowingReadAccessTo,
  );

  ///Loads the given [assetFilePath].
  Future<void> loadFile({required String assetFilePath}) =>
      _controller.platform.loadFile(assetFilePath: assetFilePath);

  ///Loads a simulated request with the given [data] payload.
  ///
  ///[urlResponse] is accepted for signature compatibility with the monolithic
  ///method but, like that method, is not forwarded to the platform.
  Future<void> loadSimulatedRequest({
    required URLRequest urlRequest,
    required Uint8List data,
    URLResponse? urlResponse,
  }) => _controller.platform.loadSimulatedRequest(
    urlRequest: urlRequest,
    data: data,
  );

  ///Reloads the current page.
  Future<void> reload() => _controller.platform.reload();

  ///Reloads the current page from the origin, bypassing the cache.
  Future<void> reloadFromOrigin() => _controller.platform.reloadFromOrigin();

  ///Stops the current page load.
  Future<void> stopLoading() => _controller.platform.stopLoading();

  ///Whether the WebView is currently loading a page.
  Future<bool> isLoading() => _controller.platform.isLoading();

  ///Goes back in the navigation history.
  Future<void> goBack() => _controller.platform.goBack();

  ///Goes forward in the navigation history.
  Future<void> goForward() => _controller.platform.goForward();

  ///Moves [steps] through the navigation history (negative goes back).
  Future<void> goBackOrForward({required int steps}) =>
      _controller.platform.goBackOrForward(steps: steps);

  ///Whether there is a back item in the navigation history.
  Future<bool> canGoBack() => _controller.platform.canGoBack();

  ///Whether there is a forward item in the navigation history.
  Future<bool> canGoForward() => _controller.platform.canGoForward();

  ///Whether [steps] can be taken through the navigation history.
  Future<bool> canGoBackOrForward({required int steps}) =>
      _controller.platform.canGoBackOrForward(steps: steps);

  ///Goes to the given [historyItem].
  Future<void> goTo({required WebHistoryItem historyItem}) =>
      _controller.platform.goTo(historyItem: historyItem);

  ///A copy of the back/forward navigation list.
  Future<WebHistory?> getCopyBackForwardList() =>
      _controller.platform.getCopyBackForwardList();

  ///Clears the navigation history.
  Future<void> clearHistory() => _controller.platform.clearHistory();
}
