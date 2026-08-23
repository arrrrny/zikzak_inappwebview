# Feature Specification: Split InAppWebViewController into Domain-Specific Controllers

**Feature Branch**: `011-split-controller-domains`

**Created**: 2026-08-22

**Status**: Draft

**Input**: GitHub issue #229 (sub-issue of #161, "Epic: Architecture & tech debt reduction", labeled enhancement / epic / tech-debt, P3). The growing `InAppWebViewController` platform interface is ~530 lines and the Android/iOS implementations are ~2600 lines each, making the single class hard to reason about and blocking parallel work. The requested breakdown groups the controller's methods into four focused domains: `NavigationController` (`loadUrl`, `reload`, `goBack`, `goForward`, `canGoBack`, `canGoForward`, plus related history methods), `JavaScriptController` (`evaluateJavascript`, `addJavaScriptHandler`, `callJavaScriptHandler` / handler invocation, plus script injection), `CookieController` (cookie management scoped to the WebView), and `SettingsController` (`getSettings`, `setSettings`). The monolithic `InAppWebViewController` must keep full backward compatibility by delegating to the new controllers, platform implementations (Android/iOS) must be moved to match, any generated code / DI wiring (e.g. the zorphy migration) must be updated, and existing behavior must be preserved by tests.

## User Scenarios & Testing

### User Story 1 - Backward-compatible monolithic API (Priority: P1)

A developer maintains an existing app that calls web view operations directly on the monolithic `InAppWebViewController` (e.g. `controller.loadUrl(...)`, `controller.evaluateJavascript(...)`, `controller.getSettings()`, `controller.setCookie(...)`). After the controller is split into domain-specific facades, all of that existing code must keep compiling and behaving identically, with no source changes required.

**Why this priority**: This is the non-negotiable guardrail of the whole refactoring. Any break in the public API would be a breaking change for every consumer of the package, so backward compatibility must be proven before the split can be considered done.

**Independent Test**: Take a snapshot of the public method surface of `InAppWebViewController` before and after the change (e.g. via an analyzer/expectation test or by running the existing consumer test suite), and assert the set of callable methods and their signatures is unchanged.

**Acceptance Scenarios**:

1. **Given** a controller configured with an implementation, **When** `controller.loadUrl(...)` is called directly, **Then** the navigation still loads the requested URL with the same observable behavior as before the split.
2. **Given** a controller configured with an implementation, **When** `controller.evaluateJavascript(...)` / `controller.addJavaScriptHandler(...)` are called directly, **Then** JavaScript evaluation and handler invocation behave identically to the pre-split implementation.
3. **Given** the refactored controller, **When** any previously-supported method is invoked, **Then** the call internally routes through the corresponding domain controller and produces the same result, with no new exceptions or behavioral divergence.

---

### User Story 2 - Navigate through the Navigation domain controller (Priority: P1)

A developer wants to group all page-loading and history operations behind a single `navigation` facade, e.g. `controller.navigation.loadUrl(...)`, `.reload()`, `.goBack()`, `.goForward()`, `.canGoBack()`, `.canGoForward()`, `.goBackOrForward(...)`, `.clearHistory()`, etc.

**Why this priority**: Navigation is one of the two domains explicitly named first in the issue and is used by virtually every consumer; exposing it as a coherent, independently usable facade validates the core of the split pattern.

**Independent Test**: Load a test page, then drive it entirely through `controller.navigation.*` and assert that history state (back/forward availability, current URL) matches the same sequence driven through the monolithic methods.

**Acceptance Scenarios**:

1. **Given** a loaded web page, **When** `controller.navigation.goBack()` is called, **Then** the view navigates back and `controller.navigation.canGoForward()` returns `true`.
2. **Given** a fresh controller, **When** `controller.navigation.canGoBack()` is called before any navigation, **Then** it returns `false` (same as the monolithic method).
3. **Given** a multi-step history, **When** `controller.navigation.goBackOrForward(steps: N)` is called, **Then** the resulting history position matches the equivalent monolithic call.

---

### User Story 3 - Script and handlers through the JavaScript domain controller (Priority: P2)

A developer wants to keep all JavaScript evaluation, script injection, and JS-handler registration behind the `javaScript` facade: `controller.javaScript.evaluateJavascript(...)`, `controller.javaScript.addJavaScriptHandler(...)` / `removeJavaScriptHandler(...)`, plus injection helpers.

**Why this priority**: JavaScript is the second named domain and is heavily used, but it is less universally critical than navigation/loading, so it ranks just below P1.

**Independent Test**: Register a JS handler via `controller.javaScript.addJavaScriptHandler(...)`, trigger it from evaluated JavaScript, and assert the Dart callback fires with the expected payload; also assert `evaluateJavascript` return values match direct calls.

**Acceptance Scenarios**:

1. **Given** a registered handler via `controller.javaScript.addJavaScriptHandler(...)`, **When** the page invokes that handler, **Then** the Dart callback receives the payload (identical to the monolithic API).
2. **Given** an expression, **When** `controller.javaScript.evaluateJavascript(source: ...)` is called, **Then** the resolved value equals the result obtained from the monolithic `evaluateJavascript`.
3. **Given** a previously added handler name, **When** `controller.javaScript.removeJavaScriptHandler(handlerName: ...)` is called, **Then** subsequent invocations no longer reach Dart (same as before the split).

