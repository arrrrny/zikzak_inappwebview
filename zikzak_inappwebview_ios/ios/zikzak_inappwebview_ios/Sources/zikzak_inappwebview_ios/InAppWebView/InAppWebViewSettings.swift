//
//  InAppWebViewSettings.swift
//  zikzak_inappwebview
//
//  Created by Lorenzo on 21/10/18.
//

import UIKit
import WebKit

@objcMembers
public class InAppWebViewSettings: ISettings<InAppWebView> {

    var useShouldOverrideUrlLoading = false
    var useOnLoadResource = false
    var useOnDownloadStart = false
    @available(*, deprecated, message: "Use InAppWebViewManager.clearAllCache instead.")
    var clearCache = false
    var userAgent = ""
    var applicationNameForUserAgent = ""
    var javaScriptEnabled = true
    var javaScriptCanOpenWindowsAutomatically = false
    var mediaPlaybackRequiresUserGesture = true
    var verticalScrollBarEnabled = true
    var horizontalScrollBarEnabled = true
    var resourceCustomSchemes: [String] = []
    var contentBlockers: [[String: [String: Any]]] = []
    var minimumFontSize = 0
    var useShouldInterceptAjaxRequest = false
    var interceptOnlyAsyncAjaxRequests = true
    var useShouldInterceptFetchRequest = false
    var incognito = false
    /// Stable identifier for a per-instance persistent WKWebsiteDataStore
    /// (iOS 17+/macOS 14+). Mirrors the Dart-side field; populated from
    /// the JSON dict by ISettings.parse via KVC. Mutually exclusive with
    /// `incognito`; init-time-only — websiteDataStore is immutable after
    /// the WKWebView is created.
    var persistentStoreIdentifier: String? = nil
    var cacheEnabled = true
    var transparentBackground = false
    var disableVerticalScroll = false
    var disableHorizontalScroll = false
    var disableContextMenu = false
    var supportZoom = true
    var allowUniversalAccessFromFileURLs = false
    var allowFileAccessFromFileURLs = false

    var disallowOverScroll = false
    var enableViewportScale = false
    var suppressesIncrementalRendering = false
    var allowsAirPlayForMediaPlayback = true
    var allowsBackForwardNavigationGestures = true
    var allowsLinkPreview = true
    var ignoresViewportScaleLimits = false
    var allowsInlineMediaPlayback = false
    var allowsPictureInPictureMediaPlayback = true
    var isFraudulentWebsiteWarningEnabled = true
    var selectionGranularity = 0
    var dataDetectorTypes: [String] = ["NONE"]  // WKDataDetectorTypeNone
    var preferredContentMode = 0
    var sharedCookiesEnabled = false
    var automaticallyAdjustsScrollIndicatorInsets = false
    var accessibilityIgnoresInvertColors = false
    var decelerationRate = "NORMAL"  // UIScrollView.DecelerationRate.normal
    var alwaysBounceVertical = false
    var alwaysBounceHorizontal = false
    /// Controls whether the scroll view bounces horizontally when it reaches the
    /// end of its content. iOS 17.4+ only; `nil` (default) leaves the scroll
    /// view's own default (`true`) untouched.
    var bouncesHorizontally: Bool? = nil
    /// Controls whether the scroll view bounces vertically when it reaches the
    /// end of its content. iOS 17.4+ only; `nil` (default) leaves the scroll
    /// view's own default (`true`) untouched.
    var bouncesVertically: Bool? = nil
    var scrollsToTop = true
    var isPagingEnabled = false
    var maximumZoomScale = 1.0
    var minimumZoomScale = 1.0
    var contentInsetAdjustmentBehavior = 2  // UIScrollView.ContentInsetAdjustmentBehavior.never
    var isDirectionalLockEnabled = false
    var mediaType: String? = nil
    var pageZoom = 1.0
    var limitsNavigationsToAppBoundDomains = false
    var useOnNavigationResponse = false
    var applePayAPIEnabled = false
    var allowingReadAccessTo: String? = nil
    var disableLongPressContextMenuOnLinks = false
    var disableInputAccessoryView = false
    var underPageBackgroundColor: String?
    var isTextInteractionEnabled = true
    var isSiteSpecificQuirksModeEnabled = true
    var upgradeKnownHostsToHTTPS = true
    var isElementFullscreenEnabled = true
    var isFindInteractionEnabled = false
    var minimumViewportInset: UIEdgeInsets? = nil
    var maximumViewportInset: UIEdgeInsets? = nil
    var isInspectable = false
    var shouldPrintBackgrounds = false
    var webAuthenticationSupport = 0
    var dismissDialogues = true
    var consoleLogEnabled = true

