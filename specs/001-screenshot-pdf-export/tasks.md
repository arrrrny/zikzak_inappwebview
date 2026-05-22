# Tasks: Screenshot and PDF Export

**Input**: Design documents from `/specs/001-screenshot-pdf-export/`

**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

**Tests**: Not included — the feature spec does not request automated tests. Verification is manual per platform.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Federated Flutter plugin package layout:

```text
zikzak_inappwebview_platform_interface/lib/src/
zikzak_inappwebview/lib/src/
zikzak_inappwebview_ios/lib/src/ + ios/Classes/
zikzak_inappwebview_macos/lib/src/ + macos/Classes/
zikzak_inappwebview_android/lib/src/ + android/src/.../webview/
zikzak_inappwebview_linux/lib/src/ + linux/
zikzak_inappwebview_windows/lib/src/
zikzak_inappwebview_web/lib/src/
```

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Verify existing configuration types and prepare cross-platform guards

- [x] T001 Verify `ScreenshotConfiguration` type in `zikzak_inappwebview_platform_interface/lib/src/types/screenshot_configuration.dart` has all fields needed (compressFormat, quality, rect, snapshotWidth, afterScreenUpdates) — no changes expected
- [x] T002 Verify `PDFConfiguration` type in `zikzak_inappwebview_platform_interface/lib/src/types/pdf_configuration.dart` has all fields needed (rect, pageSize, orientation, margins) — no changes expected
- [x] T003 Verify `PlatformInAppWebViewController.takeScreenshot` and `createPdf` abstract signatures in `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_inappwebview_controller.dart` match contracts

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Cross-platform guards and facade updates that MUST complete before user story platforms do their work

**⚠️ CRITICAL**: These tasks prevent undesired behavior on out-of-scope platforms and ensure facade compatibility

- [x] T004 [P] Add `takeScreenshot` override returning `null` in `zikzak_inappwebview_windows/lib/src/in_app_webview_windows_controller.dart` to prevent `UnimplementedError` throw (per FR-009)
- [x] T005 [P] Add `takeScreenshot` override returning `null` in `zikzak_inappwebview_web/lib/src/in_app_webview_web_controller.dart` to prevent `UnimplementedError` throw (per FR-009)
- [x] T006 Add `takeScreenshot` forwarding method with `@Deprecated` annotation to `IOSInAppWebViewController` in `zikzak_inappwebview/lib/src/in_app_webview/apple/in_app_webview_controller.dart`, matching the existing `createPdf` forwarding pattern (per FR-011)

**Checkpoint**: Foundation ready — Windows/Web safely return null, deprecated facade forwards both methods. Platform-specific user story implementation can now begin.

---

## Phase 3: User Story 1 - Capture WebView Screenshot on macOS (Priority: P1) 🎯 MVP

**Goal**: Implement `takeScreenshot` on macOS using native WKWebView snapshot API, matching iOS behavior

**Independent Test**: Open any URL in a macOS InAppWebView, call `takeScreenshot()`, verify a non-null `Uint8List` containing PNG image data is returned. Test with JPEG format and rect cropping configurations.

### Implementation for User Story 1

- [x] T007 [US1] Add `takeScreenshot` case in `handle(_ call:result:)` method switch in `zikzak_inappwebview_macos/macos/Classes/InAppWebView.swift`, using `@available(macOS 10.13, *)` and `takeSnapshot(with: WKSnapshotConfiguration, completionHandler:)`, mirroring the iOS Swift implementation (format switching via `NSImage` → `NSBitmapImageRep` for JPEG/PNG)
- [x] T008 [US1] Add `takeScreenshot` Dart override to `MacOSInAppWebViewController` in `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart` that invokes `_channel.invokeMethod<Uint8List?>('takeScreenshot', args)` with `screenshotConfiguration?.toMap()` argument, matching the existing `createPdf` override pattern in the same file

**Checkpoint**: macOS `takeScreenshot` functional — capture PNG/JPEG screenshots with configuration options

---

## Phase 4: User Story 2 - Export WebView to PDF on Android (Priority: P1)

**Goal**: Re-enable `createPdf` on Android by implementing native Java PDF generation via `WebView.createPrintDocumentAdapter()` and wiring the Flutter method channel

**Independent Test**: Open any URL in an Android InAppWebView, call `createPdf()`, verify a non-null `Uint8List` containing valid PDF data is returned. Test with `PDFConfiguration` specifying A4 page size.

### Implementation for User Story 2

