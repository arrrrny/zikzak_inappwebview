import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Compile-time probes for the platform-interface domain delegate split
/// (issue #229, P3).
///
/// The platform interface exposes four focused delegates —
/// [PlatformNavigationDelegate], [PlatformJavaScriptDelegate],
/// [PlatformCookieDelegate], [PlatformSettingsDelegate] — and the main
/// [PlatformInAppWebViewController] exposes a getter for each. If a
/// delegate, getter or method drifts, this file stops compiling, so
/// `flutter analyze` and `flutter test` both fail.

// --- Compile-time bound checks: each delegate extends PlatformInterface ---

class _ProbeNavigation extends PlatformNavigationDelegate {
  _ProbeNavigation() : super(token: Object());
  @override
  Future<WebUri?> getUrl() async => null;
  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) async {}
  @override
  Future<void> postUrl({
    required WebUri url,
    required Uint8List postData,
  }) async {}
  @override
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) async {}
  @override
  Future<void> loadFile({required String assetFilePath}) async {}
  @override
  Future<void> reload() async {}
  @override
  Future<void> goBack() async {}
  @override
  Future<bool> canGoBack() async => false;
  @override
  Future<void> goForward() async {}
  @override
  Future<bool> canGoForward() async => false;
  @override
  Future<void> goBackOrForward({required int steps}) async {}
  @override
  Future<bool> canGoBackOrForward({required int steps}) async => false;
  @override
  Future<void> goTo({required WebHistoryItem historyItem}) async {}
  @override
  Future<bool> isLoading() async => false;
  @override
  Future<void> stopLoading() async {}
}

class _ProbeJavaScript extends PlatformJavaScriptDelegate {
  _ProbeJavaScript() : super(token: Object());
  @override
  Future<dynamic> evaluateJavascript({required String source}) async => null;
  @override
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    ContentWorld? contentWorld,
  }) async => null;
  @override
  Future<void> injectJavascriptFileFromUrl({
    required WebUri urlFile,
    ScriptHtmlTagAttributes? scriptHtmlTagAttributes,
  }) async {}
  @override
  Future<dynamic> injectJavascriptFileFromAsset({
    required String assetFilePath,
  }) async => null;
  @override
  Future<void> injectCSSFileFromUrl({
    required WebUri urlFile,
    CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes,
  }) async {}
  @override
  Future<void> injectCSSFileFromAsset({required String assetFilePath}) async {}
  @override
  Future<void> injectCSSCode({required String source}) async {}
  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {}
  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) => null;
}

class _ProbeCookie extends PlatformCookieDelegate {
  _ProbeCookie() : super(token: Object());
  @override
  Future<bool> setCookie({
    required WebUri url,
    required String name,
    required String value,
    String path = "/",
    String? domain,
    int? expiresDate,
    int? maxAge,
    bool? isSecure,
    bool? isHttpOnly,
    HTTPCookieSameSitePolicy? sameSite,
  }) async => false;
  @override
  Future<List<Cookie>> getCookies({required WebUri url}) async => [];
  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
  }) async => null;
  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = "/",
    String? domain,
  }) async => false;
  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = "/",
    String? domain,
  }) async => false;
  @override
  Future<List<Cookie>> getAllCookies() async => [];
  @override
  Future<bool> deleteAllCookies() async => false;
  @override
  Future<bool> removeSessionCookies() async => false;
}

class _ProbeSettings extends PlatformSettingsDelegate {
  _ProbeSettings() : super(token: Object());
  @override
  Future<void> setSettings({required InAppWebViewSettings settings}) async {}
  @override
  Future<InAppWebViewSettings?> getSettings() async => null;
}

// --- Compile-time bound checks: the main controller exposes all four
// delegate getters. The getters return nullable delegates (null by default
// on the abstract base); the platform implementations override them.

PlatformNavigationDelegate? _nav(PlatformInAppWebViewController c) =>
    c.navigationDelegate;
PlatformJavaScriptDelegate? _js(PlatformInAppWebViewController c) =>
    c.javaScriptDelegate;
PlatformCookieDelegate? _ck(PlatformInAppWebViewController c) =>
    c.cookieDelegate;
PlatformSettingsDelegate? _st(PlatformInAppWebViewController c) =>
    c.settingsDelegate;

void main() {
  group('PlatformInAppWebViewController delegate split (issue #229 P3)', () {
    test(
      'the four domain delegate types are exported from the platform interface',
      () {
        expect(_ProbeNavigation, isNotNull);
        expect(_ProbeJavaScript, isNotNull);
        expect(_ProbeCookie, isNotNull);
        expect(_ProbeSettings, isNotNull);
      },
    );

    test(
      'PlatformInAppWebViewController declares all four delegate getters',
      () {
        expect(_nav, isNotNull);
        expect(_js, isNotNull);
        expect(_ck, isNotNull);
        expect(_st, isNotNull);
      },
    );
  });
}
