//
//  ProxyManager.swift
//  zikzak_inappwebview_macos
//
//  macOS proxy controller using WKWebsiteDataStore.proxyConfigurations
//  (available macOS 14.0+ / Sonoma). Mirrors the iOS ProxyManager.swift.
//

import FlutterMacOS
import Foundation
import Network
import WebKit

@available(macOS 14.0, *)
public class ProxyManager: ChannelDelegate {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/zikzak_inappwebview_proxycontroller"
    static let DEFAULT_PROXY_SCHEME = "http"

    private var plugin: InAppWebViewFlutterPlugin?

    /// Per-profile proxy configurations keyed by persistentStoreIdentifier.
    /// When a WebView is created with a custom data store, the proxy for its
    /// identifier is applied to that data store.
    static var profileProxies: [String: ProxyConfiguration] = [:]

    init(plugin: InAppWebViewFlutterPlugin) {
        super.init(
            channel: FlutterMethodChannel(
                name: ProxyManager.METHOD_CHANNEL_NAME,
                binaryMessenger: plugin.registrar!.messenger))
        self.plugin = plugin
    }

    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case "setProxyOverride":
            if let settingsMap = arguments?["settings"] as? [String: Any] {
                let settings = ProxySettings.fromMap(settingsMap)
                let profileId = arguments?["profileId"] as? String
                do {
                    let proxyConfiguration = try resolveProxyConfiguration(settings)
                    if let pid = profileId, !pid.isEmpty {
                        ProxyManager.profileProxies[pid] = proxyConfiguration
                    }
                    WKWebsiteDataStore.default().proxyConfigurations = [proxyConfiguration]
                    result(true)
                } catch let error as ProxyConfigurationError {
                    result(FlutterError(code: error.code, message: error.message, details: nil))
                } catch {
                    result(
                        FlutterError(
                            code: "PROXY_CONFIGURATION_ERROR",
                            message: error.localizedDescription,
                            details: nil))
                }
            } else {
                result(false)
            }
        case "clearProxyOverride":
            if let args = arguments as? [String: Any],
               let profileId = args["profileId"] as? String {
                ProxyManager.profileProxies.removeValue(forKey: profileId)
            } else {
                ProxyManager.profileProxies.removeAll()
            }
            WKWebsiteDataStore.default().proxyConfigurations = []
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Applies the stored proxy configuration for [identifier] to [dataStore].
    /// Called by the WebView factory when a custom data store is created.
    public static func applyProxy(forIdentifier identifier: String, to dataStore: WKWebsiteDataStore) {
        guard let config = profileProxies[identifier] else { return }
        dataStore.proxyConfigurations = [config]
    }

    private func resolveProxyConfiguration(_ settings: ProxySettings) throws -> ProxyConfiguration {
        let proxyUrl = normalizeProxyUrl(settings.proxyUrl)
        guard let components = URLComponents(string: proxyUrl) else {
            throw ProxyConfigurationError.invalidProxyUrl
        }

        let schemeType = (components.scheme ?? ProxyManager.DEFAULT_PROXY_SCHEME).uppercased()
        guard let host = components.host, !host.isEmpty else {
            throw ProxyConfigurationError.invalidProxyUrl
        }
        guard isValidHost(host) else {
            throw ProxyConfigurationError.invalidProxyUrl
        }
        guard let portValue = components.port,
            (1...65535).contains(portValue),
            let port = NWEndpoint.Port(rawValue: UInt16(portValue))
        else {
            throw ProxyConfigurationError.invalidProxyUrl
        }

        let endpoint = NWEndpoint.hostPort(
            host: NWEndpoint.Host(host), port: port)
        let isSocksProxy = schemeType == "SOCKS" || schemeType == "SOCKS5"
        let isHttpConnectProxy = schemeType == "HTTP" || schemeType == "HTTPS"

        guard isSocksProxy || isHttpConnectProxy else {
            throw ProxyConfigurationError.unsupportedProxyScheme
        }

        var proxyConfiguration =
            isSocksProxy
            ? ProxyConfiguration(socksv5Proxy: endpoint)
            : ProxyConfiguration(httpCONNECTProxy: endpoint)

        proxyConfiguration.allowFailover = settings.allowFailover
        proxyConfiguration.excludedDomains = settings.excludedDomains
        proxyConfiguration.matchDomains = settings.matchDomains
        return proxyConfiguration
    }

    private func normalizeProxyUrl(_ proxyUrl: String) -> String {
        let trimmed = proxyUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.contains("://") {
            return trimmed
        }
        return "\(ProxyManager.DEFAULT_PROXY_SCHEME)://\(trimmed)"
    }

    private func isValidHost(_ host: String) -> Bool {
        if IPv4Address(host) != nil || IPv6Address(host) != nil {
            return true
        }

        guard
            let asciiHost = host.applyingTransform(
                StringTransform(rawValue: "Any-Latin; Latin-ASCII"), reverse: false),
            !asciiHost.isEmpty,
            asciiHost.count <= 253
        else {
            return false
        }

        let labels = asciiHost.split(separator: ".", omittingEmptySubsequences: false)
        if labels.isEmpty {
            return false
        }

        for label in labels {
            let labelValue = String(label)
            guard !labelValue.isEmpty,
                labelValue.count <= 63,
                !labelValue.hasPrefix("-"),
                !labelValue.hasSuffix("-"),
                labelValue.range(
                    of: "^[A-Za-z0-9-]+$",
                    options: NSString.CompareOptions.regularExpression)
                    != nil
            else {
                return false
            }
        }

        return true
    }

    public override func dispose() {
        super.dispose()
        plugin = nil
    }

    private enum ProxyConfigurationError: Error {
        case invalidProxyUrl
        case unsupportedProxyScheme

        var code: String {
            switch self {
            case .invalidProxyUrl:
                return "INVALID_PROXY_URL"
            case .unsupportedProxyScheme:
                return "UNSUPPORTED_PROXY_SCHEME"
            }
        }

        var message: String {
            switch self {
            case .invalidProxyUrl:
                return "Proxy URL must include a valid host and port."
            case .unsupportedProxyScheme:
                return "Proxy URL scheme must be HTTP, HTTPS, SOCKS, or SOCKS5."
            }
        }
    }

    deinit {
        dispose()
    }
}

private class ProxySettings {
    let allowFailover: Bool
    let excludedDomains: [String]
    let matchDomains: [String]
    let proxyUrl: String

    init(
        proxyUrl: String = "",
        allowFailover: Bool = false,
        excludedDomains: [String] = [],
        matchDomains: [String] = []
    ) {
        self.proxyUrl = proxyUrl
        self.allowFailover = allowFailover
        self.excludedDomains = excludedDomains
        self.matchDomains = matchDomains
    }

    static func fromMap(_ map: [String: Any]) -> ProxySettings {
        let allowFailover = map["allowFailover"] as? Bool ?? false
        let excludedDomains = map["excludedDomains"] as? [String] ?? []
        let matchDomains = map["matchDomains"] as? [String] ?? []
        let proxyUrl = map["proxyUrl"] as? String ?? ""

        return ProxySettings(
            proxyUrl: proxyUrl,
            allowFailover: allowFailover,
            excludedDomains: excludedDomains,
            matchDomains: matchDomains)
    }
}
