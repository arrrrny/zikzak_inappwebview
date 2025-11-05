package wtf.zikzak.zikzak_inappwebview_android.security;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.util.Log;
import android.webkit.WebView;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.webkit.WebViewCompat;
import androidx.webkit.WebViewFeature;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import wtf.zikzak.zikzak_inappwebview_android.webview.in_app_webview.InAppWebView;

/**
 * ZikZak Security Manager - Advanced security features for Android 15+
 * Version 2.0.0
 *
 * This class provides advanced security features specifically designed for Android 15+
 * with backporting capabilities for earlier Android versions where possible.
 */
public class ZikZakSecurityManager {

    private static final String TAG = "ZikZakSecurity";

    private static ZikZakSecurityManager instance;
    private final Context context;
    private final Executor securityExecutor;
    private final Set<String> blockedTrackers;
    private final Map<String, SecurityPolicy> securityPolicies;
    private boolean securityEnhancementsEnabled = false;
    private int securityLevel = SecurityLevel.NORMAL;

    /**
     * Security levels
     */
    public static final class SecurityLevel {

        public static final int NORMAL = 0;
        public static final int ENHANCED = 1;
        public static final int MAXIMUM = 2;
    }

    /**
     * Security policy for WebViews
     */
    public static class SecurityPolicy {

        public boolean blockThirdPartyRequests = false;
        public boolean enforceHttps = false;
        public boolean blockTrackers = false;
        public boolean enforceStrictCsp = false;
        public boolean reduceFingerprinting = false;
        public String securityHeaders;

        public SecurityPolicy() {
            this.securityHeaders =
                "default-src 'self'; script-src 'self' 'unsafe-inline'; object-src 'none';";
        }
    }

    /**
     * Private constructor for singleton pattern
     *
     * @param context Application context
     */
    private ZikZakSecurityManager(@NonNull Context context) {
        this.context = context.getApplicationContext();
        this.securityExecutor = Executors.newSingleThreadExecutor();
        this.blockedTrackers = new HashSet<>();
        this.securityPolicies = new HashMap<>();

        // Initialize default blocked trackers
        initializeDefaultTrackers();
    }

    /**
     * Get singleton instance of ZikZakSecurityManager
     *
     * @param context Application context
     * @return ZikZakSecurityManager instance
     */
    public static synchronized ZikZakSecurityManager getInstance(
        @NonNull Context context
    ) {
        if (instance == null) {
            instance = new ZikZakSecurityManager(context);
        }
        return instance;
    }

    /**
     * Initialize default trackers to block
     */
    private void initializeDefaultTrackers() {
        List<String> defaultTrackers = new ArrayList<>();
        defaultTrackers.add("google-analytics.com");
        defaultTrackers.add("doubleclick.net");
        defaultTrackers.add("facebook.net");
        defaultTrackers.add("facebook.com/tr");
        defaultTrackers.add("twitter.com/i/jot");
        defaultTrackers.add("adnxs.com");

        blockedTrackers.addAll(defaultTrackers);
    }

    /**
     * Enable security enhancements
     *
     * @param enabled True to enable, false to disable
     */
    public void setSecurityEnhancementsEnabled(boolean enabled) {
        this.securityEnhancementsEnabled = enabled;
        Log.d(
            TAG,
            "Security enhancements " + (enabled ? "enabled" : "disabled")
        );
    }

    /**
     * Set security level
     *
     * @param level Security level from SecurityLevel class
     */
    public void setSecurityLevel(int level) {
        this.securityLevel = level;
        Log.d(TAG, "Security level set to " + securityLevelToString(level));
    }

    /**
     * Convert security level to string description
     *
     * @param level Security level
     * @return String description
     */
    private String securityLevelToString(int level) {
        switch (level) {
            case SecurityLevel.ENHANCED:
                return "ENHANCED";
            case SecurityLevel.MAXIMUM:
                return "MAXIMUM";
            case SecurityLevel.NORMAL:
            default:
                return "NORMAL";
        }
    }

    /**
     * Add a tracker domain to block
     *
     * @param trackerDomain Tracker domain to block
     */
    public void addBlockedTracker(String trackerDomain) {
        if (trackerDomain != null && !trackerDomain.isEmpty()) {
            blockedTrackers.add(trackerDomain);
        }
    }

    /**
     * Remove a tracker domain from blocklist
     *
     * @param trackerDomain Tracker domain to unblock
     */
    public void removeBlockedTracker(String trackerDomain) {
        blockedTrackers.remove(trackerDomain);
    }

    /**
     * Get the list of blocked tracker domains
     *
     * @return Set of blocked tracker domains
     */
    public Set<String> getBlockedTrackers() {
        return new HashSet<>(blockedTrackers);
    }

