import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_ios/src/in_app_webview/modules/ios_navigation_delegate.dart';
import 'package:zikzak_inappwebview_ios/src/in_app_webview/modules/ios_javascript_delegate.dart';
import 'package:zikzak_inappwebview_ios/src/in_app_webview/modules/ios_cookie_delegate.dart';
import 'package:zikzak_inappwebview_ios/src/in_app_webview/modules/ios_settings_delegate.dart';

/// Compile-time probes for the iOS domain delegates.
///
/// Importing and referencing each concrete delegate forces the analyzer to
/// resolve the class and its overrides against the platform interface. If any
/// delegate signature drifts from its [PlatformInterface] base, this file stops
/// compiling — which is exactly how a brittle override (e.g. a return-type
/// mismatch) would be caught before shipping.
void main() {
  group('iOS delegate compile-time checks', () {
    test('IOSNavigationDelegate compiles', () {
      expect(IOSNavigationDelegate, isNotNull);
    });
    test('IOSJavaScriptDelegate compiles', () {
      expect(IOSJavaScriptDelegate, isNotNull);
    });
    test('IOSCookieDelegate compiles', () {
      expect(IOSCookieDelegate, isNotNull);
    });
    test('IOSSettingsDelegate compiles', () {
      expect(IOSSettingsDelegate, isNotNull);
    });
  });
}
