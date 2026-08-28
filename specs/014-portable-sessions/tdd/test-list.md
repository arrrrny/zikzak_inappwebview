---
feature: 014-portable-sessions
loop: outside-in # WebViewSessions is a public controller with a real entry point
profile: .specify/memory/tdd-profile.md
spec_criteria: 5 # US1 s1/s2/s3, US2, US3 acceptance scenarios
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked # zuraffa pub-cache corruption — run `flutter pub cache repair` (targets umbrella zikzak_inappwebview package)
---

# Test List: Portable Sessions for zikzak_inappwebview

> Spec `specs/014-portable-sessions/spec.md`, plan `specs/014-portable-sessions/plan.md`.
> The controller (`lib/src/webview_sessions/webview_sessions.dart`) and a partial
> `test/webview_sessions_test.dart` already exist. The unit seams (cookie mapping,
> localStorage harvest/apply, port `list`/`delete`) have tests; the controller-level
> `save`/`load` glue and the acceptance scenarios have **no** driving test yet.
> The umbrella package suite is BLOCKED (zuraffa cache), so existing tests are
> "DONE by presence" — not independently re-run here.

## Outer loop: acceptance behaviors

One per acceptance scenario in `spec.md`. Each must run through the real
`WebViewSessions` entry point, not the pieces beneath it.

| id  | behavior                                                                                              | traces                | kind    | state    | test |
| --- | ----------------------------------------------------------------------------------------------------- | --------------------- | ------- | -------- | ---- |
| A1  | `save(sessionId)` persists a `PortableSession` carrying the webview's cookies and localStorage through the `SessionPort` | FR-001, FR-002, FR-003, FR-006 | example | PENDING  |      |
| A2  | `load(sessionId)` re-applies the saved cookies via `CookieManager.setCookie` and the saved localStorage via the webview, restoring the logged-in state | FR-001, FR-004, FR-006 | example | PENDING  |      |
| A3  | `load(sessionId)` when no session is saved returns not-found (false) without throwing                  | FR-001, FR-002        | example | PENDING  |      |
| A4  | Two named sessions saved with distinct cookies load onto their own webviews so each carries only its own session's cookies (no cross-contamination) | FR-001, FR-002, FR-005 | example | PENDING  |      |
| A5  | `WebViewSessions` is exported from the main federated package and the package depends only on `zikzak_session` + existing plugin APIs (pubspec declares `zikzak_session`; barrel export present) | FR-001, FR-008 | example | PENDING  |      |

## Inner loop: unit behaviors

Grouped by the component from `plan.md` that owns them.

### `zikzak_inappwebview/lib/src/webview_sessions/webview_sessions.dart` — cookie mapping (`toCookieEntry` / `fromCookieEntry`)

| id  | behavior                                                                                  | traces  | kind    | state   | test |
| --- | ----------------------------------------------------------------------------------------- | ------- | ------- | ------- | ---- |
| U1  | `toCookieEntry` preserves name, value, domain, path, expiresAt, secure, httpOnly field-by-field | FR-005  | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::cookie mapping (FR-005) plugin Cookie maps onto a portable CookieEntry field by field` |
| U2  | `toCookieEntry` stringifies a non-`String` value via `toString()` and falls back to safe defaults (empty domain, `/` path, secure/httpOnly false) for null optionals | FR-005  | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::cookie mapping (FR-005) null optionals fall back to safe defaults` |
| U3  | `fromCookieEntry` reconstructs a plugin `Cookie` on a given `WebUri`, restoring name/value/domain/path/expiry/secure/httpOnly | FR-005  | example | PENDING |      |
| U4  | Round-trips a `Cookie` through `toCookieEntry` then `fromCookieEntry` preserving the representable (String-value) fields — invariant sampled at the String-value boundary | FR-005  | example | PENDING |      |

### `zikzak_inappwebview/lib/src/webview_sessions/webview_sessions.dart` — localStorage (`harvestLocalStorage` / `applyLocalStorage`)

| id  | behavior                                                                                              | traces          | kind    | state   | test |
| --- | ----------------------------------------------------------------------------------------------------- | --------------- | ------- | ------- | ---- |
| U5  | `harvestLocalStorage(evaluate)` reads `window.localStorage` through the evaluator and returns key/value pairs | FR-003, FR-006  | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004) harvest reads window.localStorage through the evaluator` |
| U6  | `harvestLocalStorage` tolerates a failing, empty, or non-map evaluation and yields an empty list (best-effort) | FR-003          | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004) a failing or empty evaluation yields an empty list` |
| U7  | `applyLocalStorage(evaluate, entries)` issues one JSON-escaped `localStorage.setItem` per entry       | FR-004, FR-006  | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004) applyLocalStorage issues one setItem per entry, JSON-escaped` |
| U8  | `applyLocalStorage` with an empty list issues zero `setItem` calls (boundary: 0 entries)              | FR-004          | example | PENDING |      |

### `zikzak_inappwebview/lib/src/webview_sessions/webview_sessions.dart` — controller (`save` / `load` / `list` / `delete`)

| id  | behavior                                                                                              | traces                          | kind    | state   | test |
| --- | ----------------------------------------------------------------------------------------------------- | ------------------------------- | ------- | ------- | ---- |
| U9  | `save` harvests cookies via `CookieManager.getCookies(url)` and localStorage via `evaluateJavascript`, then delegates to `port.save` with a `PortableSession` (id=sessionId, name) | FR-001, FR-002, FR-003, FR-006 | example | PENDING |      |
| U10 | `save` sets `origin = url.origin` and `createdAt/updatedAt = now` on the persisted session           | FR-002                          | example | PENDING |      |
| U11 | `load` when the session exists applies cookies via `setCookie` and then localStorage via `evaluateJavascript`, in that order | FR-001, FR-004, FR-006          | example | PENDING |      |
| U12 | `load` when absent returns `false` and applies nothing, never throwing                                | FR-002, FR-001                  | example | PENDING |      |
| U13 | `list` returns the sessions held by the `SessionPort`                                                 | FR-001                          | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::session round-trip through the port (FR-002/US1) a saved session round-trips with cookies and storage intact` |
| U14 | `delete(sessionId)` removes the session and returns `true` when one existed                          | FR-001                          | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::session round-trip through the port (FR-002/US1) delete frees the session (FR-001)` |
| U15 | `delete(sessionId)` returns `false` when no session exists under that id                             | FR-001                          | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::session round-trip through the port (FR-002/US1) delete frees the session (FR-001)` |
| U16 | The injected `SessionPort` backs the controller; any implementation is accepted (constructor parameter) | FR-007                          | example | DONE    | `zikzak_inappwebview/test/webview_sessions_test.dart::port injection (FR-007) any SessionPort implementation backs the controller` |

## Invariants and edge cases still to place

None identified — every behavior above has a home in the outer or inner loop.

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- Issue #253 (per-instance persistent isolated WKWebsiteDataStore / Android profiles): tracked separately; the portable layer works on top of whatever store the webview uses.
- sessionStorage capture: spec covers localStorage only (it survives navigation, which is what restore needs).
- IndexedDB / Cache API persistence: explicitly out of scope for v1.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` (package `zikzak_inappwebview`) at
planning time. Run from `zikzak_inappwebview/`.

- Single test: `flutter test --plain-name "{name}"`
- Full suite (file): `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

> Note: the umbrella `zikzak_inappwebview` suite is currently **blocked** by the
> zuraffa pub-cache corruption; run `flutter pub cache repair` before relying on it.
> There is no mutation-test or property library in this repo, so invariants (U4) are
> pinned as `example` cases sampled at the boundary rather than property tests.
