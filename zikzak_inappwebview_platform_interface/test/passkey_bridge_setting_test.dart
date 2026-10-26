import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/src/domain/entities/in_app_webview_settings/in_app_webview_settings.dart';

/// Issue #384 B2 — `passkeyBridgeEnabled` on the Dart settings surface.
///
/// The opt-out ships as a real settings field (default on) so embedders can
/// withhold the passkey shim + bridge; the native macOS/iOS settings classes
/// carry the same field and gate arming on it.
void main() {
  group('passkeyBridgeEnabled setting (issue #384 B2)', () {
    test('exists on InAppWebViewSettings and serializes the armed default', () {
      final settings = InAppWebViewSettings();
      final map = settings.toJson();
      expect(map.containsKey('passkeyBridgeEnabled'), isTrue);
      // The armed default is what ships on the wire; the native layer treats
      // a null as armed too (the 6.2.2 default behavior is preserved either
      // way).
      expect(map['passkeyBridgeEnabled'], isTrue);
    });

    test('an explicit false round-trips false', () {
      final settings = InAppWebViewSettings(passkeyBridgeEnabled: false);
      final map = settings.toJson();
      expect(map['passkeyBridgeEnabled'], isFalse);

      final restored = InAppWebViewSettings.fromJson(map);
      expect(restored.passkeyBridgeEnabled, isFalse);
    });

    test('an explicit true round-trips true', () {
      final settings = InAppWebViewSettings(passkeyBridgeEnabled: true);
      final map = settings.toJson();
      expect(map['passkeyBridgeEnabled'], isTrue);
    });
  });
}
