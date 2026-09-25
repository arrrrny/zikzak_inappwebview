# Bug Verification: [macOS] EXC_BREAKPOINT crash accessing a nil sourceFrame (#327)

- **Slug**: macos-sourceframe-crash
- **Tested**: 2026-09-25
- **Assessment**: ./assessment.md
- **Fix**: ./fix.md
- **Result**: partial
- **TDD verification**: ./tdd/verification.md (verdict PASS_WITH_GAPS)

## Summary

The fix is applied and every automatable check passes: the source-contract
tests fail on the defective tree and pass after the fix, the 48-test baseline
is intact (51/51), analyze is clean, and the changed Swift compiles (example
macOS build exit 0 pre- and post-fix). The on-device crash reproduction
(macOS 15.1 WebKit nil-frame navigation) could not be exercised in this
environment — hence `partial`, not `verified`.

## Checks Performed

| Check | Command / Action | Result | Notes |
|-------|------------------|--------|-------|
| Reproduction (post-fix) | macOS 15.1 device + nil-frame navigation | not-run | requires the reporter's OS build/WebKit quirk; environment boundary recorded in spec |
| New tests (red→green) | `flutter test test/swift_sourceframe_kvc_test.dart` | pass | RED captured pre-fix (3/3 fail with violation list), GREEN post-fix |
| Regression suite | `flutter test` (zikzak_inappwebview_macos) | pass | 51/51 (48 baseline + 3 new), no existing test weakened |
| Lint / type-check | `flutter analyze` | pass | No issues found |
| Compile gate | `flutter build macos --debug` (example) | pass | exit 0 before and after; no CI job compiles macOS Swift |

## Output Excerpts

```
RED:   00:05 +0 -3: Some tests failed.  (AC1 violation list: InAppWebView.swift 6 sites; AC2 Expected <1> Actual <0>; AC3 Expected <2> Actual <0>)
GREEN: 00:07 +51: All tests passed!
BUILD: flutter build macos --debug → exit 0 (post-fix)
```

## Residual Risks

- The crash path itself was verified by construction (the trap source is gone
  from the sources) rather than by on-device repro; reporter confirmation on
  macOS 15.1 is the final proof.
- KVC reads rely on WebKit's public property names (`sourceFrame`,
  `request`, `securityOrigin`) — the same reliance the shipped
  `WKFrameInfo.toMap()` already carries.

## Recommendation

Merge-worthy: the automatable evidence is fully green and the defect class is
pinned by regression tests. Ask the reporter to confirm on 6.0.3+ / the PR
branch; keep the issue open until then if preferred (the PR carries
`Closes #327`).
