//
//  CertificatePinningManager.swift
//  zikzak_inappwebview_ios
//
//  Created by ZikZak Team on 2025-11-05.
//

import Foundation
import Security
import CommonCrypto

/// Manages SSL/TLS certificate pinning to prevent MITM attacks
public class CertificatePinningManager {

    /// Certificate pinning configuration for a specific host
    public struct PinConfiguration {
        let hostname: String
        let publicKeyHashes: [String] // Base64 encoded SHA256 hashes
        let includeSubdomains: Bool
        let allowExpiredCertificates: Bool

        public init(hostname: String,
                   publicKeyHashes: [String],
                   includeSubdomains: Bool = false,
                   allowExpiredCertificates: Bool = false) {
            self.hostname = hostname
            self.publicKeyHashes = publicKeyHashes
            self.includeSubdomains = includeSubdomains
            self.allowExpiredCertificates = allowExpiredCertificates
        }
    }

    private var pinConfigurations: [String: PinConfiguration] = [:]
    private var enabled: Bool = false

    public init() {}

    /// Enable certificate pinning
    public func enable() {
        enabled = true
    }

    /// Disable certificate pinning
    public func disable() {
        enabled = false
    }

    /// Add a pin configuration for a hostname
    public func addPinConfiguration(_ config: PinConfiguration) {
        pinConfigurations[config.hostname] = config
    }

    /// Remove pin configuration for a hostname
    public func removePinConfiguration(hostname: String) {
        pinConfigurations.removeValue(forKey: hostname)
    }

    /// Clear all pin configurations
    public func clearAllPinConfigurations() {
        pinConfigurations.removeAll()
    }

    /// Validate server trust against pinned certificates
    /// - Parameters:
    ///   - serverTrust: The server trust to validate
    ///   - hostname: The hostname being connected to
    /// - Returns: true if validation passes, false otherwise
    public func validateServerTrust(_ serverTrust: SecTrust, hostname: String) -> Bool {
        guard enabled else {
            // Certificate pinning disabled, allow all
            return true
        }

        // Check if we have a pin configuration for this host
        guard let config = getPinConfiguration(for: hostname) else {
            // No pinning configured for this host, allow
            return true
        }

        // Validate the certificate chain
        var error: CFError?
        guard SecTrustEvaluateWithError(serverTrust, &error) else {
            if let error = error {
                print("[CertificatePinning] Trust evaluation failed: \(error)")
            }
            return false
        }

        // Extract public keys from the certificate chain
        guard let serverPublicKeys = extractPublicKeys(from: serverTrust) else {
            print("[CertificatePinning] Failed to extract public keys")
            return false
        }

        // Check if any public key matches our pins
        for serverKey in serverPublicKeys {
            let serverKeyHash = sha256(data: serverKey)
            let serverKeyHashBase64 = serverKeyHash.base64EncodedString()

            if config.publicKeyHashes.contains(serverKeyHashBase64) {
                print("[CertificatePinning] ✅ Certificate pinning validation passed for \(hostname)")
                return true
            }
        }

        print("[CertificatePinning] ❌ Certificate pinning validation FAILED for \(hostname)")
        print("[CertificatePinning] None of the server's public keys match the pinned hashes")
        return false
    }

    /// Get pin configuration for a hostname (supports subdomains)
    private func getPinConfiguration(for hostname: String) -> PinConfiguration? {
        // Exact match
        if let config = pinConfigurations[hostname] {
            return config
        }

        // Check for subdomain matches
        for (configHost, config) in pinConfigurations {
            if config.includeSubdomains && hostname.hasSuffix("." + configHost) {
                return config
            }
        }

        return nil
    }

    /// Extract public keys from the certificate chain
    private func extractPublicKeys(from serverTrust: SecTrust) -> [Data]? {
        var publicKeys: [Data] = []

        let certificateCount = SecTrustGetCertificateCount(serverTrust)
        guard certificateCount > 0 else {
            return nil
        }

        for index in 0..<certificateCount {
            guard let certificate = SecTrustGetCertificateAtIndex(serverTrust, index) else {
                continue
            }

            guard let publicKey = extractPublicKey(from: certificate) else {
                continue
            }

            publicKeys.append(publicKey)
        }

        return publicKeys.isEmpty ? nil : publicKeys
    }

    /// Extract public key from a certificate
    private func extractPublicKey(from certificate: SecCertificate) -> Data? {
        // Get the public key from the certificate
        guard let publicKey = SecCertificateCopyKey(certificate) else {
            return nil
        }

        // Get the external representation of the public key
        var error: Unmanaged<CFError>?
        guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? else {
            if let error = error?.takeRetainedValue() {
                print("[CertificatePinning] Failed to get public key data: \(error)")
            }
            return nil
        }

        return publicKeyData
    }

    /// Compute SHA256 hash of data
    private func sha256(data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }

    /// Helper to create a pin configuration from a certificate file
    public static func createPinConfiguration(
        hostname: String,
        certificateData: Data,
        includeSubdomains: Bool = false
    ) -> PinConfiguration? {
        guard let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) else {
            print("[CertificatePinning] Failed to create certificate from data")
            return nil
        }

        guard let publicKey = SecCertificateCopyKey(certificate) else {
            print("[CertificatePinning] Failed to extract public key from certificate")
            return nil
        }

        var error: Unmanaged<CFError>?
        guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? else {
            print("[CertificatePinning] Failed to get public key data")
            return nil
        }

        // Compute SHA256 hash
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        publicKeyData.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(publicKeyData.count), &hash)
        }
        let hashData = Data(hash)
        let hashBase64 = hashData.base64EncodedString()

        return PinConfiguration(
            hostname: hostname,
            publicKeyHashes: [hashBase64],
            includeSubdomains: includeSubdomains
        )
    }
}
