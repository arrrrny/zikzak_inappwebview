# Implementation Tasks: Rewrite Module Wiring (Zuraffa-native)

Tasks are ordered: test task precedes implementation task for the same behavior.
Behavior markers (e.g., `[A1]`) on every task that behavior covers.
All tests are mandatory — must be observed failing first before implementation.

## Phase 0: Setup and Foundation

- [ ] T001: Create engine module and package registrar wiring skeleton (foundation for [A1], [A2], [A3])
- [ ] T002: Implement DDA datasource interfaces (SessionStore, CookieStore, ArtifactStore, CassetteStore) (foundation for [A8], [A9], [A10])
- [ ] T003: Set up code generation pipeline for ZuraffaUseCases (foundation for [A4], [A5], [A6], [A7])

## Phase 1: Zero-manual-wiring module registration (User Story 1)

- [ ] T010: **Test** Registrar resolves all stores and usecases after importing engine module ([A1])
- [ ] T011: **Implement** Registrar resolution for all stores and usecases ([A1])
- [ ] T012: **Test** Registrar returns consistent equivalent instances and is idempotent on re-import ([A2])
- [ ] T013: **Implement** Stable/idempotent registrar resolution ([A2])
- [ ] T014: **Test** Registrar fails with clear "not registered" signal when engine module not imported ([A3])
- [ ] T015: **Implement** Clear "not registered" failure for unregistered usecases ([A3])

## Phase 2: Generated mission-scoped usecases with streaming (User Story 2)

- [ ] T020: **Test** All 11 usecases exist as generated ZuraffaUseCases with code-generated provenance ([A4])
- [ ] T021: **Implement** Code generation for all 11 usecases via zfa make ([A4])
- [ ] T022: **Test** recipeReplay annotated with confirm risk and obtains confirmation on credential steps ([A5])
- [ ] T023: **Implement** Confirm risk annotation and confirmation flow for recipeReplay ([A5])
- [ ] T024: **Test** interceptBrowse emits Sightings through distiller slot with page-state progress streaming ([A6])
- [ ] T025: **Implement** interceptBrowse distiller slot and streaming ([A6])
- [ ] T026: **Test** search follows multi-engine degrade order on primary engine failure/no results ([A7])
- [ ] T027: **Implement** Multi-engine degrade order for search ([A7])

## Phase 3: Session continuity via pooled DDA stores (User Story 3)

- [ ] T030: **Test** browse → interceptBrowse → executeJs share same pooled webview instance ([A8])
- [ ] T031: **Implement** Pooled webview session continuity across operations ([A8])
- [ ] T032: **Test** Screenshot/PDF capture persisted via artifact store and retrievable via artifactRef ([A9])
- [ ] T033: **Implement** Artifact store persistence and artifactRef resolution ([A9])
- [ ] T034: **Test** cookies.set then cookies.get returns cookie scoped to mission session ([A10])
- [ ] T035: **Implement** Cookie store scoping to mission session ([A10])

## Phase 4: Mission cancellation, salvage, and budget accounting (User Story 4)

- [ ] T040: **Test** Cancelling interceptBrowse flushes captures, releases session, returns partial Sightings, no leaks ([A11])
- [ ] T041: **Implement** Cancellation/salvage protocol for interceptBrowse ([A11])
- [ ] T042: **Test** Webview-seconds budget exhaustion blocks consumption and emits budget-exceeded kernel event ([A12])
- [ ] T043: **Implement** MissionBudgetHook with webview-seconds accounting and budget enforcement ([A12])
- [ ] T044: **Test** Failed salvage flush still releases pooled session with no session/cassette leak ([A13])
- [ ] T045: **Implement** Resource cleanup guarantee on salvage failure ([A13])

## Phase 5: Edge Cases and Integration

- [ ] T050: **Test** Usecase cancelled before any capture flush releases session and returns empty Sightings (edge case)
- [ ] T051: **Implement** Early cancellation handling (edge case)
- [ ] T052: **Test** All search engines fail → explicit empty/failure SignalResult (edge case)
- [ ] T053: **Implement** Exhaustive degrade order handling (edge case)
- [ ] T054: **Test** Artifact store unavailable → failure surfaced through SignalResult (edge case)
- [ ] T055: **Implement** Graceful failure propagation through SignalResult (edge case)
- [ ] T056: **Test** Budget exhausted mid-interceptBrowse → budget-exceeded event and salvage cancel (edge case)
- [ ] T057: **Implement** Mid-operation budget enforcement (edge case)
- [ ] T058: **Test** User denies recipeReplay confirmation → abort without credential steps (edge case)
- [ ] T059: **Implement** Confirmation denial handling for recipeReplay (edge case)

## Phase 6: Acceptance Validation

- [ ] T060: **Test** Full outer-loop acceptance: consuming app import → all services resolvable, operations stream, sessions pool, budgets enforce, cancellation salvages ([A1]–[A13])
- [ ] T061: **Verify** All acceptance criteria SC-001 through SC-006 pass in integration context