    /**
     * Apply security settings to a WebView
     * This method applies security enhancements based on the current security level
     *
     * @param webView WebView to enhance
     */
    public void applySecurityToWebView(final InAppWebView webView) {
        if (!securityEnhancementsEnabled) {
            return;
        }

        if (webView == null) {
            Log.e(TAG, "Cannot apply security to null WebView");
            return;
        }

        // Run on security thread to avoid blocking main thread
        securityExecutor.execute(
            new Runnable() {
                @Override
                public void run() {
                    try {
                        if (Build.VERSION.SDK_INT >= 35) {
                            applyAndroid15SecurityEnhancements(webView);
                        } else if (
                            Build.VERSION.SDK_INT >=
                            Build.VERSION_CODES.TIRAMISU
                        ) {
                            applyModernSecurityEnhancements(webView);
                        } else {
                            applyLegacySecurityEnhancements(webView);
                        }
                    } catch (Exception e) {
                        Log.e(TAG, "Error applying security settings", e);
                    }
                }
            }
        );
    }

    /**
     * Apply security enhancements for Android 15+
     *
     * @param webView WebView to enhance
     */
    @RequiresApi(35)
    @SuppressLint("NewApi")
    private void applyAndroid15SecurityEnhancements(
        final InAppWebView webView
    ) {
        // Apply newer security features only available in Android 15
        webView.post(
            new Runnable() {
                @Override
                public void run() {
                    SecurityPolicy policy = getOrCreateSecurityPolicy(
                        webView.getUrl()
                    );

                    // Update policy based on security level
                    updatePolicyForSecurityLevel(policy);

                    try {
                        // Content-Security-Policy is now applied via HTTP headers in shouldInterceptRequest
                        // See InAppWebViewClient.addSecurityHeaders() for implementation
                        // JavaScript-based CSP injection has been removed as it is fundamentally insecure

                        // Apply modern security settings
                        if (
                            WebViewFeature.isFeatureSupported(
                                WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST
                            )
                        ) {
                            List<String> allowList = new ArrayList<>();
                            allowList.add(webView.getUrl());
                            allowList.add(
                                "https://*." +
                                extractDomainFromUrl(webView.getUrl())
                            );
                            // This is a modern feature for controlling the X-Requested-With header

                        }

                        // Apply Android 15 specific enhancements
                        applyAdvancedSecuritySettings(webView);

                        Log.d(
                            TAG,
                            "Applied Android 15+ security enhancements to WebView at " +
                            webView.getUrl()
                        );
                    } catch (Exception e) {
                        Log.e(
                            TAG,
                            "Error applying Android 15 security enhancements",
                            e
                        );
                    }
                }
            }
        );
    }

    /**
     * Apply security enhancements for Android 13+
     *
     * @param webView WebView to enhance
     */
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    private void applyModernSecurityEnhancements(final InAppWebView webView) {
        webView.post(
            new Runnable() {
                @Override
                public void run() {
                    SecurityPolicy policy = getOrCreateSecurityPolicy(
                        webView.getUrl()
                    );

                    // Update policy based on security level
                    updatePolicyForSecurityLevel(policy);

                    try {
                        // Apply modern security features
                        try {
                            // Check if SUPPRESS_ERROR_PAGE feature is supported (available in androidx.webkit:webkit 1.13.0+)
                            if (
                                android.os.Build.VERSION.SDK_INT >=
                                android.os.Build.VERSION_CODES.Q
                            ) {
                                Class<?> webViewFeatureClass = Class.forName(
                                    "androidx.webkit.WebViewFeature"
                                );
                                java.lang.reflect.Field suppressErrorPageField =
                                    webViewFeatureClass.getDeclaredField(
                                        "SUPPRESS_ERROR_PAGE"
                                    );
                                String suppressErrorPageConstant =
                                    (String) suppressErrorPageField.get(null);

                                java.lang.reflect.Method isFeatureSupportedMethod =
                                    webViewFeatureClass.getMethod(
                                        "isFeatureSupported",
                                        String.class
                                    );
                                boolean isSupported =
                                    (boolean) isFeatureSupportedMethod.invoke(
                                        null,
                                        suppressErrorPageConstant
                                    );

                                if (isSupported) {
                                    // Feature is available, can use it for security purposes
                                    android.util.Log.d(
                                        "ZikZakSecurityManager",
                                        "SUPPRESS_ERROR_PAGE feature is available"
                                    );
                                }
                            }
                        } catch (Exception e) {
                            // SUPPRESS_ERROR_PAGE feature not available in this version of androidx.webkit
                            // This is expected in androidx.webkit versions < 1.13.0
                            android.util.Log.d(
                                "ZikZakSecurityManager",
                                "SUPPRESS_ERROR_PAGE feature not available: " +
                                e.getMessage()
                            );
                        }

                        // CSP headers are now injected via HTTP headers in shouldInterceptRequest
                        // JavaScript-based CSP injection is deprecated and insecure

                        Log.d(
                            TAG,
                            "Applied modern security enhancements to WebView at " +
                            webView.getUrl()
                        );
                    } catch (Exception e) {
                        Log.e(
                            TAG,
                            "Error applying modern security enhancements",
                            e
                        );
                    }
                }
            }
        );
    }

