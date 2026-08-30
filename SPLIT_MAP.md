# Split Map — zikzak_inappwebview Two-Tier Rewrite

**Created**: 2026-08-24
**Tracks**: Issue #264 (Wave Z rewrite: zuraffa v6 webview module — consolidated tracking)
**Specs**: 003–009

This document assigns every Dart-side value-add class in
`zikzak_inappwebview/lib/src/` to exactly one tier:

| Tier | Description |
|------|-------------|
| **Core** | Thin platform plugin: widget, controller facades, platform_interface, native packages. Raw APIs only. |
| **Module** | `zikzak_inappwebview_module` — all policy, state, intelligence, agent surface. |

## Seam Contract

The module depends ONLY on the plugin core's public API surface:
- `InAppWebView` (widget)
- `InAppWebViewController` (controller facades)
- `HeadlessInAppWebView` (headless API)
- `CookieManager` (public cookie facade)
- Raw capture-event stream (network capture event types from platform_interface)
- `InAppBrowser` (browser widget)
- `ChromeSafariBrowser` (custom tab widget)

The module MUST NOT import `zikzak_inappwebview_platform_interface` internals
other than re-exported public facades.

## Class Inventory

### Core Tier (remains in `zikzak_inappwebview`)

These classes provide raw platform plumbing and are part of the thin core.

| Class | File | Rationale |
|-------|------|----------|
| `InAppWebView` | `in_app_webview/in_app_webview.dart` | Core widget — the primary web view component |
| `_InAppWebViewState` | `in_app_webview/in_app_webview.dart` | Widget state (private, core implementation detail) |
| `InAppWebViewController` | `in_app_webview/in_app_webview_controller.dart` | Core controller facade — the seam boundary |
| `HeadlessInAppWebView` | `in_app_webview/headless_in_app_webview.dart` | Core headless API — the seam boundary |
| `AndroidInAppWebViewController` | `in_app_webview/android/in_app_webview_controller.dart` | Platform-specific controller (core native package) |
| `IOSInAppWebViewController` | `in_app_webview/apple/in_app_webview_controller.dart` | Platform-specific controller (core native package) |
| `NavigationController` | `in_app_webview/controllers/navigation_controller.dart` | Raw navigation facade |
| `JavaScriptController` | `in_app_webview/controllers/javascript_controller.dart` | Raw JS evaluation facade |
| `CookieController` | `in_app_webview/controllers/cookie_controller.dart` | Raw cookie channel facade |
| `SettingsController` | `in_app_webview/controllers/settings_controller.dart` | Raw settings channel facade |
| `InAppBrowser` | `in_app_browser/in_app_browser.dart` | Core browser widget |
| `ChromeSafariBrowser` | `chrome_safari_browser/chrome_safari_browser.dart` | Core custom-tab widget |
| `CookieManager` | `cookie_manager.dart` | Core cookie facade (public API surface) |
| `FindInteractionController` | `find_interaction/find_interaction_controller.dart` | Raw find-interaction facade |
| `HttpAuthCredentialDatabase` | `http_auth_credentials_database.dart` | Raw HTTP auth facade |
| `PullToRefreshController` | `pull_to_refresh/pull_to_refresh_controller.dart` | Raw pull-to-refresh facade |
| `WebMessageChannel` | `web_message/web_message_channel.dart` | Raw web messaging facade |
| `WebMessageListener` | `web_message/web_message_listener.dart` | Raw web messaging facade |
| `JavaScriptReplyProxy` | `web_message/web_message_listener.dart` | Raw web messaging facade |
| `WebMessagePort` | `web_message/web_message_port.dart` | Raw web messaging facade |
| `WebAuthenticationSession` | `web_authentication_session/web_authenticate_session.dart` | Raw web auth facade |
| `WebStorageManager` | `web_storage/web_storage_manager.dart` | Raw web storage facade |
| `AndroidWebStorageManager` | `web_storage/android/web_storage_manager.dart` | Platform-specific storage |
| `IOSWebStorageManager` | `web_storage/ios/web_storage_manager.dart` | Platform-specific storage |
| `Storage` | `web_storage/web_storage.dart` | Raw storage abstraction |
| `LocalStorage` | `web_storage/web_storage.dart` | Raw localStorage implementation |
| `SessionStorage` | `web_storage/web_storage.dart` | Raw sessionStorage implementation |
| `WebStorage` | `web_storage/web_storage.dart` | Raw storage facade |
| `WebViewEnvironment` | `webview_environment/webview_environment.dart` | Raw environment setup |
| `PrintJobController` | `print_job/print_job_controller.dart` | Raw print facade |
| `ProxyController` | `proxy_controller.dart` | Raw proxy facade |
| `TracingController` | `tracing_controller.dart` | Raw tracing facade |
| `ServiceWorkerController` | `service_worker_controller.dart` | Raw service-worker facade |
| `AndroidServiceWorkerController` | `service_worker_controller.dart` | Platform-specific service worker |
| `AndroidServiceWorkerClient` | `service_worker_controller.dart` | Platform-specific service worker |
| `ProcessGlobalConfig` | `process_global_config.dart` | Raw process config |
| `InAppLocalhostServer` | `in_app_localhost_server.dart` | Raw localhost server |
| `PathHandler` | `webview_asset_loader.dart` | Raw asset loader (abstract) |
| `CustomPathHandler` | `webview_asset_loader.dart` | Raw asset loader extension |
| `AssetsPathHandler` | `webview_asset_loader.dart` | Raw asset loader |
| `InternalStoragePathHandler` | `webview_asset_loader.dart` | Raw asset loader |
| `ResourcesPathHandler` | `webview_asset_loader.dart` | Raw asset loader |

