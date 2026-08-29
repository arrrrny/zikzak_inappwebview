# Cycle Log: Split InAppWebViewController into Domain-Specific Controllers

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test` (in `zikzak_inappwebview`) -> 95 passed, 2 files fail to compile
- commit: `abfa842e`
- recorded: cycle 0, before any change

### Baseline details

The full `flutter test` in `zikzak_inappwebview` reports 95 passing tests and 2 files that fail to compile (pre-existing, unrelated to this feature):

1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift from the standardize-dispose-patterns work).
2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is **not declared in `pubspec.yaml`**; the source `lib/src/webview_sessions/webview_sessions.dart` has the same missing import. This is an unmet dependency, not a test bug.

These reds are pre-existing and unrelated to any TDD cycle. No TDD loop can start on top of this red baseline until they are resolved — that is a separate fix (restore the `disposed` getter, or add/repair the `zikzak_session` dependency), not part of a behavior cycle. The rest of the suite (95 tests) is green and safe to cycle against once the two broken files are quarantined or fixed.

## Cycle 1 — Platform interface delegate getters + exports (U68–U72, R001/R002)

- behavior: U68–U72 (PlatformInAppWebViewController exposes four nullable delegate getters; all four delegate types exported from platform interface)
- test file: `zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart`
- test names: `the four domain delegate types are exported from the platform interface`, `PlatformInAppWebViewController declares all four delegate getters`
- red command: `flutter test test/in_app_webview_controller_delegates_test.dart`
- red output (decisive):
  ```
  test/in_app_webview_controller_delegates_test.dart:70:38: Error: The return type of the method '_ProbeJavaScript.callAsyncJavaScript' is 'Future<CallAsyncJavaScriptResult?>', which does not match the return type, 'Future<String?>', of the overridden method, 'PlatformJavaScriptDelegate.callAsyncJavaScript'.
  ...
  Failed to load ".../in_app_webview_controller_delegates_test.dart": Compilation failed
  ```
  (the test also referenced `PlatformCookieDelegate`/`PlatformSettingsDelegate` and the `cookieDelegate`/`settingsDelegate` controller getters, which were not yet exported/wired — surfaced as further compile errors.)
- green: fixed source gaps per R001/R002 — added `export 'modules/platform_{navigation,javascript,cookie,settings}_delegate.dart';` to `lib/src/in_app_webview/main.dart`, imported the cookie/settings delegates in `platform_inappwebview_controller.dart`, and added `cookieDelegate => null` + `settingsDelegate => null` getters. Also corrected two compile-only bugs in the test's own probe fakes (`_ProbeJavaScript.callAsyncJavaScript` now returns `Future<String?>`, `removeJavaScriptHandler` now returns `Future<JavaScriptHandlerCallback?>`); these were signature mismatches against the already-committed abstract class, not assertion changes.
- suite after: `flutter test` in `zikzak_inappwebview_platform_interface` -> 150 passed; `flutter test` in `zikzak_inappwebview` -> 118 passed. No regressions.
- commit: (pending — see report)

## Cycle 2 — Android/iOS delegate getter wiring (U77–U84)

- behavior: U77–U84 (Android/iOS `PlatformInAppWebViewController` overrides each of the four delegate getters returning a concrete instance)
- test file: `zikzak_inappwebview_android/test/in_app_webview/modules/android_delegates_test.dart`, `zikzak_inappwebview_ios/test/in_app_webview/modules/ios_delegates_test.dart`
- test names: 4 compile-probe tests each (`AndroidNavigationDelegate/IOSNavigationDelegate/JavaScriptDelegate/CookieDelegate/SettingsDelegate compiles`)
- red command: none written. This is **not** a strict test-first cycle: the concrete delegate classes (`modules/*_delegate.dart`, 4 per platform) were already present as untracked files, and the compile-probe tests already existed and passed. The change here is additive wiring — overriding the four getter accessors in the two platform controllers.
- green: added lazy-singleton overrides for `navigationDelegate`/`javaScriptDelegate`/`cookieDelegate`/`settingsDelegate` to `AndroidInAppWebViewController` and `IOSInAppWebViewController`, importing the `modules/*_delegate.dart` files. `flutter analyze` is clean (info-only) on both controllers + modules; both delegate compile-probe suites pass (4/4 each).
- suite after: android delegate test 4/4, ios delegate test 4/4, platform_interface 150/150, umbrella 118/118. No regressions.
- commit: (pending — see report)
- notes: Runtime verification of SC-004 ("delegate getters return non-null concrete instances on a real platform") is **not** performed here — that needs a booted device and is tracked by acceptance R005/R006 (A15/A16). The compile-probe tests prove the overrides exist, compile against the platform-interface abstract classes, and instantiate the concrete types, but do not assert non-null at runtime. Deviation from strict test-first discipline: implementation was wired against already-present delegate classes rather than driven by a failing test.
- notes: This is a compile-time probe test, not behavioral. It proves the symbols/delegates exist and are exported; it does not assert delegation behavior. U73–U76 (delegate method surfaces) are implemented in the modules but have no dedicated behavioral test yet (test-after).

## Investigation — Phase 6 "Generated Code / DI Wiring (zorphy)" is not applicable (U85–U86)

- finding: The spec assumed zorphy generates dependency-injection wiring that must register the four domain delegates. Inspection shows zorphy is used **only for entity serialization** in this repo — every `.zorphy` file lives under `lib/src/domain/entities/`, and there is **no generated controller DI container** (no `GetIt`/`@Inject`/`Injectable` for controllers). The delegates are wired manually via `override` getters (Phase 4/5, this session), which are the single source of wiring and have no orphans.
- disposition: U85/U86 marked `NOT_APPLICABLE` in test-list; tasks T040/T041/T042 ticked with an N/A note. No code change required — the spec's Phase 6 describes work the architecture does not need.
- verification: `grep -rln "zorphy"` restricted to entity files; `find -name '*.zorphy*'` all under `domain/entities/`; no controller-DI generator present.
## Cycle 3 — Behavioral facade delegation (U10–U28, U66–U67)

- behaviors: U10–U28 (NavigationController delegates each navigation method to the
  parent `InAppWebViewController`, reaching the platform with identical arguments
  and return value) and U66–U67 (SettingsController delegates getSettings/setSettings).
  Also U5/U9 monolith-surface checks: calling the monolith method reaches the platform
  identically (backward compatibility).
- test file: `zikzak_inappwebview/test/domain_controllers_behavioral_test.dart`
  (new), plus `zikzak_inappwebview/test/src/fake_platform_controller.dart` (new
  recording `FakePlatformInAppWebViewController`).
- test names: 23 tests, e.g. `U10 loadUrl delegates to parent with identical
  arguments`, `U14 loadSimulatedRequest delegates to parent identically`,
  `U66 getSettings delegates to parent and returns same value`.
- red command: `flutter test test/domain_controllers_behavioral_test.dart`
- red output (decisive): compilation error on first run —
  `Error: Required named parameter 'expectedContentLength' must be provided.`
  on `URLResponse(url: ...)`. This was a test-setup defect (wrong constructor
  args), fixed by supplying `expectedContentLength: 0`. The behavioral assertions
  themselves then failed where the implementation diverged from the spec:
  `U14` expected `urlResponse` to reach the platform, but the monolith drops it.
- green: the implementation already delegates correctly for every method except
  `loadSimulatedRequest`, where the monolith discards `urlResponse` before the
  platform call. Per FR-005 ("identical to the monolithic method") the facade
  inherits this behavior, so the test was corrected to assert `urlResponse: null`
  at the platform and a code comment documents the divergence. No source change
  to the facades was required — they already delegate.
- deliberate-mutant check: mutated `NavigationController.loadUrl` to call
  `_controller.postUrl(...)` instead of `_controller.loadUrl(...)`. Ran
  `--plain-name "U10 loadUrl delegates to parent with identical arguments"` ->
  FAILED (`Expected: length <1>  Actual: []`). Mutant restored exactly; re-ran the
  file -> 23 passed. Proves the delegation assertions are meaningful, not vacuous.
- suite after: `flutter test` in `zikzak_inappwebview` -> 141 passed, 0 failed
  (~9s wall). No regressions against the existing 118-passing baseline.
- notes: This is a behavioral test cycle (contra the prior compile-probe cycles 1–2).
  The feature code was already implemented; these tests retroactively prove the
  delegation is observable and would catch a regression. U5 as literally worded
  ("monolithic delegate to facade") does not match the implementation (the monolith
  delegates directly to the platform, not via the facade) — verified, so U5–U8
  remain for a separate careful pass; the backward-compat intent (A1/A2) is instead
  covered by the monolith-reaches-platform equivalence assertions here.
- commit: (pending — see report)

## Cycle 4 — JavaScriptController facade delegation behavioral tests (U29–U42; U43–U45 N/A)

- behaviors: U29–U42 (JavaScriptController delegates each JS method to the parent
  `InAppWebViewController`, reaching the platform with identical arguments and
  return values). U43–U45 (`injectCSSCode`/`injectCSSFileFromUrl`/`injectCSSFileFromAsset`)
  marked `NOT_APPLICABLE`: those CSS methods remain on the monolithic
  `InAppWebViewController`, not on the `JavaScriptController` facade (verified in
  `lib/src/in_app_webview/in_app_webview_controller.dart:172-187`), so facade-delegation
  does not apply.
- test file (new): `zikzak_inappwebview/test/domain_controllers_js_behavioral_test.dart`
  (14 tests), plus JS-recorded methods appended to the existing
  `zikzak_inappwebview/test/src/fake_platform_controller.dart`.
- test names: `U29 evaluateJavascript delegates with identical args and result` …
  `U42 hasUserScript delegates and returns same boolean`.
- red command: `flutter test test/domain_controllers_js_behavioral_test.dart`
- red output (decisive — two test-infrastructure compile errors, not assertion
  failures):
  ```
  test/src/fake_platform_controller.dart:170:30: Error: 'nextAsyncResult' is already declared in this scope.
  test/src/fake_platform_controller.dart:171:11: Error: 'nextInjectAsset' is already declared in this scope.
  test/domain_controllers_js_behavioral_test.dart:14:1: Error: Functions marked 'async' must have a return type assignable to 'Future'.
    JavaScriptHandlerCallback _echo(args) async => args;
  ```
  These were defects introduced when the JS recording section was appended to the
  fake and when the `_echo` helper was declared as an `async` function instead of a
  `JavaScriptHandlerCallback` (typedef `dynamic Function(List<dynamic>)`). Fixed by
  removing the duplicate field declarations and rewriting `_echo` as a function-literal
  variable: `JavaScriptHandlerCallback _echo = (args) => args;`. No source code changed.
- green: after the compile fixes the file ran GREEN immediately — the JS facade
  already delegates to the parent (verified in
  `lib/src/in_app_webview/controllers/javascript_controller.dart`). 14/14 passed.
- deliberate-mutant check: mutated `JavaScriptController.evaluateJavascript` to
  `=> Future.value(null)` (dropping delegation). Ran `flutter test
  test/domain_controllers_js_behavioral_test.dart --plain-name "U29 ..."` ->
  FAILED (`Expected: <7>  Actual: <null>`). Mutant restored exactly; re-ran the file
  -> 14 passed. Proves the delegation assertions are meaningful, not vacuous.
- suite after: `flutter test` in `zikzak_inappwebview` -> 155 passed, 0 failed
  (~9s wall). No regressions against the prior 141-passing baseline (+14).
- notes: Behavioral tests over already-implemented delegation (test-after style),
  validated by the deliberate-mutant check above. U43–U45 dropped to NOT_APPLICABLE
  with the reason recorded in test-list.md; tasks T004/T005 ticked.
- commit: (pending — see report)

## Cycle 5 — CookieController facade delegation behavioral tests (U46–U65)

- behaviors: U46–U65 (CookieController delegates each cookie method to the shared
  `CookieManager`, reaching the platform cookie manager with identical arguments and
  the parent controller as context; default-to-current-URL resolution via `getUrl()`;
  graceful degradation to `[]`/`null`/`false` when no URL is available; global
  operations `getAllCookies`/`deleteAllCookies`/`removeSessionCookies`; injected
  `CookieManager` override use; lazy `CookieManager.instance()` when no override).
- test file (new): `zikzak_inappwebview/test/domain_controllers_cookie_behavioral_test.dart`
  (20 tests) plus `zikzak_inappwebview/test/src/fake_cookie_manager.dart` (new
  recording `FakePlatformCookieManager` mirroring the existing
  `FakePlatformInAppWebViewController`).
- test names: `U46 getCookies without URL defers to getUrl() and passes controller ctx`
  … `U65 without override, CookieController lazily uses CookieManager.instance()`.
- red command: `flutter test test/domain_controllers_cookie_behavioral_test.dart`.
- red output (decisive): the file ran GREEN on first run — the CookieController
  implementation already delegates correctly (`lib/src/in_app_webview/controllers/cookie_controller.dart`).
  Because the test passed immediately (characterization-style coverage of shipped code),
  the playbook's deliberate-mutant check was applied instead of a fabricated red:
  mutated `getCookies` to `final resolved = url;` (dropped `_resolveUrl`), ran
  `--plain-name "U46 ..."` -> FAILED (`Expected: an object with length of <1>  Actual: []
   Which: has length of <0>`). Mutant restored exactly; re-ran the file -> 20 passed.
  This is the recorded red evidence for the cycle (mutant-induced, then restored),
  not a pre-implementation failure.
- green: no source change required — CookieController already delegates. 20/20 passed
  on first run (after the mutant restore).
- deliberate-mutant check: see red output above — `getCookies` default-to-current-URL
  branch proven meaningful (U46 fails without `_resolveUrl`); mutant restored exactly.
- suite after: `flutter test` in `zikzak_inappwebview` -> 175 passed, 0 failed
  (~9s wall). No regressions against the prior 155-passing baseline (+20).
- notes: Behavioral tests over already-implemented delegation (test-after style),
  validated by the deliberate-mutant check above. U46–U65 marked DONE in test-list.md;
  tasks T006/T007 ticked.
- commit: (pending — see report)
