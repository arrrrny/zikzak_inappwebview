package wtf.zikzak.zikzak_inappwebview_android;

import android.util.Log;

/**
 * Security event logging utility for ZikZak InAppWebView.
 *
 * Provides privacy-safe logging for security-related events including:
 * - Certificate pinning validation
 * - HTTPS-only mode enforcement
 * - URL validation failures
 * - SSL/TLS errors
 * - Safe Browsing detections
 *
 * @since v3.0.0
 */
public class SecurityLogger {

    private static final String TAG = "ZikZakWebView.Security";
    private static final boolean ENABLE_LOGGING = true; // Set to false for production if needed

    /**
     * Log certificate pinning validation events
     */
    public static void logCertificatePinning(String event, String host, boolean success) {
        if (!ENABLE_LOGGING) return;

        String message = String.format(
            "[CERT_PINNING] %s | Host: %s | Success: %b",
            event, sanitizeHost(host), success
        );

        if (success) {
            Log.i(TAG, message);
        } else {
            Log.w(TAG, message);
        }
    }

    /**
     * Log HTTPS-only mode events
     */
    public static void logHttpsOnly(String action, String url, String reason) {
        if (!ENABLE_LOGGING) return;

        String message = String.format(
            "[HTTPS_ONLY] %s | URL: %s | Reason: %s",
            action, sanitizeUrl(url), reason
        );

        Log.i(TAG, message);
    }

    /**
     * Log URL validation failures
     */
    public static void logUrlValidation(String url, String reason, String action) {
        if (!ENABLE_LOGGING) return;

        String message = String.format(
            "[URL_VALIDATION] Blocked: %s | Reason: %s | Action: %s",
            sanitizeUrl(url), reason, action
        );

        Log.w(TAG, message);
    }

    /**
     * Log SSL/TLS errors
     */
    public static void logSslError(String errorType, String host, String details) {
        if (!ENABLE_LOGGING) return;

        String message = String.format(
            "[SSL_ERROR] Type: %s | Host: %s | Details: %s",
            errorType, sanitizeHost(host), details
        );

        Log.e(TAG, message);
    }

    /**
     * Log Safe Browsing detections
     */
    public static void logSafeBrowsing(String threatType, String url, String action) {
        if (!ENABLE_LOGGING) return;

        String message = String.format(
            "[SAFE_BROWSING] Threat: %s | URL: %s | Action: %s",
            threatType, sanitizeUrl(url), action
        );

        Log.w(TAG, message);
    }

    /**
     * Log general security events
     */
    public static void logSecurityEvent(String eventType, String description) {
        if (!ENABLE_LOGGING) return;

        String message = String.format(
            "[SECURITY_EVENT] %s | %s",
            eventType, description
        );

        Log.i(TAG, message);
    }

    /**
     * Sanitize URL for logging - remove query parameters and fragments to avoid
     * leaking sensitive data like tokens, session IDs, or personal information
     */
    private static String sanitizeUrl(String url) {
        if (url == null || url.isEmpty()) {
            return "[empty]";
        }

        try {
            // Remove query params and fragments
            int queryIndex = url.indexOf('?');
            int fragmentIndex = url.indexOf('#');

            int endIndex = url.length();
            if (queryIndex > 0) {
                endIndex = Math.min(endIndex, queryIndex);
            }
            if (fragmentIndex > 0) {
                endIndex = Math.min(endIndex, fragmentIndex);
            }

            String sanitized = url.substring(0, endIndex);

            // Indicate if query params or fragments were removed
            boolean hasQuery = queryIndex > 0;
            boolean hasFragment = fragmentIndex > 0;

            if (hasQuery || hasFragment) {
                sanitized += "[...]";
            }

            return sanitized;
        } catch (Exception e) {
            return "[invalid-url]";
        }
    }

    /**
     * Sanitize hostname for logging
     */
    private static String sanitizeHost(String host) {
        if (host == null || host.isEmpty()) {
            return "[empty]";
        }

        // Host is generally safe to log, but truncate if too long
        if (host.length() > 100) {
            return host.substring(0, 97) + "...";
        }

        return host;
    }
}
