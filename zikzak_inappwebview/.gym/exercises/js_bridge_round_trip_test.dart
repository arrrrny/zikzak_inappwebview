/// GYM exercise — JS bridge message round-trip (graded).
///
/// Brief (spec 022 / issue #397, US2-S3): the headless form of "boot a
/// WebView and drive its JS bridge" — a genuine dev task, not a
/// re-skinned unit test. The exercise:
///
///   1. BOOTS an [InAppWebViewController] on a faked platform (the
///      repo's established platform-interface fake pattern — no device,
///      no emulator, no network).
///   2. REGISTERS a Dart-side JavaScript handler through the public
///      `JavaScriptController` facade (`addJavaScriptHandler`).
///   3. EVALUATES JS in the bridge: calls
///      `window.zikzak_inappwebview.callHandler(...)` through
///      `evaluateJavascript` — the real JS-side calling convention — and
///      the fake platform dispatches it to the registered Dart handler
///      exactly the way the native bridge does.
///   4. ASSERTS the full message round-trip: the arguments cross the
///      bridge unchanged, the handler's return value is JSON-encoded
///      back to the JS caller, handler presence is queryable
///      (`hasJavaScriptHandler`), and the platform recorded exactly the
///      sources that were sent.
///
/// `flutter test` is the grader (FR-007: exit 0 = pass). A failure is a
/// clean, named assertion; an unexpected outcome is a mis-fire — DROP
/// CARD convention: github.com/arrrrny/drop-card.
///
/// verifyCommand:
/// `flutter test .gym/exercises/js_bridge_round_trip_test.dart`
/// evaluate: exit 0 => pass; exit !=0 => fail
library;

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Platform fake that simulates the native bridge: handler registration
/// is recorded, and a `window.zikzak_inappwebview.callHandler(...)`
/// evaluation is dispatched to the registered Dart handler with its
/// JSON-decoded arguments — the same dispatch the Android/iOS
/// implementations perform when JS calls the handler. The handler's
/// return value is JSON-encoded back, mirroring the Promise resolution
/// the JS caller awaits.
class _FakePlatformController extends PlatformInAppWebViewController {
  _FakePlatformController()
      : super.implementation(
          const PlatformInAppWebViewControllerCreationParams(
            id: 'gym-exercise-webview',
          ),
        );

  final Map<String, JavaScriptHandlerCallback> _handlers =
      <String, JavaScriptHandlerCallback>{};
  final List<String> evaluatedSources = <String>[];

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    _handlers[handlerName] = callback;
  }

  @override
  bool hasJavaScriptHandler({required String handlerName}) =>
      _handlers.containsKey(handlerName);

  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) =>
      _handlers.remove(handlerName);

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    evaluatedSources.add(source);
    final match = RegExp(
      r"callHandler\('([^']+)',\s*(.*)\)",
    ).firstMatch(source);
    if (match == null) {
      return 'ok:$source';
    }
    final handlerName = match.group(1)!;
    final args = jsonDecode(match.group(2)!) as List<dynamic>;
    final handler = _handlers[handlerName];
    if (handler == null) {
      return null;
    }
    final response = await handler(args);
    return jsonEncode(response);
  }
}

void main() {
  test(
    'js-bridge-round-trip: boot the controller, register a handler, and '
    'round-trip a message through the bridge',
    () async {
      // 1. Boot the controller stack on the faked platform.
      final platform = _FakePlatformController();
      final controller = InAppWebViewController.fromPlatform(
        platform: platform,
      );

      // 2. Register the Dart-side handler through the public facade.
      final receivedArgs = <dynamic>[];
      controller.javaScript.addJavaScriptHandler(
        handlerName: 'gymBridge',
        callback: (arguments) {
          receivedArgs.addAll(arguments);
          return <String, dynamic>{'pong': arguments.first};
        },
      );
      expect(
        controller.javaScript.hasJavaScriptHandler(handlerName: 'gymBridge'),
        isTrue,
        reason: 'a handler registered through the public facade must be '
            'queryable through the same facade',
      );

      // 3. Evaluate JS in the bridge: the real JS-side calling
      //    convention, dispatched by the (faked) native bridge.
      final result = await controller.javaScript.evaluateJavascript(
        source: 'window.zikzak_inappwebview.callHandler('
            "'gymBridge', [\"ping\", 42])",
      );

      // 4. The full round-trip is proven.
      expect(receivedArgs, <dynamic>['ping', 42],
          reason: 'the arguments must cross the bridge unchanged');
      expect(result, isA<String>(),
          reason: 'the handler response must be JSON-encoded back to JS');
      expect(
        jsonDecode(result as String),
        <String, dynamic>{'pong': 'ping'},
        reason: 'the handler return value must round-trip back to the JS '
            'caller',
      );
      expect(platform.evaluatedSources, hasLength(1));
      expect(
        platform.evaluatedSources.single,
        contains('callHandler'),
        reason: 'the platform must have received exactly the evaluation '
            'that was sent',
      );

      // Handler removal completes the lifecycle contract.
      expect(
        controller.javaScript.removeJavaScriptHandler(
          handlerName: 'gymBridge',
        ),
        isNotNull,
      );
      expect(
        controller.javaScript.hasJavaScriptHandler(handlerName: 'gymBridge'),
        isFalse,
      );
    },
  );
}
