import Foundation
import OSLog

/**
 * Security event logging utility for ZikZak InAppWebView.
 *
 * Provides privacy-safe logging for security-related events using Apple's unified logging system (OSLog).
 * Events include:
 * - Certificate pinning validation
 * - HTTPS-only mode enforcement
 * - URL validation failures
 * - SSL/TLS errors
 *
 * @since v3.0.0
 */
@available(iOS 15.0, *)
public class SecurityLogger {

    private static let subsystem = "wtf.zikzak.inappwebview"
    private static let category = "Security"
    private static let logger = Logger(subsystem: subsystem, category: category)
    private static let enableLogging = true // Set to false for production if needed

    /**
     * Log certificate pinning validation events
     */
    public static func logCertificatePinning(event: String, host: String, success: Bool) {
        guard enableLogging else { return }

        let message = "[CERT_PINNING] \(event) | Host: \(sanitizeHost(host)) | Success: \(success)"

        if success {
            logger.info("\(message, privacy: .public)")
        } else {
            logger.warning("\(message, privacy: .public)")
        }
    }

    /**
     * Log HTTPS-only mode events
     */
    public static func logHttpsOnly(action: String, url: String, reason: String) {
        guard enableLogging else { return }

        let message = "[HTTPS_ONLY] \(action) | URL: \(sanitizeUrl(url)) | Reason: \(reason)"
        logger.info("\(message, privacy: .public)")
    }

    /**
     * Log URL validation failures
     */
    public static func logUrlValidation(url: String, reason: String, action: String) {
        guard enableLogging else { return }

        let message = "[URL_VALIDATION] Blocked: \(sanitizeUrl(url)) | Reason: \(reason) | Action: \(action)"
        logger.warning("\(message, privacy: .public)")
    }

    /**
     * Log SSL/TLS errors
     */
    public static func logSslError(errorType: String, host: String, details: String) {
        guard enableLogging else { return }

        let message = "[SSL_ERROR] Type: \(errorType) | Host: \(sanitizeHost(host)) | Details: \(details)"
        logger.error("\(message, privacy: .public)")
    }

    /**
     * Log general security events
     */
    public static func logSecurityEvent(eventType: String, description: String) {
        guard enableLogging else { return }

        let message = "[SECURITY_EVENT] \(eventType) | \(description)"
        logger.info("\(message, privacy: .public)")
    }

    /**
     * Sanitize URL for logging - remove query parameters and fragments to avoid
     * leaking sensitive data like tokens, session IDs, or personal information
     */
    private static func sanitizeUrl(_ url: String) -> String {
        if url.isEmpty {
            return "[empty]"
        }

        guard let urlComponents = URLComponents(string: url) else {
            return "[invalid-url]"
        }

        // Build URL without query params or fragments
        var components = urlComponents
        components.query = nil
        components.fragment = nil

        var sanitized = components.string ?? url

        // Indicate if query params or fragments were removed
        let hasQuery = urlComponents.query != nil
        let hasFragment = urlComponents.fragment != nil

        if hasQuery || hasFragment {
            sanitized += "[...]"
        }

        return sanitized
    }

    /**
     * Sanitize hostname for logging
     */
    private static func sanitizeHost(_ host: String) -> String {
        if host.isEmpty {
            return "[empty]"
        }

        // Host is generally safe to log, but truncate if too long
        if host.count > 100 {
            return String(host.prefix(97)) + "..."
        }

        return host
    }
}
