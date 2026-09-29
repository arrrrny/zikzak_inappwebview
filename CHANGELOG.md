## Unreleased

---

## 6.1.0 - 2026-09-29

### Features

- [macOS] `InAppWebViewSettings.contentBlockers` is now actually applied. The setting was declared and decoded on macOS but never consumed — no `WKContentRuleList` was ever compiled or added, so ad/tracker blocking was silently inert while the identical setting works on iOS. `setSettings` now removes all content rule lists, serializes the decoded blockers, compiles them through `WKContentRuleListStore` under the shared `ContentBlockingRules` identifier, and adds the result to `configuration.userContentController`; an empty list clears blocking without compiling. Compilations are serialized with a token so a stale completion can no longer re-add rules a newer update removed, and a single `applyContentBlockers` funnel serves platform views, `InAppBrowser`, headless webviews and runtime updates (#338)
- [macOS] `useOnDownloadStart` / `onDownloadStartRequest` are now wired. macOS declared the setting and accepted the Dart callback, but no Swift code read the flag and no `WKDownload` plumbing existed, so the documented support could never fire. The package now adopts `WKDownloadDelegate`, returns `.download` from the navigation-response policy when the MIME type cannot be shown (with an iOS-style main-frame/non-text-mime fallback that dispatches the event and cancels), dispatches the event and cancels the native download from the destination callback so Dart streams the bytes, maps Dart policy `DOWNLOAD` to `.download` in `shouldOverrideUrlLoading`, bridges through `WebViewChannelDelegate`, and routes the event in the Dart controller. The action-stage handoff now reports a real `contentLength` and derives `suggestedFilename` from the URL path (#339, #340, #344)
- [macOS] `InAppBrowser` forwards `onDownloadStartRequest` to its event handler — downloads started in the browser never surfaced an event before (#344)
- [iOS/macOS] The platform-view root is now pinned to its Flutter bounds. On iOS `clipsToBounds` is set unconditionally at view setup; on macOS `layer.masksToBounds = true` is pinned at construction time (after `wantsLayer`, so the pin cannot be a silent no-op) and re-asserted after the web view is embedded. An `NSView` does not clip by default, so a native layer could paint over sibling Flutter content on a mis-clipped compositing path (#331, #336, #337)

### Bug Fixes

- [iOS] Forward private custom URL schemes to `shouldOverrideUrlLoading`. Payment and authentication deep links such as `weixin://` were cancelled by the native pre-navigation gate before the host navigation delegate ran, so a host could not intercept them and open the URL externally. The gate now blocks only what `URLValidationManager` already treats as dangerous (blocked schemes, failing scheme-specific checks, schemeless URLs, a rejecting custom validator); a custom scheme that no host policy handles is still cancelled
- [macOS] Stop an `EXC_BREAKPOINT` crash on macOS 15.x. `WKNavigationAction.sourceFrame` is declared non-optional by the Swift overlay, but WebKit can deliver a nil runtime object, and member access then traps in the unconditional Objective-C bridge. Navigation source frame and request/security origin are now read through a KVC-based accessor that yields nil for a nil runtime frame, at both the `shouldOverrideUrlLoading` and `onCreateWindow` call sites. With a present frame the emitted map is unchanged; with a nil frame Dart receives `sourceFrame: null`, which `NavigationAction`/`CreateWindowAction` already model as nullable (#327)
- [Dart] `onDownloadStartRequest` tolerates a null arguments map and drops a URL-less payload instead of throwing out of `DownloadStartRequest.fromJson` (#344)
- [iOS] The pre-navigation gate and `URLValidationManager` no longer evaluate a custom scheme twice — one scheme policy returns an explicit block / defer-to-host / allow decision that is reused as the delegate fallback, so a host custom validator runs once per navigation. The fallback stays fail-closed

### Internal

- Every macOS parity gap above is guarded by source-contract and behavioral tests runnable on any host (`content_blockers_parity_test`, `content_blockers_rule_list_test`, `download_start_request_parity_test`, `swift_sourceframe_kvc_test`, `swift_platform_view_clipping_test`, `ios_custom_scheme_navigation_test`)
- `InAppWebView`/`WebViewChannelDelegate` param-listener tests hardened: `handleMethod` now proves a decoded download event reaches the params callback and that a malformed one is dropped
- Bug and feature records for #327, #331, #337, #338, #339 and the iOS custom-scheme navigation fix live under `.specify/bugs/`, with TDD cycle logs and verification reports

### Docs

- Record the macOS WKWebView passkey requirements (web credentials entitlement, `apple-app-site-association` host, document-focus gotcha) in INSIGHTS.md
- Upstream engine report for the Flutter 3.47.x platform-view overlay compositing artifact filed as [flutter/flutter#193363](https://github.com/flutter/flutter/issues/193363), with an on-device mitigation matrix and evidence frames under `.specify/bugs/flutter347-platformview-rendering/`

### Example

- Add a WebAuthn passkey test page plus a local relying-party host, wired into the macOS example drawer, for manual passkey validation

---

## 6.0.2 - 2026-09-14

### Changes

- Bump `zorphy` / `zorphy_annotation` to `^2.4.0`
- Bump `zuraffa_session` to `^1.1.0`
- Add centralized version constant system (`tool/versions.dart`, `tool/update_readmes.dart`) so all package and dependency versions are defined in one place and README snippets stay in sync automatically
- Fix stale `^4.6.0` install snippet in root README and umbrella README to `^6.0.2`

### Bug Fixes

- [iOS] Restore the Swift 6 `evaluateJavaScript` override to stop a SIGBUS on first evaluation
- [iOS] Fail `build-ios` CI job when a runner stops compiling its ARM arm
- [iOS] Build the example on macOS 15 too so both `evaluateJavaScript` arms compile

### Docs

- Record the 15-job CI matrix and the build-ios coverage gap in AGENTS.md

---

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
