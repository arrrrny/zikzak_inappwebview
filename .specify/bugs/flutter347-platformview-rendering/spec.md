# Bug Spec: Flutter 3.47.x rendering confusion — plugin-side mitigation search + native clipping hardening (Bug #331)

## Problem

On the Flutter 3.47.x line, a WebView embedded in a scrolled list under a modal
route (bottom sheet) makes every Flutter widget painted after it in the frame
disappear (list items below it, the sheet footer; occasionally the whole frame
renders white). Reproduced on this repo's issue (#331) with the reporter's
exact repro. See `./assessment.md` and the `ev_*.png` evidence in this
directory.

## Acceptance Criteria

1. **AC1 — Mitigation matrix is exhaustive and evidenced.** Every plugin-side
   hypothesis for the artifact (snapshot-path opacity wrap, RepaintBoundary,
   native `clipsToBounds`, `PlatformViewLink` construction, Impeller disabled)
   is tested against the real repro on-device, with captured frames, and the
   matrix is recorded in the fix report.
2. **AC2 — No native layer leaks its Flutter bounds.** The iOS WKWebView root
   sets `clipsToBounds = true` at creation: a platform view must never paint
   outside the bounds Flutter allocates, independent of the engine regression
   (`UIView.clipsToBounds` defaults to NO and WebKit does not guarantee it on
   the root view). Pinned by an executable source-contract regression test.
3. **AC3 — No regression.** `flutter test` (13/13) and `flutter analyze` (192
   pre-existing infos, 0 warnings) in `zikzak_inappwebview_ios`.
4. **AC4 — Honest disposition.** The fix report states explicitly whether the
   artifact itself is fixed (it is not — AC1 shows the artifact is engine-side
   content dropping, construction-independent), and the PR must not claim to
   close the issue.

## Environment Boundary (recorded, not hidden)

The artifact's actual repair belongs to flutter/flutter (TLHC overlay
compositing). A/B runs were executed on-device (iPhone 17 simulator, iOS 18.x,
Flutter 3.47.4) from a dedicated repro harness; the shared build host ran a
concurrent workload, so two early A/B frames were re-taken after switching to a
dedicated simulator.

## Out of scope

- macOS platform views (different embedding path).
- Engine-side repair (upstream).
