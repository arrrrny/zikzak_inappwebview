package wtf.zikzak.zikzak_inappwebview_android.security;

import android.net.Uri;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.function.Function;

/**
 * Manages URL validation to prevent malicious URLs and schemes
 * Prevents javascript:, vbscript:, and other dangerous URL schemes
 */
public class URLValidationManager {

    private static final String TAG = "URLValidation";

    /** URL schemes that are considered safe by default */
    private static final Set<String> DEFAULT_SAFE_SCHEMES = new HashSet<>(Arrays.asList(
        "http", "https", "file", "data", "about", "blob", "content"
    ));

    /** URL schemes that are blocked by default (security risk) */
    private static final Set<String> DEFAULT_BLOCKED_SCHEMES = new HashSet<>(Arrays.asList(
        "javascript", "vbscript", "jar", "wyciwyg"
    ));

    private final Set<String> safeSchemes;
    private final Set<String> blockedSchemes;
    private Function<String, ValidationResult> customValidator;

    public URLValidationManager() {
        this.safeSchemes = new HashSet<>(DEFAULT_SAFE_SCHEMES);
        this.blockedSchemes = new HashSet<>(DEFAULT_BLOCKED_SCHEMES);
        this.customValidator = null;
    }

    /**
     * Add a safe scheme
     * @param scheme Scheme to add to safe list
     */
    public void addSafeScheme(@NonNull String scheme) {
        String lower = scheme.toLowerCase();
        safeSchemes.add(lower);
        blockedSchemes.remove(lower);
    }

    /**
     * Add a blocked scheme
     * @param scheme Scheme to block
     */
    public void addBlockedScheme(@NonNull String scheme) {
        String lower = scheme.toLowerCase();
        blockedSchemes.add(lower);
        safeSchemes.remove(lower);
    }

    /**
     * Remove a safe scheme
     * @param scheme Scheme to remove from safe list
     */
    public void removeSafeScheme(@NonNull String scheme) {
        safeSchemes.remove(scheme.toLowerCase());
    }

    /**
     * Remove a blocked scheme
     * @param scheme Scheme to remove from blocked list
     */
    public void removeBlockedScheme(@NonNull String scheme) {
        blockedSchemes.remove(scheme.toLowerCase());
    }

    /**
     * Set a custom URL validator
     * @param validator Custom validation function
     */
    public void setCustomValidator(@Nullable Function<String, ValidationResult> validator) {
        this.customValidator = validator;
    }

    /**
     * Validate a URL
     * @param url URL to validate
     * @return ValidationResult indicating if URL is safe
     */
    @NonNull
    public ValidationResult validateURL(@NonNull String url) {
        // Run custom validator first if set
        if (customValidator != null) {
            ValidationResult result = customValidator.apply(url);
            if (!result.allowed) {
                Log.d(TAG, "Custom validator blocked URL: " + url);
                return result;
            }
        }

        // Parse the URL
        Uri uri;
        try {
            uri = Uri.parse(url);
        } catch (Exception e) {
            Log.w(TAG, "Failed to parse URL: " + url + " - " + e.getMessage());
            return new ValidationResult(false, "Invalid URL format: " + e.getMessage());
        }

        // Check scheme
        String scheme = uri.getScheme();
        if (scheme == null || scheme.isEmpty()) {
            Log.w(TAG, "URL has no scheme: " + url);
            return new ValidationResult(false, "URL has no scheme");
        }

        scheme = scheme.toLowerCase();

        // Check if scheme is explicitly blocked
        if (blockedSchemes.contains(scheme)) {
            Log.w(TAG, "Blocked dangerous URL scheme '" + scheme + "': " + url);
            return new ValidationResult(
                false,
                "URL scheme '" + scheme + "' is blocked for security reasons"
            );
        }

        // Check if scheme is in safe list
        if (safeSchemes.contains(scheme)) {
            // Perform additional validation for specific schemes
            return validateSchemeSpecific(url, uri, scheme);
        }

        // Unknown scheme - be conservative and block
        Log.w(TAG, "Blocked unknown URL scheme '" + scheme + "': " + url);
        return new ValidationResult(
            false,
            "URL scheme '" + scheme + "' is not in the safe schemes list"
        );
    }

    /**
     * Perform scheme-specific validation
     * @param url Original URL string
     * @param uri Parsed URI
     * @param scheme URL scheme
     * @return ValidationResult
     */
    @NonNull
    private ValidationResult validateSchemeSpecific(
        @NonNull String url,
        @NonNull Uri uri,
        @NonNull String scheme
    ) {
        switch (scheme) {
            case "javascript":
                // Should never reach here as javascript is blocked by default
                return new ValidationResult(
                    false,
                    "JavaScript execution via URL is not allowed"
                );

            case "file":
                // Validate file URLs to prevent directory traversal
                return validateFileURL(uri);

            case "data":
                // Validate data URLs
                return validateDataURL(url);

            default:
                // Default: allow if in safe schemes
                return new ValidationResult(true, null);
        }
    }

    /**
     * Validate file URLs
     * @param uri Parsed file URI
     * @return ValidationResult
     */
    @NonNull
    private ValidationResult validateFileURL(@NonNull Uri uri) {
        String path = uri.getPath();
        if (path == null) {
            path = "";
        }

        // Check for directory traversal attempts
        if (path.contains("../") || path.contains("..\\")) {
            return new ValidationResult(
                false,
                "File URL contains directory traversal patterns"
            );
        }

        // Check for suspicious patterns
        // Allow double slashes at the start (e.g., UNC paths), but not elsewhere
        if (path.indexOf("//") > 0) {
            return new ValidationResult(
                false,
                "File URL contains suspicious path patterns"
            );
        }

        return new ValidationResult(true, null);
    }

    /**
     * Validate data URLs
     * @param url URL string
     * @return ValidationResult
     */
    @NonNull
    private ValidationResult validateDataURL(@NonNull String url) {
        String lowercased = url.toLowerCase();

        // Check for embedded javascript in data URLs
        if (lowercased.contains("javascript:") ||
            lowercased.contains("<script") ||
            lowercased.contains("onerror=") ||
            lowercased.contains("onload=")) {
            return new ValidationResult(
                false,
                "Data URL contains potentially malicious content"
            );
        }

        return new ValidationResult(true, null);
    }

    /**
     * Validate a URL string and check for XSS patterns
     * @param urlString URL string to validate
     * @return ValidationResult
     */
    @NonNull
    public ValidationResult validateURLString(@NonNull String urlString) {
        // Check for obvious XSS attempts
        String lowercased = urlString.toLowerCase();
        String[] dangerousPatterns = {
            "javascript:",
            "vbscript:",
            "data:text/html",
            "<script",
            "onerror=",
            "onload="
        };

        for (String pattern : dangerousPatterns) {
            if (lowercased.contains(pattern)) {
                return new ValidationResult(
                    false,
                    "URL string contains potentially malicious pattern: " + pattern
                );
            }
        }

        return validateURL(urlString);
    }

    /**
     * Result of URL validation
     */
    public static class ValidationResult {
        public final boolean allowed;
        @Nullable
        public final String reason;

        public ValidationResult(boolean allowed, @Nullable String reason) {
            this.allowed = allowed;
            this.reason = reason;
        }

        @Override
        public String toString() {
            return "ValidationResult{allowed=" + allowed + ", reason='" + reason + "'}";
        }
    }
}
