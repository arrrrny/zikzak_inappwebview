# Cycle Log: Per-profile and global proxy support (zuraffa_browser)

Append only. Newest last. Every entry's `red` block is the evidence that the
test existed and failed before the implementation.

## Baseline

- suite: `flutter test` in `zikzak_inappwebview` -> **+240 -2** (240 passed)
- suite: `flutter test` in `zikzak_inappwebview_platform_interface` -> **+305 -1** (305 passed)
- suite: `flutter test` in `zikzak_inappwebview_module` -> **+0 -1** (compile load error)
- commit: `a841cee2`
- recorded: cycle 0, before any feature change

### Red baseline details

The three baseline reds predate this feature and touch files this feature
never modifies:

1. `zikzak_inappwebview/test/domain_controllers_behavioral_test.dart` —
   "NavigationController delegates to parent (U10-U28) U14 loadSimulatedRequest
   delegates to parent identically" (pre-existing).
2. `zikzak_inappwebview/test/in_app_webview_dispose_test.dart` —
   "InAppWebViewController / InAppWebView dispose forwarding (spec 013) U9: a
   later dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards
   false and fully releases" (pre-existing).
3. `zikzak_inappwebview_platform_interface/test/types/final_gap_entities_test.dart`
   — "PDFConfiguration wire: rect as nested map" (pre-existing).
4. `zikzak_inappwebview_module` — compile load error in the pub-cache copy of
   hosted `zuraffa 6.0.0` (`src/extensions/future_extensions.dart` missing from
   the downloaded archive). Third-party cache corruption; the module package is
   not part of this feature's verify scope (umbrella + platform_interface are).

The loop for this feature runs inside the new `zuraffa_browser` package only,
whose own suite starts empty (trivially green). Target for this feature:
**NO NEW failures** in umbrella/platform_interface vs the counts above.

## Cycle T001 — Global proxy API (red → green)

### Red

- command: `flutter test test/global_proxy_test.dart` and
  `flutter test test/proxy_config_test.dart` (cwd `zuraffa_browser`)
- commit-under-red: tests committed before any implementation exists.
- observed output (excerpt):

```text
test/global_proxy_test.dart:9:40: Error: Type 'ProxyApplier' not found.
test/global_proxy_test.dart:10:20: Error: 'ResolvedProxy' isn't a type.
test/global_proxy_test.dart:25:23: Error: Method not found: 'ProxyConfig'.
test/global_proxy_test.dart:28:11: Error: Undefined name 'ProxyType'.
test/global_proxy_test.dart:35:29: Error: Undefined name 'Browser'.
test/global_proxy_test.dart:36:16: Error: Method not found: 'InMemoryProxyConfigStore'.
Compilation failed for testPath=.../test/global_proxy_test.dart
Compilation failed for testPath=.../test/proxy_config_test.dart
```

Both files fail to load: the whole API surface under test (ProxyType,
ProxyConfig, ProxyConfigRecord, stores, vault, ProxyApplier, ResolvedProxy,
Browser) does not exist yet.
