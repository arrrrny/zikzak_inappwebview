---
feature: 012-lifecycle-integration-tests
loop: outside-in # acceptance tests observed through the real entry point (InAppWebView widget / InAppWebViewController round-trips), not a unit beneath it
profile: .specify/memory/tdd-profile.md
spec_criteria: 12 # 12 numbered acceptance scenarios in spec.md (3 per User Story)
planned_at: f349d421
updated_at: f349d421
suite_baseline: green # default stack (zikzak_inappwebview_platform_interface) green; this feature's suites run from umbrella/example/integration_test (needs device/emulator) and per-platform packages (android/ios/macos/linux/windows, all green) — see note below
---

# Test List: WebView Lifecycle Integration Tests

> **Inner loop: SKIPPED (outer-only).** `plan.md` is absent for this feature, so no
> component list exists to slice into `U` unit behaviors. Only the outer loop
> (acceptance behaviors, one per acceptance criterion) is produced. Re-run
> `/speckit.tdd.plan` after `plan.md` is written if unit-level coverage is wanted.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md` (the 12 numbered "Acceptance Scenarios").
Each stays red until the lifecycle regression net works end to end through the real
entry point (`InAppWebView` / `InAppWebViewController`). These are integration tests
that exercise the current zorphy-based platform interface (FR-005 / SC-006).

| id  | behavior                                                                                                                  | traces              | kind    | state   | test |
| --- | ------------------------------------------------------------------------------------------------------------------------- | ------------------- | ------- | ------- | ---- |
| A1  | An `InAppWebView` that loaded `https://example.com` returns a non-null, valid URL from `controller.getUrl()` after a hot restart, without throwing | SC-001, FR-001, FR-006 | example | PENDING |      |
| A2  | After a hot restart, `controller.evaluateJavascript(source: '1 + 1')` resolves to `2` (or its string form) instead of a channel error | SC-001, FR-006      | example | PENDING |      |
| A3  | On a hot restart fired mid-navigation, `onLoadStop` fires exactly once for the final load with the correct URL once loading completes after restart | SC-001, FR-006      | example | PENDING |      |
| A4  | After an orientation/configuration-change `Activity` recreation, no `MissingPluginException` is thrown and `controller.getUrl()` still resolves | SC-002, FR-002, FR-007 | example | PENDING |      |
| A5  | After background→foreground transition, the plugin's method channels remain registered and controller calls (e.g. `getUrl`/`evaluateJavascript`) succeed | SC-002, FR-002, FR-007 | example | PENDING |      |
| A6  | After `Activity` recreation, the re-attached native view preserves/restores content rather than leaving the WebView blank or detached | SC-002, FR-002      | example | PENDING |      |
| A7  | A `FlutterFragment` with no attached `Activity` completes plugin (method-channel) registration without throwing | SC-003, FR-003, FR-008 | example | PENDING |      |
| A8  | With the plugin registered without an `Activity`, creating a controller and later attaching an `Activity` binds lifecycle callbacks without a prior null-`Activity` failure | SC-003, FR-008      | example | PENDING |      |
| A9  | A `FlutterFragment` detached before an `Activity` is available runs plugin teardown without raising an exception from host-referencing cleanup | SC-003, FR-003      | example | PENDING |      |
| A10 | WebView2 initialises without throwing an unhandled exception when configured with a read-only user-data directory | SC-004, FR-004, FR-009 | example | PENDING |      |
| A11 | A navigation to a valid URL on a WebView initialised against a read-only directory completes (or fails with a catchable error) instead of crashing the process | SC-004, FR-004      | example | PENDING |      |
| A12 | When WebView2 cannot write the default location but a fallback writable directory is available, the plugin selects it and the WebView stays functional | SC-004, FR-004      | example | PENDING |      |

## Invariants and edge cases still to place

Cross-cutting criteria that are process/contract constraints, not standalone observable
acceptance behaviors, so they are tracked here rather than as separate `A` lines:

- **Per-instance channel re-binding (edge case "Multiple WebViews during recreation").**
  Several controllers existing simultaneously must not clobber each other's channel on
  recreation. Belongs to A4/A6 once the Android test harness exists; assert distinct
  controller round-trips survive a single recreation cycle.
- **True hot restart vs. full restart (edge case).** Tests must distinguish a VM-reuse hot
  restart from a full restart to avoid false negatives (A1/A2/A3).
- **zorphy platform interface (FR-005 / SC-006).** All of A1–A12 must drive platform
  channel calls through the post-#226 zorphy-based `PlatformInterface`, not the legacy
  plugin API. Verified by construction in each A test's harness.
- **CI determinism (FR-010 / SC-005).** Each lifecycle test must run through the standard
  `integration_test` (or platform-equivalent) harness with deterministic pass/fail; this is
  a wiring concern, surfaced in `tasks.md`, not a separate behavior assertion.

## Out of scope

- **Unit (inner-loop) behaviors**: no `plan.md`, so `U` lines are intentionally absent
  (outer-only per workflow step 3).
- **Mutation / property tests**: the stack profile records no mutation or property tooling
  in any `pubspec.lock`; invariants above are noted as sampled examples at their boundaries.
- **New product features**: per spec Assumptions, these four scenarios are regression nets
  asserting current correct behavior, not introducing functionality.
- **Non-Android lifecycle hosts (iOS/macOS/Linux recreation)**: spec scopes activity
  recreation to Android (P2) and `FlutterFragment` registration to Android (P3); equivalent
  desktop/macOS recreation is not required by the spec.
- **Real `Program Files` path on a packaged Windows install**: the spec asks only for an
  emulated read-only user-data/cache directory (A10–A12), not a true installer scenario.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time (default stack
`zikzak_inappwebview_platform_interface`). Run each **from the package directory that owns
the test**: `zikzak_inappwebview/example` for the hot-restart / activity-recreation /
`FlutterFragment` integration tests (device/emulator required, not exercised in this
baseline), and the per-platform package dir for the WebView2 Windows test
(`zikzak_inappwebview_windows`).

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

## Notes and deviations

- `suite_baseline: green` reflects the default (platform_interface) stack. The umbrella
  `zikzak_inappwebview` and `zikzak_inappwebview_module` suites are **blocked** by the
  zuraffa pub-cache corruption (run `flutter pub cache repair`); the umbrella's
  `example/integration_test` (where A1–A9 live) needs a real device/emulator and was not
  run. The integration tests are therefore PENDING by design, not because the suite is red.
- All 12 acceptance behaviors are PENDING: none is covered by an existing passing test
  (the existing e2e/integration layer was not exercised, per the profile). No `DONE` claim
  is made for any behavior.
