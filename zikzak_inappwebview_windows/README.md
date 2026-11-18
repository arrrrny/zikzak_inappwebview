# zikzak_inappwebview_windows

The Windows implementation of the [zikzak_inappwebview](https://pub.dev/packages/zikzak_inappwebview) plugin.

## Usage

This package is endorsed, which means you can simply use `zikzak_inappwebview` normally. This package will be automatically included in your app when you do.

## Cookies and the WebView2 environment

`CookieManager` supports native URL-scoped reads, inventory, writes, deletion
by name/domain/path, clearing the jar, and removing session cookies. HttpOnly
cookies are handled through CDP; they are never read or written through page
JavaScript. Expiration dates use milliseconds, as on the other platforms.

Cookies and visible webviews await the same environment initialization. Create
the desired `WebViewEnvironment` before the first cookie operation or webview,
and pass it to both. The companion currently supports **one environment per
process**. A request with a different explicit user-data directory, runtime
directory, or browser arguments throws instead of silently using the existing
profile. Omitting environment options reuses the existing environment.

A non-navigating native controller provides cookie access before any visible
webview exists. Disposing the environment releases that controller; the native
environment itself remains alive until the process exits.

## Verification

Run `flutter test test/` for channel-boundary and widget tests. The native
scenario is `integration_test/windows_cookie_profile_test.dart`: copy it into
the `integration_test/` directory of an isolated Windows Flutter consumer using
this package, then run `flutter test integration_test/windows_cookie_profile_test.dart -d windows`.
The consumer needs `integration_test` from the
Flutter SDK, `material_ui`, and `zikzak_inappwebview_platform_interface`.
Set the standard `WEBVIEW2_USER_DATA_FOLDER` environment variable to a fresh
temporary profile for each run. The consumer owns that directory and removes it
after its process exits (WebView2 keeps the profile open while running).

`integration_test/windows_navigation_test.dart` uses the same consumer setup to
exercise the first intercepted request with headers, subsequent page-initiated
navigation, cancellation, and a successful load after cancellation. Run it in a
separate process with its own fresh profile.
