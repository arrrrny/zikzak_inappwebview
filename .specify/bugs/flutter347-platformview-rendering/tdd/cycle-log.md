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

## Cycle 3 — issue resolution: user-facing workaround documentation (2026-10-27 local, UTC+3 — commit `17426183` authored 2026-10-26T21:34Z; session on `fix/331-flutter-version-upgrade-from-3-44-x-to-3-47-2-causes-renderi` @ `e1c1a555`)

The upstream repair remains open (flutter/flutter#193363, triaged `engine` /
`platform-views` / `c: regression`; still open with no fix on the 3.47 line when
this cycle ran — 2026-10-27 local, UTC+3; upstream comments 2026-10-13/16 add two
independent confirmations and one layout-level observation — a clip wrapper
removal unblocking one Google Maps layout). The forklift chore for #331 ships the
issue's remaining deliverable: the workaround guidance as user-facing
documentation.

**Disposition — the issue stays OPEN.** An earlier draft of this entry planned to
close #331 as resolved-by-documentation, which would have contradicted `spec.md`
AC4 ("the PR must not claim to close the issue"), `fix.md` Status ("this PR must
not close the issue") and `test.md` § Recommendation ("keep #331 **open**"). The
records were right and are unchanged: `Closes` resolves an issue as *completed*
and drops a still-reproducing regression out of triage, so the PR links it with
`Related to #331` instead, #331 carries the `upstream` label, and the tracking
continues on flutter/flutter#193363.

- Changed (docs-only): `README.md` (+7) — a short Known Issues summary that
  points at the canonical copy; `zikzak_inappwebview/README.md` (+14) — the
  canonical section stating the symptom, the engine root cause with the upstream
  tracker, the on-device matrix conclusion (no plugin-side fix exists, cited from
  `fix.md` § *Mitigation matrix*), the shipped `clipsToBounds` hardening, and the
  three workarounds.
- No code behaviour touched → no new tests required by the plan.
- Fresh regression evidence from this session (both suites re-run, `--concurrency=2`):
  - `zikzak_inappwebview_ios`: 77/77 pass (~64 s) — includes the AC2 contract test
    `swift_platform_view_clipping_test.dart`.
  - `zikzak_inappwebview` (umbrella): 269/269 pass (~20 s).
  - `dart analyze`: umbrella 23 issues; iOS 192 issues — the exact recorded
    pre-existing all-info baseline, 0 new.
  - `dart format .` (Dart 3.13.7) re-formats 9 pre-existing test/example files
    (formatter-version drift; not this chore's files — reverted, reported LOW).
- AC4 note: the documented disposition (no plugin-side fix exists, tracked
  upstream) is stated in the PR body and the Known Issues section, which claim no
  behaviour change and no closure — AC4 as written is satisfied, not amended.
