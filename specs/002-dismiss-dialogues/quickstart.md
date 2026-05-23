# Quickstart: Dismiss Dialogues Setting

## Step 1 — Add the setting to the annotated template

Edit `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/in_app_webview_settings.dart`:

Add the new property inside the `InAppWebViewSettings_` class:

```dart
@SupportedPlatforms(platforms: [
  PlatformOS.iOS,
  PlatformOS.android,
  PlatformOS.macOS,
  PlatformOS.windows,
  PlatformOS.linux,
  PlatformOS.web,
])
@ExchangeableObjectProperty(defaultValue: "true")
bool? dismissDialogues;
```

## Step 2 — Regenerate `.g.dart`

```bash
cd zikzak_inappwebview_platform_interface
dart run build_runner build --delete-conflicting-outputs
```

## Step 3 — Add the dismissal logic to the web view controller

In `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview_controller.dart`, after page load completes (`onLoadStop`), if `dismissDialogues` is `true`, call `evaluateJs` with the overlay removal script.

The script should:
1. Query all elements
2. Remove those with `position: fixed` or `position: sticky`
3. Reset `overflow` and `margin` on `html` and `body`
4. Return removed count

Wrap in a retry loop (3 attempts, 800ms delay).

## Step 4 — Propagate to platform packages

For each platform package, add the `dismissDialogues` property to the native `InAppWebViewSettings` implementation:

| Platform | File | Language |
|---|---|---|
| iOS | `.../ios/.../InAppWebViewSettings.swift` | Swift |
| macOS | `.../macos/.../InAppWebViewSettings.swift` | Swift |
| Android | `.../android/.../InAppWebViewSettings.java` | Java |
| Linux | `.../linux/.../in_app_webview_settings.cc` | C++ |
| Windows | `.../windows/.../in_app_webview_settings.dart` | Dart |
| Web | `.../web/.../in_app_webview_settings.dart` | Dart |

Each platform just needs to store the boolean property — the actual overlay removal runs from the Dart JS evaluation (not native code), so the native side only needs to pass the value through.

## Step 5 — Update agent context

Update `AGENTS.md` to point to this plan:
```
<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
at specs/002-dismiss-dialogues/plan.md
<!-- SPECKIT END -->
```
