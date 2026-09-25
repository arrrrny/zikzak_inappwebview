# Upstream Issue Draft — flutter/flutter

> Ready to file at https://github.com/flutter/flutter/issues/new?template=2_bug.yml
> Attach the three `ev_3475_*.png` frames from this directory when filing.
> Status: **FILED** as https://github.com/flutter/flutter/issues/193363 (2026-09-25).

---

**Title:** `[iOS] WKWebView platform views drop Flutter content painted after them in overlay composition (regression in 3.47.x; 3.44.x OK)`

**Labels:** platform-ios, platform-views, found in rel: 3.47.x

## Steps to reproduce

1. On Flutter stable **3.47.5** (iOS 18.x simulator; also observed on 3.47.1–3.47.4), create an app that:
   - hosts a `WebViewWidget` (webview_flutter 4.14.1, WKWebView) as the page body,
   - opens a `showModalBottomSheet` whose body is a `ListView.builder` containing a `WebViewWidget` every 11 items,
   - scrolls the list so a WebView item is mid-viewport.
2. Observe the frame after the scroll settles.
3. Compare the same layout with the WebView items replaced by a plain first-party `UiKitView` (trivial colored `UIView` factory registered in `AppDelegate`).

Full runnable `main.dart` at the bottom (uses **only first-party packages**: `webview_flutter`).

## Expected results

All ListView items below the WebView card and the sheet's footer Container remain visible; the WebView composes into the frame like any other layer.

## Actual results

Everything Flutter paints **after** the WebView in the frame is dropped:

- ListView items below the WebView card: missing
- the sheet's footer `Container` (painted after the list): missing
- intermittently the entire frame renders blank for a frame ("header invisible" reports from users)

The WebView itself renders correctly inside its card. The artifact is stable (not just during scroll animation).

**The same layout with a plain `UIView`-backed `UiKitView` composes correctly on the identical Flutter build** — items and footer all visible. The trigger is the WKWebView content specifically, not platform views in general.

Comparison frames (attached):

| Variant | Flutter | Frame |
|---|---|---|
| `webview_flutter` (WKWebView, first-party) | 3.47.5 | broken — items below + footer dropped (`ev_3475_webview_flutter_broken.png`) |
| third-party WKWebView plugin (zikzak_inappwebview) | 3.47.5 | broken — identical (`ev_3475_zikzak_broken.png`) |
| plain `UIView` via `UiKitView` | 3.47.5 | correct — everything composited (`ev_3475_plain_uiview_ok.png`) |
| any of the above | 3.44.x | correct (no artifact) |

Also NOT contributing (all tested, all unchanged): Impeller disabled, `Opacity(0.99)` snapshot wrap, `RepaintBoundary`, native `clipsToBounds`, `PlatformViewLink` vs `UiKitView` construction.

## Code sample

```dart
// pubspec: webview_flutter: ^4.14.1  (first-party)
// Page body: WebViewWidget(controller: c) inside a full-bleed Container.
// Sheet: showModalBottomSheet(isScrollControlled: true, useSafeArea: true) with:
Column(children: [
  Expanded(child: ListView.builder(
    controller: _scrollController,
    itemCount: 100,
    itemBuilder: (context, index) {
      const cycleLength = 11;
      if (index % cycleLength == cycleLength - 1) {
        return SizedBox(width: 200, height: 340, child: WebViewWidget(controller: c));
      }
      return ListTile(title: Text('Item #$index'));
    },
  )),
  Container(color: Colors.teal, height: 60, child: Text('Footer')),
])
// After first frame: _scrollController.animateTo(640, ...) so a WebView item
// is mid-viewport, then observe the settled frame.
```

## Environment

- Flutter stable **3.47.5** (framework `6a19cca564`, engine `af7e796e16`), also reproduces on 3.47.1/3.47.2/3.47.4
- iOS 18.x simulator (iPhone 16e / iPhone 17); reported by app users on device as well
- macOS 15.7 host, Xcode 26

## Notes / prior art

- 3.44.x stable renders the same layouts correctly; the regression window is the 3.47 line.
- Possibly related: #191771 (non-rect clip breaks platform-view effects and overlay composition in 3.47.1; closed pending a first-party repro). Our case has **no non-rect clip** — plain rect anti-alias clip — and reproduces with zero third-party code beyond `webview_flutter`, so it may be the same slicing regression with a broader trigger or a sibling. If #182662's revert (#190003) fixed a form of this on main, this repro is a ready-made regression test for it.
- Symptom matches community reports on WKWebView-based plugins (e.g. flutter_inappwebview#326/#328/#331 family): content painted after the platform view disappears under modal + scrolled-list setups.

---
