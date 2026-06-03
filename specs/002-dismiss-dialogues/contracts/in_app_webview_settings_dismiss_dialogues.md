# Interface Contract: InAppWebViewSettings.dismissDialogues

## Declaration

```dart
@SupportedPlatforms(platforms: [
  PlatformOS.iOS,
  PlatformOS.android,
  PlatformOS.macOS,
  PlatformOS.windows,
  PlatformOS.linux,
  PlatformOS.web,
])
@ExchangeableObjectProperty(defaultValue: "false")
bool? dismissDialogues;
```

## Contract

- **Type**: `bool?` (nullable, as per all settings in this project's convention)
- **Default**: `false`
- **Platform support**: All platforms (iOS, Android, macOS, Windows, Linux, Web)

## Behavior

When the web view controller receives `onLoadStop` (page load complete), and `dismissDialogues` is `true`:

1. Inject and execute JavaScript that:
   - Queries all elements via `document.querySelectorAll('*')`
   - For each element, checks `window.getComputedStyle(el).position`
   - If `position` is `fixed` or `sticky`, removes the element from DOM
   - Resets `document.documentElement` and `document.body` `overflow` and `margin` to empty string
   - Returns count of removed elements
2. Retry up to 3 times with ~800ms delay between attempts
3. Silently catch any JavaScript errors (no propagation to Dart/native side)

## Serialization

The property follows standard settings serialization:

- **toMap()**: `'dismissDialogues' → bool?`
- **fromMap(map)**: `dismissDialogues = map['dismissDialogues']`

The key `dismissDialogues` must be consistent across all platform channels (Dart, Swift, Java, C++, Web).
