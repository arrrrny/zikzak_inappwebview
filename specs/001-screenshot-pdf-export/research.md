# Research: Screenshot and PDF Export

**Feature**: Screenshot and PDF Export  
**Date**: 2026-05-22

## macOS takeScreenshot

### Decision
Implement `takeScreenshot` on macOS by adding a Dart controller override and Swift native handler that uses `WKWebView.takeSnapshot(with:completionHandler:)` with `WKSnapshotConfiguration`, mirroring the existing iOS implementation.

### Rationale
- macOS `WKWebView` has supported `takeSnapshot(with:)` since macOS 10.13, using the exact same API signature as iOS
- The iOS implementation in `InAppWebView.swift` (lines 815-851) is a proven template — both platforms share the same WebKit framework
- The method channel pattern (FlutterMethodCall "takeScreenshot") is already used by the macOS controller for other methods (e.g., "createPdf")
- `WKSnapshotConfiguration` supports rect cropping and snapshot width, matching the `ScreenshotConfiguration` parameters

### Alternatives Considered
1. **Screen capture via NSView snapshots**: More complex, wouldn't match the WebView-only capture behavior of iOS/Android
2. **JavaScript-based canvas rendering**: Less reliable, doesn't capture native-rendered content properly
3. **CGDisplay/Window capture**: Captures entire window including non-WebView UI

### Implementation Notes
- macOS availability check: `@available(macOS 10.13, *)` for the Swift handler
- JPEG/PNG format switching follows same pattern as iOS: `NSImage` → `NSBitmapImageRep` for format conversion
- The `IOSInAppWebViewController` deprecated facade should also forward `takeScreenshot`

---

## Android createPdf

### Decision
Re-implement `createPdf` on Android using `WebView.createPrintDocumentAdapter(String)` + a custom `PrintDocumentAdapter` subclass that renders to a `PdfDocument`, then serializes the PDF bytes to return via the Flutter method channel.

### Rationale
- Android has supported `WebView.createPrintDocumentAdapter()` since API 21 (Lollipop), which is the project's minimum API level
- The original implementation (commit `9fb4dff9`, Feb 2026) used a method channel approach but was in commit `e422e846` (Apr 2026) with the message "removed non existent printPage in android"
- Android WebView does NOT have a native "createPdf" API like iOS/macOS WKWebView — `createPdf` on Android is inherently a print-to-PDF workaround
- The `PrintDocumentAdapter` approach allows using `android.print.pdf.PrintedPdfDocument` to render pages to a file, then read the file bytes back
- Linux's C implementation uses a similar pattern (`WebKitPrintOperation` → output to temp file → read bytes back)

### Alternatives Considered
1. **JavaScript `window.print()` + native print intercept**: Unreliable cross-device, UI-dependent
2. **External PDF library (iText, PDFBox)**: Heavy dependency, not platform-native
3. **Canvas-based HTML-to-PDF in JavaScript (jsPDF)**: Poor fidelity for complex pages, no native text rendering
4. **Keep disabled**: Violates FR-005 and user requirement for Android parity

### Implementation Details
The approach uses a `PdfPrintDocumentAdapter` helper class that:
1. Wraps `WebView.createPrintDocumentAdapter("document")` in a custom adapter for layout
2. Uses `android.graphics.pdf.PdfDocument` to render each page
3. Writes to a temporary file in the app's cache directory
4. Reads the bytes and returns them through the Flutter method channel
5. Cleans up the temp file

Key considerations:
- Layout: Need `PrintAttributes.MediaSize` to handle page size from `PDFConfiguration`
- Multi-page: Iterate through pages from the print adapter
- Memory: Use temp file (not in-memory) for large documents to avoid OOM
- Thread safety: PDF generation runs on background thread, result dispatched to main thread

---

## Linux createPdf

### Decision
Add a `createPdf` Dart controller override that invokes the existing native C implementation via Flutter method channel. No native code changes needed.

