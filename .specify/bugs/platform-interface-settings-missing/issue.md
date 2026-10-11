# Bug Issue: zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/in_app_webview_settings.dart': No such file or directory

- **Slug**: platform-interface-settings-missing
- **Fetched**: 2026-08-24
- **Issue**: 257
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/257
- **State**: open
- **Severity**: unknown
- **Author**: arontest2023-glitch
- **Labels**: none

## Body

```
../../.pub-cache/hosted/pub.dev/zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/modules/platform_settings_delegate.dart:3:8: Error: Error when reading '../../.pub-cache/hosted/pub.dev/zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/in_app_webview_settings.dart': No such file or directory
import '../in_app_webview_settings.dart';
       ^
../../.pub-cache/hosted/pub.dev/zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/modules/platform_settings_delegate.dart:22:38: Error: Type 'InAppWebViewSettings' not found.
  Future<void> setSettings({required InAppWebViewSettings settings}) {
                                     ^^^^^^^^^^^^^^^^^^^^
../../.pub-cache/hosted/pub.dev/zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/modules/platform_settings_delegate.dart:29:10: Error: Type 'InAppWebViewSettings' not found.
  Future<InAppWebViewSettings?> getSettings() {
         ^^^^^^^^^^^^^^^^^^^^
../../.pub-cache/hosted/pub.dev/zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/modules/platform_settings_delegate.dart:22:38: Error: 'InAppWebViewSettings' isn't a type.
  Future<void> setSettings({required InAppWebViewSettings settings}) {
```

## Comments

None.
