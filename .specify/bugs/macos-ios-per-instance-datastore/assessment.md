# Bug Assessment: [macOS/iOS] Per-instance persistent, isolated WKWebsiteDataStore

- **Slug**: macos-ios-per-instance-datastore
- **Created**: 2026-08-24
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/253
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

Feature/enhancement request: add a per-instance persistent, isolated
`WKWebsiteDataStore` on Apple platforms via `WKWebsiteDataStore(forIdentifier:)`,
keyed by a stable `webViewProfileId`/`dataStoreIdentifier`, so multiple webviews
can hold independent, restart-persistent sessions. Today only `.default()`
(shared) and `.nonPersistent()` (incognito, wiped) exist.

## Symptom

No API to bind a webview to a named persistent isolated data store; concurrent
multi-account sessions are impossible on Apple platforms.

## Reproduction

N/A (enhancement). Acceptance criteria supplied in the issue.

## Suspected Code Paths

- `zikzak_inappwebview_macos/.../InAppWebView.swift` (`init`, `setSettings`)
- `zikzak_inappwebview_ios/.../InAppWebView.swift` (mirror)
- `MyCookieManager` / `WebStorageManager` (currently `.default()` only)
- `InAppWebViewSettings_` in platform_interface

## Root Cause Hypothesis

Missing feature: no `webViewProfileId` setting or `forIdentifier:` wiring.

## Proposed Remediation

Add nullable `webViewProfileId` to `InAppWebViewSettings_` (iOS/macOS), thread it
through `init(...)`, set `configuration.websiteDataStore = WKWebsiteDataStore(
forIdentifier:)` when supported, gate on iOS 17/macOS 14, and document fallback.

## Risks & Considerations

- Enhancement (not a regression). Large-ish native change on two platforms.
- Requires Apple-native build toolchain to verify (unavailable in this env).

## Open Questions

- Accept UUID string directly or derive UUIDv5 from an arbitrary string?
