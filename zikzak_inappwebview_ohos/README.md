# Zikzak InAppWebView for OpenHarmony

An unendorsed federated implementation of `zikzak_inappwebview`, using the
system ArkWeb engine. Add this package alongside `zikzak_inappwebview`; OHOS
Flutter registers `OhosInAppWebViewPlatform` automatically. Application code uses
the ordinary `InAppWebView`, `InAppWebViewController` and `CookieManager` APIs.
No generated app backend or dependency on `webview_flutter` is required.

## Requirements

- OpenHarmony Flutter 3.47 or newer, Dart 3.13 or newer.
- HarmonyOS/OpenHarmony API 23 or newer. Native cookie enumeration uses
  `WebCookieManager.fetchAllCookies`, introduced in API 23.
- Declare `ohos.permission.INTERNET` in the application's `module.json5`.
  Camera, microphone and location requests also require the appropriate host
  declarations and runtime consent. A WebView callback never grants OS consent.

This platform package accepts the 6.4 platform interface. It can be added to
6.4 applications on OH Flutter 3.47 without raising the umbrella's Apple SDK
requirements; newer interface releases remain subject to their own SDK floor.

## Implemented surface

- Inline ArkWeb views; URL/HTML/asset loading; back/forward/reload/stop.
- GET request headers and native POST body loading. ArkWeb cannot attach custom
  headers to `postUrl`; such requests fail explicitly rather than becoming GETs.
- Progress, title, history, console, HTTP and resource-error events.
- JavaScript evaluation with decoded JSON results and asynchronous
  `window.zikzak_inappwebview.callHandler` results.
- Ordered document-start/end user scripts in the page content world, including
  origin rules and main-frame-only scripts; script changes apply before the
  configuration Future resolves. Isolated worlds are unsupported.
- JavaScript, zoom, viewport, text zoom, user agent, mixed content, forced dark,
  media gesture and transparent-background settings.
- OS-native cookies, including HttpOnly attributes, host/domain/path scoping,
  same-name path variants, writing and deletion. Cookie persistence is owned by
  ArkWeb, not by a Dart-side mirror.
- Media/geolocation callbacks (deny by default), system document selection and
  camera capture for file inputs.

## Navigation policy boundary

ArkWeb's URL override callback is synchronous, while the public Dart navigation
policy is asynchronous. The implementation cancels and reissues allowed
**main-frame GET** requests, preserving headers. A later navigation invalidates
an outstanding decision. POST bodies and frame identities cannot be recovered
from this native callback, so POST and subframe requests continue natively and
are not offered as cancellable asynchronous navigation events.

Headless views, keep-alive/adopting popup windows, browser windows, isolated
content worlds, DevTools protocol capture and proxy overrides are not
implemented. Their inherited platform methods throw rather than report success.

## Validation

Run using an OHOS Flutter SDK (the platform widget uses `OhosView`):

```sh
flutter pub get
dart analyze --fatal-infos lib test
flutter test --concurrency=2
```

Native behavior must also be verified on an API 23+ device through a consumer
application. A Dart-only channel test does not compile ArkTS or prove WebView
rendering, script timing, native permission delivery or cookie persistence.
