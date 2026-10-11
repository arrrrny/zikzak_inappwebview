---
feature: 005-rewrite-module-wiring
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 13
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked # zuraffa pub-cache corruption — run `flutter pub cache repair`
---

# Test List: Rewrite Module Wiring (Zuraffa-native)

`plan.md` is ABSENT for this feature, so this list is **outer-loop only**. The
inner loop (per-component `U` behaviors) was deliberately skipped: without
`plan.md` there is no component decomposition to own unit behaviors, and
deriving components from existing code would violate the spec-first rule. Re-run
`/speckit.tdd-plan` after `/speckit.plan` to add the inner loop.

`spec.md` numbers its acceptance scenarios per user story rather than with global
`AC-n` ids, so each behavior below names its story and scenario in the behavior
text and traces to the **real** `FR-` / `SC-` ids that scenario asserts. Every
`traces` value resolves to an id present in `spec.md`.

## Outer loop: acceptance behaviors

One per acceptance scenario in `spec.md` (US1.1–US4.3), in spec order, plus the
edge cases that are not already an acceptance scenario. Each is observable
through the feature's real entry point: the imported engine module, the package
registrar, and an invoked `ZuraffaUseCase`'s `SignalResult`.

| id  | behavior                                                                                                                                   | traces          | kind    | state   | test |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------ | --------------- | ------- | ------- | ---- |
| A1  | US1.1 — after importing only the engine module, the registrar resolves the session, cookie, artifact and cassette stores and every usecase by type, with no registration call in app code | FR-002, SC-001  | example | PENDING |      |
| A2  | US1.2 — requesting the same usecase type twice yields an equivalent instance, and importing the engine module a second time leaves the registration count unchanged | FR-002           | example | PENDING |      |
| A3  | US1.3 — without the engine module imported, resolving a module usecase fails with an explicit "not registered" error rather than returning null | FR-002           | example | PENDING |      |
| A4  | US2.1 — all eleven usecases (`browse`, `interceptBrowse`, `search`, `executeJs`, `cookies.get`, `cookies.set`, `dialogueDismiss`, `screenshot`, `pdf`, `recipeRecord`, `recipeReplay`) are present as `ZuraffaUseCase`s whose provenance is code-generated, with no hand-written body | FR-003, FR-005, SC-002 | example | PENDING |      |
| A5  | US2.2 — `recipeReplay` reports `confirm` risk and a credential-bearing replay step executes only after explicit confirmation is granted | FR-008, SC-002  | example | PENDING |      |
| A6  | US2.3 — an `interceptBrowse` run over distiller-matching content emits those matches as Sightings through the distiller slot while the `SignalResult` stream reports page-state progress | FR-004, FR-006, FR-011, SC-003 | example | PENDING |      |
| A7  | US2.4 — when the primary search engine fails or returns nothing, `search` queries the remaining engines in the defined degrade order and returns an empty-result signal only after the order is exhausted | FR-007          | example | PENDING |      |
| A8  | US3.1 — `browse` → `interceptBrowse` → `executeJs` in one mission all operate on the same pooled webview instance (instance identity) | FR-001, SC-005  | example | PENDING |      |
| A9  | US3.2 — a `screenshot` or `pdf` captured during a mission is retrievable from the mission store through its artifactRef | FR-001          | example | PENDING |      |
| A10 | US3.3 — a cookie written by `cookies.set` on a mission session is returned by `cookies.get` scoped to that same mission session | FR-012          | example | PENDING |      |
| A11 | US4.1 — cancelling an in-flight `interceptBrowse` returns the partial Sightings, flushes the captured artifacts, releases the pooled session, and leaves zero leaked sessions or cassettes | FR-009, SC-004  | example | PENDING |      |
| A12 | US4.2 — once the mission's webview-seconds budget is exhausted, a further usecase attempt is blocked and a budget-exceeded kernel event is emitted before any over-run | FR-010, SC-006  | example | PENDING |      |
| A13 | US4.3 — when the salvage flush itself throws during cancellation, the pooled session is still released and no session or cassette leak remains | FR-009, SC-004  | example | PENDING |      |
| A14 | Edge — cancelling before any capture has been flushed returns empty Sightings and still releases the pooled session with no leak | FR-009, SC-004  | example | PENDING |      |
| A15 | Edge — when the artifact/mission store is unavailable, the artifactRef fails to resolve and the usecase surfaces the failure as a failed `SignalResult` instead of an uncaught throw | FR-001, FR-004  | example | PENDING |      |
| A16 | Edge — a budget exhaustion occurring mid-`interceptBrowse` emits the budget-exceeded event and drives the usecase through the salvage protocol | FR-009, FR-010, SC-006 | example | PENDING |      |
| A17 | Edge — denying confirmation on a `recipeReplay` credential step aborts the replay without executing any credential-bearing step | FR-008          | example | PENDING |      |

