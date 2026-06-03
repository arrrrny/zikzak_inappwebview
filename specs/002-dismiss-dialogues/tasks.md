---
description: "Task list for dismiss-dialogues feature"
---

# Tasks: Dismiss Dialogues Setting

**Input**: Design documents from `specs/002-dismiss-dialogues/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in feature spec. No test tasks generated.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Main package**: `zikzak_inappwebview/`
- **Platform interface**: `zikzak_inappwebview_platform_interface/`
- **iOS package**: `zikzak_inappwebview_ios/`
- **Android package**: `zikzak_inappwebview_android/`
- **macOS package**: `zikzak_inappwebview_macos/`
- **Windows package**: `zikzak_inappwebview_windows/`
- **Linux package**: `zikzak_inappwebview_linux/`
- **Web package**: `zikzak_inappwebview_web/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Review existing patterns and prepare for implementation

- [x] T001 Review existing `InAppWebViewSettings_` annotated template in `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/in_app_webview_settings.dart` to confirm annotation patterns and platform support declarations
- [x] T002 Review `onLoadStop` handling in `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview_controller.dart` to identify where to hook overlay dismissal after page load
- [x] T003 [P] Review iOS native settings in `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebViewSettings.swift` to confirm property pattern
- [x] T004 [P] Review Android native settings in `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java` to confirm property pattern
- [x] T005 [P] Review platform Dart controller files for macOS, Windows, Linux, Web at `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart`, `zikzak_inappwebview_windows/lib/src/in_app_webview_windows_controller.dart`, `zikzak_inappwebview_linux/lib/src/in_app_webview/in_app_webview_controller.dart`, `zikzak_inappwebview_web/lib/src/in_app_webview_web_controller.dart` to understand how settings are passed to each platform

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Code generation setup and annotated template changes that ALL subsequent tasks depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T006 Add `dismissDialogues` property with `@ExchangeableObjectProperty(defaultValue: "false")` annotation and `@SupportedPlatforms(platforms: [PlatformOS.iOS, PlatformOS.android, PlatformOS.macOS, PlatformOS.windows, PlatformOS.linux, PlatformOS.web])` in `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/in_app_webview_settings.dart`
- [x] T007 Regenerate `.g.dart` by running `dart run build_runner build` in `zikzak_inappwebview_platform_interface/`

**Checkpoint**: Foundation ready — `InAppWebViewSettings` now has `dismissDialogues` with default `false` across the generated Dart code

---

## Phase 3: User Story 1 - Default overlay dismissal (Priority: P1) 🎯 MVP

**Goal**: When `dismissDialogues` is `true`, fixed/sticky overlays are automatically removed after page load. The overlay removal script runs with retries to handle dynamic content.

**Independent Test**: Load any web page with fixed/sticky overlays using default settings and verify overlays are absent from the rendered content.

### Implementation for User Story 1

- [x] T008 [P] [US1] Add `dismissDialogues` boolean property to iOS native settings in `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebViewSettings.swift`
- [x] T009 [P] [US1] Add `dismissDialogues` boolean property to Android native settings in `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java`
- [x] T010 [P] [US1] Add `dismissDialogues` property pass-through in iOS Dart controller at `zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview_controller.dart` (handled by .g.dart serialization)
- [x] T011 [P] [US1] Add `dismissDialogues` property pass-through in Android Dart controller at `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview_controller.dart` (handled by .g.dart serialization)
- [x] T012 [P] [US1] Add `dismissDialogues` property pass-through in macOS Dart controller at `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart` (handled by .g.dart serialization)
- [x] T013 [P] [US1] Add `dismissDialogues` property pass-through in Windows Dart controller at `zikzak_inappwebview_windows/lib/src/in_app_webview_windows_controller.dart` (handled by .g.dart serialization)
- [x] T014 [P] [US1] Add `dismissDialogues` property pass-through in Linux Dart controller at `zikzak_inappwebview_linux/lib/src/in_app_webview/in_app_webview_controller.dart` (handled by .g.dart serialization)
- [x] T015 [P] [US1] Add `dismissDialogues` property pass-through in Web Dart controller at `zikzak_inappwebview_web/lib/src/in_app_webview_web_controller.dart` (handled by .g.dart serialization)
- [x] T016 [US1] Implement overlay dismissal JavaScript injection in main web view at `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart`: when `dismissDialogues` is enabled and page load completes via onLoadStop, inject JS to find and remove all `fixed`/`sticky` elements, reset `overflow`/`margin` styles
- [x] T017 [US1] Add retry loop (3 attempts with 800ms delay) around the overlay dismissal JS execution in `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart` to catch dynamically loaded overlays
- [x] T018 [US1] Wrap overlay dismissal in try-catch with silent error handling to ensure JavaScript errors never propagate to the web view in `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart`

