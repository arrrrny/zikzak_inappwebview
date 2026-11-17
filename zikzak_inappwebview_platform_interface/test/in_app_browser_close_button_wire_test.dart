import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/src/domain/entities/in_app_browser_settings/in_app_browser_settings.dart';

/// Issue #438 — the `hideCloseButton` half of the contract that lives on the
/// Dart side of the wire.
///
/// The iOS native controller decides the close button's presence from the
/// `hideCloseButton` key it receives through the `open` method channel, and the
/// channel map is `InAppBrowserClassSettings.toJson()` — the browser settings
/// merged with the WebView settings. A key that is dropped, renamed or
/// defaulted away here is a setting the native side can never see, so the
/// round-trip is pinned against the entity.
void main() {
  group('hideCloseButton on the wire (issue #438)', () {
    test('defaults to false', () {
      final map = InAppBrowserSettings().toJson();
      expect(map.containsKey('hideCloseButton'), isTrue);
      expect(map['hideCloseButton'], isFalse);
    });

    test('an explicit true round-trips true', () {
      final map = InAppBrowserSettings(hideCloseButton: true).toJson();
      expect(map['hideCloseButton'], isTrue);
    });

    test('the browser class settings merge keeps the key', () {
      final map = InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(hideCloseButton: true),
      ).toJson();
      expect(map['hideCloseButton'], isTrue);
    });

    test('it survives a JSON round-trip', () {
      final settings = InAppBrowserSettings(hideCloseButton: true);
      final rehydrated = InAppBrowserSettings.fromJson(settings.toJson());
      expect(rehydrated.hideCloseButton, isTrue);
    });

    test('copyWith can turn it on', () {
      final settings = InAppBrowserSettings().copyWith(hideCloseButton: true);
      expect(settings.hideCloseButton, isTrue);
    });
  });
}
