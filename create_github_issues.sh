#!/bin/bash

# ZikZak InAppWebView - GitHub Issues Creation Script
# This script creates all issues for the modernization plan
# Run: chmod +x create_github_issues.sh && ./create_github_issues.sh

set -e

REPO="arrrrny/zikzak_inappwebview"

echo "Creating GitHub issues for ZikZak InAppWebView modernization..."
echo "Repository: $REPO"
echo ""

# ============================================================================
# 1. CRITICAL SECURITY ISSUES
# ============================================================================

echo "[1/35] Creating security issue: Remove JavaScript-based CSP injection"
gh issue create \
  --repo "$REPO" \
  --title "[SECURITY] Remove JavaScript-based CSP injection" \
  --label "security,breaking-change,android" \
  --body "## Problem
The current ZikZakSecurityManager injects Content-Security-Policy via JavaScript (\`evaluateJavascript\`), which is fundamentally insecure and bypassable.

**File:** \`ZikZakSecurityManager.java:579-591\`

## Security Risk
- JavaScript-based CSP can be bypassed by attackers
- Not as reliable as HTTP header-based CSP
- False sense of security

## Solution
Implement proper HTTP header-based Content Security Policy:
1. Intercept requests using \`shouldInterceptRequest\`
2. Add CSP headers to responses
3. Remove JavaScript-based injection code

## Impact
- **Breaking Change:** Applications relying on JS-based CSP may need updates
- **Security:** Significantly improves security posture

## Priority
🔴 CRITICAL - Must fix before v3.0 release

## References
- [OWASP CSP](https://owasp.org/www-community/controls/Content_Security_Policy)
- [MDN CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)"

echo "[2/35] Creating security issue: Implement certificate pinning"
gh issue create \
  --repo "$REPO" \
  --title "[SECURITY] Implement SSL/TLS certificate pinning" \
  --label "security,enhancement,android,ios" \
  --body "## Problem
No certificate pinning support for secure connections, leaving applications vulnerable to MITM attacks.

## Solution
### Android
Implement certificate pinning using:
- \`CertificatePinner\` from OkHttp (for network requests)
- \`onReceivedSslError\` override with certificate validation
- Pin public keys or certificates

### iOS
Implement certificate pinning using:
- \`WKNavigationDelegate.didReceive(challenge:)\`
- \`URLSession\` challenge handling
- Pin public keys using Security framework

## API Design
\`\`\`dart
InAppWebView(
  certificatePinningConfig: CertificatePinningConfig(
    certs: [
      CertificatePin(
        hostname: 'example.com',
        publicKeyHashes: ['sha256/AAAAAAAAAAAAAAAA...'],
        includeSubdomains: true,
      ),
    ],
    allowExpiredCertificates: false,
  ),
)
\`\`\`

## Priority
🔴 CRITICAL

## References
- [OWASP Certificate Pinning](https://owasp.org/www-community/controls/Certificate_and_Public_Key_Pinning)"

echo "[3/35] Creating security issue: Fix JavaScript execution security model"
gh issue create \
  --repo "$REPO" \
  --title "[SECURITY] Fix JavaScript execution security model" \
  --label "security,breaking-change,android,ios" \
  --body "## Problem
1. JavaScript is enabled by default (security risk)
2. Arbitrary code execution via \`evaluateJavascript()\` without validation
3. No request signing for JS bridge communication

## Solution
1. **Disable JavaScript by default**
   - Breaking change, but more secure
   - Users must explicitly enable it

2. **Implement secure JavaScript bridge**
   - Add request signing/verification
   - Implement allowlist for JavaScript handlers
   - Add rate limiting for JS bridge calls

3. **Validate JavaScript before execution**
   - Add CSP enforcement
   - Sandbox JavaScript execution (iOS: WKContentWorld)

## Implementation
### iOS
\`\`\`swift
// Use WKContentWorld for isolation
let userScript = WKUserScript(
  source: jsCode,
  injectionTime: .atDocumentStart,
  forMainFrameOnly: true,
  in: .page // Use isolated world
)
\`\`\`

### Android
\`\`\`java
// Disable JavaScript by default
webSettings.setJavaScriptEnabled(false);

// Add request signing for JS bridge
JavaScriptBridge bridge = new SecureJavaScriptBridge(signature);
webView.addJavascriptInterface(bridge, \"bridge\");
\`\`\`

## Priority
🔴 CRITICAL

## Breaking Changes
- JavaScript disabled by default
- JS bridge API changes"

echo "[4/35] Creating security issue: Implement HTTPS-only mode"
gh issue create \
  --repo "$REPO" \
  --title "[SECURITY] Implement HTTPS-only mode" \
  --label "security,enhancement,android,ios" \
  --body "## Problem
HTTP connections are allowed by default, exposing users to MITM attacks and unencrypted data transmission.

## Solution
Add \`enforceHTTPS\` option with strict mode:

### Android
\`\`\`java
if (enforceHTTPS && !url.startsWith(\"https://\")) {
    return super.shouldOverrideUrlLoading(view,
        request.getUrl().toString().replaceFirst(\"http://\", \"https://\"));
}
\`\`\`

### iOS
\`\`\`swift
func webView(_ webView: WKWebView,
             decidePolicyFor navigationAction: WKNavigationAction,
             decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if enforceHTTPS && navigationAction.request.url?.scheme == \"http\" {
        // Upgrade to HTTPS
        if let httpsURL = upgradeToHTTPS(navigationAction.request.url) {
            webView.load(URLRequest(url: httpsURL))
            decisionHandler(.cancel)
            return
        }
    }
    decisionHandler(.allow)
}
\`\`\`

## API Design
\`\`\`dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    enforceHTTPS: true, // Default: false for backward compatibility
    httpsUpgradeStrategy: HTTPSUpgradeStrategy.strict,
  ),
)
\`\`\`

## Priority
🔴 HIGH"

echo "[5/35] Creating security issue: Fix URL validation with scheme checking"
gh issue create \
  --repo "$REPO" \
  --title "[SECURITY] Fix URL validation - Add scheme checking" \
  --label "security,bug,android,ios" \
  --body "## Problem
Current URL validation only checks the host, forgetting about the scheme. This leaves the app vulnerable to \`javascript:\` scheme attacks.

**Vulnerability:**
\`\`\`javascript
javascript:alert(document.cookie)
\`\`\`

## Solution
Implement comprehensive URL validation:

\`\`\`java
// Android
private boolean isURLSafe(String url) {
    if (url == null || url.isEmpty()) return false;

    // Check scheme first
    Uri uri = Uri.parse(url);
    String scheme = uri.getScheme();

    if (scheme == null) return false;

    // Only allow safe schemes
    List<String> allowedSchemes = Arrays.asList(\"http\", \"https\", \"file\", \"data\");
    if (!allowedSchemes.contains(scheme.toLowerCase())) {
        Log.w(TAG, \"Blocked unsafe URL scheme: \" + scheme);
        return false;
    }

    // Then validate host
    String host = uri.getHost();
    // ... existing host validation ...

    return true;
}
\`\`\`

## Priority
🔴 CRITICAL

## References
- [OWASP URL Validation](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
- [Oversecured Android WebView Checklist](https://blog.oversecured.com/Android-security-checklist-webview/)"

echo "[6/35] Creating security issue: Enable Safe Browsing by default"
gh issue create \
  --repo "$REPO" \
  --title "[SECURITY] Enable Android Safe Browsing by default" \
  --label "security,enhancement,android" \
  --body "## Problem
Android Safe Browsing API is not enabled by default, leaving users vulnerable to known phishing and malware sites.

## Solution
Enable Safe Browsing by default on Android:

\`\`\`java
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
    webSettings.setSafeBrowsingEnabled(true);
}

// Handle Safe Browsing hits
@Override
public void onSafeBrowsingHit(WebView view,
                              WebResourceRequest request,
                              int threatType,
                              SafeBrowsingResponse callback) {
    // Log the threat
    Log.w(TAG, \"Safe Browsing detected threat: \" + threatType);

    // Show warning to user or block automatically
    if (settings.blockMaliciousSites) {
        callback.backToSafety(true);
    } else {
        callback.showInterstitial(true);
    }
}
\`\`\`

## API Design
\`\`\`dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    safeBrowsingEnabled: true, // Default: true
    blockMaliciousSites: true, // Default: false (show interstitial)
  ),
)
\`\`\`

## Priority
🟡 MEDIUM

## References
- [Android Safe Browsing](https://developer.android.com/guide/webapps/managing-webview#safe-browsing)"

echo "[7/35] Creating security issue: Implement security audit logging"
gh issue create \
  --repo "$REPO" \
  --title "[SECURITY] Implement security audit logging" \
  --label "security,enhancement,android,ios" \
  --body "## Problem
No audit trail for security events, making it difficult to:
- Debug security issues
- Monitor suspicious activity
- Comply with security requirements

## Solution
Implement comprehensive security event logging:

### Events to Log
1. Certificate validation failures
2. HTTPS upgrade attempts
3. Blocked requests (trackers, malicious sites)
4. JavaScript execution attempts
5. File access attempts
6. Cookie/storage access
7. Permission requests

### Implementation
\`\`\`dart
// Dart API
InAppWebView(
  onSecurityEvent: (SecurityEvent event) {
    print('Security event: \${event.type}');
    print('Details: \${event.details}');
    print('Timestamp: \${event.timestamp}');

    // Send to analytics/logging service
    securityLogger.log(event);
  },
)

enum SecurityEventType {
  certificateError,
  httpsUpgrade,
  blockedRequest,
  javascriptExecution,
  unauthorizedFileAccess,
  safeBrowsingHit,
}
\`\`\`

## Priority
🟡 MEDIUM"

# ============================================================================
# 2. CRITICAL BUG FIXES
# ============================================================================

echo "[8/35] Creating bug fix: iOS 18.4/18.5 crashes"
gh issue create \
  --repo "$REPO" \
  --title "[BUG] Fix iOS 18.4/18.5 startup crashes" \
  --label "bug,ios,critical" \
  --body "## Problem
Application crashes immediately upon launch on iOS 18.4 and iOS 18.5.

**Related Issues:** Original repo #2584, #2636

## Root Cause
WKWebView API changes in iOS 18.4+ causing compatibility issues with existing delegate implementations.

## Solution
1. Audit all WKWebView delegate methods for iOS 18.4+ compatibility
2. Update delegate implementations
3. Add iOS version checks where necessary
4. Test on iOS 18.4 simulator and real devices

## Investigation Areas
- WKNavigationDelegate method changes
- WKUIDelegate method changes
- WKWebView initialization changes
- Memory management changes

## Priority
🔴 CRITICAL

## Testing
- [ ] Test on iOS 18.4 simulator
- [ ] Test on iOS 18.5 simulator
- [ ] Test on iOS 18.4 physical device
- [ ] Test on iOS 18.5 physical device"

echo "[9/35] Creating bug fix: Xcode 16.1 build failures"
gh issue create \
  --repo "$REPO" \
  --title "[BUG] Fix Xcode 16.1 build failures" \
  --label "bug,ios,critical" \
  --body "## Problem
Build fails with Xcode 16.1 due to WKUIDelegate protocol requirement changes.

**Related Issue:** Original repo #2327

## Root Cause
Xcode 16 introduced stricter protocol conformance requirements and changes to WKUIDelegate methods, particularly around JavaScript evaluation.

## Solution
1. Update WKUIDelegate implementation to conform to Xcode 16 requirements
2. Fix \`evaluateJavaScript\` method signature
3. Add required protocol methods
4. Update Swift code to handle new API requirements

## Files to Update
- \`InAppWebView.swift\`
- \`InAppBrowserWebView.swift\`
- Any classes implementing WKUIDelegate

## Priority
🔴 CRITICAL

## Testing
- [ ] Build with Xcode 16.1
- [ ] Build with Xcode 16.2
- [ ] Verify no warnings
- [ ] Test JavaScript execution"

echo "[10/35] Creating enhancement: Add iOS privacy manifest"
gh issue create \
  --repo "$REPO" \
  --title "[iOS] Add Privacy Manifest (PrivacyInfo.xcprivacy)" \
  --label "enhancement,ios,critical" \
  --body "## Problem
Missing privacy manifest required for App Store compliance.

**Related Issue:** Original repo #1909

## Solution
Add \`PrivacyInfo.xcprivacy\` file to the iOS plugin with proper declarations:

### Required Declarations
1. **API Types Used:**
   - User defaults (if used)
   - File timestamp (if used)
   - System boot time (if used)

2. **Tracking Domains:**
   - List any tracking domains

3. **Data Collection:**
   - Declare what data is collected
   - Purpose of collection
   - Whether it's linked to user identity

### Example Structure
\`\`\`xml
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array/>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <!-- Declare APIs used -->
    </array>
</dict>
</plist>
\`\`\`

## Priority
🔴 CRITICAL (App Store requirement)

## References
- [Apple Privacy Manifest](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)"

echo "[11/35] Creating bug fix: iOS keyboard crashes"
gh issue create \
  --repo "$REPO" \
  --title "[BUG] Fix iOS keyboard crashes with date picker (iOS 17+)" \
  --label "bug,ios,critical" \
  --body "## Problem
App crashes when interacting with date pickers and dropdown selections on iOS 17+ devices. Causes excessive memory usage and EXC_BAD_ACCESS errors.

**Related Issue:** Original repo #2535

## Root Cause
Memory management issues with WKWebView input accessories and keyboard interactions on iOS 17+.

## Solution
1. Optimize memory management for input accessories
2. Fix retain cycles with keyboard observers
3. Implement proper cleanup for input views
4. Add memory pressure handling

## Investigation
\`\`\`swift
// Check for retain cycles in:
- Input accessory view handling
- Keyboard notification observers
- WKWebView input delegates
\`\`\`

## Priority
🔴 CRITICAL

## Testing
- [ ] Test with date picker inputs
- [ ] Test with dropdown selections
- [ ] Monitor memory usage
- [ ] Test on iOS 17.0+
- [ ] Test on physical devices"

echo "[12/35] Creating bug fix: Android closing crashes"
gh issue create \
  --repo "$REPO" \
  --title "[BUG] Fix Android WebView closing crashes" \
  --label "bug,android,critical" \
  --body "## Problem
App crashes when closing InAppWebView on Android.

**Related Issue:** Original repo #1675
**Affected Versions:** 5.7.2+3 (not present in 5.4.3+8)

## Root Cause
Improper cleanup of WebView resources during disposal.

## Solution
Implement proper lifecycle management:

\`\`\`java
@Override
public void dispose() {
    if (webView != null) {
        // Stop all loading
        webView.stopLoading();

        // Remove all views
        webView.removeAllViews();

        // Clear history
        webView.clearHistory();

        // Clear cache
        webView.clearCache(true);

        // Remove from parent
        ViewGroup parent = (ViewGroup) webView.getParent();
        if (parent != null) {
            parent.removeView(webView);
        }

        // Destroy WebView
        webView.destroy();
        webView = null;
    }

    // Clean up handlers and callbacks
    cleanupHandlers();
}
\`\`\`

## Priority
🔴 CRITICAL

## Testing
- [ ] Test closing WebView
- [ ] Test with ongoing navigation
- [ ] Test with active JavaScript
- [ ] Test memory leaks
- [ ] Regression test against v5.4.3+8"

echo "[13/35] Creating bug fix: Zoom functionality"
gh issue create \
  --repo "$REPO" \
  --title "[BUG] Fix zoom functionality not working" \
  --label "bug,android,ios" \
  --body "## Problem
Zoom support is not working properly despite being enabled in settings.

**Related Issue:** Original repo #1554

## Root Cause
Incorrect zoom settings configuration or conflicting viewport meta tags.

## Solution
### Android
\`\`\`java
// Enable zoom controls
webSettings.setSupportZoom(true);
webSettings.setBuiltInZoomControls(true);
webSettings.setDisplayZoomControls(false); // Hide +/- buttons

// Set initial scale
webSettings.setLoadWithOverviewMode(true);
webSettings.setUseWideViewPort(true);
\`\`\`

### iOS
\`\`\`swift
// Enable pinch zoom
webView.scrollView.isScrollEnabled = true
webView.scrollView.minimumZoomScale = 1.0
webView.scrollView.maximumZoomScale = 3.0

// Handle viewport meta tag conflicts
let jsString = \"document.querySelector('meta[name=viewport]')?.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes');\"
webView.evaluateJavaScript(jsString)
\`\`\`

## Priority
🟡 MEDIUM

## Testing
- [ ] Test pinch zoom on Android
- [ ] Test pinch zoom on iOS
- [ ] Test with different viewport settings
- [ ] Test programmatic zoom"

# ============================================================================
# 3. PLATFORM CLEANUP
# ============================================================================

echo "[14/35] Creating platform cleanup: Remove non-target platforms"
gh issue create \
  --repo "$REPO" \
  --title "[BREAKING] Remove macOS, Windows, and Web platform support" \
  --label "breaking-change,enhancement" \
  --body "## Rationale
Focus exclusively on Android and iOS for:
- Cleaner, leaner codebase
- Reduced maintenance burden
- Better focus on core platforms
- Improved code quality

## Changes
### Remove Packages
- ❌ \`zikzak_inappwebview_macos/\`
- ❌ \`zikzak_inappwebview_web/\`
- ❌ Any Windows-related code

### Update Files
- \`pubspec.yaml\` - Remove platform entries
- \`README.md\` - Update platform support documentation
- Platform interface - Remove web/desktop methods

## Migration Path
Users on macOS/Windows/Web should:
1. Stay on v2.x
2. Use alternative packages for those platforms
3. Or contribute platform-specific forks

## Priority
🔵 HIGH (Clean codebase)

## Breaking Changes
✅ This is a major breaking change for v3.0"

echo "[15/35] Creating platform update: Increase minimum Android SDK"
gh issue create \
  --repo "$REPO" \
  --title "[BREAKING] Increase Android minSdk from 19 to 24" \
  --label "breaking-change,android" \
  --body "## Rationale
Increase minSdk from 19 (Android 4.4) to 24 (Android 7.0) for:
- Better security APIs (TLS 1.2 by default, modern crypto)
- Cleaner code (remove legacy workarounds)
- Modern WebView features
- Better performance
- Industry standard (Android 7.0 released in 2016)

## Market Coverage
- Android 7.0+ covers **~94%** of devices (2024 data)
- Android 4.4-6.0 represents only **~6%** of devices

## Benefits
1. **Security:** Modern TLS, better crypto, security patches
2. **Code Quality:** Remove legacy compatibility code
3. **Features:** Access to modern WebView APIs
4. **Performance:** Better optimizations

## Changes
\`\`\`gradle
android {
    defaultConfig {
        minSdkVersion 24  // Was: 19
    }
}
\`\`\`

## Priority
🔵 HIGH

## Breaking Changes
✅ Apps targeting Android 4.4-6.0 must stay on v2.x"

echo "[16/35] Creating platform update: Increase minimum iOS version"
gh issue create \
  --repo "$REPO" \
  --title "[BREAKING] Increase iOS minimum version from 13.0 to 14.0" \
  --label "breaking-change,ios" \
  --body "## Rationale
Increase minimum iOS version from 13.0 to 14.0 for:
- Modern WKWebView APIs (WKContentWorld, etc.)
- Better security features
- Cleaner code
- Industry standard

## Market Coverage
- iOS 14.0+ covers **~97%** of devices (2024 data)
- iOS 13 represents only **~3%** of active devices

## Benefits
1. **WKContentWorld** for JavaScript isolation
2. **Modern Privacy APIs**
3. **Better performance**
4. **Cleaner codebase**

## Changes
\`\`\`ruby
# Podspec
s.platforms = { :ios => '14.0' }
\`\`\`

## Priority
🔵 HIGH

## Breaking Changes
✅ Apps targeting iOS 13 must stay on v2.x"

# ============================================================================
# 4. ARCHITECTURE REFACTORING
# ============================================================================

echo "[17/35] Creating architecture: Refactor Android InAppWebView.java"
gh issue create \
  --repo "$REPO" \
  --title "[ARCHITECTURE] Refactor InAppWebView.java monolithic class" \
  --label "architecture,android,enhancement" \
  --body "## Problem
\`InAppWebView.java\` is **2000+ lines**, violating Single Responsibility Principle.

## Solution
Apply Clean Architecture and SOLID principles:

### New Structure
\`\`\`
InAppWebView.java (Core, ~300 lines)
├── managers/
│   ├── WebViewSettingsManager.java
│   ├── WebViewSecurityManager.java
│   ├── WebViewLifecycleManager.java
│   ├── WebViewJavaScriptBridge.java
│   ├── WebViewNavigationHandler.java
│   └── WebViewContentManager.java
├── delegates/
│   ├── WebViewClientDelegate.java
│   └── ChromeClientDelegate.java
└── interfaces/
    ├── IWebViewLifecycle.java
    ├── IWebViewNavigation.java
    └── IWebViewSecurity.java
\`\`\`

### Responsibilities
- **InAppWebView**: Core WebView coordination only
- **SettingsManager**: Handle all WebView settings
- **SecurityManager**: Security policies and validation
- **LifecycleManager**: Lifecycle events and cleanup
- **JavaScriptBridge**: JS communication
- **NavigationHandler**: URL navigation and redirects
- **ContentManager**: Content loading and caching

## Benefits
- ✅ Single Responsibility Principle
- ✅ Easier testing (unit tests per manager)
- ✅ Better maintainability
- ✅ Clearer code organization
- ✅ Easier to extend

## Priority
🔵 HIGH

## Implementation Steps
1. Create manager interfaces
2. Extract settings logic to SettingsManager
3. Extract security logic to SecurityManager
4. Extract lifecycle logic to LifecycleManager
5. Extract JavaScript logic to JavaScriptBridge
6. Update InAppWebView to use managers
7. Add comprehensive tests"

echo "[18/35] Creating architecture: Refactor iOS InAppWebView.swift"
gh issue create \
  --repo "$REPO" \
  --title "[ARCHITECTURE] Refactor InAppWebView.swift monolithic class" \
  --label "architecture,ios,enhancement" \
  --body "## Problem
\`InAppWebView.swift\` is **1500+ lines**, violating Single Responsibility Principle.

## Solution
Apply Clean Architecture and SOLID principles:

### New Structure
\`\`\`
InAppWebView.swift (Core, ~200 lines)
├── Managers/
│   ├── WebViewSettingsManager.swift
│   ├── WebViewSecurityManager.swift
│   ├── WebViewLifecycleManager.swift
│   ├── WebViewNavigationHandler.swift
│   └── WebViewContentHandler.swift
├── Delegates/
│   ├── NavigationDelegateHandler.swift
│   └── UIDelegateHandler.swift
└── Protocols/
    ├── WebViewLifecycleProtocol.swift
    ├── WebViewNavigationProtocol.swift
    └── WebViewSecurityProtocol.swift
\`\`\`

### Responsibilities
- **InAppWebView**: Core WKWebView coordination only
- **SettingsManager**: Handle all WKWebView configuration
- **SecurityManager**: Security policies and certificate validation
- **LifecycleManager**: Lifecycle events and memory management
- **NavigationHandler**: Navigation delegation and URL handling
- **ContentHandler**: Content handling and custom schemes

## Benefits
- ✅ Single Responsibility Principle
- ✅ Protocol-oriented design
- ✅ Easier testing (unit tests per manager)
- ✅ Better maintainability
- ✅ Clearer code organization

## Priority
🔵 HIGH

## Implementation Steps
1. Create protocols
2. Extract settings logic to SettingsManager
3. Extract security logic to SecurityManager
4. Extract lifecycle logic to LifecycleManager
5. Extract navigation logic to NavigationHandler
6. Update InAppWebView to use managers
7. Add comprehensive tests"

echo "[19/35] Creating architecture: Implement clean architecture layers"
gh issue create \
  --repo "$REPO" \
  --title "[ARCHITECTURE] Implement clean architecture layers" \
  --label "architecture,android,ios,enhancement" \
  --body "## Goal
Implement clean architecture with clear separation of concerns:

\`\`\`
┌─────────────────────────────────────┐
│     Presentation Layer              │
│  (Flutter Dart API / Method Channel)│
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│      Domain Layer                   │
│  (Business Logic / Use Cases)       │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│      Data Layer                     │
│  (Platform Implementation)          │
└─────────────────────────────────────┘
\`\`\`

## Layers

### 1. Presentation Layer
- Dart API surface
- Method channel communication
- Data serialization/deserialization

### 2. Domain Layer
- Business logic
- Use cases
- Platform-agnostic interfaces
- Validation rules

### 3. Data Layer
- Android platform implementation
- iOS platform implementation
- WebView native APIs
- Platform-specific features

## Benefits
- ✅ Platform independence
- ✅ Testable business logic
- ✅ Clear dependencies
- ✅ Easier to modify platform implementations
- ✅ Better code reusability

## Priority
🔵 HIGH"

echo "[20/35] Creating architecture: Apply SOLID principles"
gh issue create \
  --repo "$REPO" \
  --title "[ARCHITECTURE] Apply SOLID principles throughout codebase" \
  --label "architecture,android,ios,enhancement" \
  --body "## Goal
Apply SOLID principles to improve code quality:

### 1. Single Responsibility Principle (SRP)
Each class has one reason to change.
- ✅ Separate managers for different concerns
- ✅ Focused interfaces
- ✅ Small, cohesive classes (< 400 lines)

### 2. Open/Closed Principle (OCP)
Open for extension, closed for modification.
- ✅ Use protocols/interfaces
- ✅ Strategy pattern for configurable behavior
- ✅ Plugin architecture for extensibility

### 3. Liskov Substitution Principle (LSP)
Subtypes must be substitutable for base types.
- ✅ Proper inheritance hierarchy
- ✅ Interface segregation
- ✅ Contract-based programming

### 4. Interface Segregation Principle (ISP)
Clients shouldn't depend on interfaces they don't use.
- ✅ Focused interfaces
- ✅ No fat interfaces
- ✅ Role-based interfaces

### 5. Dependency Inversion Principle (DIP)
Depend on abstractions, not concretions.
- ✅ Dependency injection
- ✅ Protocol/interface-based design
- ✅ Inversion of control

## Implementation Checklist
- [ ] Audit all classes for SRP violations
- [ ] Create focused interfaces
- [ ] Implement dependency injection
- [ ] Add abstraction layers
- [ ] Refactor inheritance hierarchies
- [ ] Update documentation

## Priority
🔵 HIGH"

# ============================================================================
# 5. MODERN WEBVIEW TECHNOLOGIES
# ============================================================================

echo "[21/35] Creating enhancement: Update Android dependencies"
gh issue create \
  --repo "$REPO" \
  --title "[Android] Update to latest WebView dependencies" \
  --label "enhancement,android" \
  --body "## Current Dependencies
\`\`\`gradle
androidx.webkit:webkit:1.13.0
androidx.browser:browser:1.8.0
androidx.appcompat:appcompat:1.7.0
\`\`\`

## Updates Needed
Monitor and update to latest versions:
\`\`\`gradle
androidx.webkit:webkit:1.14.0 (when released)
androidx.browser:browser:1.9.0 (when released)
\`\`\`

## New Features to Leverage
1. **SUPPRESS_ERROR_PAGE** (webkit 1.13.0+)
2. **WebViewAssetLoader** improvements
3. **WebMessageListener** enhancements
4. **DocumentStartJavaScript** for early injection

## Priority
🟢 NORMAL (Keep updated)"

echo "[22/35] Creating enhancement: Implement WebMessageListener"
gh issue create \
  --repo "$REPO" \
  --title "[Android] Implement WebMessageListener for secure JS communication" \
  --label "enhancement,android" \
  --body "## Problem
Current JavaScript bridge uses addJavascriptInterface, which has security limitations.

## Solution
Implement modern WebMessageListener (Android 6.0+):

\`\`\`java
if (WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_LISTENER)) {
    WebViewCompat.addWebMessageListener(
        webView,
        \"messageHandler\",
        allowedOriginRules,
        new WebViewCompat.WebMessageListener() {
            @Override
            public void onPostMessage(
                WebView view,
                WebMessageCompat message,
                Uri sourceOrigin,
                boolean isMainFrame,
                JavaScriptReplyProxy replyProxy
            ) {
                // Handle message from JavaScript
                String data = message.getData();

                // Reply back to JavaScript
                replyProxy.postMessage(\"Response from native\");
            }
        }
    );
}
\`\`\`

### Benefits
- ✅ More secure than JavaScriptInterface
- ✅ Origin-based access control
- ✅ Bidirectional communication
- ✅ Better performance

## Priority
🟡 MEDIUM"

echo "[23/35] Creating enhancement: Implement WKContentWorld"
gh issue create \
  --repo "$REPO" \
  --title \"[iOS] Implement WKContentWorld for JavaScript isolation\" \
  --label \"enhancement,ios\" \
  --body \"## Problem
JavaScript executes in the same context as the page, creating security risks.

## Solution
Use WKContentWorld for JavaScript isolation (iOS 14.0+):

\`\`\`swift
// Create isolated world
let contentWorld = WKContentWorld.world(name: \\\"zikzakWorld\\\")

// Add user script to isolated world
let userScript = WKUserScript(
    source: jsCode,
    injectionTime: .atDocumentStart,
    forMainFrameOnly: false,
    in: contentWorld
)
webView.configuration.userContentController.addUserScript(userScript)

// Evaluate JavaScript in isolated world
webView.evaluateJavaScript(jsCode, in: nil, in: contentWorld) { result in
    // Handle result
}
\`\`\`

### Benefits
- ✅ JavaScript isolation from page context
- ✅ Better security
- ✅ No conflicts with page JavaScript
- ✅ Clean separation of concerns

## Priority
🟡 MEDIUM

## Requirements
Requires minimum iOS 14.0 (already planned)\""

echo "[24/35] Creating enhancement: Implement algorithmic darkening"
gh issue create \
  --repo "$REPO" \
  --title "[Android] Implement algorithmic darkening for dark mode" \
  --label "enhancement,android" \
  --body "## Feature
Implement algorithmic darkening for automatic dark mode support:

\`\`\`java
if (WebViewFeature.isFeatureSupported(WebViewFeature.ALGORITHMIC_DARKENING)) {
    WebSettingsCompat.setAlgorithmicDarkeningAllowed(
        webView.getSettings(),
        true
    );
}
\`\`\`

### Benefits
- ✅ Automatic dark mode for web content
- ✅ Respects system dark mode preference
- ✅ Better user experience
- ✅ No need for CSS media queries

## API Design
\`\`\`dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    algorithmicDarkeningAllowed: true, // Android only
    forceDark: ForceDark.auto, // Legacy support
  ),
)
\`\`\`

## Priority
🟢 NORMAL"

echo "[25/35] Creating enhancement: Implement iOS download API"
gh issue create \
  --repo "$REPO" \
  --title "[iOS] Implement WKDownload API for file downloads" \
  --label "enhancement,ios" \
  --body "## Feature
Implement modern WKDownload API for better file download handling (iOS 14.5+):

\`\`\`swift
// WKNavigationDelegate
func webView(_ webView: WKWebView,
             navigationResponse: WKNavigationResponse,
             didBecome download: WKDownload) {
    download.delegate = self
}

// WKDownloadDelegate
func download(_ download: WKDownload,
              decideDestinationUsing response: URLResponse,
              suggestedFilename: String,
              completionHandler: @escaping (URL?) -> Void) {
    // Determine download location
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destinationURL = documentsPath.appendingPathComponent(suggestedFilename)
    completionHandler(destinationURL)
}
\`\`\`

### Benefits
- ✅ Native download progress tracking
- ✅ Better download management
- ✅ Resume/pause support
- ✅ Background downloads

## Priority
🟢 NORMAL"

# ============================================================================
# 6. PERFORMANCE OPTIMIZATIONS
# ============================================================================

echo "[26/35] Creating performance: Fix memory leaks"
gh issue create \
  --repo "$REPO" \
  --title "[PERFORMANCE] Fix memory leaks and improve memory management" \
  --label "performance,bug,android,ios" \
  --body "## Problem
Memory leaks identified in:
1. WebView cleanup and disposal
2. iOS keyboard interactions (related to #2535)
3. Callback handlers not being released

## Solution

### Android
\`\`\`java
public class WebViewLifecycleManager {
    public void cleanup(InAppWebView webView) {
        // Clear callbacks
        webView.setWebViewClient(null);
        webView.setWebChromeClient(null);

        // Remove JavaScript interfaces
        webView.removeJavascriptInterface(\"bridge\");

        // Clear views
        webView.removeAllViews();

        // Clear history and cache
        webView.clearHistory();
        webView.clearCache(true);
        webView.clearFormData();

        // Destroy
        webView.destroy();
    }
}
\`\`\`

### iOS
\`\`\`swift
class WebViewLifecycleManager {
    func cleanup(webView: WKWebView) {
        // Stop loading
        webView.stopLoading()

        // Remove observers
        removeKeyboardObservers()

        // Clear delegates
        webView.navigationDelegate = nil
        webView.uiDelegate = nil

        // Remove user scripts
        webView.configuration.userContentController.removeAllUserScripts()

        // Clear website data
        let dataStore = webView.configuration.websiteDataStore
        dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                            modifiedSince: Date.distantPast) { }
    }
}
\`\`\`

## Testing
Use memory profiling tools:
- Android: LeakCanary
- iOS: Instruments (Leaks, Allocations)

## Priority
🔴 HIGH"

echo "[27/35] Creating performance: Enable hardware acceleration"
gh issue create \
  --repo "$REPO" \
  --title "[PERFORMANCE] Enable hardware acceleration by default" \
  --label "performance,enhancement,android" \
  --body "## Feature
Enable hardware acceleration by default for better rendering performance:

\`\`\`java
// In AndroidManifest.xml or programmatically
webView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
\`\`\`

### Benefits
- ✅ Faster rendering
- ✅ Smoother scrolling
- ✅ Better animation performance
- ✅ GPU-accelerated compositing

## Considerations
- Check device capabilities
- Fall back to software rendering if needed
- Monitor memory usage

## Priority
🟢 NORMAL"

echo "[28/35] Creating performance: Optimize JavaScript execution"
gh issue create \
  --repo "$REPO" \
  --title "[PERFORMANCE] Optimize JavaScript execution and bridge calls" \
  --label "performance,enhancement,android,ios" \
  --body "## Optimizations

### 1. Reduce evaluateJavaScript calls
- Batch multiple JavaScript calls
- Use single script execution when possible
- Cache frequently used scripts

### 2. Use WKContentWorld (iOS)
- Isolated JavaScript execution
- Better performance
- No conflicts with page scripts

### 3. Implement message batching
- Batch multiple messages to native
- Reduce bridge overhead
- Better performance for high-frequency calls

### 4. Add call throttling
- Rate limit JavaScript bridge calls
- Prevent abuse
- Better performance

## Implementation
\`\`\`dart
// Batched JavaScript execution
await webView.evaluateJavaScriptBatch([
  'script1',
  'script2',
  'script3',
]);

// Throttled handler
InAppWebView(
  javascriptHandlerThrottleMs: 100, // Max 10 calls/sec
)
\`\`\`

## Priority
🟡 MEDIUM"

# ============================================================================
# 7. API SIMPLIFICATION
# ============================================================================

echo "[29/35] Creating API: Consolidate settings"
gh issue create \
  --repo "$REPO" \
  --title "[API] Consolidate and simplify settings (70+ → 40 settings)" \
  --label "breaking-change,enhancement,api" \
  --body "## Problem
Currently **70+ settings** make the API overwhelming and difficult to use.

## Solution
Consolidate to **~40 essential settings** grouped logically:

### Groups
1. **Security Settings** (10)
   - JavaScript, cookies, storage, file access, HTTPS enforcement

2. **Display Settings** (8)
   - Zoom, viewport, text size, dark mode

3. **Media Settings** (6)
   - Autoplay, picture-in-picture, media capture

4. **Performance Settings** (5)
   - Caching, hardware acceleration, loading strategy

5. **Behavior Settings** (11)
   - Navigation, scroll, pull-to-refresh, gestures

### Deprecated Settings
Mark old settings as deprecated with migration path.

## Priority
🔵 HIGH

## Breaking Changes
✅ Settings API cleanup for v3.0"

echo "[30/35] Creating API: Reduce callbacks"
gh issue create \
  --repo "$REPO" \
  --title "[API] Reduce and rename callbacks (40+ → 25 callbacks)" \
  --label "breaking-change,enhancement,api" \
  --body "## Problem
Currently **40+ callbacks** with inconsistent naming.

## Solution
Reduce to **~25 essential callbacks** with consistent naming:

### Essential Callbacks
1. **Lifecycle** (5)
   - onWebViewCreated, onLoadStart, onLoadStop, onLoadError, onDispose

2. **Navigation** (4)
   - onNavigationRequest, onNavigationCompleted, onRedirect, onPageStarted

3. **Security** (4)
   - onSecurityEvent, onCertificateError, onHttpAuthRequest, onPermissionRequest

4. **Content** (5)
   - onTitleChanged, onProgressChanged, onFaviconChanged, onPrint, onDownloadStart

5. **JavaScript** (3)
   - onConsoleMessage, onJavaScriptAlert, onJavaScriptConfirm

6. **Interaction** (4)
   - onScroll, onZoomChanged, onFocus, onContextMenu

### Naming Convention
- Use \`on\` prefix consistently
- Use present/past tense appropriately
- Use descriptive names

## Priority
🔵 HIGH

## Breaking Changes
✅ Callback API cleanup for v3.0"

# ============================================================================
# 8. TESTING & QUALITY
# ============================================================================

echo "[31/35] Creating testing: Add unit tests for security"
gh issue create \
  --repo "$REPO" \
  --title "[TESTING] Add comprehensive unit tests for security managers" \
  --label "testing,security" \
  --body "## Goal
Achieve **100% test coverage** for security-critical code.

## Test Coverage

### SecurityCoordinator
- [ ] Certificate pinning validation
- [ ] URL validation with all schemes
- [ ] CSP header injection
- [ ] HTTPS upgrade logic
- [ ] Safe Browsing integration

### CertificatePinningManager
- [ ] Public key extraction
- [ ] Certificate validation
- [ ] Pin matching logic
- [ ] Error handling

### URLValidationManager
- [ ] Scheme validation
- [ ] Host validation
- [ ] Malicious URL detection
- [ ] Edge cases

### ContentSecurityPolicyManager
- [ ] CSP header generation
- [ ] Policy enforcement
- [ ] Violation reporting

## Test Frameworks
- **Android:** JUnit, Mockito, Robolectric
- **iOS:** XCTest, Quick, Nimble

## Priority
🔴 HIGH"

echo "[32/35] Creating testing: Add integration tests"
gh issue create \
  --repo "$REPO" \
  --title "[TESTING] Add integration tests for WebView lifecycle" \
  --label "testing" \
  --body "## Goal
Test end-to-end WebView functionality.

## Test Scenarios

### Lifecycle
- [ ] WebView creation and initialization
- [ ] Loading URLs
- [ ] Navigation forward/back
- [ ] Cleanup and disposal
- [ ] Memory management

### JavaScript Bridge
- [ ] Send message from Dart to JS
- [ ] Send message from JS to Dart
- [ ] Handler registration
- [ ] Error handling

### Security
- [ ] Certificate pinning rejection
- [ ] HTTP to HTTPS upgrade
- [ ] Blocked malicious sites
- [ ] CSP violations

### Performance
- [ ] Page load times
- [ ] Memory usage
- [ ] JavaScript execution time

## Test Frameworks
- **Flutter:** integration_test package
- **Android:** Espresso
- **iOS:** XCUITest

## Priority
🟡 MEDIUM"

echo "[33/35] Creating testing: Add security penetration tests"
gh issue create \
  --repo "$REPO" \
  --title "[TESTING] Add security penetration tests" \
  --label "testing,security" \
  --body "## Goal
Perform security penetration testing on WebView implementation.

## Test Cases

### XSS (Cross-Site Scripting)
- [ ] Reflected XSS
- [ ] Stored XSS
- [ ] DOM-based XSS
- [ ] JavaScript injection

### CSRF (Cross-Site Request Forgery)
- [ ] State-changing requests
- [ ] Token validation

### URL Manipulation
- [ ] javascript: scheme
- [ ] data: scheme
- [ ] file: scheme
- [ ] Open redirect

### Certificate Validation
- [ ] Self-signed certificates
- [ ] Expired certificates
- [ ] Wrong hostname
- [ ] Certificate pinning bypass attempts

### JavaScript Bridge
- [ ] Unauthorized access
- [ ] Message tampering
- [ ] Replay attacks

## Tools
- OWASP ZAP
- Burp Suite
- Custom test suite

## Priority
🔴 HIGH"

# ============================================================================
# 9. DOCUMENTATION
# ============================================================================

echo "[34/35] Creating documentation: Security best practices guide"
gh issue create \
  --repo "$REPO" \
  --title "[DOCS] Create security best practices guide" \
  --label "documentation" \
  --body "## Content

### 1. Certificate Pinning
- How to extract public key hashes
- Configuration examples
- Updating pinned certificates

### 2. Content Security Policy
- CSP configuration examples
- Common CSP directives
- Testing CSP policies

### 3. JavaScript Security
- When to enable/disable JavaScript
- Secure JavaScript bridge usage
- Input validation

### 4. HTTPS-Only Mode
- Enabling HTTPS-only
- Handling mixed content
- Certificate errors

### 5. Safe Browsing
- Enabling Safe Browsing
- Handling threats
- User warnings

### 6. Common Vulnerabilities
- XSS prevention
- CSRF protection
- URL validation
- File access restrictions

## Format
- Markdown documentation
- Code examples
- Visual diagrams
- Video tutorials (optional)

## Priority
🟡 MEDIUM"

echo "[35/35] Creating documentation: v2.x to v3.x migration guide"
gh issue create \
  --repo "$REPO" \
  --title "[DOCS] Create v2.x to v3.x migration guide" \
  --label "documentation" \
  --body "## Content

### Breaking Changes
1. Platform support removed (macOS, Windows, Web)
2. Minimum Android SDK increased (19 → 24)
3. Minimum iOS version increased (13.0 → 14.0)
4. Settings API changes (70+ → 40)
5. Callbacks API changes (40+ → 25)
6. JavaScript disabled by default
7. Security API changes

### Migration Steps
Step-by-step guide for each breaking change with:
- Old API usage
- New API usage
- Migration script (if applicable)

### Example Migration
\`\`\`dart
// v2.x
InAppWebView(
  initialOptions: InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
    ),
  ),
);

// v3.x
InAppWebView(
  initialSettings: InAppWebViewSettings(
    enableNavigationCallbacks: true, // Renamed
  ),
);
\`\`\`

### Troubleshooting
Common migration issues and solutions.

## Priority
🔴 HIGH (Required for v3.0 release)"

echo ""
echo "✅ All 35 GitHub issues created successfully!"
echo ""
echo "Summary:"
echo "- 7 Critical Security Issues"
echo "- 6 Critical Bug Fixes"
echo "- 3 Platform Cleanup Tasks"
echo "- 4 Architecture Refactoring Tasks"
echo "- 5 Modern WebView Features"
echo "- 3 Performance Optimizations"
echo "- 2 API Simplification Tasks"
echo "- 3 Testing Tasks"
echo "- 2 Documentation Tasks"
echo ""
echo "Next steps:"
echo "1. Review all issues on GitHub"
echo "2. Prioritize and assign labels"
echo "3. Create project board for v3.0"
echo "4. Start implementation following roadmap"
