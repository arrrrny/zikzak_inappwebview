// Public-API regression tests for the chrome_safari_browser sibling classes,
// migrated from @ExchangeableObject codegen (see PROGRESS.md, Phase 3e).
//
// ChromeSafariBrowserActionButton / ChromeSafariBrowserMenuItem /
// ChromeSafariBrowserSecondaryToolbar(+ClickableID) are hand-written
// skip/fork classes (the zorphy generator cannot express Function()-typed
// callback fields — zorphy #89); the wire matches the old codegen (callbacks
// excluded). ChromeSafariBrowserSettings (the large settings object) is
// converted separately (Phase 3f).
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ChromeSafariBrowserActionButton', () {
    test('wire is id/icon/description/shouldTint (onClick excluded)', () {
      var clicked = false;
      final button = ChromeSafariBrowserActionButton(
        id: 1,
        icon: Uint8List.fromList([1, 2]),
        description: 'button',
        onClick: (url, title) => clicked = true,
      );
      final map = button.toMap();
      expect(map['id'], 1);
      expect(map['icon'], [1, 2]);
      expect(map['description'], 'button');
      expect(map['shouldTint'], false);
      expect(map.containsKey('onClick'), isFalse);

      final restored = ChromeSafariBrowserActionButton.fromMap(map)!;
      expect(restored.id, 1);
      expect(restored.description, 'button');
      expect(restored.onClick, isNull);
    });
  });

  group('ChromeSafariBrowserMenuItem', () {
    test('wire is id/label/image (onClick excluded)', () {
      final item = ChromeSafariBrowserMenuItem(
        id: 2,
        label: 'Menu',
        onClick: (url, title) {},
      );
      final map = item.toMap();
      expect(map['id'], 2);
      expect(map['label'], 'Menu');
      expect(map.containsKey('onClick'), isFalse);

      final restored = ChromeSafariBrowserMenuItem.fromMap(map)!;
      expect(restored.label, 'Menu');
      expect(restored.image, isNull);
      expect(restored.onClick, isNull);
    });
  });

  group('ChromeSafariBrowserSecondaryToolbar', () {
    test('wire is layout + clickableIDs', () {
      final toolbar = ChromeSafariBrowserSecondaryToolbar(
        layout: AndroidResource(name: 'layout'),
        clickableIDs: [
          ChromeSafariBrowserSecondaryToolbarClickableID(
            id: AndroidResource(name: 'btn'),
          ),
        ],
      );
      final map = toolbar.toMap();
      expect((map['layout'] as Map)['name'], 'layout');
      expect((map['clickableIDs'] as List).length, 1);
      expect(
        (((map['clickableIDs'] as List).first as Map)['id'] as Map)['name'],
        'btn',
      );

      final restored = ChromeSafariBrowserSecondaryToolbar.fromMap(map)!;
      expect(restored.clickableIDs.single.id, isNotNull);
    });
  });
}
