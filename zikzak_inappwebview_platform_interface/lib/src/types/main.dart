export '../domain/entities/enums/action_mode_menu_item.dart' show ActionModeMenuItem, actionModeMenuItemFromWire, actionModeMenuItemToWire;
// Zorphy entities (migrated from @ExchangeableObject codegen, see PROGRESS.md).
export '../domain/entities/ajax_request/ajax_request.dart'
    show AjaxRequest, AjaxRequestSerialization;
export '../domain/entities/enums/ajax_request_action.dart'
    show AjaxRequestAction;
export '../domain/entities/ajax_request_event/ajax_request_event.dart'
    show AjaxRequestEvent, AjaxRequestEventSerialization;
export '../domain/entities/enums/ajax_request_event_type.dart'
    show AjaxRequestEventType;
// Hand-written (migration skip/fork — see PROGRESS.md).
export 'ajax_request_headers.dart' show AjaxRequestHeaders;
export '../domain/entities/enums/ajax_request_ready_state.dart'
    show AjaxRequestReadyState;
export '../domain/entities/attributed_string/attributed_string.dart' show AttributedString, AttributedStringSerialization;
export '../domain/entities/enums/attributed_string_text_effect_style.dart' show AttributedStringTextEffectStyle;
export '../domain/entities/enums/cache_mode.dart' show CacheMode, cacheModeFromWire, cacheModeToWire;
export '../domain/entities/call_async_javascript_result/call_async_javascript_result.dart' show CallAsyncJavaScriptResult, CallAsyncJavaScriptResultSerialization;
export 'client_cert_challenge.dart' show ClientCertChallenge;
export '../domain/entities/client_cert_response/client_cert_response.dart'
    show ClientCertResponse, ClientCertResponseSerialization;
export '../domain/entities/enums/client_cert_response_action.dart'
    show ClientCertResponseAction;
export '../domain/entities/enums/compress_format.dart' show CompressFormat;
// Zorphy entities (migrated from @ExchangeableObject codegen, see PROGRESS.md).
export '../domain/entities/console_message/console_message.dart'
    show ConsoleMessage, ConsoleMessageSerialization;
export '../domain/entities/enums/console_message_level.dart'
    show ConsoleMessageLevel;
export '../domain/entities/enums/content_blocker_action_type.dart' show ContentBlockerActionType, contentBlockerActionTypeFromWire, contentBlockerActionTypeToWire;
export '../domain/entities/enums/content_blocker_trigger_load_type.dart' show ContentBlockerTriggerLoadType, contentBlockerTriggerLoadTypeFromWire, contentBlockerTriggerLoadTypeToWire;
export '../domain/entities/enums/content_blocker_trigger_resource_type.dart' show ContentBlockerTriggerResourceType, contentBlockerTriggerResourceTypeFromWire, contentBlockerTriggerResourceTypeToWire;
export 'content_world.dart' show ContentWorld;
export '../domain/entities/cookie/cookie.dart' show Cookie, CookieSerialization;
export '../domain/entities/create_window_action/create_window_action.dart'
    show CreateWindowAction, CreateWindowActionSerialization;
export '../domain/entities/enums/cross_origin.dart' show CrossOrigin;
export '../domain/entities/css_link_html_tag_attributes/css_link_html_tag_attributes.dart' show CSSLinkHtmlTagAttributes, CSSLinkHtmlTagAttributesSerialization;
export '../domain/entities/custom_scheme_response/custom_scheme_response.dart' show CustomSchemeResponse, CustomSchemeResponseSerialization;
export '../domain/entities/enums/custom_tabs_share_state.dart' show CustomTabsShareState;
export '../domain/entities/enums/data_detector_types.dart' show DataDetectorTypes;
export '../domain/entities/enums/dismiss_button_style.dart' show DismissButtonStyle;
export '../domain/entities/download_start_request/download_start_request.dart' show DownloadStartRequest, DownloadStartRequestSerialization;
export '../domain/entities/favicon/favicon.dart' show Favicon, FaviconSerialization;
// Zorphy entities (migrated from @ExchangeableObject codegen, see PROGRESS.md).
export '../domain/entities/fetch_request/fetch_request.dart'
    show FetchRequest, FetchRequestSerialization;
export '../domain/entities/enums/fetch_request_action.dart'
    show FetchRequestAction;
// Hand-written (migration skip/hierarchy — polymorphic credential wire
// dispatch; see PROGRESS.md).
export 'fetch_request_credential.dart' show FetchRequestCredential;
export 'fetch_request_credential_default.dart'
    show FetchRequestCredentialDefault;
