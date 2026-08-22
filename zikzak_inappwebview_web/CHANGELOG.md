## [Unreleased]

## 5.0.1 - 2026-08-22

### Fixes

- Fixed Android enum settings serialization so platform-channel consumers receive the expected integer wire values.

## 5.0.0 - 2026-08-16

### Breaking Changes

- Migrated the entire `platform_interface` model layer to **Zorphy entities** — every model class is now a Zorphy entity instead of a hand-written `@ExchangeableObject`-style class (Phases 1–3j). This changes the public API surface of the platform interface (class structure, `toJson`/`fromJson`, equality) and may require updates to custom platform implementations.

### Features

- [platform_interface] Migrated model families to Zorphy entities: JS dialogue, ajax request, fetch request, console message, web resource, permission/safe-browsing, navigation, auth/ssl, pull-to-refresh, web storage, web message, web authentication session, context menu, webview environment, chrome safari browser, print job, `InAppBrowserMenuItem`, tracing settings, user script, image/rect/screenshot config, in-app webview settings, and script HTML tag attributes

### Chores

- Removed the dead `@ExchangeableObject` codegen toolchain
- Removed the Docusaurus website (to be replaced by a zread wiki)

## 4.10.0 - 2026-08-16

### Fixes

- [iOS] Gate `HeadlessInAppWebView.run()` on web-process readiness — the first real `loadUrl` after `run()` could be silently dropped by WKWebView while its content process was still booting, surfacing as "Unable to fetch data" on the very first request. `run()` now completes only after the initial navigation reaches a terminal state (`didFinish`/`didFail`); signal-driven, no timeout constant
- [iOS] Guard `run()` against a missing web view (no silent hang)
- [Android] Same headless readiness gate — `run()` completes only after `onPageFinished` or a main-frame error (both `InAppWebViewClient` and `InAppWebViewClientCompat`)
- [macOS] Same headless readiness gate — `run()` completes only after `didFinish`/`didFail`
- [Linux] Same headless readiness gate — the headless "run" channel handler responds only after the first `WEBKIT_LOAD_FINISHED`

### Features

- [example] Add First-Load Race Stress screen — reproduces the first-load race for headless and visible webviews (fresh webview + immediate `loadUrl`, 10 sequential attempts)

## 4.9.0 - 2026-08-14

### Features

