# Bug Assessment: iOS build fails — SPM min platform mismatch + invalid `#available` boolean usage

- **Slug**: 316-ios-build-fail
- **Created**: 2026-09-06
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/316
- **Verdict**: valid (both errors reproduced at source level; root causes located and directly fixable in this repo)
- **Severity**: critical (package 5.3.3 cannot be consumed at all on iOS 15.0 app targets; second error breaks any build once the first is worked around)

## Report (verbatim or summarized)

Building any Flutter app that consumes `zikzak_inappwebview` 5.3.3 on iOS fails in
two stages:

1. `FlutterGeneratedPluginSwiftPackage` errors: the package product
   `zikzak-inappwebview-ios` requires minimum iOS platform version 16.0 while the
   app target supports 15.0.
2. After bumping/aligning the deployment target via `flutter build ios
   --config-only`, the Swift compiler rejects the package source:
   `InAppWebView.swift:887:76 #available may only be used as condition of an 'if',
   'guard' or 'while' statement` for the line
   `if !dataStoreWasSelected && (!hasValidPersistentId || !#available(iOS 17.0, *)) {`.

## Symptom

The iOS implementation package cannot compile or be resolved by SPM when the host
app targets iOS 15.0, and its Swift source is not even syntactically acceptable to
the Swift compiler in the current form — the plugin is unusable on iOS 15.0 app
targets and fails to build outright after the version workaround.

## Reproduction

Use package version 5.3.3 in a Flutter app whose iOS deployment target is 15.0 and
run on an iOS device or simulator. Error 1 appears during SPM resolution; error 2
appears at Swift compile time once the platform check is bypassed. Cannot be
reproduced end-to-end on Linux (Xcode/WebKit required); both root causes are,
however, fully visible in the source tree.

## Suspected Code Paths

- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Package.swift` line 7 —
  `platforms: [.iOS("16.0")]` is what `FlutterGeneratedPluginSwiftPackage` enforces
  against the app target. This package is SPM-only (no `.podspec` exists anywhere
  under `zikzak_inappwebview_ios/`), so this single declaration is the sole source
  of the reported platform mismatch.
- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift`
  line 887 — `!#available(iOS 17.0, *)` appears inside a boolean expression. The
  Swift grammar only admits an availability condition as the direct condition of an
  `if`/`guard`/`while` statement, so this line is a compile error regardless of
  deployment target.

## Root Cause Hypothesis

**Error 1 (platform mismatch).** `Package.swift` declares `.iOS("16.0")`, but the
package's Swift sources never require iOS 16 unguarded: every iOS 15/15.4/16/16.4
API touchpoint (`cameraCaptureState`/`microphoneCaptureState` KVO, `isTextInteractionEnabled`,
`isElementFullscreenEnabled`, `isFindInteractionEnabled`, `isInspectable`,
`upgradeKnownHostsToHTTPS`, `minimumViewportInset`/`maximumViewportInset`) is
already wrapped in `#available`/`#unavailable` guards in
`InAppWebView.swift`, `InAppWebViewSettings.swift` and
`WebViewChannelDelegate.swift`. The declared minimum is therefore stricter than the
code requires, and 16.0 excludes app targets that the code would otherwise support.
The `persistentStoreIdentifier` feature (the reason an iOS 17 check exists at all)
is itself availability-guarded at every use (lines 832–836, 878–889).

**Error 2 (invalid availability condition).** Commit-level intent (comment block
above line 887): when `sharedCookiesEnabled` is on and no data store was already
selected in the iOS 9+ block above (incognito / iOS 17+ persistent store /
cacheEnabled default store), the store must be forced to `nonPersistent()` when
there is no valid persistent id OR when the OS is older than iOS 17 (where
`WKWebsiteDataStore(forIdentifier:)` is unavailable and per-account isolation
cannot be honored). The author folded both predicates into one boolean expression
with `!#available(iOS 17.0, *)`, which Swift rejects: availability is not a
plain Boolean value.

## Proposed Remediation

**R1 — Fix the availability usage (mandatory).** Restructure line 887 into nested
`if` statements that preserve the exact truth table of
`!dataStoreWasSelected && (!hasValidPersistentId || iOS < 17)`:

```swift
if !dataStoreWasSelected {
    if #available(iOS 17.0, *) {
        if !hasValidPersistentId {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        }
    } else {
        // Below iOS 17 a persistent store with identifier cannot be honored.
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
    }
}
```

This is semantics-identical in every case: selected → skip; not selected on iOS 17+
→ force non-persistent only when the id is invalid; not selected below iOS 17 →
always force non-persistent. `#unavailable` is NOT an acceptable alternative inside
a boolean expression — it obeys the same grammar restriction.

**R2 — Fix the platform mismatch (mandatory).** Change `Package.swift` line 7 from
`.iOS("16.0")` to `.iOS("15.0")` so `FlutterGeneratedPluginSwiftPackage` accepts app
targets on iOS 15.0 (and 16.0+). This is safe per the audit above: no unguarded
iOS 15.4+/16+ API usage exists in the package sources. Expected outcome: the
package resolves and compiles cleanly for app targets on both iOS 15.0+ and 16.0+.

**R3 — Regression guards.** Add Dart-side unit tests in
`zikzak_inappwebview_ios/test/` that (a) scan the package's Swift sources for
availability conditions used outside `if`/`guard`/`while` (the exact bug class of
error 2), and (b) assert the SPM platform minimum in `Package.swift` is ≤ 15.0 so
iOS 15.0 app targets stay supported (the exact bug class of error 1). These tests
are executable in a Linux CI environment, unlike an Xcode build.

## Files likely to change

- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Package.swift` (R2)
- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift` (R1)
- `zikzak_inappwebview_ios/test/` — new regression test file (R3)

## Tests to add or update

- New: `zikzak_inappwebview_ios/test/swift_availability_usage_test.dart` — source
  scan forbidding `#available`/`#unavailable` inside boolean expressions (RED
  against current source: line 887 violates it).
- New: `zikzak_inappwebview_ios/test/ios_package_platform_test.dart` — parses
  `Package.swift` and asserts the declared iOS minimum ≤ 15.0 (RED against current
  source: 16.0 violates it).

## Risks & Considerations

- Lowering the SPM minimum to 15.0 makes previously unavailable (iOS 15.0–15.5)
  devices compile against code paths they could not previously reach at all; every
  such path is already availability-guarded, so runtime behavior on those OS
  versions falls back exactly as it does today on 16.0+ devices.
- The restructured 887 block must not silently change data-store selection
  semantics; the truth table above is the contract, and the fix keeps each case
  bit-for-bit identical.
- An Xcode/Swift compile of this package cannot be executed in the Linux
  environment where this fix is produced; the fix report and verification must say
  so explicitly (see Environment Boundary in `spec.md`).
