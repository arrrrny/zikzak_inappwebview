---
feature: 349-ios-contentblockers-silently-blocks-the-initial-navigation-blank-page-no-logs
verdict: PASS_WITH_GAPS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md # rubric graded against; no overrides/presets present
verified_at: 97caf324 # short SHA audited
behaviors: 11 # B1-B10 runnable gates + B11 macOS cross-check re-derivation
proven: 11
likely: 0
test_after: 0
no_test: 0
high_smells: 0
criteria_total: 6
criteria_covered: 6 # AC1-AC6 at the source-contract gate level; runtime end-to-end is B13, NOT_EXECUTED
mutation_score: null # no mutation tool in the profile (mutation: null); deliberate mutants sampled
mutants_survived: 0 # 2/2 deliberate mutants caught (M1, M2)
suite: iOS 23 passed / 0 failed (1m30s); macOS 76 passed / 0 failed (1m3s); new gate 10 passed / 0 failed (32s)
---

# TDD Verification — 349-ios-contentblockers-silently-blocks-the-initial-navigation-blank-page-no-logs

**Verdict: PASS_WITH_GAPS.** Test-first discipline is PROVEN by commit order
(`729a7735` adds the gate alone and its tree contains zero
`applyContentBlockers` references; the red `+2 -8` is recorded against that
tree), both deliberate mutants were caught, and every AC is covered at the
repo's native-parity gate level — the gaps are environmental: the iOS compile
gate (B12) and the simulator runtime observation (B13) cannot run on this
Linux host, and the audit was not independent.

## Environment

Linux x86_64 (Debian 13). Flutter 3.47.5 / Dart 3.13.4. No macOS SDK, no
Xcode, no WebKit, no Swift toolchain — same class of host as the 338 cycle.

## Test-first evidence

