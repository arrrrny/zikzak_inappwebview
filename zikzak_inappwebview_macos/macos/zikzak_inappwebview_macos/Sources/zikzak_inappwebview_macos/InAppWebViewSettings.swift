import AppKit
import WebKit

@objcMembers
public class InAppWebViewSettings: ISettings<InAppWebView> {

    var useShouldOverrideUrlLoading = false
    var useOnLoadResource = false
    var useOnDownloadStart = false
    var clearCache = false
    var userAgent = ""
    var applicationNameForUserAgent = ""
    var javaScriptEnabled = true
    var javaScriptCanOpenWindowsAutomatically = false
    var mediaPlaybackRequiresUserGesture = true
    var resourceCustomSchemes: [String] = []
    var contentBlockers: [[String: [String: Any]]] = []
    var minimumFontSize = 0
    var useShouldInterceptAjaxRequest = false
    var interceptOnlyAsyncAjaxRequests = true
    var useShouldInterceptFetchRequest = false
    var incognito = false
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
    var dataDetectorTypes: [String] = ["NONE"]
    var preferredContentMode = 0
    var sharedCookiesEnabled = false
    var accessibilityIgnoresInvertColors = false
    var alwaysBounceVertical = false
    var alwaysBounceHorizontal = false
    var isPagingEnabled = false
    var maximumZoomScale = 1.0
    var minimumZoomScale = 1.0
    var contentInsetAdjustmentBehavior = 2
    var isDirectionalLockEnabled = false
    var mediaType: String? = nil
    var pageZoom = 1.0
    var limitsNavigationsToAppBoundDomains = false
    var useOnNavigationResponse = false
    var applePayAPIEnabled = false
    var allowingReadAccessTo: String? = nil
    var disableLongPressContextMenuOnLinks = false
    var underPageBackgroundColor: String?
    var isTextInteractionEnabled = true
    var isSiteSpecificQuirksModeEnabled = true
    var upgradeKnownHostsToHTTPS = true
    var isElementFullscreenEnabled = true
    var isFindInteractionEnabled = false
    var isInspectable = false
    var shouldPrintBackgrounds = false
    var webAuthenticationSupport = 0
    var dismissDialogues = true
    /// When `false`, the console override script is not injected and
    /// console.log/error/warn messages are NOT forwarded to Dart.
    /// Set to `false` in apps that don't need console messages (e.g.
    /// zuraffa_browser) to reduce bridge traffic and avoid the
    /// WebKit SIGSEGV on non-cloneable objects (#309, #312).
    var consoleLogEnabled = true

    override init() {
        super.init()
    }

    // MARK: - Enum wire-name helpers
    // The Dart surface serializes InAppWebViewSettings enums as String names
    // (see the generated EnumMaps). Native WebKit exposes them as Int rawValues,
    // so we translate in both directions.
    //
    // Ordering matches the generated EnumMaps exactly:
    //   UserPreferredContentMode:            RECOMMENDED(0) | MOBILE(1) | DESKTOP(2)
    //   WKSelectionGranularity:              DYNAMIC(0) | CHARACTER(1)
    //   ScrollViewContentInsetAdjustmentBehavior: AUTOMATIC(0) | SCROLLABLE_AXES(1) | NEVER(2) | ALWAYS(3)
    //   WebAuthenticationSupport:           NONE(0) | FOR_APP(1) | FOR_BROWSER(2)

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
        var settings = settings  // re-assign to allow removal of untranslatable keys
        // Translate enum String wire names coming from the Dart surface back to
        // the Int rawValues the WebKit properties expect. The base ISettings
        // parse sets properties via KVC `setValue(_:forKey:)`, which throws on a
        // type mismatch, so a String must be converted to Int before that runs.
        // Legacy Int values are passed through unchanged.
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
        let _ = super.parse(settings: settings)
        return self
    }

    override func getRealSettings(obj: InAppWebView?) -> [String: Any?] {
        var realSettings: [String: Any?] = toMap()
        if let webView = obj {
            let configuration = webView.configuration
            realSettings["userAgent"] = webView.customUserAgent
            realSettings["applicationNameForUserAgent"] = configuration.applicationNameForUserAgent
            realSettings["allowsAirPlayForMediaPlayback"] =
                configuration.allowsAirPlayForMediaPlayback
            realSettings["allowsLinkPreview"] = webView.allowsLinkPreview
            realSettings["javaScriptCanOpenWindowsAutomatically"] =
                configuration.preferences.javaScriptCanOpenWindowsAutomatically
            realSettings["mediaPlaybackRequiresUserGesture"] =
                configuration.mediaTypesRequiringUserActionForPlayback == .all
            realSettings["minimumFontSize"] = Int(configuration.preferences.minimumFontSize)
            realSettings["suppressesIncrementalRendering"] =
                configuration.suppressesIncrementalRendering
            realSettings["allowsBackForwardNavigationGestures"] =
                webView.allowsBackForwardNavigationGestures
            realSettings["javaScriptEnabled"] = configuration.defaultWebpagePreferences.allowsContentJavaScript
            realSettings["allowUniversalAccessFromFileURLs"] = configuration.value(
                forKey: "allowUniversalAccessFromFileURLs")
            realSettings["allowFileAccessFromFileURLs"] = configuration.preferences.value(
                forKey: "allowFileAccessFromFileURLs")

            if #available(macOS 14.0, *) {
                realSettings["isInspectable"] = webView.isInspectable
                realSettings["shouldPrintBackgrounds"] =
                    configuration.preferences.shouldPrintBackgrounds
            }
            if #available(macOS 11.0, *) {
                realSettings["mediaType"] = webView.mediaType
                realSettings["pageZoom"] = Float(webView.pageZoom)
                realSettings["limitsNavigationsToAppBoundDomains"] =
                    configuration.limitsNavigationsToAppBoundDomains
            }
            if #available(macOS 13.3, *) {
                realSettings["isTextInteractionEnabled"] =
                    configuration.preferences.isTextInteractionEnabled
                realSettings["upgradeKnownHostsToHTTPS"] = configuration.upgradeKnownHostsToHTTPS
                realSettings["underPageBackgroundColor"] =
                    webView.underPageBackgroundColor?.hexString
            }
            if #available(macOS 13.3, *) {
                realSettings["isSiteSpecificQuirksModeEnabled"] =
                    configuration.preferences.isSiteSpecificQuirksModeEnabled
                realSettings["isElementFullscreenEnabled"] =
                    configuration.preferences.isElementFullscreenEnabled
            }
            // WebAuthn / passkey read-back (issue #272)
            if #available(macOS 13.3, *) {
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
            // isFindInteractionEnabled is not available on macOS
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