export 'fetch_request_federated_credential.dart'
    show FetchRequestFederatedCredential;
export 'fetch_request_password_credential.dart'
    show FetchRequestPasswordCredential;
export '../domain/entities/enums/force_dark.dart' show ForceDark;
export '../domain/entities/enums/force_dark_strategy.dart' show ForceDarkStrategy;
export '../domain/entities/enums/form_resubmission_action.dart' show FormResubmissionAction, formResubmissionActionFromWire, formResubmissionActionToWire;
export '../domain/entities/frame_info/frame_info.dart'
    show FrameInfo, FrameInfoSerialization;
export '../domain/entities/geolocation_permission_show_prompt_response/geolocation_permission_show_prompt_response.dart'
    show
        GeolocationPermissionShowPromptResponse,
        GeolocationPermissionShowPromptResponseSerialization;
export '../domain/entities/http_auth_response/http_auth_response.dart'
    show HttpAuthResponse, HttpAuthResponseSerialization;
export '../domain/entities/enums/http_auth_response_action.dart'
    show HttpAuthResponseAction;
export 'http_authentication_challenge.dart' show HttpAuthenticationChallenge;
export '../domain/entities/enums/http_cookie_same_site_policy.dart' show HTTPCookieSameSitePolicy, httpCookieSameSitePolicyFromWire, httpCookieSameSitePolicyToWire;
export '../domain/entities/in_app_webview_hit_test_result/in_app_webview_hit_test_result.dart' show InAppWebViewHitTestResult, InAppWebViewHitTestResultSerialization;
export '../domain/entities/enums/in_app_webview_hit_test_result_type.dart' show InAppWebViewHitTestResultType, inAppWebViewHitTestResultTypeFromWire, inAppWebViewHitTestResultTypeToWire;
export '../domain/entities/in_app_webview_initial_data/in_app_webview_initial_data.dart' show InAppWebViewInitialData, InAppWebViewInitialDataSerialization;
export '../domain/entities/in_app_webview_rect/in_app_webview_rect.dart' show InAppWebViewRect, InAppWebViewRectSerialization;
export 'javascript_handler_callback.dart' show JavaScriptHandlerCallback;
// Zorphy entities (migrated from @ExchangeableObject codegen, see PROGRESS.md).
export '../domain/entities/js_alert_request/js_alert_request.dart'
    show JsAlertRequest, JsAlertRequestSerialization;
export '../domain/entities/js_alert_response/js_alert_response.dart'
    show JsAlertResponse, JsAlertResponseSerialization;
export '../domain/entities/enums/js_alert_response_action.dart'
    show JsAlertResponseAction;
export '../domain/entities/js_before_unload_request/js_before_unload_request.dart'
    show JsBeforeUnloadRequest, JsBeforeUnloadRequestSerialization;
export '../domain/entities/js_before_unload_response/js_before_unload_response.dart'
    show JsBeforeUnloadResponse, JsBeforeUnloadResponseSerialization;
export '../domain/entities/enums/js_before_unload_response_action.dart'
    show JsBeforeUnloadResponseAction;
export '../domain/entities/js_confirm_request/js_confirm_request.dart'
    show JsConfirmRequest, JsConfirmRequestSerialization;
export '../domain/entities/js_confirm_response/js_confirm_response.dart'
    show JsConfirmResponse, JsConfirmResponseSerialization;
export '../domain/entities/enums/js_confirm_response_action.dart'
    show JsConfirmResponseAction;
export '../domain/entities/js_prompt_request/js_prompt_request.dart'
    show JsPromptRequest, JsPromptRequestSerialization;
export '../domain/entities/js_prompt_response/js_prompt_response.dart'
    show JsPromptResponse, JsPromptResponseSerialization;
export '../domain/entities/enums/js_prompt_response_action.dart'
    show JsPromptResponseAction;
export '../domain/entities/enums/layout_algorithm.dart' show LayoutAlgorithm;
export '../domain/entities/enums/layout_in_display_cutout_mode.dart' show LayoutInDisplayCutoutMode;
export '../domain/entities/loaded_resource/loaded_resource.dart' show LoadedResource, LoadedResourceSerialization;
export '../domain/entities/login_request/login_request.dart'
    show LoginRequest, LoginRequestSerialization;