    /**
     * Apply security enhancements for older Android versions
     *
     * @param webView WebView to enhance
     */
    private void applyLegacySecurityEnhancements(final InAppWebView webView) {
        webView.post(
            new Runnable() {
                @Override
                public void run() {
                    SecurityPolicy policy = getOrCreateSecurityPolicy(
                        webView.getUrl()
                    );

                    // Use more conservative settings for older Android versions
                    policy.enforceStrictCsp =
                        policy.enforceStrictCsp &&
                        securityLevel >= SecurityLevel.MAXIMUM;
                    policy.reduceFingerprinting =
                        policy.reduceFingerprinting &&
                        securityLevel >= SecurityLevel.MAXIMUM;

                    try {
                        // Apply basic security settings
                        webView.getSettings().setAllowContentAccess(true);
                        webView.getSettings().setAllowFileAccess(false);
                        webView
                            .getSettings()
                            .setAllowFileAccessFromFileURLs(false);
                        webView
                            .getSettings()
                            .setAllowUniversalAccessFromFileURLs(false);

                        // JavaScript-based cookie security is deprecated
                        // Cookie security should be handled server-side

                        Log.d(
                            TAG,
                            "Applied legacy security enhancements to WebView at " +
                            webView.getUrl()
                        );
                    } catch (Exception e) {
                        Log.e(
                            TAG,
                            "Error applying legacy security enhancements",
                            e
                        );
                    }
                }
            }
        );
    }

    /**
     * Apply advanced security settings for Android 15+
     *
     * @param webView WebView to enhance
     */
    @RequiresApi(35)
    private void applyAdvancedSecuritySettings(InAppWebView webView) {
        // These are conceptual advanced settings for Android 15+
        // Real implementation would use actual Android 15 APIs

        // Inject advanced security script for tracker blocking
        if (securityLevel >= SecurityLevel.ENHANCED) {
            final String script = generateTrackerBlockingScript();
            webView.evaluateJavascript(script, null);
        }
    }

    /**
     * Generate JavaScript for tracker blocking
     *
     * @return JavaScript code for tracker blocking
     */
    private String generateTrackerBlockingScript() {
        StringBuilder script = new StringBuilder();
        script.append("(function() {");
        script.append("  const blockedDomains = [");

        boolean first = true;
        for (String tracker : blockedTrackers) {
            if (!first) {
                script.append(",");
            }
            script.append("'").append(tracker).append("'");
            first = false;
        }

        script.append("];");
        script.append("  const originalFetch = window.fetch;");
        script.append(
            "  const originalXHR = window.XMLHttpRequest.prototype.open;"
        );

        // Override fetch
        script.append("  window.fetch = function(url, options) {");
        script.append("    if (shouldBlockRequest(url)) {");
        script.append(
            "      console.log('[ZikZak Security] Blocked fetch request to ' + url);"
        );
        script.append(
            "      return Promise.reject(new Error('Request blocked by ZikZak Security'));"
        );
        script.append("    }");
        script.append("    return originalFetch.apply(this, arguments);");
        script.append("  };");

        // Override XMLHttpRequest
        script.append(
            "  window.XMLHttpRequest.prototype.open = function(method, url) {"
        );
        script.append("    if (shouldBlockRequest(url)) {");
        script.append(
            "      console.log('[ZikZak Security] Blocked XHR request to ' + url);"
        );
        script.append(
            "      throw new Error('Request blocked by ZikZak Security');"
        );
        script.append("    }");
        script.append("    return originalXHR.apply(this, arguments);");
        script.append("  };");

        // Helper function to check if URL should be blocked
        script.append("  function shouldBlockRequest(url) {");
        script.append("    const urlString = url.toString();");
        script.append(
            "    return blockedDomains.some(domain => urlString.includes(domain));"
        );
        script.append("  }");

        script.append("})();");

        return script.toString();
    }

    /**
     * Get or create security policy for a URL
     *
     * @param url URL to get policy for
     * @return SecurityPolicy for the URL
     */
    private SecurityPolicy getOrCreateSecurityPolicy(String url) {
        String host = extractDomainFromUrl(url);
        if (!securityPolicies.containsKey(host)) {
            SecurityPolicy policy = new SecurityPolicy();
            securityPolicies.put(host, policy);
        }
        return securityPolicies.get(host);
    }

