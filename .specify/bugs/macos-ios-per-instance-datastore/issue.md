# Bug Issue: [macOS/iOS] Per-instance persistent, isolated WKWebsiteDataStore (named profiles via WKWebsiteDataStore(forIdentifier:))

- **Slug**: macos-ios-per-instance-datastore
- **Fetched**: 2026-08-24
- **Issue**: 253
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/253
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: none

## Body

## Summary

Add a per-`InAppWebView` setting that binds each webview instance to its own **persistent, isolated** website data store (cookies, `localStorage`, IndexedDB, cache), keyed by a stable identifier and surviving app restarts.

Today the Apple implementations offer only two options, both insufficient for apps that run **multiple concurrent sessions in the same process**:

- `WKWebsiteDataStore.default()` — a single **shared** persistent store used by *every* webview instance, so all instances share one cookie jar / one login.
- `WKWebsiteDataStore.nonPersistent()` (via `incognito`) — isolated, but **wiped when the webview is torn down** (no persistence across restarts).

There is currently no way to have N webviews that are simultaneously (a) isolated from each other and (b) persisted to disk — i.e. "container tabs" / "browser profiles".

## Use case

A single desktop app that hosts several visible webviews at once, each needing its **own logged-in session** for the same site (multi-account dashboard / profile-per-tab). Sessions must persist so users don't re-authenticate every launch, and switching which profiles are currently open must not require re-login for the others.

## Current behavior (macOS)

In `zikzak_inappwebview_macos/.../InAppWebView.swift`, `setSettings(...)` only ever swaps between the two shared options. `MyCookieManager` and `WebStorageManager` likewise operate only on `WKWebsiteDataStore.default()`.

## Requested feature

A new optional setting on `InAppWebViewSettings` — proposed name `webViewProfileId` (or `dataStoreIdentifier`) — that, when set, backs the instance with a **named, persistent, isolated** store:

- **API**: `WKWebsiteDataStore(forIdentifier: UUID)` — available **iOS 17.0+ / macOS 14.0+**.
- A stable string maps deterministically to a UUID (e.g. UUIDv5 from the string, or accept a UUID string directly).
- Distinct identifiers ⇒ fully isolated cookies/`localStorage`/cache; the OS persists each store separately.
- Mutually exclusive with `incognito` (incognito always wins / non-persistent).
- Must be applied at **configuration/creation time**, before the `WKWebView` is initialized. Likely threads the value through `init(...)` rather than only `setSettings(...)`.
- Availability-gated: when set on OS versions below the minimum, either fall back to `.default()` or surface a clear error.

### Nice-to-have (follow-ups)

- Cookie/`WebStorage` manager operations scoped to a given profile id.
- An API to enumerate and delete a persistent store by identifier.

## Acceptance criteria

- Two `InAppWebView`s with different `webViewProfileId` values, loaded to the same origin in the same app run, maintain **independent** cookies/sessions.
- After a full app restart, a webview reopened with the same `webViewProfileId` **retains** its prior session.
- No behavioral change when `webViewProfileId` is null.
- Documented availability floor (iOS 17 / macOS 14) and the below-minimum fallback behavior.

## Comments

None.