- Session recipe — record and replay user sessions in the WebView: JS
  tap-listener injection, selector-candidate extraction, scripted click replay,
  and recipe models (#216)
- Navigation tracker — JS-assisted URL-cycle tracking through the webview (#216)
- Dialogue dismisser — inject JS to auto-dismiss modal dialogs (#216)
- Navigation guards — `keepNavigationInWebView` helper that keeps user-tapped
  links inside the WebView, avoiding iOS universal-link handoff (#216)
- [Windows] Virtual host name to folder mapping — CORS-safe serving of local
  folders (CORS bypass for local resources) (#185)
- [macOS] Popup windows — `window.open` / `target=_blank` now load their URL
  via `WKUIDelegate createWebViewWith` off-screen-window support, reparented
  into a Flutter platform view when `onCreateWindow` is handled (#182, #183, #187)

### Fixes

- [macOS] Popup window crash, settings key, and event delivery fixes (#187)
- [macOS] Network Capture API callbacks never fired — JS bridge name aligned
  with iOS/Android so `onNetworkRequest` / `onNetworkResponse` /
  `onNetworkLoadingFinished` reach Dart (#182)
- [Linux] Blue screen instead of webview — offscreen rendering via
  `GtkOffscreenWindow` + software rendering, plus `openDevTools` support (#184)
- [Linux] Native plugin compile regression — broken `takeScreenshot` string
  literal and missing include path (#179)
- Chore: renamed remaining `flutter_inappwebview` residuals to
  `zikzak_inappwebview` (JS bridge name, method channel, platform view type id) (#186)
- Chore: dependency bumps (npm deps, brace-expansion) (#189, #210)

## 4.8.0 - 2026-08-14

### Features

- [macOS] Add context-menu support — `disableContextMenu` / `disableLongPressContextMenuOnLinks` settings now honored, `onCreateContextMenu` event fired (#208, fixes #196)
- [macOS] Implement WKNavigationDelegate authentication challenges — HTTP basic/digest/NTLM/Negotiate, TLS server-trust, and client-certificate requests (#207, fixes #193)
- [macOS] Method-channel parity — ~50 controller methods implemented on iOS are now available on macOS (MissingPluginException resolved) (#205, fixes #197)
- [macOS] Implement print page support reusing the iOS pattern (#190, fixes #188)
- [Android] Add window-insets control for web content (`setInsetsForWebContentToIgnore` equivalent) (#206, fixes #198)
- [iOS] Add `UIScrollView` bouncesHorizontally / bouncesVertically (iOS 17.4+) (#209, fixes #199)
- [Android] Bump toolchain — androidx.webkit 1.15.0, AGP 8.13.1, JVM target 17 (#211, fixes #201)
- Refactor: split `InAppWebViewController` into domain-specific controllers (#176)
- Refactor: standardize dispose patterns across all wrapper classes (#175)

### Fixes

- [macOS] Implement media-capture permission prompts for `getUserMedia()` — no longer silently denied (#204, fixes #195)
- [macOS] Implement `webViewWebContentProcessDidTerminate` — no more blank/unrecoverable WebView after content-process kill (#203, fixes #194)
- [macOS] Await `shouldOverrideUrlLoading` response so cancellations are honored (#202, fixes #192)
- [macOS] Use `WKWebpagePreferences.allowsContentJavaScript` instead of deprecated `WKPreferences.javaScriptEnabled` (#212, fixes #200)
- [macOS] Replace deprecated `javaScriptEnabled` read in `getSelectedText` (#213)
- [macOS] Repair SPM build — duplicate `Util.swift`, iOS-only APIs, init ordering (#215)
- [macOS] Add missing `onPageCommitVisible` / `onDidReceiveServerRedirectForProvisionalNavigation` method-channel handlers (#217)
- [Windows] Forward `additionalBrowserArguments` to WebView2 (#214, fixes #178)
- [Windows] Implement `addJavaScriptHandler` + JS bridge (fixes #177)
- [Android] Use `androidx.core.view.OnApplyWindowInsetsListener` type directly (#217)

## 4.7.0 - 2026-07-29

### Features

- Added iOS proxy support (iOS 17.0+) — set process-wide proxy for WKWebView
- Added Network Capture API — capture XHR/fetch requests and response bodies
- Added Network Capture Scraper example screen

### Fixes

- Fixed: Web/WASM build failure — `HeadlessInAppWebViewWeb.dispose()` missing
  `isKeepAlive` parameter that was added to `PlatformHeadlessInAppWebView.dispose`
  interface, causing `dart2wasm` and `dart2js` compile errors
- Fixed iOS: removed duplicate `else` clause in `ProxyManager` guard statement
- Fixed iOS: added missing Flutter import and fixed Swift API usage in `ProxyManager`
- Fixed Linux: removed unused `<iostream>` includes and call `load_initial` in
  `createHeadless`
- Fixed Linux: fixed pre-existing C++ issues in `in_app_webview.cc`
- Fixed: restored `Disposable` interface on `PlatformProxyController`

### Chores

- Removed network capture example from public package
- Added `.clangd` and `compile_flags.txt` for Linux Flutter header resolution
- Bumped svgo dependency

## 4.6.3 - 2026-07-21

- Fixed: Web/WASM build failure — `HeadlessInAppWebViewWeb.dispose()` missing
  `isKeepAlive` parameter that was added to `PlatformHeadlessInAppWebView.dispose`
  interface, causing `dart2wasm` and `dart2js` compile errors

## 4.6.2 - 2026-07-21

- Fixed: Web/WASM compilation broken by unconditional `dart:io` import in platform
  interface — replaced with conditional export `if (dart.library.io)` to compile
  a stub on Web/WASM and the real `HttpServer`-based implementation on native

## 4.6.1 - 2026-07-21

- Fixed: iOS compile error in `URLValidationManager` integration — removed extraneous
  argument label `url:` from `validateURL` call that caused Swift compiler error
  when archiving for device

## 4.6.0 - 2026-07-21

- Fixed: iOS InAppBrowser crash after SPM migration — storyboard now loaded via
  `Bundle.module` instead of main bundle, resolving "Could not find a storyboard
  named 'WebView'" exception when opening the in-app browser
- Fixed: Android WebView lifecycle — `onFlutterViewDetached()` now properly
  destroys the WebView (guarded against keepAlive)
- Fixed: Android WebSettings OEM crash protection — 18 `WebSettingsCompat.*`
  calls wrapped in try/catch for Huawei/Honor/OnePlus devices
- Fixed: iOS `webViewWebContentProcessDidTerminate` now auto-reloads after
  500ms with `isDisposed` guard
- Fixed: iOS `URLValidationManager` wired into navigation flow — blocks
  `javascript:`, `vbscript:`, `jar`, `wyciwyg` schemes at native level
- Fixed: `InAppLocalhostServer` race condition — added `Completer` gate to
  prevent `SocketException: Address already in use` on rapid start/close
- Fixed: `PullToRefreshController` — added `_isDisposed` guard with
  `MissingPluginException` catch
- Fixed: Headless WebView cleanup — explicit `stopLoading()` and script
  removal in deinit/dispose across iOS, Android, and Dart layers
- Fixed: webkit2gtk-4.0 compile failure with proper memory cleanup
- Feature: Web platform — added `addJavaScriptHandler`/`removeJavaScriptHandler`/
  `hasJavaScriptHandler` via `postMessage` bridge
- Feature: Windows — wired `WebViewEnvironmentSettings.userDataFolder` into
  WebView2 initialization with writability verification
- Security: iOS native URL scheme validation via `URLValidationManager`
- Perf: CookieManager — all 7 methods wrapped with `Lock.synchronized()` for
  thread-safe concurrent access

## 4.5.3 - 2026-07-20

- Fixed: iOS InAppBrowser crash after SPM migration — storyboard now loaded via
  `Bundle.module` instead of main bundle, resolving "Could not find a storyboard
  named 'WebView'" exception when opening the in-app browser
- Cleaned up `any` version constraints from dev/example pubspec files

## 4.5.3 - 2026-07-20

- Fixed: iOS InAppBrowser crash after SPM migration — storyboard now loaded via
  `Bundle.module` instead of main bundle, resolving "Could not find a storyboard
  named 'WebView'" exception when opening the in-app browser
- Cleaned up `any` version constraints from dev/example pubspec files

## 4.5.2 - 2026-07-19

- Fixed: Generator no longer produces `InvalidType` for fields referencing
  other generated types (e.g. `PrintJobColorMode?`) — the `exchangeable_object_generator`
  now falls back to AST source text when the analyzer can't resolve a type
- Feature: Added camelCase convenience getters for all `SCREAMING_SNAKE_CASE`
  enum constants (e.g. `UserScriptInjectionTime.atDocumentStart`,
  `Sandbox.allowPopups`, `ConsoleMessageLevel.warning`)
- Fixed: `exchangeable_enum_generator` no longer attempts to generate getters
  for Dart reserved words (`default`, `switch`, etc.) or `@ExchangeableEnumCustomValue`
  fields with non-standard types
- Docs: Added `GENERATOR_NOTES.md` documenting the `console_message.g.dart`
  null-safety hand-edit and regeneration workflow

## 4.5.1 - 2026-07-19

- Fixed: macOS `addJavaScriptHandler` bridge now uses `postMessage` with a JSON
  string instead of structured clone — eliminates `EXC_BAD_ACCESS` crash in
  WebCore's `wrap<DOMException>` when passing large or complex data through
  `callHandler`
- Fixed: macOS `evaluateJavascript` now returns `null` to Dart instead of
  throwing `PlatformException` when WKWebView returns `nil` (e.g., for
  `undefined`, `void`, or Promise expressions)
- Fixed: macOS `initialUserScripts` parameter was silently ignored — WKWebView
  now properly injects user scripts during initialization
- Added: `UserScriptInjectionTime.atDocumentStart` and `atDocumentEnd`
  convenience getters (in addition to existing `AT_DOCUMENT_START` / `AT_DOCUMENT_END`)
- Removed: CocoaPods podspec files from iOS and macOS packages (project is now
  100% SPM)

## 4.5.0 - 2026-07-18

- Feature: Added `addJavaScriptHandler` / `removeJavaScriptHandler` /
  `hasJavaScriptHandler` support on macOS — the JavaScript bridge
  (`window.flutter_inappwebview.callHandler()`) is now fully functional,
  enabling bidirectional communication between Dart and JavaScript in
  macOS WKWebView
- Fixed: macOS `ConsoleMessage.fromMap` crash when receiving null `message`
  or `messageLevel` values from JavaScript — fixed at the Swift native layer
  (coerces null to empty string), Dart macOS controller (null-safe constructor)
  and shared `ConsoleMessage.fromMap` (null-safe defaults for all platforms)
- Tests: Added unit tests for macOS controller (`addJavaScriptHandler` lifecycle)
  and platform interface (`ConsoleMessage.fromMap` null safety)

## 4.4.5 - 2026-07-18

- Fixed: macOS InAppWebView no longer returns WKWebView directly as the platform
  view — it now wraps it in a container NSView with proper autoresizing masks,
  eliminating the blank screen caused by a zero-frame WKWebView that couldn't
  resize to fill its allocated space
- Fixed: macOS example app entitlements — added missing
  `com.apple.security.network.client` to both DebugProfile and Release
  entitlements, granting WKWebView's networking process outgoing access so it
  can load remote web pages under App Sandbox
- Updated: Flutter SDK upgrade with project configuration migration across all
  platforms (Android build.gradle → build.gradle.kts, iOS SceneDelegate, Xcode
  project updates, platform file regeneration)

## 4.4.4 - 2026-07-03

- Fixed: macOS headless WebView now uses a dedicated off-screen `NSWindow` instead
  of attaching to the main window with `alphaValue = 0.01` — eliminates potential
  mouse event interception behind the Flutter surface while still providing the
  view hierarchy `WKWebView` needs for rendering and JS execution

## 4.4.3 - 2026-06-24

- Fixed: iOS JavaScript handler error messages with newlines, backslashes, or
  carriage returns are now properly escaped via `JSONSerialization` instead of
  single-quote interpolation that produced `SyntaxError: Unexpected EOF` and
  left JS promises pending forever — matches Android's `JSONObject.quote()`

## 4.4.2 - 2026-06-19

- Fixed: Windows and Linux `onWebViewCreated` type mismatch — platform controllers
  (`InAppWebViewWindowsController`, `LinuxInAppWebViewController`) are now wrapped through
  `controllerFromPlatform` to return proper `InAppWebViewController` instances

## 4.4.1 - 2026-06-16

- Fixed: Android build failure — `URLRequest` constructor calls in `InAppWebViewClient`,
  `InAppWebViewClientCompat`, and `InAppWebViewChromeClient` now pass the 5th `timeoutInterval`
  parameter to match the updated constructor signature

## 4.4.1 - 2026-06-16

- Fixed: Android build failure — `URLRequest` constructor calls in `InAppWebViewClient`,
  `InAppWebViewClientCompat`, and `InAppWebViewChromeClient` now pass the 5th `timeoutInterval`
  parameter to match the updated constructor signature

## 4.4.0 - 2026-06-16

- Feature: Android URLRequest now supports `timeoutInterval` — the InAppWebView will stop
  loading after the specified interval, making rendered HTML available for extraction via
  `getHtml()` even if the page hasn't fully loaded
- Feature: macOS `URLRequest` native extension with full property support —
  `init(fromPluginMap:)` and `toMap()` covering method, body, headers, cache policy,
  network service type, timeout interval, and more
- Refactor: macOS `InAppWebView` uses the new `URLRequest(fromPluginMap:)` extension
  for cleaner URL loading in both initial load and `loadUrl()`
- Chore: `prepare_for_publish.sh` no longer attempts to update CocoaPods podspecs
  (migrated to Swift Package Manager)
- Chore: Updated dependency lock files

## 4.4.0 - 2026-06-16

- Chore: Updated dependency lock files

## 4.3.8 - 2026-06-15

- fixed macos setting and removed pods from example
- 'updated deps'

## 4.3.7 - 2026-06-15

- Remove debugPrint dealloc statements from Swift deinit blocks
- published

## 4.3.6 - 2026-06-14

- Merge pull request #147 from arrrrny/fix/issue144-stuck-loading
- fixed timer issue
- bumped gradle
- fix(android): resume global WebView timers when preparing a new InAppWebView
- chore(android): bump Gradle wrapper to 9.1.1 for AGP 9.0
- chore(android): upgrade AGP to 9.0.0
- chore(android): add .kotlin/ to gitignore
- chore: remove accidentally committed .kotlin session file
- fix(android): upgrade Gradle/AGP/Kotlin and migrate off kotlin-android
- Merge branch 'publish-4.3.5'
- 'pub get
- Merge pull request #146 from arrrrny/fix/v4.3.5-build-fixes

## 4.3.5 - 2026-06-12

- Fixed: macOS build failure — removed stray `}` that closed the `InAppWebView` class prematurely,
  leaving `WKNavigationDelegate`/`WKUIDelegate` methods outside the class scope. Also removed
  dead `result` variable reference from `shouldOverrideUrlLoading` (#145)
- Fixed: Android AGP 9+ build failure — replaced `getDefaultProguardFile('proguard-android.txt')`
  with `getDefaultProguardFile('proguard-android-optimize.txt')` in `android/build.gradle` (#143)
- Fixed: Linux build failure with WebKitGTK 2.52+ — migrated deprecated
  `webkit_web_view_run_javascript` → `webkit_web_view_evaluate_javascript` and replaced
  removed synchronous `webkit_web_view_get_snapshot` with async version (#142)
- Fixed: Windows build failure — removed `pluginClass` from pubspec.yaml; the Windows plugin
  is Dart-only (uses `webview_windows` package), so no native CMake project is needed (#142)
- Fixed: CMake include directory visibility for Linux plugin — changed `INTERFACE` to `PUBLIC`
  so the plugin can find its own headers (#142)

## 4.3.4 - 2026-06-12

- Fixed: iOS `type 'int' is not a subtype of type 'WebAuthenticationSupport?'` crash in
  `getHtml()`/`getSettings()` — `InAppWebViewSettings.fromMap()` now converts
  `webAuthenticationSupport` via `WebAuthenticationSupport.fromNativeValue()` instead of
  assigning the raw `int` value from the platform channel map

## 4.3.3 - 2026-06-04

-

## 4.3.2 - 2026-06-04

- fix: use KVC for webAuthenticationSupport to avoid SDK availability issue

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

- Prepare for publishing version 4.2.3

## 4.2.2 - 2026-06-03

- Prepare for publishing version 4.2.2

## 4.2.1 - 2026-05-24

- Prepare for publishing version 4.2.1

## 4.2.0 - 2026-05-23

- Prepare for publishing version 4.2.0

## 4.1.0 - 2026-05-23

- Prepare for publishing version 4.1.0

## 4.0.10 - 2026-04-01

- Prepare for publishing version 4.0.10

## 4.0.9 - 2026-04-01

- Prepare for publishing version 4.0.9

## 4.0.9 - 2026-02-17

- Feature: Added clearCookies support for macos

## 4.0.8 - 2026-02-16

- Prepare for publishing version 4.0.8

## 4.0.7 - 2026-02-16

- Fixed: getHtml works on macos, tested on ios,android

## 4.0.6 - 2026-02-16

- Fixed: GetHtml is tested on mac/web

## 4.0.5 - 2026-02-16

- Fix: updated missing linux package reference

- Updated dependencies to use hosted references

## 4.0.3 - 2026-02-16

- Fixed: EdgeInsets conversion issue on getHtml
- Fix: Added getHtml method for macos,windows,web,linux platforms

- Updated dependencies to use hosted references

## 4.0.2 - 2026-02-16

- Prepare for publishing version 4.0.2
- Updated dependencies to use hosted references

## 4.0.0 - 2026-02-16

- Refactored with Gemini-3-Flash
- Updated dependencies to use hosted references
