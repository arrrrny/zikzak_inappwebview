# Tasks: Portable Sessions for zikzak_inappwebview (via zikzak_session)

**Input**: Design documents from `/specs/014-portable-sessions/`

**Prerequisites**: plan.md (required), spec.md (required)

**Tests**: Mandatory — tests must be written and observed failing before implementation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Dependencies & Configuration)

**Purpose**: Add zikzak_session dependency and verify existing types

- [x] T001 [US3] Add `zikzak_session` path dependency to `zikzak_inappwebview/pubspec.yaml`: `zikzak_session: {path: ../../zikzak_session}` with comment documenting flip to hosted when published (per FR-008)
- [x] T002 [US3] Verify `PortableSession`, `CookieEntry`, `StorageEntry`, and `SessionPort` are exported from `package:zikzak_session/zikzak_session.dart`
- [x] T003 [US3] Verify `FileSessionStore` is available for test infrastructure (temp dir usage)

---

## Phase 2: Controller Implementation (Core)

**Purpose**: Implement the `WebViewSessions` controller in the main plugin package

- [x] T004 [US1] Create `zikzak_inappwebview/lib/src/webview_sessions/webview_sessions.dart` with `WebViewSessions` class:
  - Constructor accepting required `SessionPort port` and optional `CookieManager? cookieManager` (FR-007)
  - Lazy `CookieManager` getter (platform-channel boundary)
  - `save(controller, sessionId, name, url)` method harvesting cookies + localStorage (FR-001, FR-002, FR-003)
  - `load(controller, sessionId, url)` method restoring cookies + localStorage, returning `bool` (FR-001, FR-004)
  - `list()` and `delete(sessionId)` delegating to port (FR-001)
  - Static `toCookieEntry(Cookie)` mapping with value stringification (FR-005)
  - Static `harvestLocalStorage(evaluator)` with error/empty handling (FR-003, FR-006)
  - Static `applyLocalStorage(evaluator, storage)` with per-key JSON encoding (FR-004, FR-006)
  - Private `_originOf(WebUri)` helper (FR-003, FR-004)

- [x] T005 [US3] Export `WebViewSessions` from `zikzak_inappwebview/lib/zikzak_inappwebview.dart`

---

## Phase 3: Test Implementation (Mandatory — Tests First)

**Purpose**: Write all tests for the feature — must fail before implementation

- [x] T006 [US1] Write `test/webview_sessions_test.dart` with test groups:
  - `cookie mapping (FR-005)`: `toCookieEntry` field-by-field, null optionals → defaults [A5, U1-U7]
  - `localStorage harvest/apply (FR-003/FR-004)`: harvest via evaluator, empty/error cases, apply with JSON escaping [A6, U8-U13]
  - `session round-trip through the port (FR-002/US1)`: save→persist→load with cookies + storage, list, delete [A1, A3, A4, U14-U20]
  - `load semantics (FR-004/US1 scenario 3)`: unknown session returns false, no throw [A2, U16-U18]
  - `port injection (FR-007)`: custom `SessionPort` implementation works [A4, U22]
  - Use `FileSessionStore` against temp dir, fake evaluator closure for JS paths

---

## Phase 4: Implementation Verification

**Purpose**: Run tests and verify implementation matches spec

- [x] T007 [US1] Run `flutter test test/webview_sessions_test.dart` from `zikzak_inappwebview` package directory — all tests must pass
- [x] T008 [US3] Run `flutter test` (full suite in umbrella package) — confirm no new regressions beyond pre-existing 2 compile-broken files
- [x] T009 [US1] Verify `WebViewSessions` example from spec.md doc comment compiles and runs conceptually (manual review)

---

## Phase 5: Cross-Cutting & Polish

**Purpose**: Final validation and documentation

- [ ] T010 [US3] Verify `WebUri` and `Cookie` types from `zikzak_inappwebview_platform_interface` work correctly in mapping
- [ ] T011 [US1] Add/update doc comments on `WebViewSessions` public methods with FR traceability
- [ ] T012 [US3] Update `PROGRESS.md` with status entry for portable sessions completion

---

## Phase 6: Acceptance Criteria Validation (Outer Loop)

**Purpose**: Each acceptance criterion must have a passing end-to-end test

- [x] T013 [US1] A1: Save harvests cookies + localStorage, persists via SessionPort — verified by test `session round-trip through the port` [A1]
- [x] T014 [US1] A2: Load restores cookies + localStorage, returns false on missing — verified by test `load semantics` [A2]
- [x] T015 [US2] A3: Two named sessions coexist without contamination — verified by test `two named sessions coexist without contamination` [A3]
- [x] T016 [US3] A4: Controller exposes save/load/list/delete with injectable SessionPort — verified by test `port injection` [A4]
- [x] T017 [US1] A5: Cookie mapping field-by-field with stringification — verified by test `cookie mapping` [A5]
- [x] T018 [US1] A6: Storage entries carry key, value, origin, area=localStorage — verified by test `localStorage harvest/apply` [A6]

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Controller (Phase 2)**: Depends on Setup — T001 must complete first
- **Tests (Phase 3)**: Depends on Setup — can write tests against imports
- **Verification (Phase 4)**: Depends on Controller + Tests — implementation must exist
- **Polish (Phase 5)**: Depends on Verification passing
- **Acceptance (Phase 6)**: Depends on Verification passing — confirms outer loop

