//
//  HTTPSOnlyManager.swift
//  zikzak_inappwebview_ios
//
//  Created by ZikZak Team on 2025-11-05.
//

import Foundation

/// Manages HTTPS-only mode to prevent insecure HTTP connections
public class HTTPSOnlyManager {

    /// HTTPS upgrade strategy
    public enum UpgradeStrategy {
        case disabled       // Allow both HTTP and HTTPS
        case upgrade        // Automatically upgrade HTTP to HTTPS
        case strict         // Block all HTTP requests
    }

    private var strategy: UpgradeStrategy = .disabled
    private var allowedHTTPHosts: Set<String> = [] // Whitelist for HTTP exceptions

    public init() {}

    /// Set the HTTPS enforcement strategy
    public func setStrategy(_ strategy: UpgradeStrategy) {
        self.strategy = strategy
    }

    /// Get current strategy
    public func getStrategy() -> UpgradeStrategy {
        return strategy
    }

    /// Add a host to the HTTP whitelist (for upgrade/strict modes)
    public func addAllowedHTTPHost(_ host: String) {
        allowedHTTPHosts.insert(host.lowercased())
    }

    /// Remove a host from the HTTP whitelist
    public func removeAllowedHTTPHost(_ host: String) {
        allowedHTTPHosts.remove(host.lowercased())
    }

    /// Clear all allowed HTTP hosts
    public func clearAllowedHTTPHosts() {
        allowedHTTPHosts.removeAll()
    }

    /// Check if a URL should be allowed
    /// - Parameter url: The URL to check
    /// - Returns: ValidationResult indicating if URL is allowed and any upgraded URL
    public func validateURL(_ url: URL) -> ValidationResult {
        guard let scheme = url.scheme?.lowercased() else {
            return ValidationResult(allowed: false, upgradedURL: nil, reason: "No scheme specified")
        }

        // HTTPS is always allowed
        if scheme == "https" {
            return ValidationResult(allowed: true, upgradedURL: nil, reason: nil)
        }

        // HTTP handling based on strategy
        if scheme == "http" {
            // Check if host is in whitelist
            if let host = url.host?.lowercased(), allowedHTTPHosts.contains(host) {
                return ValidationResult(allowed: true, upgradedURL: nil, reason: "Host is whitelisted for HTTP")
            }

            switch strategy {
            case .disabled:
                // Allow HTTP
                return ValidationResult(allowed: true, upgradedURL: nil, reason: nil)

            case .upgrade:
                // Attempt to upgrade to HTTPS
                if let httpsURL = upgradeToHTTPS(url) {
                    return ValidationResult(
                        allowed: true,
                        upgradedURL: httpsURL,
                        reason: "Upgraded HTTP to HTTPS"
                    )
                } else {
                    return ValidationResult(
                        allowed: false,
                        upgradedURL: nil,
                        reason: "Failed to upgrade to HTTPS"
                    )
                }

            case .strict:
                // Block HTTP
                return ValidationResult(
                    allowed: false,
                    upgradedURL: nil,
                    reason: "HTTP connections blocked in strict mode"
                )
            }
        }

        // Non-HTTP/HTTPS schemes (file, data, etc.) - allow by default
        // Can be extended to handle other schemes
        return ValidationResult(allowed: true, upgradedURL: nil, reason: nil)
    }

    /// Attempt to upgrade an HTTP URL to HTTPS
    private func upgradeToHTTPS(_ url: URL) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url
    }

    /// Result of URL validation
    public struct ValidationResult {
        public let allowed: Bool
        public let upgradedURL: URL?
        public let reason: String?

        public init(allowed: Bool, upgradedURL: URL?, reason: String?) {
            self.allowed = allowed
            self.upgradedURL = upgradedURL
            self.reason = reason
        }
    }
}
