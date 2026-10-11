# Feature Specification: Portable Sessions for zikzak_inappwebview (via zikzak_session)

**Feature Branch**: `014-portable-sessions`
**Created**: 2026-08-23
**Status**: Draft
**Input**: User description: "complete making zikzak_inappwebview a pure zuraffa package (entity migration is done); the whole portable session must use zikzak_session since the rewritten zikzak_inappwebview is a zuraffa plugin; issue #253 (per-instance persistent isolated data stores on Linux/Android) is nice-to-have, not a priority."

## Summary

zikzak_inappwebview's model layer is fully migrated to Zorphy entities (PROGRESS.md: ALL `@ExchangeableObject`/`@ExchangeableEnum` models migrated). The missing piece is the **portable sessions layer**: a `WebViewSessions` controller in the federated plugin package that saves/restores a headless webview's session state through **`zikzak_session`'s `SessionPort`** — never its own storage format — so a webview authenticates once, its session persists across app restarts, and a named session loads onto a specific site programmatically (the forklift cloaked-browser use case, spec 001 of zikzak_session).

`zikzak_inappwebview` becomes a **consumer of the zuraffa ecosystem**: it depends on `zikzak_session` (which itself carries the session contract) and wires it behind a thin, well-documented controller. No parallel session logic is introduced anywhere.

## User Scenarios & Testing

### User Story 1 - Save and restore a headless webview session across restarts (P1)

As a developer driving headless webviews (agent tool layer, scraper), I authenticate a webview on a site, save its session under a name, kill the app, and on relaunch load that session into a fresh webview at the same site — still logged in.

**Acceptance Scenarios**:
1. **Given** a webview with cookies and localStorage set, **When** `save(sessionId)` is called, **Then** a `PortableSession` with those cookies/storage entries is persisted through the `SessionPort`.
2. **Given** a saved session and a fresh webview at the same origin, **When** `load(sessionId)` is called, **Then** cookies are re-set through `CookieManager` and storage entries re-applied through the webview's `localStorage`.
3. **Given** no saved session, **When** `load` is called, **Then** it returns not-found without error.

### User Story 2 - Named sessions onto specific sites, no cross-contamination (P1)

Forklift spawns N cloaked browsers; each gets its own named session loaded onto its own site.

**Acceptance**: two sessions saved with different cookies; loading A then B yields each webview carrying only its assigned session's cookies.

### User Story 3 - Pure-Flutter-package integration (P1)

`zikzak_inappwebview` is a federated Flutter plugin; the sessions layer lives in the main Dart package, works on every platform the plugin supports (cookies/storage APIs are platform-channel based), and depends only on `zikzak_session` + existing plugin APIs.

## Requirements

- **FR-001**: `WebViewSessions` controller MUST exist in the main plugin package with `save`, `load`, `list`, `delete` methods.
- **FR-002**: Session persistence MUST delegate entirely to zikzak_session's `SessionPort` (no separate storage format, no direct file I/O in this package).
- **FR-003**: `save` MUST harvest cookies via `CookieManager.getCookies` and localStorage via JS evaluation on the webview's controller.
- **FR-004**: `load` MUST re-apply cookies via `CookieManager.setCookie` and storage via the webview's `localStorage.setItem`.
- **FR-005**: Cookie mapping MUST translate between the plugin's `Cookie` entity and zikzak_session's `CookieEntry` (name, value, domain, path, expiry, secure/httpOnly where representable).
- **FR-006**: Storage entries MUST carry key, value, and origin (area = localStorage).
- **FR-007**: The `SessionPort` instance MUST be injectable (constructor parameter) so tests use an in-memory/fake store and apps configure the real one.
- **FR-008**: The integration MUST ship in the pubspec as a dependency on `zikzak_session` (path dep while unpublished).

## Out of scope (v1)

- Issue #253 (per-instance persistent isolated WKWebsiteDataStore/Android profiles) — tracked separately; the portable-session layer works on top of whatever store the webview uses.
- sessionStorage capture (localStorage only — it survives navigation, which is what session restore needs).
- IndexedDB/Cache API persistence.
