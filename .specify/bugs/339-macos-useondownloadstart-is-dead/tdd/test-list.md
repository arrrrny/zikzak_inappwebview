---
feature: 339-macos-useondownloadstart-is-dead
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 8
planned_at: 9e710171
updated_at: 9e710171
suite_baseline: green
---

# Test List — 339-macos-useondownloadstart-is-dead

Acceptance criteria (derived from issue #339 and the task's hard constraints):

- **AC1** — macOS ships `Types/DownloadStartRequest.swift` mapping the 7
  documented payload fields.
- **AC2** — macOS `InAppWebView` adopts `WKDownloadDelegate`; the destination
  callback dispatches the event and cancels the native download
  (`completionHandler(nil)`); `webView(_:navigationResponse:didBecome:)`
  dispatches the event.
- **AC3** — `decidePolicyFor navigationResponse` honors `useOnDownloadStart`:
  `!canShowMIMEType` → `.download`; main-frame/non-text-mime fallback dispatches
  the event and cancels; single `decisionHandler` call per path.
- **AC4** — `shouldOverrideUrlLoading` maps policy `2` (DOWNLOAD) to
  `.download` in both the `Int` and `NSNumber` branches; the old
  `case 0, 2: policy = .cancel` downgrade is gone.
- **AC5** — `WebViewChannelDelegate.onDownloadStartRequest(request:)` bridges
  `"onDownloadStartRequest"` with `request.toMap()`.
- **AC6** — The macOS Dart controller routes `'onDownloadStartRequest'` to the
  user callback via `DownloadStartRequest.fromJson`.
- **AC7** — Changes confined to `zikzak_inappwebview_macos/**` + bug records +
  `.specify/feature.json`; zero unrelated formatting churn.
- **AC8** — No regression: `flutter analyze` / `flutter test` in the macOS
  package match or beat the pre-fix baseline; new parity test green.

The failing behavior is "native Swift never dispatches the event". The
development environment is Linux (no macOS SDK, no WebKit, no FlutterMacOS), so
the executable red→green is the repo's established host-runnable
source-contract pattern (`swift_sourceframe_kvc_test.dart` bug #327,
`user_script_initializer_parity_test.dart` bug #317): the parity test
`test/download_start_request_parity_test.dart` asserts the presence and shape of
every link in the download chain and FAILS against `master` @ `9e710171`
(observed: 0 passed / 7 failed), then PASSES after the fix. The macOS runtime
gate (`flutter run -d macos` on the issue's repro with a
`Content-Disposition: attachment` server) is `MACOS-ONLY / NOT_EXECUTED` with
exact commands in the cycle log.

## Behaviors

| ID | Criterion | Behavior | Kind | Level | Test / Gate | Status |
| --- | --- | --- | --- | --- | --- | --- |
| B1 | AC1 | `Types/DownloadStartRequest.swift` exists in the macOS Swift sources with `class DownloadStartRequest: NSObject`, `toMap`, and the 7 payload keys | behavior | unit (source contract, host-runnable) | `flutter test test/download_start_request_parity_test.dart --plain-name AC1` (cycle-log C1/C2) | RUNNABLE / PROVEN |
| B2 | AC2 | `InAppWebView` class declaration adopts `WKDownloadDelegate` | behavior | unit (source contract) | AC2 in the same test file | RUNNABLE / PROVEN |
| B3 | AC2 | Destination callback dispatches `onDownloadStartRequest` and calls `completionHandler(nil)`; `didBecome` dispatches the event | behavior | unit (source contract) | AC4 in the same test file | RUNNABLE / PROVEN |
| B4 | AC3 | `decidePolicyFor navigationResponse` reads `useOnDownloadStart`, checks `canShowMIMEType`, resolves `.download`, dispatches via the fallback path | behavior | unit (source contract) | AC3 in the same test file | RUNNABLE / PROVEN |
| B5 | AC4 | Policy `2` resolves `.download` (Int + NSNumber branches); `case 0, 2:` → `.cancel` downgrade gone | behavior | unit (source contract, brace-matched handler block) | AC6 in the same test file | RUNNABLE / PROVEN |
| B6 | AC5 | `WebViewChannelDelegate.onDownloadStartRequest(request:)` bridges the channel event | behavior | unit (source contract) | AC5 in the same test file | RUNNABLE / PROVEN |
| B7 | AC6 | `MacOSInAppWebViewController.handleMethod` has `case 'onDownloadStartRequest':` decoding `DownloadStartRequest.fromJson` and invoking the user callback | behavior | unit (source contract + `flutter analyze`) | AC7 in the same test file | RUNNABLE / PROVEN |
| B8 | AC7 | Diff confined to `zikzak_inappwebview_macos/**` + `.specify/bugs/339-*/` + `.specify/feature.json`; zero whitespace/formatting diffs in changed files | gate | repo | `git status --porcelain`, `git diff --check`, `dart format` on changed files | RUNNABLE / PROVEN |
| B9 | AC8 | `flutter analyze` in `zikzak_inappwebview_macos`: no new findings vs baseline (baseline: clean, "No issues found!") | gate | package | baseline vs post-fix run | RUNNABLE / PROVEN |
| B10 | AC8 | `flutter test` in `zikzak_inappwebview_macos`: full suite green (pre-fix baseline 48 tests green per AGENTS.md 2026-09-11 + 7 new = expected all green) | gate | package | baseline vs post-fix run | RUNNABLE / PROVEN |
| B11 | AC2–AC6 | End-to-end: `Content-Disposition: attachment` click dispatches `onDownloadStartRequest` on a macOS host (issue repro sketch) | behavior | integration (macOS runtime) | macOS-only: `cd zikzak_inappwebview/example && flutter run -d macos` with the issue's repro snippet (cycle-log C3) | MACOS-ONLY / NOT_EXECUTED |
| B12 | AC2–AC4 | The edited Swift files are syntactically valid (parse gate; no type-check against WebKit/FlutterMacOS possible on Linux) | gate | file | `swiftc -parse` on the 3 touched Swift files (Swift 6.1.2 Linux tarball) | RUNNABLE / PROVEN (syntax-only) |