    override init() {
        super.init()
    }

    // MARK: - Enum wire-name helpers
    // The Dart surface serializes InAppWebViewSettings enums as String names
    // (see the generated EnumMaps). Native WebKit exposes them as Int rawValues,
    // so we translate in both directions.

    private func preferredContentModeName(_ rawValue: Int) -> String {
        switch rawValue {
        case 1: return "MOBILE"
        case 2: return "DESKTOP"
        default: return "RECOMMENDED"
        }
    }

    private func selectionGranularityName(_ rawValue: Int) -> String {
        switch rawValue {
        case 1: return "CHARACTER"
        default: return "DYNAMIC"
        }
    }

    private func contentInsetAdjustmentBehaviorName(_ rawValue: Int) -> String {
        switch rawValue {
        case 1: return "SCROLLABLE_AXES"
        case 2: return "NEVER"
        case 3: return "ALWAYS"
        default: return "AUTOMATIC"
        }
    }

    private func webAuthenticationSupportName(_ rawValue: Int) -> String {
        switch rawValue {
        case 1: return "FOR_APP"
        case 2: return "FOR_BROWSER"
        default: return "NONE"
        }
    }

    private func preferredContentModeRawValue(_ name: String?) -> Int {
        switch name {
        case "MOBILE": return 1
        case "DESKTOP": return 2
        default: return 0
        }
    }

    private func selectionGranularityRawValue(_ name: String?) -> Int {
        switch name {
        case "CHARACTER": return 1
        default: return 0
        }
    }

    private func contentInsetAdjustmentBehaviorRawValue(_ name: String?) -> Int {
        switch name {
        case "SCROLLABLE_AXES": return 1
        case "NEVER": return 2
        case "ALWAYS": return 3
        default: return 0
        }
    }

    private func webAuthenticationSupportRawValue(_ name: String?) -> Int {
        switch name {
        case "FOR_BROWSER": return 2
        case "FOR_APP": return 1
        default: return 0
        }
    }

