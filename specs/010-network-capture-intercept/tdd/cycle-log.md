# Cycle Log: Network Capture — Mission-Grade Intercept

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test` -> 95 passed, 2 files fail to compile (pre-existing, unrelated)
- commit: abfa842e
- recorded: cycle 0, before any change
- note: The two failing files are:
  1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift from standardize-dispose-patterns work).
  2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is not declared in `pubspec.yaml`; the source `lib/src/webview_sessions/webview_sessions.dart` has the same missing import.
  These reds are pre-existing and unrelated to any TDD cycle. No TDD loop can start on top of this red baseline until they are resolved.

## Cycle 1: A13/A14 secret redaction at source (Authorization header + session Cookie)

- test: `test/network_capture_redaction_test.dart::redacts Authorization and session Cookie headers before any consumer (A13/A14)` (new)
- red: `cd zikzak_inappwebview && flutter test test/network_capture_redaction_test.dart --plain-name "redacts Authorization and session Cookie headers before any consumer (A13/A14)"`
  -> `Expected: '<redacted>'  Actual: 'Bearer s3cr3t-token-12345'` (1 failed)
- green: added `lib/src/in_app_webview/network_capture/secret_redactor.dart`
  (`redactRequest` / `redactResponse` replace the values of `authorization`,
  `proxy-authorization`, `cookie`, `set-cookie` headers with `kRedactionMarker`)
  and wired `redactRequest` / `redactResponse` / `redactBody` into
  `NetworkCaptureManager._onJavaScriptEvent` BEFORE the raw callbacks and the
  collector, so secrets are removed at the source (FR-007 / SC-004). Suite
  `flutter test` -> 185 passed, 0 failed (was 184).
- refactor: none needed; `_redactHeaders` helper shared by request and response.
- commit: 55e02139
- note: the Baseline red (2 compile failures) is resolved at this branch HEAD; the
  suite is green, so this cycle started on a green baseline. A15 (URL/body auth
  param redaction) is a separate, still-pending behavior covered by its own cycle.

## Cycle 2: A15 URL/body auth param redaction (api_key / password)

- test: `test/network_capture_redaction_test.dart::redacts auth-shaped URL query and body params before any consumer (A15)` (new)
- red: `cd zikzak_inappwebview && flutter test test/network_capture_redaction_test.dart --plain-name "redacts auth-shaped URL query and body params before any consumer (A15)"`
  -> `Expected: not contains 'AKIA-SECRET-12345'  Actual: 'https://api.example.com/login?api_key=AKIA-SECRET-12345&password=hunter2-pass&scope=read'`
- green: added `_redactedParamKeys` + `_isRedactableParam`, plus `_redactUrl` (rebuilds
  the `WebUri` with redacted query-param values via `Uri.replace`) and `_redactFormBody`
  (redacts `key=value` pairs for auth-shaped keys in `application/x-www-form-urlencoded`
  bodies); wired both into `redactRequest`. Suite `flutter test` -> 186 passed, 0 failed
  (was 185).
- refactor: none needed; `_isRedactableParam` shared by both helpers.
- note: a JSON-encoded request/response body is not yet redacted by this cycle (only
  URL query params + form-urlencoded bodies). The marker is percent-encoded in the raw
  URL string (`%3Credacted%3E`) but `Uri.parse(...).queryParameters` decodes it back to
  `<redacted>`, which is what every consumer reads, so the test asserts on the decoded
  query-param value.
- commit: 72d4896f

## Cycle 3: A10 per-domain maxEntries budget (FR-006 / US4-AC1)

- test: `zikzak_inappwebview_platform_interface/test/types/network_capture_controller_budget_test.dart::enforces per-domain maxEntries budget; other domains keep capturing (A10)` (new)
- red: `cd zikzak_inappwebview_platform_interface && flutter test test/types/network_capture_controller_budget_test.dart`
  -> `Expected: <15>  Actual: <55>` (1 failed) — no enforcement yet, so all 55 requests captured.
- green: in `NetworkCaptureController.trackRequest`, extract `request.url.host`, look up
  `domainBudgets[host]`, and when `maxEntries` is set drop further requests for that host
  once `_domainEntryCount[host]` reaches the cap (increment only on a kept entry); other
  domains keep capturing. `clear()` now also resets `_domainEntryCount`. Suite
  `flutter test` (platform_interface) -> 149 ran, 148 passed, 1 pre-existing compile
  failure in `test/in_app_webview_controller_delegates_test.dart` (unrelated:
  `_ProbeJavaScript.callAsyncJavaScript` return-type mismatch vs `PlatformJavaScriptDelegate`).
- refactor: none needed; budget lookup is a single self-contained guard.
- note: the budget `DomainBudget` type + `domainBudgets`/`_domainEntryCount` fields were
  added as a green seam before this cycle (kept minimal so the test compiles). The
  pre-existing delegates-test failure is out of 010's scope and is not fixed here.
- commit: ecb9807b

## Cycle 4: A11 per-domain maxBytes budget on response bodies (FR-006 / US4-AC2)

- test: `zikzak_inappwebview_platform_interface/test/types/network_capture_controller_budget_test.dart::enforces per-domain maxBytes budget on response bodies; others kept (A11)` (new)
- red: `cd zikzak_inappwebview_platform_interface && flutter test test/types/network_capture_controller_budget_test.dart --plain-name "enforces per-domain maxBytes budget on response bodies; others kept (A11)"`
  -> `Expected: <3>  Actual: <4>` (1 failed) — no body budget yet, so all 4 bodies retained.
- green: added `_domainByteCount` and enforced it in `attachBody`: for the body's host,
  when `maxBytes` is set, drop the body once `retained + body.body.length > maxBytes`
  (entry still tracked); reset the counter in `clear()`. Suite `flutter test`
  (platform_interface) -> 150 ran, 149 passed, 1 pre-existing delegates-test compile
  failure (unrelated, same as Cycle 3).
- refactor: none needed; the byte guard mirrors the entry guard from Cycle 3.
- note: A11 drops only the response body when the byte budget is exceeded (entries are
  still retained); this matches the `DomainBudget.maxBytes` doc ("total response-body
  bytes captured for the domain"). The pre-existing delegates-test failure is out of
  scope and not fixed here.
- commit: 31b72b72

## Cycle 5: A12 per-domain maxBodySize truncation (FR-006 / US4-AC3)

- test: `zikzak_inappwebview_platform_interface/test/types/network_capture_controller_budget_test.dart::enforces per-domain maxBodySize truncation; others kept whole (A12)` (new)
- red: `cd zikzak_inappwebview_platform_interface && flutter test test/types/network_capture_controller_budget_test.dart --plain-name "enforces per-domain maxBodySize truncation; others kept whole (A12)"`
  -> `Expected: <5>  Actual: <20>` (1 failed) — body not truncated yet.
- green: in `attachBody`, when the domain's `maxBodySize` is set and the body is
  longer, truncate `body.body` to that cap, set `truncated = true`, and recompute
  `size`; the byte budget (A11) then counts the truncated length. Other domains are
  unaffected. Suite `flutter test` (platform_interface) -> 151 ran, 150 passed, 1
  pre-existing delegates-test compile failure (unrelated, same as Cycle 3/4).
- refactor: none needed; the truncation guard sits alongside the byte guard.
- note: per-domain `maxBodySize` is a further cap below the global
  `networkCaptureMaxBodySize` (applied in JS before the body reaches Dart). The
  pre-existing delegates-test failure is out of 010's scope and is not fixed here.
- commit: 8d7a0a1d