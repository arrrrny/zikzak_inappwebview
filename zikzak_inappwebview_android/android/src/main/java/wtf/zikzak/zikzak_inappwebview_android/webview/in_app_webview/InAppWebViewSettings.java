package wtf.zikzak.zikzak_inappwebview_android.webview.in_app_webview;

import static android.webkit.WebSettings.LayoutAlgorithm.NARROW_COLUMNS;
import static android.webkit.WebSettings.LayoutAlgorithm.NORMAL;

import android.annotation.SuppressLint;
import android.os.Build;
import android.view.View;
import android.webkit.WebSettings;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.webkit.WebSettingsCompat;
import androidx.webkit.WebViewFeature;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import wtf.zikzak.zikzak_inappwebview_android.ISettings;
import wtf.zikzak.zikzak_inappwebview_android.types.PreferredContentModeOptionType;
import wtf.zikzak.zikzak_inappwebview_android.webview.InAppWebViewInterface;

public class InAppWebViewSettings implements ISettings<InAppWebViewInterface> {

    public static final String LOG_TAG = "InAppWebViewSettings";

    public Boolean useShouldOverrideUrlLoading = false;
    public Boolean useOnLoadResource = false;
    public Boolean useOnDownloadStart = false;

    /**
     * @deprecated
     */
    @Deprecated
    public Boolean clearCache = false;

    public String userAgent = "";
    public String applicationNameForUserAgent = "";
    public Boolean javaScriptEnabled = true;
    public Boolean javaScriptCanOpenWindowsAutomatically = false;
    public Boolean mediaPlaybackRequiresUserGesture = true;
    public Integer minimumFontSize = 8;
    public Boolean verticalScrollBarEnabled = true;
    public Boolean horizontalScrollBarEnabled = true;
    public List<String> resourceCustomSchemes = new ArrayList<>();
    public List<Map<String, Map<String, Object>>> contentBlockers =
        new ArrayList<>();
    public Integer preferredContentMode =
        PreferredContentModeOptionType.RECOMMENDED.toValue();
    public Boolean useShouldInterceptAjaxRequest = false;
    public Boolean interceptOnlyAsyncAjaxRequests = true;
    public Boolean useShouldInterceptFetchRequest = false;
    public Boolean incognito = false;
    public Boolean cacheEnabled = true;
    public Boolean transparentBackground = false;
    public Boolean disableVerticalScroll = false;
    public Boolean disableHorizontalScroll = false;
    public Boolean disableContextMenu = false;
    public Boolean supportZoom = true;
    public Boolean allowFileAccessFromFileURLs = false;
    public Boolean allowUniversalAccessFromFileURLs = false;
    public Boolean allowBackgroundAudioPlaying = false;
    public Integer textZoom = 100;

    /**
     * @deprecated
     */
    @Deprecated
    public Boolean clearSessionCache = false;

    public Boolean builtInZoomControls = true;
    public Boolean displayZoomControls = false;
    public Boolean databaseEnabled = false;
    public Boolean domStorageEnabled = true;
    public Boolean useWideViewPort = true;
    public Boolean safeBrowsingEnabled = true;
    public Integer mixedContentMode;
    public Boolean allowContentAccess = true;
    public Boolean allowFileAccess = true;
    public String appCachePath;
    public Boolean blockNetworkImage = false;
    public Boolean blockNetworkLoads = false;
    public Integer cacheMode = WebSettings.LOAD_DEFAULT;
    public String cursiveFontFamily = "cursive";
    public Integer defaultFixedFontSize = 16;
    public Integer defaultFontSize = 16;
    public String defaultTextEncodingName = "UTF-8";
    public Integer disabledActionModeMenuItems;
    public String fantasyFontFamily = "fantasy";
    public String fixedFontFamily = "monospace";
    public Integer forceDark = 0; // WebSettingsCompat.FORCE_DARK_OFF
    public Integer forceDarkStrategy =
        WebSettingsCompat.DARK_STRATEGY_PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING;
    public Boolean geolocationEnabled = true;
    public WebSettings.LayoutAlgorithm layoutAlgorithm;
    public Boolean loadWithOverviewMode = true;
    public Boolean loadsImagesAutomatically = true;
    public Integer minimumLogicalFontSize = 8;
    public Integer initialScale = 0;
    public Boolean needInitialFocus = true;
    public Boolean offscreenPreRaster = false;
    public String sansSerifFontFamily = "sans-serif";
    public String serifFontFamily = "sans-serif";
    public String standardFontFamily = "sans-serif";
    public Boolean saveFormData = true;
    public Boolean thirdPartyCookiesEnabled = true;
    public Boolean hardwareAcceleration = true;
    public Boolean supportMultipleWindows = false;
    public String regexToCancelSubFramesLoading;
    public String regexToCancelOverrideUrlLoading;
    public Integer overScrollMode = View.OVER_SCROLL_IF_CONTENT_SCROLLS;
    public Boolean networkAvailable = null;
    public Integer scrollBarStyle = View.SCROLLBARS_INSIDE_OVERLAY;
    public Integer verticalScrollbarPosition = View.SCROLLBAR_POSITION_DEFAULT;
    public Integer scrollBarDefaultDelayBeforeFade = null;
    public Boolean scrollbarFadingEnabled = true;
    public Integer scrollBarFadeDuration = null;

    @Nullable
    public Map<String, Object> rendererPriorityPolicy = null;

    public Boolean useShouldInterceptRequest = false;
    public Boolean useOnRenderProcessGone = false;
    public Boolean disableDefaultErrorPage = false;
    public Boolean useHybridComposition = true;

    @Nullable
    public String verticalScrollbarThumbColor;

    @Nullable
    public String verticalScrollbarTrackColor;

    @Nullable
    public String horizontalScrollbarThumbColor;

    @Nullable
    public String horizontalScrollbarTrackColor;

