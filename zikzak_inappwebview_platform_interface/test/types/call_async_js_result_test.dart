// Public-API regression tests for CallAsyncJavaScriptResult (Zorphy
// valueObject entity). Pins the consumer-visible contract:
//   - constructor shape (value: dynamic, error: String?)
//   - JSON wire format (dynamic value + error pass through)
//   - null/missing-key tolerance of fromJson
// See PROGRESS.md — this is part of the conformance suite that will be reused
// during the zuraffa-only (zfa CLI) migration.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('CallAsyncJavaScriptResult', () {
    test('default constructor keeps nulls', () {
      final r = CallAsyncJavaScriptResult();
      expect(r.value, isNull);
      expect(r.error, isNull);
    });

    test('toJson passes value + error through', () {
      final r = CallAsyncJavaScriptResult(value: 42, error: null);
      expect(r.toJson(), {'value': 42, 'error': null});

      final r2 = CallAsyncJavaScriptResult(value: {'a': [1, 2]}, error: 'boom');
      expect(r2.toJson()['value'], {'a': [1, 2]});
      expect(r2.toJson()['error'], 'boom');
    });

    test('fromJson is null/missing-key tolerant', () {
      final r = CallAsyncJavaScriptResult.fromJson({});
      expect(r.value, isNull);
      expect(r.error, isNull);
      final r2 = CallAsyncJavaScriptResult.fromJson({'value': null, 'error': 'e'});
      expect(r2.value, isNull);
      expect(r2.error, 'e');
    });

    test('round-trip preserves dynamic value', () {
      final r = CallAsyncJavaScriptResult(
        value: {'result': true, 'list': [1, 2, 3]},
        error: null,
      );
      final back = CallAsyncJavaScriptResult.fromJson(r.toJson());
      expect(back.value, {'result': true, 'list': [1, 2, 3]});
      expect(back.error, isNull);
    });

    test('copyWith is available (zorphy addition)', () {
      final r = CallAsyncJavaScriptResult(value: 1);
      expect(r.copyWith(error: 'x').error, 'x');
      expect(r.copyWith(error: 'x').value, 1);
      expect(r.copyWith().error, isNull);
    });
  });
}