---

### User Story 4 - Cookie management through the Cookie domain controller (Priority: P2)

A developer wants cookie operations scoped to the current WebView exposed through `controller.cookies`: `getCookies`, `getCookie`, `setCookie`, `deleteCookie`, `deleteCookies`, `getAllCookies`, `deleteAllCookies`, `removeSessionCookies`. When no explicit URL is supplied, operations default to the WebView's current URL; an explicit URL may still be passed.

**Why this priority**: Cookie management is a distinct, frequently used concern, but it complements rather than blocks core navigation, so it is P2.

**Independent Test**: After loading a page, call `controller.cookies.setCookie(name: "x", value: "1")` without a URL, then `controller.cookies.getCookies()` and assert the cookie is stored against the current URL; repeat with an explicit URL and assert isolation.

**Acceptance Scenarios**:

1. **Given** a loaded page at URL U, **When** `controller.cookies.setCookie(name: "k", value: "v")` is called without a URL, **Then** the cookie is stored scoped to U and returned by `getCookies()`.
2. **Given** no page loaded (no current URL) and no explicit URL, **When** `controller.cookies.getCookies()` / `setCookie(...)` are called, **Then** they degrade safely (empty list / `false`) instead of throwing.
3. **Given** an explicit URL argument, **When** a cookie operation is performed, **Then** it targets that URL rather than the current one (preserving prior explicit-URL behavior).

---

### User Story 5 - Settings through the Settings domain controller (Priority: P3)

A developer wants to read and update web view settings via `controller.settings.getSettings()` and `controller.settings.setSettings(...)`.

**Why this priority**: Settings is the smallest, most stable domain and is rarely performance- or correctness-critical, so it is the lowest-named domain (P3), but it must still be covered for completeness.

**Independent Test**: Read settings via `controller.settings.getSettings()`, mutate one field, call `controller.settings.setSettings(...)`, then read again and assert the change persisted and matches the monolithic equivalent.

**Acceptance Scenarios**:

1. **Given** a configured controller, **When** `controller.settings.getSettings()` is called, **Then** the returned settings match `controller.getSettings()`.
2. **Given** new settings, **When** `controller.settings.setSettings(settings: ...)` is called, **Then** the applied configuration equals the monolithic `setSettings(...)` result.

---

### User Story 6 - Platform implementations migrated to delegate pattern (Priority: P3)

A maintainer working on the Android or iOS platform package wants the per-domain method implementations relocated behind the corresponding delegate (e.g. `PlatformNavigationDelegate`, `PlatformJavaScriptDelegate`, `PlatformCookieDelegate`, `PlatformSettingsDelegate`) so the large monolithic platform classes shrink and become parallelizable. The platform interface exposes a nullable delegate getter per domain (defaulting to `null` for not-yet-migrated implementations) that platform packages override.

**Why this priority**: This is the mechanical payoff of the refactor (smaller platform classes, parallel work) but is internal and does not affect the consumer API, so it is the last priority.

**Independent Test**: On Android and iOS, instantiate the platform controller and assert that each domain delegate getter returns a non-null concrete delegate and that calling the migrated method through the delegate produces the same result as before.

**Acceptance Scenarios**:

1. **Given** the Android platform controller, **When** `navigationDelegate` / `javaScriptDelegate` / `cookieDelegate` / `settingsDelegate` are accessed, **Then** each returns a concrete, non-null delegate instance.
2. **Given** the iOS platform controller, **When** the same delegate getters are accessed, **Then** each returns a concrete, non-null delegate instance.
3. **Given** any platform, **When** a delegate getter is accessed on an implementation that has not yet migrated, **Then** it returns `null` without throwing, preserving backward compatibility for that platform.

---

### Edge Cases

