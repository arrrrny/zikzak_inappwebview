import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zuraffa_browser/zuraffa_browser.dart';

/// Units for the proxy configuration value objects and the injectable
/// persistence/vault ports (spec 279: U1-U14).
void main() {
  group('ProxyConfig.toProxyUrl (U1-U3)', () {
    test('maps type http/https/socks5 to scheme://host:port (U1)', () {
      expect(
        ProxyConfig(
          host: 'proxy.example.com',
          port: 8080,
          type: ProxyType.http,
        ).toProxyUrl(),
        'http://proxy.example.com:8080',
      );
      expect(
        ProxyConfig(
          host: 'secure.example.com',
          port: 8443,
          type: ProxyType.https,
        ).toProxyUrl(),
        'https://secure.example.com:8443',
      );
      expect(
        ProxyConfig(host: 'socks.example.com', port: 1080, type: ProxyType.socks5)
            .toProxyUrl(),
        'socks5://socks.example.com:1080',
      );
    });

    test('embeds user:pass@ when credentials are present (U2)', () {
      expect(
        ProxyConfig(
          host: 'gate.example.com',
          port: 3128,
          type: ProxyType.http,
          username: 'alice',
          password: 's3cret!',
        ).toProxyUrl(),
        'http://alice:s3cret!@gate.example.com:3128',
      );
    });

    test('omits @ when no credentials are present (U3)', () {
      final url = ProxyConfig(
        host: 'plain.example.com',
        port: 80,
        type: ProxyType.https,
      ).toProxyUrl();
      expect(url.contains('@'), isFalse);
    });
  });

  group('ProxyConfig serialization and redaction (U4-U6)', () {
    test('toJson/fromJson round-trips host, port, type, username (U4)', () {
      final config = ProxyConfig(
        host: 'proxy.example.com',
        port: 9090,
        type: ProxyType.https,
        username: 'bob',
        password: 'hunter2',
      );
      final restored = ProxyConfig.fromJson(config.toJson());
      expect(restored.host, config.host);
      expect(restored.port, config.port);
      expect(restored.type, config.type);
      expect(restored.username, config.username);
    });

    test('toJson never contains the password (U5)', () {
      final config = ProxyConfig(
        host: 'proxy.example.com',
        port: 9090,
        type: ProxyType.http,
        username: 'bob',
        password: 'hunter2',
      );
      final json = config.toJson();
      expect(json.toString().contains('hunter2'), isFalse,
          reason: 'toJson must redact the transient password (FR-009)');
    });

    test('toString redacts the password (U6)', () {
      final config = ProxyConfig(
        host: 'proxy.example.com',
        port: 9090,
        type: ProxyType.http,
        username: 'bob',
        password: 'hunter2',
      );
      expect(config.toString().contains('hunter2'), isFalse,
          reason: 'toString must never leak credentials (FR-009)');
    });
  });

  group('ProxyConfig equality and validation (U7-U8)', () {
    test('equality on host/port/type; different port is not equal (U7)', () {
      final a = ProxyConfig(host: 'h', port: 1, type: ProxyType.http);
      final b = ProxyConfig(host: 'h', port: 1, type: ProxyType.http);
      final c = ProxyConfig(host: 'h', port: 2, type: ProxyType.http);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(c)));
    });

    test('invalid port (0, 65536) rejected; empty host rejected (U8)', () {
      expect(
        () => ProxyConfig(host: 'h', port: 0, type: ProxyType.http),
        throwsArgumentError,
      );
      expect(
        () => ProxyConfig(host: 'h', port: 65536, type: ProxyType.http),
        throwsArgumentError,
      );
      expect(
        () => ProxyConfig(host: '', port: 8080, type: ProxyType.http),
        throwsArgumentError,
      );
    });
  });

  group('ProxyConfigRecord (U9-U10)', () {
    test('round-trips through toJson/fromJson with secretRef (U9)', () {
      const record = ProxyConfigRecord(
        host: 'proxy.example.com',
        port: 8080,
        type: ProxyType.socks5,
        username: 'carol',
        secretRef: 'proxy/global/password',
      );
      final restored = ProxyConfigRecord.fromJson(record.toJson());
      expect(restored, equals(record));
      final config = restored.toConfig(password: 'pw');
      expect(config.password, 'pw');
      expect(config.username, 'carol');
    });

    test('ProxyType wire values are the lowercase scheme strings (U10)', () {
      expect(ProxyType.http.wire, 'http');
      expect(ProxyType.https.wire, 'https');
      expect(ProxyType.socks5.wire, 'socks5');
    });
  });

  group('InMemoryProxyConfigStore (U11-U12)', () {
    test('saves/loads/clears the global record (U11)', () async {
      final store = InMemoryProxyConfigStore();
      expect(await store.loadGlobal(), isNull);
      const record = ProxyConfigRecord(
        host: 'g',
        port: 1,
        type: ProxyType.http,
      );
      await store.saveGlobal(record);
      expect(await store.loadGlobal(), equals(record));
      await store.saveGlobal(null);
      expect(await store.loadGlobal(), isNull);
    });

    test('saves/loads/clears per-profile records (U12)', () async {
      final store = InMemoryProxyConfigStore();
      const recordA = ProxyConfigRecord(
        host: 'a',
        port: 1,
        type: ProxyType.http,
      );
      const recordB = ProxyConfigRecord(
        host: 'b',
        port: 2,
        type: ProxyType.https,
      );
      await store.saveProfile('a', recordA);
      await store.saveProfile('b', recordB);
      expect(await store.loadProfile('a'), equals(recordA));
      expect(await store.loadProfile('b'), equals(recordB));
      expect(await store.profileIds(), unorderedEquals(['a', 'b']));
      await store.saveProfile('a', null);
      expect(await store.loadProfile('a'), isNull);
      expect(await store.profileIds(), ['b']);
    });
  });

  group('FileProxyConfigStore (U13)', () {
    test('round-trips records through a JSON file (U13)', () async {
      final dir = await Directory.systemTemp.createTemp('zuraffa_proxy_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      final store = FileProxyConfigStore(
        file: File('${dir.path}/proxy_config.json'),
      );
      const global = ProxyConfigRecord(
        host: 'g',
        port: 1,
        type: ProxyType.https,
        username: 'u',
        secretRef: 'proxy/global/password',
      );
      const profile = ProxyConfigRecord(
        host: 'p',
        port: 2,
        type: ProxyType.socks5,
      );
      await store.saveGlobal(global);
      await store.saveProfile('work', profile);

      // A second store instance over the same file simulates a restart.
      final reopened = FileProxyConfigStore(
        file: File('${dir.path}/proxy_config.json'),
      );
      expect(await reopened.loadGlobal(), equals(global));
      expect(await reopened.loadProfile('work'), equals(profile));
    });
  });

  group('InMemorySecretVault (U14)', () {
    test('write/read/delete round-trip (U14)', () async {
      final vault = InMemorySecretVault();
      expect(await vault.read('k'), isNull);
      await vault.write('k', 'v1');
      expect(await vault.read('k'), 'v1');
      await vault.write('k', 'v2');
      expect(await vault.read('k'), 'v2');
      await vault.delete('k');
      expect(await vault.read('k'), isNull);
    });
  });
}
