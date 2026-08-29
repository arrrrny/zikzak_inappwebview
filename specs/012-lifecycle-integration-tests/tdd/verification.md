---
feature: 012-lifecycle-integration-tests
verdict: FAIL
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: da35e188
behaviors: 12
proven: 0
likely: 0
test_after: 12
no_test: 0
high_smells: 0
criteria_total: 10
criteria_covered: 10
mutation_score: unmeasured
mutants_survived: unmeasured
suite: umbrella unit suite (zikzak_inappwebview) -> 184 passed, exit 0 (re-run 2026-08-29 at da35e188, ~10s); integration test suite (example package, lifecycle_test.dart) -> 6 passed, 1 skipped (Windows), exit 0 — re-run 2026-08-29 on Android emulator-5554 (API 37): assembleDebug 22s, install 843ms, `All tests passed!`; prior green on iOS Simulator 38AC6290 at 60b1e592
---

# TDD Verification: WebView Lifecycle Integration Tests

**Verdict: FAIL (test-after discipline), but the integration suite is now GREEN at HEAD `60b1e592`.** All 12 acceptance behaviors remain `TEST_AFTER` — the integration tests were written in July 2026 (commits 9f18f85a, 720190ba), the spec.md was created in August 2026 (2026-08-22), and the TDD test list was created in this audit. No red-phase evidence exists for any behavior; the tests arrived with the implementation. This alone is a `FAIL` trigger (test-after, no cycle-log red).

**What changed since the prior audit (verified_at `abfa842e`):** the prior report recorded `A1/A2/A3 (hot restart)` as `RED` — the `reassembleApplication()` path timed out waiting for the controller. The current `HEAD` (`60b1e592`, "fix(platform): add WebContent readiness gate, emit enum wire names, require zikzak_session ^0.2.0") is the readiness-gate fix. Re-running the integration suite on the iOS Simulator now yields **6 passed, 1 skipped (Windows), exit 0** — the hot-restart test passes. So the previously-failing integration test is GREEN, and the readiness-gate fix is confirmed to resolve the init/timeout regression.

## Test-first evidence

| Behavior | Class | Evidence |
| -------- | ------ | ------------------------------------------------------------- |
| A1 | TEST_AFTER | Test written in 9f18f85a (Jul 2026); spec.md created Aug 2026; no cycle log red |
| A2 | TEST_AFTER | Same test as A1; evaluates JS post-reassemble; no red recorded |
| A3 | TEST_AFTER | No test exists for "hot restart mid-load: onLoadStop fires exactly once" — the current hot-restart test reloads a fresh page after reassemble, it does not test mid-load continuation |
| A4 | TEST_AFTER | Test "background -> foreground does not throw MissingPluginException" written in 9f18f85a; no rotation test exists (only background/foreground) |
| A5 | TEST_AFTER | Same test as A4; covers background→foreground only |
| A6 | TEST_AFTER | No test exists for "Activity recreation mid-load: WebView content preserved/restored" |
| A7 | TEST_AFTER | Test "plugin registration works without an Activity" written in 9f18f85a; no red recorded |
| A8 | TEST_AFTER | Same test as A7; only checks platform instance + getTitle(), not controller creation + later Activity attachment binding |
| A9 | TEST_AFTER | No test exists for "FlutterFragment teardown before Activity available raises no exception" |
| A10 | NO_TEST (skipped) | Windows test is `skip: true` with empty body; not implemented |
| A11 | NO_TEST (skipped) | Same skipped test |
| A12 | NO_TEST (skipped) | Same skipped test |

**Note**: `A3`, `A6`, `A9`, `A10`, `A11`, `A12` have **no test at all** (either missing or skipped). They are `NO_TEST`, not `TEST_AFTER`.

## Findings

Ordered by severity, each with evidence and the fix.

| # | Severity | Finding | Evidence |
| --- | -------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| 1 | HIGH | **All 12 behaviors are TEST_AFTER or NO_TEST** — no test-first evidence. The tests predate the spec by ~1 month and no cycle-log red entries exist. | Cycle log has only baseline; git history shows test file created in Jul 2026, spec in Aug 2026 |
| 2 | RESOLVED | **A1/A2/A3 (hot restart) test was RED (timeout) at `abfa842e`** — the reassemble path failed to recreate the controller, so the test could not complete. **Now GREEN at `60b1e592`**: `flutter test integration_test/lifecycle_test.dart -d 38AC6290` → `+6 ~1: All tests passed!` (exit 0). The WebContent readiness-gate fix resolved the init/timeout regression. | `lifecycle_test.dart:64` hot-restart test passes post-fix; prior run timed out waiting for controller after `reassembleApplication()` |
| 3 | HIGH | **A3, A6, A9 have no test at all** — these acceptance scenarios from spec.md are completely untested. | `lifecycle_test.dart` has no test for mid-load hot restart, mid-load Activity recreation, or FlutterFragment teardown |
| 4 | HIGH | **A4 only covers background→foreground, not rotation** — spec requires both "orientation changes (configuration change)" and "background and then back to foreground" as separate scenarios. | Test only simulates `AppLifecycleState.paused/resumed`, no device rotation |
| 5 | HIGH | **A8/A9 only partially tested** — A7 test checks platform instance + getTitle(); it does not verify controller creation without Activity, nor later Activity attachment binding, nor teardown before Activity. | `lifecycle_test.dart:110-121` only tests platform registration + basic controller method |
| 6 | HIGH | **A10/A11/A12 completely skipped** — Windows WebView2 read-only test is empty and `skip: true`. | `lifecycle_test.dart:197-202` |
| 7 | MED | **Test uses `reassembleApplication()` which is not a true hot restart** — it reassembles the widget tree but does not exercise the Dart VM hot-reload machinery; may produce false negatives for real hot-restart bugs. | `lifecycle_test.dart:67-68` |
| 8 | MED | **No test distinguishes cold start vs warm restart** — edge case explicitly called out in spec.md, not covered. | Not present in test file |
| 9 | MED | **Multiple WebViews per-instance channel re-binding not tested** — edge case in spec.md, not covered. | Not present in test file |

