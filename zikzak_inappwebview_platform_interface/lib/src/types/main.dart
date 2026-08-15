export 'action_mode_menu_item.dart' show ActionModeMenuItem;
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
export 'attributed_string.dart' show AttributedString;
export 'attributed_string_text_effect_style.dart'
    show AttributedStringTextEffectStyle;
export 'cache_mode.dart' show CacheMode;
export 'call_async_javascript_result.dart' show CallAsyncJavaScriptResult;
export 'client_cert_challenge.dart' show ClientCertChallenge;
export 'client_cert_response.dart' show ClientCertResponse;
export 'client_cert_response_action.dart' show ClientCertResponseAction;
export 'compress_format.dart' show CompressFormat;
// Zorphy entities (migrated from @ExchangeableObject codegen, see PROGRESS.md).
export '../domain/entities/console_message/console_message.dart'
    show ConsoleMessage, ConsoleMessageSerialization;
export '../domain/entities/enums/console_message_level.dart'
    show ConsoleMessageLevel;
export 'content_blocker_action_type.dart' show ContentBlockerActionType;
export 'content_blocker_trigger_load_type.dart'
    show ContentBlockerTriggerLoadType;
export 'content_blocker_trigger_resource_type.dart'
    show ContentBlockerTriggerResourceType;
export 'content_world.dart' show ContentWorld;
export 'cookie.dart' show Cookie;
export 'create_window_action.dart' show CreateWindowAction;
export 'cross_origin.dart' show CrossOrigin;
export 'css_link_html_tag_attributes.dart' show CSSLinkHtmlTagAttributes;
export 'custom_scheme_response.dart' show CustomSchemeResponse;
export 'custom_tabs_share_state.dart' show CustomTabsShareState;
export 'data_detector_types.dart' show DataDetectorTypes;
export 'dismiss_button_style.dart' show DismissButtonStyle;
export 'download_start_request.dart' show DownloadStartRequest;
export 'favicon.dart' show Favicon;
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
export 'force_dark.dart' show ForceDark;
export 'force_dark_strategy.dart' show ForceDarkStrategy;
export 'form_resubmission_action.dart' show FormResubmissionAction;
export 'frame_info.dart' show FrameInfo;
export '../domain/entities/geolocation_permission_show_prompt_response/geolocation_permission_show_prompt_response.dart'
    show GeolocationPermissionShowPromptResponse,
        GeolocationPermissionShowPromptResponseSerialization;
export 'http_auth_response.dart' show HttpAuthResponse;
export 'http_auth_response_action.dart' show HttpAuthResponseAction;
export 'http_authentication_challenge.dart' show HttpAuthenticationChallenge;
export 'http_cookie_same_site_policy.dart' show HTTPCookieSameSitePolicy;
export 'in_app_webview_hit_test_result.dart' show InAppWebViewHitTestResult;
export 'in_app_webview_hit_test_result_type.dart'
    show InAppWebViewHitTestResultType;
export 'in_app_webview_initial_data.dart' show InAppWebViewInitialData;
export 'in_app_webview_rect.dart' show InAppWebViewRect;
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
export 'layout_algorithm.dart' show LayoutAlgorithm;
export 'layout_in_display_cutout_mode.dart' show LayoutInDisplayCutoutMode;
export 'loaded_resource.dart' show LoadedResource;
export 'login_request.dart' show LoginRequest;
export 'media_capture_state.dart' show MediaCaptureState;
export 'media_playback_state.dart' show MediaPlaybackState;
export 'meta_tag.dart' show MetaTag;
export 'meta_tag_attribute.dart' show MetaTagAttribute;
export 'mixed_content_mode.dart' show MixedContentMode;
export 'modal_presentation_style.dart' show ModalPresentationStyle;
export 'modal_transition_style.dart' show ModalTransitionStyle;
export 'navigation_action.dart' show NavigationAction;
export 'network_capture_controller.dart' show NetworkCaptureController;
export 'network_entry.dart' show NetworkEntry;
export 'network_request.dart' show NetworkRequest;
export 'network_response.dart' show NetworkResponse;
export 'network_response_body.dart' show NetworkResponseBody;
export 'resource_type.dart' show ResourceType;
export 'android_webview_insets.dart' show AndroidWebViewInsets;
export 'url_pattern_type.dart' show UrlPatternType;
export 'navigation_action_policy.dart' show NavigationActionPolicy;
export 'navigation_response.dart' show NavigationResponse;
export 'navigation_response_action.dart' show NavigationResponseAction;
export 'navigation_type.dart' show NavigationType;
export 'on_post_message_callback.dart' show OnPostMessageCallback;
export 'over_scroll_mode.dart' show OverScrollMode;
export 'pdf_configuration.dart' show PDFConfiguration;
export '../domain/entities/permission_request/permission_request.dart'
    show PermissionRequest, PermissionRequestSerialization;
