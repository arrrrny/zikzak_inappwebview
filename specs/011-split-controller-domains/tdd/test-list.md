---
feature: 011-split-controller-domains
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 6
planned_at: abfa842e
updated_at: abfa842e
suite_baseline: red
---

# Test List: Split InAppWebViewController into Domain-Specific Controllers

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works end to end through its real entry point.

| id  | behavior                                                    | traces | kind    | state   | test                                        |
| --- | ----------------------------------------------------------- | ------ | ------- | ------- | ------------------------------------------- |
| A1  | Existing consumer code calling monolithic `InAppWebViewController` methods compiles and behaves identically after the split (full backward compatibility) | US-1, FR-002, SC-001, SC-002 | example | PENDING | |
| A2  | Navigation operations work through `controller.navigation.*` facade with identical behavior to monolithic methods | US-2, FR-005, SC-003 | example | PENDING | |
| A3  | JavaScript evaluation, handlers, and injection work through `controller.javaScript.*` facade with identical behavior | US-3, FR-006, SC-003 | example | PENDING | |
| A4  | Cookie operations work through `controller.cookies.*` facade with default-to-current-URL semantics and graceful degradation | US-4, FR-007, SC-003, SC-005 | example | PENDING | |
| A5  | Settings read/write works through `controller.settings.*` facade with identical behavior | US-5, FR-008, SC-003 | example | PENDING | |
| A6  | Android and iOS platform implementations expose non-null delegate instances for all four domains and migrated methods produce identical results | US-6, FR-003, FR-004, SC-004 | example | PENDING | |

## Inner loop: unit behaviors

Grouped by the component from `plan.md` that owns them. Each line names one observable result.

### `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview_controller.dart` — Monolithic Controller Delegation

| id  | behavior                                                  | traces     | kind     | state   | test                                   |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U1  | `navigation` getter returns a lazily-created `NavigationController` instance (singleton per controller) | FR-011, SC-006 | example  | DONE | zikzak_inappwebview/test/domain_controllers_test.dart |
| U2  | `javaScript` getter returns a lazily-created `JavaScriptController` instance (singleton per controller) | FR-011, SC-006 | example  | DONE | zikzak_inappwebview/test/domain_controllers_test.dart |
| U3  | `cookies` getter returns a lazily-created `CookieController` instance (singleton per controller) | FR-011, SC-006 | example  | DONE | zikzak_inappwebview/test/domain_controllers_test.dart |
| U4  | `settings` getter returns a lazily-created `SettingsController` instance (singleton per controller) | FR-011, SC-006 | example  | DONE | zikzak_inappwebview/test/domain_controllers_test.dart |
| U5  | All navigation methods on `InAppWebViewController` delegate to `navigation` facade and produce identical results | FR-002, FR-005 | example  | PENDING | |
| U6  | All JavaScript methods on `InAppWebViewController` delegate to `javaScript` facade and produce identical results | FR-002, FR-006 | example  | PENDING | |
| U7  | All cookie methods on `InAppWebViewController` delegate to `cookies` facade and produce identical results | FR-002, FR-007 | example  | PENDING | |
| U8  | All settings methods on `InAppWebViewController` delegate to `settings` facade and produce identical results | FR-002, FR-008 | example  | PENDING | |
| U9  | Public method surface of `InAppWebViewController` is unchanged (no methods removed, signatures identical) | FR-002, SC-002 | example  | PENDING | |

### `zikzak_inappwebview/lib/src/in_app_webview/controllers/navigation_controller.dart` — NavigationController

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U10 | `loadUrl` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U11 | `postUrl` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U12 | `loadData` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U13 | `loadFile` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U14 | `loadSimulatedRequest` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U15 | `reload` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U16 | `reloadFromOrigin` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U17 | `stopLoading` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U18 | `isLoading` delegates to parent controller and returns same value | FR-005 | example          | PENDING | |
| U19 | `goBack` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U20 | `goForward` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U21 | `goBackOrForward` delegates to parent controller with correct steps sign | FR-005 | example          | PENDING | |
| U22 | `canGoBack` delegates to parent controller and returns same boolean | FR-005 | example          | PENDING | |
| U23 | `canGoForward` delegates to parent controller and returns same boolean | FR-005 | example          | PENDING | |
| U24 | `canGoBackOrForward` delegates to parent controller with correct steps sign and returns same boolean | FR-005 | example          | PENDING | |
| U25 | `goTo` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U26 | `getCopyBackForwardList` delegates to parent controller and returns same history | FR-005 | example          | PENDING | |
| U27 | `clearHistory` delegates to parent controller and produces same navigation behavior | FR-005 | example          | PENDING | |
| U28 | `getUrl` delegates to parent controller and returns same URL | FR-005 | example          | PENDING | |