### Module Tier (moves to `zikzak_inappwebview_module`)

These classes provide policy, state management, intelligence, or agent-facing
capabilities and are extracted behind clean port interfaces.

| Class | Current File | Module Port/Service | Spec |
|-------|-------------|---------------------|------|
| `NetworkCaptureManager` | `in_app_webview/network_capture/network_capture_manager.dart` | `CaptureSource` (port) + adapter | 004, 008 |
| `DialogueDismisser` | `dialogue_dismisser/dialogue_dismisser.dart` | `DialogueDismissPort` | 004 |
| `DialogueDismissRules` | `dialogue_dismisser/dialogue_dismiss_rules.dart` | `DialogueDismissPort` (impl detail) | 004 |
| `DialogueDismissal` | `dialogue_dismisser/dialogue_dismissal.dart` | `DialogueDismissPort` (model) | 004 |
| `NavigationTracker` | `navigation_tracker/navigation_tracker.dart` | `NavigationTrackerPort` | 004 |
| `UrlCycleEntry` | `navigation_tracker/url_cycle_entry.dart` | `NavigationTrackerPort` (model) | 004 |
| `RecipeRecorder` | `session_recipe/recipe_recorder.dart` | `RecipePort` | 004, 008 |
| `RecipeReplayer` | `session_recipe/recipe_replayer.dart` | `RecipePort` | 004, 008 |
| `ReplayDriver` | `session_recipe/recipe_replayer.dart` | `RecipePort` (port) | 004, 008 |
| `InAppWebViewReplayDriver` | `session_recipe/recipe_replayer.dart` | `RecipePort` (adapter) | 004, 008 |
| `RecipeRecording` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `RecipeStepDefinition` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `RecordedSignal` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `RecordedStep` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `ReplayProgress` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `ReplayResult` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `SessionRecipe` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `SessionSnapshot` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `TapTarget` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `CookieEntry` | `session_recipe/models.dart` | `RecipePort` (model) | 004 |
| `RecordingFinished` | `session_recipe/recipe_recorder.dart` | `RecipePort` (event) | 004 |
| `SignalMatched` | `session_recipe/recipe_recorder.dart` | `RecipePort` (event) | 004 |
| `StepAdvanced` | `session_recipe/recipe_recorder.dart` | `RecipePort` (event) | 004 |
| `TapCaptured` | `session_recipe/recipe_recorder.dart` | `RecipePort` (event) | 004 |
| `UrlVisited` | `session_recipe/recipe_recorder.dart` | `RecipePort` (event) | 004 |
| `SelectorCandidateRules` | `session_recipe/selector_candidate_rules.dart` | `RecipePort` (impl detail) | 004 |
| `WebViewSessions` | `webview_sessions/webview_sessions.dart` | `SessionStore` (DDA datasource) | 005 |

### Carve-Out: Raw Capture Event Plumbing (stays in Core)

The raw capture-event **source** (the JavaScript injection, event channel wiring,
and capture settings types) stays in the plugin core. Only the capture
**management/distillation policy** moves to the module.

- `network_capture_interceptor_js.dart` — raw JS injection for intercept -> **Core**
- Capture event types from `platform_interface` — **Core** (re-exported as public API)

The `NetworkCaptureManager` class itself moves to the module as the
`CaptureSource` port implementation (adapter), because it contains the
policy logic for filtering, budget enforcement, and event routing.

## Validation Rules

1. Every class in `zikzak_inappwebview/lib/src/` appears exactly once above.
2. No module-tier class imports `zikzak_inappwebview_platform_interface` directly;
   module code reaches platform internals only through the plugin core's
   public facades (controller, headless, cookie manager, capture event types).
3. The grep gate (scripts/grep_gate.sh) enforces rule 2 automatically.

## Re-homed Issues

| Original Issue | Spec | Module Landing Zone | Notes |
|----------------|------|---------------------|-------|
| #237 (pool) | 007 | `WebViewPool` service + `SessionStore` DDA datasource | |
| #238 (VCR) | 008 | `CassetteEngine` service + `CassetteStore` DDA datasource | |
| #239 (tools) | 009, 006 | Generated `webview.*` tools + thin registrar | Superseded by generated tools (#244) |
| #240 (intercept) | 004 | `CaptureSource` port + distiller slot | |
| #241 (umbrella) | 003 | Split map + scaffold (this document) | |
| #242 (extract) | 004 | All ports & services | |
| #243 (wiring) | 005 | DDA stores + ZuraffaUseCases | |
| #244 (agent tools) | 006 | Generated tools + cassette parity gate | Supersedes #239 |