    public Boolean algorithmicDarkeningAllowed = false;
    public Boolean paymentRequestEnabled = false;
    @Nullable
    public Integer webAuthenticationSupport = null;
    public Boolean enterpriseAuthenticationAppLinkPolicyEnabled = true;

    @Nullable
    public Map<String, Object> webViewAssetLoader;

    @Nullable
    public byte[] defaultVideoPoster;

    @Nullable
    public Set<String> requestedWithHeaderOriginAllowList;

    public Boolean stylusHandwritingEnabled = true;

    public Boolean dismissDialogues = true;

    /**
     * Which window insets the WebView should <b>ignore</b> when laying out
     * web content, so that content can render edge-to-edge behind the
     * status bar, navigation bar, IME, display cutout and/or system-gesture
     * areas. Each entry is one of the {@link wtf.zikzak.zikzak_inappwebview_android.types.WebViewInsets}
     * wire values (e.g. {@code "systemBars"}, {@code "ime"},
     * {@code "displayCutout"}). {@code null} or empty keeps the default
     * Android behavior (the WebView is inset by the system bars / IME).
     */
    @Nullable
    public List<String> insetsForWebContentToIgnore = null;

    // Maps from the String enum wire names produced by the Dart rewrite (and the
    // legacy Integer wire values) to the native int constants the platform
    // WebSettings expect. Keeping both shapes lets settings from either the
    // published 5.x (Integer) or the rewritten (String) Dart surface parse.
    private static final Map<String, Integer> PREFERRED_CONTENT_MODE_VALUES =
        new HashMap<>();

    static {
        PREFERRED_CONTENT_MODE_VALUES.put(
            "RECOMMENDED",
            PreferredContentModeOptionType.RECOMMENDED.toValue()
        );
        PREFERRED_CONTENT_MODE_VALUES.put(
            "MOBILE",
            PreferredContentModeOptionType.MOBILE.toValue()
        );
        PREFERRED_CONTENT_MODE_VALUES.put(
            "DESKTOP",
            PreferredContentModeOptionType.DESKTOP.toValue()
        );
    }

    private static final Map<String, Integer> MIXED_CONTENT_MODE_VALUES =
        new HashMap<>();

    static {
        MIXED_CONTENT_MODE_VALUES.put(
            "MIXED_CONTENT_ALWAYS_ALLOW",
            WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
        );
        MIXED_CONTENT_MODE_VALUES.put(
            "MIXED_CONTENT_NEVER_ALLOW",
            WebSettings.MIXED_CONTENT_NEVER_ALLOW
        );
        MIXED_CONTENT_MODE_VALUES.put(
            "MIXED_CONTENT_COMPATIBILITY_MODE",
            WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE
        );
    }

    private static final Map<String, Integer> CACHE_MODE_VALUES = new HashMap<>();

    static {
        CACHE_MODE_VALUES.put("LOAD_DEFAULT", WebSettings.LOAD_DEFAULT);
        CACHE_MODE_VALUES.put(
            "LOAD_CACHE_ELSE_NETWORK",
            WebSettings.LOAD_CACHE_ELSE_NETWORK
        );
        CACHE_MODE_VALUES.put("LOAD_NO_CACHE", WebSettings.LOAD_NO_CACHE);
        CACHE_MODE_VALUES.put("LOAD_CACHE_ONLY", WebSettings.LOAD_CACHE_ONLY);
    }

    private static final Map<String, Integer> DISABLED_ACTION_MODE_MENU_ITEMS_VALUES =
        new HashMap<>();

    static {
        DISABLED_ACTION_MODE_MENU_ITEMS_VALUES.put(
            "MENU_ITEM_NONE",
            WebSettings.MENU_ITEM_NONE
        );
        DISABLED_ACTION_MODE_MENU_ITEMS_VALUES.put(
            "MENU_ITEM_SHARE",
            WebSettings.MENU_ITEM_SHARE
        );
        DISABLED_ACTION_MODE_MENU_ITEMS_VALUES.put(
            "MENU_ITEM_WEB_SEARCH",
            WebSettings.MENU_ITEM_WEB_SEARCH
        );
        DISABLED_ACTION_MODE_MENU_ITEMS_VALUES.put(
            "MENU_ITEM_PROCESS_TEXT",
            WebSettings.MENU_ITEM_PROCESS_TEXT
        );
    }

    private static final Map<String, Integer> FORCE_DARK_VALUES = new HashMap<>();

    static {
        FORCE_DARK_VALUES.put("OFF", WebSettingsCompat.FORCE_DARK_OFF);
        FORCE_DARK_VALUES.put("AUTO", WebSettingsCompat.FORCE_DARK_AUTO);
        FORCE_DARK_VALUES.put("ON", WebSettingsCompat.FORCE_DARK_ON);
    }

    private static final Map<String, Integer> FORCE_DARK_STRATEGY_VALUES =
        new HashMap<>();

    static {
        FORCE_DARK_STRATEGY_VALUES.put(
            "USER_AGENT_DARKENING_ONLY",
            WebSettingsCompat.DARK_STRATEGY_USER_AGENT_DARKENING_ONLY
        );
        FORCE_DARK_STRATEGY_VALUES.put(
            "WEB_THEME_DARKENING_ONLY",
            WebSettingsCompat.DARK_STRATEGY_WEB_THEME_DARKENING_ONLY
        );
        FORCE_DARK_STRATEGY_VALUES.put(
            "PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING",
            WebSettingsCompat.DARK_STRATEGY_PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING
        );
    }

    private static final Map<String, Integer> OVER_SCROLL_MODE_VALUES =
        new HashMap<>();

    static {
        OVER_SCROLL_MODE_VALUES.put("ALWAYS", View.OVER_SCROLL_ALWAYS);
        OVER_SCROLL_MODE_VALUES.put(
            "IF_CONTENT_SCROLLS",
            View.OVER_SCROLL_IF_CONTENT_SCROLLS
        );
        OVER_SCROLL_MODE_VALUES.put("NEVER", View.OVER_SCROLL_NEVER);
    }