No existing test covers any of the above. The only test file in the target
package is `zikzak_inappwebview_module/test/cassette_model_test.dart`, which
covers cassette model serialization, not module wiring — so nothing is marked
`DONE`.

## Inner loop: unit behaviors

Skipped — `plan.md` is absent, so no component decomposition exists to own unit
behaviors. Characterization (`kind: characterization`) baselines are likewise
deferred to the inner-loop pass, with one exception noted below: the target
package is effectively untested, so every component `plan.md` eventually names
will need a `BASELINE` characterization line before it is rewritten.

## Invariants and edge cases still to place

These belong to the feature but have no owning component until `plan.md` exists.
The profile records **no property or mutation library**, so when these land they
must be `kind: example` sampled at their boundaries.

- Registrar idempotence invariant: N imports of the engine module produce exactly one registration per key (sample N = 1 and N = 2 — both sides of the "already registered" boundary).
- Budget boundary: consuming webview-seconds up to exactly the budget limit is allowed; the first second beyond it is blocked (`<=` and `>` sides of `SC-006`).
- Salvage no-leak invariant: pooled sessions released == pooled sessions acquired, for every terminal path (success, cancel, cancel-with-failed-flush).
- Streaming ordering invariant: every progress event on a `SignalResult` channel is delivered before the terminal result, never after (`FR-004`).
- Search degrade-order invariant: engines are attempted in the declared order with no engine skipped and none retried, for a 1-engine and an all-engines-fail sample (`FR-007`).
- Artifact round-trip invariant: write through the artifact store then resolve by artifactRef yields the same bytes/content (`FR-001`).
- Stop-condition boundary for `interceptBrowse` `stopOn`: interception halts on the first match satisfying the condition and not on the one before it (`FR-006`).

## Out of scope

- Platform rendering and the method-channel/controller layer for Android/iOS/Web/Linux/Windows/macOS: per the spec's Assumptions, this feature rewires the Zuraffa-facing module surface on top of those existing ports and does not alter them.
- The umbrella rewrite (#241) and the extraction (#242): prerequisite features, assumed complete.
- Upstream Zuraffa capabilities themselves (package mode zuraffa#389, salvage protocol zuraffa#388, usecase codegen zuraffa#385, annotation scheme zorphy#114): assumed available and stable, tested upstream.
- Device-backed end-to-end runs: the profile records no acceptance runner; the only e2e layer (`zikzak_inappwebview/example/integration_test`) needs a real device/emulator.
- Property-based and mutation testing: no such library exists in any `pubspec.lock`.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` (stack
`zikzak_inappwebview_module`, run from `cwd: zikzak_inappwebview_module`):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`
- Mutation (changed files): none — `mutation: null` in the profile.

**Baseline caveat:** this stack's `suite_baseline` is `blocked`, not green — the
`zuraffa` package in the pub cache is a corrupted extraction, so the suite
crashes at compile/load time. Run `flutter pub cache repair` before starting the
loop. The green reference stack is `zikzak_inappwebview_platform_interface`
(300 tests, ~82s).