### Rationale
- The native C code in `in_app_webview.cc` (lines 286-311) is fully functional: it creates a `WebKitPrintOperation`, saves PDF to `/tmp/`, reads bytes back, cleans up
- The only gap is the Dart → native wiring: `LinuxInAppWebViewController` at `zikzak_inappwebview_linux/lib/src/in_app_webview/in_app_webview_controller.dart` has no `createPdf` override
- Following the exact same pattern as iOS (lines 2527-2532) and macOS (lines 240-245): invoke `_channel.invokeMethod<Uint8List?>('createPdf', args)`

### Alternatives Considered
1. **Rewrite native C code**: Unnecessary — existing code works
2. **New implementation approach**: Adds risk and complexity for no benefit

### Implementation Notes
- Simply add `@override Future<Uint8List?> createPdf({...})` to the Dart controller
- Pass `pdfConfiguration?.toMap()` as argument, matching iOS/macOS pattern
- The native C handler already parses `pdfConfiguration` from the method call arguments
- Verify that `pdfConfiguration` parameters are handled by the C code (may need a parity check)

---

## Linux takeScreenshot

### Decision
Implement `takeScreenshot` on Linux using `webkit_web_view_get_snapshot()` which the Linux plugin already uses internally for pixel buffer texture rendering.

### Rationale
- `webkit_web_view_get_snapshot()` is already in the codebase for the pixel buffer texture feature (`in_app_webview.cc` line 144)
- The API returns a `cairo_surface_t` which can be rendered to PNG or JPEG via cairo/pixbuf APIs
- GTK/WebKit provide all necessary infrastructure without external dependencies

### Alternatives Considered
1. **GDK Pixbuf screen capture of the entire window**: Captures non-WebView UI, doesn't match platform behavior
2. **JavaScript canvas approach (via evaluateJavascript)**: Inconsistent results, no native rendering quality
3. **Skip Linux screenshot**: User considers Linux "nice to have" but PR explicitly lists both features for Linux

### Implementation Details
- Native C: Add "takeScreenshot" case to the method call handler
  - Use `webkit_web_view_get_snapshot()` to get a cairo surface
  - Convert to PNG or JPEG based on `ScreenshotConfiguration.compressFormat`
  - Return `Uint8List` through Flutter result
- Dart: Add `takeScreenshot` override to `LinuxInAppWebViewController`
  - Invoke `_channel.invokeMethod<Uint8List?>('takeScreenshot', args)`

---

## Windows and Web (Out of Scope)

### Decision
Continue returning `null` for `createPdf` on Windows (existing behavior) and leave `takeScreenshot` unimplemented (throws `UnimplementedError` from base class) on both Windows and Web.

### Rationale
- User explicitly stated "windows and web dont bother"
- Windows has a TODO stub; Web has a null-return stub
- No changes needed to these packages

---

## iOS Verification

### Decision
No functional changes to iOS — existing implementation is confirmed complete. Verification consists of confirming no regressions.

### Rationale
- iOS `takeScreenshot` is fully implemented in Dart (line 1910) and Swift (line 815)
- iOS `createPdf` is fully implemented in Dart (line 2528) and Swift (line 853)
- Both features use the canonical Apple WebKit APIs
- The `@available(iOS 11.0, *)` and `@available(iOS 14.0, *)` guards are appropriate

---

## Deprecated Apple Facade

### Decision
Add `takeScreenshot` forwarding to the deprecated `IOSInAppWebViewController` in the main package, matching the existing `createPdf` forwarding pattern.

### Rationale
- `IOSInAppWebViewController` at `zikzak_inappwebview/lib/src/in_app_webview/apple/in_app_webview_controller.dart` already forwards `createPdf` (lines 26-30)
- Adding `takeScreenshot` forwarding maintains backward compatibility
- Follows the existing `@Deprecated` annotation pattern
