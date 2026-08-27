//
//  Util.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS Util helpers used by the methods added in #197.
//  Only the helpers actually referenced from the macOS InAppWebView are
//  included here (getContentWorld, JSONStringify, getUrlAsset) to keep the
//  surface area minimal.
//

import Foundation
import FlutterMacOS
import WebKit

public class Util {
    /// Resolve a Flutter asset path to a file:// URL the WKWebView can load.
    /// Mirrors the iOS `Util.getUrlAsset` but uses the macOS registrar's
    /// `lookupKey(forAsset:)` + `Bundle.main.url`.
    public static func getUrlAsset(
        registrar: FlutterPluginRegistrar, assetFilePath: String
    ) throws -> URL {
        let key = registrar.lookupKey(forAsset: assetFilePath)
        guard let assetURL = Bundle.main.url(forResource: key, withExtension: nil) else {
            throw NSError(domain: assetFilePath + " asset file cannot be found!", code: 0)
        }
        return assetURL
    }

    public static func JSONStringify(value: Any, prettyPrinted: Bool = false) -> String {
        let options: JSONSerialization.WritingOptions =
            prettyPrinted ? .prettyPrinted : .init(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(
                withJSONObject: value, options: options),
                let string = String(data: data, encoding: .utf8)
            {
                return string
            }
        }
        return ""
    }

    public static func getContentWorld(name: String) -> WKContentWorld {
        switch name {
        case "defaultClient":
            return WKContentWorld.defaultClient
        case "page":
            return WKContentWorld.page
        default:
            return WKContentWorld.world(name: name)
        }
    }
}

extension Util {
    /// Resolve a Flutter asset path to an absolute file-system path (used for
    /// PKCS#12 certificate files during auth-challenge handling).
    public static func getAbsPathAsset(
        plugin: InAppWebViewFlutterPlugin, assetFilePath: String
    ) throws -> String {
        guard let key = plugin.registrar?.lookupKey(forAsset: assetFilePath),
              let assetAbsPath = Bundle.main.path(forResource: key, ofType: nil) else {
            throw NSError(domain: assetFilePath + " asset file cannot be found!", code: 0)
        }
        return assetAbsPath
    }
}
