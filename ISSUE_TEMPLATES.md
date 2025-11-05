# GitHub Issue Templates

This file contains all issue templates for the modernization plan. If the shell script doesn't work, you can manually create issues using these templates.

---

## How to Use

1. Go to your GitHub repository: https://github.com/arrrrny/zikzak_inappwebview/issues
2. Click "New Issue"
3. Copy the template below
4. Fill in the template
5. Add appropriate labels
6. Submit

---

## Quick Reference: All 35 Issues

### Critical Security (7 issues)
1. Remove JavaScript-based CSP injection
2. Implement SSL/TLS certificate pinning
3. Fix JavaScript execution security model
4. Implement HTTPS-only mode
5. Fix URL validation - Add scheme checking
6. Enable Android Safe Browsing by default
7. Implement security audit logging

### Critical Bugs (6 issues)
8. Fix iOS 18.4/18.5 startup crashes
9. Fix Xcode 16.1 build failures
10. Add Privacy Manifest (PrivacyInfo.xcprivacy)
11. Fix iOS keyboard crashes (iOS 17+)
12. Fix Android WebView closing crashes
13. Fix zoom functionality

### Platform Cleanup (3 issues)
14. Remove macOS, Windows, and Web support
15. Increase Android minSdk 19→24
16. Increase iOS minimum 13.0→14.0

### Architecture (4 issues)
17. Refactor InAppWebView.java monolithic class
18. Refactor InAppWebView.swift monolithic class
19. Implement clean architecture layers
20. Apply SOLID principles

### Modern WebView (5 issues)
21. Update Android dependencies
22. Implement WebMessageListener (Android)
23. Implement WKContentWorld (iOS)
24. Implement algorithmic darkening (Android)
25. Implement WKDownload API (iOS)

### Performance (3 issues)
26. Fix memory leaks
27. Enable hardware acceleration by default
28. Optimize JavaScript execution

### API Simplification (2 issues)
29. Consolidate settings (70+→40)
30. Reduce callbacks (40+→25)

### Testing (3 issues)
31. Add unit tests for security managers
32. Add integration tests
33. Add security penetration tests

### Documentation (2 issues)
34. Create security best practices guide
35. Create v2.x→v3.x migration guide

---

## Labels to Create

Create these labels in your repository:

- `security` (red) - Security-related issues
- `bug` (red) - Bug fixes
- `critical` (red) - Critical priority
- `architecture` (blue) - Architecture improvements
- `breaking-change` (orange) - Breaking changes
- `enhancement` (green) - New features
- `performance` (yellow) - Performance improvements
- `android` (blue) - Android-specific
- `ios` (blue) - iOS-specific
- `testing` (purple) - Testing-related
- `documentation` (gray) - Documentation

---

# Detailed Issue Templates

## [1] Remove JavaScript-based CSP injection

**Title:** `[SECURITY] Remove JavaScript-based CSP injection`

**Labels:** `security`, `breaking-change`, `android`

**Body:**
```markdown
## Problem
The current ZikZakSecurityManager injects Content-Security-Policy via JavaScript (`evaluateJavascript`), which is fundamentally insecure and bypassable.

**File:** `ZikZakSecurityManager.java:579-591`

## Security Risk
- JavaScript-based CSP can be bypassed by attackers
- Not as reliable as HTTP header-based CSP
- False sense of security

## Solution
Implement proper HTTP header-based Content Security Policy:
1. Intercept requests using `shouldInterceptRequest`
2. Add CSP headers to responses
3. Remove JavaScript-based injection code

## Impact
- **Breaking Change:** Applications relying on JS-based CSP may need updates
- **Security:** Significantly improves security posture

## Priority
🔴 CRITICAL - Must fix before v3.0 release

## References
- [OWASP CSP](https://owasp.org/www-community/controls/Content_Security_Policy)
- [MDN CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
```

---

## [2] Implement SSL/TLS certificate pinning

**Title:** `[SECURITY] Implement SSL/TLS certificate pinning`

**Labels:** `security`, `enhancement`, `android`, `ios`

**Body:**
```markdown
## Problem
No certificate pinning support for secure connections, leaving applications vulnerable to MITM attacks.

## Solution
### Android
Implement certificate pinning using:
- `CertificatePinner` from OkHttp (for network requests)
- `onReceivedSslError` override with certificate validation
- Pin public keys or certificates

### iOS
Implement certificate pinning using:
- `WKNavigationDelegate.didReceive(challenge:)`
- `URLSession` challenge handling
- Pin public keys using Security framework

## API Design
```dart
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
```

## Priority
🔴 CRITICAL

## References
- [OWASP Certificate Pinning](https://owasp.org/www-community/controls/Certificate_and_Public_Key_Pinning)
```

---

## [3] Fix JavaScript execution security model

**Title:** `[SECURITY] Fix JavaScript execution security model`

**Labels:** `security`, `breaking-change`, `android`, `ios`

**Body:**
```markdown
## Problem
1. JavaScript is enabled by default (security risk)
2. Arbitrary code execution via `evaluateJavascript()` without validation
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

## Priority
🔴 CRITICAL

## Breaking Changes
- JavaScript disabled by default
- JS bridge API changes
```

---

## [4-35] Additional Templates

*(For brevity, the remaining templates follow the same pattern as shown in the shell script. Each includes: Problem, Solution, Implementation details, Priority, and relevant References/Breaking Changes)*

You can find the complete detailed content for all 35 issues in the `create_github_issues.sh` script.

---

## Creating Issues in Bulk

### Option 1: Using GitHub CLI (Recommended)
```bash
# Install GitHub CLI if not already installed
# macOS: brew install gh
# Linux: See https://cli.github.com/

# Authenticate
gh auth login

# Make script executable
chmod +x create_github_issues.sh

# Run script
./create_github_issues.sh
```

### Option 2: Using GitHub API
```bash
# Set your token
export GITHUB_TOKEN="your_personal_access_token"

# Use curl or similar to create issues via API
# See: https://docs.github.com/en/rest/issues/issues#create-an-issue
```

### Option 3: Manual Creation
Copy each template above and create issues manually through GitHub web interface.

---

## Project Board Structure

Create a GitHub project board with these columns:

1. **Backlog** - All issues
2. **Phase 1: Critical Security & Bugs** - Issues #1-#7, #8-#13
3. **Phase 2: Platform & Architecture** - Issues #14-#20
4. **Phase 3: Security Rewrite** - Issues #11-#13
5. **Phase 4: Modern Features** - Issues #21-#25
6. **Phase 5: Performance & Testing** - Issues #26-#28, #31-#33
7. **Phase 6: Documentation** - Issues #29-#30, #34-#35
8. **In Progress** - Currently being worked on
9. **Review** - Awaiting code review
10. **Done** - Completed

---

## Milestone Structure

Create these milestones:

1. **v3.0-alpha** - Phase 1 & 2 complete
2. **v3.0-beta** - Phase 1-4 complete
3. **v3.0-rc** - Phase 1-5 complete
4. **v3.0.0** - All phases complete

---

## Priority Legend

- 🔴 **CRITICAL** - Must be fixed immediately, blocking release
- 🟠 **HIGH** - Important, should be in next release
- 🟡 **MEDIUM** - Desirable, can wait for later release
- 🟢 **NORMAL** - Nice to have, no urgency

---

## Need Help?

If you encounter issues creating these GitHub issues, please:
1. Check GitHub CLI installation: `gh --version`
2. Verify authentication: `gh auth status`
3. Check repository permissions
4. Create issues manually as a fallback
