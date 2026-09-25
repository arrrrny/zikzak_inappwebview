# Bug Verification: Flutter 3.47.x rendering layer confusion (#331)

- **Slug**: flutter347-platformview-rendering
- **Tested**: 2026-09-25
- **Assessment**: ./assessment.md
- **Fix**: ./fix.md
- **Result**: partial
- **TDD verification**: ./tdd/verification.md (verdict PASS_WITH_GAPS)

## Summary

The investigation is complete and the shipped hardening is verified, but the
reported artifact is **not fixed** — five plugin-side mitigations were
exhausted on-device and the defect is conclusively in the Flutter 3.47.x
engine's TLHC overlay compositing. `partial` reflects: hardening verified
(RED→GREEN, 13/13, analyze at baseline), artifact still reproduces.

## Checks Performed

| Check | Command / Action | Result | Notes |
|-------|------------------|--------|-------|
| Mitigation matrix (on-device) | 5 candidates × repro harness, iPhone 17/16e simulators, Flutter 3.47.4 | complete | none changes the artifact; frames captured (`ev_*.png`, cycle-log cycle 2) |
| Native-overflow discriminator | red-background HTML variant | pass (informative) | red stays inside the card ⇒ native view does not overflow; content is dropped by the compositor |
| New contract test | `flutter test test/swift_platform_view_clipping_test.dart` | pass | RED captured before the change |
| Regression suite | `flutter test` (zikzak_inappwebview_ios) | pass | 13/13 (12 baseline + 1 new) |
| Lint / type-check | `flutter analyze` | pass | 192 issues = exact baseline (all infos) |
| Artifact resolution (post-fix) | on-device repro | fail (out of plugin scope) | engine-side; upstream report required |

## Output Excerpts

```
RED:   00:00 +0 -1: platform view clips its own rendering … [E]
GREEN: 01:23 +13: All tests passed!
MATRIX: control=broken | impeller-off=broken | opacity0.99=broken |
        clipsToBounds=broken (no native overflow) | PlatformViewLink=broken
```

## Residual Risks

- Users on 3.47.x remain exposed until the engine fix lands; documented
  workarounds: stay on 3.44.x, or avoid keeping platform views alive under
  modal overlays / inside lazy lists.
- The upstream report is the critical path; this PR only carries the evidence.

## Recommendation

Merge the hardening (correct in its own right), keep #331 **open** tracking the
upstream flutter/flutter report, and comment on the issue with the matrix so
affected users have concrete mitigations.
