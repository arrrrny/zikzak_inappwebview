# Cycle Log — 339-macos-useondownloadstart-is-dead

Append-only. One entry per cycle. Evidence over intention: entries marked
`NOT_EXECUTED` were not run, and the reason is recorded. Nothing in this file
claims a pass that was not observed on this machine.

---

## C1 — RED: parity source contract fails against master @ 9e710171 (EXECUTED)

- **Date**: 2026-09-27
- **Environment**: Linux x86_64 (Debian 13). Flutter 3.47.5 / Dart 3.13.4
  (Linux host). Swift 6.1.2 (Linux tarball, `swiftc` with a `libncursesw`
  shim). **No macOS SDK, no Xcode, no WebKit, no FlutterMacOS.**
- **Tree**: test-first commit `fbc30418` (test + bug records only, no fix —
  verified via a throwaway `git worktree` checked out at that commit so the
  fix sources could not leak into the run).

### C1a — static reproduction (EXECUTED)

Re-running the issue's own evidence commands against the clone:

```bash
rg -n "useOnDownloadStart" zikzak_inappwebview_macos/
```

Observed (real): only the declaration
(`InAppWebViewSettings.swift:9`) and the Dart-side headless inference
(`headless_in_app_webview.dart:335-336`) — no Swift reader.

```bash
rg -n "WKDownload|WKDownloadDelegate|DownloadStartRequest|shouldPerformDownload|downloadDelegate" \
    zikzak_inappwebview_macos/macos/
```

Observed (real): **zero matches** (rg exit 1) — no download plumbing of any
kind in the macOS Swift sources, exactly as issue #339 states.

### C1b — red test (EXECUTED, the observable failing case)

```bash
git worktree add /tmp/redtree fbc30418
cd /tmp/redtree/zikzak_inappwebview_macos
flutter pub get
flutter test test/download_start_request_parity_test.dart
```

Observed (real): **exit 1, `00:04 +0 -7: Some tests failed.`** — all 7
criteria fail, each for the exact gap the issue documents:

- AC1 — `Types/DownloadStartRequest.swift` does not exist (AC1 expects the
  iOS-parity type with its 7 payload keys).
- AC2 — `public class InAppWebView: ...` does not adopt `WKDownloadDelegate`.
- AC3 — `decidePolicyFor navigationResponse` contains no `useOnDownloadStart`
  read, no `canShowMIMEType` check, no `decisionHandler(.download)` path.
- AC4 — no `download(_:decideDestinationUsing:...)` and no
  `webView(_:navigationResponse:didBecome:)` implementations.
- AC5 — `WebViewChannelDelegate` has no
  `public func onDownloadStartRequest(request: DownloadStartRequest)` bridge.
- AC6 — the `shouldOverrideUrlLoading` handler's Int branch still carries the
  `case 0, 2:` block mapping DOWNLOAD to `.cancel`; observed failure output
  shows the actual handler body ending in `policy = .cancel` and
  `resolvePolicy(policy)` with "does not contain 'policy = .download'".
- AC7 — `MacOSInAppWebViewController.handleMethod` has no
  `case 'onDownloadStartRequest':` (the event would hit `default:` →
  `throw UnimplementedError`).

RED recorded: exit 1, 0 passed / 7 failed, failure reasons match the issue's
stated root cause (missing native download chain + missing Dart routing).

---

## C2 — GREEN: minimal iOS-parity port makes the contract pass (EXECUTED)

- **Fix applied** (working tree, later committed on top of `fbc30418`):
  - NEW `zikzak_inappwebview_macos/macos/.../Types/DownloadStartRequest.swift`
    (port of the iOS type; `import Foundation` instead of `import UIKit`).
  - `InAppWebView.swift`: class adopts `WKDownloadDelegate`;
    `decidePolicyFor navigationResponse` gains the `useOnDownloadStart`-gated
    download detection (`!canShowMIMEType` → `.download`, main-frame/non-text
    mime fallback → dispatch + `.cancel`, single `decisionHandler` per path);
    adds the two `WKDownloadDelegate` methods (destination callback dispatches
    the event and cancels with `completionHandler(nil)`;
    `didBecome` dispatches the event); `shouldOverrideUrlLoading` maps policy
    `2` to `.download` in both the `Int` and `NSNumber` branches.
  - `WebViewChannelDelegate.swift`: adds
    `public func onDownloadStartRequest(request: DownloadStartRequest)`
    bridging `invokeMethod("onDownloadStartRequest", arguments: request.toMap())`.
  - `lib/src/in_app_webview/in_app_webview_controller.dart`: adds
    `case 'onDownloadStartRequest':` decoding `DownloadStartRequest.fromJson`
    and invoking `params.webviewParams!.onDownloadStartRequest!`.

