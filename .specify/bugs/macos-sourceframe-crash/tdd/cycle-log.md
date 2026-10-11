# TDD Cycle Log — macos-sourceframe-crash (bug #327)

## Baseline

- **Commit**: `76528631` (branch `fix/macos-sourceframe-crash`)
- **Date**: 2026-09-25
- **Suite**: `cd zikzak_inappwebview_macos && flutter test` → **48/48 pass** (green baseline)
- **Compile**: `cd zikzak_inappwebview/example && flutter build macos --debug` → exit 0 (pre-fix baseline build)

## Cycle 1 — A1/A2/A3: sourceFrame reads go through a KVC accessor

- **Test file**: `zikzak_inappwebview_macos/test/swift_sourceframe_kvc_test.dart`
- **Tests**: `sourceFrame KVC contract (bug #327) › AC1 / AC2 / AC3`

### RED

Command:

```
cd zikzak_inappwebview_macos && flutter test test/swift_sourceframe_kvc_test.dart
```

Output (all three fail for the right reasons — the defect is present):

```
00:05 +0 -3: Some tests failed.
Failing tests:
  …/swift_sourceframe_kvc_test.dart: sourceFrame KVC contract (bug #327) AC1: …
  …/swift_sourceframe_kvc_test.dart: sourceFrame KVC contract (bug #327) AC2: …
  …/swift_sourceframe_kvc_test.dart: sourceFrame KVC contract (bug #327) AC3: …
```

AC1 decisive excerpt (violations found by the scan):

```
Actual: [
  'Sources/zikzak_inappwebview_macos/InAppWebView.swift:2528',
  'Sources/zikzak_inappwebview_macos/InAppWebView.swift:2530',
  'Sources/zikzak_inappwebview_macos/InAppWebView.swift:2533',
  …
```

AC2: `Expected: <1> / Actual: <0> / exactly one sourceFrameMap accessor definition expected`
AC3: `Expected: <2> / Actual: <0>` (no call sites)

(Line numbers differ from the raw file because comment stripping rewrites the
source; they are the `decidePolicyFor` and `createWebViewWith` access chains.)

### GREEN

Implementation (smallest sufficient change):

- new `Sources/zikzak_inappwebview_macos/Types/WKNavigationAction.swift` —
  `WKNavigationAction.sourceFrameMap()` reading `sourceFrame` / `request` /
  `securityOrigin` via `value(forKey:)` with nil fallbacks;
- `InAppWebView.swift` `decidePolicyFor navigationAction` — removed the
  unconditional access chain, map now carries
  `"sourceFrame": navigationAction.sourceFrameMap()`;
- `InAppWebView.swift` `createWebViewWith` — replaced the unconditional IIFE
  with `let sourceFrame = navigationAction.sourceFrameMap()`.

Commands:

```
cd zikzak_inappwebview_macos && flutter test
00:07 +51: All tests passed!
```

(48 baseline + 3 new; no existing test weakened.)

### Refactor

None needed — the accessor is the single home for the safe pattern; call sites
shrank. Recorded as "no refactor needed".

### Notes

- Behavior change confined to the crash corner: with a present runtime frame
  the emitted map keys/value types are identical to pre-fix (AC3 of spec).
- Compile proof (AC4) captured separately: post-fix example macOS build exit 0.
