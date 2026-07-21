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

## 4.6.0 - 2026-07-20

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

## 4.5.2 - 2026-07-18

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

## 4.5.1 - 2026-07-18

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

## 4.4.4 - 2026-06-16

- Fixed: macOS headless WebView now uses a dedicated off-screen `NSWindow` instead
  of attaching to the main window with `alphaValue = 0.01` — eliminates potential
  mouse event interception behind the Flutter surface while still providing the
  view hierarchy `WKWebView` needs for rendering and JS execution

## 4.4.3 - 2026-06-16

- Fixed: iOS JavaScript handler error messages with newlines, backslashes, or
  carriage returns are now properly escaped via `JSONSerialization` instead of
  single-quote interpolation that produced `SyntaxError: Unexpected EOF` and
  left JS promises pending forever — matches Android's `JSONObject.quote()`

## 4.4.2 - 2026-06-16

- Fixed: Windows and Linux `onWebViewCreated` type mismatch — platform controllers
  (`InAppWebViewWindowsController`, `LinuxInAppWebViewController`) are now wrapped through
  `controllerFromPlatform` to return proper `InAppWebViewController` instances

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

## 4.3.6 - 2026-06-14

- Fixed: Android InAppWebView stuck loading when navigating between pages — removed
  `pauseTimers()` and `onPause()` from `dispose()` which are global operations affecting
  all WebViews in the app, and changed `destroy()` to be called immediately instead
  of deferred to avoid race conditions (#144)

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

## 4.3.1 - 2026-06-03

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

## 3.0.0 - 2025-11-05

- removed macos,linux,web,windows support. implemented fixes for issues with Claude AI
- Updated dependencies to use hosted references

## 3.0.0 - 2025-11-05

- **BREAKING CHANGE:** Removed macOS, Windows, Web, and Linux platform support
- **BREAKING CHANGE:** Minimum Android SDK raised from 19 to 24 (Android 7.0 Nougat)
- **BREAKING CHANGE:** Minimum iOS version raised from 13.0 to 15.0
- **16KB page size support:** Compatible with Android 15+ devices using 16KB memory pages (AGP 8.5.2)
- **Google Safe Browsing:** NOW ENABLED BY DEFAULT - Protects against phishing, malware, and unwanted software
- Focus on mobile-first: iOS and Android only for cleaner, leaner, faster codebase
- Removed all GitHub workflows from previous maintainer
- Removed all test directories (comprehensive testing suite planned for future release)
- Updated all publish scripts to support iOS and Android only

## 2.4.28 - 2025-07-25

- fixed cocoapods issues
- Updated dependencies to use hosted references

## 2.4.8 - 2025-06-16

- cocoapads paths updated
- Updated dependencies to use hosted references

## 2.4.7 - 2025-06-16

- update cocoapods path
- Updated dependencies to use hosted references

## 2.4.6 - 2025-06-16

- updated pod repo paths
- Updated dependencies to use hosted references

## 2.4.6 - 2025-06-16

- fixed ios
- Updated dependencies to use hosted references

## 2.4.5 - 2025-06-16

- cocoapods path issuu fixed
- Updated dependencies to use hosted references

## 2.4.4 - 2025-06-16

- bump versions
- Updated dependencies to use hosted references

## 2.4.3 - 2025-06-16

- bump versions
- Updated dependencies to use hosted references

## 2.4.2 - 2025-06-16

- bump OrderedSet to 6.0.3 to satisfy Xcode 16
- Updated dependencies to use hosted references

## 2.4.1 - 2025-06-15

- published to cocoapods
- Updated dependencies to use hosted references

## 2.4.0 - 2025-06-15

- Removed obsolete LIBRARY_SEARCH_PATHS for Swift overlays
- Updated dependencies to use hosted references

## 2.3.0 - 2025-06-15

- Updated to Android SDK 36 support
- Updated dependencies to use hosted references

## 2.2.0 - 2025-06-01

- fix missing dynamic library error for libswiftWebKit.dylib
- Updated dependencies to use hosted references

## 2.1.0 - 2025-04-27

- fixed dependencies
- Updated dependencies to use hosted references

## 2.0.0 - 2025-04-26

- updated to Android compileSdk 35
- Updated dependencies to use hosted references

## 2.0.0 - 2025-04-26

- fix dependencies, upgraded to Android compileSdk 35
- Updated dependencies to use hosted references

## 2.0.0 - 2025-04-26

- fixed dependencies
- Updated dependencies to use hosted references

## 2.0.0 - 2025-04-26

- Fixed package dependecy issues
- Updated dependencies to use hosted references

## 1.8.0 - 2025-04-26

- all build errors are fixed
- Updated dependencies to use hosted references

## 1.7.0 - 2025-04-26

- added internal anootations for next release
- Updated dependencies to use hosted references

## 1.5.0 - 2025-04-26

- support compileSdk 35 fix android issues
- Updated dependencies to use hosted references

## 1.1.0

- Updated all subpackages to version 1.1.0
- Improved overall performance and stability
- Enhanced compatibility with the latest Flutter versions
- Fixed minor bugs and issues reported by users
- Added new customization options for the in-app browser
- Improved documentation and code examples

## 1.0.6

- Add regexToCancelOverrideUrlLoading setting

## 1.0.4

Rebased .git to have all the history of the project

## 1.0.3

Upgraded js to 0.7.1 on zikzak_inappwebview_web

## 1.0.2

Bumped zikzak_inappwebview_ios referenced version to 1.0.1

## 1.0.1

Podfile renamed thanks Roman for PR https://github.com/MrLightful

## 1.0.0

Initial release. Thanks to ARRRRNY and all the contributors for their hard work!
