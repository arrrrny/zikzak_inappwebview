# Implementation Tasks: Split InAppWebViewController into Domain-Specific Controllers

Tasks are ordered by dependency. Test tasks must precede implementation tasks for the same behavior. Behavior markers `[A#]`/`[U#]` link each task to its test-list entry.

## Phase 0: Setup

- [X] T001: Verify baseline suite (95 pass, 2 compile-broken pre-existing) and confirm test environment

## Phase 1: Domain Controller Facades (Consumer Layer)

### NavigationController
- [ ] T002: [U10-U28] Write failing tests for NavigationController method delegation
- [ ] T003: [U10-U28] Implement NavigationController delegation to parent controller

### JavaScriptController
- [ ] T004: [U29-U45] Write failing tests for JavaScriptController method delegation
- [ ] T005: [U29-U45] Implement JavaScriptController delegation to parent controller

### CookieController
- [ ] T006: [U46-U65] Write failing tests for CookieController URL resolution and graceful degradation
- [ ] T007: [U46-U65] Implement CookieController with default-to-current-URL semantics

### SettingsController
- [ ] T008: [U66-U67] Write failing tests for SettingsController method delegation
- [ ] T009: [U66-U67] Implement SettingsController delegation to parent controller

## Phase 2: Monolithic Controller Integration

- [X] T010: [U1-U4] Write failing tests for lazy singleton facade getters on InAppWebViewController
- [X] T011: [U1-U4] Implement lazy singleton getters for navigation, javaScript, cookies, settings
- [ ] T012: [U5-U8] Write failing tests for monolithic controller delegation to facades
- [ ] T013: [U5-U8] Ensure all grouped methods on InAppWebViewController delegate to corresponding facade
- [ ] T014: [U9] Write surface test verifying InAppWebViewController public method surface unchanged
- [ ] T015: [A1] Write acceptance test: existing consumer code compiles and behaves identically (backward compatibility)

## Phase 3: Platform Interface Delegates

- [X] T016: [U68-U72] Write failing tests for platform interface delegate getters (null by default)
- [X] T017: [U68-U72] Verify PlatformInAppWebViewController exposes four nullable delegate getters
- [ ] T018: [U73] Write failing tests for PlatformNavigationDelegate method surface
- [ ] T019: [U74] Write failing tests for PlatformJavaScriptDelegate method surface
- [ ] T020: [U75] Write failing tests for PlatformCookieDelegate method surface
- [ ] T021: [U76] Write failing tests for PlatformSettingsDelegate method surface

## Phase 4: Platform Implementation Migration (Android)

- [X] {t}: [U77] Write failing test for Android navigationDelegate override
- [X] {t}: [U77] Implement Android PlatformNavigationDelegate and wire navigationDelegate getter
- [X] {t}: [U78] Write failing test for Android javaScriptDelegate override
- [X] {t}: [U78] Implement Android PlatformJavaScriptDelegate and wire javaScriptDelegate getter
- [X] {t}: [U79] Write failing test for Android cookieDelegate override
- [X] {t}: [U79] Implement Android PlatformCookieDelegate and wire cookieDelegate getter
- [X] {t}: [U80] Write failing test for Android settingsDelegate override
- [X] {t}: [U80] Implement Android PlatformSettingsDelegate and wire settingsDelegate getter
- [ ] T030: [A6-Android] Write acceptance test: Android delegates non-null and migrated methods produce identical results

## Phase 5: Platform Implementation Migration (iOS)

- [X] {t}: [U81] Write failing test for iOS navigationDelegate override
- [X] {t}: [U81] Implement iOS PlatformNavigationDelegate and wire navigationDelegate getter
- [X] {t}: [U82] Write failing test for iOS javaScriptDelegate override
- [X] {t}: [U82] Implement iOS PlatformJavaScriptDelegate and wire javaScriptDelegate getter
- [X] {t}: [U83] Write failing test for iOS cookieDelegate override
- [X] {t}: [U83] Implement iOS PlatformCookieDelegate and wire cookieDelegate getter
- [X] {t}: [U84] Write failing test for iOS settingsDelegate override
- [X] {t}: [U84] Implement iOS PlatformSettingsDelegate and wire settingsDelegate getter
- [ ] T039: [A6-iOS] Write acceptance test: iOS delegates non-null and migrated methods produce identical results

