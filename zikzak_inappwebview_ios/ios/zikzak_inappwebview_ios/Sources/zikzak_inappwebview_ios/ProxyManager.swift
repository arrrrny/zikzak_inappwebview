//
//  ProxyManager.swift
//  zikzak_inappwebview
//

import Flutter
import Foundation
import Network
import WebKit

@available(iOS 17.0, *)
public class ProxyManager: ChannelDelegate {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/zikzak_inappwebview_proxycontroller"
    static let DEFAULT_PROXY_SCHEME = "http"

    private var plugin: SwiftFlutterPlugin?

    /// Per-profile proxy configurations keyed by persistentStoreIdentifier
    /// (issue #410, mirrors the macOS ProxyManager). When a WebView is
    /// created with a custom data store, the proxy for its identifier is
    /// applied to that data store by `applyProxy(forIdentifier:to:)` —
    /// without the registry the configuration only ever reached the default
    /// store, and isolated profiles egressed directly.
    static var profileProxies: [String: ProxyConfiguration] = [:]

    /// Data stores created for a persistent identifier, held weakly so the
    /// registry never keeps a store alive. `setProxyOverride` writes the new
    /// configuration onto every live store of the profile, which covers web
    /// content processes created after the toggle. WebKit applies
    /// `proxyConfigurations` only to processes created after the write, so a
    /// page that is already loading keeps its route until its process is
    /// recreated — documented on `ProxySettings.profileId` and in the
    /// CHANGELOG.
    private static var liveStores: [String: NSHashTable<WKWebsiteDataStore>] = [:]

