---
feature: 011-split-controller-domains
verdict: FAIL
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: 47cea2f8
behaviors: 92
proven: 5
likely: 16
test_after: 0
no_test: 69
not_applicable: 2
high_smells: 2
criteria_total: 6
criteria_covered: 0
mutation_score: N/A # no mutation tool in stack profile (mutation_test absent)
mutants_survived: 1 # 1 deliberate mutant sampled; systemic, see Finding 1
suite: umbrella 118 passed, 0 failed; platform_interface 150 passed, 0 failed; android 4/4; ios 4/4
---

# TDD Verification: Split InAppWebViewController into Domain-Specific Controllers

**Verdict: FAIL.** The committed tests pass, but they are all compile-time probes that assert only that symbols exist — none exercise runtime behavior. A deliberate mutant (`AndroidInAppWebViewController.navigationDelegate => null`) left the Android delegate suite at 4/4, proving the tests cannot catch a behavioral break. Sixty-nine behaviors (the six acceptance criteria and the entire facade-delegation layer U5–U67) have no test at all, so acceptance criteria US-1–US-6 / SC-001–SC-006 are uncovered.

Prior `verification.md` (verified_at `abfa842e`) reported `BLOCKED` because the delegate getters did not exist and the suite had compile errors. That blocker was resolved in commits `21d0d157`, `4e67a8f8`, `47cea2f8` (delegate exports, getters, and Android/iOS wiring). This re-audit reflects the code as it stands at `47cea2f8`: the blocker is gone, but the feature is **not** behaviorally tested.

## Test-first evidence

| Behavior group | Class | Evidence |
| -------------- | ----- | -------- |
| U68–U72 (platform delegate getters + exports) | PROVEN | Cycle 1 records a red (compile error: missing `cookieDelegate`/`settingsDelegate` getters + unexported delegate types). Source fixed in `21d0d157`. |
| U1–U4 (lazy facade getters) | LIKELY | `domain_controllers_test.dart` present and passing; no independent red recorded. Tests are compile-probes (see Finding 1). |
| U73–U76 (delegate method surfaces) | LIKELY | Module classes present; assertions only that the types exist/compile. |
| U77–U84 (Android/iOS delegate wiring) | LIKELY | Cycle 2 states "no red written"; concrete overrides added against already-present delegate classes. Compile-probe suites pass. |
| A1–A6 (acceptance) | NO_TEST | `test-list.md` rows all `PENDING`; no test file exists. |
| U5–U67 (facade delegation) | NO_TEST | `test-list.md` rows all `PENDING`; no behavioral test exists. |
| U85, U86 (zorphy DI) | NOT_APPLICABLE | zorphy is entity codegen only; delegates wired manually via override getters. Confirmed by inspection. |

## Findings

| # | Severity | Finding | Evidence |
| - | -------- | ------- | -------- |
| 1 | HIGH | All 12 committed tests are compile-time probes. They assert only symbol/function-reference existence (`expect(FooClass, isNotNull)`); none instantiate a controller, call a method, or assert delegation or observable behavior. They pass even when runtime behavior is broken. Verified empirically: mutating `AndroidInAppWebViewController.navigationDelegate => null` left `android_delegates_test.dart` at 4/4 (mutant survived). Consequence: lazy-singleton instantiation (FR-011, SC-006), delegate wiring (FR-004, SC-004), and facade delegation (FR-002) are unverified at runtime. | `zikzak_inappwebview/test/domain_controllers_test.dart:28-42`; `zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart:170-188`; `zikzak_inappwebview_android/test/in_app_webview/modules/android_delegates_test.dart:14-28`; `zikzak_inappwebview_ios/test/in_app_webview/modules/ios_delegates_test.dart:14-28` |
| 2 | HIGH | Six acceptance behaviors A1–A6 (US-1–US-6) are NO_TEST. No end-to-end or behavioral test exercises the real facades or delegates, so acceptance criteria SC-001–SC-006 are uncovered. This is the decisive FAIL condition. | `tdd/test-list.md` A1–A6 all `PENDING`; `spec.md` US-1–US-6 |
| 3 | MED | Facade delegation behaviors U5–U67 (63 rows) are NO_TEST. The core of the feature — monolith delegates to facades, facades delegate to parent — has no behavioral test. Testing it requires a fake parent controller; the U1–U4 probes only prove the getters exist. | `tdd/test-list.md` U5–U67 all `PENDING` |
| 4 | MED | Acceptance A6 / SC-004 (Android & iOS delegate getters return non-null concrete instances at runtime) is unproven. The committed tests only confirm the override symbols compile; non-null is never asserted at runtime (tracked by open remediation R005/R006). | `tdd/cycle-log.md` Cycle 2 notes: "Runtime verification of SC-004 … is not performed here" |