### Within Phase 2 (Controller)

- T004 (webview_sessions.dart) before T005 (export)

### Within Phase 3 (Tests)

- All test groups can be written in parallel (same file, different groups)

### Parallel Opportunities

- Phase 1: T001, T002, T003 can run in parallel
- Phase 3: All test groups can be written in parallel
- Phase 6: All acceptance validations can run in parallel

---

## Notes

- All test tasks are **MANDATORY** — no "OPTIONAL" or "only if tests requested" qualifiers. Tests must be observed failing first (Red phase).
- Behavior markers `[A1]`, `[U1]` etc. link tasks to the test list in `specs/014-portable-sessions/tdd/test-list.md`.
- The two pre-existing compile-broken files (`headless_dispose_test.dart`, `webview_sessions_test.dart` with missing `zikzak_session` dep) are NOT this feature's responsibility. They must be fixed separately before a clean TDD cycle can run.
- The `zikzak_session` dependency is a path dep during development; flip to hosted version when `zikzak_session` is published.

---

## Phase 7: TDD Remediation (from verification report)

**Purpose**: Address findings from `/speckit.tdd.verify` — the feature was implemented test-after, not test-first.

**Verdict**: FAIL — feature not done until blocking findings are cleared.

### Blocking Findings (HIGH)

- [ ] T019 [US1] **Finding #1**: No test-first discipline — feature implemented in single commit with no red phase
  - **Fix**: Re-implement feature using TDD cycle: for each behavior in `specs/014-portable-sessions/tdd/test-list.md`, write failing test first (RED), then make it pass (GREEN), then refactor. Record each cycle in `specs/014-portable-sessions/tdd/cycle-log.md`.
  - **Proof**: `flutter test test/webview_sessions_test.dart` passes AND cycle-log has entries for A1–A6, U1–U22 with red→green evidence.

- [ ] T020 [US1] **Finding #2**: Test list and cycle log created post-hoc; do not reflect actual development
  - **Fix**: Reconstruct honest cycle log by replaying TDD cycles, or acknowledge test-after in cycle-log.md with a note entry.
  - **Proof**: `cycle-log.md` has cycle entries matching test-list.md behaviors, or explicit note that feature was test-after.

- [x] T021 [US3] **Finding #3**: Test file does not compile at current HEAD (missing `zikzak_session` dependency)
  - **Fix**: Add `zikzak_session: ^0.1.0` (hosted) or `zikzak_session: {path: ../../zikzak_session}` to `zikzak_inappwebview/pubspec.yaml` and run `flutter pub get`.
  - **Proof**: `flutter test test/webview_sessions_test.dart` runs without import errors. (Resolved: `zikzak_session: ^0.2.0` hosted, 10/10 pass.)

- [x] T022 [US3] **Finding #4**: Source file does not compile at current HEAD (same missing dependency)
  - **Fix**: Same as T021 — add the dependency.
  - **Proof**: `flutter analyze lib/src/webview_sessions/webview_sessions.dart` passes. (Resolved with T021.)

### Non-blocking Findings (MED/LOW)

- [ ] T023 [US1] **Finding #5**: No end-to-end tests through real webview entry point (all tests use fake evaluator)
  - **Fix**: Add `integration_test/` test using real `InAppWebViewController` on iOS simulator (device available) to validate save→load round-trip through actual platform channels.
  - **Proof**: `flutter test integration_test/portable_sessions_test.dart` passes on iOS simulator.

- [ ] T024 [US1] **Finding #6**: Clock injection boundary (U21) not directly tested — `DateTime.now()` in `save` not injectable
  - **Fix**: Make clock injectable in `WebViewSessions` (optional `clock` parameter defaulting to `DateTime.now`), add test for boundary (save timestamp captured before/after).
  - **Proof**: Test `clock_injection` in `test/webview_sessions_test.dart` passes with fixed and injected clock.

- [ ] T025 [US1] **Finding #7**: `save` overwrite behavior (same sessionId) not explicitly tested
  - **Fix**: Add test `save overwrites existing session with same id` in `session round-trip` group.
  - **Proof**: New test passes.

- [ ] T026 [US1] **Finding #8**: `load` with valid session but empty cookies/storage not tested
  - **Fix**: Add test `load with empty cookies/storage returns true and does not throw` in `load semantics` group.
  - **Proof**: New test passes.

- [ ] T027 [US1] **Finding #9**: No mutation/deliberate-mutant validation of test strength
  - **Fix**: After T019–T022 complete, run deliberate mutants on high-risk behaviors: cookie mapping boundaries (U2–U7), session isolation (A3), load-not-found (U16).
  - **Proof**: Record mutant results in `specs/014-portable-sessions/tdd/verification.md` mutation section.