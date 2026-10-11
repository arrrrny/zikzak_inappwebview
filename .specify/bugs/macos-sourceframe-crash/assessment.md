# Bug Assessment: [macOS] EXC_BREAKPOINT crash in decidePolicyForNavigationAction via sourceFrame (#327)

- **Slug**: macos-sourceframe-crash
- **Created**: 2026-09-25
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/327
- **Verdict**: valid — needs fix
- **Severity**: high (hard crash of the host app, main thread)

## Report (summarized)

On macOS 15.1 the host app crashes (EXC_BREAKPOINT / SIGTRAP 5, main thread) inside
`decidePolicyForNavigationAction` when WebKit hands a navigation whose
`sourceFrame` (or its `request`) is nil at runtime. The Swift overlay declares
`WKNavigationAction.sourceFrame` / `WKFrameInfo.request` / `.securityOrigin`
non-optional, so member access performs an *unconditional* ObjC bridge that traps
on nil (`URLRequest._unconditionallyBridgeFromObjectiveC`). Newer macOS builds
behave; 15.1 does not. Reporter is on plugin 4.7.0; the same code is present on
master.

## Symptom

Hard crash of any macOS app embedding the plugin when a navigation action with a
nil runtime `sourceFrame` reaches `shouldOverrideUrlLoading` handling.

## Reproduction

1. Run an app using `InAppWebView` with `useShouldOverrideUrlLoading: true` on
   macOS 15.1.
2. Trigger a navigation for which WebKit delivers a nil `sourceFrame` (window/opener
   -driven navigations per the crash log).
3. → EXC_BREAKPOINT in `URLRequest._unconditionallyBridgeFromObjectiveC`.

(Automated equivalent is a source-contract test — see spec; a real nil-frame
cannot be produced deterministically in CI.)

## Suspected Code Paths (verified on master 76528631)

- `zikzak_inappwebview_macos/.../InAppWebView.swift:2678-2688` —
  `decidePolicyFor navigationAction`: unconditional `navigationAction.sourceFrame`
  member access chain (6 dot accesses). **The reported crash site.**
- `zikzak_inappwebview_macos/.../InAppWebView.swift:2849-2860` —
  `createWebViewWith` (`onCreateWindow` action): an IIFE with the same
  unconditional `navigationAction.sourceFrame` access — identical trap risk.
- Existing safe precedent in-repo: `zikzak_inappwebview_macos/.../Types/WKFrameInfo.swift`
  reads `request` via KVC (`value(forKey: "request") as? URLRequest`) precisely
  because direct access throws EXC_BREAKPOINT for frames coming from
  `WKNavigationAction.sourceFrame`. The two crash sites do not use this pattern.

Dart contract: `NavigationAction.sourceFrame` and `CreateWindowAction.sourceFrame`
are both `FrameInfo?` with `_sourceFrameFromJson(null) → null` — so delivering
`nil` for a nil runtime frame is contract-safe and mirrors `targetFrame`, which is
already optional on the native side.

Out of scope (recorded, not fixed): `zikzak_inappwebview_ios/.../Types/WKNavigationAction.swift:23`
accesses `sourceFrame.toMap()` unconditionally — the same latent crash class on
iOS. Not reported there; left for a follow-up issue.

## Root Cause Hypothesis

SDK nullability mismatch: WebKit's ObjC implementation can supply nil for
`sourceFrame` on macOS 15.1 while the Swift overlay claims non-optional; the
unconditional bridge traps. Not a logic bug in the plugin — an unsafe access
pattern.

## Proposed Remediation

Add a KVC-based safe accessor for the navigation action's source frame
(`extension WKNavigationAction { func sourceFrameMap() -> [String: Any?]? }`) in
the macOS package, reading `sourceFrame`, `request`, and `securityOrigin` through
`value(forKey:)` with nil-fallbacks, and use it at both sites. When the runtime
frame is nil, send `sourceFrame: nil` to Dart (contract-safe) instead of
trapping; when present, emit exactly the same map shape/values as today.

## Tests to add or update

- New: `zikzak_inappwebview_macos/test/swift_sourceframe_kvc_test.dart` —
  source-contract regression test (the #316/#328 precedent): after stripping
  comments/strings from all macOS Swift sources, no `.sourceFrame` dot-member
  access may remain; the KVC helper must exist; both former crash sites must go
  through it.
- Compile proof: `flutter build macos --debug` in the example app before and
  after (macOS Swift is not compiled by any CI Dart job).

## Risks & Considerations

- KVC reads depend on WebKit exposing `sourceFrame`/`request`/`securityOrigin`
  as KVC-compliant properties — the same dependency the existing, shipped
  `WKFrameInfo.toMap()` already relies on (both Apple packages), so no new risk
  class is introduced.
- Behavior change is confined to the crash corner: healthy macOS versions see
  byte-identical maps.
- macOS Swift compile is NOT covered by CI (only `build-ios` is) — the example
  macos build is the compile gate for this change.

## Open Questions

None.