export '../domain/entities/enums/media_capture_state.dart' show MediaCaptureState, mediaCaptureStateFromWire, mediaCaptureStateToWire;
export '../domain/entities/enums/media_playback_state.dart' show MediaPlaybackState, mediaPlaybackStateFromWire, mediaPlaybackStateToWire;
export '../domain/entities/meta_tag/meta_tag.dart' show MetaTag, MetaTagSerialization;
export '../domain/entities/meta_tag_attribute/meta_tag_attribute.dart' show MetaTagAttribute, MetaTagAttributeSerialization;
export '../domain/entities/enums/mixed_content_mode.dart' show MixedContentMode;
export '../domain/entities/enums/modal_presentation_style.dart' show ModalPresentationStyle;
export '../domain/entities/enums/modal_transition_style.dart' show ModalTransitionStyle;
export '../domain/entities/navigation_action/navigation_action.dart'
    show NavigationAction, NavigationActionSerialization;
export 'network_capture_controller.dart' show NetworkCaptureController;
export 'network_entry.dart' show NetworkEntry;
export 'network_request.dart' show NetworkRequest;
export 'network_response.dart' show NetworkResponse;
export 'network_response_body.dart' show NetworkResponseBody;
export 'resource_type.dart' show ResourceType;
export 'android_webview_insets.dart' show AndroidWebViewInsets;
export 'url_pattern_type.dart' show UrlPatternType;
export '../domain/entities/enums/navigation_action_policy.dart'
    show NavigationActionPolicy;
export '../domain/entities/navigation_response/navigation_response.dart'
    show NavigationResponse, NavigationResponseSerialization;
export '../domain/entities/enums/navigation_response_action.dart'
    show NavigationResponseAction;
export '../domain/entities/enums/navigation_type.dart' show NavigationType;
export 'on_post_message_callback.dart' show OnPostMessageCallback;
export '../domain/entities/enums/over_scroll_mode.dart' show OverScrollMode;
export '../domain/entities/pdf_configuration/pdf_configuration.dart' show PDFConfiguration, PDFConfigurationSerialization;
export '../domain/entities/permission_request/permission_request.dart'
    show PermissionRequest, PermissionRequestSerialization;
export '../domain/entities/enums/permission_resource_type.dart'
    show PermissionResourceType;
export '../domain/entities/permission_response/permission_response.dart'
    show PermissionResponse, PermissionResponseSerialization;
export '../domain/entities/enums/permission_response_action.dart'
    show PermissionResponseAction;
export '../domain/entities/print_job_attributes/print_job_attributes.dart' show PrintJobAttributes, PrintJobAttributesSerialization;
export '../domain/entities/enums/print_job_color_mode.dart' show PrintJobColorMode, printJobColorModeFromWire, printJobColorModeToWire;
export '../domain/entities/enums/print_job_duplex_mode.dart' show PrintJobDuplexMode;
export '../domain/entities/print_job_info/print_job_info.dart' show PrintJobInfo, PrintJobInfoSerialization;
export '../domain/entities/print_job_media_size/print_job_media_size.dart' show PrintJobMediaSize, PrintJobMediaSizeSerialization;
export '../domain/entities/enums/print_job_orientation.dart' show PrintJobOrientation;
export '../domain/entities/enums/print_job_output_type.dart' show PrintJobOutputType;
export '../domain/entities/enums/print_job_rendering_quality.dart' show PrintJobRenderingQuality;
export '../domain/entities/print_job_resolution/print_job_resolution.dart' show PrintJobResolution, PrintJobResolutionSerialization;
export '../domain/entities/enums/print_job_state.dart' show PrintJobState, printJobStateFromWire, printJobStateToWire;
export '../domain/entities/proxy_rule/proxy_rule.dart' show ProxyRule, ProxyRuleSerialization;
export '../domain/entities/enums/proxy_scheme_filter.dart' show ProxySchemeFilter;
export '../domain/entities/enums/pull_to_refresh_size.dart' show PullToRefreshSize, pullToRefreshSizeToWire;
export '../domain/entities/enums/referrer_policy.dart' show ReferrerPolicy;
export '../domain/entities/render_process_gone_detail/render_process_gone_detail.dart' show RenderProcessGoneDetail, RenderProcessGoneDetailSerialization;
export '../domain/entities/enums/renderer_priority.dart' show RendererPriority;
export '../domain/entities/renderer_priority_policy/renderer_priority_policy.dart' show RendererPriorityPolicy, RendererPriorityPolicySerialization;
export '../domain/entities/request_focus_node_href_result/request_focus_node_href_result.dart' show RequestFocusNodeHrefResult, RequestFocusNodeHrefResultSerialization;
export '../domain/entities/request_image_ref_result/request_image_ref_result.dart' show RequestImageRefResult, RequestImageRefResultSerialization;
export '../domain/entities/safe_browsing_response/safe_browsing_response.dart'
    show SafeBrowsingResponse, SafeBrowsingResponseSerialization;
