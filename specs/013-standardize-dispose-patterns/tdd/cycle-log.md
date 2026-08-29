# Cycle Log: Standardize Dispose Patterns Across Wrapper Classes + HeadlessInAppWebView Double-Dispose Guard

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test` in `zikzak_inappwebview` -> 95 passed, 2 files fail to compile
- commit: `abfa842e`
- recorded: cycle 0, before any change
- note: The two compile-broken files are pre-existing and unrelated to this feature:
  1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift from this work)
  2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is not declared in `pubspec.yaml`; the source `lib/src/webview_sessions/webview_sessions.dart` has the same missing import. This is an unmet dependency, not a test bug.

## Cycle 1 — U15 (characterization/test-after of pre-existing behavior)

- test: `test/in_app_localhost_server_dispose_test.dart` — `U15: dispose() on a non-running server marks it disposed and does not close it`
- red command: `flutter test test/in_app_localhost_server_dispose_test.dart --plain-name "U15: dispose() on a non-running server marks it disposed and does not close it"`
- red evidence (deliberate-mutant check): the behavior's implementation already exists in product code, so the test passed on first run. To prove the test has teeth, `_disposed = true;` was removed from `InAppLocalhostServer.dispose()`. The test then failed:
  ```
  00:00 +0 -1: ... U15: dispose() on a non-running server marks it disposed and does not close it [E]
    Expected: true
      Actual: <false>
    dispose() must mark the server as disposed
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: restored `lib/src/in_app_localhost_server.dart` (`_disposed = true;` present). Full suite `flutter test` in `zikzak_inappwebview` -> **99 passed** (was 98; +1 new test), no regressions.
- refactor: none needed — test follows the inline-fake style of the exemplar (`disposable_pattern_test.dart`); fake `_FakePlatformLocalhostServer extends PlatformInAppLocalhostServer` via `.implementation(params)` and records `closeCallCount`.
- class: CHARACTERIZATION (implementation predates the test; no red-phase code change was required, only the mutant proof).
- commit: not committed (working tree left dirty per `--no-commit` default; harness modifications also present).

## Cycle 2 — A4, U7, U10, U13, U18 (reconciliation: already covered by a passing test)

- test: `test/disposable_pattern_test.dart` — `wrapper classes implement Disposable` and `Disposable declares the standardized dispose signature`
- red command: `flutter test test/disposable_pattern_test.dart --plain-name "wrapper classes implement Disposable"`
- red evidence: none — these behaviors were already asserted by a pre-existing passing test, not written in this cycle. The test ran green on first execution (2 passed). To prove the assertions have teeth, each `implements Disposable` binding and the canonical signature probe were removed in turn; the file then failed to compile (the generic bound `T extends Disposable` and the `void Function({bool isKeepAlive})` assignment no longer resolve), which is the recorded proof of coverage. Restored exactly; suite green again.
- green: `flutter test test/disposable_pattern_test.dart` -> **2 passed**; full umbrella suite -> **186 passed**, no regressions.
- refactor: none needed — `disposable_pattern_test.dart` is the established exemplar for the Disposable contract and was reused as-is.
- class: RECONCILIATION (behaviors A4/U7/U10/U13/U18 were already covered by the passing `disposable_pattern_test.dart`; marked DONE per the "already covered by an existing passing test" rule, no new test written).
- note: A4 subsumes U7/U10/U13 (each wrapper implements Disposable); U18 is the interface-level contract the probe encodes. U15 remains the only behavior with its own dedicated test file.
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 3 — U1 (test-first with deliberate-mutant proof)

- test: `test/headless_dispose_guard_test.dart` — `U1: dispose before run forwards to platform.dispose(isKeepAlive: false) exactly once`
- red command: `flutter test test/headless_dispose_guard_test.dart --plain-name "U1: dispose before run forwards to platform.dispose(isKeepAlive: false) exactly once"`
- red evidence (deliberate-mutant check): the test passed on first run because the current `dispose()` already forwards `isKeepAlive: false` to `platform.dispose()` for a single call. To prove the assertion has teeth, `platform.dispose(isKeepAlive: isKeepAlive)` was temporarily edited to `platform.dispose(isKeepAlive: true)`. The test then failed:
  ```
  00:00 +0 -1: ... U1: dispose before run forwards to platform.dispose(isKeepAlive: false) exactly once [E]
    Expected: false
      Actual: <true>
    test/headless_dispose_guard_test.dart:36:9  main.<fn>.<fn>
  ```
  The mutant was restored exactly; the test passed again. This mutant failure is the recorded red.
