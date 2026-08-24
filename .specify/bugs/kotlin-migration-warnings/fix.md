# Bug Fix: kotlin-migration-warnings

- **Slug**: kotlin-migration-warnings
- **Fixed**: 2026-08-23
- **Branch**: `fix/kotlin-migration-warnings` (based on `master`)
- **Assessment**: `.specify/bugs/kotlin-migration-warnings/assessment.md`
- **Status**: applied (code change complete; build verification pending — no Android SDK in this environment)

## Root-cause correction (important)

The original assessment assumed a drop-in replacement API existed (`setRequestedWithHeaderAllowedOriginList` / `getRequestedWithHeaderAllowedOriginList`) and deferred the fix because "no Android build to verify the replacement API."

Verification against the upstream `androidx.webkit` source (`WebSettingsCompat.java`, androidx-main) shows there is **no replacement API**. The deprecated methods are:

```java
@RequiresFeature(name = WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST, ...)
@Deprecated(forRemoval = true)
@SuppressWarnings("removal")
public static @NonNull Set<String> getRequestedWithHeaderOriginAllowList(@NonNull WebSettings settings) {
    return Collections.emptySet();   // no-op
}

@RequiresFeature(name = WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST, ...)
@Deprecated(forRemoval = true)
@SuppressWarnings("removal")
public static void setRequestedWithHeaderOriginAllowList(@NonNull WebSettings settings,
        @NonNull Set<String> allowList) {
    // no-op
}
```

The Javadoc states: *"The origin trial to disable the X-Requested-With feature has ended, so this API no longer does anything."*

So the `[removal]` warnings cannot be "migrated" — the only correct remediation is to **remove the calls**. Because the methods are no-ops (and the `REQUESTED_WITH_HEADER_ALLOW_LIST` feature is no longer supported by any current WebView provider), removing them produces **zero behavioral change** on modern devices and prevents a hard compile break when a future `androidx.webkit` removes the methods entirely.

## Changes

Removed the three call sites that referenced the deprecated-for-removal `WebSettingsCompat` methods:

1. `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java`
   - Removed the `if (customSettings.requestedWithHeaderOriginAllowList != null && WebViewFeature.isFeatureSupported(REQUESTED_WITH_HEADER_ALLOW_LIST)) { try { setRequestedWithHeaderOriginAllowList(...) } catch (ClassCastException) {...} }` block (~line 743).
   - Removed the analogous update block guarded by `newSettingsMap.get("requestedWithHeaderOriginAllowList") != null && !Util.objEquals(...)` (~line 2219).

2. `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java`
   - Removed the `getRealSettings()` block that called `WebSettingsCompat.getRequestedWithHeaderOriginAllowList(settings)` and stored it under the `"requestedWithHeaderOriginAllowList"` key (~line 970).

Notes:
- The `WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST` constant itself is **not** deprecated, so it is left in place where still referenced (`ZikZakSecurityManager.java`). Those references do not emit `[removal]` warnings.
- `WebSettingsCompat` and `WebViewFeature` imports remain used elsewhere; `ArrayList` is still used in `InAppWebViewSettings.java` — no dangling/unused symbols.
- The public Dart setting `requestedWithHeaderOriginAllowList` (in `zikzak_inappwebview_platform_interface`) is **retained** for API compatibility. It simply becomes a no-op on the native side (which it effectively already was). A follow-up PR may formally deprecate the Dart setting.

3. `zikzak_inappwebview_android/CHANGELOG.md` — added a `## 5.0.2 - TBD` entry.

## Tests

No automated test changes were made. Rationale:
- The affected behavior (`requestedWithHeaderOriginAllowList`) is now a native no-op; there is no observable behavior to assert that would be meaningful or verifiable without a device/WebView that still supports the ended origin trial.
- The fix is a pure deletion of dead API calls. The meaningful verification is "the Android build no longer emits `[removal]` warnings for these methods," which requires a Gradle/Android build (unavailable here).

Suggested verification (to be run in a real Android environment):
- `cd zikzak_inappwebview_android/example && flutter build apk` (or `./gradlew assemble` in the Android project) and confirm zero `warning: [removal] ... RequestedWithHeaderOriginAllowList` lines.
- Confirm the app still compiles against `androidx.webkit:webkit:1.15.0`.

## Risks & Considerations

- **Unverified Android build**: This environment has no Android SDK/Gradle, so the change was not compiled. The edit is a conservative deletion of calls to still-existing (no-op) methods and leaves no dangling references, so it is expected to compile; the Android build check above is still required before merge.
- **Public API**: The Dart `requestedWithHeaderOriginAllowList` setting remains in the API but is now silently ignored by the native side. This is the least-breaking option. Documented in the CHANGELOG; a formal Dart deprecation is a possible follow-up.
- **Future `androidx.webkit`**: Removing the calls now avoids a future hard compile break when the methods are physically removed.