    /// Canonical registry key. `persistentUUID(from:)` trims an identifier
    /// before mapping it to a store, so the registry must trim too: a padded
    /// `persistentStoreIdentifier` and a padded `profileId` address the same
    /// on-disk store, and an untrimmed key would make them miss each other.
    private static func registryKey(_ identifier: String) -> String {
        identifier.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(plugin: SwiftFlutterPlugin) {
        super.init(
            channel: FlutterMethodChannel(
                name: ProxyManager.METHOD_CHANNEL_NAME,
                binaryMessenger: plugin.registrar!.messenger()))
        self.plugin = plugin
    }

    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case "setProxyOverride":
            if let args = arguments?["settings"] as? [String: Any] {
                let settings = ProxySettings.fromMap(args)
                let profileId = arguments?["profileId"] as? String
                do {
                    let proxyConfiguration = try resolveProxyConfiguration(settings)
                    if let pid = profileId.map(ProxyManager.registryKey), !pid.isEmpty {
                        ProxyManager.profileProxies[pid] = proxyConfiguration
                        // Live stores of this profile get the new route now,
                        // so a toggle reaches tabs whose data store already
                        // exists. The shared store is NOT touched: a
                        // per-profile route must never leak onto the store
                        // every identifier-less profile uses.
                        ProxyManager.applyProxyToLiveStores(
                            forIdentifier: pid, configuration: proxyConfiguration)
                    } else {
                        WKWebsiteDataStore.default().proxyConfigurations = [proxyConfiguration]
                    }
                    result(true)
                } catch let error as ProxyConfigurationError {
                    result(FlutterError(code: error.code, message: error.message, details: nil))
                } catch {
                    result(
                        FlutterError(
                            code: "PROXY_CONFIGURATION_ERROR", message: error.localizedDescription,
                            details: nil))
                }
                break
            } else {
                result(false)
                break
            }
        case "clearProxyOverride":
            // Symmetric with the set path: an empty identifier is not a
            // scoped clear, so it wipes the registry like a bare clear does
            // instead of removing a "" key that no entry ever uses.
            if let args = arguments as? [String: Any],
               let profileId = args["profileId"] as? String,
               !ProxyManager.registryKey(profileId).isEmpty {
                let key = ProxyManager.registryKey(profileId)
                ProxyManager.profileProxies.removeValue(forKey: key)
                ProxyManager.liveStores.removeValue(forKey: key)?.allObjects.forEach {
                    $0.proxyConfigurations = []
                }
            } else {
                ProxyManager.profileProxies.removeAll()
                ProxyManager.liveStores.values.flatMap { $0.allObjects }.forEach {
                    $0.proxyConfigurations = []
                }
                ProxyManager.liveStores.removeAll()
            }
            WKWebsiteDataStore.default().proxyConfigurations = []
            result(true)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    /// Applies the stored proxy configuration for [identifier] to [dataStore]
    /// and registers the store as live for that identifier, so a later
    /// `setProxyOverride` can reach it (mirrors the macOS port; issue #410).
    public static func applyProxy(forIdentifier identifier: String, to dataStore: WKWebsiteDataStore) {
        let key = registryKey(identifier)
        guard !key.isEmpty else { return }
        registerLiveStore(dataStore, forKey: key)
        guard let config = profileProxies[key] else { return }
        dataStore.proxyConfigurations = [config]
    }

    private static func registerLiveStore(_ dataStore: WKWebsiteDataStore, forKey key: String) {
        let table = liveStores[key] ?? NSHashTable<WKWebsiteDataStore>.weakObjects()
        table.add(dataStore)
        liveStores[key] = table
    }

    private static func applyProxyToLiveStores(
        forIdentifier identifier: String, configuration: ProxyConfiguration
    ) {
        liveStores[registryKey(identifier)]?.allObjects.forEach {
            $0.proxyConfigurations = [configuration]
        }
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

        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: port)
        let isSocksProxy = schemeType == "SOCKS" || schemeType == "SOCKS5"
        let isHttpConnectProxy = schemeType == "HTTP" || schemeType == "HTTPS"

        guard isSocksProxy || isHttpConnectProxy else {
            throw ProxyConfigurationError.unsupportedProxyScheme
        }

        // TLS to the proxy itself only when the URL scheme is https://:
        // NWProtocolTLS.Options() makes Network.framework negotiate TLS with
        // the proxy endpoint (its certificate is validated against the system
        // trust store; the hostname endpoint supplies the TLS peer name)
        // instead of sending a plaintext CONNECT that a TLS-only proxy resets.
        let isTlsProxy = schemeType == "HTTPS"

        var proxyConfiguration: ProxyConfiguration
        if isSocksProxy {
            proxyConfiguration = ProxyConfiguration(socksv5Proxy: endpoint)
        } else {
            proxyConfiguration = ProxyConfiguration(
                httpCONNECTProxy: endpoint,
                tlsOptions: isTlsProxy ? NWProtocolTLS.Options() : nil)
        }

        // Credentials travel only in the URL (ProxySettings has no
        // username/password fields). URLComponents' `user`/`password`
        // accessors already return percent-decoded values, so they are passed
        // through as-is — a second decoding pass would corrupt credentials
        // containing a literal `%`. Without this, an authenticated proxy
        // answers 407 Proxy Authentication Required and pages silently never
        // load.
        //
        // Both proxy legs consume them: the HTTP CONNECT leg uses them as
        // proxy authentication, and the socksv5 leg performs SOCKS5's
        // username/password sub-negotiation (RFC 1929). The SOCKS5 hop was
        // verified against a local SOCKS5 listener, which saw the greeting
        // offer method 0x02 and then received these exact values.
        if let user = components.user, !user.isEmpty {
            proxyConfiguration.applyCredential(
                username: user,
                password: components.password ?? "")
        }

        proxyConfiguration.allowFailover = settings.allowFailover
        proxyConfiguration.excludedDomains = settings.excludedDomains
        proxyConfiguration.matchDomains = settings.matchDomains
        return proxyConfiguration
    }

    private func normalizeProxyUrl(_ proxyUrl: String) -> String {
        let trimmedProxyUrl = proxyUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedProxyUrl.contains("://") {
            return trimmedProxyUrl
        }
        return "\(ProxyManager.DEFAULT_PROXY_SCHEME)://\(trimmedProxyUrl)"
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
                    of: "^[A-Za-z0-9-]+$", options: NSString.CompareOptions.regularExpression)
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
                return """
                    Proxy URL scheme must be HTTP, HTTPS, SOCKS, or SOCKS5.
                    http:// sends a plaintext CONNECT; https:// negotiates TLS
                    with the proxy (its certificate is validated).
                    SOCKS/SOCKS5 uses SOCKS v5 without TLS. Credentials in the
                    URL (user:pass@) are percent-decoded and applied as proxy
                    authentication.
                    """
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
            matchDomains: matchDomains
        )
    }
}
