---
feature: 003-rewrite-umbrella-platform-core
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 9
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked
---

# Test List: Rewrite Umbrella — Thin Platform Core + Zuraffa v6 WebView Module

> **Inner loop skipped (outer-only).** `plan.md` is ABSENT for this feature, so no
> `U`-level unit behaviors are derived. Only the outer-loop acceptance behaviors
> below are planned. When a `plan.md` is added, re-run `/speckit.tdd.plan` to
> append the inner loop grouped by component file path.
>
> **Suite baseline is `blocked`, not red or green.** This feature clearly targets
> both the umbrella `zikzak_inappwebview` package and the new
> `zikzak_inappwebview_module` package; per the stack profile both are blocked by
> "zuraffa pub-cache corruption — run `flutter pub cache repair`". The default
> stack (`zikzak_inappwebview_platform_interface`, 300 passed / green) is NOT the
> target of this feature, so it is not used as the baseline.

## Outer loop: acceptance behaviors

One per acceptance criterion (the numbered "Acceptance Scenarios" in `spec.md`,
in user-story order). Each stays PENDING until the feature works end to end
through its real entry point (the split-map artifact, the `zfa`/`dart analyze`
tooling, the module-only consumer mission, or the automated grep gate). None is
covered by an existing passing unit test in the relevant package `test/` dirs
(the only matches for related terms live in `example/test/`, which is the
integration/acceptance layer that the profile marks `acceptance: null` / needs a
device).

| id  | behavior | traces | kind | state | test |
| --- | --- | --- | --- | --- | --- |
| A1 | An automated inventory over `zikzak_inappwebview/lib/src` finds every current value-add class listed exactly once in the published split map, each with a destination tier. | SC-001, FR-001 | example | PENDING | |
| A2 | A reviewer's import-graph check over the split map shows every module-side dependency resolves to a public plugin facade and none resolves into `platform_interface` internals. | SC-001, FR-002 | example | PENDING | |
| A3 | The merged split map is attached/linked to issue #241 and marked reviewed. | SC-001, FR-008 | example | PENDING | |
| A4 | Running `zfa package create` (zuraffa#389) with the in-repo naming decision yields a `zikzak_inappwebview_module` package laid out with the zuraffa v6 domain/data/module directories. | SC-002, FR-003 | example | PENDING | |
| A5 | The scaffolded module's DI registrar and engine module registration make `zfa build` complete without error and register the module with the engine. | SC-002, FR-003 | example | PENDING | |
| A6 | `dart analyze` run in the module package reports zero errors and zero warnings. | SC-002 | example | PENDING | |
| A7 | A plugin core version bump leaves the module compiling and the `browse`→`getHtml` mission passing without any change to the module's API usage. | SC-005, FR-004 | example | PENDING | |
| A8 | A consumer app importing only `zikzak_inappwebview_module` returns non-empty page HTML from the `browse`→`getHtml` mission on iOS, Android, and macOS. | SC-004, FR-007 | example | PENDING | |
| A9 | The module's import graph references only the plugin's public facades (controller, headless, raw capture-event stream) and never `platform_interface` internals. | SC-001, SC-003, FR-002, FR-004 | example | PENDING | |
| A10 | An automated grep gate over the plugin core package passes: no intelligence-layer identifiers (pool/VCR/dismiss/recipe/tracker/tools) remain except the explicitly permitted raw capture-event plumbing. | SC-003, FR-006 | example | PENDING | |

## Inner loop: unit behaviors

**Skipped.** No `plan.md` exists for this feature, so there are no components to
decompose into `U`-level unit behaviors. The table will be populated by a later
`/speckit.tdd.plan` run once the implementation plan is authored.

## Invariants and edge cases still to place

Behaviors that belong to the feature but have no home component yet (inner loop
is pending):

- The split map must assign each value-add class to **exactly one** tier — a class
  listed in both tiers, or in neither, is a failure (both sides of the
  "appears exactly once" boundary).
- The grep gate must fail when an intelligence-layer identifier appears, and pass
  when only the raw capture-event plumbing carve-out remains (both sides of the
  carve-out boundary).
- The module's public-API-only seam must hold even for a value-add class with a
  cyclic dependency on a core controller facade (seam must be inverted, not
  reached into).

## Out of scope

- **Consumer transition plan documentation (FR-008 re-point text, deprecation/
  re-export window):** a written deliverable, observable only as merged docs, not
  as a `flutter test`. Covered by the A3 linkage; the prose plan itself is not a
  unit test.
- **Re-homing in-flight issues #237–#240 (FR-009):** a process/issue-tracking
  deliverable (landing-zone change in each spec), not automatable as a unit test.
  Tracked outside this list; their specs are unchanged.
- **Follow-up decomposition detail (clean ports, zuraffa-native DDA store/usecase
  wiring, agent surface + cassette parity):** explicitly out of scope for this
  umbrella's first cut per `spec.md` Assumptions.
- **Per-platform native controller/MethodChannel behavior:** already exercised by
  the green `android/ios/macos/linux/windows` suites; not changed by this split.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time. Both
relevant stacks (`zikzak_inappwebview` umbrella and `zikzak_inappwebview_module`)
use identical commands but are **blocked** by the zuraffa pub-cache corruption —
run `flutter pub cache repair` before any of these will execute.

- Single test: `flutter test --plain-name "{name}"`
- File: `flutter test {file}`
- Suite: `flutter test`
- Coverage: `flutter test --coverage`

(No `mutation`, `property`, `approval`, or `contract` tooling exists in the repo
per the profile; invariants above are noted as `example` boundaries only.)
