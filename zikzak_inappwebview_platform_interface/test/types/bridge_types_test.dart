// Public-API regression tests for the still-codegen / hand-written bridge
// types that did not go through the Zorphy migration:
//   - InAppWebViewRect, UIImage (json_serializable codegen, wire = JSON map)
//   - ContentWorld, ScriptHtmlTagAttributes (hand-written fork; wire = toMap)
//   - callback typedefs (JavaScriptHandlerCallback, WebMessageCallback,
//     OnPostMessageCallback) — compile-time contracts
// Pins the consumer-visible wire contract for the zfa migration.
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('InAppWebViewRect', () {
    test('toJson emits the 4 doubles', () {
      final r = InAppWebViewRect(x: 1, y: 2.5, width: 3, height: 4);
      expect(r.toJson(), {'x': 1.0, 'y': 2.5, 'width': 3.0, 'height': 4.0});
    });

    test('fromJson requires all fields; round-trips', () {
      expect(() => InAppWebViewRect.fromJson({'x': 1}), throwsA(anything));
      final r = InAppWebViewRect.fromJson({'x': 1, 'y': 2, 'width': 3, 'height': 4});
      expect(r.x, 1);
      expect(r.height, 4);
      final back = InAppWebViewRect.fromJson(r.toJson());
      expect(back.width, 3.0);
      expect(r.copyWithInAppWebViewRect(x: 9).x, 9);
    });
  });

  group('UIImage', () {
    test('toJson serializes data as int list', () {
      final img = UIImage(
        name: 'a.png',
        systemName: 'photo',
        data: Uint8List.fromList([1, 2, 3]),
      );
      expect(img.toJson(), {
        'name': 'a.png',
        'systemName': 'photo',
        'data': [1, 2, 3],
      });
    });

    test('fromJson is null/missing-key tolerant + round-trip', () {
      final img = UIImage.fromJson({});
      expect(img.name, isNull);
      expect(img.systemName, isNull);
      expect(img.data, isNull);

      final full = UIImage(data: Uint8List.fromList([9, 8]));
      final back = UIImage.fromJson(full.toJson());
      expect(back.data, Uint8List.fromList([9, 8]));
    });
  });

  group('ContentWorld', () {
    test('predefined worlds + custom name + wire map', () {
      expect(ContentWorld.DEFAULT_CLIENT.name, 'defaultClient');
      expect(ContentWorld.PAGE.name, 'page');
      final custom = ContentWorld.world(name: 'myWorld');
      expect(custom.toMap(), {'name': 'myWorld'});
      expect(custom.toJson(), {'name': 'myWorld'});
      // names cannot contain spaces (assert)
      expect(
        () => ContentWorld.world(name: 'has space'),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ScriptHtmlTagAttributes (hand-written fork)', () {
    test('default type is text/javascript', () {
      final a = ScriptHtmlTagAttributes();
      expect(a.type, 'text/javascript');
      expect(a.async, isNull);
    });

    test('toMap wire: enums as native strings', () {
      final a = ScriptHtmlTagAttributes(
        async: true,
        crossOrigin: CrossOrigin.ANONYMOUS,
        defer: false,
        id: 's1',
        integrity: 'sha256-abc',
        noModule: true,
        nonce: 'n',
        referrerPolicy: ReferrerPolicy.ORIGIN,
        type: 'module',
      );
      expect(a.toMap(), {
        'async': true,
        'crossOrigin': 'anonymous',
        'defer': false,
        'id': 's1',
        'integrity': 'sha256-abc',
        'noModule': true,
        'nonce': 'n',
        'referrerPolicy': 'origin',
        'type': 'module',
      });
    });

    test('fromMap wire round-trip + null tolerance', () {
      expect(ScriptHtmlTagAttributes.fromMap(null), isNull);
      final a = ScriptHtmlTagAttributes.fromMap({
        'crossOrigin': 'use-credentials',
        'referrerPolicy': 'no-referrer',
        'type': 'text/javascript',
      })!;
      expect(a.crossOrigin, CrossOrigin.USE_CREDENTIALS);
      expect(a.referrerPolicy, ReferrerPolicy.NO_REFERRER);
      expect(a.type, 'text/javascript');

      final back = ScriptHtmlTagAttributes.fromMap(a.toMap())!;
      expect(back.crossOrigin, CrossOrigin.USE_CREDENTIALS);
      expect(back.type, 'text/javascript');
    });

    test('callbacks require id (assert in debug)', () {
      expect(
        () => ScriptHtmlTagAttributes(onLoad: () {}),
        throwsA(isA<AssertionError>()),
      );
      // with id it is fine
      final a = ScriptHtmlTagAttributes(id: 'x', onLoad: () {});
      expect(a.onLoad, isNotNull);
    });
  });

  group('callback typedefs', () {
    test('JavaScriptHandlerCallback is a List<dynamic> -> dynamic fn', () {
      JavaScriptHandlerCallback cb = (arguments) => arguments.length;
      expect(cb(['a']), 1);
    });

    test('WebMessageCallback + OnPostMessageCallback are void fns', () {
      int calls = 0;
      WebMessageCallback wcb = (message) {
        calls++;
        expect(message, isNull);
      };
      wcb(null);
      expect(calls, 1);

      OnPostMessageCallback ocb =
          (message, sourceOrigin, isMainFrame, replyProxy) {};
      expect(ocb, isNotNull);
    });
  });
}
