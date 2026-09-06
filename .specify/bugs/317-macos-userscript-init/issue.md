# Bug Issue: macOS UserScript initializer 'init(source:injectionTime:forMainFrameOnly:in:)' not implemented — crash with initialUserScripts

- **Slug**: 317-macos-userscript-init
- **Fetched**: 2026-09-06T00:00:00Z
- **Issue**: 317
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/317
- **State**: open
- **Severity**: critical
- **Author**: (see GitHub issue)
- **Labels**: none

## Body

### Description

When using `initialUserScripts` parameter in `InAppWebView` on macOS, the app
crashes on startup. The crash occurs during deserialization of the user scripts
from the platform channel: the macOS `UserScript` type does not implement the
`init(source:injectionTime:forMainFrameOnly:in:)` initializer.

### Steps to Reproduce

1. Create an `InAppWebView` widget with `initialUserScripts` parameter
2. Pass a list of `UserScript` objects
3. Launch the app on macOS
4. App crashes on startup

### Expected Behavior

The `UserScript` initializer
`init(source:injectionTime:forMainFrameOnly:in:)` should be implemented on
macOS, or the `initialUserScripts` parameter should work correctly.

### Actual Behavior

App crashes because the initializer is not implemented. Scripts passed via
`initialUserScripts` never inject before the first page load.

### Environment

- Flutter: 3.47.1
- Dart: 3.13.1
- zikzak_inappwebview: 5.3.3
- macOS: 15.7.9

### Workaround

Use `addUserScript` in `onLoadStop` callback instead of the `initialUserScripts`
parameter. However, this doesn't inject the script before the first page load.

## Root cause (verified in tree at 0c51cce8)

`zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/Types/UserScript.swift`
declares three initializers:

1. `public override init(source:injectionTime:forMainFrameOnly:)`
2. `public init(groupName:source:injectionTime:forMainFrameOnly:)`
3. `public init(groupName:source:injectionTime:forMainFrameOnly:in:)`

The iOS twin
(`zikzak_inappwebview_ios/ios/.../Types/UserScript.swift`) declares a fourth:

4. `public override init(source:injectionTime:forMainFrameOnly:in: contentWorld:)`

Because the macOS `UserScript` subclass declares its own designated
initializers, Swift does not inherit `WKUserScript`'s
`init(source:injectionTime:forMainFrameOnly:in:)` that was not overridden. The
initializer named in the issue title is therefore not implemented on macOS, and
construction of that shape fails (compile-time for Swift consumers; runtime
failure surfaces when platform-channel deserialized scripts take a path that
expects full `WKUserScript` API parity). iOS/Android/Web/Windows/Linux are
unaffected — the gap is macOS-only.
