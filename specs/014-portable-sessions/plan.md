# Implementation Plan: Portable Sessions for zikzak_inappwebview

**Branch**: `feat/014-portable-sessions` | **Spec**: `specs/014-portable-sessions/spec.md`

## Summary

A `WebViewSessions` controller in the main plugin package that saves/restores headless-webview session state (cookies + localStorage) through zikzak_session's `SessionPort`. Cookie harvesting via `CookieManager.getCookies(url)`; localStorage harvesting via `evaluateJavascript` on the webview's controller; restore via `CookieManager.setCookie` + `evaluateJavascript` `localStorage.setItem`. The `SessionPort` is injected (tests use the real `FileSessionStore` against a temp dir — it's pure Dart). The package depends on `zikzak_session` via path dep while it's unpublished.

## Key Design

- **Controller location**: `zikzak_inappwebview/lib/src/webview_sessions/webview_sessions.dart` — the federated main package (pure Dart over the platform interface), no per-platform code needed: cookies/storage go through existing platform channels.
- **API**:
  - `WebViewSessions({SessionPort port})`
  - `Future<void> save(InAppWebViewController controller, {required String sessionId, required String name, required WebUri url})`
  - `Future<bool> load(InAppWebViewController controller, {required String sessionId, required WebUri url})`
  - `Future<List<PortableSession>> list()` / `Future<bool> delete(String sessionId)`
- **Cookie mapping**: plugin `Cookie` (name, value dynamic, domain, path, expiresDate ms, isSecure?, isHttpOnly?) → zikzak_session `CookieEntry` (name, value String, domain, path, expiresAt int?, secure, httpOnly). Value coerced via `toString()` when non-String.
- **localStorage harvesting**: `evaluateJavascript('JSON.stringify(window.localStorage)')` → map → `StorageEntry(key, value, area: localStorage, origin: url.origin)`. Restore: one `evaluateJavascript` per key (`localStorage.setItem(k, v)`) — small maps, cheap, avoids escaping pitfalls of a single concatenated script.
- **Session metadata**: `origin = url.origin`; `createdAt/updatedAt = now`; id = sessionId; name = human label.
- **Load semantics**: returns `false` when absent; applies cookies then storage; never throws on empty/missing (matches zikzak_session FR-009).
- **pubspec**: `zikzak_session: {path: ../../zikzak_session}` — sibling checkout on the box; comment documents flipping to hosted when published.

## Tests

In `zikzak_inappwebview/test/webview_sessions_test.dart` — pure Dart against the real `FileSessionStore` (temp dir) with **fake webview controllers**: a tiny `FakeWebViewController` standing in for `InAppWebViewController` exposing the JS-eval surface (`window.localStorage` map + injected cookie state) is impossible — the plugin's controller is a hard type. Therefore the controller-dependent surface is tested through the **same code path** the real controller uses by extracting the JS/storage logic into testable pieces:
  - `harvestLocalStorage(evaluate: Future<Object?> Function(String))` and `applyLocalStorage(...)` take an evaluator closure (what `evaluateJavascript` already is).
  - Cookie mapping is a pure function pair `toCookieEntry(Cookie)` / `fromCookieEntry(CookieEntry, WebUri)` — unit tested directly.
  - The controller methods are thin compositions of these pieces + `CookieManager` (platform-level, already covered by the plugin's own suites).

This keeps the hand-written surface minimal and the test suite honest (no mock of a final class).

## Files

```text
zikzak_inappwebview/pubspec.yaml                          # + zikzak_session path dep
zikzak_inappwebview/lib/src/webview_sessions/webview_sessions.dart
zikzak_inappwebview/lib/zikzak_inappwebview.dart           # export
zikzak_inappwebview/test/webview_sessions_test.dart
specs/014-portable-sessions/{spec,plan,tasks}.md
PROGRESS.md                                               # status entry
```
