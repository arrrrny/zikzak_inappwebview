package wtf.zikzak.zikzak_inappwebview_android.security;

import android.net.Uri;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashSet;
import java.util.Set;

/**
 * Manages HTTPS-only mode to prevent insecure HTTP connections
 * Supports three strategies: disabled, upgrade, and strict
 */
public class HTTPSOnlyManager {

    private static final String TAG = "HTTPSOnly";

    /**
     * HTTPS upgrade strategy
     */
    public enum UpgradeStrategy {
        DISABLED,   // Allow both HTTP and HTTPS
        UPGRADE,    // Automatically upgrade HTTP to HTTPS
        STRICT      // Block all HTTP requests
    }

    /**
     * Result of URL validation
     */
    public static class ValidationResult {
        private final boolean allowed;
        private final String upgradedURL;
        private final String reason;

        public ValidationResult(boolean allowed, @Nullable String upgradedURL, @Nullable String reason) {
            this.allowed = allowed;
            this.upgradedURL = upgradedURL;
            this.reason = reason;
        }

        public boolean isAllowed() {
            return allowed;
        }

        @Nullable
        public String getUpgradedURL() {
            return upgradedURL;
        }

        @Nullable
        public String getReason() {
            return reason;
        }

        @Override
        public String toString() {
            return "ValidationResult{allowed=" + allowed + ", upgradedURL='" + upgradedURL + "', reason='" + reason + "'}";
        }
    }

    private UpgradeStrategy strategy = UpgradeStrategy.DISABLED;
    private final Set<String> allowedHTTPHosts = new HashSet<>();

    public HTTPSOnlyManager() {}

    /**
     * Set the HTTPS enforcement strategy
     */
    public void setStrategy(@NonNull UpgradeStrategy strategy) {
        this.strategy = strategy;
        Log.d(TAG, "HTTPS strategy set to: " + strategy);
    }

    /**
     * Get current strategy
     */
    @NonNull
    public UpgradeStrategy getStrategy() {
        return strategy;
    }

    /**
     * Add a host to the HTTP whitelist (for upgrade/strict modes)
     */
    public void addAllowedHTTPHost(@NonNull String host) {
        allowedHTTPHosts.add(host.toLowerCase());
        Log.d(TAG, "Added HTTP whitelist host: " + host);
    }

    /**
     * Remove a host from the HTTP whitelist
     */
    public void removeAllowedHTTPHost(@NonNull String host) {
        allowedHTTPHosts.remove(host.toLowerCase());
        Log.d(TAG, "Removed HTTP whitelist host: " + host);
    }

    /**
     * Clear all allowed HTTP hosts
     */
    public void clearAllowedHTTPHosts() {
        allowedHTTPHosts.clear();
        Log.d(TAG, "Cleared all HTTP whitelist hosts");
    }

    /**
     * Get all allowed HTTP hosts
     */
    @NonNull
    public Set<String> getAllowedHTTPHosts() {
        return new HashSet<>(allowedHTTPHosts);
    }

    /**
     * Check if a URL should be allowed
     *
     * @param url The URL string to check
     * @return ValidationResult indicating if URL is allowed and any upgraded URL
     */
    @NonNull
    public ValidationResult validateURL(@NonNull String url) {
        Uri uri;
        try {
            uri = Uri.parse(url);
        } catch (Exception e) {
            Log.w(TAG, "Failed to parse URL: " + url);
            return new ValidationResult(false, null, "Invalid URL format");
        }

        String scheme = uri.getScheme();
        if (scheme == null || scheme.isEmpty()) {
            return new ValidationResult(false, null, "No scheme specified");
        }

        scheme = scheme.toLowerCase();

        // HTTPS is always allowed
        if ("https".equals(scheme)) {
            return new ValidationResult(true, null, null);
        }

        // HTTP handling based on strategy
        if ("http".equals(scheme)) {
            // Check if host is in whitelist
            String host = uri.getHost();
            if (host != null && allowedHTTPHosts.contains(host.toLowerCase())) {
                Log.d(TAG, "HTTP allowed for whitelisted host: " + host);
                return new ValidationResult(true, null, "Host is whitelisted for HTTP");
            }

            switch (strategy) {
                case DISABLED:
                    // Allow HTTP
                    return new ValidationResult(true, null, null);

                case UPGRADE:
                    // Attempt to upgrade to HTTPS
                    String httpsURL = upgradeToHTTPS(uri);
                    if (httpsURL != null) {
                        Log.d(TAG, "Upgraded HTTP to HTTPS: " + url + " -> " + httpsURL);
                        return new ValidationResult(true, httpsURL, "Upgraded HTTP to HTTPS");
                    } else {
                        Log.w(TAG, "Failed to upgrade HTTP to HTTPS: " + url);
                        return new ValidationResult(false, null, "Failed to upgrade to HTTPS");
                    }

                case STRICT:
                    // Block HTTP
                    Log.w(TAG, "Blocked HTTP connection in strict mode: " + url);
                    return new ValidationResult(false, null, "HTTP connections blocked in strict mode");

                default:
                    return new ValidationResult(true, null, null);
            }
        }

        // Non-HTTP/HTTPS schemes (file, data, etc.) - allow by default
        // Can be extended to handle other schemes
        return new ValidationResult(true, null, null);
    }

    /**
     * Attempt to upgrade an HTTP URL to HTTPS
     *
     * @param uri The HTTP URI to upgrade
     * @return The HTTPS URL string, or null if upgrade failed
     */
    @Nullable
    private String upgradeToHTTPS(@NonNull Uri uri) {
        try {
            Uri.Builder builder = uri.buildUpon();
            builder.scheme("https");

            // Handle default port (80 for HTTP should not appear in HTTPS URL)
            if (uri.getPort() == 80) {
                builder.encodedAuthority(uri.getHost());
            }

            return builder.build().toString();
        } catch (Exception e) {
            Log.e(TAG, "Failed to upgrade URL to HTTPS: " + e.getMessage());
            return null;
        }
    }

    /**
     * Check if HTTPS enforcement is active
     *
     * @return true if strategy is UPGRADE or STRICT
     */
    public boolean isEnforcing() {
        return strategy == UpgradeStrategy.UPGRADE || strategy == UpgradeStrategy.STRICT;
    }
}