### `zikzak_inappwebview/lib/src/in_app_webview/controllers/javascript_controller.dart` — JavaScriptController

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U29 | `evaluateJavascript` delegates to parent controller and returns same result | FR-006 | example          | PENDING | |
| U30 | `callAsyncJavaScript` delegates to parent controller and returns same result | FR-006 | example          | PENDING | |
| U31 | `injectJavascriptFileFromUrl` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U32 | `injectJavascriptFileFromAsset` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U33 | `addJavaScriptHandler` delegates to parent controller and registers handler identically | FR-006 | example          | PENDING | |
| U34 | `removeJavaScriptHandler` delegates to parent controller and removes handler identically | FR-006 | example          | PENDING | |
| U35 | `hasJavaScriptHandler` delegates to parent controller and returns same boolean | FR-006 | example          | PENDING | |
| U36 | `addUserScript` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U37 | `addUserScripts` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U38 | `removeUserScript` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U39 | `removeUserScripts` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U40 | `removeUserScriptsByGroupName` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U41 | `removeAllUserScripts` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U42 | `hasUserScript` delegates to parent controller and returns same boolean | FR-006 | example          | PENDING | |
| U43 | `injectCSSCode` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U44 | `injectCSSFileFromUrl` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |
| U45 | `injectCSSFileFromAsset` delegates to parent controller and produces same behavior | FR-006 | example          | PENDING | |

### `zikzak_inappwebview/lib/src/in_app_webview/controllers/cookie_controller.dart` — CookieController

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U46 | `getCookies` without URL defaults to current WebView URL via `getUrl()` | FR-007 | example          | PENDING | |
| U47 | `getCookies` with explicit URL uses that URL instead of current | FR-007 | example          | PENDING | |
| U48 | `getCookies` with no current URL and no explicit URL returns empty list (graceful degradation) | FR-007, SC-005 | example          | PENDING | |
| U49 | `getCookie` without URL defaults to current WebView URL via `getUrl()` | FR-007 | example          | PENDING | |
| U50 | `getCookie` with explicit URL uses that URL instead of current | FR-007 | example          | PENDING | |
| U51 | `getCookie` with no current URL and no explicit URL returns null (graceful degradation) | FR-007, SC-005 | example          | PENDING | |
| U52 | `setCookie` without URL defaults to current WebView URL via `getUrl()` | FR-007 | example          | PENDING | |
| U53 | `setCookie` with explicit URL uses that URL instead of current | FR-007 | example          | PENDING | |
| U54 | `setCookie` with no current URL and no explicit URL returns false (graceful degradation) | FR-007, SC-005 | example          | PENDING | |
| U55 | `deleteCookie` without URL defaults to current WebView URL via `getUrl()` | FR-007 | example          | PENDING | |
| U56 | `deleteCookie` with explicit URL uses that URL instead of current | FR-007 | example          | PENDING | |
| U57 | `deleteCookie` with no current URL and no explicit URL returns false (graceful degradation) | FR-007, SC-005 | example          | PENDING | |
| U58 | `deleteCookies` without URL defaults to current WebView URL via `getUrl()` | FR-007 | example          | PENDING | |
| U59 | `deleteCookies` with explicit URL uses that URL instead of current | FR-007 | example          | PENDING | |
| U60 | `deleteCookies` with no current URL and no explicit URL returns false (graceful degradation) | FR-007, SC-005 | example          | PENDING | |
| U61 | `getAllCookies` returns all cookies from shared CookieManager (global, not scoped) | FR-007 | example          | PENDING | |
| U62 | `deleteAllCookies` deletes all cookies from shared CookieManager (global) | FR-007 | example          | PENDING | |
| U63 | `removeSessionCookies` removes session cookies from shared CookieManager (global) | FR-007 | example          | PENDING | |
| U64 | CookieController uses injected CookieManager override when provided | FR-007 | example          | PENDING | |
| U65 | CookieController lazily initializes CookieManager singleton | FR-011 | example          | PENDING | |

