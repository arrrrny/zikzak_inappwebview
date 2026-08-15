// Public-API regression tests for the fetch_request model family, migrated
// from @ExchangeableObject/@ExchangeableEnum codegen to Zorphy entities
// (see PROGRESS.md, Phase 2b).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (incl. the fork's `action` default)
//   - JSON wire format (map keys; WebUri as toString; FetchRequestAction as
//     its index; ReferrerPolicy as its native string; polymorphic
//     credentials dispatched on the wire `type` key)
//   - null/missing-key tolerance of fromJson
//   - the hand-written credential hierarchy (public API + is-a preserved)
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('FetchRequest', () {
    test('default constructor keeps the fork defaults', () {
      final r = FetchRequest();
      expect(r.action, FetchRequestAction.PROCEED);
      expect(r.url, isNull);
      expect(r.method, isNull);
      expect(r.headers, isNull);
      expect(r.body, isNull);
      expect(r.mode, isNull);
      expect(r.credentials, isNull);
      expect(r.cache, isNull);
      expect(r.redirect, isNull);
      expect(r.referrer, isNull);
      expect(r.referrerPolicy, isNull);
      expect(r.integrity, isNull);
      expect(r.keepalive, isNull);
    });

    test('toJson emits the fork wire format', () {
      final r = FetchRequest(
        url: WebUri('https://flutter.dev/api'),
        method: 'GET',
        headers: {'x-a': 'b'},
        body: 'payload',
        mode: 'cors',
        credentials: FetchRequestCredentialDefault(value: 'v', type: 'default'),
        cache: 'no-store',
        redirect: 'follow',
        referrer: 'client',
        referrerPolicy: ReferrerPolicy.NO_REFERRER,
        integrity: 'sha256-x',
        keepalive: true,
        action: FetchRequestAction.ABORT,
      );
      final map = r.toJson();
      expect(map['url'], 'https://flutter.dev/api');
      expect(map['method'], 'GET');
      expect(map['headers'], {'x-a': 'b'});
      expect(map['body'], 'payload');
      expect(map['mode'], 'cors');
      expect(map['credentials'], {'type': 'default', 'value': 'v'});
      expect(map['cache'], 'no-store');
      expect(map['redirect'], 'follow');
      expect(map['referrer'], 'client');
      expect(map['referrerPolicy'], 'no-referrer');
      expect(map['integrity'], 'sha256-x');
      expect(map['keepalive'], true);
      expect(map['action'], 0);
    });

    test('fromJson is null/missing-key tolerant (same as old fromMap)', () {
      final r = FetchRequest.fromJson({});
      expect(r.action, FetchRequestAction.PROCEED);
      expect(r.url, isNull);
      expect(r.credentials, isNull);
      expect(r.referrerPolicy, isNull);
      expect(r.headers, isNull);
      expect(r.keepalive, isNull);
    });

    test('fromJson(toJson) round-trips (WebUri + referrerPolicy + action)', () {
      final r = FetchRequest(
        url: WebUri('https://flutter.dev'),
        referrerPolicy: ReferrerPolicy.STRICT_ORIGIN,
        action: FetchRequestAction.PROCEED,
        keepalive: true,
        headers: {'a': '1'},
      );
      final back = FetchRequest.fromJson(r.toJson());
      expect(back.url?.toString(), 'https://flutter.dev');
      expect(back.referrerPolicy, ReferrerPolicy.STRICT_ORIGIN);
      expect(back.action, FetchRequestAction.PROCEED);
      expect(back.keepalive, true);
      expect(back.headers, {'a': '1'});
    });

    test('polymorphic credentials round-trip (wire type dispatch)', () {
      final r = FetchRequest(
        credentials: FetchRequestFederatedCredential(
          id: 'id1',
          name: 'name',
          protocol: 'oidc',
          provider: 'provider',
          iconURL: WebUri('https://flutter.dev/icon.png'),
          type: 'federated',
        ),
      );
      final back = FetchRequest.fromJson(r.toJson());
      expect(back.credentials, isA<FetchRequestFederatedCredential>());
      final fed = back.credentials! as FetchRequestFederatedCredential;
      expect(fed.id, 'id1');
      expect(fed.name, 'name');
      expect(fed.protocol, 'oidc');
      expect(fed.provider, 'provider');
      expect(fed.iconURL?.toString(), 'https://flutter.dev/icon.png');
      expect(fed.type, 'federated');

      final pw = FetchRequest.fromJson({
        'credentials': {'type': 'password', 'password': 'pw'},
      });
      expect(pw.credentials, isA<FetchRequestPasswordCredential>());
      expect((pw.credentials! as FetchRequestPasswordCredential).password, 'pw');

      expect(
        FetchRequest.fromJson({
          'credentials': {'type': 'unknown-type'},
        }).credentials,
        isNull,
      );
    });

    test('int enums keep the old native values (index == old _nativeValue)', () {
      expect(FetchRequestAction.ABORT.index, 0);
      expect(FetchRequestAction.PROCEED.index, 1);
    });

    test('copyWith is available (zorphy addition)', () {
      final r = FetchRequest(method: 'GET');
      expect(r.copyWith(method: 'POST').method, 'POST');
      expect(r.copyWith().method, 'GET');
    });
  });

  group('FetchRequestCredential hierarchy (hand-written, skip/hierarchy)', () {
    test('public API + is-a + wire semantics preserved', () {
      final base = FetchRequestCredential(type: 'default');
      expect(base.toMap(), {'type': 'default'});
      expect(base.toJson(), {'type': 'default'});
      expect(
        FetchRequestCredential.fromMap({'type': 'x'})?.type,
        'x',
      );
      expect(FetchRequestCredential.fromMap(null), isNull);

      final def = FetchRequestCredentialDefault(value: 'v', type: 'default');
      expect(def, isA<FetchRequestCredential>());
      expect(def.toMap(), {'type': 'default', 'value': 'v'});
      expect(
        FetchRequestCredentialDefault.fromMap({'type': 'd', 'value': 'w'})
            ?.value,
        'w',
      );

      final fed = FetchRequestFederatedCredential(
        id: 'i',
        name: 'n',
        protocol: 'p',
        provider: 'pr',
        iconURL: WebUri('https://flutter.dev/i.png'),
        type: 'federated',
      );
      expect(fed, isA<FetchRequestCredential>());
      expect(fed.toMap(), {
        'type': 'federated',
        'iconURL': 'https://flutter.dev/i.png',
        'id': 'i',
        'name': 'n',
        'protocol': 'p',
        'provider': 'pr',
      });

      final pw = FetchRequestPasswordCredential(
        id: 'i',
        name: 'n',
        password: 'pw',
        iconURL: WebUri('https://flutter.dev/i.png'),
        type: 'password',
      );
      expect(pw, isA<FetchRequestCredential>());
      expect(pw.toMap(), {
        'type': 'password',
        'iconURL': 'https://flutter.dev/i.png',
        'id': 'i',
        'name': 'n',
        'password': 'pw',
      });
    });
  });
}