- green: added internal `bool _disposed = false;` field and set `_disposed = true` at the start of `dispose()` in `lib/src/in_app_webview/headless_in_app_webview.dart`. Full umbrella suite `flutter test` -> **187 passed** (was 186; +1 new test), no regressions. The `dispose()` forwarding itself was unchanged.
- refactor: none needed — the new field is the only change; the test reuses the inline-fake style of the existing `headless_dispose_test.dart` (`_FakeHeadlessPlatform extends PlatformHeadlessInAppWebView` via `.implementation(params)`, recording `disposeCount` and the forwarded `isKeepAlive`).
- class: TEST_FIRST (test written before implementation; red proven via mutant because the observable forwarding already held, and the new internal flag is a state change not directly observable without the U3 guard).
- note: U1's "internal disposed flag" is verified indirectly — the field is added here and its observable effect (idempotency on a second dispose) is the subject of U3. The pre-existing `test/headless_dispose_test.dart` still asserts a second dispose reaches the platform (count == 2); that test captures pre-feature behavior and will be reconciled as its own step when the U3 guard is added.
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 4 — U3 (test-first, real red)

- test: `test/headless_dispose_guard_test.dart` — `U3: a second dispose() call is a no-op (idempotent)`
- red command: `flutter test test/headless_dispose_guard_test.dart --plain-name "U3: a second dispose() call is a no-op (idempotent)"`
- red evidence (real assertion failure, expected vs actual):
  ```
  00:00 +0 -1: ... U3: a second dispose() call is a no-op (idempotent) [E]
    Expected: <1>
      Actual: <2>
    test/headless_dispose_guard_test.dart:49:9  main.<fn>.<fn>
  ```
  The current `dispose()` has no guard, so a second call reaches `platform.dispose()` again (count == 2).
- green: added an early-return idempotency guard to `dispose()` in `lib/src/in_app_webview/headless_in_app_webview.dart`:
  ```dart
  Future<void> dispose({bool isKeepAlive = false}) async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await platform.dispose(isKeepAlive: isKeepAlive);
  }
  ```
  Full umbrella suite `flutter test` -> **188 passed** (was 187; +1 new test), no regressions.
- reconciliation (Hard Rule 4, genuinely-wrong-test step): implementing the guard broke the pre-existing `test/headless_dispose_test.dart`, whose second assertion (`expect(platform.disposeCount, 2)`) captured the obsolete pre-feature no-guard behavior. That test was written test-after to document the broken state; spec 013 explicitly restores the idempotency guard. The assertion was corrected to `expect(platform.disposeCount, 1)` with an updated comment — aligning the obsolete test to the feature's actual intent, not weakening it. No test was deleted or skipped.
- refactor: none needed — the guard is the minimal sufficient change and reads like the surrounding delegation.
- class: TEST_FIRST (test written and observed failing before the guard existed; real red, not a mutant check).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 5 — U6 (test-first with deliberate-mutant proof)

- test: `test/headless_dispose_guard_test.dart` — `U6: concurrent dispose() calls invoke platform.dispose at most once`
- red command: `flutter test test/headless_dispose_guard_test.dart --plain-name "U6: concurrent dispose() calls invoke platform.dispose at most once"`
- red evidence (deliberate-mutant check): the test passed on first run because the synchronous `if (_disposed) return; _disposed = true;` guard already serializes concurrent calls atomically (no `await` between the check and the set, so the second and third calls observe `_disposed == true` and return). To prove the test has teeth, the guard's early-return was temporarily removed so `dispose()` always reached `platform.dispose()`. The test then failed:
  ```
  00:00 +0 -1: ... U6: concurrent dispose() calls invoke platform.dispose at most once [E]
    Expected: <1>
      Actual: <3>
    test/headless_dispose_guard_test.dart:65:9  main.<fn>.<fn>
  ```
  The guard was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change needed beyond the guard already added in Cycle 4 (the synchronous flag check is the serialization mechanism). Full umbrella suite `flutter test` -> **189 passed** (was 188; +1 new test), no regressions.
