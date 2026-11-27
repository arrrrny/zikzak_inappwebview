# Bug Fix: Reliable macOS find-in-page results on virtualized pages

- **Slug**: macos-find-walker-rescan
- **Fixed**: 2026-11-28
- **Assessment**: ./assessment.md
- **Status**: applied
- **TDD artifacts**: ./tdd/test-list.md, ./tdd/cycle-log.md, ./tdd/verification.md

## Summary

The macOS find bridge now posts counts from `finally`, reports navigation even when highlights disappear or no matches exist, and reruns the active query after a debounced `scrollend`. Existing shadow-root and same-origin iframe traversal from #1155 is preserved and covered by executable regression tests.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/FindInteractionJS.swift` | modified | Exception-safe count delivery, unconditional navigation posts, null-safe highlight recoloring, active-query retention, debounced scroll rescan, and pending-rescan cancellation. |
| `zikzak_inappwebview_macos/test/find_shadow_dom_contract_test.dart` | modified | Executes the exact injected script for failed walks, missing/zero highlights, nested roots, debounce timing, cancellation, listener count, and null-document frames. |
| `zikzak_inappwebview_macos/test/fixtures/find_interaction_harness.js` | added | Dependency-free deterministic DOM, bridge-message, event-listener, and controllable-clock fixture. |
| `.specify/bugs/macos-find-walker-rescan/` | added | Assessment, bug spec, ordered tasks, red/green cycle log, independent-audit verification, and this fix report. |

## Tests Added or Updated

- `test/find_shadow_dom_contract_test.dart::failed walks still post final counts` — a throw after one highlight still produces a final partial-count message.
- `test/find_shadow_dom_contract_test.dart::missing highlights still post navigation counts` — a missing active node does not suppress navigation counts or throw.
- `test/find_shadow_dom_contract_test.dart::zero-match navigation posts counts` — zero-match navigation emits an explicit result.
- `test/find_shadow_dom_contract_test.dart::scrollend rescans newly mounted matches` — no rescan occurs before 150 ms after the latest event, then exactly one rescan includes new text.
- `test/find_shadow_dom_contract_test.dart::clearing matches cancels pending rescans` — clearing cancels the timer and prevents old-query posts.
- `test/find_shadow_dom_contract_test.dart::nested roots are searched and cleared` — shadow-root and iframe highlights are both found and removed on rerun.
- `test/find_shadow_dom_contract_test.dart::frame safety keeps one listener and skips null documents` — one capture listener is installed and a null `contentDocument` is safe.

## Local Verification

- `dart format --output=none --set-exit-if-changed test/find_shadow_dom_contract_test.dart` -> 0 changed.
- `flutter analyze --no-pub --no-fatal-infos` -> `No issues found!` (1.8s).
- `flutter test --no-pub --concurrency=2` -> 200 passed, 0 failed (2:36), against hosted `zikzak_inappwebview_platform_interface` 6.6.0.
- `flutter build macos --debug` from `zikzak_inappwebview/example` with the CI-style temporary checkout overrides -> `Built build/macos/Build/Products/Debug/example.app`.
- Five deliberate mutants (shadow traversal, iframe cleanup, zero delay, duplicate listener, null-document access) were each caught and restored; details are in `tdd/verification.md`.

Red evidence is recorded per behavior in `tdd/cycle-log.md`; the decisive failures were missing bridge messages (`0 !== 1`), a missing rescan timer (`0 !== 1`), and a surviving timer after clear (`1 !== 0`).

## Deviations from Assessment

- No assessment for issue #472 existed on `master`; the installed bug-assessment workflow was followed manually to create this bug directory.
- Current `master` already contained #1155's shadow-root/iframe traversal, so this fix preserves it and adds missing delivery/rescan hardening rather than reimplementing nested-root discovery.
- The issue labels scroll replay as optional; it is included because it is the package-level mitigation for newly mounted virtualized rows.
- The first full-suite attempt used a 120-second wrapper and was terminated during Flutter finalization at `01:47 +182`. The exact misfire was reported at https://github.com/arrrrny/zikzak_inappwebview/issues/472#issuecomment-7228988076; the same suite passed with a 300-second hard timeout.
- `check-prerequisites.sh` rejects the brief-mandated `feat/issue-472` branch name, so the explicitly pinned bug directory was used directly.
- Dependency overrides were set aside for published-package tests and restored before commit. A temporary CI-style example override was used only to compile this checkout's macOS sources and was removed afterward.
- The Node harness runtime is not pinned in CI; changing the workflow requires separate authorization.

## Follow-ups

- Pin Node in the macOS test job with an authorized CI change.
- Exercise find-in-page in a real WebKit session on a long virtualized page when a GUI/browser harness is available.