export '../domain/entities/enums/permission_resource_type.dart'
    show PermissionResourceType;
export '../domain/entities/permission_response/permission_response.dart'
    show PermissionResponse, PermissionResponseSerialization;
export '../domain/entities/enums/permission_response_action.dart'
    show PermissionResponseAction;
export 'print_job_attributes.dart' show PrintJobAttributes;
export 'print_job_color_mode.dart' show PrintJobColorMode;
export 'print_job_duplex_mode.dart' show PrintJobDuplexMode;
export 'print_job_info.dart' show PrintJobInfo;
export 'print_job_media_size.dart' show PrintJobMediaSize;
export 'print_job_orientation.dart' show PrintJobOrientation;
export 'print_job_output_type.dart' show PrintJobOutputType;
export 'print_job_rendering_quality.dart' show PrintJobRenderingQuality;
export 'print_job_resolution.dart' show PrintJobResolution;
export 'print_job_state.dart' show PrintJobState;
export 'proxy_rule.dart' show ProxyRule;
export 'proxy_scheme_filter.dart' show ProxySchemeFilter;
export 'pull_to_refresh_size.dart' show PullToRefreshSize;
export 'referrer_policy.dart' show ReferrerPolicy;
export 'render_process_gone_detail.dart' show RenderProcessGoneDetail;
export 'renderer_priority.dart' show RendererPriority;
export 'renderer_priority_policy.dart' show RendererPriorityPolicy;
export 'request_focus_node_href_result.dart' show RequestFocusNodeHrefResult;
export 'request_image_ref_result.dart' show RequestImageRefResult;
export '../domain/entities/safe_browsing_response/safe_browsing_response.dart'
    show SafeBrowsingResponse, SafeBrowsingResponseSerialization;
export '../domain/entities/enums/safe_browsing_response_action.dart'
    show SafeBrowsingResponseAction;
export '../domain/entities/enums/safe_browsing_threat.dart'
    show SafeBrowsingThreat;
export 'sandbox.dart' show Sandbox;
export 'screenshot_configuration.dart' show ScreenshotConfiguration;
export 'script_html_tag_attributes.dart' show ScriptHtmlTagAttributes;
export 'scrollbar_style.dart' show ScrollBarStyle;
export 'scrollview_content_inset_adjustment_behavior.dart'
    show ScrollViewContentInsetAdjustmentBehavior;
export 'scrollview_deceleration_rate.dart' show ScrollViewDecelerationRate;
export 'security_origin.dart' show SecurityOrigin;
export 'selection_granularity.dart' show SelectionGranularity;
export 'server_trust_auth_response.dart' show ServerTrustAuthResponse;
export 'server_trust_auth_response_action.dart'
    show ServerTrustAuthResponseAction;
export 'server_trust_challenge.dart' show ServerTrustChallenge;
export 'should_allow_deprecated_tls_action.dart'
    show ShouldAllowDeprecatedTLSAction;
