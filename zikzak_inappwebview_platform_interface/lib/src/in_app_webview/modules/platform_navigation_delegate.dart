import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../web_uri.dart';
import '../../types/main.dart';

/// Delegate for navigation-related methods of [PlatformInAppWebViewController].
abstract class PlatformNavigationDelegate extends PlatformInterface {
  /// Creates a new [PlatformNavigationDelegate]
  PlatformNavigationDelegate({required Object token}) : super(token: token);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getUrl}
  Future<WebUri?> getUrl() {
    throw UnimplementedError(
      'getUrl is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getTitle}
  Future<String?> getTitle() {
    throw UnimplementedError(
      'getTitle is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getProgress}
  Future<int?> getProgress() {
    throw UnimplementedError(
      'getProgress is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.loadUrl}
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) {
    throw UnimplementedError(
      'loadUrl is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.postUrl}
  Future<void> postUrl({required WebUri url, required Uint8List postData}) {
    throw UnimplementedError(
      'postUrl is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.loadData}
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) {
    throw UnimplementedError(
      'loadData is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.loadFile}
  Future<void> loadFile({required String assetFilePath}) {
    throw UnimplementedError(
      'loadFile is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.reload}
  Future<void> reload() {
    throw UnimplementedError(
      'reload is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goBack}
  Future<void> goBack() {
    throw UnimplementedError(
      'goBack is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canGoBack}
  Future<bool> canGoBack() {
    throw UnimplementedError(
      'canGoBack is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goForward}
  Future<void> goForward() {
    throw UnimplementedError(
      'goForward is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canGoForward}
  Future<bool> canGoForward() {
    throw UnimplementedError(
      'canGoForward is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goBackOrForward}
  Future<void> goBackOrForward({required int steps}) {
    throw UnimplementedError(
      'goBackOrForward is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.canGoBackOrForward}
  Future<bool> canGoBackOrForward({required int steps}) {
    throw UnimplementedError(
      'canGoBackOrForward is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.goTo}
  Future<void> goTo({required WebHistoryItem historyItem}) {
    throw UnimplementedError('goTo is not implemented on the current platform');
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.isLoading}
  Future<bool> isLoading() {
    throw UnimplementedError(
      'isLoading is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.stopLoading}
  Future<void> stopLoading() {
    throw UnimplementedError(
      'stopLoading is not implemented on the current platform',
    );
  }
}
