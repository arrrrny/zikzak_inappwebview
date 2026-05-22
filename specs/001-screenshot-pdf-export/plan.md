# Implementation Plan: Screenshot and PDF Export

**Branch**: `001-screenshot-pdf-export` | **Date**: 2026-05-22 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-screenshot-pdf-export/spec.md`

## Summary

Add or restore `takeScreenshot` and `createPdf` support across three priority platforms (iOS, Android, macOS) and the Linux nice-to-have platform. iOS already has both features fully working. The implementation gaps are: macOS `takeScreenshot` (missing entirely), Android `createPdf` (disabled, needs re-implementation), Linux `createPdf` Dart wiring (native C exists but unreachable), and Linux `takeScreenshot` (new implementation).

## Technical Context

**Language/Version**: Dart 3.x, Swift 5.x (iOS/macOS), Kotlin/Java (Android), C++17 (Linux)

**Primary Dependencies**: Flutter 3.x, WKWebView (iOS/macOS), Android WebView (Android), WebKitGTK (Linux)

**Storage**: N/A (in-memory byte buffers returned to callers)

**Testing**: Flutter widget tests (integration package), platform-specific manual verification on real devices

**Target Platform**: iOS 11.0+ (screenshot) / 14.0+ (PDF), macOS 10.13+ (screenshot) / 11.0+ (PDF), Android API 21+, Linux (WebKitGTK)

**Project Type**: Flutter federated plugin (multi-package library with platform interface + per-platform implementations)

**Performance Goals**: Screenshot <3s for typical page, PDF export <5s for 10-page content

**Constraints**: Must not introduce new external dependencies; must use platform-native APIs only

**Scale/Scope**: 5 packages modified (main, platform_interface, android, macos, linux), 2 out-of-scope (windows, web)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution is a template placeholder (never filled in). No gates to enforce. The implementation follows the existing federated plugin architecture patterns already established in the codebase.

## Project Structure

### Documentation (this feature)

```text
specs/001-screenshot-pdf-export/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (by /speckit.tasks)
```

### Source Code (repository root)

```text
zikzak_inappwebview_platform_interface/
└── lib/src/
    ├── in_app_webview/platform_inappwebview_controller.dart  # takeScreenshot, createPdf abstracts
    └── types/
        ├── screenshot_configuration.dart  # ScreenshotConfiguration
        └── pdf_configuration.dart          # PDFConfiguration

zikzak_inappwebview/
└── lib/src/
    ├── in_app_webview/in_app_webview_controller.dart    # Main facade (delegates)
    └── in_app_webview/apple/in_app_webview_controller.dart  # Deprecated Apple facade

zikzak_inappwebview_ios/
├── lib/src/in_app_webview/in_app_webview_controller.dart   # Dart controller (FULL - verify)
├── ios/Classes/InAppWebView/InAppWebView.swift             # Native Swift (FULL - verify)
├── ios/Classes/InAppWebView/WebViewChannelDelegate.swift   # Channel dispatch (FULL - verify)
└── ios/Classes/InAppWebView/WebViewChannelDelegateMethods.swift  # Enum (FULL - verify)

zikzak_inappwebview_macos/
├── lib/src/in_app_webview/in_app_webview_controller.dart   # Dart controller (ADD takeScreenshot)
└── macos/Classes/InAppWebView.swift                        # Native Swift (ADD takeScreenshot)

zikzak_inappwebview_android/
├── lib/src/in_app_webview/in_app_webview_controller.dart   # Dart controller (ENABLE createPdf)
├── android/src/.../webview/in_app_webview/InAppWebView.java         # Native Java (ADD createPdf)
├── android/src/.../webview/WebViewChannelDelegate.java              # Channel dispatch (ADD createPdf)
└── android/src/.../webview/WebViewChannelDelegateMethods.java       # Enum (ADD createPdf)

zikzak_inappwebview_linux/
├── lib/src/in_app_webview/in_app_webview_controller.dart   # Dart controller (ADD takeScreenshot, ADD createPdf)
└── linux/in_app_webview.cc                                 # Native C (ADD takeScreenshot)
```

**Structure Decision**: Federated Flutter plugin with platform interface + per-platform packages. Each platform package contains Dart method channel code and native code (Swift, Java, C++) connected via Flutter method channels.

## Complexity Tracking

No violations. All changes follow existing patterns within the established federated plugin architecture.