**Checkpoint**: User Story 1 complete — overlays are auto-dismissed with default settings, including retries for dynamic content

---

## Phase 4: User Story 2 - Opt-out of overlay removal (Priority: P2)

**Goal**: Setting `dismissDialogues` to `false` preserves all fixed/sticky elements — no automatic DOM modification occurs.

**Independent Test**: Set `dismissDialogues` to `false` and verify that a page with overlays retains all fixed/sticky elements.

### Implementation for User Story 2

- [x] T019 [US2] Add condition check in `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart` to only run overlay dismissal when `dismissDialogues == true`; skip entirely when `false`
- [x] T020 [US2] Ensure no side effects (style resets, DOM queries) occur when `dismissDialogues` is `false` in `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart`

**Checkpoint**: User Story 2 complete — setting `dismissDialogues` to `false` correctly preserves all page overlays

---

## Phase 5: User Story 3 - Dynamic late-loading overlays (Priority: P3)

**Goal**: Overlays that appear dynamically after the initial page load (e.g., delayed popup, cookie consent) are caught by the retry mechanism and removed.

**Independent Test**: Load a page that injects a fixed overlay after a delay and verify the overlay is still removed.

### Implementation for User Story 3

- [x] T021 [US3] Verify retry timing in `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart` is correctly staggered (800ms between retries) and the JavaScript removal function is safely re-invokable (no stale state between retries)
- [x] T022 [US3] Confirm no-op behavior when retry encounters an already-clean page (no errors, no side effects) in `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart`

**Checkpoint**: User Story 3 complete — dynamic overlays appearing within the retry window are successfully removed

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories, build verification, and documentation

- [ ] T023 [P] Run `dart analyze` on all modified packages to verify no static analysis warnings
- [ ] T024 [P] Run `dart run build_runner build --delete-conflicting-outputs` in all modified packages to ensure generated files are up to date
- [ ] T025 Validate end-to-end: build the project with `flutter build` on at least one platform (e.g., iOS or Android) to confirm the new setting compiles correctly
- [ ] T026 Update feature documentation if any README or public docs reference available settings (check `zikzak_inappwebview/README.md`)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3-5)**: All depend on Foundational phase completion
  - User stories can be implemented sequentially in priority order
- **Polish (Final Phase)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — No dependencies on other stories
- **User Story 2 (P2)**: Depends on Foundational phase — Does not depend on US1 (condition check is independent of JS implementation)
- **User Story 3 (P3)**: Depends on Foundational phase — Does not depend on US1/US2 (retry logic verification is independent)

### Within Each User Story

- Annotated template change before code generation
- Platform pass-through tasks are independent of each other ([P])
- JS logic implementation depends on platform pass-through tasks conceptually, but is functionally independent (the main controller handles JS; platform controllers just pass the setting value)

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- Platform pass-through tasks (T008-T015) can all run in parallel
- T016, T017, T018 depend on build_runner regeneration but can be developed concurrently
- After Foundational phase, US1, US2, and US3 tasks can proceed in any order

---

## Parallel Example: User Story 1

```bash
# Launch all platform pass-through tasks in parallel:
Task: "Add dismissDialogues to iOS native settings in .../InAppWebViewSettings.swift"
Task: "Add dismissDialogues to Android native settings in .../InAppWebViewSettings.java"
Task: "Add dismissDialogues pass-through in iOS controller"
Task: "Add dismissDialogues pass-through in Android controller"
Task: "Add dismissDialogues pass-through in macOS controller"
Task: "Add dismissDialogues pass-through in Windows controller"
Task: "Add dismissDialogues pass-through in Linux controller"
Task: "Add dismissDialogues pass-through in Web controller"

# Then implement the JS dismissal logic:
Task: "Implement overlay dismissal JS injection in main controller"
Task: "Add retry loop around JS execution"
Task: "Add try-catch error handling"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test US1 independently — load a page with overlays using defaults, verify they're removed
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready (setting exists, .g.dart regenerated)
2. Add US1 → Default dismissal works → Deploy/Demo (MVP!)
3. Add US2 → Opt-out works → Deploy/Demo
4. Add US3 → Dynamic overlays handled → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Platform Strategy

With multiple developers:

1. Developer A: T006 (annotated template) + T007 (build_runner)
2. Once T007 done, distribute:
   - Developer A: T016, T017, T018 (JS logic in main controller)
   - Developer B: T008, T010 (iOS native + Dart controller)
   - Developer C: T009, T011 (Android native + Dart controller)
   - Developer D: T012, T013, T014, T015 (remaining platforms)
3. After US1 is testable, add US2 and US3

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story is independently completable and testable
- The JS overlay removal script is the core logic — all platform work is just property pass-through
- Commit after each task or logical group (after setup, after each story)
- Stop at any checkpoint to validate story independently
