# Bug Fix: Flutter 3.47.x rendering layer confusion (#331) — mitigation search + native clipping hardening

- **Slug**: flutter347-platformview-rendering
- **Fixed**: 2026-09-25
- **Assessment**: ./assessment.md
- **Status**: partial — hardening applied; the artifact itself is **not** fixable
  plugin-side (engine regression) and this PR must not close the issue
- **Branch**: `fix/flutter347-platformview-clipping`
- **TDD artifacts**: ./tdd/test-list.md, ./tdd/cycle-log.md, ./tdd/verification.md

## Summary

Five plugin-side mitigations were tested against the reproduced #331 artifact on
a real simulator; none changes it, proving the defect is the Flutter 3.47.x
engine's TLHC overlay compositing (content painted after the platform view is
dropped). What this PR ships: the one correctness defect the investigation
surfaced — the iOS WKWebView root never guaranteed `clipsToBounds`, so a native
layer CAN paint outside its Flutter bounds under any mis-clip — now set
unconditionally and pinned by a source-contract regression test, plus the
complete mitigation matrix as the issue's evidence base for the upstream report.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview_ios/.../InAppWebView/InAppWebView.swift` | modified | `clipsToBounds = true` unconditionally at view setup (comment references #331) |
| `zikzak_inappwebview_ios/test/swift_platform_view_clipping_test.dart` | added test | source-contract: the root view must set `clipsToBounds = true` |
| `.specify/bugs/flutter347-platformview-rendering/**` | added | issue/assessment/spec/fix/verification/test records + evidence frames |

## Mitigation matrix (on-device, Flutter 3.47.4, iPhone 17/16e simulators)

| Candidate | Result |
|-----------|--------|
| Control (`UiKitView`, plugin as shipped) | artifact reproduces |
| Impeller disabled | unchanged |
| `Opacity(0.99)` snapshot wrap | unchanged |
| native `clipsToBounds` | unchanged — red-background variant proves the native view does not overflow; content is dropped by composition |
| `PlatformViewLink` construction | unchanged |

## Tests Added or Updated

- `swift_platform_view_clipping_test.dart` — pins the clipping contract
  (RED observed before the Swift change; GREEN after; 13/13 total).

## Local Verification

- `flutter test` (zikzak_inappwebview_ios): **13/13 pass**
- `flutter analyze`: 192 issues = exact pre-existing baseline (all infos), 0 new
- On-device A/B matrix: see `./tdd/cycle-log.md` cycle 2 and the `ev_*.png` frames
- The changed Swift compiles via the CI `build-ios` job (local iOS build was
  disk-constrained on the shared host; the change is a single UIView property
  assignment)

## Deviations from Assessment

- The assessment's Proposed Remediation hypothesized a KVC/opaque-backing-class
  fix; the on-device matrix disproved every plugin-side candidate, so the shipped
  code is the clipping hardening (AC2) and the remediation's operative part
  becomes the evidence pack for the upstream flutter/flutter report (AC4).

## Follow-ups

- File the minimal repro upstream on flutter/flutter (TLHC overlay drop,
  `UiKitView` + modal route + scrolled platform view, 3.44.x OK / 3.47.x broken)
  and track #331 on it.
- Re-visit when Flutter ships a 3.4x fix: remove this issue's workaround notes.
