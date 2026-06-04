## 4.3.2 - 2026-06-04

* fix: use KVC for webAuthenticationSupport to avoid SDK availability issue

## 4.3.1 - 2026-06-04


- Fixed: iOS Passkey/WebAuthn support — wired `webAuthenticationSupport` setting into
  native `WKWebViewWebAuthenticationSupport.boundKeychainForPasskeys` on iOS 16.4+ (#131)
- Fixed: macOS 26 crash in AppKit NSToolbar when InAppBrowser window closes — added
  `isClosing` guard and `window?.delegate = nil` before teardown (#87)
- Fixed: macOS WebView native frame drift with fractional platform view widths —
  overrode `layout()` to explicitly sync frame from superview bounds (#93)
- Fixed: iOS `shouldOverrideUrlLoading` deadlock when adding custom headers — added
  `isNavigatingWithCustomAction` flag to prevent re-entrant navigation callbacks (#132)
- Fixed: `InAppLocalhostServer` fails after app resumes from background — added
  `AppLifecycleListener` to close and reset server state on resume (#113)
- Fixed: `build_runner` fails due to missing `generators` package — added as dev_dependency
  in platform_interface pubspec (#139)
- Feature: `WebAuthenticationSession` now supports `additionalHeaderFields` for custom
  HTTP headers — available on iOS 17.4+ (#100)
- Chore: Raised minimum Flutter version from 3.29.0 to 3.38.6 for iOS touch fix (#128)
## 4.3.0 - 2026-06-03


- Fixed: iOS `onCreateWindow` not respecting client return value — now returns `nil` when
  the client handles the window creation, preventing WebKit from creating an unused
  window WebView (#107)
- Fixed: iOS crash on `InAppWebView.dispose()` when KVO observers fire after disposal —
  added `isDisposed` guard to `observeValue`, made `dispose()` idempotent with
  `isDisposed = true`, added `dispose()` call in `deinit` (#120, #129)
- Fixed: macOS SIGSEGV crash in `callAsyncJavaScript` — added `isDisposed` guard to
  `observeValue`, added optional chaining on `channel?.invokeMethod` calls (#126)
- Chore: Updated minimum iOS build version to 16.0
## 4.2.4 - 2026-06-03


- Feature: WebAuthn (passkey) support — added `webAuthenticationSupport` setting +
  `WebAuthenticationSupport` enum for native passkey authentication in WebViews
  (Upstream PR #2743 @susemeee)
- Feature: Google Pay support — added `paymentRequestEnabled` setting for
  `WebViewFeature.PAYMENT_REQUEST` (Upstream PR #2722 @AzarouAmine)
- Feature: Audio capture for file picker — added `getAudioIntent()` for
  `<input type="file" accept="audio/*">` support (Upstream PR #2823 @PrimozRatej)
- Fixed: takeScreenshot now renders content outside the viewport — disabled scrollbars
  during capture, added layout() before draw() (Upstream PR #2390 @lucasdessy)
- Fixed: AJAX blob interception — use `request.response` instead of undefined `blob`
  variable (Upstream PR #2099 @EArminjon)
- Fixed: Chrome not supported error handling — wrapped `onCustomTabsConnected` in
  try-catch with `onBrowserNotSupported` callback (Upstream PR #2070 @luckyhandler)
- Fixed: Restored working `.g.dart` files after build_runner regeneration
- Chore: Bumped `androidx.webkit:webkit` from 1.13.0 to 1.14.0
- Chore: Added `generators` dependency to platform_interface for proper code generation
## 4.2.4 - 2026-06-03


- Feature: WebAuthn (passkey) support — added `webAuthenticationSupport` setting +
  `WebAuthenticationSupport` enum for native passkey authentication in WebViews
  (Upstream PR #2743 @susemeee)
- Feature: Google Pay support — added `paymentRequestEnabled` setting for
  `WebViewFeature.PAYMENT_REQUEST` (Upstream PR #2722 @AzarouAmine)
- Feature: Audio capture for file picker — added `getAudioIntent()` for
  `<input type="file" accept="audio/*">` support (Upstream PR #2823 @PrimozRatej)
- Fixed: takeScreenshot now renders content outside the viewport — disabled scrollbars
  during capture, added layout() before draw() (Upstream PR #2390 @lucasdessy)
- Fixed: AJAX blob interception — use `request.response` instead of undefined `blob`
  variable (Upstream PR #2099 @EArminjon)
- Fixed: Chrome not supported error handling — wrapped `onCustomTabsConnected` in
  try-catch with `onBrowserNotSupported` callback (Upstream PR #2070 @luckyhandler)
- Fixed: Restored working `.g.dart` files after build_runner regeneration
- Chore: Bumped `androidx.webkit:webkit` from 1.13.0 to 1.14.0
- Chore: Added `generators` dependency to platform_interface for proper code generation
## 4.2.3 - 2026-06-03


- Fixed: Android onWebViewCreated not firing on ~50% release cold starts — deferred JS bridge
  registration (addJavascriptInterface, addDocumentStartJavaScript) to View.post() so binder IPC
  doesn't suppress engine's onPlatformViewCreated dispatch
- Fixed: Changed dismissDialogues setting default from true to false (opt-in behavior)
- Fixed: Android 15 edge-to-edge — skip deprecated setNavigationBarColor/setNavigationBarDividerColor
  APIs on SDK 35+ (PR #2729 @NIKDISSV-Forever)
- Fixed: Java deprecation cleanup — new Handler(Looper.getMainLooper()), clearSessionCookies()
  helper, @SuppressWarnings on WebViewClient classes (PR #2817 @Khairul989)
- Fixed: KeepAlive NPE — use remove() instead of put(null), copy-on-iterate in dispose()
  (PR #2638 @mustafayildiz12)
- Fixed: CVE-2020-6563 — sandbox file access protection in file picker (PR #2243 @AlexV525)
- Fixed: debugAssertNotDisposed() crash — use this.\_channel directly in disposeChannel()
  (PR #2558 @MSOB7YY)
- Fixed: onCreateWindow URL for window.open() — handle HitTestResult.UNKNOWN_TYPE
  (PR #1679 @zopagaduanjr)
- Fixed: pana/pub.dev analysis failure — analysis_options.yaml linter rules (PR #2758 @note11g)
- Fixed: Bumped example app AGP 8.4.0 → 8.6.0
- Feature: KeepAlive URL tracking — added currentUrl to InAppWebViewControllerKeepAliveProps
  (PR #2614 @Hamed233)
- Chore: Added .build/ to .gitignore — removed 3,344 tracked SPM build artifacts
- Chore: Improved changelog generation — root CHANGELOG.md as single source of truth,
  actual commit messages as fallback instead of generic placeholder
- Chore: Created UPSTREAM_ISSUES_TRIAGE.md — comprehensive triage of all 156 upstream issues
- Chore: Created 72 tracking issues, closed 18 non-applicable, notified 25+ upstream PR authors
## 4.2.3 - 2026-06-03

* Prepare for publishing version 4.2.3
## 4.2.2 - 2026-06-03

* Prepare for publishing version 4.2.2
## 4.2.1 - 2026-05-24

* Prepare for publishing version 4.2.1
## 4.2.0 - 2026-05-23

* Prepare for publishing version 4.2.0
## 4.1.0 - 2026-05-23

* Prepare for publishing version 4.1.0
## 4.0.10 - 2026-04-01

* Prepare for publishing version 4.0.10
## 4.0.9 - 2026-04-01

* Prepare for publishing version 4.0.9
## 4.0.9 - 2026-02-17

* Feature: Added clearCookies support for macos

## 4.0.8 - 2026-02-16

* Prepare for publishing version 4.0.8
## 4.0.7 - 2026-02-16

* Fixed: getHtml works on macos, tested on ios,android

## 4.0.6 - 2026-02-16

* Fixed: GetHtml is tested on mac/web

## 4.0.5 - 2026-02-16

* Fix: updated missing linux package reference

* Updated dependencies to use hosted references

## 4.0.3 - 2026-02-16

* Fixed: EdgeInsets conversion issue on getHtml
* Fix: Added getHtml method for macos,windows,web,linux platforms

* Updated dependencies to use hosted references

## 4.0.2 - 2026-02-16

* Prepare for publishing version 4.0.2
* Updated dependencies to use hosted references

## 4.0.0 - 2026-02-16

* Refactored with Gemini-3-Flash
* Updated dependencies to use hosted references

## 3.0.0 - 2025-11-05

* removed macos,linux,web,windows support. implemented fixes for issues with Claude AI
* Updated dependencies to use hosted references

## 2.4.28 - 2025-07-25

* fixed cocoapods issues
* Updated dependencies to use hosted references

## 2.4.8 - 2025-06-16

* cocoapads paths updated
* Updated dependencies to use hosted references

## 2.4.7 - 2025-06-16

* update cocoapods path
* Updated dependencies to use hosted references

## 2.4.6 - 2025-06-16

* updated pod repo paths
* Updated dependencies to use hosted references

## 2.4.6 - 2025-06-16

* fixed ios
* Updated dependencies to use hosted references

## 2.4.5 - 2025-06-16

* cocoapods path issuu fixed
* Updated dependencies to use hosted references

## 2.4.4 - 2025-06-16

* bump versions
* Updated dependencies to use hosted references

## 2.4.3 - 2025-06-16

* bump versions
* Updated dependencies to use hosted references

## 2.4.2 - 2025-06-16

* bump OrderedSet to 6.0.3 to satisfy Xcode 16
* Updated dependencies to use hosted references

## 2.4.1 - 2025-06-15

* published to cocoapods
* Updated dependencies to use hosted references

## 2.4.0 - 2025-06-15

* Removed obsolete LIBRARY_SEARCH_PATHS for Swift overlays
* Updated dependencies to use hosted references

## 2.3.0 - 2025-06-15

* Updated to Android SDK 36 support
* Updated dependencies to use hosted references

## 2.2.0 - 2025-06-01

* fix  missing dynamic library error for libswiftWebKit.dylib
* Updated dependencies to use hosted references

## 1.8.0 - 2025-04-26

* all build errors are fixed
* Updated dependencies to use hosted references

## 1.7.0 - 2025-04-26

* added internal anootations for next release
* Updated dependencies to use hosted references

## 1.5.0 - 2025-04-26

* support compileSdk 35 fix android issues
* Updated dependencies to use hosted references