### `zikzak_inappwebview/lib/src/in_app_webview/controllers/settings_controller.dart` — SettingsController

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U66 | `getSettings` delegates to parent controller and returns same settings | FR-008 | example          | PENDING | |
| U67 | `setSettings` delegates to parent controller and applies settings identically | FR-008 | example          | PENDING | |

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_inappwebview_controller.dart` — Platform Interface Delegates

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U68 | `navigationDelegate` getter returns `null` by default on base class | FR-003 | example          | DONE | zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart |
| U69 | `javaScriptDelegate` getter returns `null` by default on base class | FR-003 | example          | DONE | zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart |
| U70 | `cookieDelegate` getter returns `null` by default on base class | FR-003 | example          | DONE | zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart |
| U71 | `settingsDelegate` getter returns `null` by default on base class | FR-003 | example          | DONE | zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart |
| U72 | All four delegate types (`PlatformNavigationDelegate`, `PlatformJavaScriptDelegate`, `PlatformCookieDelegate`, `PlatformSettingsDelegate`) are exported from platform interface | FR-003, SC-003 | example          | DONE | zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart |

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/modules/platform_navigation_delegate.dart` — PlatformNavigationDelegate

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U73 | Declares all navigation methods matching `PlatformInAppWebViewController` surface | FR-004 | example          | DONE | lib/src/in_app_webview/modules/platform_navigation_delegate.dart |

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/modules/platform_javascript_delegate.dart` — PlatformJavaScriptDelegate

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U74 | Declares all JavaScript methods matching `PlatformInAppWebViewController` surface | FR-004 | example          | DONE | lib/src/in_app_webview/modules/platform_javascript_delegate.dart |

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/modules/platform_cookie_delegate.dart` — PlatformCookieDelegate

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U75 | Declares all cookie methods matching `PlatformInAppWebViewController` / `PlatformCookieManager` surface | FR-004 | example          | DONE | lib/src/in_app_webview/modules/platform_cookie_delegate.dart |

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/modules/platform_settings_delegate.dart` — PlatformSettingsDelegate

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U76 | Declares `setSettings` and `getSettings` matching `PlatformInAppWebViewController` surface | FR-004 | example          | DONE | lib/src/in_app_webview/modules/platform_settings_delegate.dart |

### Platform Implementation Migration (Android/iOS) — `zikzak_inappwebview_android` and `zikzak_inappwebview_ios`

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U77 | Android `PlatformInAppWebViewController` overrides `navigationDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_android/test/in_app_webview/modules/android_delegates_test.dart |
| U78 | Android `PlatformInAppWebViewController` overrides `javaScriptDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_android/test/in_app_webview/modules/android_delegates_test.dart |
| U79 | Android `PlatformInAppWebViewController` overrides `cookieDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_android/test/in_app_webview/modules/android_delegates_test.dart |
| U80 | Android `PlatformInAppWebViewController` overrides `settingsDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_android/test/in_app_webview/modules/android_delegates_test.dart |
| U81 | iOS `PlatformInAppWebViewController` overrides `navigationDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_ios/test/in_app_webview/modules/ios_delegates_test.dart |
| U82 | iOS `PlatformInAppWebViewController` overrides `javaScriptDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_ios/test/in_app_webview/modules/ios_delegates_test.dart |
| U83 | iOS `PlatformInAppWebViewController` overrides `cookieDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_ios/test/in_app_webview/modules/ios_delegates_test.dart |
| U84 | iOS `PlatformInAppWebViewController` overrides `settingsDelegate` returning concrete instance | FR-004, SC-004 | example          | DONE | zikzak_inappwebview_ios/test/in_app_webview/modules/ios_delegates_test.dart |

### Generated Code / DI Wiring (zorphy)

| id  | behavior                                              | traces | kind             | state    | test                                    |
| --- | ----------------------------------------------------- | ------ | ---------------- | -------- | --------------------------------------- |
| U85 | Generated platform controller wiring resolves and registers all four delegates correctly | FR-009 | example          | NOT_APPLICABLE | NOT_APPLICABLE — delegates wired manually via override getters (this turn); zorphy is entity codegen only, no controller DI |
| U86 | No orphaned or duplicated wiring for delegate instances in generated code | FR-009 | example          | NOT_APPLICABLE | NOT_APPLICABLE — no generated wiring exists for delegates (zorphy = entity serialization only); manual override getters are the single source of wiring |

## Invariants and edge cases still to place

Behaviors that belong to the feature but do not yet have a home component. Each must become a numbered line above before the feature is done, or be dropped with a reason.

- Disposed controller: Domain controller method calls on a disposed controller must not crash and must behave consistently with monolithic API (Edge case from spec)
- HeadlessInAppWebView: Domain controller facades must behave identically for headless contexts (Edge case from spec)
- Cross-domain state consistency: Shared state (e.g., settings affecting navigation) must not introduce inconsistencies versus monolithic behavior (Edge case from spec)
- Concurrent access: Multiple domain controllers accessed concurrently on same parent must not cause state desynchronization (FR-011)

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- Screenshot/PDF export methods: Remain on monolithic controller per spec assumption (methods outside the four named domains)
- Media playback control methods: Remain on monolithic controller per spec assumption
- DevTools protocol methods: Remain on monolithic controller per spec assumption
- Web Message Channel methods: Remain on monolithic controller per spec assumption
- User Script methods beyond those in JavaScriptController: Remain on monolithic controller
- SSL/Certificate methods: Remain on monolithic controller
- Find interaction methods: Remain on monolithic controller
- Pull to refresh methods: Remain on monolithic controller
- Print job methods: Remain on monolithic controller
- Network capture methods: Remain on monolithic controller
- Service worker methods: Remain on monolithic controller
- Proxy controller methods: Remain on monolithic controller
- Windows/Linux/macOS platform delegate migration: Not required by spec (only Android/iOS explicitly named in US-6 and SC-004)
- Performance benchmarks: No performance requirement in spec, only behavioral equivalence

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, so this file is readable on its own:

- Single test: `flutter test {file} --plain-name "{name}"`
- File suite: `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

Note: `flutter test` must run INSIDE the package that owns the test file. The default umbrella package is `zikzak_inappwebview`.