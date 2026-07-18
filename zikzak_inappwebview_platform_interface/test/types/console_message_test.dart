import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ConsoleMessage.fromMap', () {
    test('with null message returns empty string', () {
      final result = ConsoleMessage.fromMap({
        'message': null,
        'messageLevel': 1,
      });
      expect(result, isNotNull);
      expect(result!.message, '');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with null messageLevel defaults to LOG', () {
      final result = ConsoleMessage.fromMap({
        'message': 'test message',
        'messageLevel': null,
      });
      expect(result, isNotNull);
      expect(result!.message, 'test message');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with both null returns safe defaults', () {
      final result = ConsoleMessage.fromMap({
        'message': null,
        'messageLevel': null,
      });
      expect(result, isNotNull);
      expect(result!.message, '');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with completely null map returns null', () {
      final result = ConsoleMessage.fromMap(null);
      expect(result, isNull);
    });

    test('with empty map returns safe defaults', () {
      final result = ConsoleMessage.fromMap(<String, dynamic>{});
      expect(result, isNotNull);
      expect(result!.message, '');
      expect(result.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('with valid values works correctly', () {
      final result = ConsoleMessage.fromMap({
        'message': 'Hello World',
        'messageLevel': 2,
      });
      expect(result, isNotNull);
      expect(result!.message, 'Hello World');
      expect(result.messageLevel, ConsoleMessageLevel.WARNING);
    });

    test('with ERROR level works correctly', () {
      final result = ConsoleMessage.fromMap({
        'message': 'An error occurred',
        'messageLevel': 3,
      });
      expect(result, isNotNull);
      expect(result!.message, 'An error occurred');
      expect(result.messageLevel, ConsoleMessageLevel.ERROR);
    });

    test('with DEBUG level works correctly', () {
      final result = ConsoleMessage.fromMap({
        'message': 'debug info',
        'messageLevel': 4,
      });
      expect(result, isNotNull);
      expect(result!.message, 'debug info');
      expect(result.messageLevel, ConsoleMessageLevel.DEBUG);
    });
  });
}
