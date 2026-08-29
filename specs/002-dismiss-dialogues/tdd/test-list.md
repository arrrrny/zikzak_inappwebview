---
feature: 002-dismiss-dialogues
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 5 # SC-001..SC-005 in spec.md
planned_at: abfa842e # short SHA the list was derived from
updated_at: abfa842e # short SHA of the last change to this file
suite_baseline: green # umbrella unit suite green (+98) after fixing/quarantining the two pre-existing broken files
---

# Test List: Dismiss Dialogues Setting (002)

## Critical finding (read before cycling)

`spec.md` describes `dismissDialogues` as a single boolean that, when enabled,
removes **all** `position: fixed` / `position: sticky` elements. The code delivers
**two** related-but-divergent implementations:

1. **The spec's actual behavior** — a boolean `dismissDialogues` setting on
   `InAppWebViewSettings` (default `false`, `in_app_webview_settings.zorphy.dart:287`).
   When `true`, the controllers run an **inline brute-force** JS snippet in
   `onLoadStop` that removes every `fixed`/`sticky` element (retrying 3×) —
   `in_app_webview.dart:337` and `headless_in_app_webview.dart:380`. This matches the
   spec literally. **It currently has no unit or integration test.**
2. **A separate, content-aware `DialogueDismisser` module**
   (`lib/src/dialogue_dismisser/`) that only removes overlays whose *text* matches
   keyword presets (cookie/gdpr/download/newsletter). It is **NOT wired** to the
   `dismissDialogues` setting — `DialogueDismisser.maybeCreate` is only referenced
   inside its own file. Its existing test (`dialogue_dismisser_test.dart`) is a
   characterization of this unwired module, not of the spec's acceptance criteria.

Consequence for this list: the acceptance behaviors (`A1`–`A5`) trace to the
**inline** implementation (#1), which is the spec's contract. The module tests are
recorded below as `BASELINE` characterization of #2 and are out of the spec's
acceptance trace. This divergence is itself a finding for `/speckit.tdd.verify`.

## Outer loop: acceptance behaviors (trace to inline `dismissDialogues`)

| id  | behavior                                                                                 | traces | kind           | state    | test |
| --- | ---------------------------------------------------------------------------------------- | ------ | -------------- | -------- | ---- |
| A1  | Overlay removal is controlled by one boolean `dismissDialogues`, defaulting to `false`   | SC-001 | example (unit) | DONE      | `zikzak_inappwebview/test/dismiss_dialogues_setting_test.dart::InAppWebViewSettings.dismissDialogues (FR-001, FR-002, SC-001) defaults to false (overlay removal disabled)` |
| A2  | With default settings a page keeps its fixed/sticky overlays; enabled, they are removed  | SC-002 | example (integration) | DONE | `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart::SC-002: dismissDialogues removes fixed/sticky overlays when enabled` (iOS Simulator ✓) |
| A3  | Fixed/sticky overlays injected *after* load are removed within the retry window          | SC-003 | example (integration) | DONE | `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart::SC-003: dismissDialogues removes fixed/sticky overlays injected after load (retry window)` (iOS Simulator ✓) |
| A4  | With `dismissDialogues: false` the DOM is never modified                                 | SC-004 | example (integration) | DONE | `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart::SC-004: dismissDialogues leaves overlays intact when disabled` (iOS Simulator ✓) |
| A5  | Overlay removal never crashes the web view, even when a JS error occurs                  | SC-005 | example        | DONE | `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart::SC-005: dismissDialogues never crashes the web view when the removal script throws` (iOS Simulator ✓) |

## Inner loop: the unwired `DialogueDismisser` module (characterization / BASELINE)

These tests already exist and are green. They characterize the **separate** content-
aware module (#2 above), which is not on the spec's acceptance trace. Left here so
the audit can see them and the divergence is explicit.

### `lib/src/dialogue_dismisser/dialogue_dismisser.dart` + `_rules.dart` + `_dismissal.dart`

| id  | behavior                                                            | traces | kind             | state     | test |
| --- | ------------------------------------------------------------------- | ------ | ---------------- | --------- | ---- |
| U1  | `normalizeText` is Turkish-aware (`İ`→`i`, `I`→`ı`) and collapses WS | —      | example          | DONE      | `test/dialogue_dismisser/dialogue_dismisser_test.dart::DialogueDismissRules.normalizeText` |
| U2  | Preset classification honours the enabled preset set                | —      | example          | DONE      | `...::DialogueDismissRules classification::classify honours the enabled preset set` |
| U3  | `buildDialogueDismisserJs` serializes only enabled presets           | —      | example          | DONE      | `...::buildDialogueDismisserJs::serializes enabled presets into the JS` |
| U4  | `DialogueDismisser.maybeCreate` returns null for empty presets      | —      | example          | DONE      | `...::DialogueDismisser::maybeCreate returns null for empty presets` |
| U5  | `buildUserScript` is main-frame-only at document start              | —      | example          | DONE      | `...::DialogueDismisser::buildUserScript is main-frame-only at document start` |
| U6  | `mergeUserScripts` appends the dismisser script (null caller case)  | —      | example          | DONE      | `...::DialogueDismisser::mergeUserScripts appends the dismisser script` |
| U7  | `handleJsPayload` routes dismissals to the callback + round-trips   | —      | example          | DONE      | `...::DialogueDismisser::handleJsPayload routes dismissals to the callback` |

## Invariants and edge cases still to place

- `mergeUserScripts` with an **existing non-empty** caller script list (only the
  null-caller case is covered by U6) — genuine gap, candidate for first `run` cycle.
- `DialogueDismissal.fromJson` with missing/extra fields defaults gracefully.
- A2/A4 integration must run on **macOS (desktop), iOS simulator, and Android
  emulator** per the user's coverage requirement.

## Out of scope

- The content-aware `DialogueDismisser` module's preset behavior itself — it is not
  on the spec's acceptance trace (divergence finding above). Its existing tests stay
  as `BASELINE`.
- iframe-inner overlays (spec edge case): the inline JS only touches the top document.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time. Unit tests
run **inside the owning package**; integration tests run from the example app.

- Single test (umbrella): `cd zikzak_inappwebview && flutter test {file} --plain-name "{name}"`
- Single test (platform_interface): `cd zikzak_inappwebview_platform_interface && flutter test {file} --plain-name "{name}"`
- Full suite (umbrella): `cd zikzak_inappwebview && flutter test`
- Integration (macOS desktop): `cd zikzak_inappwebview/example && flutter test integration_test/dismiss_dialogues_test.dart -d macos`
- Integration (iOS sim): `... -d <iphone-simulator-id>`
- Integration (Android emu): `... -d emulator-<id>`
- Coverage: `cd zikzak_inappwebview && flutter test --coverage`
- Mutation: none available in this repo