    private static final Map<String, Integer> SCROLL_BAR_STYLE_VALUES =
        new HashMap<>();

    static {
        SCROLL_BAR_STYLE_VALUES.put(
            "SCROLLBARS_INSIDE_OVERLAY",
            View.SCROLLBARS_INSIDE_OVERLAY
        );
        SCROLL_BAR_STYLE_VALUES.put(
            "SCROLLBARS_INSIDE_INSET",
            View.SCROLLBARS_INSIDE_INSET
        );
        SCROLL_BAR_STYLE_VALUES.put(
            "SCROLLBARS_OUTSIDE_OVERLAY",
            View.SCROLLBARS_OUTSIDE_OVERLAY
        );
        SCROLL_BAR_STYLE_VALUES.put(
            "SCROLLBARS_OUTSIDE_INSET",
            View.SCROLLBARS_OUTSIDE_INSET
        );
    }

    private static final Map<String, Integer> VERTICAL_SCROLLBAR_POSITION_VALUES =
        new HashMap<>();

    static {
        VERTICAL_SCROLLBAR_POSITION_VALUES.put(
            "SCROLLBAR_POSITION_DEFAULT",
            View.SCROLLBAR_POSITION_DEFAULT
        );
        VERTICAL_SCROLLBAR_POSITION_VALUES.put(
            "SCROLLBAR_POSITION_LEFT",
            View.SCROLLBAR_POSITION_LEFT
        );
        VERTICAL_SCROLLBAR_POSITION_VALUES.put(
            "SCROLLBAR_POSITION_RIGHT",
            View.SCROLLBAR_POSITION_RIGHT
        );
    }

    private static final Map<String, Integer> WEB_AUTHENTICATION_SUPPORT_VALUES =
        new HashMap<>();

    static {
        WEB_AUTHENTICATION_SUPPORT_VALUES.put(
            "NONE",
            WebSettingsCompat.WEB_AUTHENTICATION_SUPPORT_NONE
        );
        WEB_AUTHENTICATION_SUPPORT_VALUES.put(
            "FOR_APP",
            WebSettingsCompat.WEB_AUTHENTICATION_SUPPORT_FOR_APP
        );
        WEB_AUTHENTICATION_SUPPORT_VALUES.put(
            "FOR_BROWSER",
            WebSettingsCompat.WEB_AUTHENTICATION_SUPPORT_FOR_BROWSER
        );
    }

    /**
     * Parse an enum settings value that may arrive either as a legacy
     * {@code Integer} (index/wire value) or as the String enum name the
     * rewritten Dart surface emits. Returns {@code null} when the value cannot
     * be resolved, in which case the caller should keep the field's default.
     */
    @Nullable
    private static Integer parseEnumValue(
        @Nullable Object value,
        @NonNull Map<String, Integer> nameToValue
    ) {
        if (value instanceof Integer) {
            return (Integer) value;
        }
        if (value instanceof String) {
            return nameToValue.get(value);
        }
        return null;
    }

    /**
     * Reverse of {@link #parseEnumValue}: given a native int constant (or null),
     * return the String enum wire name the rewritten Dart surface expects.
     * Returns {@code null} when the value cannot be resolved, so callers can
     * leave the field absent rather than emitting a stray int that
     * {@code fromJson} (via {@code $enumDecodeNullable}) rejects.
     */
    @Nullable
    private static String enumValueToName(
        @Nullable Integer value,
        @NonNull Map<String, Integer> nameToValue
    ) {
        if (value == null) {
            return null;
        }
        for (Map.Entry<String, Integer> entry : nameToValue.entrySet()) {
            if (value.equals(entry.getValue())) {
                return entry.getKey();
            }
        }
        return null;
    }

