# Tasks: Extract Value-Add into Module (Ports & Services)

All tasks listed here are mandatory and must be completed in order. Test tasks must be observed failing (RED) before implementation tasks begin. Each behavioral task carries its behavior marker `[A#]` or `[U#]` — this is load-bearing for the TDD loop.

## Phase 0: Module Setup

- [ ] T001 Create `zikzak_inappwebview_module` package with pubspec.yaml (FR-001)
- [ ] T002 Define port interfaces: `WebViewSessionFactory`, `CaptureSource`, `CassetteEngine`, `DialogueDismissPort`, `RecipePort`, `NavigationTrackerPort` (FR-001, FR-014)
- [ ] T003 Set up DDA datasource structure per zuraffa#389 for module services (FR-002)

## Phase 1: WebView Pooling (US-1, P1)

- [ ] T010 [A1] Write acceptance test: pool returns session with domain affinity, reuses idle session for same domain
- [ ] T011 [A1] Implement `WebViewPool` service with domain-affinity reuse logic (FR-004)
- [ ] T012 [A2] Write acceptance test: pool under memory pressure disposes lowest-priority/longest-idle sessions
- [ ] T013 [A2] Implement memory-pressure eviction in `WebViewPool` service (FR-004)
- [ ] T014 [A3] Write acceptance test: every acquired handle returned to pool or fully torn down, no leaks
- [ ] T015 [A3] Implement no-leak guarantee in `WebViewPool` with verification run (FR-009)
- [ ] T016 Create plugin-side adapter: `WebViewSessionFactoryAdapter` over `HeadlessInAppWebView` (FR-003, FR-004)
- [ ] T017 Write characterization tests for any existing pool logic being extracted (FR-012)

## Phase 2: Capture Service (US-2, P2)

- [ ] T020 [A4] Write acceptance test: capture with finite budget stops and emits salvage flush when exhausted
- [ ] T021 [A4] Implement `CaptureSource` service with budget cap and salvage flush (FR-005)
- [ ] T022 [A5] Write acceptance test: stopOn predicate ends capture early, returns accumulated entries
- [ ] T023 [A5] Implement `stopOn` early-return predicate in capture service (FR-005)
- [ ] T024 [A6] Write acceptance test: auth-flow tokens redacted at source, distiller receives redacted Sighting
- [ ] T025 [A6] Implement at-source redaction in capture service (FR-005, FR-008)
- [ ] T026 Expose distiller post-processor slot consuming `Sighting` contract (FR-007)
- [ ] T027 Write contract test for distiller slot using stub implementation (FR-013)
- [ ] T028 Create plugin-side adapter: `CaptureSourceAdapter` over raw plugin capture events (FR-003, FR-005)

## Phase 3: VCR Record/Replay and Remaining Ports (US-3, P3)

- [ ] T030 [A7] Write acceptance test: CassetteEngine replay mode serves from cassette, zero network requests
- [ ] T031 [A7] Implement `CassetteEngine` service with record/replay transport wrapper (FR-006)
- [ ] T032 [A8] Write acceptance test: identical cassette replayed twice produces byte-identical outputs
- [ ] T033 [A8] Implement deterministic replay guarantee in `CassetteEngine` (FR-010)
- [ ] T034 [A9] Write acceptance test: DialogueDismissPort, RecipePort, NavigationTrackerPort operate through port boundary
- [ ] T035 [A9] Implement DDA datasources for dismiss, recipe, tracker ports (FR-002, FR-014)
- [ ] T036 Create plugin-side adapters for DialogueDismissPort, RecipePort, NavigationTrackerPort (FR-003)

## Phase 4: Structural Gate and Parity

- [ ] T040 Automated structural gate: zero value-add logic in plugin core (FR-011, SC-001)
- [ ] T041 Re-point existing plugin examples/tests to module equivalents (FR-012, SC-006)
- [ ] T042 Verify module unit tests import no plugin internals, run with fakes (SC-007)
- [ ] T043 No-leak stress/teardown run reports zero orphaned sessions (SC-002)
- [ ] T044 Capture redaction test asserts no secret byte patterns in output (SC-003)
- [ ] T045 VCR determinism test: identical outputs, zero network calls (SC-004)
- [ ] T046 Distiller contract test passes all Sighting assertions with stub (SC-005)

## Phase 5: Edge Cases (from test-list.md Invariants section)

- [ ] T050 Test: replay references missing asset → deterministic failure, no network fallback
- [ ] T051 Test: capture budget zero → immediate yield with single salvage flush
- [ ] T052 Test: memory pressure during capture → pool evicts after capture salvages buffer
- [ ] T053 Test: novel auth scheme not matched → distiller catches as second redaction layer
- [ ] T054 Test: malformed Sighting from distiller stub → contract test fails loudly
- [ ] T055 Test: module unit tests run without plugin, fakes satisfy ports
- [ ] T056 Test: port invoked before adapter registered → clear "adapter not registered" error

## Phase N: TDD remediation

- [ ] T060 Create `plan.md` with component architecture so inner-loop unit behaviors can be derived (addresses Finding #3)
- [ ] T061 Create `zikzak_inappwebview_module` package with pubspec.yaml and port interfaces (addresses Finding #5, enables FR-001)
- [ ] T062 Run `/speckit.tdd.plan refresh` after `plan.md` exists to populate inner-loop behaviors (addresses Finding #4)
- [ ] T063 Begin TDD cycle for A1: write acceptance test for pool domain-affinity reuse (addresses Finding #1, #2)
- [ ] T064 Begin TDD cycle for A2: write acceptance test for pool memory-pressure eviction (addresses Finding #1, #2)
- [ ] T065 Begin TDD cycle for A3: write acceptance test for pool no-leak guarantee (addresses Finding #1, #2)
- [ ] T066 Begin TDD cycle for A4: write acceptance test for capture budget + salvage (addresses Finding #1, #2)
- [ ] T067 Begin TDD cycle for A5: write acceptance test for capture stopOn early return (addresses Finding #1, #2)
- [ ] T068 Begin TDD cycle for A6: write acceptance test for capture redaction at source (addresses Finding #1, #2)
- [ ] T069 Begin TDD cycle for A7: write acceptance test for CassetteEngine replay zero network (addresses Finding #1, #2)
- [ ] T070 Begin TDD cycle for A8: write acceptance test for CassetteEngine deterministic replay (addresses Finding #1, #2)
- [ ] T071 Begin TDD cycle for A9: write acceptance test for remaining ports via port boundary (addresses Finding #1, #2)