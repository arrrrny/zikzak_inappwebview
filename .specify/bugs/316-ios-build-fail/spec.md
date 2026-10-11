# Bug Spec: iOS build — valid availability conditions + platform minimum aligned with app targets (Bug #316)

## Problem

`zikzak_inappwebview_ios` 5.3.3 cannot be consumed by iOS apps:

1. `Package.swift` declares `.iOS("16.0")`, so `FlutterGeneratedPluginSwiftPackage`
   rejects any app target whose deployment target is 15.0.
2. `InAppWebView.swift:887` uses `!#available(iOS 17.0, *)` inside a boolean
   expression, which the Swift compiler rejects outright
   (`#available may only be used as condition of an 'if', 'guard' or 'while'
   statement`).

The result is that the plugin does not build on iOS 15.0 app targets, and fails
compilation even where the platform check is bypassed.

## Acceptance Criteria

1. **AC1 — Valid availability grammar.** Every `#available(iOS …, *)` /
   `#unavailable(iOS …, *)` occurrence in the iOS package's Swift sources appears
   as the direct condition of an `if`, `guard`, or `while` statement (or a
   `#if`-free attribute), never as an operand of `!`, `&&`, `||` or any other
   boolean operator. Specifically, the former line 887 pattern
   `!dataStoreWasSelected && (!hasValidPersistentId || !#available(iOS 17.0, *))`
   is restructured into nested `if` statements.
2. **AC2 — Preserved data-store semantics.** The restructured code keeps the exact
   truth table of the original intent: when a data store was already selected
   (incognito / iOS 17+ persistent store / cacheEnabled default) it is never
   overridden; when none was selected on iOS 17+ it is forced `nonPersistent()`
   only when `hasValidPersistentId` is false; when none was selected below iOS 17
   it is always forced `nonPersistent()`.
3. **AC3 — Platform minimum ≤ 15.0.** `Package.swift` declares an iOS platform
   minimum of at most 15.0 (i.e. `.iOS("15.0")`), so app targets on iOS 15.0 and
   16.0+ are both accepted by `FlutterGeneratedPluginSwiftPackage`.
4. **AC4 — No unguarded modern API.** With the minimum lowered to 15.0, no Swift
   source in the package uses an API annotated iOS 15.4+/16+ without an enclosing
   availability guard (audit evidence recorded in the fix report).
5. **AC5 — No regression.** `flutter analyze` and `flutter test` pass in
   `zikzak_inappwebview_ios` and in the umbrella package `zikzak_inappwebview`
   with no new failures, and `git diff --stat` shows zero remaining formatting
   diffs.

## Environment Boundary (recorded, not hidden)

The Xcode/Swift-compiler reproduction (SPM platform resolution error and the
`swiftc` syntax error at InAppWebView.swift:887) requires macOS + Xcode. This fix
was produced in a Linux CI environment where neither Xcode nor the Apple SDK is
available. AC1/AC3/AC4 are verified by real, executable Dart regression tests that
statically encode the two bug classes (availability-in-boolean-expression source
scan; Package.swift platform minimum bound), plus the full availability-guard audit
of the package sources. The macOS-level red/green run of the actual Swift
compilation is NOT PROVED here; the exact reproduction and verification commands
for a macOS host are recorded in `tdd/cycle-log.md` and `tdd/verification.md`.
AC2 is verified by construction (truth-table-equivalent restructure, documented in
the fix report) and by the AC1 test asserting the restructured shape.
