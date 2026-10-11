# Cycle Log — 349-ios-contentblockers-silently-blocks-the-initial-navigation-blank-page-no-logs

Append-only. One entry per cycle. Evidence over intention: entries marked
`NOT_EXECUTED` were not run, and the reason is recorded. Nothing in this file
claims a pass that was not observed on this machine.

---

## C0 — Baselines (captured before any source change, clean tree at `db17a3d2`)

- **Date**: 2026-10-04
- **Environment**: Linux x86_64 (Debian 13 container). Flutter 3.47.5 /
  Dart 3.13.4 (Linux) — the same toolchain the 338 cycle used and the issue
  reporter ran. **No macOS SDK, no Xcode, no WebKit, no FlutteriOS, no Swift
  toolchain.**
- **Base commit**: `db17a3d2` (master), branch
  `fix/349-ios-contentblockers-silently-blocks-the-initial-navigation-b`.

### Pre-fix baselines

- `cd zikzak_inappwebview_ios && flutter analyze` → **192 issues** (all
  infos; exit 0 — the AGENTS.md-recorded tolerated state: "192 infos,
  0 warnings, 0 errors").
- `cd zikzak_inappwebview_ios && flutter test` → **13 passed / 0 failed**
  (`01:13 +13: All tests passed!` — AGENTS.md's table says 12; one test has
  landed on master since, both green).
- `cd zikzak_inappwebview_macos && flutter test` (neighbor package whose
  parity gate cross-checks the iOS sources) → **76 passed / 0 failed**;
  `flutter analyze` → **No issues found!**.

---

## C1 — RED: the eight behavior gates fail on the un-fixed native source

- **Date**: 2026-10-04
- **Gate** (new, runnable on any host):
  `zikzak_inappwebview_ios/test/content_blockers_initial_load_test.dart`
  (10 tests, B1–B10) reads the real native sources
  (`FlutterWebViewController.swift`, `InAppWebView.swift`,
  `InAppBrowserWebViewController.swift`, `Types/URLRequest.swift`,
  `InAppWebViewSettings.swift`) and enforces the #349 contract: initial load
  routed through `loadAfterContentRuleLists`, compilation through the
  `applyContentBlockers` funnel, no force unwrap, no fixed store identifier,
  token-guarded settle-on-any-outcome completion, URLRequest fallback log.

```bash
cd zikzak_inappwebview_ios && flutter test test/content_blockers_initial_load_test.dart
```

Observed (real, pre-fix):

```
00:34 +2 -8: Some tests failed.
Failing: B1, B3, B4, B5, B6, B7, B8, B9  (B2, B10 pass — preservation gates)
```

- **Failed for the right reason**: the iOS sources contain no
  `applyContentBlockers`/`loadAfterContentRuleLists` machinery, the fixed
  `"ContentBlockingRules"` identifier is present at three compile sites, the
  compile completions early-return past the initial load on error, and the
  URLRequest fallback is silent — the exact decoded-and-drop state issue #349
  reports.
- Two test defects were repaired BEFORE the red was recorded (assertion
  mechanism, not strength; no source change between runs): (1) B1–B3
  initially extracted `makeInitialLoad` from the wrong file variable — the
  function lives in `FlutterWebViewController.swift`, not `InAppWebView.swift`;
  (2) B2's literal `contains` tripped over the line-wrapped Swift call —
  replaced with a whitespace-tolerant regex, the exact pitfall the 338
  cycle-log documents. A defective earlier run was observed (`+1 -9`) and is
  superseded by the official red above from the corrected gate.

### Re-pro note (smallest possible case)

The issue's runtime repro (initial navigation never commits on an iOS
simulator) requires WKWebView + a simulator. The smallest runnable
reproduction of the *reported state* on a Linux host is the source-scan gate
above: it proves the iOS `makeInitialLoad` issues the initial navigation only
from inside the compile completion (with the error-path `return` and the
`contentRuleList!` force unwrap on the success path). The runtime observation
itself is B13 (SIMULATOR-ONLY / NOT_EXECUTED, C5).

---

## C2 — GREEN: all ten gates pass on the fixed source

