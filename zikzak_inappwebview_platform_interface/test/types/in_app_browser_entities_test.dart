// Public-API regression tests for the in_app_browser menu item, migrated from
// @ExchangeableObject codegen (see PROGRESS.md, Phase 3h).
//
// InAppBrowserMenuItem is a hand-written skip/fork class (Function()-typed
// onClick — zorphy #89); the wire matches the old codegen (id, title,
// polymorphic icon, iconColor hex, order, showAsAction; onClick excluded).
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('InAppBrowserMenuItem', () {
    test('wire round-trip (onClick excluded)', () {
      var clicked = false;
      final item = InAppBrowserMenuItem(
        id: 1,
        title: 'Item',
        order: 2,
        showAsAction: true,
        iconColor: Color_(0xFF112233),
        onClick: () => clicked = true,
      );
      final map = item.toMap();
      expect(map['id'], 1);
      expect(map['title'], 'Item');
      expect(map['order'], 2);
      expect(map['showAsAction'], true);
      expect(map['iconColor'], '#ff112233');
      expect(map.containsKey('onClick'), isFalse);

      final restored = InAppBrowserMenuItem.fromMap(map)!;
      expect(restored.id, 1);
      expect(restored.showAsAction, isTrue);
      expect(restored.iconColor!.value, 0xFF112233);
      expect(restored.onClick, isNull);
    });
  });
}
