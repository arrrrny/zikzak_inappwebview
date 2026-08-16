// Public-API regression tests for ChromeSafariBrowserSettings, migrated from
// @ExchangeableObject codegen (see PROGRESS.md, Phase 3f).
//
// Pins the CONSUMER-VISIBLE contract: fork constructor defaults, wire
// format (Color_ as hex, still-codegen enums via fromNativeValue ints,
// displayMode via the polymorphic type-key, nested still-codegen objects),
// and round-trips.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ChromeSafariBrowserSettings', () {
    test('fork defaults are preserved', () {
      final settings = ChromeSafariBrowserSettings();
      expect(settings.shareState, CustomTabsShareState.SHARE_STATE_DEFAULT);
      expect(settings.showTitle, isTrue);
      expect(settings.enableUrlBarHiding, isFalse);
      expect(settings.additionalTrustedOrigins, isEmpty);
      expect(
        settings.screenOrientation,
        TrustedWebActivityScreenOrientation.DEFAULT,
      );
      expect(settings.dismissButtonStyle, DismissButtonStyle.DONE);
      expect(settings.presentationStyle, ModalPresentationStyle.FULL_SCREEN);
      expect(settings.transitionStyle, ModalTransitionStyle.COVER_VERTICAL);
    });

    test('wire round-trip (colors as hex, enums as native ints)', () {
      final settings = ChromeSafariBrowserSettings(
        toolbarBackgroundColor: Color_(0xFF112233),
        navigationBarColor: Color_(0xFF445566),
        shareState: CustomTabsShareState.SHARE_STATE_ON,
        dismissButtonStyle: DismissButtonStyle.CLOSE,
        presentationStyle: ModalPresentationStyle.PAGE_SHEET,
        transitionStyle: ModalTransitionStyle.FLIP_HORIZONTAL,
      );
      final map = settings.toJson();
      expect(map['toolbarBackgroundColor'], '#ff112233');
      expect(map['navigationBarColor'], '#ff445566');
      expect(map['shareState'], isA<int>());
      expect(map['dismissButtonStyle'], isA<int>());

      final restored = ChromeSafariBrowserSettings.fromJson(map);
      expect(restored.toolbarBackgroundColor!.value, 0xFF112233);
      expect(restored.shareState, CustomTabsShareState.SHARE_STATE_ON);
      expect(restored.dismissButtonStyle, DismissButtonStyle.CLOSE);
      expect(restored.presentationStyle, ModalPresentationStyle.PAGE_SHEET);
      expect(restored.transitionStyle, ModalTransitionStyle.FLIP_HORIZONTAL);
    });

    test('displayMode polymorphic type-key round-trip', () {
      final settings = ChromeSafariBrowserSettings(
        displayMode: TrustedWebActivityDefaultDisplayMode(),
      );
      final map = settings.toJson();
      expect(map['displayMode'], isNotNull);
      final restored = ChromeSafariBrowserSettings.fromJson(map);
      expect(restored.displayMode, isA<TrustedWebActivityDefaultDisplayMode>());
    });
  });
}
