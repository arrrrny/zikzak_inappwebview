//
//  SecurityCoordinator.swift
//  zikzak_inappwebview_ios
//
//  Created by ZikZak Team on 2025-11-05.
//

import Foundation
import WebKit

/// Coordinates all security features for WebView
public class SecurityCoordinator {

    // Security managers
    public let certificatePinning: CertificatePinningManager
    public let httpsOnly: HTTPSOnlyManager
    public let urlValidation: URLValidationManager

    // Configuration
    private var securityEnabled: Bool = true
    private var auditLoggingEnabled: Bool = false

    public init() {
        self.certificatePinning = CertificatePinningManager()
        self.httpsOnly = HTTPSOnlyManager()
        self.urlValidation = URLValidationManager()
    }

    /// Enable or disable all security features
    public func setSecurityEnabled(_ enabled: Bool) {
        self.securityEnabled = enabled
        if !enabled {
            logSecurityEvent("⚠️  All security features disabled")
        }
    }

    /// Enable or disable audit logging
    public func setAuditLoggingEnabled(_ enabled: Bool) {
        self.auditLoggingEnabled = enabled
    }

    /// Validate a navigation request
    /// - Parameter request: The navigation request to validate
    /// - Returns: SecurityDecision indicating whether to allow the navigation
    public func validateNavigationRequest(_ request: URLRequest) -> SecurityDecision {
        guard securityEnabled else {
            return SecurityDecision(allowed: true, modifiedURL: nil, reason: "Security disabled")
        }

        guard let url = request.url else {
            return SecurityDecision(allowed: false, modifiedURL: nil, reason: "No URL in request")
        }

        // 1. URL Scheme Validation
        let urlValidationResult = urlValidation.validateURL(url)
        if !urlValidationResult.allowed {
            logSecurityEvent("🚫 URL validation failed: \(url.absoluteString) - \(urlValidationResult.reason ?? "unknown")")
            return SecurityDecision(allowed: false, modifiedURL: nil, reason: urlValidationResult.reason)
        }

        // 2. HTTPS-Only Mode Check
        let httpsValidationResult = httpsOnly.validateURL(url)
        if !httpsValidationResult.allowed {
            logSecurityEvent("🚫 HTTPS validation failed: \(url.absoluteString) - \(httpsValidationResult.reason ?? "unknown")")
            return SecurityDecision(allowed: false, modifiedURL: nil, reason: httpsValidationResult.reason)
        }

        // If URL should be upgraded to HTTPS
        if let upgradedURL = httpsValidationResult.upgradedURL {
            logSecurityEvent("⬆️  Upgraded HTTP to HTTPS: \(url.absoluteString) → \(upgradedURL.absoluteString)")
            return SecurityDecision(allowed: true, modifiedURL: upgradedURL, reason: "Upgraded to HTTPS")
        }

        logSecurityEvent("✅ Navigation request validated: \(url.absoluteString)")
        return SecurityDecision(allowed: true, modifiedURL: nil, reason: nil)
    }

    /// Validate an SSL/TLS challenge (for certificate pinning)
    /// - Parameters:
    ///   - challenge: The authentication challenge
    ///   - completionHandler: Handler to call with the disposition and credential
    /// - Returns: true if handled, false if should use default handling
    public func handleAuthenticationChallenge(
        _ challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) -> Bool {
        guard securityEnabled else {
            return false // Use default handling
        }

        // Only handle server trust challenges for certificate pinning
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            return false // Not our concern
        }

        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            logSecurityEvent("🚫 No server trust in challenge")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return true
        }

        let hostname = challenge.protectionSpace.host

        // Validate certificate pinning
        let isValid = certificatePinning.validateServerTrust(serverTrust, hostname: hostname)

        if isValid {
            logSecurityEvent("✅ Certificate pinning validated for \(hostname)")
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            logSecurityEvent("🚫 Certificate pinning validation FAILED for \(hostname)")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }

        return true
    }

    /// Log a security event
    private func logSecurityEvent(_ message: String) {
        if auditLoggingEnabled {
            let timestamp = ISO8601DateFormatter().string(from: Date())
            print("[SecurityAudit] \(timestamp) - \(message)")
        }
    }

    /// Security decision result
    public struct SecurityDecision {
        public let allowed: Bool
        public let modifiedURL: URL?
        public let reason: String?

        public init(allowed: Bool, modifiedURL: URL?, reason: String?) {
            self.allowed = allowed
            self.modifiedURL = modifiedURL
            self.reason = reason
        }
    }
}

/// Security configuration that can be passed from Dart
public struct SecurityConfiguration: Codable {
    // Certificate Pinning
    public var certificatePins: [CertificatePin]?
    public var certificatePinningEnabled: Bool?

    // HTTPS-Only Mode
    public var httpsOnlyMode: String? // "disabled", "upgrade", "strict"
    public var allowedHTTPHosts: [String]?

    // URL Validation
    public var customSafeSchemes: [String]?
    public var customBlockedSchemes: [String]?

    // Audit Logging
    public var auditLoggingEnabled: Bool?

    public struct CertificatePin: Codable {
        public let hostname: String
        public let publicKeyHashes: [String]
        public let includeSubdomains: Bool?
        public let allowExpiredCertificates: Bool?
    }
}
