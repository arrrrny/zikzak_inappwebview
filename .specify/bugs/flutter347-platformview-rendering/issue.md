# Bug Issue: Flutter version upgrade from 3.44.x to 3.47.2 causes rendering layer confusion

- **Slug**: flutter347-platformview-rendering
- **Fetched**: 2026-09-25
- **Issue**: 331
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/331
- **State**: open
- **Severity**: unknown (visual corruption; no crash)
- **Author**: taosimple (Tao)
- **Labels**: (none)

## Body

Key steps to reproduce: overlaid WebView + Bottom Sheet + WebView in ListView
(flutter 3.47.2, zikzak_inappwebview 6.0.0, iPhone 16 Pro simulator).

Symptoms (screenshots in issue): "Normal" (WebView removed → fine),
"Header invisible", "Bottom invisible". Removing the InAppWebView returns the
UI to normal. Full repro code provided in the issue (Scaffold with a
full-screen InAppWebView body; a modal bottom sheet whose ListView embeds an
InAppWebView every 11 items).

Related: #293 (same reporter; same Flutter delta; closed with "Try 5.2.0, it is
working fine for me" — no root cause).

## Comments

- **taosimple**: links #293
- **mapletaotao**: "@arrrrny I am facing a similar issue. Is there any update on this problem?"
