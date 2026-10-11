# Bug Fix: iOS build — valid availability conditions + platform floor 15.0

- **Slug**: 316-ios-build-fail
- **Fixed**: 2026-09-06
- **Assessment**: ./assessment.md
- **Status**: applied
- **TDD artifacts**: ./tdd/test-list.md, ./tdd/cycle-log.md, ./tdd/verification.md,
  ./tdd/red-swiftparse.txt, ./tdd/green-swiftparse.txt

## Summary

Fixed the two iOS build blockers of issue #316: the `#available(iOS 17.0, *)`
condition used as a boolean operand in `InAppWebView.swift` (a Swift grammar
violation) was restructured into nested conditionals with an identical truth
table, and the SwiftPM iOS platform minimum in `Package.swift` was lowered from
16.0 to 15.0 after an audit proved every iOS 15.4+/16/16.4/17+ API touchpoint in
the package is already availability-guarded. Two executable source-contract
regression tests were added so both bug classes fail fast without needing Xcode.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift` | modified | line 887: `if !dataStoreWasSelected && (!hasValidPersistentId \|\| !#available(iOS 17.0, *))` → nested `if !dataStoreWasSelected { if #available(iOS 17.0, *) { if !hasValidPersistentId { … } } else { … } }`; comment updated, references issue #316 |
| `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Package.swift` | modified | `platforms: [.iOS("16.0")]` → `.iOS("15.0")` with guard-audit comment |
| `zikzak_inappwebview_ios/test/swift_availability_usage_test.dart` | added test | scans all `Sources/**/*.swift` (comments/strings stripped, block-comment nesting and triple-quoted strings handled) and fails on any `#available`/`#unavailable` used as a boolean operand — predecessor must be `if`/`guard`/`while`/`,`/`(` and successor must be `,`/`{`/`else` |
| `zikzak_inappwebview_ios/test/ios_package_platform_test.dart` | added test | parses `Package.swift` and asserts the declared `.iOS("…")` minimum is ≤ 15.0 |
| `.specify/feature.json` | modified | pinned to `.specify/bugs/316-ios-build-fail` for the TDD loop (bug workflow step) |
| `.specify/bugs/316-ios-build-fail/**` | added | bug workflow records (issue/assessment/spec/fix + tdd artifacts) |

## Diff Highlights

Before (`InAppWebView.swift:887` — rejected by the Swift parser):

```swift
if !dataStoreWasSelected && (!hasValidPersistentId || !#available(iOS 17.0, *)) {
    configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
}
```

After — identical truth table, valid availability grammar:

```swift
if !dataStoreWasSelected {
    if #available(iOS 17.0, *) {
        if !hasValidPersistentId {
            configuration.websiteDataStore =
                WKWebsiteDataStore.nonPersistent()
        }
    } else {
        configuration.websiteDataStore =
            WKWebsiteDataStore.nonPersistent()
    }
}
```

Truth-table proof (AC2):

| `dataStoreWasSelected` | OS | `hasValidPersistentId` | before → sets nonPersistent? | after → sets nonPersistent? |
|---|---|---|---|---|
| true | any | any | no | no (outer `if` false) |
| false | ≥17 | true | no (`!valid`=false, `!available`=false) | no (inner `if` false) |
| false | ≥17 | false | yes | yes |
| false | <17 | either | yes (`!available`=true) | yes (`else` branch) |

Note the iOS ≥17 + valid-id case is additionally unreachable when
`dataStoreWasSelected == false`, because the iOS 9+ block above (lines 828–840)
selects the persistent store in exactly that case; both versions behave
identically regardless.

`Package.swift`:

```swift
platforms: [
    // iOS 15.0: matches the oldest app target we support. Every
    // iOS 15.4/16/16.4/17+ API used in the sources is already
    // availability-guarded …
    .iOS("15.0")
],
```

## Tests Added or Updated

- `zikzak_inappwebview_ios/test/swift_availability_usage_test.dart` — forbids the
  issue #316 grammar violation package-wide; RED pre-fix (flags line 887),
  GREEN post-fix.
- `zikzak_inappwebview_ios/test/ios_package_platform_test.dart` — pins the SPM iOS
  floor at ≤ 15.0; RED pre-fix (16.0 > 15.0), GREEN post-fix.

## Guard audit for the platform-floor change (AC4)

Every iOS 15/15.4/16/16.4/17+ API touchpoint in the package is availability-
guarded, so lowering the floor introduces no unguarded path:

- `InAppWebView.swift` KVO on `cameraCaptureState`/`microphoneCaptureState` —
  `if #available(iOS 15.0, *)` (lines ~514–524); context-menu fallback behind
  `#unavailable(iOS 16.0)`.
- `InAppWebView.swift` `isFindInteractionEnabled` — `#available(iOS 16.0, *)`;
  `isInspectable` — `#available(iOS 16.4, *)`; `isTextInteractionEnabled` —
  `#available(iOS 15.0, *)`; `isElementFullscreenEnabled`/`isSiteSpecificQuirksModeEnabled`
  — `#available(iOS 15.4, *)`; `shouldPrintBackgrounds` — `#available(iOS 16.4, *)`.
- `InAppWebViewSettings.swift` realSettings getters — same guards at lines
  ~290–315 (15.0/15.4/15.5/16.0/16.4).
- `WebViewChannelDelegate.swift` capture-state cases — `if let webView = webView,
  #available(iOS 15.0, *)`.
- `WKWebsiteDataStore(forIdentifier:)` (iOS 17+) — guarded at InAppWebView.swift
  lines 832–836 and the restructured 887 block.

## Local Verification

- **RED (pre-fix, real compiler + real tests)**: `swiftc -parse` on
  `InAppWebView.swift` → `887:76: error: #available may only be used as condition
  of an 'if', 'guard' or 'while' statement` (exact issue #316 diagnostic; Swift
  6.1). Full tree: 1 error across 139 files. Dart contract tests against stashed
  fixes: `+0 -2` (both new tests fail for exactly the expected reasons — see
  `tdd/cycle-log.md`).
- **GREEN (post-fix)**: `swiftc -parse` full tree → CLEAN (139/139). 
  `flutter test` in `zikzak_inappwebview_ios` → **11/11 passed** (includes the 2
  new contract tests). `flutter test` in `zikzak_inappwebview` → **245 passed /
  2 failed**, both failures reproduce identically on pristine `master` (verified
  in a clean git worktree) — pre-existing, unrelated to this fix.
- `flutter analyze` — 195 (ios package) and 37 (umbrella) pre-existing
  info/warnings; **0 in any changed or new file**.
- `git diff --check` — clean.
- **NOT runnable here (Linux, no Xcode/Apple SDK)**: the full Swift type-check
  (`swift build`), `flutter build ios` against an iOS 15.0 app target, and
  runtime verification of data-store selection on device. See the Environment
  Boundary in `spec.md` and `tdd/verification.md`.

## Deviations from Assessment

None. R1, R2 and R3 were implemented as proposed; the nested-conditional shape is
exactly the one from the assessment's remediation.
