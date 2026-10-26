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
