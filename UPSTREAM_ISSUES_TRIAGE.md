# flutter_inappwebview Upstream Issues — Triage & Analysis

**Source:** https://github.com/pichillilorenzo/flutter_inappwebview/issues  
**Total Open Issues:** 156  
**Analysis Date:** 2026-06-03  
**Last Updated:** 2026-06-03 (changes applied during session)

This document categorizes and prioritizes all 156 open issues from the upstream repository to help us track which issues apply to our fork.

---

## Triage Summary

### By Priority

| Priority        | Count   | Criteria                                                          |
| --------------- | ------- | ----------------------------------------------------------------- |
| 🔴 **Critical** | ~30     | App crashes, security vulnerabilities, major platform regressions |
| 🟠 **High**     | ~40     | Feature gaps, non-crashing bugs, missing platform support         |
| 🟡 **Medium**   | ~45     | Minor bugs, usability issues, warnings, docs                      |
| 🟢 **Low**      | ~30     | Showcase apps, questions, feature requests without clear demand   |
| ✅ **Resolved** | **~18** | **Issues closed or not applicable to our fork**                   |

### By Type

| Type          | Count | Description                     |
| ------------- | ----- | ------------------------------- |
| `bug`         | ~95   | Defects and unexpected behavior |
| `enhancement` | ~41   | Feature requests                |
| `showcase`    | ~4    | App showcase submissions        |
| (unlabeled)   | ~16   | Questions, discussions          |

### By Affected Platform

| Platform       | Issue Count |
| -------------- | ----------- |
| Android        | ~45         |
| iOS            | ~40         |
| Windows        | ~25         |
| macOS          | ~12         |
| Linux          | ~8          |
| Web            | ~8          |
| Cross-platform | ~18         |

---

## ✅ Resolved / Not Applicable in Our Fork

The following issues have been closed on our repo as already addressed or not applicable:

| Upstream Issue        | Reason                                                                |
| --------------------- | --------------------------------------------------------------------- |
| #2700                 | `setAllowUniversalAccessFromFileURLs` — API removed from our codebase |
| #2842 / #2841         | SPM support — already implemented (Package.swift)                     |
| #2703                 | 16KB page size — AGP 8.5.2 handles automatically                      |
| #2846                 | Built-in Kotlin — our Android code is pure Java, no KGP               |
| #2536                 | CWE-502 — `getSerializable()` removed from our codebase               |
| #2178                 | R8 BackEvent — AGP 8.5.2 with clean proguard rules                    |
| #2641 / #2685 / #1627 | Java deprecation warnings — largely cleaned up                        |
| #2728                 | Android 15 edge-to-edge APIs — SDK 35 guards applied                  |
| #2757                 | pana analysis failure — analysis_options.yaml fixed                   |
| #2735                 | Windows transparentBackground — not applicable (pure Dart)            |
| #2840                 | Windows MSVCP140 crash — not applicable (no C++ code)                 |
| #2725                 | Windows getTitle returns URL — not applicable (pure Dart)             |
| #2812                 | Windows pageZoom — not applicable (different architecture)            |
| #2733                 | Windows crash on process exit — not applicable (pure Dart)            |
| #2814                 | Windows multi-window exit — not applicable (pure Dart)                |
| #2752                 | Windows crash on certain computers — not applicable                   |
| #2789 / #2692         | Windows desktop click-blocking — not applicable                       |
| #2736                 | Windows HTML INPUT focus — not applicable                             |
| #2839                 | Windows /await compiler error — not applicable (no C++)               |
| #2682                 | Windows release crash — not applicable                                |
| #2627                 | Web resource response warning — not applicable                        |
| #2687                 | syncReleaseLibJars FAILED — different build config                    |

---

## 🔴 Critical Issues (Should Track Immediately)

### Crashes & Stability

