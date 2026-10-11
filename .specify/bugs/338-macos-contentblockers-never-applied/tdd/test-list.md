---
feature: 338-macos-contentblockers-never-applied
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 4
planned_at: 9e710171
updated_at: 9e710171
suite_baseline: green
---

# Test List — 338-macos-contentblockers-never-applied

Acceptance criteria (derived from issue #338 and the task's hard constraints):

- **AC1** — the macOS `InAppWebViewSettings.contentBlockers` setting is
  consumed inside `InAppWebView.setSettings` exactly like the iOS
  `updateSettings` branch: stale rule lists are cleared
  (`removeAllContentRuleLists()`), the decoded blockers are serialized with
  `JSONSerialization`, compiled through
  `WKContentRuleListStore.default().compileContentRuleList(forIdentifier:
  "ContentBlockingRules", encodedContentRuleList:)`, and the compiled list is
  added back via `configuration.userContentController.add(...)` in the
  completion handler; an empty list clears without compiling
  (`contentBlockers.count > 0` guard).
- **AC2** — `contentBlockers` actually blocks matching requests at runtime on
  macOS (real WKWebView behavior).
- **AC3** — the change is confined to the macOS package plus bug records; iOS
  and every other platform untouched; zero whitespace/formatting diffs
  introduced by the fix.
- **AC4** — the runnable Dart-side gates show no regression vs the pre-fix
  baseline (analyze finding sets identical; test suites identical pass/fail,
  plus the new parity tests).

The missing consumer is a Swift API gap in macOS-only code. The development
environment for this fix is Linux: no macOS SDK, no Xcode, no WebKit, no
FlutterMacOS, and no Swift toolchain (the Swift Linux tarball would exhaust the
disk budget on this host), so `flutter build macos`, `swiftc` parse gates and
any macOS runtime observation are impossible here. Behaviors are classified
honestly: the red→green is runnable via a Dart parity gate that reads the
native source (the established house gate for native parity bugs — see
`swift_sourceframe_kvc_test.dart`, `user_script_initializer_parity_test.dart`);
the real macOS compile and runtime gates (B12/B13) are `MACOS-ONLY /
NOT_EXECUTED` with exact commands in the cycle log. No fake macOS run is
invented to simulate them.

## Behaviors

| ID | Criterion | Behavior | Kind | Level | Test / Gate | Status |
| --- | --- | --- | --- | --- | --- | --- |
| B1 | AC1 | macOS `InAppWebView.setSettings` consumes the `contentBlockers` settings key (`newSettingsMap["contentBlockers"]`) so the branch runs on creation-time `initialSettings` AND runtime `setSettings` calls | behavior | unit (native-source parity gate, runnable) | `cd zikzak_inappwebview_macos && flutter test test/content_blockers_parity_test.dart` | RUNNABLE (red C1 → green C2) |
| B2 | AC1 | Stale rule lists are removed before (re)applying: `configuration.userContentController.removeAllContentRuleLists()` runs whenever the key is present | behavior | unit (parity gate) | same file | RUNNABLE (red C1 → green C2) |
| B3 | AC1 | Decoded blockers are serialized (`JSONSerialization.data(withJSONObject: contentBlockers`) and compiled via `WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "ContentBlockingRules", encodedContentRuleList:)` — same store identifier as iOS | behavior | unit (parity gate) | same file | RUNNABLE (red C1 → green C2) |
| B4 | AC1 | The compiled list is added back in the completion handler: `configuration.userContentController.add(contentRuleList...)` | behavior | unit (parity gate) | same file | RUNNABLE (red C1 → green C2) |
| B5 | AC1 | An empty list clears existing lists and skips compilation (`contentBlockers.count > 0` guard around the compile block) | behavior | unit (parity gate) | same file | RUNNABLE (red C1 → green C2) |
| B6 | AC1 | Parity target intact: the iOS `updateSettings` branch still consumes `contentBlockers` (guards against a trivially-passing scan) | gate | unit (iOS cross-check) | same file | RUNNABLE / green before and after |
| B7 | AC1 | The setting is still declared on macOS (`var contentBlockers: [[String: [String: Any]]]` in `InAppWebViewSettings.swift`) — the gate cannot be satisfied by deleting the declaration | gate | unit (parity gate) | same file | RUNNABLE / green before and after |
| B8 | AC3 | Changes confined to `zikzak_inappwebview_macos/**` + `.specify/bugs/338-*/**` records; no iOS/other platform touched | gate | repo | `git status --porcelain` / `git diff --stat master..HEAD` | RUNNABLE |
| B9 | AC3 | Zero whitespace/formatting diffs introduced by the fix (`git diff --check` clean; new files `dart format`-clean; the only `dart format --set-exit-if-changed` hit is pre-existing master drift in `test/swift_sourceframe_kvc_test.dart`, untouched) | gate | repo | `git diff --check` + `dart format --output=none --set-exit-if-changed` | RUNNABLE |
| B10 | AC4 | `flutter analyze` in `zikzak_inappwebview_macos`: finding set identical to pre-fix baseline (0 pre-fix) | gate | package | baseline vs post-fix run | RUNNABLE |
| B11 | AC4 | `flutter test` in `zikzak_inappwebview_macos`: 51/0 pre-fix → all pass post-fix (51 + new parity tests); umbrella package unchanged (analyze 23 pre-existing; test 250/0) | gate | package | baseline vs post-fix run | RUNNABLE |
| B12 | AC1/AC3 | `flutter build macos` in `zikzak_inappwebview_macos` compiles the package with the new branch | gate | integration (macOS toolchain) | macOS-only: `cd zikzak_inappwebview_macos && flutter build macos` | MACOS-ONLY / NOT_EXECUTED |
| B13 | AC2 | `contentBlockers` passed to `InAppWebView` on macOS blocks matching requests before they start (repro from the issue: doubleclick.net third-party request must not fire) | behavior | end-to-end (macOS runtime) | macOS-only: run example app with the issue's `InAppWebViewSettings(contentBlockers: [...])` against a page loading the filtered URL | MACOS-ONLY / NOT_EXECUTED |
| B14 | AC1 | Test strength: the parity gate catches (a) removal of the whole contentBlockers branch and (b) dropping the completion-handler `add` — deliberate mutants | gate | mutation (deliberate, sample) | M1/M2 in cycle-log C3, each caught, restore exact, suite green after restore | RUNNABLE |
