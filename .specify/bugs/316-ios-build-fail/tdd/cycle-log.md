# TDD Cycle Log — Bug #316 (ios-build-fail)

Toolchain: Flutter 3.47.2 (stable) · Dart 3.13.2 · Swift 6.1 (swift-6.1-RELEASE,
Linux host, parse mode) · branch `fix/316-ios-build-fail` @ `0c51cce`

## Environment boundary (read this first)

- The end-to-end reproduction from issue #316 (`flutter build ios` against an app
  target with iOS 15.0 deployment target, then Xcode compiling the package) runs
  only on macOS + Xcode. This loop ran on a **Linux** host.
- What the Linux host CAN run, and what was used here:
  1. **swiftc -parse** on every Swift source (syntax parsing is the exact compiler
     stage that emits `#available may only be used as condition of an 'if',
     'guard' or 'while' statement`). UIKit/WebKit are NOT resolved — this is a
     parse-level gate, not a type-check or a full build.
  2. **Dart source-contract tests** (flutter_test) that encode both bug classes as
     executable checks (`test/swift_availability_usage_test.dart`,
     `test/ios_package_platform_test.dart`).
- macOS-side verification commands (NOT run here, for the reviewer with Xcode):
  ```bash
  # from an example app consuming this branch, iOS deployment target 15.0:
  flutter build ios --config-only      # error 1 must no longer appear
  flutter build ios                    # error 2 must no longer appear
  cd zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios && swift build
  ```

## Cycle 1 — B1: availability conditions must be direct if/guard/while conditions

**RED — compiler level** (`tdd/red-swiftparse.txt`):

```text
$ swiftc -parse Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift
InAppWebView/InAppWebView.swift:887:76: error: #available may only be used as
condition of an 'if', 'guard' or 'while' statement
 887 |  if !dataStoreWasSelected && (!hasValidPersistentId || !#available(iOS 17.0, *)) {
```

Full-tree parse (`scripts/swift_parse_check.sh red`): **139 files scanned,
1 parse error** — only `InAppWebView.swift:887`. All other sources parse clean.

**RED — Dart contract** (pre-fix source, fixes stashed):

```text
$ flutter test test/swift_availability_usage_test.dart test/ios_package_platform_test.dart
00:36 +0 -2: Some tests failed.
- swift_availability_usage_test: Actual: ['Sources/.../InAppWebView.swift:line 887:
  availability condition preceded by `!` and followed by `)`']
```

**Fix applied** — `InAppWebView.swift` lines ~881–902: boolean-folded availability
replaced by nested conditionals with identical truth table (see `fix.md`).

**GREEN — compiler level** (`tdd/green-swiftparse.txt`):

```text
$ swiftc -parse <each of 139 Swift files>
# RESULT: CLEAN
```

**GREEN — Dart contract** (full iOS package suite, post-fix):

```text
$ flutter test            # cwd zikzak_inappwebview_ios
00:39 +11: All tests passed!
```

## Cycle 2 — B2: SPM iOS platform minimum ≤ 15.0

**RED — Dart contract** (pre-fix source, fixes stashed):

```text
$ flutter test test/ios_package_platform_test.dart
00:36 +0 -2: Some tests failed.
- ios_package_platform_test: Expected: false / Actual: <true> /
  iOS platform minimum 16.0 exceeds 15.0 — apps targeting iOS 15.0 are rejected
  by FlutterGeneratedPluginSwiftPackage (bug #316)
```

(The SPM-side manifestation of the RED — "The package product
'zikzak-inappwebview-ios' requires minimum platform version 16.0 … but this
target supports 15.0" — is the issue #316 report itself; SPM platform resolution
does not run on Linux.)

**Fix applied** — `Package.swift`: `.iOS("16.0")` → `.iOS("15.0")` with a guard
audit comment.

**GREEN — Dart contract**: same suite run as Cycle 1:
`00:39 +11: All tests passed!`

## Suite baseline (post-fix)

| Suite (cwd per `.specify/memory/tdd-profile.md`) | Result |
| --- | --- |
| `zikzak_inappwebview_ios` `flutter test` | **11 passed / 0 failed** (9 pre-existing + 2 new contract tests) |
| `zikzak_inappwebview` `flutter test` | **245 passed / 2 failed** — both failures reproduce identically on pristine `master` (verified in a clean worktree): `domain_controllers_behavioral_test.dart` "U14 loadSimulatedRequest delegates to parent identically" and `proxy_tracing_controllers_test.dart` (load error). Pre-existing, NOT introduced by this fix. |
| `flutter analyze` `zikzak_inappwebview_ios` | 195 pre-existing info/warnings, **0 in changed/new files** |
| `flutter analyze` `zikzak_inappwebview` | 37 pre-existing info/warnings, **0 in changed/new files** |
| `swiftc -parse` full tree | **CLEAN, 139 files** |
| `git diff --check` | clean (no whitespace/formatting errors) |
