# wire_parity

Dev-only package (not published; `.pubignore` excludes it). It checks that the
values zikzak's Dart layer sends to the Linux native code are the values the
native code, imported from upstream flutter_inappwebview_linux 0.1.0-beta.1,
was written to decode.

Both directions are covered, in one test file each (shared helpers and the
`knownDifferences` table are in `test/support.dart`):

- `test/encode_test.dart`, `test/enums_test.dart`, `test/settings_test.dart`:
  Dart to native. The same object is built with every field set to a
  non-default value in both interfaces (and once per value of every enum field),
  then upstream's `toMap()` / `toNativeValue()` is compared with zikzak's
  `toJson()` / `xxxToWire()` / `.index`.
- `test/decode_test.dart`: native to Dart. A fully populated upstream object is
  turned into its `toMap()` (the shape upstream's native code emits), passed
  through zikzak's `fromJson`, and zikzak's `toJson()` of the result is compared
  with the original map. Every lost or changed key, and every decoder that
  throws, is a difference.

Comparison is strict after dropping null values and sorting keys: `2` vs `"2"`,
`true` vs `"true"`, `4` vs `4.0` and `List<int>` vs `Uint8List` all differ. Key
order and absent-vs-null are not differences. The tests pin
`debugDefaultTargetPlatformOverride` to Linux, because upstream's native values
and zikzak's permission encoding depend on the platform.

Every differing path prints a `DIFF <label>@<path>` line and must be explained by
an entry in `knownDifferences`: key `Root` covers every path of labels `Root` and
`Root.*`; key `Root@path` covers that path only. The value names the adapter in
`lib/src/util/wire.dart` that resolves it, or says why none is needed (an extra
key native never reads). An unlisted difference fails the test. Set
`WIRE_PARITY_VERBOSE=1` to print both encodings under each DIFF line.

Not compared, with the reason:

- `ProxySettings`: zikzak's has a different shape and no `toJson`; mapped by hand.
- `WebMessageListener.toMap()`: implemented by the platform class in the Linux
  package, not by either interface package.
- `PullToRefreshOptions` (deprecated upstream), `InAppBrowserClassOptions`
  (deprecated upstream), `ShowFileChooserRequest`, `JavaScriptHandlerFunctionData`
  and `CacheModel`: zikzak has no such type.
- `InAppWebViewSettings.webViewAssetLoader`: Android-only structured type that
  Linux never reads.
- `WebResourceErrorType.toNativeValue()`: zikzak has no wire encoding for it
  (its decoder is covered in `decode_test.dart`).
- `SslCertificate.x509Certificate`: no stable wire form; native sends
  `sslCertificate` as null anyway.

## Run

    cd tool/wire_parity && flutter pub get && flutter test 2>&1 | grep -A2 '^DIFF\|Settings keys only upstream\|All tests passed\|Some tests failed'

Rerun after every upstream sync and after every bump of zikzak's platform
interface, and add an adapter plus a `knownDifferences` entry for each new
difference.

## Settings keys only upstream

These `InAppWebViewSettings` keys exist in upstream's `toMap()` and not in
zikzak's `toJson()` (zikzak has no such settings, so it cannot send them):

    allowModalDialogs, allowTopNavigationToDataUrls, alpha, appCachePath,
    browserAcceleratorKeysEnabled, clearCache, clearSessionCache, corsAllowlist,
    cursorBlinkTime, darkMode, disableAnimations, disableWebSecurity,
    doubleClickDistance, doubleClickTime, dragThreshold, drawCompositingIndicators,
    enable2DCanvasAcceleration, enableCaretBrowsing, enableEncryptedMedia,
    enableJavaScriptMarkup, enableMedia, enableMediaCapabilities,
    enableMockCaptureDevices, enablePageCache, enableResizableTextAreas,
    enableSmoothScrolling, enableSpatialNavigation, enableTabsToLinks,
    enableWebRTC, enableWriteConsoleMessagesToStdout, fontAntialias, fontDPI,
    fontHintingStyle, fontSubpixelLayout, generalAutofillEnabled,
    handleAcceleratorKeyPressed, hiddenPdfToolbarItems, iframeAriaHidden,
    iframeRole, isUserInteractionEnabled, itpEnabled, javaScriptBridgeEnabled,
    javaScriptBridgeForMainFrameOnly, javaScriptBridgeOriginAllowList,
    javaScriptCanAccessClipboard, javaScriptHandlersForMainFrameOnly,
    javaScriptHandlersOriginAllowList, keyRepeatDelay, keyRepeatInterval,
    mediaContentTypesRequiringHardwareSupport, nonClientRegionSupportEnabled,
    passwordAutosaveEnabled, pictographFontFamily, pinchZoomEnabled,
    pluginScriptsForMainFrameOnly, pluginScriptsOriginAllowList,
    regexToAllowSyncUrlLoading, reputationCheckingRequired, scrollMultiplier,
    statusBarEnabled, textZoom, useOnAjaxProgress, useOnAjaxReadyStateChange,
    useOnShowFileChooser, webRTCUdpPortsRange

Missing keys are safe. `linux/in_app_webview/in_app_webview_settings.cc` parses
the settings map in the `InAppWebViewSettings(FlValue*)` constructor, starting
at line 19. Every key is read either with
`x = get_fl_map_value(map, "key", x)` (for example line 41, `userAgent`), which
returns the member's current default when the key is missing, null or of the
wrong type (`linux/utils/flutter.h`, lines 142-165 for bool and int64, with the
same guard in the double, string and string-list overloads), or inside
`if (fl_map_contains_not_null(map, "key")) { ... }` (for example lines 152-195, `darkMode` to
`keyRepeatInterval`). The members' defaults come from `in_app_webview_settings.h`.

Defaults differ from upstream's Dart defaults for three of these keys, so
zikzak users get the native value, not upstream's Dart one:

| key | native default | upstream Dart default |
| --- | --- | --- |
| `allowModalDialogs` | true | false |
| `enable2DCanvasAcceleration` | true | false |
| `enableEncryptedMedia` | false | true |
