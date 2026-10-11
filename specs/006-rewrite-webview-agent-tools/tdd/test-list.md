---
feature: 006-rewrite-webview-agent-tools
loop: outside-in # feature has a user-visible surface: `zfa make --agent` CLI, the generated `webview.*` tool set, and the cassette CI harness
profile: .specify/memory/tdd-profile.md
spec_criteria: 17 # 16 numbered acceptance scenarios across the 5 user stories + the redaction/version success criterion (SC-008 / FR-013), which has no dedicated scenario
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked # feature targets zikzak_inappwebview_module (generated tools) + umbrella zikzak_inappwebview; both blocked by zuraffa pub-cache corruption — run `flutter pub cache repair`
---

# Test List: Generated `webview.*` Agent Tools + Cassette Parity CI Gate

**Inner loop skipped (outer-only).** `plan.md` is absent for this feature, so no
`U*` unit behaviors and no characterization baselines are listed — only the outer
acceptance loop is planned. When `plan.md` is added, re-run `/speckit.tdd.plan` to
append the inner loop grouped by component file.

**Suite baseline: `blocked`.** This feature rewrites the agent surface of
`zikzak_inappwebview_module` and closes the umbrella `zikzak_inappwebview` issue
#241, both of which are blocked at planning time by the zuraffa pub-cache
corruption (see profile Notes). The default green stack
`zikzak_inappwebview_platform_interface` (300 passed, ~82s) is the runnable
baseline for any shared logic; the module/umbrella legs must be re-baselined
after `flutter pub cache repair` before their acceptance tests can execute.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works
end to end through its real entry point (`zfa make --agent` CLI, the generated
kernel registrable tool set, the cassette replay harness, or dws_playground
missions).

| id  | behavior                                                                                                                              | traces            | kind    | state    | test |
| --- | ------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | ------- | -------- | ---- |
| A1  | Running `zfa make --agent` in package mode over the module usecases emits exactly the §4.1 surface (the 11 `webview.*` tool names, no more, no fewer) | FR-001, FR-002, SC-001 | example | PENDING  |      |
| A2  | Inspecting the module source yields zero hand-written `webview.*` tool classes; only a registrar that references the generated symbols and registers them via the `McpToolProvider` SPI remains | FR-003, SC-001    | example | PENDING  |      |
| A3  | An agent kernel listing tools in the `webview` namespace enumerates all §4.1 tools and each is individually callable in-process after the generated set is registered | FR-003, SC-001    | example | PENDING  |      |
| A4  | A generated tool description documents session ids as opaque strings with continuation semantics and states which tools accept `newSession` | FR-004            | example | PENDING  |      |
| A5  | A `webview.browse` → `webview.intercept_browse` → `webview.execute_js` sequence with the `sessionId` from browse threaded through serves a single live pooled web view for the whole sequence | FR-004, SC-002    | example | PENDING  |      |
| A6  | A tool called with `filters`/`stopOn` accepts them as typed arguments (not opaque payloads) and those arguments gate capture | FR-005            | example | PENDING  |      |
| A7  | A tool whose result exceeds the size threshold returns a bounded `summary` plus an `artifactRef` to the full artifact, while a result under the threshold is returned inline | FR-006, SC-003    | example | PENDING  |      |
| A8  | The cassette parity suite run in CI is green on both macOS and the Android emulator (harness records once via VCR and replays on every change) | FR-007, FR-010, SC-004 | example | PENDING  |      |
| A9  | Replaying any single golden cassette 10× yields byte-identical mission outcomes (determinism measured, not assumed) | FR-010, SC-004    | example | PENDING  |      |
| A10 | Replaying a multi-engine degrade set whose engine block cassette is engaged makes `webview.search` degrade correctly to the next engine without error, over a golden set covering ≥ 3 retailers × {browse, intercept, search per engine, dialogue dismiss, recipe replay} | FR-008, FR-009, SC-005 | example | PENDING  |      |
| A11 | An unmatched live network call during deterministic replay makes the harness fail hard (no silent pass), with a soft mode configurable for CI flakiness triage | FR-014, SC-004    | example | PENDING  |      |
| A12 | dws_playground golden missions GM-2, GM-4, and GM-5 pointed at the module tools all run green in CI | FR-011, SC-006    | example | PENDING  |      |
| A13 | On a green mission run, umbrella #241 is closed on the parity sign-off and #239 is closed as superseded-by-generated with its old→new tool-name mapping recorded | FR-011, SC-006    | example | PENDING  |      |
| A14 | A zuraffa consumer importing the module registrar has the generated `webview.*` tools registered into its agent kernel | FR-012, SC-007    | example | PENDING  |      |
| A15 | A non-zuraffa app importing the plugin directly can use the thin core standalone without the zuraffa runtime | FR-012, SC-007    | example | PENDING  |      |
| A16 | Migration docs document both the registrar import path and the plugin-only standalone import path | FR-012, SC-007    | example | PENDING  |      |
| A17 | Every committed cassette contains no auth headers or cookie values and the cassette format carries a version field | FR-013, SC-008    | example | PENDING  |      |

## Inner loop: unit behaviors

**Skipped — `plan.md` is absent for this feature.** No `U*` behaviors are listed.
Re-run `/speckit.tdd.plan` after `plan.md` exists to append unit behaviors grouped
by component file, including `kind: characterization` baselines for any currently
untested module component the feature changes (e.g. the existing
`zikzak_inappwebview_module/test/cassette_model_test.dart` surface, and any
registrar/codegen glue).

## Invariants and edge cases still to place

Not applicable while the inner loop is unplanned. The following spec edge cases
should be turned into `U*` lines under the relevant component once `plan.md` exists:

- A usecase changes but the generator is not re-run → CI surface-equality check (A1) fails and blocks merge.
- `newSession: true` mid-sequence obtains a fresh pooled identity and releases the prior instance without leaking.
- Oversized result with an unavailable artifact store → tool fails loudly, never returns a truncated silent payload.
- Engine fully blocked in the degrade set → `webview.search` degrades through all engines and returns an empty/no-result state without throwing.
- CI with no Android emulator available → macOS gate is mandatory; the harness still reports which legs ran and whether the missing leg caused a non-green run.

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- Periodic cassette re-recording: operational task explicitly outside this feature's automated gate (spec Assumptions).
- Live network accuracy of cassettes: the determinism run guards replay stability, not live accuracy (Edge Cases) — not asserted here.
- The `zfa make --agent` generator and zuraffa `McpToolProvider` SPI/registry internals: assumed available and API-compatible; the feature consumes generated output, it does not implement the generator (Assumptions).
- The §4.1 surface definition in the zik_zak architecture doc: the authoritative tool list, not produced by this feature.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, so this
file is readable on its own. Run from the package directory whose source the
behavior exercises.

- Single test: `flutter test --plain-name "{name}"`
- File: `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

> Note: the relevant packages for this feature (`zikzak_inappwebview_module`,
> `zikzak_inappwebview`) are **blocked** by the zuraffa pub-cache corruption. The
> command shapes above are identical across packages; after `flutter pub cache
> repair`, run them from `zikzak_inappwebview_module` (or the umbrella) cwd. The
> default green stack `zikzak_inappwebview_platform_interface` runs as written from
> its own cwd.