    @NonNull
    @Override
    public InAppWebViewSettings parse(@NonNull Map<String, Object> settings) {
        for (Map.Entry<String, Object> pair : settings.entrySet()) {
            String key = pair.getKey();
            Object value = pair.getValue();
            if (value == null) {
                continue;
            }

            switch (key) {
                case "useShouldOverrideUrlLoading":
                    useShouldOverrideUrlLoading = (Boolean) value;
                    break;
                case "useOnLoadResource":
                    useOnLoadResource = (Boolean) value;
                    break;
                case "useOnDownloadStart":
                    useOnDownloadStart = (Boolean) value;
                    break;
                case "clearCache":
                    clearCache = (Boolean) value;
                    break;
                case "userAgent":
                    userAgent = (String) value;
                    break;
                case "applicationNameForUserAgent":
                    applicationNameForUserAgent = (String) value;
                    break;
                case "javaScriptEnabled":
                    javaScriptEnabled = (Boolean) value;
                    break;
                case "javaScriptCanOpenWindowsAutomatically":
                    javaScriptCanOpenWindowsAutomatically = (Boolean) value;
                    break;
                case "mediaPlaybackRequiresUserGesture":
                    mediaPlaybackRequiresUserGesture = (Boolean) value;
                    break;
                case "minimumFontSize":
                    minimumFontSize = (Integer) value;
                    break;
                case "verticalScrollBarEnabled":
                    verticalScrollBarEnabled = (Boolean) value;
                    break;
                case "horizontalScrollBarEnabled":
                    horizontalScrollBarEnabled = (Boolean) value;
                    break;
                case "resourceCustomSchemes":
                    resourceCustomSchemes = (List<String>) value;
                    break;
                case "contentBlockers":
                    contentBlockers = (List<
                            Map<String, Map<String, Object>>
                        >) value;
                    break;
                case "preferredContentMode": {
                    Integer v = parseEnumValue(value, PREFERRED_CONTENT_MODE_VALUES);
                    if (v != null) preferredContentMode = v;
                    break;
                }
                case "useShouldInterceptAjaxRequest":
                    useShouldInterceptAjaxRequest = (Boolean) value;
                    break;
                case "interceptOnlyAsyncAjaxRequests":
                    interceptOnlyAsyncAjaxRequests = (Boolean) value;
                    break;
                case "useShouldInterceptFetchRequest":
                    useShouldInterceptFetchRequest = (Boolean) value;
                    break;
                case "incognito":
                    incognito = (Boolean) value;
                    break;
                case "cacheEnabled":
                    cacheEnabled = (Boolean) value;
                    break;
                case "transparentBackground":
                    transparentBackground = (Boolean) value;
                    break;
                case "disableVerticalScroll":
                    disableVerticalScroll = (Boolean) value;
                    break;
                case "disableHorizontalScroll":
                    disableHorizontalScroll = (Boolean) value;
                    break;
                case "disableContextMenu":
                    disableContextMenu = (Boolean) value;
                    break;
                case "textZoom":
                    textZoom = (Integer) value;
                    break;
                case "clearSessionCache":
                    clearSessionCache = (Boolean) value;
                    break;
                case "builtInZoomControls":
                    builtInZoomControls = (Boolean) value;
                    break;
                case "displayZoomControls":
                    displayZoomControls = (Boolean) value;
                    break;
                case "supportZoom":
                    supportZoom = (Boolean) value;
                    break;
                case "databaseEnabled":
                    databaseEnabled = (Boolean) value;
                    break;
                case "domStorageEnabled":
                    domStorageEnabled = (Boolean) value;
                    break;
                case "useWideViewPort":
                    useWideViewPort = (Boolean) value;
                    break;
                case "safeBrowsingEnabled":
                    safeBrowsingEnabled = (Boolean) value;
                    break;
                case "mixedContentMode": {
                    Integer v = parseEnumValue(value, MIXED_CONTENT_MODE_VALUES);
                    if (v != null) mixedContentMode = v;
                    break;
                }
                case "allowContentAccess":
                    allowContentAccess = (Boolean) value;
                    break;
                case "allowFileAccess":
                    allowFileAccess = (Boolean) value;
                    break;
                case "allowFileAccessFromFileURLs":
                    allowFileAccessFromFileURLs = (Boolean) value;
                    break;
                case "allowUniversalAccessFromFileURLs":
                    allowUniversalAccessFromFileURLs = (Boolean) value;
                    break;
                case "appCachePath":
                    appCachePath = (String) value;
                    break;
                case "blockNetworkImage":
                    blockNetworkImage = (Boolean) value;
                    break;
                case "blockNetworkLoads":
                    blockNetworkLoads = (Boolean) value;
                    break;
                case "cacheMode": {
                    Integer v = parseEnumValue(value, CACHE_MODE_VALUES);
                    if (v != null) cacheMode = v;
                    break;
                }
                case "cursiveFontFamily":
                    cursiveFontFamily = (String) value;
                    break;
                case "defaultFixedFontSize":
                    defaultFixedFontSize = (Integer) value;
                    break;
                case "defaultFontSize":
                    defaultFontSize = (Integer) value;
                    break;
                case "defaultTextEncodingName":
                    defaultTextEncodingName = (String) value;
                    break;
                case "disabledActionModeMenuItems": {
                    Integer v =
                        parseEnumValue(value, DISABLED_ACTION_MODE_MENU_ITEMS_VALUES);
                    if (v != null) disabledActionModeMenuItems = v;
                    break;
                }
                case "fantasyFontFamily":
                    fantasyFontFamily = (String) value;
                    break;
                case "fixedFontFamily":
                    fixedFontFamily = (String) value;
                    break;
                case "forceDark": {
                    Integer v = parseEnumValue(value, FORCE_DARK_VALUES);
                    if (v != null) forceDark = v;
                    break;
                }
                case "forceDarkStrategy": {
                    Integer v = parseEnumValue(value, FORCE_DARK_STRATEGY_VALUES);
                    if (v != null) forceDarkStrategy = v;
                    break;
                }
                case "geolocationEnabled":
                    geolocationEnabled = (Boolean) value;
                    break;
                case "layoutAlgorithm":
                    setLayoutAlgorithm((String) value);
                    break;
                case "loadWithOverviewMode":
                    loadWithOverviewMode = (Boolean) value;
                    break;
                case "loadsImagesAutomatically":
                    loadsImagesAutomatically = (Boolean) value;
                    break;
                case "minimumLogicalFontSize":
                    minimumLogicalFontSize = (Integer) value;
                    break;
                case "initialScale":
                    initialScale = (Integer) value;
                    break;
                case "needInitialFocus":
                    needInitialFocus = (Boolean) value;
                    break;
                case "offscreenPreRaster":
                    offscreenPreRaster = (Boolean) value;
                    break;
                case "sansSerifFontFamily":
                    sansSerifFontFamily = (String) value;
                    break;
                case "serifFontFamily":
                    serifFontFamily = (String) value;
                    break;
                case "standardFontFamily":
                    standardFontFamily = (String) value;
                    break;
                case "saveFormData":
                    saveFormData = (Boolean) value;
                    break;
                case "thirdPartyCookiesEnabled":
                    thirdPartyCookiesEnabled = (Boolean) value;
                    break;
                case "hardwareAcceleration":
                    hardwareAcceleration = (Boolean) value;
                    break;
                case "supportMultipleWindows":
                    supportMultipleWindows = (Boolean) value;
                    break;
                case "regexToCancelSubFramesLoading":
                    regexToCancelSubFramesLoading = (String) value;
                    break;
                case "regexToCancelOverrideUrlLoading":
                    regexToCancelOverrideUrlLoading = (String) value;
                    break;
                case "overScrollMode": {
                    Integer v = parseEnumValue(value, OVER_SCROLL_MODE_VALUES);
                    if (v != null) overScrollMode = v;
                    break;
                }
                case "networkAvailable":
                    networkAvailable = (Boolean) value;
                    break;
                case "scrollBarStyle": {
                    Integer v = parseEnumValue(value, SCROLL_BAR_STYLE_VALUES);
                    if (v != null) scrollBarStyle = v;
                    break;
                }
                case "verticalScrollbarPosition": {
                    Integer v =
                        parseEnumValue(value, VERTICAL_SCROLLBAR_POSITION_VALUES);
                    if (v != null) verticalScrollbarPosition = v;
                    break;
                }
                case "scrollBarDefaultDelayBeforeFade":
                    scrollBarDefaultDelayBeforeFade = (Integer) value;
                    break;
                case "scrollbarFadingEnabled":
                    scrollbarFadingEnabled = (Boolean) value;
                    break;
                case "scrollBarFadeDuration":
                    scrollBarFadeDuration = (Integer) value;
                    break;
                case "rendererPriorityPolicy":
                    rendererPriorityPolicy = (Map<String, Object>) value;
                    break;
                case "useShouldInterceptRequest":
                    useShouldInterceptRequest = (Boolean) value;
                    break;
                case "useOnRenderProcessGone":
                    useOnRenderProcessGone = (Boolean) value;
                    break;
                case "disableDefaultErrorPage":
                    disableDefaultErrorPage = (Boolean) value;
                    break;
                case "useHybridComposition":
                    useHybridComposition = (Boolean) value;
                    break;
                case "verticalScrollbarThumbColor":
                    verticalScrollbarThumbColor = (String) value;
                    break;
                case "verticalScrollbarTrackColor":
                    verticalScrollbarTrackColor = (String) value;
                    break;
                case "horizontalScrollbarThumbColor":
                    horizontalScrollbarThumbColor = (String) value;
                    break;
                case "horizontalScrollbarTrackColor":
                    horizontalScrollbarTrackColor = (String) value;
                    break;
                case "algorithmicDarkeningAllowed":
                    algorithmicDarkeningAllowed = (Boolean) value;
                    break;
                case "paymentRequestEnabled":
                    paymentRequestEnabled = (Boolean) value;
                    break;
                case "webAuthenticationSupport": {
                    Integer v =
                        parseEnumValue(value, WEB_AUTHENTICATION_SUPPORT_VALUES);
                    if (v != null) webAuthenticationSupport = v;
                    break;
                }
                case "enterpriseAuthenticationAppLinkPolicyEnabled":
                    enterpriseAuthenticationAppLinkPolicyEnabled =
                        (Boolean) value;
                    break;
                case "allowBackgroundAudioPlaying":
                    allowBackgroundAudioPlaying = (Boolean) value;
                    break;
                case "webViewAssetLoader":
                    webViewAssetLoader = (Map<String, Object>) value;
                    break;
                case "defaultVideoPoster":
                    defaultVideoPoster = (byte[]) value;
                    break;
                case "requestedWithHeaderOriginAllowList":
                    requestedWithHeaderOriginAllowList = new HashSet<>(
                        (List<String>) value
                    );
                    break;
                case "stylusHandwritingEnabled":
                    stylusHandwritingEnabled = (Boolean) value;
                    break;
                case "dismissDialogues":
                    dismissDialogues = (Boolean) value;
                    break;
                case "insetsForWebContentToIgnore":
                    insetsForWebContentToIgnore = (List<String>) value;
                    break;
            }
        }

        return this;
    }

