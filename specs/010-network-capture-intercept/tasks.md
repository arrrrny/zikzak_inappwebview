# Tasks: Network Capture — Mission-Grade Intercept

## Phase 1: Test Planning

- [ ] **T001** [A1] Write acceptance test: getSightings() returns non-empty, distiller-valid Sightings for live retailer session
- [ ] **T002** [A2] Write acceptance test: getEntries() returns unchanged raw NetworkEntry objects when distillation enabled
- [ ] **T003** [A3] Write acceptance test: getSightings() returns empty list without throwing when no distiller configured
- [ ] **T004** [A4] Write acceptance test: Streaming API terminates early when stopOn matches high-confidence product-API event
- [ ] **T005** [A5] Write acceptance test: Streaming API does not early-return for low-confidence events
- [ ] **T006** [A6] Write acceptance test: Early return includes triggering event and all previously streamed events
- [ ] **T007** [A7] Write acceptance test: Salvage flush emits buffered events on cancellation before disposal
- [ ] **T008** [A8] Write acceptance test: Salvage flush emits buffered events on timeout before teardown
- [ ] **T009** [A9] Write acceptance test: Zero-loss window (>1s) satisfied for events before cancellation
- [ ] **T010** [A10] Write acceptance test: Per-domain maxEntries budget enforced
- [ ] **T011** [A11] Write acceptance test: Per-domain maxBytes budget enforced
- [ ] **T012** [A12] Write acceptance test: Per-domain maxBodySize budget enforced
- [x] **T013** [A13] Write acceptance test: Auth header values redacted at source
- [x] **T014** [A14] Write acceptance test: Session cookie values redacted at source
- [ ] **T015** [A15] Write acceptance test: URL/body auth params redacted at source
- [ ] **T016** [A16] Write acceptance test: SSO/auth-flow sequences detected and marked auth
- [ ] **T017** [A17] Write acceptance test: Auth-marked entries have response body dropped entirely
- [ ] **T018** [A18] Write acceptance test: Auth-marked entries carry auth tag and no body on stream/flush
- [ ] **T019** [A19] Write acceptance test: Capture overhead < 5% page-load p50 on mid-tier Android
- [ ] **T020** [A20] Write acceptance test: Benchmark produces documented before/after numbers

## Phase 2: Implementation

- [ ] **T021** [A1] Implement SightingDistiller pluggable post-processor slot in NetworkCaptureManager
- [ ] **T022** [A2] Implement getSightings() on NetworkCaptureController returning distiller output
- [ ] **T023** [A3] Ensure getSightings() degrades gracefully when no distiller configured
- [ ] **T024** [A4] Implement live streaming event API on NetworkCaptureController
- [ ] **T025** [A4] Implement stopOn condition {classification, minRank} for early termination
- [ ] **T026** [A5] Ensure stopOn only triggers on high-confidence matches
- [ ] **T027** [A6] Ensure early return includes all accumulated sightings
- [ ] **T028** [A7] Implement salvage flush on cancellation in NetworkCaptureController
- [ ] **T029** [A8] Implement salvage flush on timeout
- [ ] **T030** [A9] Enforce documented zero-loss window (>1s) for salvage
- [ ] **T031** [A10] Implement per-domain maxEntries budget enforcement
- [ ] **T032** [A11] Implement per-domain maxBytes budget enforcement
- [ ] **T033** [A12] Implement per-domain maxBodySize budget enforcement
- [x] **T034** [A13] Implement SecretRedactor for Authorization headers at source
- [x] **T035** [A14] Implement SecretRedactor for session cookies at source
- [ ] **T036** [A15] Implement SecretRedactor for URL/body auth params (api_key, password) at source
- [ ] **T037** [A16] Implement SSO/auth-flow detection and auth classification
- [ ] **T038** [A17] Implement response body dropping for auth-marked entries
- [ ] **T039** [A18] Ensure auth tag and no body propagate to stream and salvage flush
- [ ] **T040** [A19] Validate capture overhead with benchmark harness
- [ ] **T041** [A20] Produce documented before/after benchmark numbers

## Phase 3: Integration & Validation

