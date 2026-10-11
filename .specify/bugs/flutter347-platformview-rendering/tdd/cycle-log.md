# TDD Cycle Log — flutter347-platformview-rendering (bug #331)

## Baseline

- **Commit**: `54464edf` (master, post-#335 merge) — branch `fix/flutter347-platformview-clipping`
- **Date**: 2026-09-25
- **Suite**: `cd zikzak_inappwebview_ios && flutter test` → **12/12 pass** (green baseline)
- **Device A/B baseline**: artifact reproduced on dedicated iPhone 17 simulator, Flutter 3.47.4, plugin 6.0.2 from pub (`ev_red_bg_control.png`: red-background variant, below-card content + footer missing)

## Cycle 1 — AC2: native clipping contract

- **Test file**: `zikzak_inappwebview_ios/test/swift_platform_view_clipping_test.dart`
- **Test**: `platform view clips its own rendering to its Flutter bounds (bug #331)`

### RED

```
cd zikzak_inappwebview_ios && flutter test test/swift_platform_view_clipping_test.dart
00:00 +0 -1: Some tests failed.
Failing tests:
  …/swift_platform_view_clipping_test.dart: platform view clips its own rendering to its Flutter bounds (bug #331)
```

(The contract fails because `InAppWebView.swift` never sets `clipsToBounds`.)

### GREEN

Implementation: `InAppWebView.swift` (iOS package) sets `clipsToBounds = true`
unconditionally in the view setup, with a comment referencing #331.

```
cd zikzak_inappwebview_ios && flutter test
01:23 +13: All tests passed!
```

(12 baseline + 1 new; no existing test weakened.)

### Refactor

None needed.

## Cycle 2 — AC1: on-device mitigation matrix (not code-driven; evidence run)

Each row: dedicated iPhone 17 simulator (except row 3, iPhone 16e before the
dedicated switch), Flutter 3.47.4, repro harness `/tmp/zkw331_repro` (issue's
exact repro + auto-open/auto-scroll + red-background variant).

| # | Candidate | Mechanism | Result | Evidence |
|---|-----------|-----------|--------|----------|
| 1 | Control (plugin as shipped, `UiKitView`) | — | artifact reproduces (below-card items + footer dropped; occasional full-white frame) | `zkw331_run6_3.png`, `zkw331_run6_2.png`, `ev_red_bg_control.png` |
| 2 | Impeller disabled (`FLTEnableImpeller=false`) | different rasterizer | artifact unchanged | `zkw331_noimp_3.png` |
| 3 | `Opacity(0.99)` wrap (snapshot path) | forces backup-layer composition | artifact unchanged (re-verified 10:13 frame, iPhone 16e) | session log |
| 4 | native `clipsToBounds = true` | prevents native overflow | artifact unchanged; red bg proves native view does NOT overflow — content is dropped by composition | `ev_cliptobounds_kept_artifact.png` |
| 5 | `PlatformViewLink`/`PlatformViewSurface` construction of the same registered native view | alternative widget construction | artifact unchanged | `ev_platformviewlink_kept_artifact.png` |

Conclusion: the engine's TLHC overlay compositing drops Flutter content painted
after the platform view on the 3.47 line, independent of plugin construction,
configuration, or rasterizer. No plugin-side rendering fix exists (AC4).
