# Tasks: WebView Lifecycle Integration Tests

## Phase 1: Hot Restart Integration Test (P1)

- [ ] T01 [A1,A2,A3] Write integration test for hot restart (reassemble) scenario
- [ ] T02 [A1,A2,A3] Implement hot restart test harness and verification logic

## Phase 2: Android Activity Recreation Test (P2)

- [ ] T03 [A4,A5,A6] Write integration test for Activity recreation (rotation + background→foreground)
- [ ] T04 [A4,A5,A6] Implement Activity recreation test harness and verification logic

## Phase 3: FlutterFragment Registration Test (P3)

- [ ] T05 [A7,A8,A9] Write integration test for FlutterFragment registration without Activity
- [ ] T06 [A7,A8,A9] Implement FlutterFragment test harness and verification logic

## Phase 4: Windows WebView2 Read-Only Directory Test (P3)

- [ ] T07 [A10,A11,A12] Write integration test for Windows WebView2 read-only install directory
- [ ] T08 [A10,A11,A12] Implement Windows WebView2 test harness and verification logic

## Phase 5: CI Integration and Cross-Platform Wiring (P2)

- [ ] T09 Wire all four test suites into per-platform CI (Android, Windows, iOS simulator)
- [ ] T10 Verify tests demonstrably exercise zorphy-based platform interface (FR-005, SC-006)

## Notes

- All test tasks are MANDATORY (not optional) and must be observed failing first before implementation.
- Behavior markers `[A#]` must remain on every task they cover for `/speckit.tdd.run` and `/speckit.implement` to track progress.
- The existing `example/integration_test/lifecycle_test.dart` already has partial coverage (hot restart, background→foreground, plugin registration, HeadlessInAppWebView dispose). These tasks extend and complete the test coverage per spec.md.

## Phase 2: TDD remediation

- [ ] R01 [F1] Establish test-first discipline: for each behavior A1–A12, write a failing test (RED), record in cycle-log.md, then make it pass. Start with A1/A2 hot restart (currently failing).
- [ ] R02 [F2] Fix hot restart test timeout: investigate why `reassembleApplication()` does not yield a new controller; ensure test waits for correct re-initialization.
- [ ] R03 [F3] Add missing test for A3: hot restart mid-load — onLoadStop fires exactly once for final load after restart.
- [ ] R04 [F4] Add rotation test for A4: simulate Android configuration change (orientation) via platform channel or integration_test driver, not just background/foreground.
- [ ] R05 [F5] Add missing test for A6: Activity recreation mid-load — verify WebView content preserved/restored.
- [ ] R06 [F6] Expand A7 test to cover A8/A9: controller creation without Activity, later Activity attachment binding, and teardown before Activity.
- [ ] R07 [F7] Implement Windows WebView2 read-only directory test (A10/A11/A12): requires Windows CI runner; implement test body and remove `skip: true`.
- [ ] R08 [F8] Add test for edge case: cold start vs warm restart distinction.
- [ ] R09 [F9] Add test for edge case: multiple WebViews during recreation — per-instance channel re-binding.
- [ ] R10 [F10] Verify all tests exercise zorphy-based platform interface (post-#226) and not legacy API.
- [ ] R11 [F11] Wire all four test suites into per-platform CI (Android emulator, Windows, iOS simulator).