- refactor: none needed.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the existing guard already satisfied the behavior).
- note: the behavior is satisfied by the U3 guard's synchronous atomic check; U6's test locks that contract in for concurrent callers.
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 6 — U4 (test-first with deliberate-mutant proof)

- test: `test/headless_dispose_guard_test.dart` — `U4: dispose(isKeepAlive: true) forwards true to platform.dispose`
- red command: `flutter test test/headless_dispose_guard_test.dart --plain-name "U4: dispose(isKeepAlive: true) forwards true to platform.dispose"`
- red evidence (deliberate-mutant check): the test passed on first run because `dispose()` already forwards the `isKeepAlive` argument to `platform.dispose(isKeepAlive: isKeepAlive)`. To prove the test has teeth, `platform.dispose(isKeepAlive: isKeepAlive)` was temporarily edited to `platform.dispose(isKeepAlive: false)`. The test then failed:
  ```
  00:00 +0 -1: ... U4: dispose(isKeepAlive: true) forwards true to platform.dispose [E]
    Expected: true
      Actual: <false>
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing forwarding; full umbrella suite `flutter test` -> **190 passed** (was 189; +1 new test), no regressions.
- refactor: none needed.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the forwarding already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 7 — U14 (test-first with deliberate-mutant proof)

- test: `test/in_app_localhost_server_dispose_test.dart` — `U14: dispose() on a running server closes it and marks it disposed`
- red command: `flutter test test/in_app_localhost_server_dispose_test.dart --plain-name "U14: dispose() on a running server closes it and marks it disposed"`
- red evidence (deliberate-mutant check): the test passed on first run because `InAppLocalhostServer.dispose()` already calls `close()` when `isRunning()`. To prove the test has teeth, the `if (isRunning())` guard around the fire-and-forget `close()` was temporarily changed to `if (false)`. The test then failed:
  ```
  00:00 +0 -1: ... U14: dispose() on a running server closes it and marks it disposed [E]
    Expected: <1>
      Actual: <0>
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing stop-on-running logic; full umbrella suite `flutter test` -> green at 191 (was 190; +1 new test), no regressions.
- refactor: none needed — reused the `_FakePlatformLocalhostServer` fake from the U15 test in the same file.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the stop-on-running logic already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 8 — U16 (test-first with deliberate-mutant proof)

- test: `test/in_app_localhost_server_dispose_test.dart` — `U16: a second dispose() call on the server is a no-op (idempotent)`
- red command: `flutter test test/in_app_localhost_server_dispose_test.dart --plain-name "U16: a second dispose() call on the server is a no-op (idempotent)"`
- red evidence (deliberate-mutant check): the test passed on first run because `InAppLocalhostServer.dispose()` already has the `if (_disposed) return;` guard. To prove the test has teeth, the guard was temporarily removed so `dispose()` always reached `close()`. The test then failed:
  ```
  00:00 +0 -1: ... U16: a second dispose() call on the server is a no-op (idempotent) [E]
    Expected: <1>
      Actual: <2>
    close() must not be called again by a second dispose()
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing idempotency guard; full umbrella suite `flutter test` -> green at 192 (was 191; +1 new test), no regressions.
- refactor: none needed — reused the `_FakePlatformLocalhostServer` fake from the U15/U14 tests in the same file.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the guard already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 9 — U17 (test-first with deliberate-mutant proof)

- test: `test/in_app_localhost_server_dispose_test.dart` — `U17: dispose(isKeepAlive: true) is accepted but has no effect on server behavior`
- red command: `flutter test test/in_app_localhost_server_dispose_test.dart --plain-name "U17: dispose(isKeepAlive: true) is accepted but has no effect on server behavior"`
- red evidence (deliberate-mutant check): the test passed on first run because `InAppLocalhostServer.dispose()` ignores `isKeepAlive` (calls `close()` whenever `isRunning()`). To prove the test has teeth, the close condition was temporarily changed from `if (isRunning())` to `if (isRunning() && !isKeepAlive)` so `keepAlive: true` would suppress `close()`. The test then failed:
  ```
  00:00 +0 -1: ... U17: dispose(isKeepAlive: true) is accepted but has no effect on server behavior [E]
    Expected: <1>
      Actual: <0>
    close() must still be called exactly once; keepAlive must not suppress it
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing no-op treatment of `isKeepAlive`; full umbrella suite `flutter test` -> green at 193 (was 192; +1 new test), no regressions.
- refactor: none needed — reused the `_FakePlatformLocalhostServer` fake from the U15/U14/U16 tests in the same file.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the behavior already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 10 — U8 (test-first with deliberate-mutant proof)

