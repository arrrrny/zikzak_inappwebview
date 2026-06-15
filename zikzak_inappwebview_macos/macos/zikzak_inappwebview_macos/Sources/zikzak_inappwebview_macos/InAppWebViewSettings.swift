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

    override init() {
        super.init()
    }

    override func parse(settings: [String: Any?]) -> InAppWebViewSettings {
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
            realSettings["javaScriptEnabled"] = configuration.preferences.javaScriptEnabled
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
            if #available(macOS 13.0, *) {
                realSettings["isFindInteractionEnabled"] = webView.isFindInteractionEnabled
            }
        }
        return realSettings
    }
}