| #    | Title                                                               | Platform     | Summary                                                                     |
| ---- | ------------------------------------------------------------------- | ------------ | --------------------------------------------------------------------------- |
| 2843 | `onWebViewCreated` never fires on ~50% of release-build cold starts | Android      | JS bridge security path causes silent crash; fix defers bridge registration |
| 2654 | Crashing on dispose with EXC_BAD_ACCESS                             | iOS, Android | Crash on navigation away with `dispose()`                                   |
| 2600 | iOS app CRASH when using `windowId` in `InAppWebView`               | iOS          | SIGSEGV crash when pushing webview with windowId                            |
| 2584 | Crash on startup in iOS 18.4 Simulator                              | iOS          | `libswiftWebKit.dylib` missing in iOS 18.4 simulator                        |
| 2636 | App Crash on iOS 18.5 Simulator                                     | iOS          | Same dylib issue on 18.5                                                    |
| 2619 | `callAsyncJavaScript` crashes on macOS Intel release builds         | macOS Intel  | SIGSEGV on release, works in debug                                          |
| 2555 | NullPointerException on Android 10                                  | Android      | InputMethodManager crash on Android 10                                      |
| 2733 | Application Crash on Windows Process Exit                           | Windows      | Static object destruction order issue                                       |
| 2752 | Windows crash on certain computers                                  | Windows      | EXCEPTION_ACCESS_VIOLATION                                                  |
| 2682 | Windows release collapse                                            | Windows      | Debug works, release crashes                                                |
| 2512 | Windows app crash after exit, Problem Reporting                     | Windows      | Crash on exit with `dcomp.dll`                                              |
| 2814 | Multi-window: closing child window exits entire app                 | Windows      | `findInteractionController` causes app exit                                 |
| 2840 | Windows native MSVCP140 access violation                            | Windows      | WebView2 C++ exception unwind crash                                         |
| 2778 | Linux crash on Arch Linux                                           | Linux        | GLib-GObject critical errors                                                |

### Build Failures

| #    | Title                                               | Summary                          |
| ---- | --------------------------------------------------- | -------------------------------- |
| 2839 | Windows `/await` compiler option error              | STL1011 error with VS 18.6+      |
| 2796 | webview_flutter_android Pigeon build failure        | Missing Pigeon-generated classes |
| 2687 | `syncReleaseLibJars FAILED`                         | Android release build failure    |
| 2178 | R8 minification: missing `android.window.BackEvent` | Android release build failure    |

### Security

| #    | Title                                               | Summary                                    |
| ---- | --------------------------------------------------- | ------------------------------------------ |
| 2700 | `setAllowUniversalAccessFromFileURLs` security risk | Dangerous file access enabled by default   |
| 2536 | CWE-502: Insecure deserialization                   | `Bundle.getSerializable()` used insecurely |
| 2745 | `eval()` in `web_support.js`                        | Security risk in iframes                   |
| 2834 | Sec-CH-UA client hints cannot be suppressed         | WebView fingerprinting                     |

### Platform Migration (Will Become Errors)

| #    | Title                                        | Summary                                | Status                 |
| ---- | -------------------------------------------- | -------------------------------------- | ---------------------- |
| 2846 | Migrate to Built-in Kotlin                   | AGP 9.0 will remove KGP support        | ✅ Already pure Java   |
| 2842 | Swift Package Manager support for iOS        | Flutter will require SPM               | ✅ Already implemented |
| 2841 | Request Swift Package Manager adoption       | Same issue, duplicate                  | ✅ Already implemented |
| 2703 | Support 16 KB Page Size (Android new policy) | Required for Google Play from Nov 2025 | ✅ AGP 8.5.2 handles   |

---

## 🟠 High Priority

### Android Issues

| #    | Title                                                     | Summary                                    |
| ---- | --------------------------------------------------------- | ------------------------------------------ |
| 2837 | White screen after device locked for ~15 min              | WebView white screen, recovers on touch    |
| 2819 | `onExitFullscreen` never fires on MediaTek devices        | GPU/buffer failure during fullscreen video |
| 2791 | `shouldOverrideUrlLoading` breaks browsing context        | `window.opener` lost                       |
| 2728 | Deprecated navigation/status bar color APIs on Android 15 | Play Console warnings                      |
| 2680 | `ERR_FAILED` fetching mp3 on mobile data                  | SDK 35 regression                          |
| 2673 | `WebSettingsWrapper` cannot be cast on Huawei/Honor       | `setForceDarkStrategy` crash               |
| 2659 | Input time picker plus/minus button crashes app           | NullPointerException                       |
| 2695 | Host not resolved after background for 5 min              | `about:blank` loads unexpectedly           |
| 2697 | Multi-window mode distorted on Galaxy Fold                | Content area issues on foldables           |
| 2660 | Support `WebViewFeature.PAYMENT_REQUEST` (Google Pay)     | Missing payment support                    |

### iOS Issues