- test: `test/in_app_webview_dispose_test.dart` — `U8: InAppWebViewController.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true)`
- red command: `flutter test test/in_app_webview_dispose_test.dart --plain-name "U8: InAppWebViewController.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true)"`
- red evidence (deliberate-mutant check): the test passed on first run because `InAppWebViewController.dispose()` already forwards `isKeepAlive` to `platform.dispose()`. To prove the test has teeth, the forwarding was temporarily changed from `platform.dispose(isKeepAlive: isKeepAlive)` to `platform.dispose(isKeepAlive: false)`. The test then failed:
  ```
  00:00 +0 -1: ... U8: InAppWebViewController.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true) [E]
    Expected: true
      Actual: <false>
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing forwarding; full umbrella suite `flutter test` -> green at 194 (was 193; +1 new test), no regressions.
- refactor: none needed — new `_FakePlatformController` fake follows the inline-fake style of `_FakeHeadlessPlatform`.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the forwarding already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 11 — U9 (test-first with deliberate-mutant proof)

- test: `test/in_app_webview_dispose_test.dart` — `U9: a later dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards false and fully releases`
- red command: `flutter test test/in_app_webview_dispose_test.dart --plain-name "U9: a later dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards false and fully releases"`
- red evidence (deliberate-mutant check): the test passed on first run because `InAppWebViewController.dispose()` forwards the actual `isKeepAlive` flag. To prove the test has teeth, the forwarding was temporarily changed from `platform.dispose(isKeepAlive: isKeepAlive)` to `platform.dispose(isKeepAlive: true)`. The test then failed:
  ```
  00:00 +0 -1: ... U9: a later dispose(isKeepAlive: false) ... forwards false and fully releases [E]
    Expected: false
      Actual: <true>
    the second (non-keepAlive) call must forward false
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing forwarding; full umbrella suite `flutter test` -> green at 195 (was 194; +1 new test), no regressions.
- refactor: none needed — reused the `_FakePlatformController` fake from the U8 test in the same file.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the behavior already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 12 — U11 (test-first with deliberate-mutant proof)

- test: `test/in_app_webview_dispose_test.dart` — `U11: InAppWebView.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true)`
- red command: `flutter test test/in_app_webview_dispose_test.dart --plain-name "U11: InAppWebView.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true)"`
- red evidence (deliberate-mutant check): the test passed on first run because `InAppWebView.dispose()` already forwards `isKeepAlive` to `platform.dispose()`. To prove the test has teeth, the forwarding was temporarily changed from `platform.dispose(isKeepAlive: isKeepAlive)` to `platform.dispose(isKeepAlive: false)`. The test then failed:
  ```
  00:00 +0 -1: ... U11: InAppWebView.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true) [E]
    Expected: true
      Actual: <false>
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing forwarding; full umbrella suite `flutter test` -> green at 197 (was 196; +2 new tests U11/U12 already present in file, U11 verified this cycle), no regressions.
- refactor: none needed — new `_FakePlatformWidget` fake follows the inline-fake style; reuses the flutter widgets import for the required `build`/`controllerFromPlatform` stubs.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the forwarding already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 13 — U12 (test-first with deliberate-mutant proof)

- test: `test/in_app_webview_dispose_test.dart` — `U12: a later InAppWebView.dispose(isKeepAlive: false) after keepAlive forwards false and fully releases`
- red command: `flutter test test/in_app_webview_dispose_test.dart --plain-name "U12: a later InAppWebView.dispose(isKeepAlive: false) after keepAlive forwards false and fully releases"`
- red evidence (deliberate-mutant check): the test passed on first run because `InAppWebView.dispose()` forwards the actual `isKeepAlive` flag. To prove the test has teeth, the forwarding was temporarily changed from `platform.dispose(isKeepAlive: isKeepAlive)` to `platform.dispose(isKeepAlive: true)`. The test then failed:
  ```
  00:00 +0 -1: ... U12: a later InAppWebView.dispose(isKeepAlive: false) ... forwards false and fully releases [E]
    Expected: false
      Actual: <true>
    the second (non-keepAlive) call must forward false
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing forwarding; full umbrella suite `flutter test` -> green at 197, no regressions.
- refactor: none needed — reused the `_FakePlatformWidget` fake from the U11 test in the same file.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the behavior already held).
- commit: not committed (working tree left dirty per `--no-commit` default).

