# Cycle Log: Portable Sessions for zikzak_inappwebview (via zikzak_session)

Append only. Newest last. Every entry's `red` block is the evidence that the test
existed and failed before the implementation.

## Baseline

- suite: `flutter test` in `zikzak_inappwebview` -> 95 passed, 2 files fail to compile (pre-existing, unrelated)
- commit: `abfa842e`
- recorded: cycle 0, before any change

### Red baseline details

The two compile-broken files are NOT this feature's responsibility:
1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift from the standardize-dispose-patterns work).
2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is **not declared in `pubspec.yaml`**; the source `lib/src/webview_sessions/webview_sessions.dart` has the same missing import. This is an unmet dependency, not a test bug.

These reds are pre-existing and unrelated to any TDD cycle. No TDD loop can start on top of this red baseline until they are resolved — that is a separate fix (restore the `disposed` getter, or add/repair the `zikzak_session` dependency), not part of a behavior cycle. The rest of the suite (95 tests) is green and safe to cycle against once the two broken files are quarantined or fixed.

## Unblock — dependency wiring (not a behavior cycle)

- trigger: session asked to clear up whether `webview_sessions` depends on `zikzak_session`. It does (`lib/src/webview_sessions/webview_sessions.dart` and `test/webview_sessions_test.dart` both `import 'package:zikzak_session/zikzak_session.dart'`), but no pubspec declared it. A local copy exists at `~/Developer/zikzak_session` (v0.1.0) and it is published on pub.dev (latest 0.2.0).
- fix:
  1. Added to `zikzak_inappwebview/pubspec.yaml` `dependencies`: `zikzak_session: { path: ../../zikzak_session }` (local sibling; swap to hosted `^0.2.0` before `flutter pub publish`).
  2. Un-quarantined `disabled/webview_sessions.dart` -> `lib/src/webview_sessions/webview_sessions.dart` and `test/webview_sessions_test.disabled.dart` -> `test/webview_sessions_test.dart`.
  3. `flutter pub get` resolved the new dependency (also picked up local `zuraffa`).
