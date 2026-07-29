//
//  ProxyManager.swift
//  zikzak_inappwebview
//

import Foundation
import Network
import WebKit

@available(iOS 17.0, *)
public class ProxyManager: ChannelDelegate {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/zikzak_inappwebview_proxycontroller"
    static let DEFAULT_PROXY_SCHEME = "http"
    
    private var plugin: SwiftFlutterPlugin?
    
    init(plugin: SwiftFlutterPlugin) {
        super.init(channel: FlutterMethodChannel(name: ProxyManager.METHOD_CHANNEL_NAME, binaryMessenger: plugin.registrar!.messenger()))
        self.plugin = plugin
    }
    
    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case "setProxyOverride":
            if let args = arguments?["settings"] as? [String: Any] {
                let settings = ProxySettings.fromMap(args)
                do {
                    let proxyConfiguration = try resolveProxyConfiguration(settings)
                    let websiteDataStore = WKWebsiteDataStore.default()
                    websiteDataStore.proxyConfigurations = [proxyConfiguration]
                    result(true)
                } catch let error as ProxyConfigurationError {
                    result(FlutterError(code: error.code, message: error.message, details: nil))
                } catch {
                    result(FlutterError(code: "PROXY_CONFIGURATION_ERROR", message: error.localizedDescription, details: nil))
                }
                break
            } else {
                result(false)
                break
            }
        case "clearProxyOverride":
            WKWebsiteDataStore.default().proxyConfigurations = []
            result(true)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    private func resolveProxyConfiguration (_ settings: ProxySettings) throws -> ProxyConfiguration {
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
              let port = NWEndpoint.Port(rawValue: UInt16(portValue)) else {
            throw ProxyConfigurationError.invalidProxyUrl
        }
        
        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: port)
        let isSocksProxy = schemeType == "SOCKS" || schemeType == "SOCKS5"
        let isHttpConnectProxy = schemeType == "HTTP" || schemeType == "HTTPS"
        
        guard isSocksProxy || isHttpConnectProxy else {
            throw ProxyConfigurationError.unsupportedProxyScheme
        }
        
        var proxyConfiguration = isSocksProxy ?
        ProxyConfiguration(socksv5Proxy: endpoint) : ProxyConfiguration(httpCONNECTProxy: endpoint)
        
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
        
        guard let asciiHost = host.applyingTransform(.toASCII, reverse: false),
              !asciiHost.isEmpty,
              asciiHost.count <= 253 else {
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
                  labelValue.range(of: "^[A-Za-z0-9-]+$", options: .regularExpression) != nil else {
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
            matchDomains: matchDomains
        )
    }
}
