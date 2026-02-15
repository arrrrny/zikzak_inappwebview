# Quick GitHub Issues Creation Guide

Since GitHub CLI is not available, here's how to create issues quickly:

## Method 1: Use GitHub's Web Interface

Go to: https://github.com/arrrrny/zikzak_inappwebview/issues/new

Copy each issue below and paste into the GitHub issue form:

---

## Issue #1: [SECURITY] Remove JavaScript-based CSP injection

**Labels:** `security`, `breaking-change`, `android`

**Description:**
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

## Priority
🔴 CRITICAL

## References
- [OWASP CSP](https://owasp.org/www-community/controls/Content_Security_Policy)
```

---

## Issue #2: [SECURITY] Implement SSL/TLS certificate pinning

**Labels:** `security`, `enhancement`, `android`, `ios`

**Description:**
```markdown
## Problem
No certificate pinning support, vulnerable to MITM attacks.

## Solution
### Android
- `onReceivedSslError` override with certificate validation
- Pin public keys or certificates

### iOS
- `WKNavigationDelegate.didReceive(challenge:)`
- Pin public keys using Security framework

## API Design
\`\`\`dart
InAppWebView(
  certificatePinningConfig: CertificatePinningConfig(
    certs: [
      CertificatePin(
        hostname: 'example.com',
        publicKeyHashes: ['sha256/AAAA...'],
      ),
    ],
  ),
)
\`\`\`

## Priority
🔴 CRITICAL
```

---

## Issue #3: [SECURITY] Implement HTTPS-only mode

**Labels:** `security`, `enhancement`, `android`, `ios`

**Description:**
```markdown
## Problem
HTTP connections allowed by default, exposing users to MITM attacks.

## Solution
Add `enforceHTTPS` option with strict mode.

## API Design
\`\`\`dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    enforceHTTPS: true,
    httpsUpgradeStrategy: HTTPSUpgradeStrategy.strict,
  ),
)
\`\`\`

## Priority
🔴 HIGH
```

---

## Issue #4: [SECURITY] Fix URL validation - Add scheme checking

**Labels:** `security`, `bug`, `android`, `ios`

**Description:**
```markdown
## Problem
Current URL validation only checks host, not scheme. Vulnerable to `javascript:` scheme attacks.

## Solution
Implement comprehensive URL validation with scheme checking.

## Priority
🔴 CRITICAL

## References
- [OWASP URL Validation](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
```

---

## Method 2: Import via GitHub CLI (When Available)

If you have `gh` installed locally:

```bash
# Install gh: https://cli.github.com/
brew install gh  # macOS
# or see docs for other platforms

# Authenticate
gh auth login

# Run the script
./create_github_issues.sh
```

---

## Method 3: Bulk Create with CSV Import

GitHub supports bulk issue import. Use the CSV format from `ISSUE_TEMPLATES.md`.

---

**For now, focus on the code improvements! Issues can be created as we implement features.**