export 'ssl_certificate.dart' show SslCertificate;
export 'ssl_certificate_dname.dart' show SslCertificateDName;
export 'ssl_error.dart' show SslError;
export 'ssl_error_type.dart' show SslErrorType;
export 'trusted_web_activity_default_display_mode.dart'
    show TrustedWebActivityDefaultDisplayMode;
export 'trusted_web_activity_display_mode.dart'
    show TrustedWebActivityDisplayMode;
export 'trusted_web_activity_immersive_display_mode.dart'
    show TrustedWebActivityImmersiveDisplayMode;
export 'trusted_web_activity_screen_orientation.dart'
    show TrustedWebActivityScreenOrientation;
export 'underline_style.dart' show UnderlineStyle;
export 'url_authentication_challenge.dart' show URLAuthenticationChallenge;
export 'url_credential.dart' show URLCredential;
export 'url_credential_persistence.dart' show URLCredentialPersistence;
export 'url_protection_space.dart' show URLProtectionSpace;
export 'url_protection_space_authentication_method.dart'
    show URLProtectionSpaceAuthenticationMethod;
export 'url_protection_space_http_auth_credentials.dart'
    show URLProtectionSpaceHttpAuthCredentials;
export 'url_protection_space_proxy_type.dart' show URLProtectionSpaceProxyType;
export 'url_request.dart' show URLRequest;
export 'url_request_attribution.dart' show URLRequestAttribution;
export 'url_request_cache_policy.dart' show URLRequestCachePolicy;
export 'url_request_network_service_type.dart'
    show URLRequestNetworkServiceType;
export 'url_response.dart' show URLResponse;
export 'user_preferred_content_mode.dart' show UserPreferredContentMode;
export 'user_script.dart' show UserScript;
export 'user_script_injection_time.dart' show UserScriptInjectionTime;
export 'vertical_scrollbar_position.dart' show VerticalScrollbarPosition;
export 'web_archive_format.dart' show WebArchiveFormat;
export 'web_authentication_session_error.dart'
    show WebAuthenticationSessionError;
export 'web_authentication_support.dart' show WebAuthenticationSupport;
export 'web_history.dart' show WebHistory;
export 'web_history_item.dart' show WebHistoryItem;
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
export 'web_storage_origin.dart' show WebStorageOrigin;
export 'web_storage_type.dart' show WebStorageType;
export 'website_data_record.dart' show WebsiteDataRecord;
export 'website_data_type.dart' show WebsiteDataType;
export 'webview_package_info.dart' show WebViewPackageInfo;
export 'webview_render_process_action.dart' show WebViewRenderProcessAction;
export 'window_features.dart' show WindowFeatures;
export 'find_session.dart' show FindSession;
export 'search_result_display_style.dart' show SearchResultDisplayStyle;
export 'content_blocker_trigger_load_context.dart'
    show ContentBlockerTriggerLoadContext;
export 'print_job_page_order.dart' show PrintJobPageOrder;
export 'print_job_pagination_mode.dart' show PrintJobPaginationMode;
export 'print_job_disposition.dart' show PrintJobDisposition;
export 'printer.dart' show Printer;
export 'window_type.dart' show WindowType;
export 'window_style_mask.dart' show WindowStyleMask;
export 'window_titlebar_separator_style.dart' show WindowTitlebarSeparatorStyle;
export 'custom_tabs_navigation_event_type.dart'
    show CustomTabsNavigationEventType;
export 'custom_tabs_relation_type.dart' show CustomTabsRelationType;
export 'prewarming_token.dart' show PrewarmingToken;
export 'android_resource.dart' show AndroidResource;
export 'ui_image.dart' show UIImage;
export 'activity_button.dart' show ActivityButton;
export 'ui_event_attribution.dart' show UIEventAttribution;
export 'tracing_mode.dart' show TracingMode;
export 'tracing_category.dart' show TracingCategory;
export 'custom_tabs_post_message_result_type.dart'
    show CustomTabsPostMessageResultType;
export 'disposable.dart';
