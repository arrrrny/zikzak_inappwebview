# Bug Issue: [Linux] Platform gap analysis & hardening

- **Slug**: linux-platform-gap-hardening
- **Fetched**: 2026-08-24
- **Issue**: 251
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/251
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: none

## Body

# [Linux] Platform gap analysis & hardening

## Summary

Linux was deferred (maintainer uses macOS), so the platform is significantly behind. This report consolidates reported Linux issues, a Dart static-analysis pass, an API-coverage gap analysis vs other platforms, and recommendations.

## 1. Reported Linux issues (GitHub history)

All historically closed (blue screen, build breakage, hardcoded WPE paths, WebKit-version compile errors, keepAlive regressions). No open Linux-specific bug currently exists — the gap is silent.

## 2. Static-analysis findings (Dart) — `zikzak_inappwebview_linux`

- **High (logic bug)**: `in_app_webview_controller.dart:72-82` — `onReceivedError` maps every error to `WebResourceErrorType.UNKNOWN`. `int code = call.arguments['code']` compared with `t.name == code` (String == int) is always false, so `firstWhere` falls through to `UNKNOWN`. Fix: use `t.index == code`. (Fix applied locally.)
- Medium: `handleMethod` wraps dispatch in `catch (e) { // ignore error }` — every callback exception silently swallowed.
- Medium: `dispose({isKeepAlive})` only nulls the handler; does not call `super.dispose()` / native teardown (unlike #227).
- Low (lint): `headless_in_app_webview.dart:160` `overridden_fields` shadow.
- Low (lint): `in_app_webview.dart:77` `avoid_print` debug print.

## 3. API-coverage gap (InAppWebViewController)

Linux implements 18/89 controller methods (~20%), far behind Android (74%) / iOS (67%). ~71 methods fall through to `throw UnimplementedError`. High-impact missing: user scripts, web message listeners, zoom, scroll, cache/history clearing, safe-browsing, dev-tools, `setSettings` (settings never pushed to native), `postUrl`, `loadFile`, `getDefaultUserAgent`, `getFavicons`, media-playback controls.

## 4. CookieManager is entirely stubbed

`linux/lib/src/cookie_manager.dart` implements `PlatformCookieManager` with every method a no-op (`// TODO: implement`): setCookie returns true (does nothing), getCookies/getCookie return []/null, delete* return true, dispose empty. Cookies are completely non-functional on Linux.

## 5. Native build could not be verified

Linux C++/GTK toolchain absent (cmake, clang, ninja, gtk3, webkit2gtk missing), non-root, so `flutter build linux` could not run. Native layer unverified.

## 6. Recommendations

1. Merge the `onReceivedError` fix (int-compare `t.index == code`).
2. Stop swallowing callback errors in `handleMethod`.
3. Wire `CookieManager` to WebKitGTK `SoupCookieManager`/`WebKitCookieManager`.
4. Implement `setSettings` so settings reach the native view.
5. Prioritize the ~71 missing controller methods (at minimum document unsupported).
6. Add a Linux CI job.

See also #227 (disposal) and #229 (domain-controller split) that already landed on `development`.

## Comments

None.
