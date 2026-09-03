# Cycle Log: Per-profile and global proxy support (zuraffa_browser)

Append only. Newest last. Every entry's `red` block is the evidence that the
test existed and failed before the implementation.

## Baseline

- suite: `flutter test` in `zikzak_inappwebview` -> **+240 -2** (240 passed)
- suite: `flutter test` in `zikzak_inappwebview_platform_interface` -> **+305 -1** (305 passed)
- suite: `flutter test` in `zikzak_inappwebview_module` -> **+0 -1** (compile load error)
- commit: `a841cee2`
- recorded: cycle 0, before any feature change

### Red baseline details

The three baseline reds predate this feature and touch files this feature
never modifies:

1. `zikzak_inappwebview/test/domain_controllers_behavioral_test.dart` —
   "NavigationController delegates to parent (U10-U28) U14 loadSimulatedRequest
   delegates to parent identically" (pre-existing).
2. `zikzak_inappwebview/test/in_app_webview_dispose_test.dart` —
   "InAppWebViewController / InAppWebView dispose forwarding (spec 013) U9: a
   later dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards
   false and fully releases" (pre-existing).
3. `zikzak_inappwebview_platform_interface/test/types/final_gap_entities_test.dart`
   — "PDFConfiguration wire: rect as nested map" (pre-existing).
4. `zikzak_inappwebview_module` — compile load error in the pub-cache copy of
   hosted `zuraffa 6.0.0` (`src/extensions/future_extensions.dart` missing from
   the downloaded archive). Third-party cache corruption; the module package is
   not part of this feature's verify scope (umbrella + platform_interface are).

The loop for this feature runs inside the new `zuraffa_browser` package only,
whose own suite starts empty (trivially green). Target for this feature:
**NO NEW failures** in umbrella/platform_interface vs the counts above.

## Cycle T001 — Global proxy API (red → green)

### Red

- command: `flutter test test/global_proxy_test.dart` and
  `flutter test test/proxy_config_test.dart` (cwd `zuraffa_browser`)
- commit-under-red: tests committed before any implementation exists.
- observed output (excerpt):

```text
test/global_proxy_test.dart:9:40: Error: Type 'ProxyApplier' not found.
test/global_proxy_test.dart:10:20: Error: 'ResolvedProxy' isn't a type.
test/global_proxy_test.dart:25:23: Error: Method not found: 'ProxyConfig'.
test/global_proxy_test.dart:28:11: Error: Undefined name 'ProxyType'.
test/global_proxy_test.dart:35:29: Error: Undefined name 'Browser'.
test/global_proxy_test.dart:36:16: Error: Method not found: 'InMemoryProxyConfigStore'.
Compilation failed for testPath=.../test/global_proxy_test.dart
Compilation failed for testPath=.../test/proxy_config_test.dart
```

Both files fail to load: the whole API surface under test (ProxyType,
ProxyConfig, ProxyConfigRecord, stores, vault, ProxyApplier, ResolvedProxy,
Browser) does not exist yet.

### Green (T001)

- command: `flutter test` (cwd `zuraffa_browser`)
- observed output:

```text
00:00 +18: All tests passed!
```

- implementation: `lib/src/proxy_config.dart` (ProxyType, ProxyConfig,
  ProxyConfigRecord), `lib/src/proxy_ports.dart` (ProxyConfigStore +
  InMemory/File, SecretVault + InMemory, ResolvedScope/ResolvedProxy,
  ProxyApplier), `lib/src/browser.dart` (Browser.open/setProxy/clearProxy/
  proxy with store+vault persistence and immediate applier push).
- test adjustment during green (behavior unchanged): `ProxyConfig` validates
  in its constructor (ArgumentError), which is incompatible with a const
  constructor, so the test construction sites were changed from `const` to
  `final`; the validated behavior (U8 throwsArgumentError) is identical.
- A1 stays RED at this point: "applied to all profiles" needs profiles and
  page navigation (cycles T002-T004).

## Cycle T002 — Per-profile proxy (red → green)

### Red

- command: `flutter test test/profile_proxy_test.dart` (cwd `zuraffa_browser`)
- observed output (excerpt):

```text
test/profile_proxy_test.dart:38:28: Error: The method 'createProfile' isn't defined for the type 'Browser'.
Compilation failed for testPath=.../test/profile_proxy_test.dart
```

The whole Profile layer (createProfile/profile/effectiveProxy, per-profile
store records) does not exist yet.

### Green (T002)

- command: `flutter test` (cwd `zuraffa_browser`)
- observed output:

```text
00:00 +26: All tests passed!
```

- implementation: `lib/src/profile.dart` (part of the browser library:
  Profile with setProxy/clearProxy/proxy/effectiveProxy, per-profile vault
  key `proxy/profile/<id>/password`), Browser.createProfile/profile/profiles,
  restore-on-open of per-profile records (FR-003/004/005/011).
- test adjustment during green (intent unchanged): the restart-restore test
  asserted `browser2.profile('personal')!.effectiveProxy` — a profile with
  no proxy record is not recreated by the proxy store on restart (the store
  only knows profiles that carry records; profile-entity persistence is not
  a proxy concern), so the line became null-aware (`personal?.effectiveProxy`).
  The asserted behavior — record-less profiles resolve to direct/global —
  is unchanged.
- note: `setProxy` at profile level deliberately does NOT call the applier
  (FR-007, covered by the T004 lifecycle cycle).

## Cycle T003 — Browser/Page programmatic API (red → green)

### Red

- command: `flutter test test/page_api_test.dart` (cwd `zuraffa_browser`)
- observed output (excerpt):

```text
test/page_api_test.dart:19:31: Error: Type 'PageHost' not found.
test/page_api_test.dart:100:25: Error: The method 'openPage' isn't defined for the type 'Profile'.
test/page_api_test.dart:207:20: Error: Method not found: 'proxySettingsFromConfig'.
Compilation failed for testPath=.../test/page_api_test.dart
```

The page layer (PageHost port, Profile.openPage, BrowserPage overrides) and
the pure platform mapping do not exist yet.

### Green (T003)

- command: `flutter test` (cwd `zuraffa_browser`)
- observed output:

```text
00:01 +35: All tests passed!
```

- implementation: `lib/src/page.dart` (BrowserPage override surface, part of
  the browser library), `lib/src/page_host.dart` (PageHost port +
  HeadlessPageHost bound to the profile persistentStoreIdentifier),
  Profile.openPage, PageHostFactory on Browser.open,
  `lib/src/platform_settings.dart` (pure proxySettingsFromConfig ->
  Android ProxyRule(schemeFilter) + IOSProxySettings.proxyUrl),
  ProxyConfig.toProxyUrl({password}) override.
- test adjustment during green (setup bug, assertion unchanged): the
  "effective resolution" test expected the profile proxy to apply but its
  setup never called `work.setProxy(workProxy)`; the setup now does. The
  asserted behavior (page ?? profile.effective ?? global) is unchanged.
- PlatformProxyApplier (the channel-backed applier over
  ProxyController.instance()) lands with the lifecycle cycle T004.

## Cycle T004 — Lifecycle (red → green)

### Red

- command: `flutter test test/lifecycle_test.dart` (cwd `zuraffa_browser`)
- observed output (excerpt):

```text
test/lifecycle_test.dart:77:18: Error: The method 'navigate' isn't defined for the type 'BrowserPage'.
Compilation failed for testPath=.../test/lifecycle_test.dart
```

navigate / Profile.dispose / Browser.dispose do not exist yet.
