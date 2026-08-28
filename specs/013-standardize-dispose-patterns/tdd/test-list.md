---
feature: 013-standardize-dispose-patterns # spec-kit feature directory name
loop: outside-in # acceptance tests first, through the real wrapper entry points
profile: .specify/memory/tdd-profile.md # stack profile the commands must read
spec_criteria: 9 # acceptance scenarios across the 3 user stories in spec.md
planned_at: f349d421 # short SHA the list was derived from
updated_at: f349d421 # short SHA of the last change to this file
suite_baseline: blocked # umbrella zikzak_inappwebview is blocked: zuraffa pub-cache corruption — run `flutter pub cache repair`
---

# Test List: Standardize Dispose Patterns Across Wrapper Classes + HeadlessInAppWebView Double-Dispose Guard

> **Loop scope note:** `plan.md` is ABSENT for this feature, so the inner loop
> (unit behaviors grouped by component) is **skipped** — this is an **outer-only**
> plan. The 9 acceptance scenarios from `spec.md` become acceptance behaviors
> `A1`–`A9`. Three distinct, user-observable edge cases from the spec's "Edge
> Cases" section (not already subsumed by a scenario) are promoted to `A10`–`A12`
> so the list is complete; all trace to real `FR-*` / `SC-*` ids in `spec.md`.
> No `U*` rows are produced.

## Outer loop: acceptance behaviors

One per acceptance criterion (scenario) in `spec.md`, observable through the real
wrapper entry points (`HeadlessInAppWebView`, `InAppWebViewController`,
`InAppWebView`, `InAppLocalhostServer`). Assertions run against hand-written
platform fakes (per `tdd-profile.md`): call counts and state flags, not live
rendering.

| id  | behavior | traces | kind | state | test |
| --- | --- | --- | --- | --- | --- |
| A1 | Given a `HeadlessInAppWebView` whose `run()` was never called, `dispose()` releases the underlying platform resources exactly once and leaves no web view running. | FR-004, SC-002 | example | DONE | `zikzak_inappwebview/test/headless_dispose_test.dart::HeadlessInAppWebView.dispose is idempotent (double-dispose guard)` |
| A2 | Given a started `HeadlessInAppWebView`, `dispose()` followed by a second `dispose()` is a no-op and the platform `dispose()` is invoked only once. | FR-004, FR-008, SC-002 | example | DONE | `zikzak_inappwebview/test/headless_dispose_test.dart::HeadlessInAppWebView.dispose is idempotent (double-dispose guard)` |
| A3 | Given a `HeadlessInAppWebView` in any lifecycle state, concurrent or repeated `dispose()` calls never throw and never leak a partially-disposed instance. | FR-008, SC-002, SC-006 | example | PENDING | |
| A4 | The public wrappers `InAppWebViewController`, `InAppWebView`, `InAppLocalhostServer`, and `HeadlessInAppWebView` are each statically assignable to `Disposable` (`declares implements Disposable`). | FR-002, SC-001 | example | DONE | `zikzak_inappwebview/test/disposable_pattern_test.dart::wrapper classes implement Disposable` |
| A5 | Given any disposable wrapper, invoking its `dispose()` forwards to the corresponding platform `dispose({bool isKeepAlive = false})`, preserving the caller's `isKeepAlive` value and the same default-parameter shape. | FR-006, SC-004 | example | PENDING | |
| A6 | Given an `InAppLocalhostServer`, calling `dispose()` stops the server if running, releases its resources, and a second call is a safe idempotent no-op. | FR-003, SC-003 | example | PENDING | |
| A7 | Given a controller created with an `InAppWebViewKeepAlive`, `dispose(isKeepAlive: true)` releases Dart-side references while the native web view remains usable. | FR-007, SC-005 | example | PENDING | |
| A8 | Given the same keep-alive controller, a subsequent `dispose()` without keep-alive fully releases the native web view. | FR-007, SC-005 | example | PENDING | |
| A9 | Given any disposable wrapper, the `isKeepAlive` default value (`false`) and its interpretation are identical across all implementations (uniform `dispose({bool isKeepAlive = false})` signature). | FR-005, FR-007, SC-004 | example | PENDING | |
| A10 | Given an `InAppLocalhostServer` that was never `start()`ed, `dispose()` is safe and idempotent (no error, no server left running). | FR-003, SC-003 | example | PENDING | |
| A11 | Given an `InAppLocalhostServer` whose `close()` is still in flight, `dispose()` does not surface the in-flight close Future as an unhandled error and still marks the instance disposed. | FR-003, FR-009 | example | PENDING | |
| A12 | Given a wrapper forwarding `dispose()` to a platform object that is already disposed, the call is tolerated (no crash) and idempotent. | FR-009 | example | PENDING | |

## Inner loop: unit behaviors

**Skipped.** `plan.md` does not exist for this feature, so there is no component
list to attach unit behaviors to. All behavior is expressed at the acceptance
(outer) level above. When `plan.md` is added, re-run `/speckit.tdd.plan` to emit
`U1…` rows grouped by component file path, including `kind: characterization`
BASELINE rows for any changed component that currently lacks tests.

## Invariants and edge cases still to place

All spec edge cases are already represented as `A*` rows above (dispose-before-run
→ A1; double-dispose → A2; concurrent → A3; keepAlive+double-dispose → A7/A8;
localhost-not-started → A10; localhost-async-shutdown → A11; already-disposed
platform → A12). No unplaced items remain for the outer loop.

## Out of scope

- Live native web-view rendering: cannot be exercised in the Dart test runner
  (native views); tests assert call counts / state flags via platform fakes, per
  spec §Assumptions.
- Mutation / property-based testing: no `mutation_test` or `glados`/`fast_check`
  in any `pubspec.lock` (see `tdd-profile.md`), so invariants are captured as
  `kind: example` sampled at boundaries, not property tests.
- The `Disposable` interface definition itself: assumed to already exist in the
  platform-interface package (spec §Assumptions); this feature uses it, does not
  redefine it.
- `zikzak_inappwebview_module` / example `integration_test` acceptance paths: need
  a device/emulator and are not part of this feature's unit surface.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` (the `zikzak_inappwebview`
umbrella stack) at planning time, so this file is readable on its own:

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

> **Baseline caveat:** the umbrella `zikzak_inappwebview` suite is **blocked** by
> the corrupted `zuraffa` package in the pub cache (compile/load crash, not a red
> suite). These commands will not run until `flutter pub cache repair` is executed.
> `A1`, `A2`, `A4` are marked DONE because the existing tests
> (`headless_dispose_test.dart`, `disposable_pattern_test.dart`) assert those
> behaviors and the source already implements the contract — but this is based on
> the test files' presence, not a live green run (the suite could not be executed).