## Mutation results

No mutation-testing tool in the stack profile (`mutation: null`). Deliberate-mutant spot check performed on the highest-risk committed behavior (delegate wiring):

| Mutant | Behavior | Survived | Judgment |
| ------ | -------- | -------- | -------- |
| `zikzak_inappwebview_android/.../in_app_webview_controller.dart:2723` `navigationDelegate` body changed to `=> null` | U77 | **Yes** | Caught by nothing — the Android delegate test references the `AndroidNavigationDelegate` *class*, never calls the getter. Systemic: all 12 committed tests are compile-probes. Mutant restored exactly; `flutter test` re-run confirmed green. |

One mutant sampled (of 92 behaviors); it survived. Because every committed test is a compile-probe, the unaffected set is effectively the same — test strength against bugs is **unmeasured and almost certainly low**. Coverage output (`flutter test --coverage`) is available but not a substitute; see "What was not audited".

## Traceability

| Criterion | Tests | End to end |
| --------- | ----- | ---------- |
| US-1 / FR-002 / SC-001, SC-002 (backward compatibility) | none (A1 PENDING) | No |
| US-2 / FR-005 / SC-003 (navigation facade) | none (A2, U5, U10–U28 PENDING) | No |
| US-3 / FR-006 / SC-003 (JavaScript facade) | none (A3, U6, U29–U45 PENDING) | No |
| US-4 / FR-007 / SC-003, SC-005 (cookie facade) | none (A4, U7, U46–U65 PENDING) | No |
| US-5 / FR-008 / SC-003 (settings facade) | none (A5, U8, U66–U67 PENDING) | No |
| US-6 / FR-003, FR-004 / SC-004 (platform delegate migration) | compile-probe only (A6, U68–U86); runtime non-null unasserted | No |

**Untested criteria:** 6 of 6 acceptance criteria have no behavioral test.
**Tests tracing to nothing:** the 12 compile-probe tests verify symbol existence, not behavior, and trace to no acceptance criterion in the test list.

## What was not audited

- **Facade delegation at runtime (U5–U67) and all acceptance scenarios (A1–A6):** no tests exist; nothing to audit beyond confirming absence.
- **Device/integration coverage for SC-004:** Android emulator (`emulator-5554`) and macOS desktop are not drivable under `flutter test` in this environment (per profile); only the iOS Simulator runs integration tests. So even the runtime non-null check for Android/iOS delegates (A6) cannot be exercised here. iOS simulator is reachable.
- **Mutation / property-based testing:** absent from the stack; test strength is unmeasured.
- **Coverage scope:** `flutter test --coverage` produces `lcov.info` but was not used to gate this audit; the behavioral gaps above are structural (no tests), not merely branch gaps.
- **Edge cases** (disposed controller, HeadlessInAppWebView, cross-domain state, concurrency, FR-011 dedupe): listed in `test-list.md` "Invariants" but untested.

## Remediation

The existing `## Phase N: TDD remediation` section in `tasks.md` already carries R001–R002 (done) and R003–R007 (open). R004 covers A1 only; R005/R006 cover Android/iOS delegate non-null (referencing A15/A16). The NEW gaps found in this audit — acceptance A2–A5 and the facade-delegation layer — are added as R008–R010, appended (not reworded) to that section. The feature is **not done** until the blocking findings (F1, F2) are cleared.
