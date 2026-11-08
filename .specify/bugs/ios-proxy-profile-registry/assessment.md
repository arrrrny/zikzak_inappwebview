# Bug Assessment: iOS ProxyController drops profileId — per-profile data stores never receive a proxy

- **Slug**: ios-proxy-profile-registry
- **Created**: 2026-11-08
- **Source**: pasted text (Ahmet, via Vibe session 2026-11-08, screenshots of the Zuraffa Browser iOS app)
- **Verdict**: valid
- **Severity**: high (framework-class plugin bug: the consumer's flagship proxy feature is silently dead on iOS for every isolated profile)

## Report (verbatim, condensed)

> "On ios I enabled global proxy yet it does not aut activate it"

Screenshots show the Zuraffa Browser iOS app with the Managed Proxy toggle ON ("Routed via proxy.zuzu.dev") while a whatismyipaddress.com tab reports the direct Türk Telekom IP — traffic never egresses through the proxy. The third screenshot shows the per-profile dialog ("Proxy: profile 1"): profile 1 is an isolated profile with its own persistent `WKWebsiteDataStore`.

## Symptom

On iOS, enabling the global proxy (managed or custom) never routes the profiles' traffic: the proxy configuration is written only to `WKWebsiteDataStore.default()`, while every isolated profile WebView uses its own persistent data store created from `persistentStoreIdentifier` — which never receives any proxy configuration. macOS is unaffected: the macOS `ProxyManager` keeps a per-profile registry applied at data-store creation.

## Reproduction

1. Launch the Zuraffa Browser iOS app with >=2 profiles (an isolated profile, e.g. "profile 1", active).
2. Open Global Proxy -> toggle Managed Proxy ON -> Save (dialog shows "Routed via proxy.zuzu.dev").
3. Open a whatismyipaddress.com tab in the isolated profile.
4. Observed: the page reports the user's direct ISP IP. Expected: the proxy egress IP.

The shared/default profile (identifier-less store, `WKWebsiteDataStore.default()`) does receive the configuration, so the bug hides whenever the default profile is the only one tested.

## Suspected Code Paths

- `zikzak_inappwebview_ios/lib/src/proxy_controller.dart` — `IosProxyController.setProxyOverride` sends only `settings.iOSProxySettings?.toJson()`; `settings.profileId` never crosses the method channel. `clearProxyOverride({String? profileId})` drops the `profileId` argument entirely.
- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/ProxyManager.swift` — `setProxyOverride` writes `WKWebsiteDataStore.default().proxyConfigurations` only; no per-profile registry, no `profileId` handling; `clearProxyOverride` wipes only the default store.
- `zikzak_inappwebview_ios/ios/.../InAppWebView/InAppWebView.swift:886-889` — the persistent store `WKWebsiteDataStore(forIdentifier:)` is created here with no proxy application; the macOS port calls `ProxyManager.applyProxy(forIdentifier:to:)` at exactly this point (zikzak_inappwebview_macos InAppWebView.swift:279).
- Reference implementation (correct): `zikzak_inappwebview_macos/.../ProxyManager.swift` — static `profileProxies: [String: ProxyConfiguration]` registry, `profileId` read from both method-channel calls, `applyProxy(forIdentifier:to:)` applied by the WebView factory.

## Root Cause Hypothesis

High confidence. The iOS port was written against the single-default-store model and predates the consumer's per-profile proxy feature (zuraffa_browser FR-007, issue #91); the macOS port was extended with the profileId registry + creation-time application but the iOS port was never given the same treatment, and its Dart-side controller was never taught to forward `ProxySettings.profileId` (a field the platform interface has documented for exactly this purpose). Both halves of the iOS chain must be fixed; either alone leaves the feature dead.

## Proposed Remediation

**Preferred**: mirror the macOS implementation exactly, on both sides of the channel:

1. Dart `IosProxyController`: forward `settings.profileId` in `setProxyOverride` args and honor the `profileId` parameter in `clearProxyOverride` (identical shape to the macOS controller).
2. Swift `ProxyManager`: add the static `profileProxies` registry; on `setProxyOverride` with a non-empty `profileId`, store the configuration (and keep the default-store write for the shared store); on `clearProxyOverride`, remove only the profiled entry when `profileId` is passed, else wipe the registry; add `public static func applyProxy(forIdentifier:to:)`.
3. Swift `InAppWebView.swift`: at the persistent-store creation site, call `ProxyManager.applyProxy(forIdentifier: id, to: store)` before assigning `configuration.websiteDataStore` (mirroring the macOS call site).
4. Extend the host-runnable source-contract test pattern with an iOS profileId-registry contract so the defect class cannot silently return; `build-ios` CI remains the compile gate.

**Alternatives**: none worth the divergence — the macOS port is the proven, consumer-tested design; anything else forks the semantics per platform.

**Files likely to change**:

- `zikzak_inappwebview_ios/lib/src/proxy_controller.dart`
- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/ProxyManager.swift`
- `zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift`
- `zikzak_inappwebview_ios/test/` (new contract test)
- `zikzak_inappwebview_ios/CHANGELOG.md`

**Tests to add or update**:

- Source-scan contract test (host-runnable, no Xcode): Dart controller forwards `profileId` on set/clear; Swift registry exists; `setProxyOverride`/`clearProxyOverride` honor `profileId`; `InAppWebView` creation site applies the registry to the persistent store.

## Risks & Considerations

- `proxyConfigurations` applies to web content processes created after it is set (a WebKit constraint identical on macOS): already-open WebViews pick the route up when their store is re-created (existing macOS behavior, mirrored, not worsened).
- `@available(iOS 17.0, *)` guards: `applyProxy` lives on the availability-scoped `ProxyManager`; the call site sits inside an existing `#available(iOS 17.0, *)` branch.
- Channel shape change (`profileId` added to the args map) is additive; the native side reads it optionally, so mixed-version embedders keep working.

## Open Questions

- None blocking.
