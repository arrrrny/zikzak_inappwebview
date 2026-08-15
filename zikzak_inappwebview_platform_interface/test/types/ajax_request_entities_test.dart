// Public-API regression tests for the ajax_request model family, migrated from
// @ExchangeableObject/@ExchangeableEnum codegen to Zorphy entities
// (see PROGRESS.md, Phase 2a).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (incl. the fork's `action` default)
//   - JSON wire format (map keys; WebUri as toString; int enums as index;
//     AjaxRequestEventType as its native strings; nested maps for
//     event/headers; AjaxRequestHeaders.toMap() = accumulated new headers)
//   - null/missing-key tolerance of fromJson
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('AjaxRequest', () {
    test('default constructor keeps the fork defaults', () {
      final r = AjaxRequest();
      expect(r.action, AjaxRequestAction.PROCEED);
      expect(r.data, isNull);
      expect(r.method, isNull);
      expect(r.url, isNull);
      expect(r.event, isNull);
      expect(r.headers, isNull);
      expect(r.readyState, isNull);
    });

    test('toJson emits the fork wire format', () {
      final r = AjaxRequest(
        data: 'payload',
        method: 'GET',
        url: WebUri('https://flutter.dev/api'),
        readyState: AjaxRequestReadyState.DONE,
        responseHeaders: {'x-a': 'b'},
        event: AjaxRequestEvent(type: AjaxRequestEventType.LOADSTART),
        action: AjaxRequestAction.ABORT,
      );
      final map = r.toJson();
      expect(map['data'], 'payload');
      expect(map['method'], 'GET');
      expect(map['url'], 'https://flutter.dev/api');
      expect(map['readyState'], 4);
      expect(map['action'], 0);
      expect(map['responseHeaders'], {'x-a': 'b'});
      expect(map['event'], {
        'type': 'loadstart',
        'lengthComputable': null,
        'loaded': null,
        'total': null,
      });
    });

    test('fromJson is null/missing-key tolerant (same as old fromMap)', () {
      final r = AjaxRequest.fromJson({});
      expect(r.action, AjaxRequestAction.PROCEED);
      expect(r.data, isNull);
      expect(r.url, isNull);
      expect(r.event, isNull);
      expect(r.readyState, isNull);
      expect(r.responseHeaders, isNull);
    });

    test('fromJson(toJson) round-trips (WebUri + nested event)', () {
      final r = AjaxRequest(
        url: WebUri('https://flutter.dev'),
        responseURL: WebUri('https://flutter.dev/redirected'),
        readyState: AjaxRequestReadyState.LOADING,
        event: AjaxRequestEvent(
          type: AjaxRequestEventType.PROGRESS,
          lengthComputable: true,
          loaded: 10,
          total: 100,
        ),
        action: AjaxRequestAction.PROCEED,
      );
      final back = AjaxRequest.fromJson(r.toJson());
      expect(back.url?.toString(), 'https://flutter.dev');
      expect(back.responseURL?.toString(), 'https://flutter.dev/redirected');
      expect(back.readyState, AjaxRequestReadyState.LOADING);
      expect(back.event?.type, AjaxRequestEventType.PROGRESS);
      expect(back.event?.loaded, 10);
      expect(back.event?.total, 100);
      expect(back.action, AjaxRequestAction.PROCEED);
    });

    test(
      'int enums keep the old native values (index == old _nativeValue)',
      () {
        expect(AjaxRequestAction.ABORT.index, 0);
        expect(AjaxRequestAction.PROCEED.index, 1);
        expect(AjaxRequestReadyState.UNSENT.index, 0);
        expect(AjaxRequestReadyState.DONE.index, 4);
      },
    );

    test('copyWith is available (zorphy addition)', () {
      final r = AjaxRequest(method: 'GET');
      expect(r.copyWith(method: 'POST').method, 'POST');
      expect(r.copyWith().method, 'GET');
    });
  });

  group('AjaxRequestEvent', () {
    test('toJson uses the native string wire for type', () {
      final e = AjaxRequestEvent(
        type: AjaxRequestEventType.LOADEND,
        lengthComputable: true,
        loaded: 5,
        total: 5,
      );
      expect(e.toJson(), {
        'type': 'loadend',
        'lengthComputable': true,
        'loaded': 5,
        'total': 5,
      });
    });

    test('fromJson maps native strings back to enum values', () {
      final e = AjaxRequestEvent.fromJson({'type': 'timeout', 'loaded': 1});
      expect(e.type, AjaxRequestEventType.TIMEOUT);
      expect(e.loaded, 1);
      expect(e.lengthComputable, isNull);
      expect(AjaxRequestEvent.fromJson({}).type, isNull);
    });
  });

  group('AjaxRequestHeaders (hand-written, skip/fork)', () {
    test('public API + wire semantics preserved', () {
      final h = AjaxRequestHeaders({'a': '1'});
      expect(h.getHeaders(), {'a': '1'});
      // wire form is the ACCUMULATED new headers (old toMap semantics)
      expect(h.toMap(), isEmpty);
      expect(h.toJson(), isEmpty);
      h.setRequestHeader('x', 'y');
      expect(h.toMap(), {'x': 'y'});
      final fromMap = AjaxRequestHeaders.fromMap({'b': '2'});
      expect(fromMap?.getHeaders(), {'b': '2'});
      expect(AjaxRequestHeaders.fromMap(null), isNull);
    });
  });

  group('AjaxRequest.headers (nested, via fromMap glue)', () {
    test('headers round-trip through toJson/fromJson', () {
      final r = AjaxRequest(headers: AjaxRequestHeaders({'a': '1'}));
      // wire: toMap() returns the accumulated new headers (empty here)
      expect(r.toJson()['headers'], isEmpty);
      final back = AjaxRequest.fromJson({
        'headers': {'a': '1'},
      });
      expect(back.headers?.getHeaders(), {'a': '1'});
    });
  });
}
