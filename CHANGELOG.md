## 6.3.3 - 2026-10-31

### Bug Fixes

- [Linux] The headless WebView is no longer dead on arrival. `LinuxHeadlessInAppWebView` never overrode `PlatformHeadlessInAppWebView.id`, so `run()` threw `UnimplementedError: id is not implemented on the current platform` inside `_init()` before any channel call — every published `zikzak_inappwebview_linux` version (4.10.0 → 6.3.2) carries the gap, so no downgrade helps. The macOS port assigns `IdGenerator.generate()` in its constructor; the Linux port now mirrors that, so the generated id backs the per-instance method channels, the `id` arg on the shared `run`/`dispose` channel calls, and `webViewController` creation. `dispose`/`setSize`/`getSize` were already safe (they guard on `_running` and never touch `id` directly) (#405)
- [Android] `WebViewCompat.addDocumentStartJavaScript` is no longer called unguarded on release cold starts, and `dispose()` no longer wipes the app-wide WebView cache (#399, PR #399). All four call sites are wrapped in `try/catch (RuntimeException)` with a log and the script left unregistered so a later add retries — `UserContentController.updateContentWorldsCreatorScript()` (releasing `contentWorldsCreatorScript = null`), `addUserOnlyScript()`, `addPluginScript()` (both leaving the script out of `scriptHandlerMap`), and the deferred-registration `Runnable` posted from the `InAppWebView` constructor, where an uncaught throw takes down the main thread. `RuntimeException` is what Chromium's browser process throws before it finishes starting ("Must be started before we block!", upstream #2843/#2849, prior art #2844). Separately, the `clearCache(true)` call removed from `InAppWebView.dispose()` was wiping the per-application HTTP disk cache shared by every other WebView in the app — including for each short-lived headless WebView; `clearHistory()` stays, and explicit clearing remains available via `clearAllCache()`
- [iOS] No private UIKit class names ship in the binary anymore — the fullscreen-window detection is ported from upstream v6.2.0-beta.3 (PR #402). Apps embedding the plugin were rejected under App Review Guideline 2.5.1 for `NSClassFromString`-ing `PGHostedWindow`. `isVideoPlayerWindow` becomes `isFullscreenMediaWindow`, qualifying a window only when it shares the web view's `windowScene`, covers ≥90% of the screen's width and height, has `windowLevel >= .normal`, and its class name (plain `NSStringFromClass`, no `NSClassFromString`) is not Keyboard / TextEffects / Alert / StatusBar / Accessibility. The `windowLevel` requirement also skips the headless host window (level `normal - 1`), so a headless run no longer surfaces as `onEnterFullscreen`. `WKWebView.fullscreenState` KVO (iOS 16+) replaces the dead 15.0 branch, and enter/exit double-fire guards plus `fullscreenWindow` tracking match the upstream behavior; keyboard/alert/text-effects windows still produce no events
- [iOS] The `createWebViewWith` popup fallback now goes through the navigation policy (PR #403). `loadUrl(urlRequest:allowingReadAccessTo:)` gained an `overridingNavigationPolicy` argument; the Dart-facing entry points keep `true` (the `isNavigatingWithCustomAction` bypass from #132 is unchanged), while the fallback used when the host does not handle `onCreateWindow` passes `false`, so the popup's main-frame load runs through `decidePolicyFor` — `URLValidationManager` and the Dart `shouldOverrideUrlLoading` see it, exactly as in flutter_inappwebview 6.1.5. A host navigation allow-list or custom-scheme hand-off now also applies to `window.open` popups, matching Android; if the app's policy cancels the popup load, the popup simply does not navigate (#394)
- [macOS] `PlatformInAppWebViewController.reloadFromOrigin()` is implemented. The macOS port never overrode it, so the call hit the platform-interface default and threw `UnimplementedError` before any method-channel call — while the platform docs list macOS as supported and the Swift side already dispatches it (`InAppWebView.swift` `case "reloadFromOrigin"` → the official `WKWebView.reloadFromOrigin()`). The Dart override invokes the `reloadFromOrigin` channel method, styled after the neighbouring `reload()`; no native change was needed (#400, PR #400)

### Docs

- The READMEs no longer claim iOS 14.0 as the minimum — the package floor is iOS 15.0 (the passkey bridge's availability guards are measured from the SDK headers against it), and the installation and requirements sections now say so (#396, PR #401)

### Tests

- Every fix above is guarded by host-runnable tests: `headless_in_app_webview_test` (Linux — `run()` reaches the shared channel with a generated id, `dispose()` tears the same id down, ids are unique per instance), `js_bridge_registration_guard_contract_test` (Android — all four guarded call sites and no `clearCache(true)` in `dispose()`), `swift_fullscreen_no_private_api_test` (iOS — no private class names and no `NSClassFromString` in any Swift source), `swift_popup_fallback_navigation_policy_test` (iOS — the fallback load carries `overridingNavigationPolicy: false`), and `in_app_webview_controller_test` (macOS — `reloadFromOrigin` invokes the channel instead of throwing). The Swift ones read the `.swift` files as text; `build-ios` remains the layer that proves compilation, and both iOS PRs re-verified `flutter build ios --release --no-codesign` from this checkout

## 6.3.2 - 2026-10-29

### Dependencies

- The whole fleet rides the unified zuraffa family line: `zuraffa_session` moves from `^1.1.0` to `^7.3.0`. The `SessionPort` / `PortableSession` contract this package codes against is unchanged (the 1.x → 7.x jump was the family's version-line unification, not an API break), and the package resolves and analyzes clean against published zuraffa_session 7.3.0. This release unblocks every consumer app that also declares `zuraffa_session: ^7.3.0` — 6.3.1's `^1.1.0` range made the two constraints mutually unsatisfiable.

## 6.3.1 - 2026-10-27

### Features

- [iOS] WebAuthn / passkey ceremonies now work on iOS — the macOS passkey bridge (#358) is ported (#384, PR #385). `navigator.credentials.create` / `.get` with `publicKey` options are intercepted by an injected `PasskeysJS` shim (installed as a `WKUserScript` at `documentStart` in every frame) and forwarded over the plugin's JS-handler channel to a native `PasskeyBridge.swift` driving `ASAuthorizationController`, which hands a WebAuthn-shaped `PublicKeyCredential` back to JS. Per-API availability guards are measured from the SDK headers against the package's iOS 15.0 floor: platform and security-key provider/request classes are iOS 15.0, `ASAuthorizationController.cancel()` is iOS 16.0, platform-registration `excludedCredentials` and security-key `residentKeyPreference` are iOS 17.4 (macOS 13.5 / 14.4 parity). Headless detection consults the `HeadlessInAppWebViewManager` registry instead of `window == nil`, because iOS headless webviews live in a real off-screen `UIWindow` (#371); `window.open` children resolve their bridge from the `_windowId` they post through, sharing the opener's user content controller; errors map to the same `DOMException`s as macOS (`NotAllowedError` for user cancel / timeout / no credentials, `TypeError` for malformed options, `SecurityError` for a non-domain `rpId`); headless webviews fail fast with `NotAllowedError` and non-`publicKey` credentials fall through to the platform default. Device-gated acceptance (webauthn.io ceremonies, consent prompts) stays recorded as open verification debt on the issue, per the spec
- [iOS/macOS] New `InAppWebViewSettings.passkeyBridgeEnabled` (default `true`) is an explicit consumer opt-out: it gates bridge creation AND shim injection on both platforms, and an explicitly requested `webAuthenticationSupport == NONE` disarms as well. iOS records `webAuthenticationSupportExplicitlyRequested` in `parse()` because its native default is `NONE` (the honest read-back of #352) — only an explicit request disarms there; macOS reads the raw creation-time map, where key presence is the explicitness signal (#384)

### Bug Fixes

- [iOS/macOS] `ProxyController` `https://` proxies no longer connect in cleartext, and proxy URL credentials are no longer dropped (#387, PR #391). `resolveProxyConfiguration` mapped both `HTTP` and `HTTPS` to a plain `httpCONNECTProxy` with no `tlsOptions:`, so a TLS-only proxy received a plaintext `CONNECT` and reset the connection; and `components.user` / `components.password` were never read and `applyCredential` was never called, so an authenticated proxy answered `407 Proxy Authentication Required` and pages silently never loaded even though `setProxyOverride` returned `true`. An `https://` proxy now builds the CONNECT configuration with `tlsOptions: NWProtocolTLS.Options()` (initializer is iOS 17.0+ / macOS 14.0+, the same availability scope as the existing `ProxyConfiguration` usage); `http://` and `socks5://` keep `nil`. URL userinfo is now applied via `applyCredential(username:password:)` iff `components.user` is non-empty, passed through *without* an extra `removingPercentEncoding` pass — `URLComponents.user` / `.password` already return percent-decoded values, and a second pass would corrupt credentials containing a literal `%`. The `UNSUPPORTED_PROXY_SCHEME` diagnostic now states the real per-scheme TLS/auth support matrix, and the same matrix is documented on `IOSProxySettings.proxyUrl` (consumed by iOS and macOS alike); the explicit-port requirement is kept and now stated in the docs
- [iOS] The passkey bridge compiles against older SDKs again (#386, PR #388). The headless check in `PasskeyBridge` touched a `webView` property that only exists on newer SDKs; it now calls the `webView()` accessor contract, which the new `passkey_bridge_test` pins

### Docs

- The READMEs gain a ⚠️ Known Issues entry for the Flutter 3.47.x platform-view rendering artifact (overlaid WebView + Bottom Sheet / WebView-in-ListView: AppBar, sheet footer and list items below a WebView card vanish from the frame). Investigation on iPhone 17/16e simulators with Flutter 3.47.4/3.47.5 left the artifact unchanged for every plugin-side candidate — control `UiKitView`, Impeller disabled, `Opacity(0.99)` snapshot wrap, native `clipsToBounds`, `PlatformViewLink` construction — so this is an engine TLHC overlay-compositing regression (flutter/flutter#193363, still open), not a plugin defect; the plugin-side hardening (`clipsToBounds = true` pinned on the WKWebView root) already shipped via #336 in 6.1.0. The canonical copy is the package README (pub.dev-facing, GitHub-absolute links), with a pointer from the root README; no rendering fix is claimed and #331 stays open with the `upstream` label (#331, PR #389)

### Internal

- The canonical passkey JS shim body is now single-sourced in the platform interface (`lib/src/web_authentication/passkeys_js_source.dart`); `scripts/generate_passkeys_shim.sh` renders both native `PasskeysJS.swift` copies from it, and the iOS suite pins the three copies byte-identical, so the shims cannot drift (#384)
- `WebViewPool` (dev-only `zikzak_inappwebview_module`, not published) gains an optional `HeadlessWebViewInstanceFactory` seam (default factory preserves the previous about:blank + `run()` behavior and now applies the caller's `InAppWebViewSettings`), the max-live / max-per-domain caps are actually enforced (max-live evicts the globally oldest idle instance or throws the new `WebViewPoolExhaustedException`; max-per-domain at creation — previously the pool silently created instances past both caps), and reused idle sessions are re-issued as fresh `PoolSession` handles over the same webview so `sessions()` reports current sessionId/eTLD+1 while warm state survives. Plugin core untouched; 18 new acceptance behaviors, 13/18 proven test-first with the remainder filed as remediation tasks (#264, PR #390)
- Every fix above is guarded by host-runnable tests: `passkey_bridge_test` (iOS, including a Swift availability-usage checker over the new guards), `passkey_opt_out_test` (macOS), `passkey_bridge_setting_test` (platform interface), and `proxy_manager_tls_auth_contract_test` (iOS + macOS, 5 tests each). The Swift ones read the `.swift` files as text — `build-ios` / `build-macos` remain the layer that proves compilation. Swift compile gates from this checkout's example app both pass: `flutter build ios --release --no-codesign` and `flutter build macos --debug`

---

## 6.3.0 - 2026-10-26

### Features

- [Headless] The headless WebView lifecycle is now real (#371, PR #380). `HeadlessInAppWebView` now shares a single dispose across webviews, renders into an off-screen container, enforces the live cap, and waits for the first render before reporting ready.

### Bug Fixes

- [iOS] `useOnDownloadStart` no longer cancels displayable main-frame responses (#382, PR #383). With `useOnDownloadStart` enabled, the `decidePolicyFor navigationResponse` handler cancelled every main-frame response whose MIME type did not start with `text/`, so JSON, image and PDF navigations never rendered even though WebKit reported `canShowMIMEType == true` for them; a response now counts as a download only when WebKit cannot show it or the Content-Disposition type is `attachment`.
- [macOS] Only responses WebKit cannot display or that the server marks `attachment` reach the download pipeline now (#374, PR #377).
- [macOS] The `callAsyncJavaScript` controller override is implemented; calls no longer fall through to the platform-interface stub and throw `UnimplementedError` (#375, PR #379).
- [macOS] `evaluateJavascript` now surfaces the JS exception text and location instead of discarding it (#373, PR #378).
- [iOS] The WebView storyboard IB deployment target was raised to iOS 15.0 (#372, PR #372).

### Internal

- CI Swift build jobs resolve the platform interface from this checkout instead of pinning pub.dev's 6.2.2; the macOS resolution assertion covers that package too.
- Restored the `dependency_overrides:` dev setup by hand after the 6.2.2 release.

### Docs

- Standardized AGENTS.md (misfire rule, forklift pool PR rule, /tmp clone rule, test concurrency).

### Style

- Reformatted `lib/` with the resolved language version, as published.

## 6.2.2 - 2026-10-20

### Bug Fixes

- The `zuraffa_session` cap that 6.2.1 introduced is lifted. 6.2.1 held the dependency at `">=1.1.0 <1.2.0"` so Flutter Web consumers would stop resolving zuraffa 7.x, whose CLI subtree (`lib/src/cli/zfa_executable.dart`, reachable from the public barrel) used 64-bit integer literals that fail dart2js in every Web build (arrrrny/zuraffa#1729). That upstream issue is closed and the fix shipped in zuraffa 7.2.0, where the FNV-1a digest helper is computed with `BigInt` instead of 64-bit integer literals, so the cap is no longer needed and the constraint is `^1.1.0` again — 6.2.2 resolves `zuraffa_session` 1.2.1 and the zuraffa 7.x line. A consumer dart2js build over `package:zuraffa/zuraffa.dart` + `package:zuraffa_session/zuraffa_session.dart` was re-verified against zuraffa 7.2.0 / zuraffa_session 1.2.1 and compiles cleanly. The cap also broke version solving well beyond Web builds: `zuraffa_session` 1.1.x requires `zuraffa: ^6.2.2`, so any app that also needs `zuraffa: ^7.x` could not resolve this package at all — 6.2.1 was unreachable for zuraffa-7 apps while 6.2.0 stayed resolvable, which silently pinned those consumers to the older release. `zuraffa_session` 1.1.0 and 1.2.x carry identical session code; only the `zuraffa` range differs, so widening the constraint changes no behaviour (#369)

## 6.2.1 - 2026-10-17

### Features

- [Windows] `getUrl()`, `getProgress()`, `canGoBack()` and `canGoForward()` return real values instead of placeholders. `webview_windows` publishes the current URL, the loading state and the history depth only as event streams, with no synchronous getter, while the platform interface asks for them on demand — so `getUrl()` was a hardcoded `null` and `getProgress()` a hardcoded `100`. `InAppWebViewWindowsController` is the long-lived owner of the `WebviewController` and the only listener that can cache them (`url` is a single-subscription stream), so it now subscribes once to `url` / `loadingState` / `historyChanged`, mirrors them, and answers the four getters from that cache; progress maps `loading` → `0` and `navigationCompleted` → `100`, the same mapping `onProgressChanged` already reports. The widget reads the cached URL instead of opening a second subscription, so the URL handed to `onLoadStart`/`onLoadStop` and the one returned by `getUrl()` cannot drift apart (#367)

### Bug Fixes

- [Windows] Load events are no longer dropped. Every `onLoadStart` / `onLoadStop` / `onProgressChanged` callback vanished while the WebView rendered normally and the host waited forever for an `onLoadStop` that never arrived. `dispatchLoadingStateChange` declared its `controller` parameter as `PlatformInAppWebViewController`, but the value forwarded to the callbacks is whatever `params.controllerFromPlatform` returned, and in the federated plugin that is the app-facing `InAppWebViewController`, which *wraps* a `PlatformInAppWebViewController` instead of implementing one. The implicit downcast therefore threw a `TypeError` inside a `Stream.listen` callback, where it escaped as an unhandled zone error and killed the event. The parameter is now typed `Object` — the shape the `void Function(T, ...)` callback contract actually passes (#368)
- [Windows] An unmounted `InAppWebView` no longer leaks its platform controller. `InAppWebViewWindowsController` holds three `WebviewController` stream subscriptions, and `WebviewController.dispose()` never closes its stream controllers, so those listeners outlived the widget and kept the graph alive. The controller is created asynchronously in `initPlatformState`, held on the `State`, and disposed from `State.dispose()` — mirroring `MacOSInAppWebViewWidget` — with teardown forwarded immediately when the state was torn down while the win32 environment was still coming up (#367)
- [Android] The first `window.open()` popup is reported to Dart with `windowId` 1 instead of 2. `InAppWebViewChromeClient.onCreateWindow` allocated an id at the top of the request, then allocated a *second* one inside `shouldOverrideUrlLoading` and forwarded that one, burning an id and shifting every popup id reported to Dart (#362)
- [Android] `window.open()` no longer throws when a parked `WebViewTransport` has been recycled. The parked `Message` was read with `get()` and left in `windowWebViewMessages`, while `onCreateWindow`'s default-behaviour callback re-parked a message whose `obj` the Looper had already recycled to `null`, so a later creation for the same `windowId` dereferenced null. The message is now consumed with `remove()` on lookup, `obj` is null-checked, and the popup URL reaches Dart through the `CreateWindowAction` request instead of a re-parked message. Both consumers also fall back to their own initial load when the transport could not be wired — previously `InAppBrowserActivity` and the platform-view path both skipped it, leaving a blank window (#357)
- [iOS] `webAuthenticationSupport` no longer claims a level it never applied. No iOS version exposes a `webAuthenticationSupport` key on `WKWebView` / `WKWebViewConfiguration` — the symbol is absent from every WebKit header, and the runtime `responds(to:)` guard is false on the iOS 26.3 simulator runtime — so both non-`NONE` levels were dropped without a word and `getRealSettings()` echoed the *requested* value out of its `toMap()` seed. `FOR_BROWSER` and `FOR_APP` now log a native diagnostic at WebView creation, including below the iOS 16.4 availability gate where the in-block `else` is unreachable, and the read-back reports the applied level only: such a WebView reads back as `NONE`, which means "no passkeys are enabled via this setting", not "FOR_BROWSER was requested" (#352)
- [macOS] The same honesty fix as iOS: `webAuthenticationSupport` is unsupported on every macOS version — `WKWebViewConfiguration` exposes no public `webAuthenticationSupport` on any macOS SDK, and the KVC path behind the `responds(to:)` guard is false at runtime — so a requested `FOR_BROWSER` or `FOR_APP` is now reported at creation instead of vanishing, and `getRealSettings()` reports the applied level (`NONE`) rather than echoing the request out of `toMap()` (#351)
- [iOS] Window access goes through the UIScene lifecycle. `UIApplication.shared.keyWindow`, `UIApplication.shared.windows` and `UIApplication.shared.delegate?.window` are deprecated, and the AppDelegate `window` is `nil` once an app adopts the UIScene lifecycle — mandatory with the iOS 27 SDK — which left `HeadlessInAppWebView`, `InAppBrowser` teardown, `visibleViewController` and the `ASWebAuthenticationSession` presentation anchor with no window to use. A new `UIApplication.sceneKeyWindow` extension resolves the foreground-active connected `UIWindowScene`'s `keyWindow`, consulting another connected scene only when no foreground-active scene exists (a foreground-active scene whose `keyWindow` is momentarily `nil` still yields `nil`), and every one of those call sites now uses it (#355)
- Held `zuraffa_session` at `>=1.1.0 <1.2.0` so Flutter Web consumers stop resolving zuraffa 7.x, whose CLI subtree (`lib/src/cli/zfa_executable.dart`, reachable from the public barrel) uses 64-bit integer literals that fail dart2js. 1.2.0 differs from 1.1.0 only by widening its `zuraffa` constraint to `^7.0.1` — the session code is identical. Note the cap also keeps `zuraffa` below 7.0.0 on every platform, not just under dart2js: an app whose graph requires `zuraffa: ^7.x` will fail pub version solving after taking this release, where previously only its Web build failed. Root cause upstream: arrrrny/zuraffa#1729 (#363)

### Internal

- `scripts/local_ci.sh` runs the repository's GitHub Actions workflow locally. GitHub Actions is billing-blocked on these repos — every run ends in ~3 s with zero steps executed — so a red check meant nothing; the script reads `.github/workflows/*` at run time and executes that workflow's jobs and steps in order, which is why it cannot drift from CI. It prints what it cannot reproduce (Linux runners, GitHub context, `uses:` actions, container jobs) instead of guessing, and reports a step that fails naming only gitignored/untracked paths as LOCAL-ONLY rather than as a CI failure. Documented in AGENTS.md
- The `webAuthenticationSupport` documentation in the platform interface now states the truth instead of a supported-versions list: a per-value matrix (`NONE` / `FOR_APP` / `FOR_BROWSER` × Android/iOS/macOS/Windows/Linux/Web), an explicit definition of "applied" vs "ignored", the iOS/macOS warning-and-read-back-`NONE` behavior, and the fact that no Apple platform offers a browser-mode WebAuthn surface for arbitrary relying parties — passkey ceremonies there are gated by the host app's `webcredentials` Associated Domains entry plus `apple-app-site-association`, not by this setting
- Every fix above is guarded by tests runnable on any host: `window_open_id_allocation_test` and `window_open_transport_test` (Android), `swift_uiscene_window_api_test` and `web_authentication_support_ios_test` (iOS), `web_authentication_support_macos_test` (macOS), and `in_app_webview_windows_load_events_test` / `in_app_webview_windows_navigation_state_test` / `in_app_webview_windows_widget_wiring_test` (Windows). The Swift ones read the `.swift` files as text, so they are evidence about code shape only — `build-ios` and `build-macos` are what prove the sources compile
- `PUBLISH.md` records the 6.2.0 release gotchas: an `HTTPS_PROXY` with embedded credentials makes pub reject every command (run the pub-touching scripts with the proxy unset), `restore_dev_setup.sh` must not be the last step of a release because it writes `path:` entries under `dependencies:` and turns `invalid_dependency` into a warning that fails CI, and `publish.sh` runs `dart format lib/` per package so a formatting pre-check belongs before the release starts

---

## 6.2.0 - 2026-10-07

### Changes

- Bump `zorphy` / `zorphy_annotation` to `^2.4.3` (from `^2.4.0`). The 2.4.3 generators add a `copyWithField<T>(Field<TEntity, T> field, T value)` method to every entity family, which delegates to `copyWith` and never mutates the receiver. Entity JSON output is unchanged — regenerating produced **no** `.g.dart` diffs. The two hand-written `TrustedWebActivityDisplayMode` implementations (`TrustedWebActivityDefaultDisplayMode`, `TrustedWebActivityImmersiveDisplayMode`) now satisfy the widened interface: the fieldless default mode rejects every field name, and the immersive mode routes `displayCutoutMode` / `isSticky` through its parameterless `copyWith`

### Features

- [macOS] WebAuthn / passkey support via a JS→native bridge. `navigator.credentials.create` / `.get` with `publicKey` options are intercepted by an injected shim (`PasskeysJS.swift`, installed as a `WKUserScript` at `documentStart` in every frame) and forwarded over the plugin's JS-handler channel to a native `PasskeyBridge.swift` driving `ASAuthorizationController`, which hands a WebAuthn-shaped `PublicKeyCredential` back to JS. This bypasses WebKit's in-page WKWebView mediation, which is broken for entitled custom-browser apps — `ASCAgent` dies with `AuthorizationError Code=1` ~2 ms after "Allowing request from web browser." and no sheet is ever shown. WebAuthn options map onto platform registration/authentication requests (`rpId` defaulting to `location.hostname`, COSE algorithm identifiers, `excludeCredentials`/`allowCredentials`, `attestation`, `userVerification`, `residentKey` on macOS 14.4+); results serialize back as base64url and failures surface as real `DOMException`s — `NotAllowedError` for user cancel / timeout / no credentials, `TypeError` for malformed options, `SecurityError` for a non-domain `rpId`. Headless webviews fail fast with `NotAllowedError`, `PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable()` bridges to native availability, and non-`publicKey` credentials fall through to the platform default implementation (#358)
- [macOS] An example WebAuthn passkey test page plus a local relying-party host, wired into the example drawer, for manual passkey validation

### Bug Fixes

- [iOS] `contentBlockers` no longer silently drops the initial navigation. The first load was issued only from inside the `WKContentRuleListStore.compileContentRuleList` completion, so a compilation error, a `(nil, nil)` completion, or an undelivered completion left the webview blank with no `onLoadStart` and no `onLoadError` — no error, no logs. iOS now mirrors the macOS #338 machinery: a shared `applyContentBlockers` funnel (stale-completion token, guarded add, main-thread completion) plus a `loadAfterContentRuleLists` gate that holds the initial load until compilation settles on success **and** on error; the content-rule store identifier is now derived from a SHA-256 of the rule content instead of a fixed `ContentBlockingRules` identifier that was recompiled across launches and webviews. Wired through `makeInitialLoad`, `InAppBrowserWebViewController.viewDidLoad` and `setSettings`. `URLRequest(fromPluginMap:)` now logs the rejected url before the `about:blank` fallback (#349)
- [macOS] `URLResponse.suggestedFilename` is `String?` on macOS, so the empty-filename → `nil` mapping added for #345 did not compile and broke the build. The property is now bound to a non-optional local with `?? ""` before the emptiness check — the idiom already used throughout `InAppWebView.swift` — so a nil name unwraps to `""` and still maps to `nil`, preserving both the intended behavior and the pinned `X.isEmpty ? nil : X` shape (#346)
- [macOS] `onDownloadStartRequest` drops a malformed download event instead of throwing out of the decode (#346)

### Internal

- CI now compiles the macOS Swift sources. A `build-macos` job (`macos-15`) builds the example app from this checkout via a `pubspec_overrides.yaml` path override, taking the matrix from 15 to 17 jobs. This closes a real gap: the macOS package's tests are source-contract tests that read the `.swift` files as text and assert on their shape, so they pass on Swift that does not compile — before this job landed, all 73 of them passed while nothing compiled the package at all. A green macOS test run is a floor, not evidence of compilation (#347)
- `scripts/publish.sh` analyzes with `--no-fatal-infos`, matching the CI gate. Bare `flutter analyze` exits 1 on every package's tolerated info baseline, which under `set -e` aborted the release before the first package shipped
- `PasskeyBridge` compiles against the macOS SDK surface rather than the iOS one: `ASCOSEAlgorithmIdentifier` on macOS (`ASAuthorizationCOSEAlgorithmIdentifier` is iOS-only), the excluded-credentials protocol guarded to macOS 13.5+, no `residentKeyPreference` on the platform registration request (it exists only on the security-key request, already guarded at macOS 14.4), and `ASAuthorizationController.cancel()` guarded to macOS 13.0+
- Passkey option errors are carried in a private `PasskeyOptionError` struct instead of a `(String, String)` tuple — Swift's `Result` requires its `Failure` to conform to `Error` and tuples do not (same shape as `ProxyManager`'s private `ProxyConfigurationError`)
- Every gap above is guarded by tests runnable on any host, including a red-phase source-contract regression gate for the iOS content-rule load path (`content_blockers_initial_load_test`) and the passkey bridge (`passkey_bridge_test`); the macOS bridge also clears a real compile gate (`flutter build macos --debug`)
- The spec-kit fleet extension set is installed and the `worktrees` extension removed, putting the triage/assess workflow on the default branch so a fresh clone already has `speckit-bug-assess` / `speckit-chore-assess` / `speckit-gh-triage`. Installed: `spec-stats`; already present: `bug`, `chore`, `gh-triage`, `gym`, `tdd`, `git`. No source files change

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
