import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

// Characterization of FR-001 / FR-002 / SC-001: the `dismissDialogues` boolean
// option exists on InAppWebViewSettings and defaults to disabled (false).
// The setting drives the inline fixed/sticky removal wired in
// in_app_webview.dart:337 / headless_in_app_webview.dart:380.
void main() {
  group('InAppWebViewSettings.dismissDialogues (FR-001, FR-002, SC-001)', () {
    test('defaults to false (overlay removal disabled)', () {
      final settings = InAppWebViewSettings();
      expect(settings.dismissDialogues, isFalse);
    });

    test('can be enabled', () {
      final settings = InAppWebViewSettings(dismissDialogues: true);
      expect(settings.dismissDialogues, isTrue);
    });
  });
}
