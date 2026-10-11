---
feature: 004-rewrite-extract-module
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 9
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked # feature targets zikzak_inappwebview_module (and the umbrella adapter/gate); both blocked by zuraffa pub-cache corruption — run `flutter pub cache repair`
---

# Test List: Extract Value-Add into Module (Ports & Services)

> **Inner loop skipped (outer-only).** `plan.md` is absent for this feature, so no
> component-level unit behaviors (`U*`) are derived here. The 9 acceptance
> scenarios from `spec.md` plus the structural/contract/parity acceptance criteria
> (SC-001, FR-001, SC-005, SC-006) are captured as outer-loop acceptance
> behaviors (`A*`). The edge cases in `spec.md` are listed under "Invariants and
> edge cases still to place" and must be placed onto component files once
> `plan.md` exists (they become `U*` unit behaviors then).

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works
end to end through its real entry point — the module package's public ports and
services (`WebViewSessionFactory`, `WebViewPool`, `CaptureSource`,
`CassetteEngine`, `DialogueDismissPort`, `RecipePort`, `NavigationTrackerPort`)
and the umbrella structural gate. All traces resolve to real `FR-*` / `SC-*` ids
in `spec.md`.

| id  | behavior                                                                                                                       | traces            | kind             | state    | test |
| --- | ------------------------------------------------------------------------------------------------------------------------------ | ----------------- | ---------------- | -------- | ---- |
| A1  | Requesting a session for a domain returns a handle with domain affinity, reusing an idle same-domain session when one is free   | FR-004, SC-002    | example          | PENDING  |      |
| A2  | Exceeding the pool's memory-pressure threshold disposes the lowest-priority / longest-idle sessions and frees their resources    | FR-004, SC-002    | example          | PENDING  |      |
| A3  | Releasing or disposing an acquired session returns it to the pool or tears it down with no leaked handle                        | FR-009, SC-002    | example          | PENDING  |      |
| A4  | Exhausting a finite capture budget stops capture and emits a salvage flush of all buffered entries before teardown              | FR-005, SC-003    | example          | PENDING  |      |
| A5  | A stopOn predicate returning true mid-stream ends capture early and returns accumulated entries without processing further      | FR-005            | example          | PENDING  |      |
| A6  | Raw events carrying auth-flow tokens are redacted at the capture boundary and the distiller receives only redacted Sightings    | FR-005, FR-008, SC-003 | example     | PENDING  |      |
| A7  | Replay mode serves responses from the cassette and makes zero network requests                                                 | FR-006, SC-004    | example          | PENDING  |      |
| A8  | Replaying the same cassette twice produces byte-identical outputs (deterministic replay)                                       | FR-010, SC-004    | example          | PENDING  |      |
| A9  | DialogueDismissPort, RecipePort, and NavigationTrackerPort run record/replay entirely through their port boundaries without importing plugin internals | FR-003, FR-014, SC-007 | example | PENDING | |
| A10 | An automated structural gate confirms zero value-add / intelligence logic remains in the plugin core                           | FR-011, SC-001    | example          | PENDING  |      |
| A11 | The module declares the seven value-add ports as abstract interfaces importable by module tests without pulling in plugin code  | FR-001            | example          | PENDING  |      |
| A12 | The distiller post-processor slot passes all Sighting-contract assertions when validated by a stub implementation              | FR-007, FR-013, SC-005 | contract     | PENDING  |      |
| A13 | Existing plugin tests for the moved features pass unchanged after being re-pointed at the module equivalents                    | FR-012, SC-006    | example          | PENDING  |      |

## Inner loop: unit behaviors

**Skipped.** `plan.md` is absent (see note at top). No component files are
enumerated, so no `U*` unit behaviors are derived in this plan. The edge cases
below are the candidate unit behaviors and will be placed here once `plan.md`
exists.

## Invariants and edge cases still to place

Edge cases called out in `spec.md` that belong to the feature but have no home
component yet (no `plan.md`). Each must become a `U*` line in the Inner loop
above, or be dropped with a reason, before the feature is done.

- Replay references a cassette asset that is not present: the engine fails
  deterministically and MUST NOT fall back to the network (relates to A7/A8).
- Capture budget of zero: capture yields immediately with a single salvage flush
  and processes no events (boundary of A4).
- Memory pressure during an active capture: the pool evicts sessions only after
  the capture service salvages its buffer (interaction of A2/A3/A4).
- A novel auth scheme not matched by redaction patterns: defense in depth applies,
  the distiller is a second redaction layer, and no raw secret leaves the capture
  service (relates to A6).
- The distiller stub returns a malformed `Sighting`: the distiller contract test
  must fail loudly rather than silently passing bad data downstream (relates to A12).
- Module unit tests run without the plugin present: fakes satisfy the ports and
  plugin internals are never imported by module tests (relates to A9/A11).
- A port is invoked before its adapter is registered: the module surfaces a clear
  "adapter not registered" error rather than a null failure (relates to A9/FR-014).

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- The real dart_web_scraper#79 distiller implementation: lands separately (see
  `spec.md` Assumption); only a stub satisfies the distiller slot contract here
  (FR-013), so the real integration is out of scope.
- The umbrella split map (#241) and the zuraffa#389 package-mode module
  structure: named as completed preconditions in `spec.md`, not produced by this
  feature.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, for the
relevant package `zikzak_inappwebview_module` (run from that package's own
directory — `cwd: zikzak_inappwebview_module`). The umbrella adapter/gate
commands are identical in shape but operate from `cwd: zikzak_inappwebview`.

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

> Both `zikzak_inappwebview_module` and `zikzak_inappwebview` are currently
> **blocked** by zuraffa pub-cache corruption (the `zuraffa-6.0.0` extension
> sources are missing from the pub cache). Run `flutter pub cache repair` before
> the loop can execute; the default stack `zikzak_inappwebview_platform_interface`
> runs green (300 tests) in the meantime.