```bash
cd zikzak_inappwebview_macos
flutter test test/download_start_request_parity_test.dart
```

Observed (real): **exit 0, `00:04 +7: All tests passed!`** — 7/7.

### C2b — neighbour gates (EXECUTED)

```bash
flutter test          # full macOS package suite
flutter analyze       # macOS package
dart format lib/src/in_app_webview/in_app_webview_controller.dart \
             test/download_start_request_parity_test.dart
git diff --check
```

Observed (real):

- `flutter test`: `00:11 +58: All tests passed!` — 58 passed / 0 failed
  (pre-fix baseline: the pre-existing 48-test suite was green per
  AGENTS.md's 2026-09-11 measurement, re-confirmed green before the change).
- `flutter analyze`: `No issues found! (ran in 9.4s)` — identical to the
  pre-fix baseline (clean).
- `dart format` on the changed Dart files: `0 changed`.
- `git diff --check`: exit 0 (no whitespace errors).

Note: `swift_sourceframe_kvc_test.dart` is NOT dart-format-clean on master
(observed: `dart format .` wants to reflow it). This is pre-existing drift in
a file this fix does not touch; the reformat was deliberately reverted to keep
the diff minimal.

### C2c — umbrella package gates (EXECUTED, secondary neighbour)

```bash
cd zikzak_inappwebview
flutter analyze && flutter test
```

Observed (real): analyze — 23 findings, all infos, **zero warnings/errors**
(matches the master baseline recorded in AGENTS.md); test — `00:25 +250: All
tests passed!` (matches the 250-pass baseline). The umbrella does not consume
macOS-package source; recorded as an isolation signal, not a claim of coverage.

### C2d — Swift parse gate (EXECUTED)

```bash
swiftc -parse InAppWebView.swift           # exit 0
swiftc -parse WebViewChannelDelegate.swift # exit 0
swiftc -parse Types/DownloadStartRequest.swift # exit 0
```

Observed (real): PARSE OK ×3 (Swift 6.1.2, Linux). Syntax-only: `-parse` does
not resolve `import WebKit` / `import FlutterMacOS`, which are unavailable on
Linux. Type-checking the real files is impossible on this host.

### C2e — mutation checks (deliberate mutants; EXECUTED)

No mutation tool for Swift/Dart in the profile, so deliberate mutants were
applied one at a time to the changed files, each restored exactly afterwards
(restoration verified by the final clean-tree green run):

| Mutant | Change | Observed | Caught by |
| --- | --- | --- | --- |
| M1 | remove `, WKDownloadDelegate` from the `InAppWebView` class declaration | `+6 -1: Some tests failed` — AC2 [E] | AC2 |
| M2 | downgrade the Int branch `case 2:` to `policy = .cancel` (the old bug) | first run **SURVIVED** (`+7: All tests passed!`) — the bare `contains('policy = .download')` was satisfied by the NSNumber branch alone; AC6 was strengthened to pin BOTH branches (Int sub-block + NSNumber sub-block), test-first commit amended; re-run: `+6 -1: Some tests failed` — AC6 [E] | AC6 (strengthened) |
| M3 | `decisionHandler(.download)` → `.allow` in `decidePolicyFor navigationResponse` | `+6 -1: Some tests failed` | AC3 |
| M4 | rename Dart `case 'onDownloadStartRequest':` → `...X` (event falls into `default:`) | `+6 -1: Some tests failed` | AC7 |

After all restorations: parity test 7/7 green, full suite 58/58 green,
analyze clean — the tree was verified clean after the mutation session.

---

## C3 — end-to-end macOS runtime reproduction: NOT_EXECUTED (environment)

- **Attempted** (exact command for a macOS host):

  ```bash
  cd zikzak_inappwebview/example && flutter run -d macos
  # InAppWebView(
  #   initialUrlRequest: URLRequest(url: WebUri(server.serveAttachment())), // Content-Disposition: attachment
  #   onDownloadStartRequest: (controller, request) => print("DOWNLOAD: ${request.url}"),
  #   initialSettings: InAppWebViewSettings(useOnDownloadStart: true),
  # )
  ```

- **Output on this host**: `flutter build macos` / `-d macos` do not exist off
  macOS (the subcommand is not registered on Linux — observed in the #312
  investigation on the same host class: `Could not find a subcommand named
  "macos" for "flutter build".`), and the repo's own AGENTS.md records that
  macOS desktop integration tests fail in this environment even on macOS
  hosts (`controller.loadData(...)` never completes). The click-level red
  (callback never fires pre-fix) and green (callback fires post-fix) are
  therefore NOT PROVED here; they are covered by CI/macOS-landed verification
  and by the downstream consumer's offer to test the fix
  (issue #339, zuraffa_browser#214).
