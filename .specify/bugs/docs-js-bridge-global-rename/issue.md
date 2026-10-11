# Bug Issue: Docs: JS bridge global object renamed to `window.zikzak_inappwebview`

- **Slug**: docs-js-bridge-global-rename
- **Fetched**: 2026-08-24
- **Issue**: 258
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/258
- **State**: open
- **Severity**: unknown
- **Author**: appa-gomi
- **Labels**: none

## Body

The README states that "The API is nearly identical" when migrating from
`flutter_inappwebview` to `zikzak_inappwebview`. Based on that, I assumed
the injected JavaScript bridge object on the WebView side would still be
`window.flutter_inappwebview`, since that name is unchanged in upstream
`flutter_inappwebview`.

After migrating, calls like:

```js
window.flutter_inappwebview.callHandler('myHandler', ...args);
```

started throwing:
Uncaught TypeError: Cannot read properties of undefined (reading 'callHandler')

After debugging, I found the actual injected bridge object in this fork is
`window.zikzak_inappwebview` instead of `window.flutter_inappwebview`.
Once I updated my JS to use `window.zikzak_inappwebview.callHandler(...)`,
everything worked as expected.

The `flutterInAppWebViewPlatformReady` event name itself is unchanged and
fires correctly.

### Suggestion

Could this be called out explicitly in the README / migration docs (and
ideally in the JS communication guide)? Something like:

> Note: the injected JavaScript bridge global is `window.zikzak_inappwebview`
> (not `window.flutter_inappwebview`). The `flutterInAppWebViewPlatformReady`
> event name is unchanged.

This would save other people migrating from `flutter_inappwebview` from
hitting the same silent breakage, since the error message gives no hint
that the bridge object name changed.

### Environment

- `zikzak_inappwebview` version: 5.0.0
- Flutter version: 3.47.1
- Platform: Android (also relevant on iOS if reproduced there)

### Minimal repro

```html
<script>
  window.addEventListener('flutterInAppWebViewPlatformReady', function () {
    // Works:
    window.zikzak_inappwebview.callHandler('myHandler');

    // Throws "Cannot read properties of undefined (reading 'callHandler')":
    // window.flutter_inappwebview.callHandler('myHandler');
  });
</script>
```

Happy to open a PR against the README if that's preferred — just wanted to
flag this first in case there's a reason the docs still reference the old
name.

## Comments

None.
