## 6.0.1 - 2026-09-11

### Bug Fixes

- [iOS] Make `InAppWebView.evaluateJavaScript(_:completionHandler:)` portable across Xcode versions. Its completion handler was declared `@MainActor @Sendable (Any?, (any Error)?) -> Void`, which only matches the SDK bundled with recent Xcode. On older SDKs the method stopped overriding its superclass and the extra overload it left behind made every single-argument `evaluateJavaScript(...)` call ambiguous — 10 compile errors, meaning consumers on older Xcode could not build the iOS plugin at all
- [Web] `consoleLogEnabled: false` now actually disables console interception. The guard read `params.webviewParams?.settings`, a field that does not exist on `PlatformWebViewCreationParams` — it is `initialSettings` — so the web implementation did not compile either
- [iOS] Declare `dataStoreWasSelected` in the scope shared by the iOS 9 and iOS 11 availability blocks in `preWKWebViewConfiguration`; it was declared inside the iOS 9 block but read by the later cookie-setup block, so the file did not compile (#316, #329)
- [iOS] Remove two always-true `!= null` guards in `HttpAuthCredentialsDatabase` and an unused `dart:typed_data` import in its screenshot/PDF delegation test

### Internal

- CI passes end to end again, now 15 jobs. `flutter analyze` runs with `--no-fatal-infos`: compile errors and warnings fail the build, style-level infos do not
- `zikzak_inappwebview_ios` joined the analyze and test matrices, and a `build-ios` job compiles its Swift sources from this checkout — that job is what surfaced the `evaluateJavaScript` breakage above
- Fixed `constant_identifier_names` in `zikzak_inappwebview_platform_interface/analysis_options.yaml` — `linter: rules:` accepts only booleans, so `ignore` left the rule enabled and produced 558 findings
- Intra-repo dependencies resolve from local source through `dependency_overrides`, so CI exercises this checkout rather than the published artifacts

## 6.0.0

### Breaking Changes

- **Session layer renamed**: `zikzak_session` → [`zuraffa_session`](https://pub.dev/packages/zuraffa_session) (^1.1.0). `WebViewSessions` and the portable-session APIs now consume `zuraffa_session` types — consumers passing `zikzak_session` session stores must migrate their imports (`package:zikzak_session/zikzak_session.dart` → `package:zuraffa_session/zuraffa_session.dart`) or stay on 5.x.

### Features

- Aligned with the Zuraffa fleet package identity (`zuraffa_session`).

## 5.3.3 - 2026-09-05

### Bug Fixes

- [macOS] Sanitize non-cloneable objects (DOMException, Error, RegExp, Promise, etc.) in console bridge JS before postMessage — prevents WebKit SIGSEGV on multi-tab same-profile navigation (#309, #312)
- [macOS] Restore `userContentController` public access to satisfy WKScriptMessageHandler protocol conformance (#314)

### Features

- Add `consoleLogEnabled` setting (default `true`) — when `false`, the console override script is not injected and console.log/error/warn messages are NOT forwarded to Dart. Wired on all 4 platforms that intercept console: macOS, iOS, Android, Web

## 5.3.2 - 2026-09-05

### Bug Fixes

- [Windows] Add missing `kDebugMode` import — fixes build error in 5.3.1 (#315)

## 5.3.1 - 2026-09-05

### Bug Fixes

- [macOS] Restore public access on `userContentController(_:didReceive:)` to satisfy `WKScriptMessageHandler` protocol conformance — fixes build breakage in 5.3.0 (#312, #313)

## 5.3.0 - 2026-09-05

### Features

- [Windows] WebView2 environment reuse is now observable and regression-tested (#300, #303)
- [Windows] Enforce callback ordering and dispose safety for load events (#301, #304)

## 5.2.1 - 2026-09-05

### Bug Fixes

- [macOS] Defensive deserialization of WKScriptMessage.body — prevents SIGSEGV crash when JS posts DOMException or other non-cloneable objects through the zikzak bridge (#309)
- [macOS] Add ObjC exception boundary (ZikzakExceptionCatcher) to catch WebKit deserialization exceptions in WeakScriptMessageHandler
- [macOS] Recursively sanitize message bodies for Flutter standard message codec — non-cloneable leaves converted to string representation

## 5.2.0 - 2026-09-04

### Features

- [macOS] Per-profile proxy support via WKWebsiteDataStore.proxyConfigurations
- [macOS] ProxyController implementation using WKWebsiteDataStore.proxyConfigurations
- [Android] Honor PDFConfiguration page size/margins/orientation in createPdf
- HeadlessInAppWebView double-dispose guard for safe reuse
- Network capture: per-domain maxBodySize, maxBytes, maxEntries budget enforcement
- Network capture: redact auth-shaped secrets at source (URL/body params)
- Portable sessions (014), dismiss dialogues (002), dispose patterns (013)
- Platform interface: expose and export four domain controller delegates (navigation, javaScript, cookie, settings)
- Wave Z module scaffold — split map, ports, WebViewPool, VCR, grep gate
- [iOS/macOS] Per-instance persistent isolated WKWebsiteDataStore via persistentStoreIdentifier
- GYM real exercises for zikzak_inappwebview (warmup + js-bridge-round-trip)
