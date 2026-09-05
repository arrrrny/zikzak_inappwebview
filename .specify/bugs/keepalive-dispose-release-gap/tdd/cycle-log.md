# TDD Cycle Log: keepalive-dispose-release-gap (bug #295)

Toolchain: Dart 3.13.2 / Flutter 3.47.2 stable. All red/green evidence below is
from real runs against the working tree; mutant reds are deliberate-mutant
checks (no mutation tool in stack profile), matching the convention of the
spec 013 audit.

## Cycle 1 — U5 (headless keepAlive release), TEST_FIRST

- behavior: `dispose(isKeepAlive: false)` after `dispose(isKeepAlive: true)`
  must call `platform.dispose(isKeepAlive: false)` exactly once (FR-007) while
  plain double-dispose stays a no-op (FR-008).
- test added: `test/headless_dispose_guard_test.dart` U5 (plus U5b/U5c locks).
- red command: `flutter test test/headless_dispose_guard_test.dart test/in_app_webview_dispose_test.dart test/in_app_localhost_server_dispose_test.dart`
- red evidence (REAL, pre-fix tree, 2026-09-05):
  ```
  Expected: <2>
    Actual: <1>
  00:01 +19 -2: Some tests failed.
  Failing tests:
    .../headless_dispose_guard_test.dart: ... U5: dispose(isKeepAlive: false)
    after dispose(isKeepAlive: true) forwards false and fully releases (bug #295)
    .../in_app_webview_dispose_test.dart: ... U9: a later dispose(isKeepAlive:
    false) after dispose(isKeepAlive: true) forwards false and fully releases
  ```
  U5 failed exactly as the assessment predicted: the second (release) dispose
  was swallowed by the single-boolean `_disposed` guard and never reached the
  platform. All 19 other tests — including every existing FR-008 idempotency
  test (U1, U2, U3, U4, U6) — stayed green, isolating the failure to the
  keepAlive-release transition.
- green: three-state `DisposeLifecycle` guard implemented
  (`lib/src/dispose_lifecycle.dart` + headless/controller/server wrappers).
  Same command after the fix: `00:02 +23: All tests passed!` (23 tests across
  the three dispose suites at that point, before the fake correction in
  Cycle 3; 21 + 3 lock tests total after).
- refactor: none needed; guard check-and-set stays synchronous before the
  platform await, preserving U6 concurrency serialization.
- class: TEST_FIRST.
- commit: a0c22131 (test and source change in the same commit).

## Cycle 2 — U9 (controller keepAlive release regression from #227), TEST_FIRST

- behavior: `InAppWebViewController.dispose(isKeepAlive: true)` then
  `dispose(isKeepAlive: false)` forwards both calls (U9, existing test).
- red evidence (REAL): U9 was already red on the untouched baseline BEFORE any
  fix (first command run in the session):
  ```
  00:00 +1 -1: ... U9: a later dispose(isKeepAlive: false) after
  dispose(isKeepAlive: true) forwards false and fully releases [E]
    Expected: <2>
      Actual: <1>
  ```
  Root cause: the double-dispose guard added to the controller in #227
  (commit 8a37ab4b) re-introduced the single-boolean swallow on a path whose
  spec 013 contract (U9) requires keepAlive → plain-release forwarding. This
  is the controller-side face of bug #295 ("controller/widget paths must be
  checked for consistent keepAlive behavior").
- green: same three-state guard applied to `InAppWebViewController.dispose`.
  U8, U9, U11, U12 all green after; widget path (U11/U12) untouched — it
  forwards directly with no guard and needed no change.
- refactor: none.
- class: TEST_FIRST (existing test, real red, fix committed in a0c22131).
- commit: a0c22131.

## Cycle 3 — FR-008 locks (U5b, U5c, U9b, U9c, U9d, A8-server, A8-server-b), GUARD

- behavior: pin the non-regression half of the fix — identical repeats stay
  no-ops (keepAliveHeld→keepAliveHeld; released→any) on headless, controller,
  and server.
- red evidence: none possible pre-fix for the repeat/terminal locks — the old
  single-boolean guard blocked strictly more than the new guard, so these
  tests pass both before and after by construction. Their strength is proven
  by deliberate mutants instead (see Mutant session): M2 flips U5b, M3 flips
  U5c and U3.
- test-design correction recorded honestly: A8-server initially failed after
  the fix (`Expected: <1> / Actual: <2>`) because the fake platform did not
  model the real contract that `close()` stops the server (a closed server is
  not running). The fake was corrected to flip `isRunningValue` in `close()`,
  after which the test asserts exactly one close across the keepAlive →
  plain-release sequence. This was a fake-fidelity fix, not an implementation
  red; recorded here so the audit trail is not misleading.
- green: `00:02 +24: All tests passed!` across the five dispose suites.
- class: GUARD (characterization/lock; mutant-verified where a mutant exists).
- commit: a0c22131.

## Mutant session (deliberate mutants, all caught, 0 survivors)

Run at a0c22131. Each mutant was applied to the working tree, tested, and
reverted (`git checkout --`); tree verified clean afterwards.

| Mutant | Change | Flipped test | Output |
| ------ | ------ | ------------ | ------ |
| M1 | headless guard reverted to single-boolean (`!= notDisposed` return) | U5 | `Expected: <2> / Actual: <1>` — Some tests failed |
| M2 | headless: drop the keepAliveHeld identical-repeat block (only `released` blocks) | U5b | `Expected: <1> / Actual: <2>` — Some tests failed (U6 still passed, as expected: plain concurrent disposes are unaffected by the keepAlive-repeat term) |
| M3 | headless: `released` non-terminal for keepAlive dispose (only `keepAliveHeld && isKeepAlive` blocks) | U5c and U3 | `Expected: <1> / Actual: <2>` — both tests failed |
| M4 | controller guard reverted to single-boolean | U9 | `Expected: <2> / Actual: <1>` — Some tests failed |

Mutation score on the guard logic (deliberate sampling): 4/4 caught, 0
survived.
