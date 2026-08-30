// Wire-contract regression tests for the `webAuthenticationSupport` setting
// (issue #272).
//
// The native WebAuthn wiring on iOS and macOS compares the raw settings-map
// integer against `1` (FOR_APP):
//   - iOS:  InAppWebView.preWKWebViewConfiguration (iOS 16.4+)
//   - macOS: InAppWebView.init (macOS 13.3+, this repo, issue #272)
//   - Android: WebSettingsCompat.setWebAuthenticationSupport
// Those comparisons only work because the Dart side serializes the
// `WebAuthenticationSupport` enum to its INDEX on the wire. If the enum order
// ever changes (inserting/reordering values), every native `== 1` check
// silently breaks and passkey/WebAuthn sign-in stops being enabled. These
// tests pin the wire contract.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('WebAuthenticationSupport wire contract (issue #272)', () {
    test('enum indices are pinned: NONE=0, FOR_APP=1, FOR_BROWSER=2', () {
      // The native iOS/macOS code enables passkeys when the wire value == 1.
      expect(WebAuthenticationSupport.NONE.index, 0);
      expect(WebAuthenticationSupport.FOR_APP.index, 1);
      expect(WebAuthenticationSupport.FOR_BROWSER.index, 2);
    });

    test('toWire serializes to the enum index', () {
      expect(
        webAuthenticationSupportToWire(WebAuthenticationSupport.NONE),
        0,
      );
      expect(
        webAuthenticationSupportToWire(WebAuthenticationSupport.FOR_APP),
        1,
      );
      expect(
        webAuthenticationSupportToWire(WebAuthenticationSupport.FOR_BROWSER),
        2,
      );
      expect(webAuthenticationSupportToWire(null), isNull);
    });

    test('fromWire parses index ints and rejects everything else', () {
      expect(
        webAuthenticationSupportFromWire(0),
        WebAuthenticationSupport.NONE,
      );
      expect(
        webAuthenticationSupportFromWire(1),
        WebAuthenticationSupport.FOR_APP,
      );
      expect(
        webAuthenticationSupportFromWire(2),
        WebAuthenticationSupport.FOR_BROWSER,
      );
      // Out-of-range and non-int values must parse to null, never throw.
      expect(webAuthenticationSupportFromWire(3), isNull);
      expect(webAuthenticationSupportFromWire(-1), isNull);
      expect(webAuthenticationSupportFromWire(null), isNull);
      expect(webAuthenticationSupportFromWire('1'), isNull);
      expect(webAuthenticationSupportFromWire(true), isNull);
    });

    test('settings toJson carries webAuthenticationSupport as index int', () {
      final settings = InAppWebViewSettings(
        webAuthenticationSupport: WebAuthenticationSupport.FOR_APP,
      );
      final wire = settings.toJson();
      expect(wire['webAuthenticationSupport'], 1);

      final noneSettings = InAppWebViewSettings(
        webAuthenticationSupport: WebAuthenticationSupport.NONE,
      );
      expect(noneSettings.toJson()['webAuthenticationSupport'], 0);
    });

    test('settings fromJson round-trips the wire int', () {
      final settings = InAppWebViewSettings.fromJson(const {
        'webAuthenticationSupport': 1,
      });
      expect(
        settings.webAuthenticationSupport,
        WebAuthenticationSupport.FOR_APP,
      );

      final defaults = InAppWebViewSettings.fromJson(const {});
      expect(defaults.webAuthenticationSupport, isNull);
    });

    test('enum has exactly the three values the native sides know about', () {
      // iOS/macOS enable passkeys when the wire value == 1 (FOR_APP) and
      // Android passes the raw value through to WebSettingsCompat. Adding,
      // removing, or reordering enum values without updating every native
      // implementation would silently break passkey sign-in — fail loudly
      // here instead.
      expect(WebAuthenticationSupport.values.length, 3);
      expect(WebAuthenticationSupport.values, [
        WebAuthenticationSupport.NONE,
        WebAuthenticationSupport.FOR_APP,
        WebAuthenticationSupport.FOR_BROWSER,
      ]);
    });
  });
}
