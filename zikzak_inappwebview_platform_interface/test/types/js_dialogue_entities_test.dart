// Public-API regression tests for the JS dialogue model family, migrated from
// @ExchangeableObject codegen to Zorphy entities (see PROGRESS.md, Phase 1).
//
// These tests pin the CONSUMER-VISIBLE contract that the migration must
// preserve:
//   - constructor call shapes (incl. default values)
//   - JSON wire format (map keys + int enum values + WebUri as toString)
//   - null/missing-key tolerance of fromJson
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('JsAlertResponse', () {
    test('default constructor keeps the fork defaults', () {
      final r = JsAlertResponse();
      expect(r.message, '');
      expect(r.confirmButtonTitle, '');
      expect(r.handledByClient, false);
      expect(r.action, JsAlertResponseAction.CONFIRM);
    });

    test('toJson emits the fork wire format (int action)', () {
      final r = JsAlertResponse(
        message: 'hello',
        handledByClient: true,
      );
      expect(r.toJson(), {
        'message': 'hello',
        'confirmButtonTitle': '',
        'handledByClient': true,
        'action': 0,
      });
    });

    test('fromJson is null/missing-key tolerant (same as old fromMap)', () {
      final r = JsAlertResponse.fromJson({
        'message': null,
        'confirmButtonTitle': null,
        'handledByClient': null,
        'action': null,
      });
      expect(r.message, '');
      expect(r.confirmButtonTitle, '');
      expect(r.handledByClient, false);
      expect(r.action, JsAlertResponseAction.CONFIRM);
    });

    test('fromJson(toJson) round-trips', () {
      final r = JsAlertResponse(
        message: 'm',
        confirmButtonTitle: 'OK',
        handledByClient: true,
        action: JsAlertResponseAction.CONFIRM,
      );
      expect(JsAlertResponse.fromJson(r.toJson()), r);
    });

    test('copyWith is available (zorphy addition)', () {
      final r = JsAlertResponse(message: 'a');
      expect(r.copyWith(message: 'b').message, 'b');
      expect(r.copyWith().message, 'a');
    });
  });

  group('JsAlertRequest', () {
    test('WebUri round-trips through toJson/fromJson via toString', () {
      final r = JsAlertRequest(
        url: WebUri('https://flutter.dev'),
        message: 'm',
        isMainFrame: true,
      );
      final map = r.toJson();
      expect(map['url'], 'https://flutter.dev');
      expect(map['message'], 'm');
      expect(map['isMainFrame'], true);
      final back = JsAlertRequest.fromJson(map);
      expect(back.url?.toString(), 'https://flutter.dev');
      expect(back.message, 'm');
      expect(back.isMainFrame, true);
    });

    test('null url and missing keys stay null', () {
      final r = JsAlertRequest.fromJson({'message': 'only'});
      expect(r.url, isNull);
      expect(r.isMainFrame, isNull);
      expect(r.message, 'only');
    });
  });

  group('JsConfirmResponse / JsPromptResponse / JsBeforeUnloadResponse', () {
    test('default actions match the fork', () {
      expect(JsConfirmResponse().action, JsConfirmResponseAction.CANCEL);
      expect(JsPromptResponse().action, JsPromptResponseAction.CANCEL);
      expect(
        JsBeforeUnloadResponse().action,
        JsBeforeUnloadResponseAction.CONFIRM,
      );
    });

    test('action enums serialize as ints on the wire', () {
      expect(JsConfirmResponseAction.CONFIRM.index, 0);
      expect(JsConfirmResponseAction.CANCEL.index, 1);
      final r = JsConfirmResponse(action: JsConfirmResponseAction.CANCEL);
      expect(r.toJson()['action'], 1);
      expect(
        JsConfirmResponse.fromJson({'action': 1}).action,
        JsConfirmResponseAction.CANCEL,
      );
    });

    test('prompt value field is nullable and round-trips', () {
      final r = JsPromptResponse(value: 'typed');
      expect(r.toJson()['value'], 'typed');
      expect(JsPromptResponse.fromJson({'value': 'typed'}).value, 'typed');
    });
  });
}
