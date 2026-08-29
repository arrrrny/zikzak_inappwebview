---
feature: 014-portable-sessions
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 6
planned_at: abfa842e
updated_at: abfa842e
suite_baseline: green
---

# Test List: Portable Sessions for zikzak_inappwebview (via zikzak_session)

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works end to end through its real entry point.

| id  | behavior                                                    | traces         | kind      | state  | test                                           |
| --- | ----------------------------------------------------------- | -------------- | --------- | ------ | ---------------------------------------------- |
| A1  | Save harvests cookies via CookieManager and localStorage via JS eval, persists PortableSession through SessionPort | US1 Scenario 1, FR-002, FR-003 | example   | DONE   | `test/webview_sessions_test.dart::public save/load through the API (FR-002/FR-004/US1) save harvests cookies+storage and persists through the port` (also `::session round-trip through the port (FR-002/US1)` at the port level) |
| A2  | Load restores cookies via CookieManager.setCookie and localStorage via JS eval, returns false when not found | US1 Scenario 2, US1 Scenario 3, FR-004 | example   | DONE   | `test/webview_sessions_test.dart::public save/load through the API (FR-002/FR-004/US1) load re-applies cookies and localStorage onto the webview` + `::load reports not-found for an unknown session` |
| A3  | Two named sessions with different cookies coexist without cross-contamination when saved and loaded separately | US2, FR-001    | example   | DONE   | `test/webview_sessions_test.dart::two named sessions coexist without contamination (US2)` |
| A4  | WebViewSessions controller exposes save, load, list, delete methods with injectable SessionPort | US3, FR-001, FR-007, FR-008 | example   | DONE   | `test/webview_sessions_test.dart::port injection (FR-007)` |
| A5  | Cookie mapping translates plugin Cookie to/from zikzak_session CookieEntry with value stringification and safe defaults | FR-005         | example   | DONE   | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| A6  | Storage entries carry key, value, origin with area=localStorage | FR-006         | example   | DONE   | `test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004)` |

## Inner loop: unit behaviors

Grouped by the component from `plan.md` that owns them. Each line names one observable result.

### `zikzak_inappwebview/lib/src/webview_sessions/webview_sessions.dart`

| id  | behavior                                                  | traces        | kind           | state   | test                                      |
| --- | --------------------------------------------------------- | ------------- | -------------- | ------- | ----------------------------------------- |
| U1  | toCookieEntry maps plugin Cookie.name to CookieEntry.name | FR-005        | characterization | BASELINE | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| U2  | toCookieEntry maps plugin Cookie.value (dynamic) to CookieEntry.value stringified | FR-005 | characterization | BASELINE | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| U3  | toCookieEntry maps plugin Cookie.domain (nullable) to CookieEntry.domain with '' fallback | FR-005 | characterization | BASELINE | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| U4  | toCookieEntry maps plugin Cookie.path (nullable) to CookieEntry.path with '/' fallback | FR-005 | characterization | BASELINE | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| U5  | toCookieEntry maps plugin Cookie.expiresDate (nullable int) to CookieEntry.expiresAt (nullable int) | FR-005 | characterization | BASELINE | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| U6  | toCookieEntry maps plugin Cookie.isSecure (nullable bool) to CookieEntry.secure with false fallback | FR-005 | characterization | BASELINE | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| U7  | toCookieEntry maps plugin Cookie.isHttpOnly (nullable bool) to CookieEntry.httpOnly with false fallback | FR-005 | characterization | BASELINE | `test/webview_sessions_test.dart::cookie mapping (FR-005)` |
| U8  | harvestLocalStorage evaluates 'JSON.stringify(window.localStorage)' via injected evaluator | FR-003        | characterization | BASELINE | `test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004)` |
| U9  | harvestLocalStorage returns empty list on evaluation exception | FR-003        | characterization | BASELINE | `test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004)` |
| U10 | harvestLocalStorage returns empty list on empty string result | FR-003        | characterization | BASELINE | `test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004)` |
| U11 | harvestLocalStorage returns empty list on non-Map JSON result | FR-003        | characterization | BASELINE | `test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004)` |
| U12 | harvestLocalStorage maps each Map entry to (key, value.toString()) | FR-003, FR-006 | characterization | BASELINE | `test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004)` |
| U13 | applyLocalStorage calls evaluator with setItem per entry, keys/values JSON-encoded | FR-004, FR-006 | characterization | BASELINE | `test/webview_sessions_test.dart::localStorage harvest/apply (FR-003/FR-004)` |
| U14 | save constructs PortableSession with id, name, origin, createdAt, updatedAt, mapped cookies, mapped storage | FR-001, FR-002, FR-003, FR-005, FR-006 | characterization | BASELINE | `test/webview_sessions_test.dart::public save/load through the API (FR-002/FR-004/US1) save harvests cookies+storage and persists through the port` |
| U15 | save calls port.save with the constructed PortableSession | FR-002        | characterization | BASELINE | `test/webview_sessions_test.dart::public save/load through the API (FR-002/FR-004/US1) save harvests cookies+storage and persists through the port` |
| U16 | load calls port.load and returns false when session is null | FR-002, FR-004 | characterization | BASELINE | `test/webview_sessions_test.dart::public save/load through the API (FR-002/FR-004/US1) load reports not-found for an unknown session` |
| U17 | load applies each cookie via CookieManager.setCookie with domain/path/expires/secure/httpOnly | FR-004        | characterization | BASELINE | `test/webview_sessions_test.dart::public save/load through the API (FR-002/FR-004/US1) load re-applies cookies and localStorage onto the webview` |
| U18 | load filters storage to area='localStorage' and applies via applyLocalStorage | FR-004, FR-006 | characterization | BASELINE | `test/webview_sessions_test.dart::public save/load through the API (FR-002/FR-004/US1) load re-applies cookies and localStorage onto the webview` |
| U19 | list delegates to port.list | FR-001        | characterization | BASELINE | `test/webview_sessions_test.dart::session round-trip through the port (FR-002/US1)` |
| U20 | delete delegates to port.delete and returns bool | FR-001        | characterization | BASELINE | `test/webview_sessions_test.dart::delete frees the session (FR-001)` |
| U21 | _originOf returns url.origin when non-empty and not 'null', else url.toString() | FR-003, FR-004 | characterization | BASELINE | *(no direct test — covered via round-trip)* |
| U22 | CookieManager is lazily created when not injected (platform-channel boundary) | FR-007        | characterization | BASELINE | `test/webview_sessions_test.dart::port injection (FR-007)` |

## Invariants and edge cases still to place

Behaviors that belong to the feature but do not yet have a home component. Each must become a numbered line above before the feature is done, or be dropped with a reason.

- Clock injection: `DateTime.now()` called in `save`; should be injectable for deterministic tests (currently captured locally before use).
- save overwrites existing session with same id (port.save contract handles this, but not explicitly tested as a boundary).
- load with valid session but empty cookies/storage list — should still return true and not throw.

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- Issue #253 (per-instance persistent isolated WKWebsiteDataStore/Android profiles): tracked separately; the portable-session layer works on top of whatever store the webview uses.
- sessionStorage capture (localStorage only — it survives navigation, which is what session restore needs).
- IndexedDB/Cache API persistence.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, so this file is readable on its own:

- Single test: `flutter test {file} --plain-name "{name}"`
- File tests: `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`