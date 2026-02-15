# InAppWebView v4 Modernization Plan

This document outlines the refactoring and modernization strategy for the `zikzak_inappwebview` plugin, moving to version 4.0.0. The primary goals are to leverage modern Android and iOS WebView features, improve performance, and maintain a platform-agnostic core architecture.

## Phase 1: Foundation Reset (Completed)
- [x] Remove all deprecated platform-specific options classes (`AndroidInAppBrowserOptions`, `IOSInAppBrowserOptions`, etc.).
- [x] Unify settings into `InAppWebViewSettings`, `InAppBrowserClassSettings`, etc.
- [x] Remove deprecated parameters from method signatures (e.g., `options`, `androidHistoryUrl`, `iosAnimated`).
- [x] Clean up `PlatformWebViewCreationParams` and related widget/headless parameters.
- [x] Resolve linter errors and ensure strict typing.

## Phase 2: Core Refactor & API Standardization (In Progress)
- [x] **Standardize Event Names**: Ensure all events use modern, descriptive names (e.g., `onReceivedError` instead of `onLoadError`).
- [x] **Unified Settings Architecture**: Ensure `InAppWebViewSettings` contains all modern flags for both platforms, using `@ExchangeableObject` for code generation.
- [x] **WebUri Integration**: Fully transition all URL-related fields to `WebUri`.
- [x] **Controller Decoupling**: Refactor `PlatformInAppWebViewController` to be more modular, separating concerns like Navigation, Security, and JavaScript evaluation.

## Phase 3: Modern Feature Integration (Android) (Completed)
- [x] **WebMessageListener**: Implement `WebMessageListener` for safer and more efficient two-way communication between JavaScript and modern Android code.
- [x] **ProxyController**: Add support for configuring proxies dynamically.
- [x] **X-Requested-With Header**: Implement the new opt-in API for the `X-Requested-With` header.
- [x] **Handwriting & Drag-and-Drop**: Add settings and support for Android's latest input features.
- [x] **Origin Trials**: Enable support for Chrome Origin Trials in WebView (Native Support).
- [x] **SafeBrowsing**: Ensure full compatibility with the latest Safe Browsing APIs and threat types.

## Phase 4: Modern Feature Integration (iOS) (Completed)
- [x] **WKContentWorld**: Integrate `WKContentWorld` for better isolation of User Scripts, preventing interference with the page's own JavaScript.
- [x] **WKWebsiteDataStore**: Enhance cookie and website data management.
- [x] **JavaScript Fullscreen API**: Support the native JavaScript Fullscreen API.
- [x] **HTTPS-only Mode**: Add support for enforcing HTTPS-only connections.
- [x] **Find Interaction**: Ensure full integration with `UIFindInteraction`.

## Phase 5: Platform Support Restoration (Low Priority)
- [ ] **Desktop Support**: Restore and modernize support for Windows, macOS, and Linux using their respective native WebView engines (WebView2, WKWebView, WebKitGTK).
- [ ] **Web Support**: Update and optimize the Web implementation.

## Phase 6: Performance & Security
- [ ] **SecurityCoordinator**: Implement a unified `SecurityCoordinator` for handling SSL/TLS challenges and certificate pinning.
- [ ] **Optimization**: Reduce MethodChannel overhead and optimize memory usage for large content.
- [ ] **Automated Testing**: Expand the test suite to cover new v4 features and ensure stability across all platforms.

---
*This plan is a living document and will be updated as implementation progresses.*
