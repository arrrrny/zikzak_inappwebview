# Bug Assessment: iOS cancels private custom schemes before the host navigation delegate

- **Slug**: ios-custom-scheme-navigation
- **Created**: 2026-09-15
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/pull/334 (no GitHub issue filed)
- **Verdict**: valid (reproduced on the iOS Simulator; root cause located in the native pre-navigation gate)
- **Severity**: high (any private-scheme deep link is unusable on iOS; no Dart-layer workaround)

## Report (verbatim or summarized)

A page that navigates to `weixin://wap/pay?token=test` never reaches the host's
`shouldOverrideUrlLoading` callback on iOS: the native `WKUIDelegate` cancels the
navigation first, so the host cannot open the deep link externally.

## Symptom

`useShouldOverrideUrlLoading: true` plus a `shouldOverrideUrlLoading` handler
receives nothing for custom schemes. The WebView stays on the current page, with
no error surfaced to Dart. Payment and authentication deep links are dead on
iOS, while the same code works on Android, where custom schemes reach the
callback.

## Reproduction

`zikzak_inappwebview/example/integration_test/ios_custom_scheme_navigation_test.dart`
on an iOS Simulator:

1. `InAppWebView` with `useShouldOverrideUrlLoading: true` and a handler that
   cancels `weixin://`.
2. `loadData` a page, then `window.location.href = 'weixin://wap/pay?token=test'`.
3. Before the fix the handler is never called; after it, the handler is called
   with the deep link.

## Suspected Code Paths

- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift`
  — `webView(_:decidePolicyFor:decisionHandler:)` runs a pre-delegate gate before
  `ShouldOverrideUrlLoadingCallback` is dispatched (run at PR #334 head:
  lines 2465-2488).
- `zikzak_inappwebview_ios/.../Security/URLValidationManager.swift` — the
  pre-delegate gate. At the PR base it was `validateURL`, whose final branch
  rejects every scheme absent from `safeSchemes` (`http`, `https`, `file`,
  `data`, `about`, `blob`).
- `WebViewChannelDelegate.ShouldOverrideUrlLoadingCallback` /
  `BaseCallbackResult` — where an absent or `null` host reply maps to
  `.cancel`, i.e. the fail-closed default.

## Root Cause Hypothesis

One question was doing two jobs. "Is this URL safe to load?" (answered by
`validateURL`, correctly conservative: unknown scheme ⇒ reject) was also being
used as the pre-delegate gate, whose real question is "must this be rejected
regardless of host policy?". Because a private scheme is by definition unknown
to the safe-scheme list, the gate answered *yes* and the host never got to see
the URL.

The fix splits the two: the gate now blocks only what is dangerous on its own
(custom validator rejection, blocked schemes, failing scheme-specific checks,
schemeless URLs) and lets unknown custom schemes through to the host delegate,
while the delegate's fallback keeps the conservative answer so a navigation no
host policy handles is still cancelled. The only behaviour change is an explicit
host `ALLOW` for an unknown scheme.

## Proposed Remediation

Applied on `fix/ios-custom-scheme-navigation` (PR #334):

1. `URLValidationManager` gained `decisionBeforeHostDelegate(_:)`, returning
   `PreDelegateDecision.block` / `.deferToHost` / `.allow`. The blocked/safe/
   scheme-specific policy moved into a private `validateScheme(_:scheme:)` that
   both `validateURL` and the gate call, so the policy exists once and the gate's
   only distinct decision (unknown scheme ⇒ defer to the host) is explicit.
2. `InAppWebView.swift` classifies once per navigation and reuses that
   classification as the delegate fallback's default answer, so a host-installed
   `customValidator` runs once per navigation instead of twice.
3. The integration test now reports itself as skipped off iOS rather than as a
   passing no-op, and covers both halves of the change: an unhandled custom
   scheme is still cancelled, and a host `ALLOW` is honoured.
4. `CHANGELOG.md` records the user-visible iOS behaviour change; this directory
   now carries the bug record.

## Files likely to change

- `zikzak_inappwebview_ios/.../Security/URLValidationManager.swift`
- `zikzak_inappwebview_ios/.../InAppWebView/InAppWebView.swift`
- `zikzak_inappwebview/example/integration_test/ios_custom_scheme_navigation_test.dart`
- `CHANGELOG.md`
- `.specify/bugs/ios-custom-scheme-navigation/` (this record)

## Tests to add or update

- iOS Simulator integration tests: default-cancel for an unhandled custom scheme,
  and host `ALLOW` honoured (both in
  `ios_custom_scheme_navigation_test.dart`, gated with `skip: !Platform.isIOS`).
- A Swift XCTest matrix for `URLValidationManager` (blocked scheme, `file:` with
  traversal, unknown scheme, schemeless URL, rejecting custom validator) is the
  natural home for unit-level coverage, but the example's `RunnerTests` target
  cannot host it today: the iOS project resolves the plugin as a local Swift
  package (`FlutterGeneratedPluginSwiftPackage`) and the target has no package
  product dependency, so `import zikzak_inappwebview_ios` does not resolve, and
  no CI job builds or runs that target. Revisit once the target links the plugin.

## Risks & Considerations

- Security-adjacent native code: the change must not widen what reaches WebKit.
  Everything the previous gate blocked (custom validator rejection, blocked
  schemes, `file:` traversal, `data:` payloads, schemeless URLs) is still blocked
  before the delegate, and an unhandled custom scheme is still cancelled by the
  fallback — the integration tests assert both.
- A host that returns `ALLOW` for an unknown scheme now gets what it asked for.
  That is the intended behaviour change, and the test pins it.
- `zikzak_inappwebview_ios` has no Swift unit-test target in CI, so the native
  policy is covered end-to-end on a simulator only.