- [ ] **T042** [A1] Verify A1: getSightings() returns non-empty, distiller-valid Sightings (outer loop green)
- [ ] **T043** [A2] Verify A2: getEntries() returns unchanged raw entries (outer loop green)
- [ ] **T044** [A3] Verify A3: getSightings() graceful degradation (outer loop green)
- [ ] **T045** [A4] Verify A4: Streaming early return on stopOn match (outer loop green)
- [ ] **T046** [A5] Verify A5: No early return for low-confidence events (outer loop green)
- [ ] **T047** [A6] Verify A6: Early return includes all accumulated sightings (outer loop green)
- [ ] **T048** [A7] Verify A7: Salvage flush on cancellation (outer loop green)
- [ ] **T049** [A8] Verify A8: Salvage flush on timeout (outer loop green)
- [ ] **T050** [A9] Verify A9: Zero-loss window satisfied (outer loop green)
- [ ] **T051** [A10] Verify A10: Per-domain maxEntries budget (outer loop green)
- [ ] **T052** [A11] Verify A11: Per-domain maxBytes budget (outer loop green)
- [ ] **T053** [A12] Verify A12: Per-domain maxBodySize budget (outer loop green)
- [ ] **T054** [A13] Verify A13: Auth header redaction at source (outer loop green)
- [ ] **T055** [A14] Verify A14: Session cookie redaction at source (outer loop green)
- [ ] **T056** [A15] Verify A15: URL/body param redaction at source (outer loop green)
- [ ] **T057** [A16] Verify A16: SSO/auth detection and auth classification (outer loop green)
- [ ] **T058** [A17] Verify A17: Auth body dropped entirely (outer loop green)
- [ ] **T059** [A18] Verify A18: Auth tag and no body on stream/flush (outer loop green)
- [ ] **T060** [A19] Verify A19: Capture overhead < 5% (outer loop green)
- [ ] **T061** [A20] Verify A20: Benchmark numbers documented (outer loop green)

## Phase 4: Edge Cases & Cross-Cutting

- [ ] **T062** Handle distiller throwing/malformed output: raw entry retrievable, stream continues
- [ ] **T063** Handle stopOn firing mid-event: consistent include/discard behavior
- [ ] **T064** Handle WebView disposed before salvage flush completes
- [ ] **T065** Document per-domain budget vs distiller cap precedence
- [ ] **T066** Handle secret split across header and body: all occurrences redacted
- [ ] **T067** Provide audit/escape path for redaction false positives
- [ ] **T068** Handle SSO misfire on non-login flow: body recovery documented
- [ ] **T069** Handle HeadlessInAppWebView torn down by pool manager
- [ ] **T070** Ensure getSightings() concurrent with active stream returns consistent snapshot
- [ ] **T071** Document global vs per-domain maxBodySize precedence

## Phase 5: TDD Remediation

- [ ] **T072** [F1] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A1 (getSightings returns distiller-valid Sightings)
- [ ] **T073** [F1] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A2 (getEntries unchanged with distillation)
- [ ] **T074** [F1] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A3 (getSightings graceful degradation)
- [ ] **T075** [F1] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A4 (streaming stopOn early return)
- [ ] **T076** [F1] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A5 (no early return for low-confidence)
- [ ] **T077** [F1] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A6 (early return includes all sightings)
- [ ] **T078** [F2] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A7 (salvage flush on cancellation)
- [ ] **T079** [F2] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A8 (salvage flush on timeout)
- [ ] **T080** [F2] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A9 (zero-loss window >1s)
- [ ] **T081** [F3] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A10 (per-domain maxEntries budget)
- [ ] **T082** [F3] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A11 (per-domain maxBytes budget)
- [ ] **T083** [F3] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A12 (per-domain maxBodySize budget)
- [ ] **T084** [F4] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A13 (Authorization header redaction)
- [ ] **T085** [F4] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A14 (session cookie redaction)
- [ ] **T086** [F4] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A15 (URL/body param redaction)
- [ ] **T087** [F5] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A16 (SSO/auth detection)
- [ ] **T088** [F5] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A17 (auth body dropped entirely)
- [ ] **T089** [F5] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A18 (auth tag on stream/flush)
- [ ] **T090** [F6] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A19 (overhead < 5%)
- [ ] **T091** [F6] Create feature branch `010-network-capture-intercept` and begin TDD cycle for A20 (benchmark numbers documented)