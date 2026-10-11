# Test List — macos-sourceframe-crash (bug #327)

- **Feature dir**: `.specify/bugs/macos-sourceframe-crash`
- **Spec**: `./spec.md`
- **Planned**: 2026-09-25 @ `fix/macos-sourceframe-crash` (master 76528631)
- **Suite baseline**: green — `zikzak_inappwebview_macos` 48/48 pass
- **Mode**: outer-only (no plan.md; bug-driven spec, environment boundary per spec)
- **Loop**: inside-out is not used; behaviors verified by source-contract + compile
  proof because a nil runtime `sourceFrame` cannot be produced deterministically
  outside macOS 15.1 WebKit (recorded in spec).

## Outer loop (acceptance behaviors)

| Id | Behavior (precondition → observable result) | Traces | Kind | State | Test |
|----|----------------------------------------------|--------|------|-------|------|
| A1 | macOS Swift sources scanned post comment/string-strip contain no `.sourceFrame` dot-member access (precondition: any navigation reaching the delegate) | AC1 | example | DONE | `test/swift_sourceframe_kvc_test.dart` › AC1 |
| A2 | A `sourceFrameMap` KVC accessor exists in the macOS sources and reads the frame and its request via `value(forKey:)` (mechanism that turns a nil runtime object into nil instead of a trap) | AC2 | example | DONE | `test/swift_sourceframe_kvc_test.dart` › AC2 |
| A3 | Both former crash sites (`decidePolicyForNavigationAction`, `createWebViewWith`) consume the accessor exactly once each — nil frame ⇒ `sourceFrame: null` on the channel, policy path completes | AC2, AC3 | example | DONE | `test/swift_sourceframe_kvc_test.dart` › AC3 |
| A4 | `flutter build macos --debug` (example app) compiles the changed Swift — before and after the fix | AC4 | example | DONE | build log (baseline exit 0 pre-fix; post-fix exit 0) |
| A5 | `zikzak_inappwebview_macos` `flutter test` shows no regression vs the 48-test baseline | AC5 | example | DONE | full suite 51/51 (48 + 3 new) |

## Out of scope

- iOS `Types/WKNavigationAction.swift:23` latent crash class (follow-up issue).
- Reproducing the nil frame on-device (macOS 15.1 WebKit quirk; environment boundary).

## Verification commands

```bash
cd zikzak_inappwebview_macos && flutter test
cd zikzak_inappwebview_macos && flutter analyze
cd zikzak_inappwebview/example && flutter build macos --debug
```