- [x] T009 [US2] Add `createPdf` entry to `WebViewChannelDelegateMethods` enum in `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/WebViewChannelDelegateMethods.java`
- [x] T010 [US2] Add `createPdf` method to `InAppWebViewInterface` interface in `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/InAppWebViewInterface.java`
- [x] T011 [US2] Implement `createPdf` method in `InAppWebView.java` at `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java` using `createPrintDocumentAdapter()`, `PdfDocument`, temp file in cache directory, byte array readback, and cleanup — parse `PDFConfiguration` from method args for page size/orientation/margins
- [x] T012 [US2] Add `createPdf` case to the method channel switch in `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/WebViewChannelDelegate.java`, dispatching to `webView.createPdf()`
- [x] T013 [US2] Replace the disabled `createPdf` override in `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview_controller.dart` (currently returns `null` at line 2503) with a method channel invocation: `await channel?.invokeMethod<Uint8List?>('createPdf', args)` using `pdfConfiguration?.toMap()`

**Checkpoint**: Android `createPdf` functional — export PDF documents with configuration options

---

## Phase 5: User Story 5 - Verify Existing Screenshot and PDF on iOS (Priority: P1)

**Goal**: Confirm iOS `takeScreenshot` and `createPdf` work correctly — no code changes needed

**Independent Test**: Run iOS InAppWebView example app, call both methods with various configurations, verify byte buffers returned correctly.

### Verification for User Story 5

- [x] T014 [US5] Review iOS `takeScreenshot` implementation: verify Dart override in `zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview_controller.dart` (line 1910) and Swift handler in `zikzak_inappwebview_ios/ios/Classes/InAppWebView/InAppWebView.swift` (line 815) are intact and correct
- [x] T015 [US5] Review iOS `createPdf` implementation: verify Dart override in `zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview_controller.dart` (line 2528) and Swift handler in `zikzak_inappwebview_ios/ios/Classes/InAppWebView/InAppWebView.swift` (line 853) are intact and correct
- [x] T016 [US5] Verify iOS `WebViewChannelDelegate.swift` dispatches both `takeScreenshot` and `createPdf` correctly in `zikzak_inappwebview_ios/ios/Classes/InAppWebView/WebViewChannelDelegate.swift` (lines 150-160 and 454-464) and enum entries exist in `WebViewChannelDelegateMethods.swift`

**Checkpoint**: iOS confirmed working — both screenshot and PDF export verified

---

## Phase 6: User Story 3 - Export WebView to PDF on Linux (Priority: P2)

**Goal**: Wire the existing native C `createPdf` implementation to the Dart controller via method channel

**Independent Test**: Open any URL in a Linux InAppWebView, call `createPdf()`, verify a non-null `Uint8List` containing valid PDF data is returned.

### Implementation for User Story 3

- [x] T017 [US3] Review existing native C `createPdf` handler in `zikzak_inappwebview_linux/linux/in_app_webview.cc` (lines 286-311) — confirm it parses `pdfConfiguration` arguments, creates `WebKitPrintOperation`, writes PDF to temp file, reads bytes, and cleans up. Note any gaps in handling `pageSize`/`orientation`/`margins` from `PDFConfiguration`.
- [x] T018 [US3] Add `createPdf` Dart override to `LinuxInAppWebViewController` in `zikzak_inappwebview_linux/lib/src/in_app_webview/in_app_webview_controller.dart` that invokes `_channel.invokeMethod<Uint8List?>('createPdf', args)` with `pdfConfiguration?.toMap()` argument, matching the iOS/macOS controller pattern

**Checkpoint**: Linux `createPdf` functional — PDF generation via existing native C infrastructure

---

## Phase 7: User Story 4 - Take Screenshot on Linux (Priority: P2)

**Goal**: Implement `takeScreenshot` on Linux using WebKitGTK's snapshot API

**Independent Test**: Open any URL in a Linux InAppWebView, call `takeScreenshot()`, verify a non-null `Uint8List` containing valid PNG image data is returned.

### Implementation for User Story 4

- [x] T019 [US4] Add `takeScreenshot` case to the method call handler in `zikzak_inappwebview_linux/linux/in_app_webview.cc` using `webkit_web_view_get_snapshot()` (already used internally for pixel buffer textures at line 144) to obtain a `cairo_surface_t`, convert to PNG or JPEG bytes via cairo/gdk_pixbuf APIs based on `ScreenshotConfiguration`, and return `Uint8List` via the Flutter result
- [x] T020 [US4] Add `takeScreenshot` Dart override to `LinuxInAppWebViewController` in `zikzak_inappwebview_linux/lib/src/in_app_webview/in_app_webview_controller.dart` that invokes `_channel.invokeMethod<Uint8List?>('takeScreenshot', args)` with `screenshotConfiguration?.toMap()` argument

**Checkpoint**: Linux `takeScreenshot` functional — capture PNG/JPEG screenshots using native WebKitGTK

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final verification across all platforms and documentation validation