    override func parse(settings: [String: Any?]) -> InAppWebViewSettings {
        var settings = settings  // re-assing to be able to use removeValue
        // Translate enum String wire names coming from the Dart surface back to
        // the Int rawValues the WebKit properties expect. Legacy Int values are
        // passed through unchanged.
        let enumHandlers: [(String, (String?) -> Int)] = [
            ("preferredContentMode", preferredContentModeRawValue),
            ("selectionGranularity", selectionGranularityRawValue),
            ("contentInsetAdjustmentBehavior", contentInsetAdjustmentBehaviorRawValue),
            ("webAuthenticationSupport", webAuthenticationSupportRawValue),
        ]
        for (key, converter) in enumHandlers {
            if let value = settings[key] {
                if let name = value as? String {
                    settings[key] = converter(name)
                } else if !(value is NSNull), value != nil {
                    // keep non-String, non-null values (e.g. legacy Int) as-is
                } else {
                    settings.removeValue(forKey: key)
                }
            }
        }
        if let minimumViewportInsetMap = settings["minimumViewportInset"] as? [String: Double] {
            minimumViewportInset = UIEdgeInsets.fromMap(map: minimumViewportInsetMap)
            settings.removeValue(forKey: "minimumViewportInset")
        }
        if let maximumViewportInsetMap = settings["maximumViewportInset"] as? [String: Double] {
            maximumViewportInset = UIEdgeInsets.fromMap(map: maximumViewportInsetMap)
            settings.removeValue(forKey: "maximumViewportInset")
        }
        let _ = super.parse(settings: settings)
        if #available(iOS 13.0, *) {
        } else {
            applePayAPIEnabled = false
        }
        return self
    }

    override func getRealSettings(obj: InAppWebView?) -> [String: Any?] {
        var realSettings: [String: Any?] = toMap()
        if let webView = obj {
            let configuration = webView.configuration
            if #available(iOS 9.0, *) {
                realSettings["userAgent"] = webView.customUserAgent
                realSettings["applicationNameForUserAgent"] =
                    configuration.applicationNameForUserAgent
                realSettings["allowsAirPlayForMediaPlayback"] =
                    configuration.allowsAirPlayForMediaPlayback
                realSettings["allowsLinkPreview"] = webView.allowsLinkPreview
                realSettings["allowsPictureInPictureMediaPlayback"] =
                    configuration.allowsPictureInPictureMediaPlayback
            }
            realSettings["javaScriptCanOpenWindowsAutomatically"] =
                configuration.preferences.javaScriptCanOpenWindowsAutomatically
            if #available(iOS 10.0, *) {
                realSettings["mediaPlaybackRequiresUserGesture"] =
                    configuration.mediaTypesRequiringUserActionForPlayback == .all
                realSettings["ignoresViewportScaleLimits"] =
                    configuration.ignoresViewportScaleLimits
                realSettings["dataDetectorTypes"] = Util.getDataDetectorTypeString(
                    type: configuration.dataDetectorTypes)
            } else {
                realSettings["mediaPlaybackRequiresUserGesture"] =
                    configuration.mediaPlaybackRequiresUserAction
            }
            realSettings["minimumFontSize"] = Int(configuration.preferences.minimumFontSize)
            realSettings["suppressesIncrementalRendering"] =
                configuration.suppressesIncrementalRendering
            realSettings["allowsBackForwardNavigationGestures"] =
                webView.allowsBackForwardNavigationGestures
            realSettings["allowsInlineMediaPlayback"] = configuration.allowsInlineMediaPlayback
            if #available(iOS 13.0, *) {
                realSettings["isFraudulentWebsiteWarningEnabled"] =
                    configuration.preferences.isFraudulentWebsiteWarningEnabled
                realSettings["preferredContentMode"] =
                    configuration.defaultWebpagePreferences.preferredContentMode.rawValue
                realSettings["automaticallyAdjustsScrollIndicatorInsets"] =
                    webView.scrollView.automaticallyAdjustsScrollIndicatorInsets
            }
            realSettings["selectionGranularity"] = configuration.selectionGranularity.rawValue
            if #available(iOS 11.0, *) {
                realSettings["accessibilityIgnoresInvertColors"] =
                    webView.accessibilityIgnoresInvertColors
                realSettings["contentInsetAdjustmentBehavior"] =
                    webView.scrollView.contentInsetAdjustmentBehavior.rawValue
            }
            realSettings["decelerationRate"] = Util.getDecelerationRateString(
                type: webView.scrollView.decelerationRate)
            realSettings["alwaysBounceVertical"] = webView.scrollView.alwaysBounceVertical
            realSettings["alwaysBounceHorizontal"] = webView.scrollView.alwaysBounceHorizontal
            if #available(iOS 17.4, *) {
                realSettings["bouncesHorizontally"] = webView.scrollView.bouncesHorizontally
                realSettings["bouncesVertically"] = webView.scrollView.bouncesVertically
            } else {
                realSettings["bouncesHorizontally"] = nil
                realSettings["bouncesVertically"] = nil
            }
            realSettings["scrollsToTop"] = webView.scrollView.scrollsToTop
            realSettings["isPagingEnabled"] = webView.scrollView.isPagingEnabled
            realSettings["maximumZoomScale"] = webView.scrollView.maximumZoomScale
            realSettings["minimumZoomScale"] = webView.scrollView.minimumZoomScale
            realSettings["allowUniversalAccessFromFileURLs"] = configuration.value(
                forKey: "allowUniversalAccessFromFileURLs")
            realSettings["allowFileAccessFromFileURLs"] = configuration.preferences.value(
                forKey: "allowFileAccessFromFileURLs")
            realSettings["isDirectionalLockEnabled"] = webView.scrollView.isDirectionalLockEnabled
            realSettings["javaScriptEnabled"] = configuration.preferences.javaScriptEnabled
            if #available(iOS 14.0, *) {
                realSettings["mediaType"] = webView.mediaType
                realSettings["pageZoom"] = Float(webView.pageZoom)
                realSettings["limitsNavigationsToAppBoundDomains"] =
                    configuration.limitsNavigationsToAppBoundDomains
                realSettings["javaScriptEnabled"] =
                    configuration.defaultWebpagePreferences.allowsContentJavaScript
            }
            if #available(iOS 15.0, *) {
                realSettings["isTextInteractionEnabled"] =
                    configuration.preferences.isTextInteractionEnabled
                realSettings["upgradeKnownHostsToHTTPS"] = configuration.upgradeKnownHostsToHTTPS
                realSettings["underPageBackgroundColor"] =
                    webView.underPageBackgroundColor.hexString
            }
            if #available(iOS 15.4, *) {
                realSettings["isSiteSpecificQuirksModeEnabled"] =
                    configuration.preferences.isSiteSpecificQuirksModeEnabled
                realSettings["isElementFullscreenEnabled"] =
                    configuration.preferences.isElementFullscreenEnabled
            }
            if #available(iOS 15.5, *) {
                realSettings["minimumViewportInset"] = webView.minimumViewportInset.toMap()
                realSettings["maximumViewportInset"] = webView.maximumViewportInset.toMap()
            }
            if #available(iOS 16.0, *) {
                realSettings["isFindInteractionEnabled"] = webView.isFindInteractionEnabled
            }
            if #available(iOS 16.4, *) {
                realSettings["isInspectable"] = webView.isInspectable
                realSettings["shouldPrintBackgrounds"] =
                    configuration.preferences.shouldPrintBackgrounds
                // Use KVC to avoid compile-time availability issues with older SDKs
                let selector = Selector(("webAuthenticationSupport"))
                if configuration.responds(to: selector),
                    let webAuthSupport = configuration.perform(selector)?.takeUnretainedValue()
                        as? NSObject,
                    webAuthSupport.responds(to: Selector(("boundKeychainForPasskeys")))
                {
                    // value(forKey:) throws an uncatchable NSUnknownKeyException
                    // when the key is missing — the responds(to:) guard above keeps
                    // getRealSettings() crash-proof on unexpected SDK states.
                    let boundValue =
                        webAuthSupport.value(forKey: "boundKeychainForPasskeys") as? Bool ?? false
                    realSettings["webAuthenticationSupport"] = boundValue ? 1 : 0
                }
            }
        }

        // Translate the four enum fields from WebKit Int rawValues back to the
        // String wire names the Dart surface expects (see the generated
        // EnumMaps). The Dart `fromMap` rebuilds enums via the EnumMap, so a raw
        // Int here would fail to round-trip.
        realSettings["preferredContentMode"] = preferredContentModeName(
            realSettings["preferredContentMode"] as? Int ?? 0)
        realSettings["selectionGranularity"] = selectionGranularityName(
            realSettings["selectionGranularity"] as? Int ?? 0)
        realSettings["contentInsetAdjustmentBehavior"] = contentInsetAdjustmentBehaviorName(
            realSettings["contentInsetAdjustmentBehavior"] as? Int ?? 0)
        realSettings["webAuthenticationSupport"] = webAuthenticationSupportName(
            realSettings["webAuthenticationSupport"] as? Int ?? 0)

        return realSettings
    }
}
