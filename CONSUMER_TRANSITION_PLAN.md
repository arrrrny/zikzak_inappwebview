# Consumer Transition Plan

**Tracks**: Issue #264, Spec 003 (FR-008)

This document describes how downstream consumers migrate from the plugin
core's value-add classes to the new `zikzak_inappwebview_module`.

## Naming / Location Decision

- **Module package**: `zikzak_inappwebview_module/` (in-repo, sibling to
  `zikzak_inappwebview/`)
- **Naming convention**: `zikzak_inappwebview_module` on pub (when published)

## Deprecation / Re-export Window

During the transition, the plugin core will re-export the module's public
surface so existing imports continue to compile. A deprecation annotation
points consumers to the new import path.

### Phase 1: Re-exports (this PR)

The plugin core keeps existing exports but marks them as deprecated:

```dart
// In zikzak_inappwebview/lib/src/main.dart (future):
@Deprecated('Import from zikzak_inappwebview_module instead')
export 'package:zikzak_inappwebview_module/zikzak_inappwebview_module.dart'
    show WebViewPool, CaptureSource, ...;
```

### Phase 2: Removal (after consumers migrate)

Remove the re-exports and the deprecated classes from the plugin core.
Consumers must import directly from the module.

## Known Consumers

### zik_zak (webview.* agent tools)

- **Current**: Imports value-add classes from `zikzak_inappwebview` directly.
- **Target**: Import from `zikzak_inappwebview_module` and use generated
  `webview.*` tools via the zuraffa registrar.
- **Migration**: Replace direct class imports with module imports;
  agent tool registration moves to the module's thin registrar.

### dws_playground (golden missions GM-2, GM-4, GM-5)

- **Current**: Uses plugin core's capture, pool, and recipe classes.
- **Target**: Import from `zikzak_inappwebview_module`.
- **Migration**: Update imports; golden missions re-pointed to module
  tools (spec 006 US-4).

### dart_web_scraper (web view fetch path)

- **Current**: Creates its own headless webview instances.
- **Target**: Use `WebViewPool` from the module to avoid double-rendering.
- **Migration**: Replace direct `HeadlessInAppWebView` creation with
  `WebViewPool.acquire` / `release`.

## Non-Zuraffa Consumers

Consumers that don't use the zuraffa runtime can:

1. Import the plugin core directly for thin-core usage (widget, controller,
   headless, cookies) — no zuraffa dependency.
2. Import `zikzak_inappwebview_module` for pool / capture / VCR — depends
   only on the plugin core's public API, not on zuraffa.

The standalone import path is documented in the module's README.