## Phase 6: Generated Code / DI Wiring (zorphy)

- [X] T040: [U85] Write failing test for generated wiring resolves all four delegates
      → N/A: zorphy is entity-serialization codegen only (all `.zorphy` under `lib/src/domain/entities/`); there is no generated controller DI. Delegates are wired manually via `override` getters (done in Phase 4/5, U77–U84).
- [X] T041: [U85] Update zorphy/generated code to register delegates correctly
      → N/A for the same reason as T040.
- [X] T042: [U86] Verify no orphaned or duplicated wiring in generated code
      → N/A: no generated delegate wiring exists; the single wiring path is the manual override getters, one per delegate, no orphans.

## Phase 7: Acceptance Criteria Verification

- [ ] T043: [A2] Write acceptance test: NavigationController facade works identically to monolithic
- [ ] T044: [A3] Write acceptance test: JavaScriptController facade works identically to monolithic
- [ ] T045: [A4] Write acceptance test: CookieController facade works with default URL and graceful degradation
- [ ] T046: [A5] Write acceptance test: SettingsController facade works identically to monolithic
- [ ] T047: [SC-001, SC-002] Verify full existing consumer test suite passes unchanged
- [ ] T048: [SC-003] Verify all four domain facades present and expose documented method subsets
- [ ] T049: [SC-004] Verify Android and iOS delegate getters return non-null concrete instances
- [ ] T050: [SC-005] Verify cookie operations without current URL degrade gracefully
- [ ] T051: [SC-006] Verify each domain controller facade is instantiated exactly once per parent controller

## Phase 8: Edge Cases and Invariants

- [ ] T052: [Edge] Test domain controller calls on disposed controller don't crash
- [ ] T053: [Edge] Test domain controller facades work identically for HeadlessInAppWebView
- [ ] T054: [Edge] Test cross-domain state consistency (settings affecting navigation)
- [ ] T055: [Edge] Test concurrent access to multiple domain controllers on same parent

## Phase N: TDD remediation

- [X] R001: [HIGH] Export PlatformCookieDelegate and PlatformSettingsDelegate from platform interface main export (fixes Finding 1, 4)
  - File: zikzak_inappwebview_platform_interface/lib/src/in_app_webview/main.dart
  - Command: flutter test test/in_app_webview_controller_delegates_test.dart

- [X] R002: [HIGH] Add cookieDelegate and settingsDelegate getters to PlatformInAppWebViewController base class (fixes Finding 1, 5)
  - File: zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_inappwebview_controller.dart
  - Command: flutter test test/in_app_webview_controller_delegates_test.dart

- [ ] R003: [HIGH] Fix pre-existing compile-broken tests in umbrella package (unblocks TDD loop per profile)
  - File: zikzak_inappwebview/test/headless_dispose_test.dart (restore `disposed` getter on HeadlessInAppWebView)
  - File: zikzak_inappwebview/test/webview_sessions_test.dart (add zikzak_session dependency or remove broken test)
  - Command: flutter test (in zikzak_inappwebview)

- [ ] R004: [HIGH] Write first acceptance test for A1 (backward compatibility) and run red→green cycle
  - File: zikzak_inappwebview/test/domain_split_backward_compat_test.dart (new)
  - Command: flutter test test/domain_split_backward_compat_test.dart --plain-name "A1"

- [ ] R005: [HIGH] Write acceptance test for A15 (Android delegates non-null) and run red→green cycle
  - File: zikzak_inappwebview_android/test/android_delegates_test.dart (new)
  - Command: flutter test test/android_delegates_test.dart --plain-name "A15"

- [ ] R006: [HIGH] Write acceptance test for A16 (iOS delegates non-null) and run red→green cycle
  - File: zikzak_inappwebview_ios/test/ios_delegates_test.dart (new)
  - Command: flutter test test/ios_delegates_test.dart --plain-name "A16"

- [ ] R007: [MED] Replace compile-time probe tests in domain_controllers_test.dart with behavioral tests
  - File: zikzak_inappwebview/test/domain_controllers_test.dart
  - Command: flutter test test/domain_controllers_test.dart