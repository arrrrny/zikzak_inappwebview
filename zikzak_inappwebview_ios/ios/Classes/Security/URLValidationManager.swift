//
//  URLValidationManager.swift
//  zikzak_inappwebview_ios
//
//  Created by ZikZak Team on 2025-11-05.
//

import Foundation

/// Manages URL validation to prevent malicious URLs and schemes
public class URLValidationManager {

    /// URL schemes that are considered safe by default
    private static let defaultSafeSchemes: Set<String> = [
        "http", "https", "file", "data", "about", "blob"
    ]

    /// URL schemes that are blocked by default (security risk)
    private static let defaultBlockedSchemes: Set<String> = [
        "javascript", "vbscript", "jar", "wyciwyg"
    ]

    private var safeSchemes: Set<String>
    private var blockedSchemes: Set<String>
    private var customValidator: ((URL) -> ValidationResult)?

    public init() {
        self.safeSchemes = URLValidationManager.defaultSafeSchemes
        self.blockedSchemes = URLValidationManager.defaultBlockedSchemes
    }

    /// Add a safe scheme
    public func addSafeScheme(_ scheme: String) {
        safeSchemes.insert(scheme.lowercased())
        blockedSchemes.remove(scheme.lowercased())
    }

    /// Add a blocked scheme
    public func addBlockedScheme(_ scheme: String) {
        blockedSchemes.insert(scheme.lowercased())
        safeSchemes.remove(scheme.lowercased())
    }

    /// Remove a safe scheme
    public func removeSafeScheme(_ scheme: String) {
        safeSchemes.remove(scheme.lowercased())
    }

    /// Remove a blocked scheme
    public func removeBlockedScheme(_ scheme: String) {
        blockedSchemes.remove(scheme.lowercased())
    }

    /// Set a custom URL validator
    public func setCustomValidator(_ validator: @escaping (URL) -> ValidationResult) {
        self.customValidator = validator
    }

    /// Validate a URL
    /// - Parameter url: The URL to validate
    /// - Returns: ValidationResult indicating if URL is safe
    public func validateURL(_ url: URL) -> ValidationResult {
        // Run custom validator first if set
        if let customValidator = customValidator {
            let result = customValidator(url)
            if !result.allowed {
                return result
            }
        }

        // Check scheme
        guard let scheme = url.scheme?.lowercased() else {
            return ValidationResult(
                allowed: false,
                reason: "URL has no scheme"
            )
        }

        // Check if scheme is explicitly blocked
        if blockedSchemes.contains(scheme) {
            return ValidationResult(
                allowed: false,
                reason: "URL scheme '\(scheme)' is blocked for security reasons"
            )
        }

        // Check if scheme is in safe list
        if safeSchemes.contains(scheme) {
            // Perform additional validation for specific schemes
            return validateSchemeSpecific(url: url, scheme: scheme)
        }

        // Unknown scheme - be conservative and block
        return ValidationResult(
            allowed: false,
            reason: "URL scheme '\(scheme)' is not in the safe schemes list"
        )
    }

    /// Perform scheme-specific validation
    private func validateSchemeSpecific(url: URL, scheme: String) -> ValidationResult {
        switch scheme {
        case "javascript":
            // Should never reach here as javascript is blocked by default
            return ValidationResult(
                allowed: false,
                reason: "JavaScript execution via URL is not allowed"
            )

        case "file":
            // Validate file URLs to prevent directory traversal
            return validateFileURL(url)

        case "data":
            // Validate data URLs
            return validateDataURL(url)

        default:
            // Default: allow if in safe schemes
            return ValidationResult(allowed: true, reason: nil)
        }
    }

    /// Validate file URLs
    private func validateFileURL(_ url: URL) -> ValidationResult {
        let path = url.path

        // Check for directory traversal attempts
        if path.contains("../") || path.contains("..\\") {
            return ValidationResult(
                allowed: false,
                reason: "File URL contains directory traversal patterns"
            )
        }

        // Check for suspicious patterns
        if path.contains("//") {
            return ValidationResult(
                allowed: false,
                reason: "File URL contains suspicious path patterns"
            )
        }

        return ValidationResult(allowed: true, reason: nil)
    }

    /// Validate data URLs
    private func validateDataURL(_ url: URL) -> ValidationResult {
        let urlString = url.absoluteString

        // Check for embedded javascript in data URLs
        let lowercased = urlString.lowercased()
        if lowercased.contains("javascript:") ||
           lowercased.contains("<script") ||
           lowercased.contains("onerror=") ||
           lowercased.contains("onload=") {
            return ValidationResult(
                allowed: false,
                reason: "Data URL contains potentially malicious content"
            )
        }

        return ValidationResult(allowed: true, reason: nil)
    }

    /// Validate a URL string
    /// - Parameter urlString: The URL string to validate
    /// - Returns: ValidationResult indicating if URL is safe
    public func validateURLString(_ urlString: String) -> ValidationResult {
        // Check for obvious XSS attempts
        let lowercased = urlString.lowercased()
        let dangerousPatterns = [
            "javascript:",
            "vbscript:",
            "data:text/html",
            "<script",
            "onerror=",
            "onload="
        ]

        for pattern in dangerousPatterns {
            if lowercased.contains(pattern) {
                return ValidationResult(
                    allowed: false,
                    reason: "URL string contains potentially malicious pattern: \(pattern)"
                )
            }
        }

        // Try to parse as URL
        guard let url = URL(string: urlString) else {
            return ValidationResult(
                allowed: false,
                reason: "Invalid URL format"
            )
        }

        return validateURL(url)
    }

    /// Result of URL validation
    public struct ValidationResult {
        public let allowed: Bool
        public let reason: String?

        public init(allowed: Bool, reason: String?) {
            self.allowed = allowed
            self.reason = reason
        }
    }
}
