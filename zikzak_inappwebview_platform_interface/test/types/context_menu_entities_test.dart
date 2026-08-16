// Public-API regression tests for the context_menu family, migrated from
// @ExchangeableObject codegen (see PROGRESS.md, Phase 3c).
//
// ContextMenu + ContextMenuItem are hand-written skip/fork classes (the
// zorphy generator cannot express function-typed callback fields); the wire
// matches the old codegen: only menuItems + settings on ContextMenu, only
// id + title on ContextMenuItem (callbacks excluded). ContextMenuSettings is
// a Zorphy entity.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ContextMenuSettings', () {
    test('hideDefaultSystemContextMenuItems defaults to false', () {
      final settings = ContextMenuSettings();
      expect(settings.hideDefaultSystemContextMenuItems, isFalse);
      expect(settings.toJson()['hideDefaultSystemContextMenuItems'], isFalse);

      final restored = ContextMenuSettings.fromJson({
        'hideDefaultSystemContextMenuItems': true,
      });
      expect(restored.hideDefaultSystemContextMenuItems, isTrue);
    });
  });

  group('ContextMenuItem', () {
    test('wire is id + title only (action callback excluded)', () {
      var clicked = false;
      final item = ContextMenuItem(
        id: 42,
        title: 'Item 1',
        action: () => clicked = true,
      );
      final map = item.toMap();
      expect(map['id'], 42);
      expect(map['title'], 'Item 1');
      expect(map.containsKey('action'), isFalse);

      final restored = ContextMenuItem.fromMap(map)!;
      expect(restored.id, 42);
      expect(restored.title, 'Item 1');
      expect(restored.action, isNull);
    });
  });

  group('ContextMenu', () {
    test('wire is menuItems + settings (callbacks excluded)', () {
      final menu = ContextMenu(
        menuItems: [
          ContextMenuItem(id: 1, title: 'A'),
          ContextMenuItem(id: 'b', title: 'B'),
        ],
        settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: true),
        onHideContextMenu: () {},
      );
      final map = menu.toMap();
      expect(map.containsKey('onHideContextMenu'), isFalse);
      expect(map.containsKey('onCreateContextMenu'), isFalse);
      expect((map['menuItems'] as List).length, 2);
      expect((map['menuItems'] as List).first, {'id': 1, 'title': 'A'});
      expect(
        (map['settings'] as Map)['hideDefaultSystemContextMenuItems'],
        isTrue,
      );

      final restored = ContextMenu.fromMap(map)!;
      expect(restored.menuItems.length, 2);
      expect(restored.menuItems.first.id, 1);
      expect(restored.settings!.hideDefaultSystemContextMenuItems, isTrue);
      expect(restored.onHideContextMenu, isNull);
    });

    test('menuItems defaults to empty list', () {
      final menu = ContextMenu();
      expect(menu.menuItems, isEmpty);
      expect(menu.toMap()['menuItems'], isEmpty);
    });
  });
}
