import 'package:flutter_test/flutter_test.dart';
import 'package:zuraffa_browser/zuraffa_browser.dart';

/// Global proxy API behavior (spec 279: A1 partial, A4 global, U17-U19b).
///
/// The [RecordingProxyApplier] captures what the browser pushes to the
/// platform proxy infrastructure; a `null` element means "clear override →
/// direct connection" (FR-010).
class RecordingProxyApplier implements ProxyApplier {
  final applied = <ResolvedProxy?>[];
  var disposed = false;

  @override
  Future<void> apply(ResolvedProxy? proxy) async {
    applied.add(proxy);
  }

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}

void main() {
  final globalProxy = ProxyConfig(
    host: 'global.example.com',
    port: 8080,
    type: ProxyType.http,
  );

  group('global proxy (AC1/FR-001)', () {
    test('setProxy stores the config and the getter returns it (U17)',
        () async {
      final applier = RecordingProxyApplier();
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: applier,
      );
      expect(browser.proxy, isNull);
      await browser.setProxy(globalProxy);
      expect(browser.proxy, equals(globalProxy));
    });

    test('global setProxy applies the new config through the applier (U19b)',
        () async {
      final applier = RecordingProxyApplier();
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: applier,
      );
      await browser.setProxy(globalProxy);
      expect(applier.applied, hasLength(1));
      expect(applier.applied.single, isNotNull);
      expect(applier.applied.single!.config, equals(globalProxy));
      expect(applier.applied.single!.scope, ResolvedScope.global);
    });

    test(
        'clearProxy nulls the getter, removes the stored record, '
        'and clears through the applier (U18)', () async {
      final applier = RecordingProxyApplier();
      final store = InMemoryProxyConfigStore();
      final browser = await Browser.open(
        store: store,
        vault: InMemorySecretVault(),
        applier: applier,
      );
      await browser.setProxy(globalProxy);
      await browser.clearProxy();
      expect(browser.proxy, isNull);
      expect(await store.loadGlobal(), isNull);
      expect(applier.applied.last, isNull,
          reason: 'clearProxy must push "clear override" (direct connection)');
    });
  });

  group('restart survival (AC4/FR-002)', () {
    test('Browser.open over the same store restores the global proxy (U19)',
        () async {
      final applier1 = RecordingProxyApplier();
      final store = InMemoryProxyConfigStore();
      final browser1 = await Browser.open(
        store: store,
        vault: InMemorySecretVault(),
        applier: applier1,
      );
      await browser1.setProxy(globalProxy);

      // Simulate an app restart: a brand-new Browser over the same store.
      final applier2 = RecordingProxyApplier();
      final browser2 = await Browser.open(
        store: store,
        vault: InMemorySecretVault(),
        applier: applier2,
      );
      expect(browser2.proxy, equals(globalProxy),
          reason: 'the global proxy must persist across restarts (FR-002)');
    });
  });
}
