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
