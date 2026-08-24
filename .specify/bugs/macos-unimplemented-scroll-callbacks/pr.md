# Bug Fix PR: macOS dispatches scroll callbacks instead of throwing UnimplementedError

- **Slug**: macos-unimplemented-scroll-callbacks
- **Opened**: 2026-08-24
- **PR**: 269
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/pull/269
- **Branch**: fix/macos-unimplemented-scroll-callbacks
- **Issue**: n/a (local bug; no linked GitHub issue)

Adds the three missing `case` arms (`onScrollChanged`, `onContentSizeChanged`,
`onOverScrolled`) to `MacOSInAppWebViewController.handleMethod` so the native
macOS scroll events are forwarded to the registered `webviewParams` callbacks
instead of hitting `default:` and throwing `UnimplementedError`. Squash-merged
into `master` as `443fc68b`; `flutter test` (macos package) → 41/41 passing.
