---
feature: 349-ios-contentblockers-silently-blocks-the-initial-navigation-blank-page-no-logs
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 6
planned_at: db17a3d2
updated_at: db17a3d2
suite_baseline: green
---

# Test List — 349-ios-contentblockers-silently-blocks-the-initial-navigation-blank-page-no-logs

Acceptance criteria (derived from issue #349 and the task's hard constraints):

- **AC1** — with `contentBlockers` set, the initial navigation of a platform
  view (`makeInitialLoad`) is issued when the content-rule compilation
  SETTLES — success OR error — never only from inside the
  `compileContentRuleList` completion; the null-`contentBlockers` path keeps
  clearing stale rule lists and loading directly.
- **AC2** — a compilation error cannot orphan the initial load: the
  completion resets `isCompilingContentRuleLists`, prints, and still fires
  the pending load; no `return` before the fire.
- **AC3** — a `(nil, nil)` completion cannot crash: the compiled list is
  added through an optional bind, no `contentRuleList!` force unwrap.
- **AC4** — compilations are serialized by a stale-completion token so a
  late completion cannot re-add rules a newer update removed, and the
  completion hops to the main thread.
- **AC5** — the fixed `"ContentBlockingRules"` persistent-store identifier is
  gone from the iOS sources; the identifier is derived from the rule content
  (SHA-256), so recompiles across launches/webviews cannot collide with a
  stale store entry.
- **AC6** — `URLRequest(fromPluginMap:)` logs the input it rejects before the
  `about:blank` fallback (the issue's diagnosability ask), and the
  parse-success path is preserved.

Behaviors (gate: `zikzak_inappwebview_ios/test/content_blockers_initial_load_test.dart`,
source-scan style per the repo's native-parity gate convention; all runnable
on any host — no Xcode required):

| id | behavior (test name) | AC | traces | state |
| --- | --- | --- | --- | --- |
| B1 | makeInitialLoad holds the initial navigation only until the content-rule compilation settles — #349 | AC1 | B1 test | DONE |
| B2 | makeInitialLoad keeps the no-blockers path intact — #349 | AC1 | B2 test | DONE |
| B3 | makeInitialLoad compiles through the applyContentBlockers funnel, not an inline compile — #349 | AC1, AC3 | B3 test | DONE |
| B4 | applyContentBlockers funnel exists with the macOS #338 shape — #349 | AC1, AC3, AC4, AC5 | B4 test | DONE |
| B5 | the compile completion settles into the pending load on every outcome and is token-guarded — #349 | AC2, AC4 | B5 test | DONE |
| B6 | the fixed "ContentBlockingRules" store identifier is gone from the iOS sources — #349 | AC5 | B6 test | DONE |
| B7 | setSettings funnels the contentBlockers key through applyContentBlockers — #349 | AC1–AC5 | B7 test | DONE |
| B8 | the InAppBrowser initial load settles through the same funnel — #349 | AC1–AC3 | B8 test | DONE |
| B9 | URLRequest(fromPluginMap:) logs the rejected url before the about:blank fallback — #349 | AC6 | B9 test | DONE |
| B10 | the contentBlockers setting is still declared — #349 | contract guard | B10 test | DONE |
| B11 | (macOS package) the #338 parity gate's iOS cross-check matches the re-derived iOS funnel | AC1 | `zikzak_inappwebview_macos/test/content_blockers_parity_test.dart` | DONE |

Runtime ACs (macOS/Simulator-only, NOT_EXECUTED on the Linux dev host — see
cycle-log C5):

| id | behavior | AC | state |
| --- | --- | --- | --- |
| B12 | `cd zikzak_inappwebview/example && flutter build ios --release --no-codesign` compiles the changed Swift on a macOS host / CI build-ios job | all | NOT_EXECUTED (host) |
| B13 | the issue's repro commits and renders with contentBlockers set on an iOS simulator | AC1 | NOT_EXECUTED (host) |
