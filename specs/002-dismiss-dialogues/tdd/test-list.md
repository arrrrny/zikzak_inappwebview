---
feature: 002-dismiss-dialogues
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 7
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked
---

> **suite_baseline = blocked (partial)** — the corrupted `zuraffa` pub-cache
> package (missing `extensions/` dir) is now resolved: the umbrella
> `zikzak_inappwebview` package carries a `dependency_overrides` pinning
> `zuraffa` to `pub.zuzu.dev` `6.0.1` (the only hosted mirror with a complete
> 6.x), so it compiles and a sample test runs green. However, the umbrella's
> dismissal-orchestration and acceptance tests (A*, U4–U12) evaluate overlay
> dismissal JavaScript inside a real `InAppWebView`, which needs a webview
> runtime. This headless host has no `DISPLAY`/Xvfb and no webkit libs, so those
> tests cannot run here and remain blocked. The `InAppWebViewSettings.dismissDialogues`
> component (U1–U3) is in `zikzak_inappwebwebview_platform_interface`, which runs
> green and is fully tested (DONE).

# Test List: Dismiss Dialogues Setting

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md` (the seven Given/When/Then acceptance
scenarios in User Stories 1–3). Each stays red until the feature works end to end
through its real entry point: an `InAppWebView` configured with
`InAppWebViewSettings.dismissDialogues` loading a page.

| id  | behavior                                                                                                                              | traces        | kind    | state   | test |
| --- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------- | ------- | ---- |
| A1  | With `dismissDialogues` enabled, loading a page whose DOM contains `position: fixed` popups removes every fixed element from the document after load | FR-003, FR-004 | example | PENDING |      |
| A2  | With `dismissDialogues` enabled, loading a page with sticky navigation bars removes every `position: sticky` element after load         | FR-003, FR-004 | example | PENDING |      |
| A3  | With `dismissDialogues` enabled, the `overflow` and `margin` CSS properties on both `document.documentElement` and `document.body` are reset after load | FR-005        | example | PENDING |      |
| A4  | With `dismissDialogues` false, loading a page with fixed/sticky overlays leaves those elements present and functional after load         | FR-007        | example | PENDING |      |
| A5  | With `dismissDialogues` false, fixed/sticky overlays remain in the DOM, so they appear in screenshot/PDF capture output                  | FR-007        | example | PENDING |      |
| A6  | With `dismissDialogues` enabled, a `position: fixed` overlay injected after initial load is removed within the retry window              | FR-006        | example | PENDING |      |
| A7  | With `dismissDialogues` enabled and no fixed/sticky elements present, the removal routine completes with no error and no side effect     | FR-008        | example | PENDING |      |

## Inner loop: unit behaviors

Grouped by the component from `plan.md` that owns them. The plan's
`in_app_webview_settings.dart` path resolves to
`zikzak_inappwebview_platform_interface/lib/src/domain/entities/in_app_webview_settings/in_app_webview_settings.dart`.

### `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/in_app_webview_settings.dart`

| id  | behavior                                                                                                       | traces  | kind    | state   | test |
| --- | -------------------------------------------------------------------------------------------------------------- | ------- | ------- | ------- | ---- |
| U1  | A default-constructed `InAppWebViewSettings` exposes `dismissDialogues == false`                               | FR-002  | example | DONE    | zikzak_inappwebview_platform_interface/test/types/in_app_webview_settings_test.dart::InAppWebViewSettings.dismissDialogues default-constructed settings expose dismissDialogues == false |
| U2  | An `InAppWebViewSettings` constructed with `dismissDialogues: true` exposes the property as `true`             | FR-001  | example | DONE    | zikzak_inappwebview_platform_interface/test/types/in_app_webview_settings_test.dart::InAppWebViewSettings.dismissDialogues dismissDialogues: true is exposed as true |
| U3  | `dismissDialogues` round-trips through `toJson`/`fromJson` unchanged for both `true` and `false` (invariant, sampled at both boundaries) | FR-001  | example | DONE    | zikzak_inappwebview_platform_interface/test/types/in_app_webview_settings_test.dart::InAppWebViewSettings.dismissDialogues dismissDialogues round-trips through toJson/fromJson (true and false) |

### `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart`

| id  | behavior                                                                                                                              | traces        | kind    | state   | test |
| --- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------- | ------- | ---- |
| U4  | When `dismissDialogues` is true and page load stops, the controller evaluates JS that removes every `position: fixed` and `position: sticky` element | FR-003, FR-004 | example | PENDING |      |
| U5  | When `dismissDialogues` is false, no dismissal JS is evaluated on page load (no DOM modification) — also the de-facto pre-feature baseline | FR-007        | example | PENDING |      |
| U6  | The injected JS resets `overflow` and `margin` on `document.documentElement` and `document.body`                                        | FR-005        | example | PENDING |      |
| U7  | The removal selector matches BOTH `position: fixed` and `position: sticky` elements (each category is removed)                          | FR-003        | example | PENDING |      |
| U8  | The removal logic retries across the load lifecycle with a delay between attempts, so an overlay present at load is removed on the first pass | FR-006        | example | PENDING |      |
| U9  | An overlay injected after the retry window has closed is NOT removed (boundary: late appearance beyond the window)                       | FR-006        | example | PENDING |      |
| U10 | A JavaScript error thrown during removal is caught and does not propagate out of the load handler                                       | FR-008        | example | PENDING |      |
| U11 | Removal targets only the top-level document; elements inside `iframe`/`frame` subtrees are not removed                                  | FR-009        | example | PENDING |      |
| U12 | Running removal on an already-clean page is a no-op: zero errors, zero side effects                                                     | FR-008        | example | PENDING |      |

## Invariants and edge cases still to place

None — all spec edge cases are placed: no-overlays/no-error (U12), JS-error
containment (U10), iframe top-level-only (U11), and opt-out preservation
(A4/A5, U5).

## Out of scope

- **Removal of overlays inside iframes**: explicitly out of scope per spec
  assumptions (cross-origin restrictions). FR-009 only requires that the
  top-level document is handled (covered by U11); iframe content is left
  untouched by design.
- **The preset-based `DialogueDismisser`** (`lib/src/dialogue_dismisser/*`,
  tested by `zikzak_inappwebview/test/dialogue_dismisser/dialogue_dismisser_test.dart`)
  is a separate, content-aware feature that evolved alongside this one. It is NOT
  the `dismissDialogues` boolean in `spec.md` and is intentionally not covered by
  this list.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` for the relevant package
(`zikzak_inappwebview`, the umbrella — where acceptance and dismissal logic live):

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

The settings component (U1–U3) uses the identical command form from cwd
`zikzak_inappwebview_platform_interface` (green stack). No mutation/property
library exists in the repo, so invariants (U3, U12) are example tests sampled at
boundaries, not property tests.
