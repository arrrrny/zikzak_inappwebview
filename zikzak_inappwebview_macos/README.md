# zikzak_inappwebview_macos

The macOS implementation of the [zikzak_inappwebview](https://pub.dev/packages/zikzak_inappwebview) plugin.

## Usage

This package is endorsed, which means you can simply use `zikzak_inappwebview` normally. This package will be automatically included in your app when you do.

## Media capture (camera / microphone) on macOS

`getUserMedia()` (camera / microphone) is supported on macOS 12.0+ via the
`WKUIDelegate` methods `webView(_:requestMediaCapturePermissionFor:initiatedByFrame:type:)`
and `webView(_:requestDeviceOrientationAndMotionPermissionFor:initiatedByFrame:)`.
Permission requests are forwarded to Dart through the existing
`onPermissionRequest` callback (the same event used on iOS and Android), and the
`PermissionResponse.action` you return (`GRANT` / `DENY` / `PROMPT`) is mapped
back to WebKit's `WKPermissionDecision`. If your `onPermissionRequest` handler
is not set, or returns `null`, the request is **denied** — this matches the iOS
default and is always safe (WebKit never hangs waiting for a decision).

### Required app configuration

For the WebView to actually access the camera / microphone **after** the
`WKPermissionDecision` is granted, your macOS app must declare the usage
descriptions and (for sandboxed apps) the corresponding entitlements. Without
these, the system TCC layer denies access silently and `getUserMedia()` rejects
with `NotAllowedError`, even though the WebView permission prompt was granted.

1. **Info.plist** — add a usage-description string for each capture type your
   app needs. The system shows this text in the permission prompt:

   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access so web pages can use the camera.</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>This app needs microphone access so web pages can use the microphone.</string>
   ```

2. **Entitlements** (required for sandboxed apps, i.e. when
   `com.apple.security.app-sandbox` is `true`) — add the device entitlements:

   ```xml
   <key>com.apple.security.device.camera</key>
   <true/>
   <key>com.apple.security.device.audio-input</key>
   <true/>
   ```

   Add these to **both** your `DebugProfile.entitlements` and
   `Release.entitlements` files. Non-sandboxed apps do not need the entitlements,
   but the Info.plist usage strings are always required.

### Example

The example app ships a "Media capture (getUserMedia) test" button in the app
bar that loads an inline page calling `getUserMedia({video:true,audio:true})`.
**For testing only**, the example's `onPermissionRequest` handler grants every
request — this is convenient for the test button but is **not** a pattern you
should copy into production apps that load untrusted web content.

In production, **deny by default** and grant only for origins you trust after
checking `request.resources`:

```dart
InAppWebView(
  // ...
  onPermissionRequest: (controller, request) async {
    // Trust only your own origin. Reject anything else.
    final trustedHosts = const {'your-app.example.com'};
    final originHost = request.origin.host;
    if (!trustedHosts.contains(originHost)) {
      return PermissionResponse(
        resources: request.resources,
        action: PermissionResponseAction.DENY,
      );
    }
    // Optionally gate on request.resources (camera / microphone / etc.)
    // before granting. Here we grant only the resources the page requested.
    return PermissionResponse(
      resources: request.resources,
      action: PermissionResponseAction.GRANT,
    );
  },
);
```

Tap the camera icon in the app bar to load the test page; on macOS 12.0+ the
system shows the camera/microphone permission prompt, and once granted the live
stream is rendered in the page's `<video>` element.

### Notes

- The delegate methods are gated `@available(macOS 12.0, *)`, matching the
  availability of `WKUIDelegate.requestMediaCapturePermissionForOrigin` on
  macOS. The package's deployment target is already macOS 12.0.
- `WKMediaCaptureType` (`.camera` / `.microphone` / `.cameraAndMicrophone`) is
  mapped to `PermissionResourceType` using its `rawValue`, exactly as on iOS —
  the shared Dart `PermissionResourceType.fromNativeValue` handles the macOS
  native values (`0` / `1` / `2`).
- Device-orientation-and-motion permission (`requestDeviceOrientationAndMotionPermissionForOrigin`)
  is also implemented for parity with iOS; it dispatches the same
  `onPermissionRequest` event with the `DEVICE_ORIENTATION_AND_MOTION` resource.
