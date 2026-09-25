# Bug Fix: [macOS] EXC_BREAKPOINT crash accessing a nil sourceFrame in navigation callbacks (#327)

- **Slug**: macos-sourceframe-crash
- **Fixed**: 2026-09-25
- **Assessment**: ./assessment.md
- **Status**: applied
- **Branch**: `fix/macos-sourceframe-crash`
- **TDD artifacts**: ./tdd/test-list.md, ./tdd/cycle-log.md, ./tdd/verification.md

## Summary

`WKNavigationAction.sourceFrame` (and its `request`/`securityOrigin`) are declared
non-optional by the Swift overlay, but WebKit on macOS 15.x can deliver a nil
runtime object; member access then traps in the unconditional ObjC bridge
(EXC_BREAKPOINT, issue #327). The macOS package now reads the source frame only
through a new KVC-based accessor (`sourceFrameMap()`) that yields nil instead of
trapping, and both former crash sites — `decidePolicyForNavigationAction` and
`createWebViewWith` — deliver `sourceFrame: null` to Dart in that corner. With a
present runtime frame the emitted map is unchanged.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/Types/WKNavigationAction.swift` | added | `WKNavigationAction.sourceFrameMap()` — reads `sourceFrame`, `request`, `securityOrigin` via `value(forKey:)` (the pattern already shipped in `WKFrameInfo.toMap()`); returns nil when the runtime frame is nil |
| `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/InAppWebView.swift` | modified | `decidePolicyFor navigationAction`: removed the 6-member unconditional access chain; `"sourceFrame": navigationAction.sourceFrameMap()` |
| `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/InAppWebView.swift` | modified | `createWebViewWith`: replaced the unconditional IIFE with `sourceFrameMap()` |
| `zikzak_inappwebview_macos/test/swift_sourceframe_kvc_test.dart` | added test | source-contract regression (AC1–AC3): no `.sourceFrame` dot access in macOS sources; KVC accessor exists; both call sites consume it |

## Diff Highlights

Before (`decidePolicyFor navigationAction` — traps on nil runtime frame):

```swift
let sourceFrame: [String: Any] = [
    "isMainFrame": navigationAction.sourceFrame.isMainFrame,
    "request": ["url": navigationAction.sourceFrame.request.url?.absoluteString ?? ""],
    ...
]
```

After:

```swift
// KVC-backed read (issue #327): nil when WebKit hands a nil runtime frame.
"sourceFrame": navigationAction.sourceFrameMap(),
```

Accessor (new file):

```swift
public func sourceFrameMap() -> [String: Any?]? {
    guard let frame = value(forKey: "sourceFrame") as? WKFrameInfo else { return nil }
    let request: URLRequest? = frame.value(forKey: "request") as? URLRequest
    let origin = frame.value(forKey: "securityOrigin") as? WKSecurityOrigin
    return [ /* same shape as pre-fix maps; "" / 0 fallbacks */ ]
}
```

## Tests Added or Updated

- `zikzak_inappwebview_macos/test/swift_sourceframe_kvc_test.dart` ›
  `AC1: no dot-member access of a navigation action source frame in macOS Swift sources` —
  pins the crash class: the unsafe access pattern cannot return
- … › `AC2: a KVC-based sourceFrameMap accessor exists …` — pins the safe mechanism
- … › `AC3: both navigation callbacks consume the accessor` — pins both former crash sites

## Local Verification

- `cd zikzak_inappwebview_macos && flutter test` → **51/51 pass** (48 baseline + 3 new); RED first proven: 3/3 new tests failed pre-fix with the violation list
- `cd zikzak_inappwebview_macos && flutter analyze` → No issues found
- `cd zikzak_inappwebview/example && flutter build macos --debug` → exit 0 **before** the fix and **after** (macOS Swift is compiled by no CI job, so this is the compile gate — AC4)
- Real nil-frame crash repro: not runnable in CI (macOS 15.1 WebKit quirk; spec environment boundary)

## Deviations from Assessment

- The reporter suggested a `value(forKey: "sourceFrame")` guard at the decidePolicy
  site only; the same unconditional access existed in `createWebViewWith`
  (`onCreateWindow`) and is fixed there too (same crash class, same file, logged
  in the assessment's Suspected Code Paths).
- `securityOrigin` is also read via KVC with `""`/`0` fallbacks (defensive; the
  reporter's sketch read it directly on the unwrapped frame).

## Follow-ups

- `zikzak_inappwebview_ios/.../Types/WKNavigationAction.swift:23` reads
  `sourceFrame.toMap()` unconditionally — same latent crash class on iOS; file a
  follow-up issue.
- Consider a macOS Swift compile job in CI (the `build-ios` job only covers iOS).