| #    | Title                                                                     | Summary                           |
| ---- | ------------------------------------------------------------------------- | --------------------------------- |
| 2831 | iOS 26 Location Prompt not closable                                       | Native dialog can't be tapped     |
| 2830 | Xcode 26.4.1 compilation error                                            | `presentationAnchor` availability |
| 2824 | iOS device `processDidBecomeUnresponsive`                                 | URL won't load                    |
| 2813 | WebAuthenticationSession crash on macOS with Xcode 26.4                   | Same protocol issue               |
| 2713 | WebView Touch Not Working After Drawer Closes on iOS 26                   | Touch state stuck                 |
| 2723 | WebView inside ListView stops responding to clicks after scroll on iOS 26 | Gesture conflict                  |
| 2727 | After `showModalBottomSheet`/`showDialog`, page unresponsive on iOS 26    | JS becomes unresponsive           |
| 2710 | Fullscreen video turns black after seek on iOS 26                         | WKWebView fullscreen regression   |
| 2651 | Link redirections and YouTube not working on iOS 18.4+                    | Tap interactions broken           |
| 2648 | `CANNOT_PARSE_RESPONSE` on Google search iOS 18.4                         | Specific to iPhone 16 Pro         |
| 2669 | Cursor not visible inside input field on iOS                              | Text input usability              |
| 2763 | `onCreateWindow` return value ignored on iOS                              | Window management broken          |

### Windows Issues

| #    | Title                                                  | Summary                              |
| ---- | ------------------------------------------------------ | ------------------------------------ |
| 2789 | Desktop click-blocking overlay persists after minimize | WebView blocking desktop interaction |
| 2692 | Can't click desktop when window minimized              | Same issue                           |
| 2736 | Focus issues in HTML INPUTs                            | Focus lost on second input           |
| 2783 | Cookies not saved, scroll not working                  | Missing features                     |
| 2820 | CMake warning (CMP0175)                                | CMake policy warning                 |
| 2735 | `transparentBackground` doesn't work on Windows        | Logic inverted in C++ code           |
| 2725 | `getTitle()` incorrectly returns URL on Windows        | Wrong method called                  |
| 2717 | `onReceivedClientCertRequest` not firing on Windows    | Missing implementation               |
| 2812 | Request: Windows `pageZoom` support                    | Feature parity with macOS            |
| 2805 | ProxyController support for Windows                    | Missing proxy API                    |
| 2672 | CMake warning on Windows build                         | Build quality                        |

### macOS Issues

| #    | Title                                              | Summary                            |
| ---- | -------------------------------------------------- | ---------------------------------- |
| 2826 | macOS WebView frame drifts with fractional width   | Native frame fights Flutter layout |
| 2707 | macOS 26 crash on InAppBrowser window close        | NSToolbar crash on teardown        |
| 2835 | Support custom headers in WebAuthenticationSession | iOS/macOS feature request          |
| 2475 | `transparentBackground` doesn't work on macOS      | Desktop transparency broken        |

### Linux Issues

| #    | Title                                                         | Summary                           |
| ---- | ------------------------------------------------------------- | --------------------------------- |
| 2807 | Bundled WPE is not self-contained                             | Hardcoded paths to `/usr/lib`     |
| 2798 | `loadData`/`loadUrl` not working with `keepAlive` on Linux    | MissingPluginException            |
| 2780 | Compilation error with WebKit < 2.50                          | `webkit_web_view_get_theme_color` |
| 62   | WebKitGTK 4.1 support on Ubuntu Noble                         | Migration from 4.0 needed         |
| 2655 | Crash on Windows due to VC++ redistributable (actually Linux) | Not Linux, but linked             |

### Web Issues

| #    | Title                                                    | Summary                                |
| ---- | -------------------------------------------------------- | -------------------------------------- |
| 2737 | `onLoadStart`/`onLoadStop` always return initial URL     | Cannot get actual URL after navigation |
| 2811 | WASM not supported                                       | Web platform build failure             |
| 2702 | Form submission reloads page on Web                      | Unlike native behavior                 |
| 2412 | `evaluateJavascript` doesn't work on Web platform        | JS execution broken                    |
| 2047 | Web platform: `createPlatformInAppBrowser` unimplemented | Missing feature                        |

### JavaScript Bridge / Communication

| #    | Title                                                       | Summary                   |
| ---- | ----------------------------------------------------------- | ------------------------- |
| 2580 | `shouldInterceptRequest` causes freeze on rapid navigation  | Android deadlock          |
| 2507 | `shouldInterceptRequest` not working on iOS                 | Android-only API          |
| 2568 | Cannot use `shouldOverrideUrlLoading` to add headers on iOS | Deadlock                  |
| 2793 | Add `bridgeEvents` API and typed JS handler helpers         | Enhancement with PR ready |
| 1877 | `window.flutter_inappwebview.callHandler is not a function` | JS bridge inconsistent    |

