import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('addJavaScriptHandler', () {
    test('stores a handler that can be checked with hasJavaScriptHandler', () {
      controller.addJavaScriptHandler(
        handlerName: 'testHandler',
        callback: (args) async => 'result',
      );
      expect(
        controller.hasJavaScriptHandler(handlerName: 'testHandler'),
        isTrue,
      );
    });

    test('handler returns the correct result via removeJavaScriptHandler', () {
      controller.addJavaScriptHandler(
        handlerName: 'anotherHandler',
        callback: (args) async => 42,
      );
      final removed = controller.removeJavaScriptHandler(
        handlerName: 'anotherHandler',
      );
      expect(removed, isNotNull);
      expect(
        controller.hasJavaScriptHandler(handlerName: 'anotherHandler'),
        isFalse,
      );
    });

    test('replacing an existing handler overwrites it', () {
      controller.addJavaScriptHandler(
        handlerName: 'overwrite',
        callback: (args) async => 'first',
      );
      controller.addJavaScriptHandler(
        handlerName: 'overwrite',
        callback: (args) async => 'second',
      );
      expect(controller.hasJavaScriptHandler(handlerName: 'overwrite'), isTrue);
    });
  });

  group('removeJavaScriptHandler', () {
    test('returns null when handler does not exist', () {
      final result = controller.removeJavaScriptHandler(
        handlerName: 'nonExistent',
      );
      expect(result, isNull);
    });

    test('returns the callback when handler exists', () {
      controller.addJavaScriptHandler(
        handlerName: 'removable',
        callback: (args) async => true,
      );
      final removed = controller.removeJavaScriptHandler(
        handlerName: 'removable',
      );
      expect(removed, isNotNull);
      expect(removed!, isA<JavaScriptHandlerCallback>());
    });

    test('handler no longer exists after removal', () {
      controller.addJavaScriptHandler(
        handlerName: 'temp',
        callback: (args) async => 'value',
      );
      controller.removeJavaScriptHandler(handlerName: 'temp');
      expect(controller.hasJavaScriptHandler(handlerName: 'temp'), isFalse);
    });
  });

  group('hasJavaScriptHandler', () {
    test('returns false for never-added handler', () {
      expect(
        controller.hasJavaScriptHandler(handlerName: 'neverAdded'),
        isFalse,
      );
    });

    test('returns true after adding, false after removing', () {
      controller.addJavaScriptHandler(
        handlerName: 'toggle',
        callback: (args) async => 'on',
      );
      expect(controller.hasJavaScriptHandler(handlerName: 'toggle'), isTrue);
      controller.removeJavaScriptHandler(handlerName: 'toggle');
      expect(controller.hasJavaScriptHandler(handlerName: 'toggle'), isFalse);
    });
  });

  group('dispose', () {
    test('clears all handlers', () {
      controller.addJavaScriptHandler(
        handlerName: 'persist',
        callback: (args) async => 'value',
      );
      controller.addJavaScriptHandler(
        handlerName: 'persist2',
        callback: (args) async => 'value2',
      );
      controller.dispose();
      expect(controller.hasJavaScriptHandler(handlerName: 'persist'), isFalse);
      expect(controller.hasJavaScriptHandler(handlerName: 'persist2'), isFalse);
    });
  });

  group('onWebContentProcessDidTerminate', () {
    test('invokes the callback when the method is dispatched (issue #194)', () async {
      var invoked = false;
      final widgetParams = PlatformInAppWebViewWidgetCreationParams(
        controllerFromPlatform: (c) => c,
        onWebContentProcessDidTerminate: (c) {
          invoked = true;
        },
      );
      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: 12345,
        webviewParams: widgetParams,
      );
      final ctl = MacOSInAppWebViewController(controllerParams);

      await ctl.handleMethod(
        const MethodCall('onWebContentProcessDidTerminate'),
      );

      expect(invoked, isTrue);
      ctl.dispose();
    });

    test('does not throw when no callback is registered', () async {
      // controller in setUp has no onWebContentProcessDidTerminate callback
      await controller.handleMethod(
        const MethodCall('onWebContentProcessDidTerminate'),
      );
      // reaching here without throwing is the assertion
    });
  });

  // Regression test for issue #192:
  // https://github.com/arrrrny/zikzak_inappwebview/issues/192
  //
  // On macOS, `InAppWebView.swift` `decidePolicyFor navigationAction:` used
  // to invoke `shouldOverrideUrlLoading` on the method channel fire-and-
  // forget and then unconditionally call `decisionHandler(.allow)`. The fix
  // awaits the Dart-side response and maps the returned
  // `NavigationActionPolicy` int (0=cancel, 1=allow, 2=download) to the
  // `WKNavigationActionPolicy` handed to `decisionHandler`.
  //
  // These tests pin the *Dart-side* channel contract that the Swift fix
  // relies on: the integer returned by `handleMethod('shouldOverrideUrlLoading')`
  // must match `NavigationActionPolicy.*.toNativeValue()` so the native side
  // can decode it correctly.
  group('shouldOverrideUrlLoading channel contract (issue #192)', () {
    /// Build a `MethodCall` that mirrors the payload the macOS
    /// `InAppWebView.swift` sends to Dart when a navigation action is about
    /// to occur. Only the fields consumed by `NavigationAction.fromMap` are
    /// populated; the rest default to `null` on the Dart side.
    MethodCall shouldOverrideUrlLoadingCall(String url) {
      return MethodCall('shouldOverrideUrlLoading', {
        'navigationAction': {
          'request': {'url': url},
          'isForMainFrame': true,
        },
      });
    }

    test('returns ALLOW (1) when no callback is registered', () async {
      // `controller` from setUp has no `shouldOverrideUrlLoading` wired up.
      final result = await controller.handleMethod(
        shouldOverrideUrlLoadingCall('https://example.com'),
      );
      expect(result, NavigationActionPolicy.ALLOW.toNativeValue());
    });

    test(
      'returns CANCEL (0) when the callback blocks a non-allowed scheme (intent:)',
      () async {
        final widgetParams = PlatformInAppWebViewWidgetCreationParams(
          controllerFromPlatform: (c) => c,
          shouldOverrideUrlLoading: (c, navigationAction) async {
            final url = navigationAction.request.url;
            if (url != null && url.scheme == 'intent') {
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
        );
        final controllerParams = PlatformInAppWebViewControllerCreationParams(
          id: 54321,
          webviewParams: widgetParams,
        );
        final ctrl = MacOSInAppWebViewController(controllerParams);
        addTearDown(ctrl.dispose);

        final blockedResult = await ctrl.handleMethod(
          shouldOverrideUrlLoadingCall('intent://example.com#Intent;end;'),
        );
        expect(
          blockedResult,
          NavigationActionPolicy.CANCEL.toNativeValue(),
          reason:
              'A blocked scheme must surface as CANCEL (0) so the macOS '
              'native side calls `decisionHandler(.cancel)` and stops the '
              'navigation. This is the exact regression from issue #192.',
        );

        final allowedResult = await ctrl.handleMethod(
          shouldOverrideUrlLoadingCall('https://example.com'),
        );
        expect(
          allowedResult,
          NavigationActionPolicy.ALLOW.toNativeValue(),
          reason: 'Allowed schemes must surface as ALLOW (1).',
        );
      },
    );

    test(
      'returns CANCEL (0) when the callback returns null (safe default)',
      () async {
        final widgetParams = PlatformInAppWebViewWidgetCreationParams(
          controllerFromPlatform: (c) => c,
          shouldOverrideUrlLoading: (c, navigationAction) async => null,
        );
        final controllerParams = PlatformInAppWebViewControllerCreationParams(
          id: 67890,
          webviewParams: widgetParams,
        );
        final ctrl = MacOSInAppWebViewController(controllerParams);
        addTearDown(ctrl.dispose);

        final result = await ctrl.handleMethod(
          shouldOverrideUrlLoadingCall('https://example.com'),
        );
        expect(
          result,
          NavigationActionPolicy.CANCEL.toNativeValue(),
          reason:
              'When the callback is registered but returns null, the Dart '
              'side must default to CANCEL so the native side never silently '
              'allows a navigation the user did not explicitly approve.',
        );
      },
    );
  });
}
