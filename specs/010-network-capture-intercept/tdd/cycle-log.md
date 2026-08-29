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