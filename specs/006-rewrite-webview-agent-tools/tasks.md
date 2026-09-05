# Implementation Tasks: Generated `webview.*` Agent Tools + Cassette Parity CI Gate

Tasks are ordered with test tasks preceding their implementation tasks. Every behavioral task carries a `[A#]` marker from the test list. Tests are **mandatory** — they must be observed failing first.

## Phase 1: Core generation and registrar

- [ ] T001: **[A1]** Test: `zfa make --agent` emits the `webview.*` tool suite from module usecases with zero hand-written tool classes for the module surface
- [ ] T002: **[A1]** Implement: Wire `zfa make --agent` package-mode generation to emit the `webview.*` tool suite from module usecases
- [ ] T003: **[A2]** Test: The emitted tool names exactly equal the §4.1 surface (11 tools) — no additions or omissions
- [ ] T004: **[A2]** Implement: Ensure generated tool list matches §4.1 surface exactly; add CI surface-equality check
- [ ] T005: **[A3]** Test: `WebviewMcpToolProvider` is reduced to a thin registrar registering generated tools via `McpToolProvider` SPI with no hand-written tool implementations
- [ ] T006: **[A3]** Implement: Replace `WebviewMcpToolProvider` with thin registrar that registers generated tool symbols into kernel registry

## Phase 2: Session continuation and tool contracts

- [ ] T007: **[A4]** Test: Every generated tool documents session ids as opaque strings with continuation semantics and states which tools accept `newSession`
- [ ] T008: **[A4]** Implement: Add session id documentation and `newSession` flag to generated tool schemas
- [ ] T009: **[A5]** Test: `webview.browse` → `intercept_browse` → `execute_js` sequence on one pooled instance with threaded `sessionId` uses exactly one live web view
- [ ] T010: **[A5]** Implement: Wire session continuation through pooled web view instances; add pool assertion for single instance
- [ ] T011: **[A6]** Test: Generated tools accept capture `filters`/`stopOn` as typed arguments with sane mobile defaults that gate capture behavior
- [ ] T012: **[A6]** Implement: Add typed `filters`/`stopOn` parameters to generated tool schemas with mobile defaults
- [ ] T013: **[A7]** Test: Oversized tool results return `summary` + `artifactRef`; under-threshold results return payload inline
- [ ] T014: **[A7]** Implement: Add size-threshold logic and `artifactRef` generation to generated tool result handling

## Phase 3: Cassette parity harness

- [ ] T015: **[A8]** Test: Module provides cassette parity harness that records once via VCR and replays on every change as CI regression gate
- [ ] T016: **[A8]** Implement: Build cassette harness using VCR (#238) for record-once and deterministic replay
- [ ] T017: **[A9]** Test: Golden cassette set covers ≥ 3 retailers across all required operations (browse, intercept, search per engine, dialogue dismiss, recipe replay)
- [ ] T018: **[A9]** Implement: Record golden cassette set across ≥ 3 retailers for all required operations
- [ ] T019: **[A10]** Test: Multi-engine degrade set (each engine's block cassette) and `webview.search` degrades correctly to next engine
- [ ] T020: **[A10]** Implement: Record and verify multi-engine degrade cassettes for search degradation
- [ ] T021: **[A11]** Test: CI cassette suite is green on macOS and Android emulator; 10× replay yields identical outcomes
- [ ] T022: **[A11]** Implement: Configure CI to run cassette suite on macOS and Android emulator with 10× determinism check
- [ ] T023: **[A12]** Test: In replay mode, unmatched live network call fails hard (deterministic mode), configurable to soft for CI flakiness triage
- [ ] T024: **[A12]** Implement: Add deterministic-mode fail-hard for unmatched calls with soft-mode config

## Phase 4: dws_playground parity sign-off

- [ ] T025: **[A13]** Test: dws_playground missions GM-2, GM-4, GM-5 re-pointed at module tools pass in CI
- [ ] T026: **[A13]** Implement: Re-point dws_playground missions to module tools; verify green run triggers umbrella #241 sign-off and #239 closure-as-superseded with tool-name mapping

## Phase 5: Consumer adoption paths

- [ ] T027: **[A14]** Test: Zuraffa consumer (via module registrar) gets `webview.*` tools in kernel; standalone consumer (via thin core) uses `HeadlessInAppWebView` without zuraffa runtime
- [ ] T028: **[A14]** Implement: Document and verify both registrar import path and plugin-only standalone import path
- [ ] T029: **[A14]** Test: Both import paths are documented in module docs

## Phase 6: Edge cases and invariants

- [ ] T030: Test: Cassettes redacted at record time (no auth headers/cookies); cassette format has version field
- [ ] T031: Implement: Add redaction hooks and version field to cassette format
- [ ] T032: Test: Engine fully blocked → `webview.search` degrades through all engines to empty result without throwing
- [ ] T033: Implement: Verify multi-engine degrade handles complete engine failure
- [ ] T034: Test: `newSession: true` mid-sequence obtains fresh identity, releases prior instance to pool without leak
- [ ] T035: Implement: Add `newSession` handling to pooled instance lifecycle
- [ ] T036: Test: CI reports which legs ran when Android emulator unavailable; macOS gate is mandatory
- [ ] T037: Implement: Add CI leg reporting and mandatory macOS gate
- [ ] T038: Test: Oversized result with no artifact store → tool fails loudly with retrievable `artifactRef`
- [ ] T039: Implement: Add artifact store unavailability handling

## Phase 7: Outer-loop acceptance closure

- [ ] T040: **[A1-A14]** All outer-loop acceptance behaviors green; feature complete

## Phase 8: TDD remediation

- [ ] T041: **[Finding 1]** Create first failing acceptance test for A1 (`zfa make --agent` emits webview.* tool suite from usecases). Run: `flutter test <new_test_file> --plain-name "A1"` must fail (red).
- [ ] T042: **[Finding 1]** Create first failing acceptance test for A2 (emitted tool names exactly equal §4.1 surface). Run: `flutter test <new_test_file> --plain-name "A2"` must fail (red).
- [ ] T043: **[Finding 1]** Create first failing acceptance test for A3 (thin registrar replaces WebviewMcpToolProvider). Run: `flutter test <new_test_file> --plain-name "A3"` must fail (red).
- [ ] T044: **[Finding 3,4]** Implement minimal generated tool suite source and registrar (`lib/src/agent_tools/`) to make A1-A3 tests pass (green). Run: `flutter test <test_file> --plain-name "A1"` / `A2` / `A3` must pass.
- [ ] T045: **[Finding 5]** Implement minimal cassette parity harness (`lib/src/cassette/`) to make A8 test pass (green). Run: `flutter test <test_file> --plain-name "A8"` must pass.
- [ ] T046: **[Finding 1,2,3,4,5]** Add cycle log entries for A1-A3, A8 cycles (red command + output, green change, refactor). Verify: `cat tdd/cycle-log.md` shows Cycle 1+ entries.
- [ ] T047: **[Finding 1,2,3,4,5]** Continue TDD loop for remaining 10 behaviors (A4-A7, A9-A14) per test list order. Each cycle: write failing test, make pass, refactor, log.