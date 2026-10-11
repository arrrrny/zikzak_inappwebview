# Test List — flutter347-platformview-rendering (bug #331)

- **Feature dir**: `.specify/bugs/flutter347-platformview-rendering`
- **Spec**: `./spec.md`
- **Planned**: 2026-09-25 @ `fix/flutter347-platformview-clipping` (master `54464edf`)
- **Suite baseline**: green — `zikzak_inappwebview_ios` 12/12 pass
- **Mode**: outer-only (bug-driven spec; on-device matrix is the outer evidence)

## Outer loop (acceptance behaviors)

| Id | Behavior | Traces | Kind | State | Test / evidence |
|----|----------|--------|------|-------|-----------------|
| A1 | Mitigation matrix (control, Impeller-off, opacity wrap, clipsToBounds, PlatformViewLink) executed on-device with captured frames | AC1 | example | DONE | `tdd/cycle-log.md` cycle 2 + `ev_*.png` |
| A2 | iOS WKWebView root sets `clipsToBounds = true` at creation; contract test pins it | AC2 | example | DONE | `test/swift_platform_view_clipping_test.dart` (RED→GREEN in cycle log) |
| A3 | iOS suite + analyze unchanged | AC3 | example | DONE | 13/13 pass; analyze 192 infos (baseline), 0 warnings |
| A4 | Fix report states explicitly that the artifact is NOT fixed by the plugin and the PR must not auto-close the issue | AC4 | example | DONE | `fix.md` § Deviations; PR body |

## Out of scope

- Engine-side repair; macOS embedding; re-running the on-device matrix per CI.