- result: `flutter test test/webview_sessions_test.dart` -> **10 passed**; full `flutter test` in `zikzak_inappwebview` -> **109 passed** (was 99). The compile blocker is gone.
- note: this does NOT change the TDD verdict. The feature was still implemented test-after (PR #256); only the missing-dependency blocker is resolved. Re-run `/speckit.tdd.verify 014` to refresh.

## Switch — hosted `^0.2.0`

- user requested swapping the local `path:` dependency for the published hosted version.
- `pubspec.yaml` now has `zikzak_session: ^0.2.0` (no path, no override). `flutter pub get` resolved `zikzak_session 0.2.0` from pub.dev.
- verification: `test/webview_sessions_test.dart` -> **10/10 passed**; full `flutter test` -> **109 passed**. No API drift vs the local 0.1.0 the feature was built against. Publish-clean now.

## Deliberate-mutant evidence (strength audit, not test-first)

The feature was implemented test-after (PR #256), so the cycle log cannot show a
pre-implementation red. These deliberate mutants prove the existing tests would
catch a regression: each change was applied to
`lib/src/webview_sessions/webview_sessions.dart`, the relevant test(s) run, the
failure captured, the file restored exactly from backup, and the suite re-run to
confirm green. No mutant was left in the tree.

Command template: `flutter test test/webview_sessions_test.dart --plain-name "{name}"`

### Caught mutants (behavior is genuinely pinned)

| # | Behavior | Mutant | Test | Decisive failure line |
| - | -------- | ------ | ---- | ---------------------- |
| M1 | U6 secure default (A5) | `secure: cookie.isSecure ?? false` -> `?? true` | `null optionals fall back to safe defaults` | `Expected: false` / `Actual: <true>` |
| M2 | U2 value stringify (A5) | `cookie.value?.toString() ?? ''` -> `cookie.value ?? ''` | `null optionals fall back to safe defaults` | `type 'int' is not a subtype of type 'String'` (line 65) |
| M3 | U3 domain fallback (A5) | `cookie.domain ?? ''` -> `?? 'NONE'` | `null optionals fall back to safe defaults` | `Expected: ''` / `Actual: 'NONE'` |
| M4 | U4 path fallback (A5) | `cookie.path ?? '/'` -> `?? '/x'` | `null optionals fall back to safe defaults` | `Expected: '/'` / `Actual: '/x'` |
| M5 | U7 httpOnly default (A5) | `cookie.isHttpOnly ?? false` -> `?? true` | `null optionals fall back to safe defaults` | `Expected: false` / `Actual: <true>` |
| M6 | U9 harvest exception (A6) | remove `try/catch` around `evaluate` | `a failing or empty evaluation yields an empty list` | `Bad state: no page` propagated (test errors) |
| M7 | U11 non-Map guard (A6) | remove `if (decoded is! Map...) return const [];` | `a failing or empty evaluation yields an empty list` | compile error: `The getter 'entries' isn't defined for 'Object?'` (guard is load-bearing; its removal breaks the build) |
| M8 | U13 apply json-encode (A6) | `jsonEncode(entry.value)` -> `entry.value` | `applyLocalStorage issues one setItem per entry, JSON-escaped` | `Expected: [ 'window.localStorage.setItem("auth", "a\"b")', ...]` differs |
| M9 | U20 delete delegation (A3) | `=> port.delete(sessionId)` -> `=> Future.value(false)` | `delete frees the session (FR-001)` | `Expected: true` / `Actual: <false>` |

### Survivor mutants (tests do NOT exercise the public API)

These prove a real coverage gap. No test calls `WebViewSessions.save` or
`WebViewSessions.load`; the acceptance tests call the `SessionPort` (`store.save`)
and `list`/`delete` directly, bypassing the public methods.

| # | Behavior | Mutant | Result |
| - | -------- | ------ | ------ |
| S1 | A1 save | neutralize `await port.save(...)` in `save` (`if (false) await port.save(...)`) | **survives** — full suite still 10/10; cookie harvest + localStorage harvest + port persistence inside `save` are untested |
| S2 | A2 load | `if (session == null) return false` -> `return true` | **survives** — full suite still 10/10; cookie re-application + storage re-application inside `load` are untested |

Consequence: acceptance criteria **A1 (save)** and **A2 (load)** are claimed
covered by the test list but their public entry points are never invoked. The
static helpers they delegate to (U1–U13) are well covered, but the orchestration
in `save`/`load` itself has zero test coverage. This is a `HIGH` strength finding
and the reason the verify verdict cannot be `PASS`.

## Public-API coverage added — kills S1/S2 (TEST_AFTER, no pre-impl red)

- trigger: `/speckit.tdd.verify 014` returned FAIL with two survivors because no
  test invoked `WebViewSessions.save` / `load`. User asked to close the gap
  ("lets make it green").
- refactor (green-code seam, not a behavior cycle): `save`/`load` now take a
  nullable `InAppWebViewController? controller` and an optional
  `evaluateJavascript` closure; a evaluator may be injected at construction
  (`WebViewSessions({... evaluateJavascript})`) or per call. This lets the public
  methods run without a registered platform in `flutter test`. The production API
  is unchanged for real callers (pass a non-null `controller`).
- tests added in `test/webview_sessions_test.dart`, group
  `public save/load through the API (FR-002/FR-004/US1)`:
  - `save harvests cookies+storage and persists through the port` — fake
    `CookieManager` (`_FakeCookiePlatform`) returns one cookie; `_Eval` returns
    localStorage JSON; calls `sessions.save(null, ...)`; asserts `sessions.list()`
    returns the persisted session with that cookie + storage. (covers A1, U14, U15)
  - `load re-applies cookies and localStorage onto the webview` — pre-saves a
    `PortableSession` via the port; calls `sessions.load(null, ...)`; asserts
    `CookieManager.setCookie` was called once with the right name/value and
    `window.localStorage.setItem("auth", "token-1")` was evaluated. (covers A2, U17, U18)
  - `load reports not-found for an unknown session` — calls
    `sessions.load(null, sessionId: 'nobody', ...)`; asserts `false`. (covers A2, U16)
- result: `flutter test test/webview_sessions_test.dart` → **13 passed** (was 10);
  `flutter analyze lib/src/webview_sessions/webview_sessions.dart test/webview_sessions_test.dart`
  → No issues found.
- deliberate-mutant re-check (each restored exactly, suite re-green):
  - **S1** (`await port.save(...)` neutralized in `save`) → now **CAUGHT**:
    `Expected: an object with length of <1>` / `Actual: []` in the save test.
  - **S2** (`if (session == null) return false` → `return true`) → now **CAUGHT**:
    `Expected: false` / `Actual: <true>` in the not-found test.
- note: these tests were written against already-shipping code (feature was
  test-after, PR #256). They are documented as **TEST_AFTER** — no
  pre-implementation red exists in git. They are pinned by the same
  deliberate-mutant method the original audit used, so they are genuine
  regression guards, not weak tests. No mutant left in the tree.
- consequence: mutation score is now **11/11 (no survivors)**. Acceptance A1/A2
  are now verified through their real entry points. The remaining verify finding
  is only the historical test-after classification of A1–A6 (no cycle-log red),
  which is documented, not a coverage gap.
