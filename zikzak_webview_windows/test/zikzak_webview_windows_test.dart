import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_webview_windows/zikzak_webview_windows.dart';

/// Compile-time probe: the DevTools protocol entry points this fork exists to
/// expose stay on the public controller API.
// ignore: unused_element
void _devToolsSurface(WebviewController controller) {
  controller.callDevToolsProtocolMethod('Page.enable', <String, dynamic>{});
  controller.devToolsProtocolEvent.listen((Map<String, dynamic> _) {});
}

void main() {
  group('zikzak_webview_windows package surface', () {
    test('LoadingState keeps the order the native enum defines', () {
      expect(LoadingState.values, <LoadingState>[
        LoadingState.none,
        LoadingState.loading,
        LoadingState.navigationCompleted,
      ]);
    });

    test('PointerButton keeps the order the native enum defines', () {
      expect(PointerButton.values, <PointerButton>[
        PointerButton.none,
        PointerButton.primary,
        PointerButton.secondary,
        PointerButton.tertiary,
      ]);
    });
  });
}
