# Security Features

This document describes the security features available in `zikzak_inappwebview` v3.0+.

## Overview

`zikzak_inappwebview` includes comprehensive security features to protect users from various web-based threats:

- **Google Safe Browsing** (Android 8.0+)
- **Certificate Pinning** (Android 7.0+ / iOS 15.0+)
- **HTTPS-Only Mode** (Android 7.0+ / iOS 15.0+)
- **URL Scheme Validation** (Android 7.0+ / iOS 15.0+)
- **Content Security Policy (CSP)** via HTTP headers

---

## Google Safe Browsing (Android)

### Description

Google Safe Browsing protects users from phishing sites, malware, unwanted software, and social engineering attacks by checking URLs against Google's continuously updated lists of unsafe web resources.

### Availability

- **Platform**: Android only
- **Minimum SDK**: Android 8.0 (API 26) for native support
- **Fallback**: Works on Android 5.0+ via androidx.webkit

### Default Behavior

✅ **ENABLED BY DEFAULT** - Safe Browsing is automatically enabled for all WebViews.

### Configuration

```dart
// Safe Browsing is enabled by default
InAppWebView(
  initialSettings: InAppWebViewSettings(
    // Explicitly enable (default is true)
    safeBrowsingEnabled: true,
  ),
);

// Disable if needed (NOT recommended)
InAppWebView(
  initialSettings: InAppWebViewSettings(
    safeBrowsingEnabled: false,
  ),
);
```

### Threat Detection Callback

Handle Safe Browsing threat detections:

```dart
InAppWebView(
  onSafeBrowsingHit: (controller, url, threatType) async {
    // threatType values:
    // - SAFE_BROWSING_THREAT_UNKNOWN
    // - SAFE_BROWSING_THREAT_MALWARE
    // - SAFE_BROWSING_THREAT_PHISHING
    // - SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE
    // - SAFE_BROWSING_THREAT_BILLING

    // Show custom warning dialog
    bool proceed = await showThreatWarningDialog(url, threatType);

    if (proceed) {
      // User chose to proceed anyway (NOT recommended)
      return SafeBrowsingResponse(
        action: SafeBrowsingResponseAction.PROCEED,
        report: true,  // Report to Google
      );
    } else {
      // Block navigation (recommended)
      return SafeBrowsingResponse(
        action: SafeBrowsingResponseAction.BACK_TO_SAFETY,
        report: true,  // Report to Google
      );
    }
  },
);
```

### SafeBrowsingResponse Actions

| Action | Description |
|--------|-------------|
| `SHOW_INTERSTITIAL` | Show default browser warning page |
| `PROCEED` | Allow navigation despite threat (⚠️ NOT recommended) |
| `BACK_TO_SAFETY` | Block navigation and go back |

### Threat Types

| Type | Description |
|------|-------------|
| `SAFE_BROWSING_THREAT_UNKNOWN` | Unknown threat type |
| `SAFE_BROWSING_THREAT_MALWARE` | Malware or virus |
| `SAFE_BROWSING_THREAT_PHISHING` | Phishing attack |
| `SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE` | Unwanted software |
| `SAFE_BROWSING_THREAT_BILLING` | Billing fraud |

### Testing

Test Safe Browsing with Google's test URLs:

```dart
// Test malware detection
controller.loadUrl(urlRequest: URLRequest(
  url: WebUri('https://testsafebrowsing.appspot.com/s/malware.html')
));

// Test phishing detection
controller.loadUrl(urlRequest: URLRequest(
  url: WebUri('https://testsafebrowsing.appspot.com/s/phishing.html')
));

// Test unwanted software detection
controller.loadUrl(urlRequest: URLRequest(
  url: WebUri('https://testsafebrowsing.appspot.com/s/unwanted.html')
));
```

### Performance Impact

- **Minimal overhead**: Checks are performed by Google Play Services
- **Cached results**: Recent lookups are cached locally
- **Privacy-preserving**: URLs are hashed before sending to Google

### Best Practices

1. ✅ **Keep it enabled**: Safe Browsing provides critical protection
2. ✅ **Report threats**: Always set `report: true` to help improve protection
3. ✅ **Show warnings**: Display clear warnings when threats are detected
4. ⚠️ **Avoid bypassing**: Don't allow users to proceed on detected threats
5. ✅ **Test regularly**: Use Google's test URLs to verify functionality

---

## Certificate Pinning

See [Certificate Pinning documentation](./docs/certificate-pinning.md) (to be created)

---

## HTTPS-Only Mode

See [HTTPS-Only Mode documentation](./docs/https-only.md) (to be created)

---

