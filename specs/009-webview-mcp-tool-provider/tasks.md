# Tasks: WebView MCP Tool Provider

**Feature**: 009-webview-mcp-tool-provider
**Status**: Draft (TDD planned)

## Phase 0: TDD Setup (Mandatory)

- [ ] **T-001** [A1] Write acceptance test: Provider registers with agent kernel and all webview.* tools are discoverable and callable in-process
- [ ] **T-002** [A2] Write acceptance test: browse returns page title, resolved URL, and HTML artifactRef
- [ ] **T-003** [A3] Write acceptance test: Subsequent tool calls reusing sessionId operate on same pooled webview instance
- [ ] **T-004** [A4] Write acceptance test: Released sessionId returns "session not active" error (no leak/crash)
- [ ] **T-005** [A5] Write acceptance test: intercept_browse returns bounded, secret-free distilled Sightings (not raw events)
- [ ] **T-006** [A6] Write acceptance test: Distiller enforces caps (event count, payload size, binary capture off by default)
- [ ] **T-007** [A7] Write acceptance test: Distiller fixtures produce Sightings passing secret-free and bounded assertions
- [ ] **T-008** [A8] Write acceptance test: search returns extracted links for explicit engine preference
- [ ] **T-009** [A9] Write acceptance test: search falls back through DDG/Bing/Google when preferred engine blocks
- [ ] **T-010** [A10] Write acceptance test: search returns degraded but usable result when all non-Google engines fail
- [ ] **T-011** [A11] Write acceptance test: cookies.get returns cookie previously set via cookies.set on same session
- [ ] **T-012** [A12] Write acceptance test: dialogue_dismiss clears consent overlay so screenshot/PDF are unobstructed
- [ ] **T-013** [A13] Write acceptance test: execute_js summarizes oversized results with artifactRef instead of inlining
- [ ] **T-014** [A14] Write acceptance test: Recipe recording requires explicit consent; replay excludes credentials
- [ ] **T-015** [A15] Write acceptance test: Cancelled intercept_browse emits partial Sightings via salvage, releases pool
- [ ] **T-016** [A16] Write acceptance test: Cancelled mission result marked partial/cancelled, no half-written artifacts

## Phase 1: Implementation (Mandatory — tests must be observed failing first)

- [ ] **T-017** [A1] Implement WebviewMcpToolProvider registration and tool listing (FR-001, FR-002)
- [ ] **T-018** [A2] Implement webview.browse: headless load, wait for idle, capture HTML artifact (FR-005)
- [ ] **T-019** [A3] Implement sessionId propagation across tool calls; pooled instance reuse (FR-003)
- [ ] **T-020** [A4] Implement sessionId validation: unknown/released returns clear error, no leak (FR-003, FR-004)
- [ ] **T-021** [A5] Implement webview.intercept_browse delegating to SightingDistiller (FR-006)
- [ ] **T-022** [A6] Implement distiller caps enforcement: event count, payload size, binary capture (FR-007, FR-014)
- [ ] **T-023** [A7] Wire distiller fixtures for validation (FR-006, FR-007)
- [ ] **T-024** [A8] Implement webview.search with explicit engine preference (FR-008)
- [ ] **T-025** [A9] Implement search engine fallback order: retailer → DDG → Bing → Google (FR-008)
- [ ] **T-026** [A10] Implement degraded result on engine failures (FR-008)
- [ ] **T-027** [A11] Implement webview.cookies.get/set scoped to session (FR-010)
- [ ] **T-028** [A12] Implement webview.dialogue_dismiss, screenshot, pdf (FR-011)
- [ ] **T-029** [A13] Implement webview.execute_js with result-size discipline and artifactRef (FR-009)
- [ ] **T-030** [A14] Implement recipe.record (consent-gated) and recipe.replay (headless) (FR-012)
- [ ] **T-031** [A14] Implement credential redaction in recipe traces (FR-013)
- [ ] **T-032** [A15] Implement cancellation handling with salvage protocol across all tools (FR-015)
- [ ] **T-033** [A16] Implement partial/cancelled result marking, no half-written artifacts (FR-015)
- [ ] **T-034** [A1-A16] Ensure VCR compatibility for entire tool suite (FR-016)

