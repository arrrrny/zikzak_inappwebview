package wtf.zikzak.zikzak_inappwebview_android.security;

import android.util.Base64;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.security.MessageDigest;
import java.security.cert.Certificate;
import java.security.cert.CertificateEncodingException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.net.ssl.SSLSession;
import javax.net.ssl.X509TrustManager;

/**
 * Manages SSL/TLS certificate pinning to prevent MITM attacks
 * Implements public key pinning using SHA-256 hashes
 */
public class CertificatePinningManager {

    private static final String TAG = "CertificatePinning";

    /**
     * Certificate pinning configuration for a specific host
     */
    public static class PinConfiguration {
        private final String hostname;
        private final List<String> publicKeyHashes; // Base64 encoded SHA256 hashes
        private final boolean includeSubdomains;
        private final boolean allowExpiredCertificates;

        public PinConfiguration(
            @NonNull String hostname,
            @NonNull List<String> publicKeyHashes,
            boolean includeSubdomains,
            boolean allowExpiredCertificates
        ) {
            this.hostname = hostname;
            this.publicKeyHashes = new ArrayList<>(publicKeyHashes);
            this.includeSubdomains = includeSubdomains;
            this.allowExpiredCertificates = allowExpiredCertificates;
        }

        public PinConfiguration(@NonNull String hostname, @NonNull List<String> publicKeyHashes) {
            this(hostname, publicKeyHashes, false, false);
        }

        public String getHostname() {
            return hostname;
        }

        public List<String> getPublicKeyHashes() {
            return new ArrayList<>(publicKeyHashes);
        }

        public boolean includesSubdomains() {
            return includeSubdomains;
        }

        public boolean allowsExpiredCertificates() {
            return allowExpiredCertificates;
        }
    }

    private final Map<String, PinConfiguration> pinConfigurations = new HashMap<>();
    private boolean enabled = false;

    public CertificatePinningManager() {}

    /**
     * Enable certificate pinning
     */
    public void enable() {
        enabled = true;
        Log.d(TAG, "Certificate pinning enabled");
    }

    /**
     * Disable certificate pinning
     */
    public void disable() {
        enabled = false;
        Log.d(TAG, "Certificate pinning disabled");
    }

    /**
     * Check if certificate pinning is enabled
     */
    public boolean isEnabled() {
        return enabled;
    }

    /**
     * Add a pin configuration for a hostname
     */
    public void addPinConfiguration(@NonNull PinConfiguration config) {
        pinConfigurations.put(config.getHostname(), config);
        Log.d(TAG, "Added pin configuration for: " + config.getHostname());
    }

    /**
     * Remove pin configuration for a hostname
     */
    public void removePinConfiguration(@NonNull String hostname) {
        pinConfigurations.remove(hostname);
        Log.d(TAG, "Removed pin configuration for: " + hostname);
    }

    /**
     * Clear all pin configurations
     */
    public void clearAllPinConfigurations() {
        pinConfigurations.clear();
        Log.d(TAG, "Cleared all pin configurations");
    }

    /**
     * Validate certificate chain against pinned certificates
     *
     * @param chain The certificate chain to validate
     * @param hostname The hostname being connected to
     * @return true if validation passes, false otherwise
     */
    public boolean validateCertificateChain(
        @Nullable Certificate[] chain,
        @NonNull String hostname
    ) {
        if (!enabled) {
            // Certificate pinning disabled, allow all
            return true;
        }

        if (chain == null || chain.length == 0) {
            Log.w(TAG, "Empty certificate chain for: " + hostname);
            return false;
        }

        // Check if we have a pin configuration for this host
        PinConfiguration config = getPinConfiguration(hostname);
        if (config == null) {
            // No pinning configured for this host, allow
            return true;
        }

        // Extract public key hashes from the certificate chain
        List<String> serverKeyHashes = new ArrayList<>();
        for (Certificate cert : chain) {
            if (cert instanceof X509Certificate) {
                try {
                    byte[] publicKey = cert.getPublicKey().getEncoded();
                    String hash = sha256Base64(publicKey);
                    serverKeyHashes.add(hash);
                } catch (Exception e) {
                    Log.e(TAG, "Failed to extract public key: " + e.getMessage());
                }
            }
        }

        if (serverKeyHashes.isEmpty()) {
            Log.w(TAG, "Failed to extract any public keys from certificate chain");
            return false;
        }

        // Check if any public key matches our pins
        for (String serverHash : serverKeyHashes) {
            if (config.getPublicKeyHashes().contains(serverHash)) {
                Log.d(TAG, "Certificate pinning validation passed for: " + hostname);
                return true;
            }
        }

        Log.w(TAG, "Certificate pinning validation FAILED for: " + hostname);
        Log.w(TAG, "Expected one of: " + config.getPublicKeyHashes());
        Log.w(TAG, "Got: " + serverKeyHashes);
        return false;
    }

    /**
     * Validate SSL session against pinned certificates
     *
     * @param sslSession The SSL session to validate
     * @param hostname The hostname being connected to
     * @return true if validation passes, false otherwise
     */
    public boolean validateSSLSession(
        @Nullable SSLSession sslSession,
        @NonNull String hostname
    ) {
        if (sslSession == null) {
            return false;
        }

        try {
            Certificate[] chain = sslSession.getPeerCertificates();
            return validateCertificateChain(chain, hostname);
        } catch (Exception e) {
            Log.e(TAG, "Failed to validate SSL session: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get pin configuration for a hostname
     * Supports subdomain matching if configured
     */
    @Nullable
    private PinConfiguration getPinConfiguration(@NonNull String hostname) {
        // Direct match
        PinConfiguration config = pinConfigurations.get(hostname);
        if (config != null) {
            return config;
        }

        // Check for parent domain matches with includeSubdomains
        String[] parts = hostname.split("\\.");
        for (int i = 1; i < parts.length; i++) {
            String parentDomain = String.join(".", java.util.Arrays.copyOfRange(parts, i, parts.length));
            config = pinConfigurations.get(parentDomain);
            if (config != null && config.includesSubdomains()) {
                Log.d(TAG, "Using parent domain pin config for " + hostname + " from " + parentDomain);
                return config;
            }
        }

        return null;
    }

    /**
     * Calculate SHA-256 hash of data and return as Base64 string
     */
    @NonNull
    private String sha256Base64(@NonNull byte[] data) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(data);
            return Base64.encodeToString(hash, Base64.NO_WRAP);
        } catch (Exception e) {
            Log.e(TAG, "SHA-256 calculation failed: " + e.getMessage());
            return "";
        }
    }

    /**
     * Generate SHA-256 hash for a certificate's public key
     * Useful for generating pins
     *
     * @param certificate The certificate
     * @return Base64 encoded SHA-256 hash of the public key
     */
    @Nullable
    public static String generatePublicKeyHash(@NonNull X509Certificate certificate) {
        try {
            byte[] publicKey = certificate.getPublicKey().getEncoded();
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(publicKey);
            return Base64.encodeToString(hash, Base64.NO_WRAP);
        } catch (Exception e) {
            Log.e(TAG, "Failed to generate public key hash: " + e.getMessage());
            return null;
        }
    }

    /**
     * Get current pin configurations (for debugging)
     */
    @NonNull
    public Map<String, PinConfiguration> getPinConfigurations() {
        return new HashMap<>(pinConfigurations);
    }
}
