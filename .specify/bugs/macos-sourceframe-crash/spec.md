# Bug Spec: macOS — sourceFrame accessed safely in navigation callbacks (Bug #327)

## Problem

On macOS 15.1 the host app crashes with EXC_BREAKPOINT (SIGTRAP 5) on the main
thread inside `decidePolicyForNavigationAction`
(`URLRequest._unconditionallyBridgeFromObjectiveC`). WebKit can deliver a
navigation action whose `sourceFrame` — or its `request` / `securityOrigin` — is
nil at runtime, while the Swift overlay declares these members non-optional.
Member access therefore performs an *unconditional* ObjC bridge that traps on
nil. The plugin reads `navigationAction.sourceFrame` unconditionally at two
sites in the macOS package:

1. `InAppWebView.swift` — `decidePolicyFor navigationAction` (the reported
   crash; feeds `shouldOverrideUrlLoading`).
2. `InAppWebView.swift` — `createWebViewWith:…` (`onCreateWindow` action).

The repo already carries the safe pattern for this exact trap class:
`Types/WKFrameInfo.swift` reads `request` via `value(forKey: "request")`
because direct access throws EXC_BREAKPOINT for frames coming from
`WKNavigationAction.sourceFrame`.

## Acceptance Criteria

1. **AC1 — No unconditional sourceFrame member access.** After comment/string
   stripping, no macOS-package Swift source contains a dot-member access of
   `sourceFrame` (the sequence `.sourceFrame`). All reads go through a
   KVC-based accessor that yields `nil` for a nil runtime frame.
2. **AC2 — Nil frame degrades, never traps.** When the runtime frame is nil,
   `shouldOverrideUrlLoading` and the `onCreateWindow` action are still
   delivered with `sourceFrame: nil` (the Dart `NavigationAction` /
   `CreateWindowAction` models declare `sourceFrame` as `FrameInfo?` and map
   null to null), and the policy decision path completes normally.
3. **AC3 — Preserved wire shape.** When the runtime frame is present, the
   emitted `sourceFrame` map is identical in keys and value types to today's:
   `isMainFrame` (Bool), `request.url` (String, `""` when unresolved),
   `securityOrigin.host/port/protocol` (String/Int/String).
4. **AC4 — Compiles.** The macOS Swift package compiles:
   `flutter build macos --debug` succeeds in the example app (macOS Swift is
   not compiled by any CI job, so this is the compile gate).
5. **AC5 — No regression.** `flutter test` and `flutter analyze` in
   `zikzak_inappwebview_macos` show no new failures.

## Environment Boundary (recorded, not hidden)

Producing a real nil `sourceFrame` requires a macOS 15.1 WebKit runtime quirk
that cannot be reproduced deterministically in CI. AC1/AC2/AC3 are verified by
an executable Dart source-contract regression test (the #316/#328 precedent)
plus the compile proof of AC4; the crash itself can only be exercised on the
reporter's OS build.

## Out of scope

- The identical latent pattern in `zikzak_inappwebview_ios/.../Types/WKNavigationAction.swift:23`
  (iOS crash class, not reported) — follow-up issue.
