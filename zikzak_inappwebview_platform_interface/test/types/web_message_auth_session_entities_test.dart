// Public-API regression tests for the web_message + web_authentication_session
// families, migrated from @ExchangeableObject/@ExchangeableEnum codegen to
// Zorphy entities (see PROGRESS.md, Phase 3b).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (incl. the fork's defaults)
//   - JSON wire format (map keys; WebMessage.type as int .index with STRING
//     default; ports pass-through; WebAuthenticationSessionError as its
//     1-based wire ints; settings defaults)
//   - null/missing-key tolerance of fromJson
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('WebMessage', () {
    test('type defaults to STRING + int wire', () {
      final message = WebMessage(data: 'hello');
      expect(message.type, WebMessageType.STRING);
      final map = message.toJson();
      expect(map['data'], 'hello');
      expect(map['type'], 0);

      final array = WebMessage(data: [1, 2], type: WebMessageType.ARRAY_BUFFER);
      expect(array.toJson()['type'], 1);

      final restored = WebMessage.fromJson(map);
      expect(restored.type, WebMessageType.STRING);
      expect(restored.data, 'hello');
    });

    test('fromJson tolerates missing type (defaults to STRING)', () {
      final restored = WebMessage.fromJson({'data': 'x'});
      expect(restored.type, WebMessageType.STRING);
    });
  });

  group('WebAuthenticationSessionSettings', () {
    test('prefersEphemeralWebBrowserSession defaults to false', () {
      final settings = WebAuthenticationSessionSettings();
      expect(settings.prefersEphemeralWebBrowserSession, isFalse);
      expect(settings.toJson()['prefersEphemeralWebBrowserSession'], isFalse);
    });

    test('additionalHeaderFields round-trip', () {
      final settings = WebAuthenticationSessionSettings(
        prefersEphemeralWebBrowserSession: true,
        additionalHeaderFields: {'X-Test': '1'},
      );
      final map = settings.toJson();
      expect(map['prefersEphemeralWebBrowserSession'], true);
      expect(map['additionalHeaderFields'], {'X-Test': '1'});

      final restored = WebAuthenticationSessionSettings.fromJson(map);
      expect(restored.prefersEphemeralWebBrowserSession, isTrue);
      expect(restored.additionalHeaderFields, {'X-Test': '1'});
    });
  });

  group('WebAuthenticationSessionError (1-based wire)', () {
    test('wire helpers map 1..3 to the enum', () {
      expect(
        webAuthenticationSessionErrorFromWire(1),
        WebAuthenticationSessionError.CANCELED_LOGIN,
      );
      expect(
        webAuthenticationSessionErrorFromWire(2),
        WebAuthenticationSessionError.PRESENTATION_CONTEXT_NOT_PROVIDED,
      );
      expect(
        webAuthenticationSessionErrorFromWire(3),
        WebAuthenticationSessionError.PRESENTATION_CONTEXT_INVALID,
      );
      expect(webAuthenticationSessionErrorFromWire(0), isNull);
      expect(webAuthenticationSessionErrorFromWire(99), isNull);
      expect(
        webAuthenticationSessionErrorToWire(
          WebAuthenticationSessionError.PRESENTATION_CONTEXT_INVALID,
        ),
        3,
      );
    });
  });

  group('WebAuthenticationSupport', () {
    test('sequential int wire', () {
      expect(WebAuthenticationSupport.NONE.index, 0);
      expect(WebAuthenticationSupport.FOR_BROWSER.index, 2);
    });
  });
}
