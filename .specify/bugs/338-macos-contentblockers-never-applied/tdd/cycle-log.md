# Cycle Log — 338-macos-contentblockers-never-applied

Append-only. One entry per cycle. Evidence over intention: entries marked
`NOT_EXECUTED` were not run, and the reason is recorded. Nothing in this file
claims a pass that was not observed on this machine.

---

## C0 — Baselines (captured before any source change, clean tree at `9e710171`)

- **Date**: 2026-09-27
- **Environment**: Linux x86_64 (Debian 13 container). Flutter 3.47.5 /
  Dart 3.13.4 (Linux). **No macOS SDK, no Xcode, no WebKit, no FlutterMacOS,
  no Swift toolchain** (the Swift Linux tarball would exhaust this host's disk
  budget, so no `swiftc` parse gate this time — see C5).
- **Base commit**: `9e710171` (master), branch
  `fix/338-macos-inappwebviewsettings-contentblockers-is-decoded-but-ne`.

### Pre-fix baselines

- `cd zikzak_inappwebview_macos && flutter analyze` → **No issues found!**
  (0 findings).
- `cd zikzak_inappwebview_macos && flutter test` → **51 passed / 0 failed**
  (`00:07 +51: All tests passed!`).
- `cd zikzak_inappwebview && flutter analyze` (umbrella package) →
  **23 issues found** (pre-existing).
- `cd zikzak_inappwebview && flutter test` (umbrella package) →
  **250 passed / 0 failed** (`00:25 +250: All tests passed!`).
- `cd zikzak_inappwebview_macos && dart format --output=none --set-exit-if-changed .`
  → 1 file WOULD be reformatted on the clean tree:
  `test/swift_sourceframe_kvc_test.dart` — **pre-existing master drift**,
  untouched by this fix; excluded from the fix's format gate (reformatting it
  would violate the confinement constraint).

---

## C1 — RED: the five macOS behavior gates fail on the un-fixed native source

- **Date**: 2026-09-27
- **Gate** (new, runnable on any host): `zikzak_inappwebview_macos/test/content_blockers_parity_test.dart`
  (7 tests) reads the real native source
  `macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/InAppWebView.swift`
  (+ `InAppWebViewSettings.swift`, + the sibling iOS package for the parity
  cross-check) and enforces the iOS `setSettings` contentBlockers branch shape
  inside the macOS `setSettings` funnel.

```bash
cd zikzak_inappwebview_macos && flutter test test/content_blockers_parity_test.dart
```

Observed (real, pre-fix):

```
00:42 +2 -5: Some tests failed.

Failing tests:
  test/content_blockers_parity_test.dart: ... macOS setSettings reacts to the contentBlockers settings key — #338
  test/content_blockers_parity_test.dart: ... macOS setSettings clears stale rule lists before re-applying — #338
  test/content_blockers_parity_test.dart: ... macOS setSettings serializes and compiles the decoded blockers via WKContentRuleListStore — #338
  test/content_blockers_parity_test.dart: ... macOS setSettings adds the compiled list to the content controller — #338
  test/content_blockers_parity_test.dart: ... macOS setSettings skips compilation for an empty blockers list — #338
```

- **Failed for the right reason**: the extracted macOS `setSettings` body
  contains no reference to `newSettingsMap["contentBlockers"]`,
  `removeAllContentRuleLists()`, `JSONSerialization`,
  `WKContentRuleListStore`, or `userContentController.add` — the exact
  decoded-but-never-consumed state issue #338 reports. The two structural
  gates passed: the setting is still declared on macOS, and the iOS
  `setSettings` branch (the parity target) is present.
- One test defect was repaired BEFORE the red was recorded: the iOS
  cross-check initially looked for `func updateSettings` (the issue's naming);
  in this tree iOS funnels through `func setSettings(newSettings:newSettingsMap:)`
  — same signature as macOS. The extraction was fixed; assertions unchanged;
  the final red above is from the corrected gate. (No source change was made
  between the first red run and this one; both runs were red at the macOS
  gates.)

### Re-pro note (smallest possible case)

The issue's runtime repro (WebKIT blocks a doubleclick.net third-party request
on iOS but not macOS) requires WKWebView. The smallest runnable reproduction of
the *reported state* on a Linux host is the source-scan gate above: it proves
the macOS native `setSettings` consumes nothing. The runtime observation itself
is B13 (MACOS-ONLY / NOT_EXECUTED, C5).

---

## C2 — GREEN: all seven parity gates pass on the fixed source

