# zikzak_inappwebview_module

Value-add module for `zikzak_inappwebview` — the intelligence layer that
consumes only the plugin core's public API.

## Status

**Early scaffold** — port interfaces and service stubs. Blocked on
zuraffa#389 (package SDK / package mode) for codegen integration.

## Architecture

This package is the **module tier** of the two-tier rewrite described in
the [split map](../SPLIT_MAP.md). It owns:

- **Ports** (abstract interfaces): `WebViewSessionFactory`, `CaptureSource`,
  `CassetteEngine`, `DialogueDismissPort`, `RecipePort`, `NavigationTrackerPort`
- **Services**: `WebViewPool`, capture service, VCR service, etc.
- **Models**: Shared data types (Sightings, cassette entries, pool sessions)
- **Agent surface**: Generated `webview.*` tools (via zuraffa codegen, pending #389)

## Seam Contract

This module depends ONLY on the plugin core's public API:
- `InAppWebView` (widget)
- `InAppWebViewController` (controller facades)
- `HeadlessInAppWebView` (headless API)
- `CookieManager` (public cookie facade)
- Raw capture-event stream

It MUST NOT import `zikzak_inappwebview_platform_interface` internals.

## Consumer Paths

### Zuraffa-based consumer (recommended)

```dart
import 'package:zikzak_inappwebview_module/zikzak_inappwebview_module.dart';
// Import the engine module to get all stores + usecases auto-registered.
```

### Standalone / non-zuraffa consumer

```dart
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_module/services/webview_pool.dart';
// Use the pool directly — no zuraffa runtime needed.
```

## Specs

- [003 — Umbrella platform core](../specs/003-rewrite-umbrella-platform-core/spec.md)
- [004 — Extract module (ports & services)](../specs/004-rewrite-extract-module/spec.md)
- [005 — Module wiring (Zuraffa-native)](../specs/005-rewrite-module-wiring/spec.md)
- [006 — Generated agent tools + cassette parity](../specs/006-rewrite-webview-agent-tools/spec.md)
- [007 — WebViewPool](../specs/007-webview-pool-sessions/spec.md)
- [008 — VCR record/replay](../specs/008-vcr-record-replay/spec.md)
- [009 — MCP tool provider](../specs/009-webview-mcp-tool-provider/spec.md)