## Cycle 14 — U2 (test-first with deliberate-mutant proof)

- test: `test/headless_dispose_guard_test.dart` — `U2: dispose() after run() forwards to platform.dispose(isKeepAlive: false) exactly once`
- red command: `flutter test test/headless_dispose_guard_test.dart --plain-name "U2: dispose() after run() forwards to platform.dispose(isKeepAlive: false) exactly once"`
- red evidence (deliberate-mutant check): the test passed on first run because `HeadlessInAppWebView.dispose()` forwards `isKeepAlive` to `platform.dispose()` regardless of run state (the same guard as U1). To prove the test has teeth, the forwarding was temporarily changed from `platform.dispose(isKeepAlive: isKeepAlive)` to `platform.dispose(isKeepAlive: true)`. The test then failed:
  ```
  00:00 +0 -1: ... U2: dispose() after run() forwards to platform.dispose(isKeepAlive: false) exactly once [E]
    Expected: false
      Actual: <true>
    default dispose forwards isKeepAlive: false
  ```
  The implementation was restored exactly and the test passed again. This mutant failure is the recorded red.
- green: no source change beyond the existing forwarding; full umbrella suite `flutter test` -> green at 198 (was 197; +1 new test), no regressions. The `_FakeHeadlessPlatform` gained a `run()`/`isRunning()` stub so the test can drive a started headless view without invoking the base `UnimplementedError` default.
- refactor: none needed.
- class: TEST_FIRST (test written before confirming the implementation; red proven via mutant because the behavior already held).
- commit: not committed (working tree left dirty per `--no-commit` default).
## Cycle 15 — Acceptance reconciliation + U5/A8 conflict (no new tests)

- scope: outside-in close-out. All inner-loop unit behaviors are now DONE/GREEN. The acceptance behaviors A1-A9 are driven through the same public wrapper entry points (`HeadlessInAppWebView.dispose`, `InAppWebViewController.dispose`, `InAppWebView.dispose`, `InAppLocalhostServer.dispose`) that the unit tests already exercise, because no `integration_test/` harness exists in this package (per test-list Out of scope). Each acceptance id was therefore reconciled to the unit test(s) that satisfy its criterion rather than a separate runner.
- red command: n/a (reconciliation, not a new cycle).
- green: no source or test change; full umbrella suite `flutter test` -> green at 198, no regressions.
- reconciliation mapping (acceptance id -> covering unit test file):
  - A1 -> U1 (`test/headless_dispose_guard_test.dart`)
  - A2 -> U3 (`test/headless_dispose_guard_test.dart`)
  - A3 -> U6 (`test/headless_dispose_guard_test.dart`)
  - A4 -> `test/disposable_pattern_test.dart` (already DONE in Cycle 2)
  - A5 -> U8 (controller), U11 (webview), U17 (server signature) in `test/in_app_webview_dispose_test.dart` / `test/in_app_localhost_server_dispose_test.dart`
  - A6 -> U14/U15/U16 (`test/in_app_localhost_server_dispose_test.dart`)
  - A9 -> U9 (controller) and U12 (webview) (`test/in_app_webview_dispose_test.dart`)
- ESCAPE HATCH (genuine requirement conflict): U5 and A8 ask for `dispose(false)` AFTER `dispose(true)` to re-reach the platform and "fully release". This is directly contradicted by FR-008's idempotency guard (U3/U6), which makes any second `dispose()` return early without calling the platform. Satisfying U5/A8 would require removing the guard that U3/A2/A3 depend on. No test was written that would contradict the guard, and the guard was not weakened. U5 and A8 are left BLOCKED; the conflict is recorded in the test-list and reported to the user for a spec decision.
- A7 (keepAlive retains native view) is device-only: native-view retention is platform behavior not observable at the wrapper level with a fake platform, and no `integration_test/` harness exists. Left PENDING (not a unit-testable behavior), reported as such.
- class: RECONCILIATION (acceptance rows closed by mapping to existing DONE unit tests) + ESCAPE_HATCH (U5/A8 conflict).
- commit: not committed (working tree left dirty per `--no-commit` default).
