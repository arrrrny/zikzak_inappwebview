import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zuraffa_browser/zuraffa_browser.dart';

/// Lifecycle behavior: next-navigation effect, idempotence, direct default,
/// disposal (spec 279: A1, A7, U31-U36).
///
/// The applier and the page host share one ordered event log so tests can
/// assert that the proxy is applied BEFORE the URL loads.
class RecordingProxyApplier implements ProxyApplier {
  final List<String> events;
  final applied = <ResolvedProxy?>[];
  var disposed = false;

  RecordingProxyApplier(this.events);

  @override
  Future<void> apply(ResolvedProxy? proxy) async {
    applied.add(proxy);
    events.add('apply:${proxy == null ? 'direct' : proxy.config.host}');
  }

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

class FakePageHost implements PageHost {
  final List<String> events;
  var closed = false;

  FakePageHost(this.events);

  @override
  Future<void> loadUrl(WebUri uri) async {
    events.add('load:${uri.toString()}');
  }

  @override
  Future<void> close() async {
    closed = true;
    events.add('close');
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

  Future<(Browser, RecordingProxyApplier, List<String>)> makeBrowser() async {
    final events = <String>[];
    final applier = RecordingProxyApplier(events);
    final browser = await Browser.open(
      store: InMemoryProxyConfigStore(),
      vault: InMemorySecretVault(),
      applier: applier,
      pageHostFactory: (_) => FakePageHost(events),
    );
    return (browser, applier, events);
  }

  group('navigation applies the effective proxy (A1/FR-007)', () {
    test('navigate applies the proxy BEFORE loading the URL (U31)', () async {
      final (browser, applier, events) = await makeBrowser();
      await browser.setProxy(globalProxy);
      final page = browser.createProfile('work').openPage();

      await page.navigate(WebUri('https://example.com/'));

      expect(applier.applied.single!.config, equals(globalProxy));
      expect(events, [
        'apply:global.example.com',
        'load:https://example.com/',
      ], reason: 'the effective proxy must be applied before the load');
    });

    test(
      'each profile resolves its own effective proxy on navigation (A1)',
      () async {
        final (browser, applier, _) = await makeBrowser();
        await browser.setProxy(globalProxy);
        final work = browser.createProfile('work');
        await work.setProxy(workProxy);
        final personalPage = browser.createProfile('personal').openPage();
        final workPage = work.openPage();

        await personalPage.navigate(WebUri('https://example.com/'));
        await workPage.navigate(WebUri('https://example.org/'));

        expect(
          applier.applied.map((r) => r!.config),
          orderedEquals([globalProxy, workProxy]),
          reason:
              'the personal page uses the global proxy, the work page '
              'its own proxy',
        );
      },
    );
  });

  group('not retroactive (FR-007)', () {
    test('profile.setProxy does not touch the applier until the next '
        'navigate (U32)', () async {
      final (browser, applier, events) = await makeBrowser();
      final work = browser.createProfile('work');
      final page = work.openPage();
      await page.navigate(WebUri('https://example.com/'));
      events.clear();

      await work.setProxy(workProxy);

      expect(
        events,
        isEmpty,
        reason:
            'setting a proxy must not affect anything retroactively; '
            'it applies on the next navigation',
      );

      await page.navigate(WebUri('https://example.org/'));
      expect(events, ['apply:work.example.com', 'load:https://example.org/']);
    });

    test('unchanged effective config is not re-applied on later navigations '
        '(U33)', () async {
      final (browser, applier, events) = await makeBrowser();
      await browser.setProxy(globalProxy);
      final page = browser.createProfile('work').openPage();
      await page.navigate(WebUri('https://example.com/'));
      events.clear();

      await page.navigate(WebUri('https://example.org/'));

      expect(events, [
        'load:https://example.org/',
      ], reason: 'the process override already matches; no redundant apply');
      expect(applier.applied, hasLength(1));
    });
  });

  group('direct connection default (AC7/FR-010)', () {
    test(
      'no config anywhere: the first navigation applies clear (U34)',
      () async {
        final (browser, applier, _) = await makeBrowser();
        final page = browser.createProfile('work').openPage();

        await page.navigate(WebUri('https://example.com/'));

        expect(
          applier.applied.single,
          isNull,
          reason:
              'the first navigation must establish "direct connection" '
              'explicitly',
        );
        expect(page.effectiveProxy, isNull);
      },
    );
  });

  group('disposal (FR-008)', () {
    test('Profile.dispose closes its pages, drops the profile, and '
        're-applies the global fallback (U35)', () async {
      final (browser, applier, events) = await makeBrowser();
      await browser.setProxy(globalProxy);
      final work = browser.createProfile('work');
      await work.setProxy(workProxy);
      final page = work.openPage();
      await page.navigate(WebUri('https://example.com/'));
      events.clear();

      await work.dispose();

      expect(page.isDisposed, isTrue);
      expect(work.isDisposed, isTrue);
      expect(
        browser.profile('work'),
        isNull,
        reason: 'the disposed profile is no longer live',
      );
      expect(
        events.where((e) => e.startsWith('close')),
        isNotEmpty,
        reason: 'the profile pages are closed',
      );
      expect(
        applier.applied.last!.config,
        equals(globalProxy),
        reason:
            'the fallback (global proxy) is re-applied when the '
            "profile's own proxy is released",
      );
    });

    test('Profile.dispose with no global falls back to direct (U35)', () async {
      final (browser, applier, _) = await makeBrowser();
      final work = browser.createProfile('work');
      await work.setProxy(workProxy);
      final page = work.openPage();
      await page.navigate(WebUri('https://example.com/'));

      await work.dispose();

      expect(
        applier.applied.last,
        isNull,
        reason: 'no global proxy: the fallback is a direct connection',
      );
    });

    test('navigating a disposed page throws (U35)', () async {
      final (browser, _, _) = await makeBrowser();
      final page = browser.createProfile('work').openPage();
      await browser.profile('work')!.dispose();

      expect(
        () => page.navigate(WebUri('https://example.com/')),
        throwsStateError,
      );
    });

    test('Browser.dispose disposes the applier and rejects further API calls '
        '(U36)', () async {
      final (browser, applier, _) = await makeBrowser();
      final work = browser.createProfile('work');

      await browser.dispose();

      expect(applier.disposed, isTrue);
      expect(() => browser.setProxy(globalProxy), throwsStateError);
      expect(() => work.setProxy(workProxy), throwsStateError);
    });
  });
}