export '../domain/entities/enums/safe_browsing_response_action.dart'
    show SafeBrowsingResponseAction;
export '../domain/entities/enums/safe_browsing_threat.dart'
    show SafeBrowsingThreat;
export '../domain/entities/enums/sandbox.dart' show Sandbox;
export '../domain/entities/screenshot_configuration/screenshot_configuration.dart' show ScreenshotConfiguration, ScreenshotConfigurationSerialization;
export 'script_html_tag_attributes.dart' show ScriptHtmlTagAttributes;
export '../domain/entities/enums/scrollbar_style.dart' show ScrollBarStyle;
export '../domain/entities/enums/scrollview_content_inset_adjustment_behavior.dart' show ScrollViewContentInsetAdjustmentBehavior;
export '../domain/entities/enums/scrollview_deceleration_rate.dart' show ScrollViewDecelerationRate;
export '../domain/entities/security_origin/security_origin.dart'
    show SecurityOrigin, SecurityOriginSerialization;
export '../domain/entities/enums/selection_granularity.dart' show SelectionGranularity;
export '../domain/entities/server_trust_auth_response/server_trust_auth_response.dart'
    show ServerTrustAuthResponse, ServerTrustAuthResponseSerialization;
export '../domain/entities/enums/server_trust_auth_response_action.dart'
    show ServerTrustAuthResponseAction;
export 'server_trust_challenge.dart' show ServerTrustChallenge;
export '../domain/entities/enums/should_allow_deprecated_tls_action.dart'
    show ShouldAllowDeprecatedTLSAction;
export '../domain/entities/ssl_certificate/ssl_certificate.dart'
    show SslCertificate;
export '../domain/entities/ssl_certificate_dname/ssl_certificate_dname.dart'
    show SslCertificateDName, SslCertificateDNameSerialization;
export '../domain/entities/ssl_error/ssl_error.dart'
    show SslError, SslErrorSerialization;
export '../domain/entities/enums/ssl_error_type.dart' show SslErrorType;
export 'trusted_web_activity_default_display_mode.dart'
    show TrustedWebActivityDefaultDisplayMode;
export '../domain/entities/trusted_web_activity_display_mode/trusted_web_activity_display_mode.dart' show TrustedWebActivityDisplayMode, TrustedWebActivityDisplayModeSerialization;
export 'trusted_web_activity_immersive_display_mode.dart'
    show TrustedWebActivityImmersiveDisplayMode;
export '../domain/entities/enums/trusted_web_activity_screen_orientation.dart' show TrustedWebActivityScreenOrientation;
export '../domain/entities/enums/underline_style.dart' show UnderlineStyle, underlineStyleFromWire, underlineStyleToWire;
export 'url_authentication_challenge.dart' show URLAuthenticationChallenge;
export '../domain/entities/url_credential/url_credential.dart'
    show URLCredential, URLCredentialSerialization;
export '../domain/entities/enums/url_credential_persistence.dart'
    show URLCredentialPersistence;
export '../domain/entities/url_protection_space/url_protection_space.dart'
    show URLProtectionSpace, URLProtectionSpaceSerialization;
export '../domain/entities/enums/url_protection_space_authentication_method.dart'
    show URLProtectionSpaceAuthenticationMethod;
export '../domain/entities/url_protection_space_http_auth_credentials/url_protection_space_http_auth_credentials.dart'
    show
        URLProtectionSpaceHttpAuthCredentials,
        URLProtectionSpaceHttpAuthCredentialsSerialization;
export '../domain/entities/enums/url_protection_space_proxy_type.dart'
    show URLProtectionSpaceProxyType;
export '../domain/entities/url_request/url_request.dart'
    show URLRequest, URLRequestSerialization;
export '../domain/entities/enums/url_request_attribution.dart'
    show URLRequestAttribution;
export '../domain/entities/enums/url_request_cache_policy.dart'
    show URLRequestCachePolicy;
export '../domain/entities/enums/url_request_network_service_type.dart'
    show URLRequestNetworkServiceType;
export '../domain/entities/url_response/url_response.dart'
    show URLResponse, URLResponseSerialization;
