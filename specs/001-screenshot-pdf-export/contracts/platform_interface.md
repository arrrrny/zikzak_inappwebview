# Platform Interface Contracts: Screenshot and PDF Export

**Feature**: Screenshot and PDF Export  
**Date**: 2026-05-22

These are the existing platform interface method contracts that each platform must implement (or remain compliant with).

---

## Contract 1: `takeScreenshot`

**Declared in**: `PlatformInAppWebViewController` (platform interface abstract class)  
**Dart signature**:

```dart
/// Takes a screenshot of the WebView's visible viewport.
/// Returns a [Uint8List] containing image data, or `null` if the operation fails.
///
/// [screenshotConfiguration] controls format, quality, rect cropping, and scaling.
///
/// Platform availability:
/// - iOS 11.0+
/// - macOS 10.13+
/// - Android (all supported versions)
/// - Linux (WebKitGTK)
///
/// Unsupported platforms must return null without crashing.
Future<Uint8List?> takeScreenshot({
  ScreenshotConfiguration? screenshotConfiguration,
});
```

**Method channel name**: `takeScreenshot`  
**Method channel argument shape**:

```json
{
  "screenshotConfiguration": {
    "compressFormat": "PNG" | "JPEG",
    "quality": 0-100,
    "rect": { "x": double, "y": double, "width": double, "height": double } | null,
    "snapshotWidth": double | null,
    "afterScreenUpdates": bool
  } | null
}
```

**Method channel return**: `Uint8List` (raw image bytes) | `null`

### Platform Compliance

| Platform | Status | Compliance Notes |
|----------|--------|-----------------|
| iOS | ✅ Compliant | WKWebView.takeSnapshot with WKSnapshotConfiguration |
| Android | ✅ Compliant | Bitmap-based capture with canvas rendering |
| macOS | ❌ Missing | Must implement to comply (this feature) |
| Linux | ❌ Missing | Must implement to comply (this feature, P2) |
| Windows | ❌ Non-compliant | Throws UnimplementedError — must return null instead |
| Web | ❌ Non-compliant | Throws UnimplementedError — must return null instead |

---

## Contract 2: `createPdf`

**Declared in**: `PlatformInAppWebViewController` (platform interface abstract class)  
**Dart signature**:

```dart
/// Generates PDF data from the web view's contents asynchronously.
/// Returns a [Uint8List] containing PDF data, or `null` if the operation fails.
///
/// [pdfConfiguration] controls page size, margins, orientation, and capture rect.
///
/// Platform availability:
/// - iOS 14.0+
/// - macOS 11.0+
/// - Android (all supported versions, via PrintDocumentAdapter)
/// - Linux (WebKitGTK, via WebKitPrintOperation)
///
/// Unsupported platforms must return null without crashing.
Future<Uint8List?> createPdf({PDFConfiguration? pdfConfiguration});
```

**Method channel name**: `createPdf`  
**Method channel argument shape**:

```json
{
  "pdfConfiguration": {
    "rect": { "x": double, "y": double, "width": double, "height": double } | null,
    "pageSize": { "width": double, "height": double } | null,
    "orientation": "PORTRAIT" | "LANDSCAPE" | null,
    "margins": { "top": double, "bottom": double, "left": double, "right": double } | null
  } | null
}
```

**Method channel return**: `Uint8List` (raw PDF bytes) | `null`

### Platform Compliance

| Platform | Status | Compliance Notes |
|----------|--------|-----------------|
| iOS | ✅ Compliant | WKWebView.createPDF with WKPDFConfiguration |
| macOS | ✅ Compliant | WKWebView.createPDF with WKPDFConfiguration |
| Android | ❌ Disabled | Returns null, must re-implement (this feature, P1) |
| Linux | ❌ Missing Dart | Native C exists, Dart controller needs wiring (this feature, P2) |
| Windows | ⚠️ Stub | Returns null, acceptable per out-of-scope |
| Web | ⚠️ Stub | Returns null, acceptable per out-of-scope |

---

## Contract 3: Deprecated Apple Facade Forwarding

**Declared in**: `IOSInAppWebViewController` (deprecated Apple facade in main package)  

The deprecated `IOSInAppWebViewController` class at `zikzak_inappwebview/lib/src/in_app_webview/apple/in_app_webview_controller.dart` delegates to the platform controller. It currently forwards `createPdf` but does not forward `takeScreenshot`.

**Required**: Add `takeScreenshot` forwarding:

```dart
@Deprecated("Use InAppWebViewController.takeScreenshot instead")
Future<Uint8List?> takeScreenshot({
  ScreenshotConfiguration? screenshotConfiguration,
}) async {
  return await _controller?.takeScreenshot(
    screenshotConfiguration: screenshotConfiguration,
  );
}
```
