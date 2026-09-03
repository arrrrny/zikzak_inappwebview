import 'package:flutter_test/flutter_test.dart';
import 'package:zuraffa_browser/zuraffa_browser.dart';

/// Per-profile proxy behavior (spec 279: A2, A3, A8, A4-profile-level,
/// U20-U25).
class RecordingProxyApplier implements ProxyApplier {
  final applied = <ResolvedProxy?>[];

  @override
  Future<void> apply(ResolvedProxy? proxy) async {
    applied.add(proxy);
  }

  @override
  Future<void> dispose() async {}
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

  group('per-profile proxy (AC2/FR-003)', () {
    test('profile.setProxy sets the explicit proxy; getter returns it (U20)',
        () async {
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: RecordingProxyApplier(),
      );
      final work = browser.createProfile('work');
      expect(work.proxy, isNull);
      await work.setProxy(workProxy);
      expect(work.proxy, equals(workProxy));
    });

    test('profile proxy overrides global for that profile only (A2/U21)',
        () async {
      final applier = RecordingProxyApplier();
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: applier,
      );
      await browser.setProxy(globalProxy);
      final work = browser.createProfile('work');
      final personal = browser.createProfile('personal');
      await work.setProxy(workProxy);

      expect(work.effectiveProxy, equals(workProxy),
          reason: 'per-profile proxy must override the global proxy');
      expect(personal.effectiveProxy, equals(globalProxy),
          reason: 'other profiles must keep the global proxy');
      expect(browser.proxy, equals(globalProxy),
          reason: 'the global proxy itself is unchanged');
    });
  });

  group('fallback on remove (AC3/FR-004)', () {
    test('profile.clearProxy falls back to the global proxy (U22)', () async {
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: RecordingProxyApplier(),
      );
      await browser.setProxy(globalProxy);
      final work = browser.createProfile('work');
      await work.setProxy(workProxy);
      await work.clearProxy();
      expect(work.proxy, isNull);
      expect(work.effectiveProxy, equals(globalProxy),
          reason: 'removing the per-profile proxy falls back to global');
    });

    test('profile.clearProxy with no global falls back to direct (U22)',
        () async {
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: RecordingProxyApplier(),
      );
      final work = browser.createProfile('work');
      await work.setProxy(workProxy);
      await work.clearProxy();
      expect(work.effectiveProxy, isNull,
          reason: 'no global set: removing the profile proxy is a direct '
              'connection');
    });
  });

  group('inheritance (AC8/FR-011)', () {
    test('profiles created without a proxy inherit the global proxy (U25)',
        () async {
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: RecordingProxyApplier(),
      );
      await browser.setProxy(globalProxy);
      final fresh = browser.createProfile('fresh');
      expect(fresh.proxy, isNull,
          reason: 'no explicit per-profile proxy');
      expect(fresh.effectiveProxy, equals(globalProxy),
          reason: 'existing profiles without explicit proxy inherit global');
    });

    test('a profile created before the global was set inherits it too (U25)',
        () async {
      final browser = await Browser.open(
        store: InMemoryProxyConfigStore(),
        vault: InMemorySecretVault(),
        applier: RecordingProxyApplier(),
      );
      final early = browser.createProfile('early');
      expect(early.effectiveProxy, isNull);
      await browser.setProxy(globalProxy);
      expect(early.effectiveProxy, equals(globalProxy));
    });
  });

  group('per-profile persistence (AC4/FR-005)', () {
    test('per-profile records are keyed by profileId, no cross leak (U23)',
        () async {
      final store = InMemoryProxyConfigStore();
      final browser = await Browser.open(
        store: store,
        vault: InMemorySecretVault(),
        applier: RecordingProxyApplier(),
      );
      final work = browser.createProfile('work');
      final personal = browser.createProfile('personal');
      await work.setProxy(workProxy);

      expect(await store.loadProfile('work'), isNotNull);
      expect(await store.loadProfile('personal'), isNull);
      expect(personal.proxy, isNull);
    });

    test('Browser.open restores per-profile records with the profile (U24)',
        () async {
      final applier1 = RecordingProxyApplier();
      final store = InMemoryProxyConfigStore();
      final vault = InMemorySecretVault();
      final browser1 = await Browser.open(
        store: store,
        vault: vault,
        applier: applier1,
      );
      browser1.createProfile('work');
      browser1.createProfile('personal');
      await browser1.profile('work')!.setProxy(workProxy);

      // Simulate an app restart over the same store + vault.
      final browser2 = await Browser.open(
        store: store,
        vault: vault,
        applier: RecordingProxyApplier(),
      );
      expect(browser2.profile('work'), isNotNull,
          reason: 'profiles with stored proxy records are restored');
      expect(browser2.profile('work')!.proxy, equals(workProxy),
          reason: 'the per-profile proxy must persist across restarts');
      final personal = browser2.profile('personal');
      expect(personal?.effectiveProxy, isNull,
          reason: 'profiles without a stored record stay on direct/global');
    });
  });
}