- [x] T021 Verify macOS `createPdf` (already implemented) still works correctly — review Dart override in `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart` (line 241) and Swift handler in `zikzak_inappwebview_macos/macos/Classes/InAppWebView.swift` (line 172)
- [x] T022 Verify Android `takeScreenshot` (already implemented) still works correctly — review Dart override in `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview_controller.dart` (line 1919) and Java handler in `InAppWebView.java` (line 1020)
- [x] T023 Run quickstart.md code examples against all implemented platforms and confirm each snippet compiles and returns valid data
- [x] T024 Verify platform interface `@endtemplate` doc comments in `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_inappwebview_controller.dart` reflect updated platform availability for macOS screenshot and Android/Linux PDF
- [x] T025 Verify `takeScreenshot` and `createPdf` return `null` (not throw) when called on an InAppWebView with no loaded content on all platforms (per FR-010)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational — macOS takeScreenshot
- **User Story 2 (Phase 4)**: Depends on Foundational — Android createPdf
- **User Story 5 (Phase 5)**: Depends on Foundational — iOS verification (review only)
- **User Story 3 (Phase 6)**: Depends on Foundational — Linux createPdf wiring
- **User Story 4 (Phase 7)**: Depends on Foundational — Linux takeScreenshot
- **Polish (Phase 8)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (macOS)**: Independent — no dependency on other stories
- **US2 (Android)**: Independent — no dependency on other stories
- **US5 (iOS)**: Independent — no dependency on other stories (verification only)
- **US3 (Linux createPdf)**: Independent — no dependency on other stories (but shares controller file with US4)
- **US4 (Linux takeScreenshot)**: Should follow US3 since both modify `LinuxInAppWebViewController` — implement US3 then US4 in the same controller file

### Within Each User Story

- Native handler before Dart controller (native must exist first, though both can be written in parallel)
- Within Android (US2): Interface → Enum → Implementation → Channel dispatch → Dart controller
- Within macOS (US1): Native Swift → Dart controller
- Within Linux US3: Review native C → Dart override
- Within Linux US4: Native C → Dart override

### Parallel Opportunities

- **Phase 1**: T001, T002, T003 can all run in parallel (different files)
- **Phase 2**: T004 and T005 can run in parallel (different platform files); T006 is independent
- **After Phase 2**: US1, US2, US5 can ALL run in parallel (different platforms, no shared files)
- **After Phase 2**: US3 can run in parallel with US1/US2/US5 (different platform)
- **US4 depends on US3** (shared controller file — implement sequentially)
- **Phase 8**: All Polish tasks can run in parallel after all stories complete

---

## Parallel Example: After Foundational Phase

```bash
# All three P1 stories can start simultaneously:
Task: "US1: Add takeScreenshot Swift handler in zikzak_inappwebview_macos/macos/Classes/InAppWebView.swift"
Task: "US2: Add createPdf to WebViewChannelDelegateMethods enum in .../WebViewChannelDelegateMethods.java"
Task: "US5: Review iOS takeScreenshot implementation in .../InAppWebView.swift"

# Linux createPdf (US3) can also start in parallel:
Task: "US3: Review existing native C createPdf handler in zikzak_inappwebview_linux/linux/in_app_webview.cc"
```

---

## Implementation Strategy

### MVP First (P1 Stories Only)

1. Complete Phase 1: Setup (T001-T003)
2. Complete Phase 2: Foundational (T004-T006) — **CRITICAL — blocks all stories**
3. Complete Phase 3: US1 — macOS takeScreenshot (T007-T008)
4. Complete Phase 4: US2 — Android createPdf (T009-T013)
5. Complete Phase 5: US5 — iOS verification (T014-T016)
6. **STOP and VALIDATE**: All three priority platforms (iOS, Android, macOS) have both `takeScreenshot` and `createPdf` working
7. Deploy/demo as MVP

### Incremental Delivery

1. Setup + Foundational → Cross-platform guards ready
2. Add US1 (macOS screenshot) → Test independently → macOS has both features
3. Add US2 (Android PDF) → Test independently → Android has both features
4. Add US5 (iOS verify) → Confirm iOS unchanged → All three priority platforms complete (SC-006 met)
5. Add US3 (Linux PDF) → Test independently → Linux has PDF export
6. Add US4 (Linux screenshot) → Test independently → Linux has both features
7. Polish → Final verification and doc updates

### Parallel Team Strategy

With multiple developers after Foundational phase:
- Developer A: US1 (macOS screenshot) — T007-T008
- Developer B: US2 (Android PDF) — T009-T013
- Developer C: US5 (iOS verify) — T014-T016, then US3 (Linux PDF) — T017-T018
- After US3 complete: Developer C continues to US4 (Linux screenshot) — T019-T020

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- US3 should complete before US4 (both modify `LinuxInAppWebViewController` — same file)
- Android `InAppWebView.java` is a single large file (~1135+ lines) — T011 should add the `createPdf` method following the same pattern as `takeScreenshot` (lines 1020-1135)
- The macOS Swift handler should mirror the iOS `takeScreenshot` at lines 815-851 of the iOS `InAppWebView.swift` — same API, different availability guard
- Commit after each task or logical group
- Stop at any checkpoint to validate the story independently
