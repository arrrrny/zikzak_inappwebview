# Test List: Split InAppWebViewController into Domain-Specific Controllers

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works
end to end through its real entry point. Loop is `outside-in`: the feature has a
consumer-visible surface (`InAppWebViewController` and its `navigation`,
`javaScript`, `cookies`, `settings` facades, plus platform `delegate` getters), so
the acceptance tests are written first and stay red until the split works.

> **Inner loop: skipped (outer-only).** `plan.md` is absent for this feature, so no
> inner-loop unit tables are produced. Components (`NavigationController`,
> `JavaScriptController`, `CookieController`, `SettingsController`,
> `Platform*Delegate`) are already scaffolded in the codebase; their unit behaviors
> should be enumerated once `plan.md` exists. Edge-case expectations from spec.md
> are captured here as additional `A` behaviors where they are observable through
> the public surface.

| id  | behavior                                                                                                              | traces          | kind    | state   | test |
| --- | --------------------------------------------------------------------------------------------------------------------- | --------------- | ------- | ------- | ---- |
| A1  | Calling `controller.loadUrl(...)` directly on the monolithic controller still loads the requested URL with identical observable behavior to before the split | SC-001, SC-002, FR-002 | example | PENDING |      |
| A2  | Calling `controller.evaluateJavascript(...)` / `controller.addJavaScriptHandler(...)` directly still evaluates JS and invokes handlers identically to the pre-split implementation | SC-001, FR-002  | example | PENDING |      |
| A3  | Any previously-supported monolithic method invocation internally routes through the corresponding domain controller and yields the same result with no new exceptions | SC-001, SC-002, FR-002 | example | PENDING |      |
| A4  | After `controller.navigation.goBack()`, `controller.navigation.canGoForward()` returns `true`                          | SC-003, FR-005   | example | PENDING |      |
| A5  | `controller.navigation.canGoBack()` called before any navigation returns `false` (same as the monolithic method)      | SC-003, FR-005   | example | PENDING |      |
| A6  | `controller.navigation.goBackOrForward(steps: N)` lands at the same history position as the equivalent monolithic `goBackOrForward` | SC-003, FR-005   | example | PENDING |      |
| A7  | A handler registered via `controller.javaScript.addJavaScriptHandler(...)` fires its Dart callback with the payload when invoked from the page (identical to the monolithic API) | SC-003, FR-006   | example | PENDING |      |
| A8  | `controller.javaScript.evaluateJavascript(source: ...)` resolves to the same value as the monolithic `evaluateJavascript` | SC-003, FR-006   | example | PENDING |      |
| A9  | `controller.javaScript.removeJavaScriptHandler(handlerName: ...)` stops subsequent page invocations from reaching Dart (same as before the split) | SC-003, FR-006   | example | PENDING |      |
| A10 | `controller.cookies.setCookie(name, value)` with no URL stores the cookie scoped to the current URL U and it is returned by `getCookies()` | SC-003, SC-005, FR-007 | example | PENDING |      |
| A11 | `controller.cookies.getCookies()` / `setCookie(...)` with no current URL and no explicit URL degrade safely (empty list / `false`) instead of throwing | SC-003, SC-005, FR-007 | example | PENDING |      |
| A12 | A cookie operation with an explicit URL targets that URL rather than the current one (preserving prior explicit-URL behavior) | SC-003, FR-007   | example | PENDING |      |
| A13 | `controller.settings.getSettings()` returns settings matching `controller.getSettings()`                              | SC-003, FR-008   | example | PENDING |      |
| A14 | `controller.settings.setSettings(settings)` applies configuration equal to the monolithic `setSettings(...)`            | SC-003, FR-008   | example | PENDING |      |
| A15 | On the Android platform controller the four delegate getters (`navigationDelegate`, `javaScriptDelegate`, `cookieDelegate`, `settingsDelegate`) each return a concrete non-null delegate | SC-004, FR-003, FR-004 | example | PENDING |      |
| A16 | On the iOS platform controller the same four delegate getters each return a concrete non-null delegate                  | SC-004, FR-003, FR-004 | example | PENDING |      |
| A17 | On a not-yet-migrated implementation each delegate getter returns `null` without throwing                              | SC-004, FR-003   | example | PENDING |      |
| A18 | Repeated access to the same domain getter (e.g. `controller.navigation`) returns the identical lazily-created instance with no duplicate state | SC-006, FR-011   | example | PENDING |      |
| A19 | Accessing a domain facade whose platform delegate is `null` still functions by delegating to the parent monolithic method (interim migration state), without throwing | FR-002, FR-003   | example | PENDING |      |
| A20 | A domain controller method called after the controller / web view is disposed does not crash and matches the monolithic behavior | FR-002, SC-005   | example | PENDING |      |
| A21 | Domain facades accessed on a `HeadlessInAppWebView` match the equivalent monolithic calls                              | FR-002          | example | PENDING |      |
| A22 | Constructing a platform controller after zorphy/DI regeneration resolves all four concrete delegate instances (no `null`, no duplicate wiring) | FR-009          | example | PENDING |      |

## Invariants and edge cases still to place

Inner-loop unit invariants are intentionally omitted: `plan.md` is absent, so the
inner loop is skipped for this plan. When `plan.md` is added, the following belong
to the component that owns them (sampled at boundaries — no property/mutation tool
in the profile, so mark `kind: example`):

- Round-trip invariant: a cookie set via `controller.cookies` and read back yields
  the same name/value/url scoping (boundary: no-URL default vs explicit-URL).
- Idempotence: calling `setCookie` twice with the same name/value is stable.
- Ordering: `goBack` / `goForward` / `goBackOrForward` preserve history position
  ordering against the monolithic equivalent (boundary: `steps == 0`).

## Out of scope

- Screenshot/PDF, media, DevTools and other methods outside the four named domains:
  they remain on the monolithic controller (spec Assumptions — out of scope for this split).
- Mutation / property-based testing of the facades: no `mutation_test` or
  `glados`/`fast_check` library exists in any `pubspec.lock` (profile), so invariants
  are captured as sampled `example` tests only.
- Cross-platform runtime navigation/cookie behavior on real devices: only the
  Android/iOS delegate-getter resolution (A15, A16) is in scope as an acceptance
  probe; full e2e lives in `zikzak_inappwebview/example/integration_test` (needs a device).

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time
(`zikzak_inappwebview_platform_interface` — the runnable green stack). The feature
also targets the umbrella `zikzak_inappwebview` and `zikzak_inappwebview_module`
packages, whose suites are **blocked** by the zuraffa pub-cache corruption; run
`flutter pub cache repair` before executing tests in those packages.

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

Notes:
- A1–A14, A18–A21 are acceptance behaviors on the umbrella `zikzak_inappwebview`
  package (blocked until `flutter pub cache repair`); run them there once repaired.
- A15 (Android) and A16 (iOS) run in `zikzak_inappwebview_android` and
  `zikzak_inappwebview_ios` respectively, using the same `flutter test` shape
  (both smoke-verified green).
- A17 can be asserted on the platform-interface base `PlatformInAppWebViewController`
  (the default green stack).
