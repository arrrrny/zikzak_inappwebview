# Implementation Plan: Dismiss Dialogues Setting

**Branch**: `002-dismiss-dialogues` | **Date**: 2026-05-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/002-dismiss-dialogues/spec.md`

## Summary

Add a `dismissDialogues` boolean setting (default: `true`) to `InAppWebViewSettings` that automatically removes fixed/sticky positioned elements from loaded web pages. The removal logic runs after page load with retries to catch dynamically appearing dialogs, enabling clean captures (screenshot, PDF, HTML).

## Technical Context

**Language/Version**: Dart 3.x, Swift 5.x (iOS/macOS), Kotlin/Java (Android)

**Primary Dependencies**: Flutter 3.x, WKWebView (iOS/macOS), Android WebView (Android), WebKitGTK (Linux)

**Storage**: N/A (in-memory setting, applied at runtime)

**Testing**: Flutter widget tests, platform-specific manual verification

**Target Platform**: iOS 11.0+, Android API 21+, macOS 10.13+, Linux (WebKitGTK), Windows (WebView2), Web

**Project Type**: Flutter federated plugin (multi-package library with platform interface + per-platform implementations)

**Performance Goals**: Overlay removal completes within 3 retries (with delays) — negligible impact on page load time

**Constraints**: Must follow existing `@ExchangeableObject` annotation pattern for settings; removal must only affect top-level document (not iframes); errors during removal must not propagate

**Scale/Scope**: 1 package modified (platform_interface), with native bridge updates across all 6 platform packages

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution is a template placeholder (never filled in). No gates to enforce. The implementation follows the existing federated plugin architecture patterns already established in the codebase.

## Project Structure

### Documentation (this feature)

```text
specs/002-dismiss-dialogues/
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
    ├── in_app_webview/in_app_webview_settings.dart       # Annotated template — ADD dismissDialogues property
    └── in_app_webview/in_app_webview_settings.g.dart     # Generated — REGENERATE after annotation change

zikzak_inappwebview/
└── lib/src/
    └── in_app_webview/in_app_webview_controller.dart     # Main facade — ADD dismissDialogues invocation logic on page load

zikzak_inappwebview_ios/
├── lib/src/in_app_webview/in_app_webview_controller.dart      # Dart controller — PASS dismissDialogues to native
└── ios/.../InAppWebView/InAppWebViewSettings.swift              # Native Swift — ADD dismissDialogues property

zikzak_inappwebview_android/
├── lib/src/in_app_webview/in_app_webview_controller.dart        # Dart controller — PASS dismissDialogues to native
└── android/.../webview/in_app_webview/InAppWebViewSettings.java # Native Java — ADD dismissDialogues property

zikzak_inappwebview_macos/
├── lib/src/in_app_webview/in_app_webview_controller.dart  # Dart controller — PASS dismissDialogues to native
└── macos/.../InAppWebViewSettings.swift                   # Native Swift — ADD dismissDialogues property

zikzak_inappwebview_windows/
├── lib/src/in_app_webview/in_app_webview_controller.dart  # Dart controller — PASS dismissDialogues to native
└── windows/.../in_app_webview_settings.dart                # Native Dart — ADD dismissDialogues property

zikzak_inappwebview_linux/
├── lib/src/in_app_webview/in_app_webview_controller.dart  # Dart controller — PASS dismissDialogues to native
└── linux/.../in_app_webview_settings.cc                   # Native C++ — ADD dismissDialogues property

zikzak_inappwebview_web/
├── lib/src/in_app_webview/in_app_webview_controller.dart  # Dart controller — PASS dismissDialogues to native
└── web/.../in_app_webview_settings.dart                   # Native Dart — ADD dismissDialogues property
```

**Structure Decision**: Federated Flutter plugin with platform interface + 6 platform packages. The `dismissDialogues` setting follows the same pattern as all existing settings: annotate on the template class in platform_interface, regenerate `.g.dart`, then propagate to each platform's native settings class.

## Complexity Tracking

No violations. All changes follow existing patterns within the established federated plugin architecture.
