import 'dart:typed_data';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

/// iOS implementation of [PlatformNavigationDelegate].
///
/// Forwards every call to the parent [IOSInAppWebViewController].
/// Behavior is identical to calling the controller directly — this is a
/// focused facade, not a separate implementation. Part of the
/// domain-controller split (issue #229, P3).
class IOSNavigationDelegate extends PlatformNavigationDelegate {
  /// Creates a new [IOSNavigationDelegate] bound to [_controller].
  IOSNavigationDelegate(this._controller) : super(token: _token);

  static final Object _token = Object();

  final IOSInAppWebViewController _controller;

  @override
  Future<WebUri?> getUrl() => _controller.getUrl();

  @override
  Future<String?> getTitle() => _controller.getTitle();

  @override
  Future<int?> getProgress() => _controller.getProgress();

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) => _controller.loadUrl(
    urlRequest: urlRequest,
    allowingReadAccessTo: allowingReadAccessTo,
  );

  @override
  Future<void> postUrl({required WebUri url, required Uint8List postData}) =>
      _controller.postUrl(url: url, postData: postData);

  @override
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

  @override
  Future<void> loadFile({required String assetFilePath}) =>
      _controller.loadFile(assetFilePath: assetFilePath);

  @override
  Future<void> reload() => _controller.reload();

  @override
  Future<void> goBack() => _controller.goBack();

  @override
  Future<bool> canGoBack() => _controller.canGoBack();

  @override
  Future<void> goForward() => _controller.goForward();

  @override
  Future<bool> canGoForward() => _controller.canGoForward();

  @override
  Future<void> goBackOrForward({required int steps}) =>
      _controller.goBackOrForward(steps: steps);

  @override
  Future<bool> canGoBackOrForward({required int steps}) =>
      _controller.canGoBackOrForward(steps: steps);

  @override
  Future<void> goTo({required WebHistoryItem historyItem}) =>
      _controller.goTo(historyItem: historyItem);

  @override
  Future<bool> isLoading() => _controller.isLoading();

  @override
  Future<void> stopLoading() => _controller.stopLoading();
}