---

## 🟡 Medium Priority

| #    | Title                                                          | Type        | Platform       |
| ---- | -------------------------------------------------------------- | ----------- | -------------- |
| 2821 | BackdropFilter doesn't work over WebView                       | bug         | All            |
| 2815 | Firebase Auth session storage lost                             | bug         | Android        |
| 2810 | Gesture conflict between WebView and Flutter UI on iOS         | bug         | iOS            |
| 2795 | Gesture conflict with CesiumJS on iOS                          | bug         | iOS            |
| 2787 | Keyboard changes viewport size on iOS 17                       | bug         | iOS            |
| 2782 | AppBar difference emulator vs physical device                  | bug         | Android        |
| 2778 | Linux crash on Arch                                            | bug         | Linux          |
| 2760 | Pull-to-refresh option for no-scroll pages                     | enhancement | Windows        |
| 2762 | Require Flutter 3.38.6+ for iOS touch fix                      | enhancement | iOS            |
| 2753 | `onReceivedError` not triggered on iframe errors (iOS)         | bug         | iOS            |
| 2757 | pana analysis failed on pub.dev                                | bug         | All            |
| 2742 | Flicker when switching tabs with InAppWebView                  | bug         | Android        |
| 2741 | `upgradeKnownHostsToHTTPS` unrecognized selector on macOS 11   | bug         | macOS          |
| 2730 | `CreateWindowAction.targetFrame` always null                   | bug         | Android        |
| 2721 | WebView doesn't adapt to accessibility display size change     | bug         | Android        |
| 2720 | `InAppLocalhostServer` fails after background on iOS           | bug         | iOS            |
| 2718 | Native crash in `MyCookieManager.deleteAllCookies`             | bug         | Android        |
| 2706 | Intercept HTML input operations (like `onShowFileChooser`)     | enhancement | Android        |
| 2688 | Web content flash on Android when navigating to Flutter screen | bug         | Android        |
| 2686 | Web app restarts in Safari                                     | bug         | Web            |
| 2685 | Java 17 deprecated warnings                                    | bug         | Android        |
| 2681 | Blank page when popped back to WebView                         | bug         | All            |
| 2670 | iOS `NSURLErrorDomain error -999` on back navigation           | bug         | iOS            |
| 2668 | `callAsyncJavaScript` below iOS 14.3 broken                    | bug         | iOS            |
| 2667 | Initial WebView loads very slowly                              | bug         | All            |
| 2664 | Rapid tab switching causes WebView delay                       | enhancement | All            |
| 2653 | iOS navigation back error (-999)                               | bug         | iOS            |
| 2645 | No error when no system browser on device                      | bug         | Android        |
| 2642 | Google Sheets dropdown menus not working on Windows            | bug         | Windows        |
| 2641 | Deprecated warnings with Java 17                               | bug         | Android        |
| 2627 | Web resource response conversion warning                       | bug         | Windows        |
| 2598 | Draggable widget over WebView scrolls the site on iOS          | bug         | iOS            |
| 2595 | White padding above keyboard too large on iOS                  | bug         | iOS            |
| 2594 | `WebSettingsWrapper` cast exception on OnePlus                 | bug         | Android        |
| 2590 | `takeScreenshot` MissingPluginException                        | bug         | Android        |
| 2577 | `evaluateJavascript` mouse focus not working on Windows        | bug         | Windows        |
| 2570 | Autofill service not working on iOS                            | bug         | iOS            |
| 2567 | `RenderBox was not laid out: RenderUiKitView` on iOS           | bug         | iOS            |
| 2555 | NullPointerException on Android 10 (InputMethod)               | bug         | Android        |
| 2522 | WebView blocks mouse on desktop when minimized                 | bug         | Windows        |
| 2493 | Android content doesn't scroll up when keyboard opens          | bug         | Android        |
| 2491 | Renderer process crash when navigating back                    | bug         | Android        |
| 2475 | `transparentBackground` not working on desktop                 | bug         | macOS, Windows |
| 2470 | White screen after Flutter 3.27 upgrade                        | bug         | Android        |
| 2412 | `evaluateJavascript` doesn't work on Web                       | bug         | Web            |
| 2340 | BackdropFilter broken over WebView                             | bug         | Web            |
| 2333 | Drag and drop file upload error                                | bug         | Windows        |
| 2326 | NuGet download filename exceeds path limit                     | bug         | Windows        |
| 2227 | Iframe not opening on iOS                                      | bug         | iOS            |
| 2214 | iOS crash when app goes to background and device locks         | bug         | iOS            |
| 2157 | `net::ERR_BLOCKED_BY_ORB`                                      | bug         | All            |
| 2146 | Custom `onShowFileChooser` interface on Android                | enhancement | Android        |
| 2135 | Keyboard doesn't auto-scroll input into view                   | bug         | Android        |
| 2066 | `shouldOverrideUrlLoading` not intercepting clicks             | bug         | Android        |
| 2047 | Web InAppBrowser not implemented                               | bug         | Web            |
| 2032 | iOS crash on `InAppWebView.dispose()`                          | bug         | iOS            |
| 2019 | Add testing example to docs                                    | docs        | All            |
| 2014 | App crash with client-side exception on Android                | bug         | Android        |
| 1974 | Request focus for WebView                                      | enhancement | All            |
| 1877 | `callHandler is not a function`                                | bug         | Android        |
| 1744 | Text selection cursor color customization                      | enhancement | All            |
| 1684 | `getUrl` MissingPluginException                                | bug         | Android        |
| 1682 | JS bridge not supported on Web                                 | bug         | Web            |
| 1627 | Deprecated API warnings                                        | bug         | Android        |
| 1551 | `close` MissingPluginException (ChromeSafariBrowser)           | bug         | Android        |
| 1277 | HUAWEI GPU crash                                               | bug         | Android        |
| 1144 | Customize file upload options in WebView                       | enhancement | All            |

