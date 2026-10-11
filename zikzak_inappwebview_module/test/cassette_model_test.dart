import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_module/zikzak_inappwebview_module.dart';

void main() {
  group('Cassette', () {
    test('serializes and deserializes correctly', () {
      final cassette = Cassette(
        name: 'test-cassette',
        recordedAt: DateTime(2026, 8, 24, 12, 0, 0),
        entries: [
          CassetteEntry(
            url: 'https://example.com',
            servedHtml: '<html><body>Example</body></html>',
            networkEvents: [
              CassetteNetworkEvent(
                url: 'https://example.com/style.css',
                method: 'GET',
                requestHeaders: {'accept': 'text/css'},
                statusCode: 200,
                responseHeaders: {'content-type': 'text/css'},
                responseBody: 'body { color: red; }',
              ),
            ],
            cookieSnapshot: {'session': 'abc123'},
          ),
        ],
      );

      final json = cassette.toJson();
      final restored = Cassette.fromJson(json);

      expect(restored.name, equals('test-cassette'));
      expect(restored.formatVersion, equals(1));
      expect(restored.entries.length, equals(1));
      expect(restored.entries[0].url, equals('https://example.com'));
      expect(
        restored.entries[0].servedHtml,
        equals('<html><body>Example</body></html>'),
      );
      expect(restored.entries[0].networkEvents.length, equals(1));
      expect(
        restored.entries[0].networkEvents[0].url,
        equals('https://example.com/style.css'),
      );
      expect(
        restored.entries[0].networkEvents[0].responseBody,
        equals('body { color: red; }'),
      );
    });

    test('rejects unsupported format version', () {
      final json = {
        'formatVersion': 999,
        'name': 'future',
        'recordedAt': DateTime.now().toIso8601String(),
        'entries': <dynamic>[],
      };

      expect(
        () => Cassette.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Unsupported cassette format version: 999'),
          ),
        ),
      );
    });

    test('handles empty cassette', () {
      final cassette = Cassette(name: 'empty', recordedAt: DateTime.now());
      expect(cassette.entries, isEmpty);
      final json = cassette.toJson();
      final restored = Cassette.fromJson(json);
      expect(restored.name, equals('empty'));
      expect(restored.entries, isEmpty);
    });

    test('handles cassette with no network events', () {
      final cassette = Cassette(
        name: 'no-network',
        recordedAt: DateTime.now(),
        entries: [
          CassetteEntry(url: 'https://example.com', servedHtml: '<html></html>'),
        ],
      );
      final json = cassette.toJson();
      final restored = Cassette.fromJson(json);
      expect(restored.entries[0].networkEvents, isEmpty);
    });
  });

  group('CassetteNetworkEvent', () {
    test('round-trips through JSON', () {
      final event = CassetteNetworkEvent(
        url: 'https://api.example.com/data',
        method: 'POST',
        requestHeaders: {'content-type': 'application/json'},
        requestBody: '{"key": "value"}',
        statusCode: 200,
        responseHeaders: {'x-request-id': '123'},
        responseBody: '{"result": "ok"}',
      );
      final json = event.toJson();
      final restored = CassetteNetworkEvent.fromJson(json);
      expect(restored.url, equals(event.url));
      expect(restored.method, equals(event.method));
      expect(restored.requestBody, equals(event.requestBody));
      expect(restored.responseBody, equals(event.responseBody));
      expect(restored.statusCode, equals(event.statusCode));
    });
  });

  group('CassetteEngineImpl', () {
    test('enum values exist', () {
      expect(CassetteMode.values, containsAll([
        CassetteMode.record,
        CassetteMode.replay,
      ]));
      expect(UnmatchedPolicy.values, containsAll([
        UnmatchedPolicy.hard,
        UnmatchedPolicy.soft,
      ]));
    });
  });
}