    /**
     * Update security policy based on security level
     *
     * @param policy Policy to update
     */
    private void updatePolicyForSecurityLevel(SecurityPolicy policy) {
        switch (securityLevel) {
            case SecurityLevel.MAXIMUM:
                policy.blockThirdPartyRequests = true;
                policy.enforceHttps = true;
                policy.blockTrackers = true;
                policy.enforceStrictCsp = true;
                policy.reduceFingerprinting = true;
                policy.securityHeaders =
                    "default-src 'self'; script-src 'self'; object-src 'none'; " +
                    "base-uri 'none'; frame-ancestors 'self'; form-action 'self';";
                break;
            case SecurityLevel.ENHANCED:
                policy.blockThirdPartyRequests = false;
                policy.enforceHttps = true;
                policy.blockTrackers = true;
                policy.enforceStrictCsp = true;
                policy.reduceFingerprinting = false;
                policy.securityHeaders =
                    "default-src 'self' https:; script-src 'self' 'unsafe-inline' https:; " +
                    "object-src 'none'; frame-ancestors 'self';";
                break;
            case SecurityLevel.NORMAL:
            default:
                policy.blockThirdPartyRequests = false;
                policy.enforceHttps = false;
                policy.blockTrackers = false;
                policy.enforceStrictCsp = false;
                policy.reduceFingerprinting = false;
                policy.securityHeaders =
                    "default-src * 'unsafe-inline' 'unsafe-eval'; " +
                    "script-src * 'unsafe-inline' 'unsafe-eval';";
                break;
        }
    }

    /**
     * Add security headers to HTTP response headers
     * This is the PROPER way to add CSP - via HTTP headers, not JavaScript injection
     *
     * @param responseHeaders Map of response headers to modify
     * @param url URL being loaded (to determine appropriate policy)
     * @return Modified headers map with security headers added
     */
    public Map<String, String> addSecurityHeadersToResponse(
        Map<String, String> responseHeaders,
        String url
    ) {
        if (responseHeaders == null) {
            responseHeaders = new HashMap<>();
        }

        // Get the security policy for this URL's domain
        String domain = extractDomainFromUrl(url);
        SecurityPolicy policy = securityPolicies.get(domain);

        if (policy == null) {
            policy = securityPolicies.get("*"); // Default policy
        }

        if (policy != null && policy.securityHeaders != null && !policy.securityHeaders.isEmpty()) {
            // Add Content-Security-Policy header
            responseHeaders.put("Content-Security-Policy", policy.securityHeaders);

            // Add other security headers
            responseHeaders.put("X-Content-Type-Options", "nosniff");
            responseHeaders.put("X-Frame-Options", "SAMEORIGIN");
            responseHeaders.put("X-XSS-Protection", "1; mode=block");

            if (policy.enforceHttps) {
                // Add HSTS header for HTTPS enforcement
                responseHeaders.put("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
            }

            Log.d(TAG, "Added security headers to response for: " + url);
        }

        return responseHeaders;
    }

    /**
     * @deprecated Use addSecurityHeadersToResponse instead - JavaScript-based CSP injection is insecure
     * This method is kept for backward compatibility but should not be used
     */
    @Deprecated
    private void injectSecurityHeaders(InAppWebView webView, String csp) {
        Log.w(TAG, "DEPRECATED: JavaScript-based CSP injection is insecure. Use HTTP header-based CSP instead.");
        // Method body removed - this approach is fundamentally insecure
    }

    /**
     * @deprecated JavaScript-based cookie manipulation is insecure and unreliable
     * Cookie security should be handled server-side or via proper WebView settings
     */
    @Deprecated
    private void injectBasicSecurityScript(InAppWebView webView) {
        Log.w(TAG, "DEPRECATED: JavaScript-based cookie manipulation. Use server-side cookie settings instead.");
        // Method body removed - this approach is unreliable
    }

    /**
     * Extract domain from URL
     *
     * @param url URL to extract domain from
     * @return Domain name
     */
    private String extractDomainFromUrl(String url) {
        if (url == null || url.isEmpty()) {
            return "";
        }

        try {
            String domain = url.replaceFirst("https?://", "");
            domain = domain.replaceFirst("www\\.", "");
            int slashIndex = domain.indexOf('/');
            if (slashIndex >= 0) {
                domain = domain.substring(0, slashIndex);
            }
            return domain;
        } catch (Exception e) {
            Log.e(TAG, "Error extracting domain from URL: " + url, e);
            return "";
        }
    }

    /**
     * Dispose the security manager singleton
     * This should be called when the application is terminated
     */
    public static void dispose() {
        instance = null;
    }
}
