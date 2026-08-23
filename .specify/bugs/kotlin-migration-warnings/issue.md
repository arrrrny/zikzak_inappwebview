# Bug Issue: [Migrate to Built-in Kotlin] New warnings on version 5.0.0

- **Slug**: kotlin-migration-warnings
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 235
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/235
- **State**: open
- **Severity**: unknown
- **Author**: KohlsAdrian
- **Labels**: none

## Body

If you are a plugin author, please migrate your plugin to Built-in Kotlin using this guide: https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-plugin-authors

~/.pub-cache/bin/hosted/pub.dev/zikzak_inappwebview_android-5.0.0/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java:750: warning: [removal] setRequestedWithHeaderOriginAllowList(WebSettings,Set<String>) in WebSettingsCompat has been deprecated and marked for removal
                WebSettingsCompat.setRequestedWithHeaderOriginAllowList(
                                 ^
~/.pub-cache/bin/hosted/pub.dev/zikzak_inappwebview_android-5.0.0/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java:2230: warning: [removal] setRequestedWithHeaderOriginAllowList(WebSettings,Set<String>) in WebSettingsCompat has been deprecated and marked for removal
                WebSettingsCompat.setRequestedWithHeaderOriginAllowList(
                                 ^
~/.pub-cache/bin/hosted/pub.dev/zikzak_inappwebview_android-5.0.0/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java:978: warning: [removal] getRequestedWithHeaderOriginAllowList(WebSettings) in WebSettingsCompat has been deprecated and marked for removal
                        WebSettingsCompat.getRequestedWithHeaderOriginAllowList(

## Comments

None.
