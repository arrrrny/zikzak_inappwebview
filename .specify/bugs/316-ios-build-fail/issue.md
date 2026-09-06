# Bug Issue: iOS build fails — SPM min platform 16.0 vs app target 15.0 + invalid `#available` usage in InAppWebView.swift

- **Slug**: 316-ios-build-fail
- **Fetched**: 2026-09-06T00:00:00Z
- **Issue**: 316
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/316
- **State**: open
- **Severity**: critical
- **Author**: (see GitHub issue)
- **Labels**: none

## Body

Xcode Error:

> FlutterGeneratedPluginSwiftPackage with configuration Release error: The package
> product 'zikzak-inappwebview-ios' requires minimum platform version 16.0 for the
> iOS platform, but this target supports 15.0 (in target
> 'FlutterGeneratedPluginSwiftPackage' from project
> 'FlutterGeneratedPluginSwiftPackage') The package product
> 'zikzak-inappwebview-ios' requires minimum platform version 16.0 for the iOS
> platform, but this target supports 15.0

After fixing the error above by executing `flutter build ios --config-only`, a new
error arises:

> /Users/yazan/.pub-cache/hosted/pub.dev/zikzak_inappwebview_ios-5.3.3/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift:887:76
> #available may only be used as condition of an 'if', 'guard' or 'while' statement
>
> ```swift
> if !dataStoreWasSelected && (!hasValidPersistentId || !#available(iOS 17.0, *)) {
> ```

How to reproduce: use the latest package (5.3.3), and run the project on an iOS
device or simulator.

## Comments

None.
