import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Tests for macOS-specific InAppWebView bug fixes.
///
/// These validate the Dart-side null safety fixes for ConsoleMessage
/// parsing, which previously crashed with type 'Null' is not a subtype
/// of type 'String' when JavaScript called console.log() with no arguments.
///
/// Full integration tests for addJavaScriptHandler require a macOS
/// device and are covered by unit tests in the zikzak_inappwebview_macos
/// package.
void main() {
  group('MacOS ConsoleMessage.fromJson null safety', () {
    test('handles null message without crashing', () {
      final msg = ConsoleMessage.fromJson({'message': null, 'messageLevel': 1});
      expect(msg.message, '');
    });

    test('handles null messageLevel without crashing', () {
      final msg = ConsoleMessage.fromJson({
        'message': 'test',
        'messageLevel': null,
      });
      expect(msg.message, 'test');
      expect(msg.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('handles both null without crashing', () {
      final msg = ConsoleMessage.fromJson({
        'message': null,
        'messageLevel': null,
      });
      expect(msg.message, '');
      expect(msg.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('empty map returns safe defaults', () {
      final msg = ConsoleMessage.fromJson(<String, dynamic>{});
      expect(msg.message, '');
      expect(msg.messageLevel, ConsoleMessageLevel.LOG);
    });
  });
}