- **Date**: 2026-09-27
- **Change** (the entire fix):
  `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/InAppWebView.swift`
  — `setSettings` gains the contentBlockers branch mirroring the iOS
  `setSettings` branch one-to-one (removeAllContentRuleLists →
  JSONSerialization → WKContentRuleListStore.default().compileContentRuleList(
  forIdentifier: "ContentBlockingRules") → add in the completion handler;
  `contentBlockers.count > 0` guard). Placement mirrors iOS ordering: directly
  after the `javaScriptEnabled` block. No availability guard (package floor
  macOS 12.0 > WKContentRuleList's macOS 10.13 floor). One comment block
  explains why. Diff: **1 file changed, +33 lines, 0 deletions.**

```bash
cd zikzak_inappwebview_macos && flutter test test/content_blockers_parity_test.dart
```

Observed (real, post-fix):

```
00:43 +7: All tests passed!
```

One test defect was repaired during C2 (assertion mechanism, not strength):
the serialization assertion used a literal `contains` against the
whitespace-collapsed view, where the source's line-broken
`JSONSerialization.data(\n withJSONObject:` reads as `data( withJSONObject:` —
replaced with a whitespace-tolerant regex. Assertion intent unchanged; the
other six assertions were untouched between red and green.

## C3 — Mutants (deliberate, one at a time; restore exact after each)

No mutation tool in the profile (`mutation: null`). Two deliberate mutants on
the changed file, sampled on the two mutation-relevant behaviors:

| Mutant | Change | Observed | Judgment |
| --- | --- | --- | --- |
| M1 | Delete the entire contentBlockers branch | `+2 -5: Some tests failed` — the five macOS behavior gates red | CAUGHT |
| M2 | Replace `self.configuration.userContentController.add(contentRuleList!)` with `let _ = contentRuleList` (compiled but never added) | `+6 -1: Some tests failed` — exactly the "adds the compiled list" gate red | CAUGHT |

After each mutant: file restored from a pre-mutation copy
(`diff`-verified: `git diff --stat` returns to `1 file changed, +33`), parity
test re-run green (`00:44 +7: All tests passed!`).

## C4 — Neighbour + regression gates (post-fix)

- `cd zikzak_inappwebview_macos && flutter analyze` → **No issues found!**
  (0; identical to pre-fix baseline).
- `cd zikzak_inappwebview_macos && flutter test` → **58 passed / 0 failed**
  (`00:49 +58: All tests passed!`; baseline 51/0 + 7 new parity tests).
- `cd zikzak_inappwebview && flutter analyze` (umbrella) → **23 issues**
  (identical set to pre-fix baseline).
- `cd zikzak_inappwebview && flutter test` (umbrella) → **250 passed /
  0 failed** (identical to pre-fix baseline).
- `git diff --check` → clean (zero whitespace errors).
- `dart format test/content_blockers_parity_test.dart` → 0 changed
  (format-clean, idempotent). Package-wide
  `dart format --output=none --set-exit-if-changed .` → the ONLY file that
  would change is the pre-existing master drift
  `test/swift_sourceframe_kvc_test.dart` (verified on the clean tree in C0),
  deliberately left untouched to keep the fix confined.
- Confinement: `git status --porcelain` shows ONLY
  `zikzak_inappwebview_macos/.../InAppWebView.swift` (modified),
  `zikzak_inappwebview_macos/test/content_blockers_parity_test.dart` (new)
  and `.specify/bugs/338-*/**` records. The pub side effect on
  `zikzak_inappwebview/example/pubspec.lock` (79 lines, a known pub-get
  artifact recorded in the profile) was reverted. No iOS/other-platform file
  touched.

## C5 — macOS-only gates (NOT_EXECUTED on this host, with exact commands)

The development host is Linux (no macOS SDK, no Xcode, no WebKit, no
FlutterMacOS, no Swift toolchain). These gates are the final proof and must
run on a macOS host/CI:

- **B12** `cd zikzak_inappwebview_macos && flutter build macos` — compiles the
  package with the new branch. The inserted code is a verbatim structural
  mirror of the iOS branch that compiles against the same WebKit APIs;
  `WKContentRuleListStore`, `compileContentRuleList(forIdentifier:
  encodedContentRuleList:)`, `removeAllContentRuleLists()` and
  `WKContentRuleList` are all macOS 10.13+ (package floor 12.0). Residual
  compile risk: low, but NOT_EXECUTED here and not claimed.
- **B13** runtime observation — run the example app with the issue's
  `InAppWebViewSettings(contentBlockers: [{"trigger": {"url-filter":
  ".*\\.doubleclick\\.net.*", "load-type": ["third-party"]}, "action":
  {"type": "block"}}])` against a page loading the filtered URL; the request
  must not fire (on macOS it currently does). NOT_EXECUTED.
