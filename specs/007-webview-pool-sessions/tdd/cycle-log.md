# Cycle Log: WebViewPool — Mission-Scoped Sessions, Domain Affinity, and Memory-Pressure Disposal

Append only. Newest last.

## Baseline

- suite (default stack `zikzak_inappwebview_platform_interface`): `flutter test` -> 300 passed, 0 failed, green
- suite (umbrella `zikzak_inappwebview` and `zikzak_inappwebview_module`): blocked — corrupted `zuraffa` package in pub cache (`.../zuraffa-6.0.0/lib/src/extensions/` missing). Fix: `flutter pub cache repair`.
- commit: `f349d421`
- recorded: cycle 0, before any change

<!-- No cycles recorded yet. Behaviors are listed in tdd/test-list.md and are all PENDING. -->

## Cycle 1 — outer batch 1 (A1–A5, A7, A8, A13, A14, A16–A18 + edges) — RED

- recorded: 2026-10-27, HEAD at this commit
- command: `cd zikzak_inappwebview_module && flutter test --concurrency=2 test/webview_pool_test.dart`
- result: **1 passed, 13 failed (red)**
- red reason (identical for every behavior that reaches `acquire`):

  ```
  Failed assertion: line 135 pos 7: 'InAppWebViewPlatform.instance != null': A platform
  implementation for `zikzak_inappwebview` has not been set.
    package:zikzak_inappwebview_platform_interface/.../platform_headless_in_app_webview.dart 135:7
    package:zikzak_inappwebview/.../headless_in_app_webview.dart 366:33   new HeadlessInAppWebView
    package:zikzak_inappwebview_module/src/services/webview_pool.dart 238:21  WebViewPool._createSession
    package:zikzak_inappwebview_module/src/services/webview_pool.dart 127:25  WebViewPool.acquire
  ```

  `WebViewPool._createSession` hard-constructs a real `HeadlessInAppWebView` with no
  injectable creation seam, so the pool's public API cannot be driven in a plain-Dart
  harness with fakes — the pre-zuraffa#389 pull-forward path recorded in the issue's
  2026-09-25 status comment ("plain Dart ports + fakes").
- green in this run: "release of an unknown / never-acquired sessionId is a safe no-op"
  (pure no-op guard; no acquire path involved).
- cap behaviors (SC-005) are intentionally not in this cycle's file: they reference the
  `WebViewPoolExhaustedException` type the fix introduces; their red is recorded in
  cycle 2 once the seam lets them reach the cap logic.

## Cycle 2 — GREEN (seam) + RED (caps, re-scope introspection)

- recorded: 2026-10-27
- change: `WebViewPool` gains an optional `HeadlessWebViewInstanceFactory`
  (constructor param); the default factory preserves the previous creation
  behavior (about:blank + `run()`) but now applies the caller's
  `InAppWebViewSettings` to the issued instance (FR-008). Tests inject a
  plain-Dart fake factory (`_Recorder` + `_FakeHeadlessWebView`), unblocking
  the pool for fake-driven testing (the pre-zuraffa#389 pull-forward path).
- command: `cd zikzak_inappwebview_module && flutter test --concurrency=2 test/webview_pool_test.dart`
- result: **13 passed, 4 failed**
- green: A1, A2, A3, A4, A5, A7, A13, A14, A16, A17, A18, both edges —
  the cycle-1 red reason is gone (creation seam injectable).
- red (behavioral, right reason):
  - A8: `Expected: 'example.com' / Actual: <null>` — a reused idle
    `PoolSession` keeps its stale domain association, so `sessions()` cannot
    report the current eTLD+1 (FR-006) for re-scoped instances.
  - cap (nothing evictable): acquire past `maxLiveInstances` succeeded and
    emitted a `PoolSession` instead of throwing — SC-005 violated
    (`WebViewPoolExhaustedException` never thrown; the type exists but no
    code throws it yet).
  - cap (evict oldest idle): pool created a 3rd instance (liveCount 3 > cap 2)
    instead of evicting the idle one.
  - cap (per-domain): pool created a 3rd `example.com` instance with
    `maxPerDomain: 2` — FR-003 per-domain cap is not enforced at all.
