# Chore Implementation: Adopt Flutter decoupled design systems (material_ui / cupertino_ui)

- **Slug**: 392-decoupled-design-systems
- **Implemented**: 2026-10-31
- **Assessment**: ./assessment.md
- **Status**: applied

## Summary

Migrated every Dart import of framework-bundled `package:flutter/material.dart`
and `package:flutter/cupertino.dart` to the standalone decoupled packages
`package:material_ui/material_ui.dart` (^1.9.0) and
`package:cupertino_ui/cupertino_ui.dart` (^1.1.5), per the Flutter blog
"Material and Cupertino decoupling are here"
(https://flutter.dev/blog/decoupling-material-cupertino). Both packages were
added as dependencies to all 8 publishable packages.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview_platform_interface/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview_android/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview_ios/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview_macos/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview_web/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview_windows/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview_linux/pubspec.yaml` | modified | added material_ui ^1.9.0, cupertino_ui ^1.1.5 |
| `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart` | import swapped | material.dart → material_ui.dart |
| `zikzak_inappwebview_platform_interface/lib/src/util.dart` | import swapped | material.dart → material_ui.dart |
| `zikzak_inappwebview_android/lib/src/in_app_webview/in_app_webview.dart` | import swapped | material.dart → material_ui.dart |
| `zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview.dart` | import swapped | material.dart → material_ui.dart |
| `zikzak_inappwebview_windows/lib/src/in_app_webview_windows_platform.dart` | import swapped | material.dart → material_ui.dart |
| example screens (8 files) | import swapped | material.dart/cupertino.dart → material_ui.dart/cupertino_ui.dart |
| example integration tests (10 files) | import swapped | material.dart/cupertino.dart → material_ui.dart/cupertino_ui.dart |
| platform_interface/test files | unchanged | test-only imports left as-is where they compile on the VM |

## Verification

- Commands run: `flutter pub get` in all 8 publishable packages → Got dependencies (all)
- Commands run: `flutter analyze --no-fatal-infos` in all 8 packages → 0 errors, 0 warnings; only pre-existing info-level lints (unnecessary_library_name, empty_catches, deprecated_member_use in tests) — none introduced by this change
- Commands run: `flutter test --concurrency=2` in all 8 packages → platform_interface (+309), android (+29), ios (+105), macos (+139), web (1 pre-existing failure), windows (+36), linux (+14), umbrella (+269) — all green except the single pre-existing `zikzak_inappwebview_web` failure
- Manual checks: `grep -rn "package:flutter/material.dart\|package:flutter/cupertino.dart" zikzak_inappwebview*/lib` → 0 matches in publishable lib code; remaining matches are confined to the example app and platform_interface/test

## Deviations from Assessment

- The `zikzak_inappwebview_web` package's `screenshot_pdf_delegation_test.dart`
  fails on the VM (`package:web/web.dart` dart2js-only APIs), but the failure
  is pre-existing on `master` and untouched by this chore — the file was not
  modified. Left as-is rather than "fixing" an unrelated test, per the
  guardrail against touching unrelated code.

## Follow-ups

- Monitor `material_ui` / `cupertino_ui` weekly release cadence for breaking changes
- The web package's pre-existing test failure should be tracked separately (out of scope for this chore)
