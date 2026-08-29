# Tasks: Standardize Dispose Patterns Across Wrapper Classes + HeadlessInAppWebView Double-Dispose Guard

## Phase 0: Setup & Prerequisites

- [ ] T001 Ensure `zikzak_inappwebview` package compiles and test baseline established (suite: 95 pass, 2 compile-broken) [P]
- [ ] T002 Confirm `Disposable` interface exists in `zikzak_inappwebview_platform_interface` with canonical signature `void dispose({bool isKeepAlive = false})` [P]

## Phase 1: HeadlessInAppWebView Double-Dispose Guard (P1 - Core Defect)

- [ ] T003 **[A1]** Write acceptance test: `HeadlessInAppWebView.dispose()` before `run()` releases platform resources exactly once with no leak
- [X] T004 **[U1]** Implement double-dispose guard in `HeadlessInAppWebView.dispose()`: track disposed state, call platform.dispose() at most once
- [ ] T005 **[U2]** Implement `dispose()` after `run()` completes correctly
- [X] T006 **[U3]** Implement idempotent second `dispose()` call (no-op)
- [X] T007 **[U4]** Implement `dispose(isKeepAlive: true)` forwards `true` to platform
- [ ] T008 **[U5]** Implement `dispose(isKeepAlive: false)` after `dispose(isKeepAlive: true)` fully releases
- [X] T009 **[U6]** Implement thread-safe disposal (serialized concurrent calls, platform.dispose() at most once)
- [ ] T010 **[A2]** Write acceptance test: Double dispose on started `HeadlessInAppWebView` invokes platform dispose only once
- [ ] T011 **[A3]** Write acceptance test: Concurrent/repeated `dispose()` never throws and never leaks

## Phase 2: Consistent Disposable Contract on All Wrapper Classes (P2)

- [ ] T012 **[U7]** Verify `InAppWebViewController` implements `Disposable` with canonical signature
- [X] T013 **[U8]** Verify `InAppWebViewController.dispose()` forwards to platform with `isKeepAlive`
- [X] T014 **[U9]** Verify `InAppWebViewController` keepAlive semantics: true retains native, false releases
- [ ] T015 **[U10]** Verify `InAppWebView` implements `Disposable` with canonical signature
- [ ] T016 **[U11]** Verify `InAppWebView.dispose()` forwards to platform with `isKeepAlive`
- [ ] T017 **[U12]** Verify `InAppWebView` keepAlive semantics consistent with controller
- [ ] T018 **[U13]** Verify `InAppLocalhostServer` implements `Disposable` with canonical signature
- [X] T019 **[U14]** Implement `InAppLocalhostServer.dispose()` stops server if running (fire-and-forget, swallows errors)
- [X] T020 **[U15]** Implement `InAppLocalhostServer.dispose()` on non-running server (safe, marks disposed)
- [X] T021 **[U16]** Implement idempotent second `dispose()` call on `InAppLocalhostServer`
- [X] T022 **[U17]** Implement `dispose(isKeepAlive: ...)` signature on server (accepted, no behavioral effect)
- [ ] T023 **[A4]** Write acceptance test: All four wrappers declare `implements Disposable`
- [ ] T024 **[A5]** Write acceptance test: `dispose()` on any wrapper forwards to platform with same default parameter
- [ ] T025 **[A6]** Write acceptance test: `InAppLocalhostServer.dispose()` stops server, idempotent

## Phase 3: Consistent keepAlive Semantics Everywhere (P3)

- [ ] T026 **[U18]** Verify `Disposable` interface declares canonical `void dispose({bool isKeepAlive = false})`
- [ ] T027 **[A7]** Write acceptance test: `dispose(isKeepAlive: true)` on keep-alive controller retains native view
- [ ] T028 **[A8]** Write acceptance test: Subsequent `dispose()` without keep-alive fully releases native view
- [ ] T029 **[A9]** Write acceptance test: `isKeepAlive` default and semantics identical across all wrappers

## Phase 4: Validation & Regression

- [ ] T030 Run full test suite in `zikzak_inappwebview` package (target: all pass, no new compile errors)
- [ ] T031 Run analyzer: `flutter analyze` (target: no new warnings)
- [ ] T032 Verify compile-time `expectDisposable<T>()` checks pass for all four wrappers
- [ ] T033 Verify existing `disposable_pattern_test.dart` still passes (compile-time contract test)
- [ ] T034 Verify no `UnimplementedError` thrown by disposal in normal or repeated-dispose paths