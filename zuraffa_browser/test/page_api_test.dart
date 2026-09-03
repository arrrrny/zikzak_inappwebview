import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zuraffa_browser/zuraffa_browser.dart';

/// Page-level API surface, authenticated proxies, and the pure platform
/// mapping (spec 279: A5, A6, U26-U30).
class RecordingProxyApplier implements ProxyApplier {
  final applied = <ResolvedProxy?>[];

  @override
  Future<void> apply(ResolvedProxy? proxy) async {
    applied.add(proxy);
  }

  @override
  Future<void> dispose() async {}
}

class FakePageHost implements PageHost {
  final loadedUrls = <String>[];
  var closed = false;

  @override
  Future<void> loadUrl(WebUri uri) async {
    loadedUrls.add(uri.toString());
  }

  @override
  Future<void> close() async {
    closed = true;
  }
}

void main() {
  final globalProxy = ProxyConfig(
    host: 'global.example.com',
    port: 8080,
    type: ProxyType.http,
  );
  final workProxy = ProxyConfig(
    host: 'work.example.com',
    port: 3128,
    type: ProxyType.https,
  );
  final pageProxy = ProxyConfig(
    host: 'page.example.com',
    port: 9090,
    type: ProxyType.socks5,
  );

  Future<Browser> openBrowser({
    ProxyConfigStore? store,
    SecretVault? vault,
    RecordingProxyApplier? applier,
  }) => Browser.open(
    store: store ?? InMemoryProxyConfigStore(),
    vault: vault ?? InMemorySecretVault(),
    applier: applier ?? RecordingProxyApplier(),
    pageHostFactory: (_) => FakePageHost(),
  );

  group('page-level override (AC6/FR-006)', () {
    test('page.setProxy sets the one-off override; '
        'effective beats profile and global (U26)', () async {
      final browser = await openBrowser();
      await browser.setProxy(globalProxy);
      final work = browser.createProfile('work');
      await work.setProxy(workProxy);
      final page = work.openPage();

      expect(page.proxyOverride, isNull);
      await page.setProxy(pageProxy);
      expect(page.proxyOverride, equals(pageProxy));
      expect(
        page.effectiveProxy,
        equals(pageProxy),
        reason: 'the page override wins over profile and global',
      );
    });

    test(
      'effective resolution is page ?? profile.effective ?? global (U26)',
      () async {
        final browser = await openBrowser();
        await browser.setProxy(globalProxy);
        final work = browser.createProfile('work');
        await work.setProxy(workProxy);
        final pageInWork = work.openPage();
        final personal = browser.createProfile('personal');
        final pageInPersonal = personal.openPage();

        expect(
          pageInWork.effectiveProxy,
          equals(workProxy),
          reason: 'no page override: the profile proxy applies',
        );
        expect(
          pageInPersonal.effectiveProxy,
          equals(globalProxy),
          reason: 'no page override, no profile proxy: global applies',
        );
      },
    );

    test('page.clearProxy falls back to profile/global (U27)', () async {
      final browser = await openBrowser();
      await browser.setProxy(globalProxy);
      final work = browser.createProfile('work');
      await work.setProxy(workProxy);
      final page = work.openPage();

      await page.setProxy(pageProxy);
      await page.clearProxy();
      expect(page.proxyOverride, isNull);
      expect(
        page.effectiveProxy,
        equals(workProxy),
        reason: 'cleared page override falls back to the profile proxy',
      );
    });

    test(
      'browser-level set/clear/get works page-independently (U28)',
      () async {
        final browser = await openBrowser();
        final work = browser.createProfile('work');
        final page = work.openPage();

        await browser.setProxy(globalProxy);
        expect(browser.proxy, equals(globalProxy));
        expect(browser.profile('work')!.effectiveProxy, equals(globalProxy));
        await browser.clearProxy();
        expect(browser.proxy, isNull);
        expect(page.effectiveProxy, isNull);
      },
    );
  });

  group('authenticated proxies (AC5/FR-009)', () {
    test(
      'global auth proxy: password goes to the vault, the store record '
      'carries a secretRef only, the applier receives the password (U29)',
      () async {
        final store = InMemoryProxyConfigStore();
        final vault = InMemorySecretVault();
        final applier = RecordingProxyApplier();
        final browser = await openBrowser(
          store: store,
          vault: vault,
          applier: applier,
        );

        await browser.setProxy(
          ProxyConfig(
            host: 'gate.example.com',
            port: 3128,
            type: ProxyType.http,
            username: 'alice',
            password: 's3cret!',
          ),
        );

        expect(await vault.read('proxy/global/password'), 's3cret!');
        final record = await store.loadGlobal();
        expect(record!.secretRef, 'proxy/global/password');
        expect(
          record.toJson().toString().contains('s3cret!'),
          isFalse,
          reason: 'the persisted record must not contain the password',
        );
        expect(
          applier.applied.single!.password,
          's3cret!',
          reason: 'the applier must receive the resolved password',
        );
      },
    );

    test('profile auth proxy: password goes to the vault under the profile '
        'key (U29)', () async {
      final store = InMemoryProxyConfigStore();
      final vault = InMemorySecretVault();
      final browser = await openBrowser(store: store, vault: vault);
      final work = browser.createProfile('work');

      await work.setProxy(
        ProxyConfig(
          host: 'gate.example.com',
          port: 3128,
          type: ProxyType.https,
          username: 'bob',
          password: 'hunter2',
        ),
      );

      expect(await vault.read('proxy/profile/work/password'), 'hunter2');
      final record = await store.loadProfile('work');
      expect(record!.secretRef, 'proxy/profile/work/password');
      expect(record.username, 'bob');
    });

    test('restart re-resolves the password from the vault (U29)', () async {
      final store = InMemoryProxyConfigStore();
      final vault = InMemorySecretVault();
      final browser1 = await openBrowser(store: store, vault: vault);
      await browser1.setProxy(
        ProxyConfig(
          host: 'gate.example.com',
          port: 3128,
          type: ProxyType.http,
          username: 'alice',
          password: 's3cret!',
        ),
      );

      final browser2 = await openBrowser(store: store, vault: vault);
      expect(browser2.proxy, isNotNull);
      expect(browser2.proxy!.username, 'alice');
      expect(
        browser2.proxy!.password,
        's3cret!',
        reason:
            'the restored proxy re-resolves its password from the '
            'vault',
      );
    });
  });

  group('platform mapping (FR-012)', () {
    test('proxySettingsFromConfig maps http/https/socks5 to Android rules '
        'and iOS proxyUrl (U30)', () {
      final http = proxySettingsFromConfig(
        ProxyConfig(host: 'p.example.com', port: 8080, type: ProxyType.http),
      );
      expect(
        http.androidProxySettings!.proxyRules.single.url,
        WebUri('http://p.example.com:8080'),
      );
      expect(
        http.androidProxySettings!.proxyRules.single.schemeFilter,
        ProxySchemeFilter.MATCH_HTTP,
      );
      expect(http.iOSProxySettings!.proxyUrl, 'http://p.example.com:8080');

      final https = proxySettingsFromConfig(
        ProxyConfig(host: 'p.example.com', port: 8443, type: ProxyType.https),
      );
      expect(
        https.androidProxySettings!.proxyRules.single.schemeFilter,
        ProxySchemeFilter.MATCH_HTTPS,
      );
      expect(https.iOSProxySettings!.proxyUrl, 'https://p.example.com:8443');

      final socks5 = proxySettingsFromConfig(
        ProxyConfig(host: 'p.example.com', port: 1080, type: ProxyType.socks5),
      );
      expect(
        socks5.androidProxySettings!.proxyRules.single.url,
        WebUri('socks5://p.example.com:1080'),
      );
      expect(
        socks5.androidProxySettings!.proxyRules.single.schemeFilter,
        isNull,
        reason:
            'the scheme filter enum has no SOCKS entry; the scheme is '
            'carried by the rule URL',
      );
      expect(socks5.iOSProxySettings!.proxyUrl, 'socks5://p.example.com:1080');
    });

    test(
      'authenticated mapping embeds credentials into the proxy URLs (U30)',
      () {
        final settings = proxySettingsFromConfig(
          ProxyConfig(
            host: 'gate.example.com',
            port: 3128,
            type: ProxyType.http,
            username: 'alice',
          ),
          password: 's3cret!',
        );
        expect(
          settings.androidProxySettings!.proxyRules.single.url,
          WebUri('http://alice:s3cret!@gate.example.com:3128'),
        );
        expect(
          settings.iOSProxySettings!.proxyUrl,
          'http://alice:s3cret!@gate.example.com:3128',
        );
      },
    );
  });
}