---

## 🟢 Low Priority (Showcase / Questions / Minor)

| #    | Title                                         | Type        |
| ---- | --------------------------------------------- | ----------- |
| 2822 | WebSpace app showcase                         | showcase    |
| 2811 | WASM support request                          | enhancement |
| 2805 | ProxyController for Windows (has PR)          | enhancement |
| 2769 | Smart Camera showcase                         | showcase    |
| 2716 | FlowFerry showcase                            | showcase    |
| 2691 | Windows build warnings                        | enhancement |
| 2664 | Rapid tab switching delay                     | enhancement |
| 2644 | "Is this project maintained?" question        | question    |
| 2600 | iOS crash with windowId (duplicate of others) | duplicate   |
| 2212 | How to download Blob files (tutorial)         | tutorial    |
| 460  | Flutter Desktop support (already supported!)  | enhancement |

---

## Recommended Action Plan

### Updated Action Plan

### ✅ Phase 1 — Completed (This Session)

- **Fixed critical crashes**: #2843 (onWebViewCreated 50% crash) — deferred JS bridge to View.post()
- **Addressed security issues**: #2700, #2536 — already resolved in codebase; #2745 — still open (eval())
- **Platform migration**: #2846 (Built-in Kotlin — already pure Java), #2842 (SPM — already implemented), #2703 (16KB — AGP 8.5.2)
- **Fixed build failures**: #2178, #2687 — already handled; #2796 — needs investigation
- **Merged upstream PRs**: #2729, #2817, #2758, #2638, #2243, #2558, #1679, #2614 (partial)
- **Java deprecation cleanup**: new Handler(Looper), clearSessionCookies(), @SuppressWarnings
- **Android 15 edge-to-edge**: SDK < 35 guards on deprecated nav bar APIs
- **CVE-2020-6563**: Sandbox file access protection in file picker

### Phase 2 — Short Term (Next)

1. **iOS 26/18.4 regressions**: #2831, #2713, #2723, #2727, #2710, #2651, #2648
2. **Remaining high-value PRs**: #2743 (WebAuthn), #2722 (Google Pay), #2823 (Audio intent)
3. **Linux support**: #2807, #2798, #2780, #62
4. **Web parity**: #2737, #2412, #2047, #2702

### Phase 3 — Medium Term

1. **Feature requests with PRs**: #2805 (Proxy Windows), #2793 (bridgeEvents), #2812 (pageZoom Windows), #2835 (auth session headers)
2. **Long-standing bugs**: #2580 (shouldInterceptRequest freeze), #2507 (iOS request intercept), #1877 (callHandler), #2135 (keyboard)
3. **Remaining deprecation cleanup**: #2745 (eval() in web_support.js), cleanup of setForceDark, etc.
4. **Documentation**: #2019 (testing examples)