    @NonNull
    @Override
    public Map<String, Object> toMap() {
        Map<String, Object> settings = new HashMap<>();
        settings.put(
            "useShouldOverrideUrlLoading",
            useShouldOverrideUrlLoading
        );
        settings.put("useOnLoadResource", useOnLoadResource);
        settings.put("useOnDownloadStart", useOnDownloadStart);
        settings.put("clearCache", clearCache);
        settings.put("userAgent", userAgent);
        settings.put(
            "applicationNameForUserAgent",
            applicationNameForUserAgent
        );
        settings.put("javaScriptEnabled", javaScriptEnabled);
        settings.put(
            "javaScriptCanOpenWindowsAutomatically",
            javaScriptCanOpenWindowsAutomatically
        );
        settings.put(
            "mediaPlaybackRequiresUserGesture",
            mediaPlaybackRequiresUserGesture
        );
        settings.put("minimumFontSize", minimumFontSize);
        settings.put("verticalScrollBarEnabled", verticalScrollBarEnabled);
        settings.put("horizontalScrollBarEnabled", horizontalScrollBarEnabled);
        settings.put("resourceCustomSchemes", resourceCustomSchemes);
        settings.put("contentBlockers", contentBlockers);
        settings.put(
            "preferredContentMode",
            enumValueToName(preferredContentMode, PREFERRED_CONTENT_MODE_VALUES)
        );
        settings.put(
            "useShouldInterceptAjaxRequest",
            useShouldInterceptAjaxRequest
        );
        settings.put(
            "interceptOnlyAsyncAjaxRequests",
            interceptOnlyAsyncAjaxRequests
        );
        settings.put(
            "useShouldInterceptFetchRequest",
            useShouldInterceptFetchRequest
        );
        settings.put("incognito", incognito);
        settings.put("cacheEnabled", cacheEnabled);
        settings.put("transparentBackground", transparentBackground);
        settings.put("disableVerticalScroll", disableVerticalScroll);
        settings.put("disableHorizontalScroll", disableHorizontalScroll);
        settings.put("disableContextMenu", disableContextMenu);
        settings.put("textZoom", textZoom);
        settings.put("clearSessionCache", clearSessionCache);
        settings.put("builtInZoomControls", builtInZoomControls);
        settings.put("displayZoomControls", displayZoomControls);
        settings.put("supportZoom", supportZoom);
        settings.put("databaseEnabled", databaseEnabled);
        settings.put("domStorageEnabled", domStorageEnabled);
        settings.put("useWideViewPort", useWideViewPort);
        settings.put("safeBrowsingEnabled", safeBrowsingEnabled);
        settings.put(
            "mixedContentMode",
            enumValueToName(mixedContentMode, MIXED_CONTENT_MODE_VALUES)
        );
        settings.put("allowContentAccess", allowContentAccess);
        settings.put("allowFileAccess", allowFileAccess);
        settings.put(
            "allowFileAccessFromFileURLs",
            allowFileAccessFromFileURLs
        );
        settings.put(
            "allowUniversalAccessFromFileURLs",
            allowUniversalAccessFromFileURLs
        );
        settings.put("appCachePath", appCachePath);
        settings.put("blockNetworkImage", blockNetworkImage);
        settings.put("blockNetworkLoads", blockNetworkLoads);
        settings.put(
            "cacheMode",
            enumValueToName(cacheMode, CACHE_MODE_VALUES)
        );
        settings.put("cursiveFontFamily", cursiveFontFamily);
        settings.put("defaultFixedFontSize", defaultFixedFontSize);
        settings.put("defaultFontSize", defaultFontSize);
        settings.put("defaultTextEncodingName", defaultTextEncodingName);
        settings.put(
            "disabledActionModeMenuItems",
            enumValueToName(
                disabledActionModeMenuItems,
                DISABLED_ACTION_MODE_MENU_ITEMS_VALUES
            )
        );
        settings.put("fantasyFontFamily", fantasyFontFamily);
        settings.put("fixedFontFamily", fixedFontFamily);
        settings.put(
            "forceDark",
            enumValueToName(forceDark, FORCE_DARK_VALUES)
        );
        settings.put(
            "forceDarkStrategy",
            enumValueToName(forceDarkStrategy, FORCE_DARK_STRATEGY_VALUES)
        );
        settings.put("geolocationEnabled", geolocationEnabled);
        settings.put("layoutAlgorithm", getLayoutAlgorithm());
        settings.put("loadWithOverviewMode", loadWithOverviewMode);
        settings.put("loadsImagesAutomatically", loadsImagesAutomatically);
        settings.put("minimumLogicalFontSize", minimumLogicalFontSize);
        settings.put("initialScale", initialScale);
        settings.put("needInitialFocus", needInitialFocus);
        settings.put("offscreenPreRaster", offscreenPreRaster);
        settings.put("sansSerifFontFamily", sansSerifFontFamily);
        settings.put("serifFontFamily", serifFontFamily);
        settings.put("standardFontFamily", standardFontFamily);
        settings.put("saveFormData", saveFormData);
        settings.put("thirdPartyCookiesEnabled", thirdPartyCookiesEnabled);
        settings.put("hardwareAcceleration", hardwareAcceleration);
        settings.put("supportMultipleWindows", supportMultipleWindows);
        settings.put(
            "regexToCancelSubFramesLoading",
            regexToCancelSubFramesLoading
        );
        settings.put(
            "regexToCancelOverrideUrlLoading",
            regexToCancelOverrideUrlLoading
        );
        settings.put(
            "overScrollMode",
            enumValueToName(overScrollMode, OVER_SCROLL_MODE_VALUES)
        );
        settings.put("networkAvailable", networkAvailable);
        settings.put(
            "scrollBarStyle",
            enumValueToName(scrollBarStyle, SCROLL_BAR_STYLE_VALUES)
        );
        settings.put(
            "verticalScrollbarPosition",
            enumValueToName(
                verticalScrollbarPosition,
                VERTICAL_SCROLLBAR_POSITION_VALUES
            )
        );
        settings.put(
            "scrollBarDefaultDelayBeforeFade",
            scrollBarDefaultDelayBeforeFade
        );
        settings.put("scrollbarFadingEnabled", scrollbarFadingEnabled);
        settings.put("scrollBarFadeDuration", scrollBarFadeDuration);
        settings.put("rendererPriorityPolicy", rendererPriorityPolicy);
        settings.put("useShouldInterceptRequest", useShouldInterceptRequest);
        settings.put("useOnRenderProcessGone", useOnRenderProcessGone);
        settings.put("disableDefaultErrorPage", disableDefaultErrorPage);
        settings.put("useHybridComposition", useHybridComposition);
        settings.put(
            "verticalScrollbarThumbColor",
            verticalScrollbarThumbColor
        );
        settings.put(
            "verticalScrollbarTrackColor",
            verticalScrollbarTrackColor
        );
        settings.put(
            "horizontalScrollbarThumbColor",
            horizontalScrollbarThumbColor
        );
        settings.put(
            "horizontalScrollbarTrackColor",
            horizontalScrollbarTrackColor
        );
        settings.put(
            "algorithmicDarkeningAllowed",
            algorithmicDarkeningAllowed
        );
        settings.put(
            "paymentRequestEnabled",
            paymentRequestEnabled
        );
        settings.put(
            "webAuthenticationSupport",
            enumValueToName(
                webAuthenticationSupport,
                WEB_AUTHENTICATION_SUPPORT_VALUES
            )
        );
        settings.put(
            "enterpriseAuthenticationAppLinkPolicyEnabled",
            enterpriseAuthenticationAppLinkPolicyEnabled
        );
        settings.put(
            "allowBackgroundAudioPlaying",
            allowBackgroundAudioPlaying
        );
        settings.put("defaultVideoPoster", defaultVideoPoster);
        settings.put(
            "requestedWithHeaderOriginAllowList",
            requestedWithHeaderOriginAllowList != null
                ? new ArrayList<>(requestedWithHeaderOriginAllowList)
                : null
        );
        settings.put("stylusHandwritingEnabled", stylusHandwritingEnabled);
        settings.put("dismissDialogues", dismissDialogues);
        settings.put("insetsForWebContentToIgnore", insetsForWebContentToIgnore);
        return settings;
    }

