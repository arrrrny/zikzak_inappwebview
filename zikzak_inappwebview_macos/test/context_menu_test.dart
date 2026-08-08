import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_macos/src/in_app_webview/in_app_webview_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MacOSInAppWebViewController controller;

  setUp(() {
    final widgetParams = PlatformInAppWebViewWidgetCreationParams(
      controllerFromPlatform: (c) => c,
    );
    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: 12345,
      webviewParams: widgetParams,
    );
    controller = MacOSInAppWebViewController(controllerParams);
  });

  tearDown(() {
    controller.dispose();
  });

  group('setContextMenu', () {
    setUp(() {
      // Mock the method channel so invokeMethod doesn't throw
      // MissingPluginException.
      TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('dev.zuzu/zikzak_inappwebview_12345'),
        (MethodCall call) async {
          if (call.method == 'setContextMenu') {
            return true;
          }
          return null;
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('dev.zuzu/zikzak_inappwebview_12345'),
        null,
      );
    });

    test('is overridden and does not throw', () async {
      // The method should exist and be callable without throwing.
      await controller.setContextMenu(null);
    });

    test('accepts a ContextMenu with menu items', () async {
      final contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(id: 10, title: 'Item 1', action: () {}),
          ContextMenuItem(id: 42, title: 'Item 2', action: () {}),
        ],
      );
      // Should not throw — the native channel will receive the call.
      await controller.setContextMenu(contextMenu);
    });
  });

  group('onCreateContextMenu event', () {
    test('fires contextMenu.onCreateContextMenu when event is received',
        () async {
      var createCalled = false;
      InAppWebViewHitTestResult? receivedHitTestResult;

      final contextMenu = ContextMenu(
        menuItems: [],
        onCreateContextMenu: (hitTestResult) {
          createCalled = true;
          receivedHitTestResult = hitTestResult;
        },
      );

      // Recreate controller with contextMenu set
      controller.dispose();
      final widgetParams = PlatformInAppWebViewWidgetCreationParams(
        controllerFromPlatform: (c) => c,
        contextMenu: contextMenu,
      );
      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: 54321,
        webviewParams: widgetParams,
      );
      controller = MacOSInAppWebViewController(controllerParams);

      // Simulate the native side sending onCreateContextMenu
      await controller.handleMethod(
        const MethodCall('onCreateContextMenu', {'type': 7, 'extra': 'https://example.com'}),
      );

      expect(createCalled, isTrue);
      expect(receivedHitTestResult, isNotNull);
      expect(receivedHitTestResult!.type,
          InAppWebViewHitTestResultType.srcAnchorType);
      expect(receivedHitTestResult!.extra, 'https://example.com');
    });

    test('does nothing when no contextMenu is set', () async {
      // Controller with no contextMenu — should not throw
      await controller.handleMethod(
        const MethodCall('onCreateContextMenu', {'type': 0, 'extra': null}),
      );
    });

    test('does nothing when contextMenu has no onCreateContextMenu callback',
        () async {
      final contextMenu = ContextMenu(menuItems: []);
      controller.dispose();
      final widgetParams = PlatformInAppWebViewWidgetCreationParams(
        controllerFromPlatform: (c) => c,
        contextMenu: contextMenu,
      );
      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: 11111,
        webviewParams: widgetParams,
      );
      controller = MacOSInAppWebViewController(controllerParams);

      // Should not throw even without the callback
      await controller.handleMethod(
        const MethodCall('onCreateContextMenu', {'type': 0, 'extra': null}),
      );
    });
  });

  group('onHideContextMenu event', () {
    test('fires contextMenu.onHideContextMenu when event is received',
        () async {
      var hideCalled = false;
      final contextMenu = ContextMenu(
        menuItems: [],
        onHideContextMenu: () {
          hideCalled = true;
        },
      );

      controller.dispose();
      final widgetParams = PlatformInAppWebViewWidgetCreationParams(
        controllerFromPlatform: (c) => c,
        contextMenu: contextMenu,
      );
      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: 22222,
        webviewParams: widgetParams,
      );
      controller = MacOSInAppWebViewController(controllerParams);

      await controller.handleMethod(
        const MethodCall('onHideContextMenu', {}),
      );

      expect(hideCalled, isTrue);
    });

    test('does nothing when no contextMenu is set', () async {
      await controller.handleMethod(
        const MethodCall('onHideContextMenu', {}),
      );
    });
  });

  group('onContextMenuActionItemClicked event', () {
    test('fires callback and item action when item is clicked', () async {
      var itemActionCalled = false;
      ContextMenuItem? clickedItem;

      final menuItem = ContextMenuItem(
        id: 1,
        title: 'Custom Action',
        action: () {
          itemActionCalled = true;
        },
      );

      final contextMenu = ContextMenu(
        menuItems: [menuItem],
        onContextMenuActionItemClicked: (item) {
          clickedItem = item;
        },
      );

      controller.dispose();
      final widgetParams = PlatformInAppWebViewWidgetCreationParams(
        controllerFromPlatform: (c) => c,
        contextMenu: contextMenu,
      );
      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: 33333,
        webviewParams: widgetParams,
      );
      controller = MacOSInAppWebViewController(controllerParams);

      await controller.handleMethod(
        const MethodCall('onContextMenuActionItemClicked', {
          'id': 1,
          'title': 'Custom Action',
        }),
      );

      expect(itemActionCalled, isTrue,
          reason: 'item action should be called');
      expect(clickedItem, isNotNull,
          reason: 'onContextMenuActionItemClicked should fire');
      expect(clickedItem!.id, 1);
      expect(clickedItem!.title, 'Custom Action');
    });

    test('fires onContextMenuActionItemClicked even for unknown item id',
        () async {
      ContextMenuItem? clickedItem;

      final contextMenu = ContextMenu(
        menuItems: [],
        onContextMenuActionItemClicked: (item) {
          clickedItem = item;
        },
      );

      controller.dispose();
      final widgetParams = PlatformInAppWebViewWidgetCreationParams(
        controllerFromPlatform: (c) => c,
        contextMenu: contextMenu,
      );
      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: 44444,
        webviewParams: widgetParams,
      );
      controller = MacOSInAppWebViewController(controllerParams);

      await controller.handleMethod(
        const MethodCall('onContextMenuActionItemClicked', {
          'id': 99,
          'title': 'Unknown',
        }),
      );

      expect(clickedItem, isNotNull);
      expect(clickedItem!.id, 99);
      expect(clickedItem!.title, 'Unknown');
    });

    test('does nothing when no contextMenu is set', () async {
      await controller.handleMethod(
        const MethodCall('onContextMenuActionItemClicked', {
          'id': 'test',
          'title': 'Test',
        }),
      );
    });
  });

  group('InAppWebViewSettings context menu fields', () {
    test('disableContextMenu defaults to false and is serializable', () {
      final settings = InAppWebViewSettings();
      expect(settings.disableContextMenu, false);
      final map = settings.toMap();
      expect(map.containsKey('disableContextMenu'), isTrue);
      expect(map['disableContextMenu'], false);
    });

    test('disableLongPressContextMenuOnLinks defaults to false and is serializable',
        () {
      final settings = InAppWebViewSettings();
      expect(settings.disableLongPressContextMenuOnLinks, false);
      final map = settings.toMap();
      expect(map.containsKey('disableLongPressContextMenuOnLinks'), isTrue);
      expect(map['disableLongPressContextMenuOnLinks'], false);
    });

    test('settings round-trip through fromMap preserves context menu fields', () {
      final settings = InAppWebViewSettings(
        disableContextMenu: true,
        disableLongPressContextMenuOnLinks: true,
      );
      final map = settings.toMap();
      final restored = InAppWebViewSettings.fromMap(map)!;
      expect(restored.disableContextMenu, isTrue);
      expect(restored.disableLongPressContextMenuOnLinks, isTrue);
    });
  });

  group('ContextMenuSettings', () {
    test('hideDefaultSystemContextMenuItems defaults to false', () {
      final settings = ContextMenuSettings();
      expect(settings.hideDefaultSystemContextMenuItems, false);
    });

    test('hideDefaultSystemContextMenuItems can be set to true', () {
      final settings = ContextMenuSettings(hideDefaultSystemContextMenuItems: true);
      expect(settings.hideDefaultSystemContextMenuItems, isTrue);
    });
  });

  group('HitTestResult', () {
    test('can be created with type and extra', () {
      final result = InAppWebViewHitTestResult(
        type: InAppWebViewHitTestResultType.srcAnchorType,
        extra: 'https://example.com',
      );
      expect(result.type, InAppWebViewHitTestResultType.srcAnchorType);
      expect(result.extra, 'https://example.com');
    });

    test('can be created from a map', () {
      final result = InAppWebViewHitTestResult.fromMap({
        'type': 5,
        'extra': 'https://example.com/image.png',
      })!;
      expect(result.type, InAppWebViewHitTestResultType.imageType);
      expect(result.extra, 'https://example.com/image.png');
    });

    test('fromMap returns null for null input', () {
      expect(InAppWebViewHitTestResult.fromMap(null), isNull);
    });

    test('fromMap handles unknown type gracefully', () {
      final result = InAppWebViewHitTestResult.fromMap({'type': 999, 'extra': null})!;
      // Invalid type values map to null on the Dart side (the native side
      // falls back to unknownType, but Dart's enum fromNativeValue returns
      // null for unrecognized values).
      expect(result.type, isNull);
      expect(result.extra, isNull);
    });
  });
}