- What happens when a domain controller getter (`navigation`, `javaScript`, `cookies`, `settings`) is accessed on a controller whose underlying platform has not migrated and whose delegate getter returns `null`? The consumer facade should still function by delegating to the parent monolithic method (the `null` default is an interim migration state, not a runtime failure for consumer code).
- What happens when a cookie operation is invoked with no current URL and no explicit URL? It must degrade gracefully (empty list / `false`) rather than throw.
- What happens when the controller (or its web view) has been disposed but a domain controller method call is still in flight? It must not crash and should behave consistently with the monolithic API.
- What happens when domain controllers are accessed on a `HeadlessInAppWebView`? Behavior must match the equivalent monolithic calls for headless contexts.
- What happens when the same domain controller getter is accessed repeatedly? The facade must return the same lazily-created instance (no duplicate state, no repeated allocation surprises).
- What happens when generated code / DI (zorphy) wiring is out of sync with the new delegates? Construction and registration of the platform controller must still resolve the correct delegate instances; this must be verified during the migration.
- What happens when two domains share underlying state (e.g. settings affecting navigation)? The split must not introduce cross-controller inconsistencies versus the monolithic behavior.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST define four distinct, domain-grouped controller facades — `NavigationController`, `JavaScriptController`, `CookieController`, and `SettingsController` — each grouping the corresponding subset of `InAppWebViewController` methods, without changing method signatures or observable behavior.
- **FR-002**: The monolithic `InAppWebViewController` MUST remain publicly available and MUST delegate each grouped method to its corresponding domain controller, so existing consumer code compiles and behaves identically (full backward compatibility).
- **FR-003**: The platform interface (`PlatformInAppWebViewController`) MUST expose a nullable delegate getter for each domain (`navigationDelegate`, `javaScriptDelegate`, `cookieDelegate`, `settingsDelegate`) that defaults to `null` to preserve compatibility for implementations not yet migrated.
- **FR-004**: Each platform implementation (Android, iOS) MUST override the relevant delegate getter to return a concrete delegate instance and MUST relocate the corresponding method implementations into that delegate, shrinking the monolithic platform class.
- **FR-005**: The `NavigationController` MUST expose navigation and history methods (including `loadUrl`, `reload`, `goBack`, `goForward`, `canGoBack`, `canGoForward`, `goBackOrForward`, `canGoBackOrForward`, `goTo`, `clearHistory`, and related page-loading/loading-status methods).
- **FR-006**: The `JavaScriptController` MUST expose JavaScript evaluation, handler registration/removal (`addJavaScriptHandler`, `removeJavaScriptHandler`, handler invocation), and script/CSS injection helpers, with behavior identical to the monolithic equivalents.
- **FR-007**: The `CookieController` MUST expose cookie operations (`getCookies`, `getCookie`, `setCookie`, `deleteCookie`, `deleteCookies`, `getAllCookies`, `deleteAllCookies`, `removeSessionCookies`) that default to the WebView's current URL and accept an explicit URL override.
- **FR-008**: The `SettingsController` MUST expose `getSettings()` and `setSettings(...)` with behavior identical to the monolithic equivalents.
- **FR-009**: Any generated code or dependency-injection wiring (e.g. the zorphy migration) MUST be updated so delegate instances are constructed and registered consistently with the domain split, with no orphaned or duplicated wiring.
- **FR-010**: The existing automated test suite MUST continue to pass unchanged after the split, confirming behavior preservation across all four domains and the monolithic API.
- **FR-011**: The domain controller facades MUST be lazily instantiated per parent controller (one instance per domain) and MUST NOT duplicate or desynchronize state relative to the monolithic API.

### Key Entities

- **InAppWebViewController**: The consumer-facing monolithic controller. Remains the public entry point and delegates grouped methods to the domain facades.
- **NavigationController / JavaScriptController / CookieController / SettingsController**: Consumer-facing domain facades that wrap `InAppWebViewController` and group related methods.
- **PlatformInAppWebViewController**: The platform-interface base class; exposes the four nullable delegate getters.
- **PlatformNavigationDelegate / PlatformJavaScriptDelegate / PlatformCookieDelegate / PlatformSettingsDelegate**: Platform-interface delegate base classes that platform packages subclass to hold the migrated implementations.
- **CookieManager**: The shared, cross-WebView global cookie store that the `CookieController` wraps, defaulting operations to the WebView's current URL and passing the controller as context.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of existing `InAppWebViewController` method calls work unchanged after the split, as proven by the existing consumer test suite passing with zero modifications.
- **SC-002**: The public method surface (names and signatures) of `InAppWebViewController` is identical before and after the change (verified by a surface/expectation check).
- **SC-003**: All four domain facades (`navigation`, `javaScript`, `cookies`, `settings`) are present and each exposes its documented method subset.
- **SC-004**: On both Android and iOS, the four platform delegate getters each return a non-null concrete delegate instance for the migrated methods (no `UnimplementedError` for migrated operations).
- **SC-005**: Cookie operations without a current URL degrade gracefully (empty list / `false`) rather than throwing, matching the specified safe-fallback behavior.
- **SC-006**: Each domain controller facade is instantiated exactly once per parent controller (lazy singleton), with no duplicated state versus the monolithic API.

## Assumptions

- The four domains (Navigation, JavaScript, Cookie, Settings) cover the method groups described in the issue; methods outside these groups (e.g. screenshot/PDF, media, DevTools) remain on the monolithic controller and are out of scope for this split.
- The codebase already contains preliminary delegate/facade scaffolding (e.g. `Platform*Delegate` classes and `InAppWebViewController` getters), so this spec primarily governs completing and validating the split rather than designing it from zero.
- The zorphy / generated-code migration has touched these controllers, so generated and DI wiring must be reconciled with the delegate pattern during implementation.
- No breaking API changes are intended; the split is internal/structural and the consumer-facing API is treated as stable.
- Returning `null` from a delegate getter on a not-yet-migrated platform is an acceptable interim compatibility strategy, as long as consumer-facing facades still function via the parent monolithic methods.
- The `CookieController` builds on the existing shared `CookieManager`; per-WebView scoping (defaulting to the current URL) is the expected behavior for the domain facade.