export '../domain/entities/enums/user_preferred_content_mode.dart' show UserPreferredContentMode;
export 'user_script.dart' show UserScript;
export '../domain/entities/enums/user_script_injection_time.dart' show UserScriptInjectionTime;
export '../domain/entities/enums/vertical_scrollbar_position.dart' show VerticalScrollbarPosition;
export '../domain/entities/enums/web_archive_format.dart' show WebArchiveFormat, webArchiveFormatFromWire, webArchiveFormatToWire;
export '../domain/entities/enums/web_authentication_session_error.dart' show WebAuthenticationSessionError, webAuthenticationSessionErrorFromWire, webAuthenticationSessionErrorToWire;
export '../domain/entities/enums/web_authentication_support.dart' show WebAuthenticationSupport;
export '../domain/entities/web_history/web_history.dart' show WebHistory, WebHistorySerialization;
export '../domain/entities/web_history_item/web_history_item.dart' show WebHistoryItem, WebHistoryItemSerialization;
export 'web_message_callback.dart' show WebMessageCallback;
// Zorphy entities (migrated from @ExchangeableObject codegen, see PROGRESS.md).
export '../domain/entities/web_resource_error/web_resource_error.dart'
    show WebResourceError, WebResourceErrorSerialization;
export '../domain/entities/enums/web_resource_error_type.dart'
    show WebResourceErrorType;
export '../domain/entities/web_resource_request/web_resource_request.dart'
    show WebResourceRequest, WebResourceRequestSerialization;
export '../domain/entities/web_resource_response/web_resource_response.dart'
    show WebResourceResponse, WebResourceResponseSerialization;
export '../domain/entities/web_storage_origin/web_storage_origin.dart' show WebStorageOrigin, WebStorageOriginSerialization;
export '../domain/entities/enums/web_storage_type.dart' show WebStorageType, webStorageTypeToWire;
export '../domain/entities/website_data_record/website_data_record.dart' show WebsiteDataRecord, WebsiteDataRecordSerialization;
export '../domain/entities/enums/website_data_type.dart' show WebsiteDataType, websiteDataTypeFromWire, websiteDataTypeToWire;
export '../domain/entities/webview_package_info/webview_package_info.dart' show WebViewPackageInfo, WebViewPackageInfoSerialization;
export '../domain/entities/enums/webview_render_process_action.dart' show WebViewRenderProcessAction, webViewRenderProcessActionFromWire, webViewRenderProcessActionToWire;
export '../domain/entities/window_features/window_features.dart'
    show WindowFeatures, WindowFeaturesSerialization;
export '../domain/entities/find_session/find_session.dart' show FindSession, FindSessionSerialization;
export '../domain/entities/enums/search_result_display_style.dart' show SearchResultDisplayStyle;
export '../domain/entities/enums/content_blocker_trigger_load_context.dart' show ContentBlockerTriggerLoadContext, contentBlockerTriggerLoadContextFromWire, contentBlockerTriggerLoadContextToWire;
export '../domain/entities/enums/print_job_page_order.dart' show PrintJobPageOrder, printJobPageOrderFromWire, printJobPageOrderToWire;
export '../domain/entities/enums/print_job_pagination_mode.dart' show PrintJobPaginationMode;
export '../domain/entities/enums/print_job_disposition.dart' show PrintJobDisposition;
export '../domain/entities/printer/printer.dart' show Printer, PrinterSerialization;
export '../domain/entities/enums/window_type.dart' show WindowType;
export '../domain/entities/enums/window_style_mask.dart' show WindowStyleMask, windowStyleMaskFromWire, windowStyleMaskToWire;
export '../domain/entities/enums/window_titlebar_separator_style.dart' show WindowTitlebarSeparatorStyle;
export '../domain/entities/enums/custom_tabs_navigation_event_type.dart' show CustomTabsNavigationEventType, customTabsNavigationEventTypeFromWire, customTabsNavigationEventTypeToWire;
export '../domain/entities/enums/custom_tabs_relation_type.dart' show CustomTabsRelationType, customTabsRelationTypeFromWire, customTabsRelationTypeToWire;
export '../domain/entities/prewarming_token/prewarming_token.dart' show PrewarmingToken, PrewarmingTokenSerialization;
export '../domain/entities/android_resource/android_resource.dart' show AndroidResource, AndroidResourceSerialization;
export '../domain/entities/ui_image/ui_image.dart' show UIImage, UIImageSerialization;
export '../domain/entities/activity_button/activity_button.dart' show ActivityButton, ActivityButtonSerialization;
export '../domain/entities/ui_event_attribution/ui_event_attribution.dart' show UIEventAttribution, UIEventAttributionSerialization;
export '../domain/entities/enums/tracing_mode.dart' show TracingMode;
export '../domain/entities/enums/tracing_category.dart' show TracingCategory, tracingCategoryFromWire, tracingCategoryToWire;
export '../domain/entities/enums/custom_tabs_post_message_result_type.dart' show CustomTabsPostMessageResultType, customTabsPostMessageResultTypeFromWire, customTabsPostMessageResultTypeToWire;
export 'disposable.dart';