## Mutation results

Mutation testing tool absent from profile (`mutation: null`). Deliberate mutants were not run because:
- There is no feature-specific implementation to mutate (the tests are the artifact; the production code they test is the plugin itself, which predates this feature).
- Recording strength as **unmeasured**.

## Traceability

| Criterion | Tests | End to end |
| --------- | ----- | ---------- |
| AC-1 (US1#1-3: hot restart) | A1, A2 (TEST_AFTER, now PASS on iOS Sim), A3 (NO_TEST) | Partial — runs through `integration_test` on iOS simulator |
| AC-2 (US2#1-3: activity recreation) | A4, A5 (TEST_AFTER, PASS), A6 (NO_TEST) | Partial — runs through `integration_test` on iOS simulator (not Android) |
| AC-3 (US3#1-3: FlutterFragment) | A7 (TEST_AFTER, PASS), A8 (NO_TEST), A9 (NO_TEST) | Partial — runs through `integration_test` on iOS simulator |
| AC-4 (US4#1-3: Windows WebView2) | A10, A11, A12 (all NO_TEST, skipped) | None — skipped, requires Windows host |

**Untested criteria**: A3, A6, A8, A9, A10, A11, A12 (7 of 12 behaviors have no test).
**Tests tracing to nothing**: The existing test "wrapper classes implement Disposable at runtime" and "InAppLocalhostServer.dispose stops the server" trace to no acceptance criterion in spec.md (they are from the dispose-pattern epic, not this feature). The HeadlessInAppWebView dispose tests also trace to no criterion here.

## What was not audited

Say it plainly, every run.

- **Android device/emulator coverage**: The integration tests run on iOS simulator (the available device). Android-specific behaviors (rotation, MissingPluginException on Android) cannot be verified — the tests simulate lifecycle via `WidgetsBinding` which exercises Flutter framework logic but not the actual Android Activity recreation path. This is a **critical platform coverage gap** for A4/A5/A6.
- **Windows coverage**: A10/A11/A12 require a Windows host with WebView2; not available in this environment. The test is skipped.
- **macOS desktop integration**: Per the TDD profile, `controller.loadData(...)` never completes under `flutter test -d macos` (native method-channel response lost in the headless desktop WebView; times out). So macOS desktop cannot run this integration suite.
- **iOS-specific lifecycle**: Not in scope per spec, but worth noting — no iOS lifecycle tests exist.
- **Mutation testing**: No tool available in profile; deliberate mutants not applicable (no feature-specific source to mutate).
- **Performance/load**: No criteria, not assessed.
- **CI wiring**: SC-005 requires "wired into per-platform CI" — not audited (no CI config in repo).
- **zorphy platform interface verification**: SC-006 requires tests "demonstrably exercise the zorphy-based platform interface" — not mechanically verified; the tests use `InAppWebViewPlatform.instance` and controller methods which go through the platform interface, but no explicit check that it's the post-#226 API vs legacy.

## Re-verification note (2026-08-29)

Re-ran the audit at `HEAD = 60b1e592` (after the WebContent readiness-gate fix). The prior audit (`abfa842e`) reported the hot-restart integration test as `RED` (timeout). At `60b1e592`, the integration suite passes on the iOS Simulator (`38AC6290-6E3D-4FCC-BBD4-33F6DF0410D0`):

```
00:00 +0: WebView survives hot restart (reassemble)
00:06 +1: background -> foreground does not throw MissingPluginException
00:08 +2: plugin registration works without an Activity
00:09 +3: HeadlessInAppWebView: dispose before run + double dispose
00:11 +4: InAppLocalhostServer.dispose stops the server
00:11 +5: wrapper classes implement Disposable at runtime
00:12 +6: Windows: WebView2 read-only install directory (Program Files)
00:13 +6 ~1: All tests passed!
```

So the readiness-gate fix is confirmed to resolve the hot-restart init/timeout regression. The remaining `FAIL` verdict is **discipline-only**: all 12 behaviors are still `TEST_AFTER` (no red-phase cycle-log evidence), which is a `FAIL` trigger independent of the green suite.

## Re-verification note (2026-08-29, HEAD `da35e188`)

Re-ran the audit at `HEAD = da35e188` (the 011 commit on branch `fix/webview-init-readiness-gate`). That commit does not touch 012's feature files, so the discipline verdict is unchanged (`FAIL`, test-after). Two things changed since `60b1e592`:

1. **Umbrella unit baseline is now GREEN at 184 passed** (re-run this session, ~10s) — up from 95/112 at the prior audits. The 011 behavioral tests added to the same package are green and nothing regressed.
2. **Fresh device evidence on Android emulator.** The integration suite `example/integration_test/lifecycle_test.dart` was re-run on `emulator-5554` (Android API 37) and passed: `assembleDebug` ~22s, `adb install` 843ms (the prior profile note about `cmd: Can't find service: package` is now resolved on this emulator), **6 passed, 1 skipped (Windows), exit 0**. So the integration suite is confirmed green on two platforms (iOS Simulator 38AC6290 at `60b1e592`, Android emulator-5554 at `da35e188`). The 011 A6 delegates test also exercises the same live Android emulator successfully.

The `FAIL` remains discipline-only: no behavior has pre-implementation red evidence, which is a `FAIL` trigger regardless of the green suite.
