import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Compile-time probes for the domain controller split (issue #161, P3).
///
/// The domain facades group the [InAppWebViewController] API surface into
/// focused controllers. If a facade or method is removed, or its type
/// drifts, this file stops compiling, so `flutter analyze` and
/// `flutter test` both fail.

NavigationController _navigation(InAppWebViewController c) => c.navigation;
JavaScriptController _javaScript(InAppWebViewController c) => c.javaScript;
CookieController _cookiesFacade(InAppWebViewController c) => c.cookies;
SettingsController _settings(InAppWebViewController c) => c.settings;

Future<void> _reload(NavigationController c) => c.reload();
Future<bool> _canGoBack(NavigationController c) => c.canGoBack();
Future<dynamic> _eval(JavaScriptController c, String source) =>
    c.evaluateJavascript(source: source);
bool _hasHandler(JavaScriptController c, String name) =>
    c.hasJavaScriptHandler(handlerName: name);
Future<List<Cookie>> _getCookies(CookieController c) => c.getCookies();
Future<InAppWebViewSettings?> _getSettings(SettingsController c) =>
    c.getSettings();

void main() {
  group('Domain-specific controllers (issue #161 P3)', () {
    test('InAppWebViewController exposes all four domain facades', () {
      expect(_navigation, isNotNull);
      expect(_javaScript, isNotNull);
      expect(_cookiesFacade, isNotNull);
      expect(_settings, isNotNull);
    });

    test('facades expose their domain methods with expected signatures', () {
      expect(_reload, isNotNull);
      expect(_canGoBack, isNotNull);
      expect(_eval, isNotNull);
      expect(_hasHandler, isNotNull);
      expect(_getCookies, isNotNull);
      expect(_getSettings, isNotNull);
    });
  });
}