| Behavior | Class  | Evidence |
| -------- | ------ | -------- |
| B1 (makeInitialLoad settles the initial load) | PROVEN | red C1 recorded pre-fix at `729a7735` (test-only commit; its tree has 0 `applyContentBlockers` in both iOS sources — verified via `git show 729a7735:<file> \| grep -c`); green after `97caf324` |
| B2 (no-blockers path intact)                  | PROVEN | preservation gate; green before and after — guards the path the issue reports as working |
| B3 (funnel, no inline compile)                | PROVEN | same red→green ordering as B1 |
| B4 (funnel shape, guarded add)                | PROVEN | same red→green ordering; M2 proves the force-unwrap assertion bites |
| B5 (settle-on-any-outcome + token)            | PROVEN | same red→green ordering; M1 proves the early-return assertion bites |
| B6 (fixed identifier gone, SHA-256 derived)   | PROVEN | same red→green ordering (red: `"ContentBlockingRules"` present at 3 compile sites) |
| B7 (setSettings funnels the key)              | PROVEN | same red→green ordering |
| B8 (InAppBrowser funnels)                     | PROVEN | same red→green ordering |
| B9 (URLRequest fallback logs)                 | PROVEN | same red→green ordering |
| B10 (setting still declared)                  | PROVEN | structural gate; green before and after; prevents satisfying the scan by deleting the declaration |
| B11 (macOS #338 cross-check re-derived)       | PROVEN | red not applicable (the gate was green against the OLD iOS shape); the re-derivation is the documented behavior change — see Existing-test audit |

### Existing-test audit (the highest-signal check)

Exactly one pre-existing test changed:
`zikzak_inappwebview_macos/test/content_blockers_parity_test.dart`, the #338
gate whose iOS cross-check pinned the OLD iOS shape. Diff at `97caf324`:

- REMOVED (from the `'iOS setSettings branch (the parity target) still
  consumes contentBlockers'` test): `contains('compileContentRuleList(')`
  against the iOS `setSettings` body, and
  `contains('"ContentBlockingRules"')` against the same body.
- ADDED: `contains('applyContentBlockers(')` against the iOS `setSettings`
  body (the delegation), `isNotEmpty` + `contains('WKContentRuleListStore
  .default().compileContentRuleList(')` against the NEW iOS
  `applyContentBlockers` funnel body (extraction added in `setUpAll`,
  field `iOSApplyContentBlockersBody`).

Judgment: NOT a weakening. The compilation behavior is still pinned — the
assertion moved from the inline site to the funnel that now owns it — and the
delegation is pinned in addition. The removed `"ContentBlockingRules"`
assertion is superseded by the iOS B6 gate (the fixed identifier must be
GONE — the opposite polarity, per issue #349). The test's own comment
anticipated this: "If iOS ever stops being the reference implementation, this
gate must be re-derived." Net assertions on iOS: 2 → 4.

## Findings

Ordered by severity. No HIGH findings.

| # | Severity | Finding | Evidence |
| - | -------- | ------- | -------- |
| 1 | MED (contextual, documented) | The new gate is a source scan: it proves code SHAPE, not runtime behavior. This is the repo's accepted style for native parity bugs (AGENTS.md: "macOS source-contract tests are not a type-check… Treat a green macOS test run as evidence about code shape"), and the CI `build-ios` job exists to compile what the scan cannot. Residual risk is carried by B12/B13, not by this gate. | `zikzak_inappwebview_ios/test/content_blockers_initial_load_test.dart:1-33` (header states the contract) |
| 2 | LOW | B2/B3 unwrap `functionBody(...)!` — if `makeInitialLoad` were deleted outright, the failure surfaces as a null-check exception instead of a labeled reason (B1's `isNotNull` gate does state it). | `content_blockers_initial_load_test.dart:197-200,227-230` |
| 3 | LOW | B6's fourth assertion is an OR (`contentRuleListIdentifier(forRules:' || 'SHA256.hash(data:')` — slightly weaker precision than a single-shape assertion. | `content_blockers_initial_load_test.dart:395-405` |
| 4 | LOW | Eager-ish: B5 packs the settle-order chain (token < flag-reset < error-branch < add < pending-fire) into one test — but these are five facets of the single completion-ordering behavior, and each index assertion carries its own reason, so assertion roulette is mitigated. | `content_blockers_initial_load_test.dart:327-388` |

No assertion-free, tautological, re-implemented, over-mocked, vacuous,
snapshot, conditional-logic, or skipped tests found. Properties: the gate is
deterministic (pure file reads, no clock/network/order dependence), fast
(32s including flutter overhead), isolated (no shared state), and names each
test after its behavior with the issue id. Style matches the package's
existing native-parity gates (helpers are duplicated inline per the profile's
"no shared test helpers" rule, as `content_blockers_parity_test.dart` did for
#338).

## Mutation results

No mutation tool in the profile (`mutation: null`). Deliberate mutants on the
changed file, one at a time, restored byte-identical (cp + `diff -q`) and
suite re-verified green after each restore. Sample: 2 of the highest-risk
behaviors (AC2 and AC3). Not exhaustive.

| Mutant | Behavior | Survived | Judgment |
| ------ | -------- | -------- | -------- |
| M1: reintroduce the #349 error-path drop (`return` after `print(error.localizedDescription)` in the completion) | B5 / AC2 | No | CAUGHT — B5 red: "must NOT early-return on error before firing the pending load" |
| M2: reintroduce the force unwrap (`add(contentRuleList!)`) | B4 / AC3 | No | CAUGHT — B4 red: "must be added through an optional bind, never a force unwrap" |

## Traceability

| Criterion | Tests | End to end |
| --------- | ----- | ---------- |
| AC1 (initial load fires on settle; null path intact) | B1, B2, B3, B7, B8, B11 | Source-contract level yes; runtime end-to-end = B13, NOT_EXECUTED |
| AC2 (error cannot orphan the load) | B5 | Source-contract level yes (M1 mutants it); runtime = B13 |
| AC3 ((nil,nil) cannot crash) | B3, B4, B8 | Source-contract level yes (M2 mutants it); runtime = B13 |
| AC4 (token serialization + main-thread hop) | B4, B5 | Source-contract level yes |
| AC5 (content-derived identifier) | B4, B6 | Source-contract level yes |
| AC6 (URLRequest fallback logs; parse path preserved) | B9 | Source-contract level yes |

Untested criteria: none at the gate level. Tests tracing to nothing: none
(B10 is a contract guard, B11 the cross-package parity check — both declared
in the test list).

## What was not audited

- **B12 — the Swift compile gate**: `cd zikzak_inappwebview/example &&
  flutter build ios --release --no-codesign` requires macOS/Xcode. The
  changed Swift mirrors the macOS #338 machinery (which compiles), stays
  inside the pre-existing `#available(iOS 11.0, *)` scopes, and uses only
  APIs at or below the package's iOS 15.0 floor (CryptoKit `SHA256` is iOS
  13+). Residual compile risk: low but real — the CI `build-ios` job
  (`macos-14` + `macos-15`) must green-light the PR.
- **B13 — the runtime repro** on an iOS simulator (initial navigation commits
  with contentBlockers set): requires a simulator host; not executed and not
  claimed.
- **Mutation testing** was deliberate-mutant sampling (2 mutants, 2/2
  caught), not a tool-scored run; un-mutated behaviors (B1, B6, B7, B8, B9)
  rest on the red→green evidence only.
- **Other platform packages** (umbrella, android, web, windows, linux,
  platform_interface) were not exercised: the fix touches no Dart runtime
  code and no other platform's sources; the only cross-package coupling (the
  macOS parity gate) was re-run green.
- **The audit is NOT independent** — the same session wrote the fix, the
  gate, and this report. Fail-closed was applied (all files re-read cold,
  git history cross-checked against the cycle log; no discrepancy found).

## Remediation

This bug workflow dir has no `tasks.md` (bug-workflow shape, matching the 338
precedent), so Phase 7 appends nothing. Findings worth acting on, for the
record:

1. Run B12 + B13 on a macOS/simulator host (or read the CI `build-ios` job
   result on the PR) before considering the #349 fix fully verified at
   runtime.
2. Finding #2/#3 are cosmetic; fold them into the next touch of the gate
   file if any.
