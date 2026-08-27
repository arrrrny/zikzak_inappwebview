import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_android/src/in_app_webview/modules/android_navigation_delegate.dart';
import 'package:zikzak_inappwebview_android/src/in_app_webview/modules/android_javascript_delegate.dart';
import 'package:zikzak_inappwebview_android/src/in_app_webview/modules/android_cookie_delegate.dart';
import 'package:zikzak_inappwebview_android/src/in_app_webview/modules/android_settings_delegate.dart';

/// Compile-time probes for the Android domain delegates.
///
/// Importing and referencing each concrete delegate forces the analyzer to
/// resolve the class and its overrides against the platform interface. If any
/// delegate signature drifts from its [PlatformInterface] base, this file stops
/// compiling — which is exactly how a brittle override (e.g. a return-type
/// mismatch) would be caught before shipping.
void main() {
  group('Android delegate compile-time checks', () {
    test('AndroidNavigationDelegate compiles', () {
      expect(AndroidNavigationDelegate, isNotNull);
    });
    test('AndroidJavaScriptDelegate compiles', () {
      expect(AndroidJavaScriptDelegate, isNotNull);
    });
    test('AndroidCookieDelegate compiles', () {
      expect(AndroidCookieDelegate, isNotNull);
    });
    test('AndroidSettingsDelegate compiles', () {
      expect(AndroidSettingsDelegate, isNotNull);
    });
  });
}
