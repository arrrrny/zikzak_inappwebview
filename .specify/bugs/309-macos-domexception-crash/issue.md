# Bug Issue: macOS crash — WebKit deserialization of DOMException in script message handler

- **Slug**: 309-macos-domexception-crash
- **Fetched**: 2026-09-04T21:45:00
- **Issue**: 309
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/309
- **State**: open
- **Severity**: critical
- **Author**: (see GitHub issue)
- **Labels**: none

## Body

`zuraffa_browser` crashes intermittently on macOS with `EXC_BAD_ACCESS (SIGSEGV)`
inside WebKit's `CloneDeserializer::readDOMException`.

The crash happens in `ScriptMessageHandlerDelegate::didPostMessage` when a page's
JavaScript sends a `DOMException` object through the zikzak bridge (e.g. produced
by permission APIs, notifications, service workers, or fetch errors). The
`didReceiveScriptMessage` handler does not defensively deserialize the payload —
`DOMException` and other non-cloneable objects crash the host process.

Stack trace:

```
WebCore::CloneDeserializer::readDOMException
  → SerializedScriptValue::deserialize
  → ScriptMessageHandlerDelegate::didPostMessage
```

Repro: use any zikzak webview in a macOS Flutter app → navigate to a page whose JS
creates a `DOMException` and passes it through the bridge → app crashes with SIGSEGV.

Expected: the `didReceiveScriptMessage` handler should defensively deserialize the
payload — `DOMException` and other non-cloneable objects should be caught and
reported as a normal string error rather than crashing.

## Comments

None.