## Phase 2: End-to-End Validation (Mandatory)

- [ ] **T-035** [A1] Run full provider registration acceptance test to green
- [ ] **T-036** [A2] Run browse acceptance test to green
- [ ] **T-037** [A3] Run sessionId reuse acceptance test to green
- [ ] **T-038** [A4] Run released sessionId acceptance test to green
- [ ] **T-039** [A5] Run intercept_browse Sightings acceptance test to green
- [ ] **T-040** [A6] Run distiller caps enforcement acceptance test to green
- [ ] **T-041** [A7] Run distiller fixture validation acceptance test to green
- [ ] **T-042** [A8] Run search explicit engine acceptance test to green
- [ ] **T-043** [A9] Run search fallback acceptance test to green
- [ ] **T-044** [A10] Run search degraded result acceptance test to green
- [ ] **T-045** [A11] Run cookies get/set acceptance test to green
- [ ] **T-046** [A12] Run dialogue_dismiss/screenshot/pdf acceptance test to green
- [ ] **T-047** [A13] Run execute_js size discipline acceptance test to green
- [ ] **T-048** [A14] Run recipe record/replay acceptance test to green
- [ ] **T-049** [A15] Run cancellation salvage acceptance test to green
- [ ] **T-050** [A16] Run partial result marking acceptance test to green

## Phase 3: VCR CI Integration (Mandatory)

- [ ] **T-051** Record VCR cassettes for all acceptance scenarios
- [ ] **T-052** Verify full suite passes under VCR replay (no live network)

## Notes

- Tests are mandatory, not optional. No "only if tests requested" qualifiers.
- Each implementation task must not start until its corresponding acceptance test is written and observed failing (RED).
- Behavior markers `[A#]` on every task are load-bearing for `/speckit.tdd.run` and `/speckit.implement`.
- Inner-loop unit behaviors (U1-U14) will be added when plan.md is available; they precede their respective A behaviors in the cycle order.

## Phase N: TDD remediation

- [ ] **T-053** [HIGH] Create acceptance test file for A1: Provider registers with agent kernel and all webview.* tools are discoverable and callable in-process
- [ ] **T-054** [HIGH] Create acceptance test file for A2: browse returns page title, resolved URL, and HTML artifactRef
- [ ] **T-055** [HIGH] Create acceptance test file for A3: Subsequent tool calls reusing sessionId operate on same pooled webview instance
- [ ] **T-056** [HIGH] Create acceptance test file for A4: Released sessionId returns "session not active" error (no leak/crash)
- [ ] **T-057** [HIGH] Create acceptance test file for A5: intercept_browse returns bounded, secret-free distilled Sightings (not raw events)
- [ ] **T-058** [HIGH] Create acceptance test file for A6: Distiller enforces caps (event count, payload size, binary capture off by default)
- [ ] **T-059** [HIGH] Create acceptance test file for A7: Distiller fixtures produce Sightings passing secret-free and bounded assertions
- [ ] **T-060** [HIGH] Create acceptance test file for A8: search returns extracted links for explicit engine preference
- [ ] **T-061** [HIGH] Create acceptance test file for A9: search falls back through DDG/Bing/Google when preferred engine blocks
- [ ] **T-062** [HIGH] Create acceptance test file for A10: search returns degraded but usable result when all non-Google engines fail
- [ ] **T-063** [HIGH] Create acceptance test file for A11: cookies.get returns cookie previously set via cookies.set on same session
- [ ] **T-064** [HIGH] Create acceptance test file for A12: dialogue_dismiss clears consent overlay so screenshot/PDF are unobstructed
- [ ] **T-065** [HIGH] Create acceptance test file for A13: execute_js summarizes oversized results with artifactRef instead of inlining
- [ ] **T-066** [HIGH] Create acceptance test file for A14: Recipe recording requires explicit consent; replay excludes credentials
- [ ] **T-067** [HIGH] Create acceptance test file for A15: Cancelled intercept_browse emits partial Sightings via salvage, releases pool
- [ ] **T-068** [HIGH] Create acceptance test file for A16: Cancelled mission result marked partial/cancelled, no half-written artifacts