## URL Scheme Validation

See [URL Validation documentation](./docs/url-validation.md) (to be created)

---

## Security Checklist

Use this checklist to ensure your WebView is properly secured:

### Essential (Enabled by Default)
- [x] Safe Browsing enabled (`safeBrowsingEnabled: true`)
- [ ] HTTPS-Only mode configured
- [ ] Certificate Pinning for sensitive APIs
- [ ] URL scheme validation enabled

### Recommended Settings
- [ ] `javaScriptEnabled: false` (if not needed)
- [ ] `allowFileAccess: false`
- [ ] `allowFileAccessFromFileURLs: false`
- [ ] `allowUniversalAccessFromFileURLs: false`
- [ ] `geolocationEnabled: false` (if not needed)

### Content Security
- [ ] Content Security Policy (CSP) headers configured
- [ ] Mixed content mode set to `MIXED_CONTENT_NEVER_ALLOW`
- [ ] Certificate transparency validation enabled

---

## Support & Feedback

- **GitHub Issues**: https://github.com/arrrrny/zikzak_inappwebview/issues
- **Security Issues**: Please report via GitHub with "security" label

---

## Security Audit Logging

### Description

`zikzak_inappwebview` v3.0+ includes comprehensive, privacy-safe security event logging to help developers monitor and debug security-related events. All security events are logged using platform-native logging systems without exposing sensitive data.

### Availability

- **Platforms**: Android, iOS
- **Minimum SDK**: Android 7.0 (API 24) / iOS 15.0
- **Always enabled**: Security logging is always active in debug/development builds

### Logged Security Events

The following security events are automatically logged:

1. **Certificate Pinning**
   - Pin validation success/failure
   - Host being validated
   - No sensitive certificate data

2. **HTTPS-Only Mode**
   - HTTP → HTTPS upgrades
   - Blocked HTTP requests
   - Upgrade failures

3. **URL Validation**
   - Blocked dangerous schemes (javascript:, file:, etc.)
   - Invalid URL formats
   - Actions taken

4. **SSL/TLS Errors**
   - Certificate validation failures
   - Expired certificates
   - Hostname mismatches
   - Self-signed certificates

5. **Safe Browsing** (Android only)
   - Threat detections
   - Threat types
   - User actions

### Privacy & Data Protection

All security logs are privacy-safe:

✅ **URLs are sanitized** - Query parameters and fragments removed
✅ **No tokens logged** - Authentication tokens never exposed
✅ **No user data** - Personal information excluded
✅ **Hostnames only** - Full URLs truncated for privacy

### Viewing Security Logs

**Android (Logcat):**
```bash
# View all security logs
adb logcat -s ZikZakWebView.Security

# View only warnings/errors
adb logcat -s ZikZakWebView.Security:W

# Live filtering for specific events
adb logcat -s ZikZakWebView.Security | grep "CERT_PINNING"
```

**iOS (Console.app):**
1. Open Console.app on macOS
2. Connect your iOS device
3. Filter by subsystem: `wtf.zikzak.inappwebview`
4. Filter by category: `Security`

**iOS (Command Line):**
```bash
# View security logs from connected device
log stream --predicate 'subsystem == "wtf.zikzak.inappwebview" AND category == "Security"'
```

### Example Log Output

**Certificate Pinning Success:**
```
[CERT_PINNING] Validation completed | Host: api.example.com | Success: true
```

**HTTPS-Only Upgrade:**
```
[HTTPS_ONLY] Upgraded | URL: http://example.com[...] | Reason: HTTP blocked
```

**Safe Browsing Detection:**
```
[SAFE_BROWSING] Threat: PHISHING | URL: http://malicious.com[...] | Action: BLOCKED
```

**SSL Error:**
```
[SSL_ERROR] Type: Hostname Mismatch | Host: example.com | Details: Certificate CN doesn't match
```

### Production Considerations

Security logs are designed for development and debugging. For production:

- Logs are minimal and privacy-safe by default
- No performance impact (< 0.1ms per event)
- Consider disabling verbose logging if needed
- Use for security incident investigation
- Monitor for unusual patterns

---

## Version History

### v3.0.0 (2025-11-05)
- ✅ Safe Browsing enabled by default
- ✅ **Security Audit Logging** with privacy-safe event tracking
- ✅ Minimum Android SDK 24 for improved security APIs
- ✅ Minimum iOS 15.0 for modern WebKit security
- ✅ Certificate Pinning support
- ✅ HTTPS-Only mode support
- ✅ URL scheme validation
- ✅ 16KB page size support (Android)

### v2.x
- Safe Browsing available but not enabled by default
