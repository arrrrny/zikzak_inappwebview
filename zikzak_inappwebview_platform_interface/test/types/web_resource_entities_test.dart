// Public-API regression tests for the console_message + web_resource model
// family, migrated from @ExchangeableObject/@ExchangeableEnum codegen to
// Zorphy entities (see PROGRESS.md, Phase 2c).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (incl. the fork's defaults: ConsoleMessage
//     message="" messageLevel=LOG; WebResourceResponse contentType=""
//     contentEncoding="utf-8")
//   - JSON wire format (map keys; WebUri as toString; ConsoleMessageLevel as
//     its index; WebResourceErrorType as its native string == enum name;
//     Uint8List data pass-through on the channel and List<int> on JSON paths)
//   - null/missing-key tolerance of fromJson
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ConsoleMessage', () {
    test('default constructor keeps the fork defaults', () {
      final m = ConsoleMessage();
      expect(m.message, '');
      expect(m.messageLevel, ConsoleMessageLevel.LOG);
    });

    test('toJson emits the fork wire format', () {
      final m = ConsoleMessage(
        message: 'hello',
        messageLevel: ConsoleMessageLevel.ERROR,
      );
      expect(m.toJson(), {'message': 'hello', 'messageLevel': 3});
    });

    test('fromJson is null/missing-key tolerant', () {
      final m = ConsoleMessage.fromJson({});
      expect(m.message, '');
      expect(m.messageLevel, ConsoleMessageLevel.LOG);
      expect(ConsoleMessage.fromJson({'message': 'x'}).message, 'x');
      expect(
        ConsoleMessage.fromJson({'messageLevel': 4}).messageLevel,
        ConsoleMessageLevel.DEBUG,
      );
    });

    test('round-trip', () {
      final m = ConsoleMessage(
        message: 'warn',
        messageLevel: ConsoleMessageLevel.WARNING,
      );
      final back = ConsoleMessage.fromJson(m.toJson());
      expect(back.message, 'warn');
      expect(back.messageLevel, ConsoleMessageLevel.WARNING);
    });
  });

  group('ConsoleMessageLevel', () {
    test('int enums keep the old native values (index == old _nativeValue)', () {
      expect(ConsoleMessageLevel.TIP.index, 0);
      expect(ConsoleMessageLevel.LOG.index, 1);
      expect(ConsoleMessageLevel.WARNING.index, 2);
      expect(ConsoleMessageLevel.ERROR.index, 3);
      expect(ConsoleMessageLevel.DEBUG.index, 4);
    });
  });

  group('WebResourceError', () {
    test('toJson uses the native string wire for type', () {
      final e = WebResourceError(
        type: WebResourceErrorType.BAD_URL,
        description: 'bad url',
      );
      expect(e.toJson(), {'type': 'BAD_URL', 'description': 'bad url'});
    });

    test('fromJson maps native strings back to enum values', () {
      final e = WebResourceError.fromJson({'type': 'TIMEOUT', 'description': 't'});
      expect(e.type, WebResourceErrorType.TIMEOUT);
      expect(e.description, 't');
      expect(WebResourceError.fromJson({}).type, isNull);
      expect(WebResourceError.fromJson({}).description, isNull);
    });
  });

  group('WebResourceRequest', () {
    test('toJson emits the fork wire format', () {
      final r = WebResourceRequest(
        url: WebUri('https://flutter.dev/res'),
        headers: {'x-a': 'b'},
        method: 'GET',
        hasGesture: true,
        isForMainFrame: true,
        isRedirect: false,
      );
      final map = r.toJson();
      expect(map['url'], 'https://flutter.dev/res');
      expect(map['headers'], {'x-a': 'b'});
      expect(map['method'], 'GET');
      expect(map['hasGesture'], true);
      expect(map['isForMainFrame'], true);
      expect(map['isRedirect'], false);
    });

    test('fromJson is null/missing-key tolerant + round-trip', () {
      final r = WebResourceRequest.fromJson({});
      expect(r.url, isNull);
      expect(r.headers, isNull);
      expect(r.method, isNull);

      final full = WebResourceRequest(
        url: WebUri('https://flutter.dev/a'),
        headers: {'h': '1'},
        method: 'POST',
      );
      final back = WebResourceRequest.fromJson(full.toJson());
      expect(back.url?.toString(), 'https://flutter.dev/a');
      expect(back.headers, {'h': '1'});
      expect(back.method, 'POST');
    });
  });

  group('WebResourceResponse', () {
    test('default constructor keeps the fork defaults', () {
      final r = WebResourceResponse();
      expect(r.contentType, '');
      expect(r.contentEncoding, 'utf-8');
      expect(r.data, isNull);
      expect(r.headers, isNull);
      expect(r.statusCode, isNull);
      expect(r.reasonPhrase, isNull);
    });

    test('toJson emits the fork wire format (Uint8List data)', () {
      final r = WebResourceResponse(
        contentType: 'text/html',
        contentEncoding: 'utf-8',
        data: Uint8List.fromList([1, 2, 3]),
        headers: {'h': '1'},
        statusCode: 200,
        reasonPhrase: 'OK',
      );
      final map = r.toJson();
      expect(map['contentType'], 'text/html');
      expect(map['contentEncoding'], 'utf-8');
      expect(map['data'], isA<Uint8List>());
      expect(map['headers'], {'h': '1'});
      expect(map['statusCode'], 200);
      expect(map['reasonPhrase'], 'OK');
      // jsonEncode of the map must work (data becomes a JSON int list)
      final encoded = jsonEncode(map);
      expect(encoded, contains('"data":[1,2,3]'));
    });

    test('fromJson accepts both Uint8List and List<int> data', () {
      final viaList = WebResourceResponse.fromJson({
        'data': [4, 5],
      });
      expect(viaList.data, Uint8List.fromList([4, 5]));

      final viaTyped = WebResourceResponse.fromJson({
        'data': Uint8List.fromList([6]),
      });
      expect(viaTyped.data, Uint8List.fromList([6]));

      expect(WebResourceResponse.fromJson({}).data, isNull);
    });

    test('round-trip keeps defaults + data', () {
      final r = WebResourceResponse(
        data: Uint8List.fromList([7, 8, 9]),
        statusCode: 404,
        reasonPhrase: 'Not Found',
      );
      final back = WebResourceResponse.fromJson(r.toJson());
      expect(back.contentType, '');
      expect(back.contentEncoding, 'utf-8');
      expect(back.data, Uint8List.fromList([7, 8, 9]));
      expect(back.statusCode, 404);
      expect(back.reasonPhrase, 'Not Found');
    });
  });

  group('WebResourceErrorType', () {
    test('native wire strings equal the enum names', () {
      expect(WebResourceErrorType.UNKNOWN.name, 'UNKNOWN');
      expect(WebResourceErrorType.HOST_LOOKUP.name, 'HOST_LOOKUP');
      expect(WebResourceErrorType.CANCELLED.name, 'CANCELLED');
      expect(WebResourceErrorType.values.length, greaterThan(50));
    });
  });
}