- **Date**: 2026-10-04
- **Change** (the entire fix; commit `97caf324`):
  - `InAppWebView.swift` — adds the macOS #338 machinery one-to-one:
    `contentRuleListCompileToken`, `isCompilingContentRuleLists`,
    `pendingContentRuleListLoad`, `contentRuleListIdentifier(forRules:)`
    (SHA-256 hex of the serialized rules — CryptoKit is already imported in
    this file; package floor iOS 15.0 > CryptoKit's iOS 13.0),
    `applyContentBlockers(_:)` (removeAll → serialize → compile under the
    content-derived identifier → main-thread completion: token guard, flag
    reset, guarded add, pending-load fire on BOTH outcomes),
    `loadAfterContentRuleLists(_:)`; `setSettings` delegates the
    contentBlockers key to the funnel (its inline copy carried the same
    force-unwrap and fixed-identifier hazards).
  - `FlutterWebViewController.swift` — `makeInitialLoad` routes the
    contentBlockers branch through `applyContentBlockers` +
    `loadAfterContentRuleLists` (initial load fires when the compilation
    settles, success OR error); the no-blockers path keeps
    `removeAllContentRuleLists()` + the direct load.
  - `InAppBrowserWebViewController.swift` — `viewDidLoad`'s identical inline
    compile block funnels the same way (`initLoad()` on settle).
  - `Types/URLRequest.swift` — the `about:blank` fallback logs the rejected
    url (the issue's diagnosability ask).
  - `zikzak_inappwebview_macos/test/content_blockers_parity_test.dart` —
    the #338 gate's iOS cross-check re-derived to the funnel shape it
    explicitly anticipates ("if iOS ever stops being the reference
    implementation, this gate must be re-derived"): iOS `setSettings` now
    delegates to `applyContentBlockers`, and the compile assertions moved to
    the iOS funnel body.

```bash
cd zikzak_inappwebview_ios && flutter test test/content_blockers_initial_load_test.dart
```

Observed (real, post-fix):

```
00:27 +10: All tests passed!
```

- Full package suites post-fix: iOS `flutter test` → **23 passed / 0 failed**
  (13 baseline + 10 new); iOS `flutter analyze` → **192 issues, exit 0**
  (identical tolerated-infos state to C0); macOS `flutter test` → **76
  passed / 0 failed**; macOS `flutter analyze` → **No issues found!**
- One test mechanism repair during C2 (assertion target, not strength): B4's
  in-body `contains('SHA256')` → `contains('contentRuleListIdentifier(forRules:')`
  — the SHA-256 call lives in the identifier helper; B6 still guards the
  derivation itself. One Swift formatting repair: the guarded `add` call put
  on one line mirroring the macOS source verbatim (the line-wrapped form
  broke the flattened-text literal the way 338's log warns).

---

## C3 — Mutants (deliberate, one at a time; restore exact after each)

No mutation tool in the profile (`mutation: null`). Two deliberate mutants on
the changed file, sampled on the two mutation-relevant behaviors:

| Mutant | Change | Observed | Judgment |
| --- | --- | --- | --- |
| M1 | Reintroduce the #349 error-path drop: `return` after `print(error.localizedDescription)` inside the completion | B5 red (`the compile completion must NOT early-return on error before firing the pending load`) | CAUGHT |
| M2 | Reintroduce the force unwrap: `add(contentRuleList!)` | B4 red (`must be added through an optional bind, never a force unwrap`) | CAUGHT |

After each mutant: file restored from a pre-mutation copy (`diff -q`-verified
byte-identical), full iOS suite re-run green after the final restore
(`01:28 +23: All tests passed!`).

---

## C4 — Neighbour + regression gates (post-fix)

- `cd zikzak_inappwebview_ios && flutter test` → **23 passed / 0 failed**.
- `cd zikzak_inappwebview_macos && flutter test` → **76 passed / 0 failed**
  (the macOS parity gate re-derived and green against the new iOS shape).
- `cd zikzak_inappwebview_ios && flutter analyze` → **192 issues, exit 0**
  (identical set to pre-fix baseline; 0 warnings).
- `cd zikzak_inappwebview_macos && flutter analyze` → **No issues found!**
- `git diff --check` → clean (zero whitespace errors).
- `dart format` on the new/changed test files → idempotent (0 changed after
  the initial formatting). Package-wide
  `dart format --output=none --set-exit-if-changed zikzak_inappwebview_ios/`
  → 4 files WOULD change, ALL pre-existing master drift
  (`in_app_webview_controller_test.dart`, `ios_package_platform_test.dart`,
  `swift_availability_usage_test.dart`, `swift_platform_view_clipping_test.dart`)
  — none touched by this fix (verified via `git status --porcelain` before
  formatting); reformatting them would violate the confinement constraint.
- Confinement: `git status --porcelain` between the red commit (`729a7735`)
  and the fix commit (`97caf324`) shows ONLY the four iOS Swift sources, the
  new iOS gate test, and the macOS parity gate — no pubspec.lock side
  effects, no other platform touched.
- Umbrella and other platform packages: not exercised — this fix touches no
  Dart runtime code and no other platform's sources; the only cross-package
  coupling (the macOS parity gate reading iOS sources as text) is re-run
  green above.

---

## C5 — macOS/Simulator-only gates (NOT_EXECUTED on this host, with exact commands)

The development host is Linux (no macOS SDK, no Xcode, no WebKit, no
FlutteriOS, no Swift toolchain). These gates are the final proof and must run
on a macOS host/CI:

- **B12** `cd zikzak_inappwebview/example && flutter build ios --release
  --no-codesign` — compiles the changed Swift. The inserted code is a
  structural mirror of the macOS #338 machinery that compiles against the
  same WebKit APIs; `WKContentRuleListStore`,
  `compileContentRuleList(forIdentifier:encodedContentRuleList:)`,
  `removeAllContentRuleLists()`, `WKContentRuleList` are macOS 10.13-era /
  iOS 11-era APIs (the branch stays inside the pre-existing
  `#available(iOS 11.0, *)` scope), and CryptoKit's `SHA256` is iOS 13+,
  below the package's iOS 15.0 floor. Residual compile risk: low, but
  NOT_EXECUTED here and not claimed — the CI `build-ios` job
  (`macos-14` + `macos-15`) compiles the iOS Swift sources on every PR.
- **B13** runtime observation — run the example app on an iOS simulator with
  `InAppWebViewSettings(contentBlockers: [{"trigger": {"url-filter":
  ".*\\.doubleclick\\.net.*", "load-type": ["third-party"]}, "action":
  {"type": "block"}}])` and an `initialUrlRequest`; `onLoadStart`/
  `onLoadStop` must fire and the page must render (it currently stays blank
  with no callbacks). NOT_EXECUTED.
