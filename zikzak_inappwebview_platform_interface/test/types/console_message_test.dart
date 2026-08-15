// Public-API regression tests for ConsoleMessage, migrated from
// @ExchangeableObject codegen to a Zorphy entity (see PROGRESS.md, Phase 2c).
// Ported from the upstream fromMap-based test to the fromJson API; the
// null/missing-key behaviors it pinned are preserved.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ConsoleMessage.fromJson', () {
    test('with null message returns empty string', () {
      final result = ConsoleMessage.fromJson({
        'message': null,
        'messageLevel': 1,
      });
      expect(result.message, '');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with null messageLevel defaults to LOG', () {
      final result = ConsoleMessage.fromJson({
        'message': 'test message',
        'messageLevel': null,
      });
      expect(result.message, 'test message');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with both null returns safe defaults', () {
      final result = ConsoleMessage.fromJson({
        'message': null,
        'messageLevel': null,
      });
      expect(result.message, '');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with empty map returns safe defaults', () {
      final result = ConsoleMessage.fromJson(<String, dynamic>{});
      expect(result.message, '');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with valid values works correctly', () {
      final result = ConsoleMessage.fromJson({
        'message': 'Hello World',
        'messageLevel': 2,
      });
      expect(result.message, 'Hello World');
      expect(result.messageLevel, ConsoleMessageLevel.WARNING);
    });

    test('with ERROR level works correctly', () {
      final result = ConsoleMessage.fromJson({
        'message': 'An error occurred',
        'messageLevel': 3,
      });
      expect(result.message, 'An error occurred');
      expect(result.messageLevel, ConsoleMessageLevel.ERROR);
    });

    test('with DEBUG level works correctly', () {
      final result = ConsoleMessage.fromJson({
        'message': 'debug info',
        'messageLevel': 4,
      });
      expect(result.message, 'debug info');
      expect(result.messageLevel, ConsoleMessageLevel.DEBUG);
    });
  });
}