    @SuppressLint("RestrictedApi")
    @NonNull
    @Override
    public Map<String, Object> getRealSettings(
        @NonNull InAppWebViewInterface inAppWebView
    ) {
        Map<String, Object> realSettings = toMap();
        if (inAppWebView instanceof InAppWebView) {
            InAppWebView webView = (InAppWebView) inAppWebView;
            WebSettings settings = webView.getSettings();
            realSettings.put("userAgent", settings.getUserAgentString());
            realSettings.put(
                "javaScriptEnabled",
                settings.getJavaScriptEnabled()
            );
            realSettings.put(
                "javaScriptCanOpenWindowsAutomatically",
                settings.getJavaScriptCanOpenWindowsAutomatically()
            );
            realSettings.put(
                "mediaPlaybackRequiresUserGesture",
                settings.getMediaPlaybackRequiresUserGesture()
            );
            realSettings.put("minimumFontSize", settings.getMinimumFontSize());
            realSettings.put(
                "verticalScrollBarEnabled",
                webView.isVerticalScrollBarEnabled()
            );
            realSettings.put(
                "horizontalScrollBarEnabled",
                webView.isHorizontalScrollBarEnabled()
            );
            realSettings.put("textZoom", settings.getTextZoom());
            realSettings.put(
                "builtInZoomControls",
                settings.getBuiltInZoomControls()
            );
            realSettings.put("supportZoom", settings.supportZoom());
            realSettings.put(
                "displayZoomControls",
                settings.getDisplayZoomControls()
            );
            realSettings.put("databaseEnabled", settings.getDatabaseEnabled());
            realSettings.put(
                "domStorageEnabled",
                settings.getDomStorageEnabled()
            );
            realSettings.put("useWideViewPort", settings.getUseWideViewPort());
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.SAFE_BROWSING_ENABLE
                )
            ) {
                realSettings.put(
                    "safeBrowsingEnabled",
                    WebSettingsCompat.getSafeBrowsingEnabled(settings)
                );
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                realSettings.put(
                    "safeBrowsingEnabled",
                    settings.getSafeBrowsingEnabled()
                );
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                realSettings.put(
                    "mixedContentMode",
                    enumValueToName(
                        settings.getMixedContentMode(),
                        MIXED_CONTENT_MODE_VALUES
                    )
                );
            }
            realSettings.put(
                "allowContentAccess",
                settings.getAllowContentAccess()
            );
            realSettings.put("allowFileAccess", settings.getAllowFileAccess());
            realSettings.put(
                "allowFileAccessFromFileURLs",
                settings.getAllowFileAccessFromFileURLs()
            );
            realSettings.put(
                "allowUniversalAccessFromFileURLs",
                settings.getAllowUniversalAccessFromFileURLs()
            );
            realSettings.put(
                "blockNetworkImage",
                settings.getBlockNetworkImage()
            );
            realSettings.put(
                "blockNetworkLoads",
                settings.getBlockNetworkLoads()
            );
            realSettings.put(
                "cacheMode",
                enumValueToName(settings.getCacheMode(), CACHE_MODE_VALUES)
            );
            realSettings.put(
                "cursiveFontFamily",
                settings.getCursiveFontFamily()
            );
            realSettings.put(
                "defaultFixedFontSize",
                settings.getDefaultFixedFontSize()
            );
            realSettings.put("defaultFontSize", settings.getDefaultFontSize());
            realSettings.put(
                "defaultTextEncodingName",
                settings.getDefaultTextEncodingName()
            );
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.DISABLED_ACTION_MODE_MENU_ITEMS
                )
            ) {
                realSettings.put(
                    "disabledActionModeMenuItems",
                    enumValueToName(
                        WebSettingsCompat.getDisabledActionModeMenuItems(
                            settings
                        ),
                        DISABLED_ACTION_MODE_MENU_ITEMS_VALUES
                    )
                );
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                realSettings.put(
                    "disabledActionModeMenuItems",
                    enumValueToName(
                        settings.getDisabledActionModeMenuItems(),
                        DISABLED_ACTION_MODE_MENU_ITEMS_VALUES
                    )
                );
            }
            realSettings.put(
                "fantasyFontFamily",
                settings.getFantasyFontFamily()
            );
            realSettings.put("fixedFontFamily", settings.getFixedFontFamily());
            if (WebViewFeature.isFeatureSupported(WebViewFeature.FORCE_DARK)) {
                realSettings.put(
                    "forceDark",
                    enumValueToName(
                        WebSettingsCompat.getForceDark(settings),
                        FORCE_DARK_VALUES
                    )
                );
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                realSettings.put(
                    "forceDark",
                    enumValueToName(
                        settings.getForceDark(),
                        FORCE_DARK_VALUES
                    )
                );
            }
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.FORCE_DARK_STRATEGY
                )
            ) {
                realSettings.put(
                    "forceDarkStrategy",
                    enumValueToName(
                        WebSettingsCompat.getForceDarkStrategy(settings),
                        FORCE_DARK_STRATEGY_VALUES
                    )
                );
            }
            realSettings.put(
                "layoutAlgorithm",
                settings.getLayoutAlgorithm().name()
            );
            realSettings.put(
                "loadWithOverviewMode",
                settings.getLoadWithOverviewMode()
            );
            realSettings.put(
                "loadsImagesAutomatically",
                settings.getLoadsImagesAutomatically()
            );
            realSettings.put(
                "minimumLogicalFontSize",
                settings.getMinimumLogicalFontSize()
            );
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.OFF_SCREEN_PRERASTER
                )
            ) {
                realSettings.put(
                    "offscreenPreRaster",
                    WebSettingsCompat.getOffscreenPreRaster(settings)
                );
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                realSettings.put(
                    "offscreenPreRaster",
                    settings.getOffscreenPreRaster()
                );
            }
            realSettings.put(
                "sansSerifFontFamily",
                settings.getSansSerifFontFamily()
            );
            realSettings.put("serifFontFamily", settings.getSerifFontFamily());
            realSettings.put(
                "standardFontFamily",
                settings.getStandardFontFamily()
            );
            realSettings.put("saveFormData", settings.getSaveFormData());
            realSettings.put(
                "supportMultipleWindows",
                settings.supportMultipleWindows()
            );
            realSettings.put(
                "overScrollMode",
                enumValueToName(webView.getOverScrollMode(), OVER_SCROLL_MODE_VALUES)
            );
            realSettings.put(
                "scrollBarStyle",
                enumValueToName(webView.getScrollBarStyle(), SCROLL_BAR_STYLE_VALUES)
            );
            realSettings.put(
                "verticalScrollbarPosition",
                enumValueToName(
                    webView.getVerticalScrollbarPosition(),
                    VERTICAL_SCROLLBAR_POSITION_VALUES
                )
            );
            realSettings.put(
                "scrollBarDefaultDelayBeforeFade",
                webView.getScrollBarDefaultDelayBeforeFade()
            );
            realSettings.put(
                "scrollbarFadingEnabled",
                webView.isScrollbarFadingEnabled()
            );
            realSettings.put(
                "scrollBarFadeDuration",
                webView.getScrollBarFadeDuration()
            );
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Map<String, Object> rendererPriorityPolicy = new HashMap<>();
                rendererPriorityPolicy.put(
                    "rendererRequestedPriority",
                    webView.getRendererRequestedPriority()
                );
                rendererPriorityPolicy.put(
                    "waivedWhenNotVisible",
                    webView.getRendererPriorityWaivedWhenNotVisible()
                );
                realSettings.put(
                    "rendererPriorityPolicy",
                    rendererPriorityPolicy
                );
            }
            try {
                // Check if SUPPRESS_ERROR_PAGE feature is supported (available in androidx.webkit:webkit 1.13.0+)
                if (
                    android.os.Build.VERSION.SDK_INT >=
                    android.os.Build.VERSION_CODES.Q
                ) {
                    Class<?> webViewFeatureClass = Class.forName(
                        "androidx.webkit.WebViewFeature"
                    );
                    java.lang.reflect.Field suppressErrorPageField =
                        webViewFeatureClass.getDeclaredField(
                            "SUPPRESS_ERROR_PAGE"
                        );
                    String suppressErrorPageConstant =
                        (String) suppressErrorPageField.get(null);

                    java.lang.reflect.Method isFeatureSupportedMethod =
                        webViewFeatureClass.getMethod(
                            "isFeatureSupported",
                            String.class
                        );
                    boolean isSupported =
                        (boolean) isFeatureSupportedMethod.invoke(
                            null,
                            suppressErrorPageConstant
                        );

                    if (isSupported) {
                        Class<?> webSettingsCompatClass = Class.forName(
                            "androidx.webkit.WebSettingsCompat"
                        );
                        java.lang.reflect.Method willSuppressErrorPageMethod =
                            webSettingsCompatClass.getMethod(
                                "willSuppressErrorPage",
                                android.webkit.WebSettings.class
                            );
                        boolean willSuppress =
                            (boolean) willSuppressErrorPageMethod.invoke(
                                null,
                                settings
                            );
                        realSettings.put(
                            "disableDefaultErrorPage",
                            willSuppress
                        );
                    }
                }
            } catch (Exception e) {
                // SUPPRESS_ERROR_PAGE feature not available in this version of androidx.webkit
                // This is expected in androidx.webkit versions < 1.13.0
                android.util.Log.d(
                    "InAppWebViewSettings",
                    "SUPPRESS_ERROR_PAGE feature not available: " +
                    e.getMessage()
                );
            }
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.ALGORITHMIC_DARKENING
                ) &&
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
            ) {
                realSettings.put(
                    "algorithmicDarkeningAllowed",
                    WebSettingsCompat.isAlgorithmicDarkeningAllowed(settings)
                );
            }
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.PAYMENT_REQUEST
                )
            ) {
                realSettings.put(
                    "paymentRequestEnabled",
                    WebSettingsCompat.getPaymentRequestEnabled(settings)
                );
            }
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.WEB_AUTHENTICATION
                )
            ) {
                realSettings.put(
                    "webAuthenticationSupport",
                    enumValueToName(
                        WebSettingsCompat.getWebAuthenticationSupport(settings),
                        WEB_AUTHENTICATION_SUPPORT_VALUES
                    )
                );
            }
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY
                )
            ) {
                realSettings.put(
                    "enterpriseAuthenticationAppLinkPolicyEnabled",
                    WebSettingsCompat.getEnterpriseAuthenticationAppLinkPolicyEnabled(
                        settings
                    )
                );
            }
            if (
                WebViewFeature.isFeatureSupported(
                    WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST
                )
            ) {
                realSettings.put(
                    "requestedWithHeaderOriginAllowList",
                    new ArrayList<>(
                        WebSettingsCompat.getRequestedWithHeaderOriginAllowList(
                            settings
                        )
                    )
                );
            }
        }
        return realSettings;
    }

    private void setLayoutAlgorithm(String value) {
        if (value != null) {
            switch (value) {
                case "NARROW_COLUMNS":
                    layoutAlgorithm = NARROW_COLUMNS;
                case "NORMAL":
                    layoutAlgorithm = NORMAL;
                case "TEXT_AUTOSIZING":
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        layoutAlgorithm =
                            WebSettings.LayoutAlgorithm.TEXT_AUTOSIZING;
                    } else {
                        layoutAlgorithm = NORMAL;
                    }
                    break;
            }
        }
    }

    private String getLayoutAlgorithm() {
        if (layoutAlgorithm != null) {
            switch (layoutAlgorithm) {
                case NORMAL:
                    return "NORMAL";
                case TEXT_AUTOSIZING:
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        return "TEXT_AUTOSIZING";
                    } else {
                        return "NORMAL";
                    }
                case NARROW_COLUMNS:
                    return "NARROW_COLUMNS";
            }
        }
        return null;
    }
}
