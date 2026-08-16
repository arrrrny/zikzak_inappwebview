// Public-API regression tests for the user_script + meta_tag valueObjects
// (Zorphy entities). Pins the consumer-visible contract:
//   - constructor shapes + fork defaults (allowedOriginRules {'*'},
//     forMainFrameOnly true, contentWorld PAGE on missing)
//   - JSON wire format (sets as lists; contentWorld as {'name': ...};
//     injectionTime as index int; nested MetaTagAttribute maps)
//   - null/missing-key tolerance of fromJson (source required; injectionTime
//     requires an int)
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('UserScript', () {
    test('default constructor keeps the fork defaults', () {
      final s = UserScript(
        source: 'console.log(1)',
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      );
      expect(s.source, 'console.log(1)');
      expect(s.allowedOriginRules, {'*'});
      expect(s.forMainFrameOnly, true);
      expect(s.groupName, isNull);
      expect(s.injectionTime, UserScriptInjectionTime.AT_DOCUMENT_START);
      expect(s.contentWorld, isNull);
    });

    test('toJson emits the wire format', () {
      final s = UserScript(
        source: 'js',
        allowedOriginRules: {'https://a.dev', 'https://b.dev'},
        contentWorld: ContentWorld.world(name: 'custom'),
        forMainFrameOnly: false,
        groupName: 'g',
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      );
      final map = s.toJson();
      expect(map['source'], 'js');
      expect(map['allowedOriginRules'], ['https://a.dev', 'https://b.dev']);
      expect(map['contentWorld'], {'name': 'custom'});
      expect(map['forMainFrameOnly'], false);
      expect(map['groupName'], 'g');
      expect(map['injectionTime'], 1);
    });

    test('fromJson applies fork defaults on missing keys', () {
      final s = UserScript.fromJson({
        'source': 'x',
        'injectionTime': 0,
      });
      expect(s.source, 'x');
      expect(s.allowedOriginRules, {'*'});
      expect(s.forMainFrameOnly, true);
      expect(s.injectionTime, UserScriptInjectionTime.AT_DOCUMENT_START);
      expect(s.contentWorld, ContentWorld.PAGE); // default on missing
      expect(s.groupName, isNull);

      // source is required.
      expect(() => UserScript.fromJson({'injectionTime': 0}), throwsA(anything));
      // injectionTime requires an int.
      expect(
        () => UserScript.fromJson({'source': 'x', 'injectionTime': 'end'}),
        throwsA(anything),
      );
    });

    test('round-trip (custom content world + rules) + copyWith', () {
      final s = UserScript(
        source: 'js',
        allowedOriginRules: {'https://only.dev'},
        contentWorld: ContentWorld.world(name: 'mine'),
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      );
      final back = UserScript.fromJson(s.toJson());
      expect(back.allowedOriginRules, {'https://only.dev'});
      expect(back.contentWorld?.name, 'mine');
      expect(back.injectionTime, UserScriptInjectionTime.AT_DOCUMENT_END);
      expect(s.copyWith(groupName: 'g2').groupName, 'g2');
    });
  });

  group('UserScriptInjectionTime wire', () {
    test('serializes as index int', () {
      expect(UserScriptInjectionTime.AT_DOCUMENT_START.index, 0);
      expect(UserScriptInjectionTime.AT_DOCUMENT_END.index, 1);
    });
  });

  group('MetaTag', () {
    test('toJson nests MetaTagAttribute maps', () {
      final t = MetaTag(
        name: 'viewport',
        content: 'width=device-width',
        attrs: [
          MetaTagAttribute(name: 'data-x', value: '1'),
        ],
      );
      expect(t.toJson(), {
        'name': 'viewport',
        'content': 'width=device-width',
        'attrs': [
          {'name': 'data-x', 'value': '1'},
        ],
      });
    });

    test('fromJson is null/missing-key tolerant + round-trip', () {
      final t = MetaTag.fromJson({});
      expect(t.name, isNull);
      expect(t.content, isNull);
      expect(t.attrs, isNull);

      final full = MetaTag(
        name: 'n',
        content: 'c',
        attrs: [MetaTagAttribute(name: 'a', value: 'b')],
      );
      final back = MetaTag.fromJson(full.toJson());
      expect(back.name, 'n');
      expect(back.attrs, hasLength(1));
      expect(back.attrs!.first.name, 'a');
      expect(back.attrs!.first.value, 'b');
      expect(full.copyWith(content: 'c2').content, 'c2');
    });
  });
}
