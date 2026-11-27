# Configurable headless live-instance cap

Tracking: [#474](https://github.com/arrrrny/zikzak_inappwebview/issues/474).

## User story

As an application using multiple headless WebViews, I need to raise the
process-wide live-instance ceiling before the first headless view starts, while
keeping Dart and native enforcement synchronized and preserving the memory
safety defaults.

## Requirements

1. Expose a process-wide `HeadlessInAppWebView.maxLiveWebViews` getter and
   setter. The setter accepts integers greater than or equal to one and throws a
   clear state error once any headless view is live.
2. Preserve native defaults of three on iOS and Android, five on macOS, and the
   existing Dart default of eight elsewhere until the setter is called.
3. Propagate the configured value over the existing headless method channel to
   the iOS, Android, and macOS managers. A `run()` issued immediately after the
   setter must observe the new native ceiling.
4. Make `HeadlessWebViewRegistryConfig.platformDefaults()` and the module-tier
   `WebViewPoolConfig.platformDefaults()` read the configured process-wide cap.
5. Preserve the existing lifecycle and LRU safety behavior: iOS and Android
   recycle the least-recently-used live instance when a create reaches the cap;
   a create still fails clearly if no slot can be released. macOS retains its
   existing full-cap refusal behavior.
6. Document that every live headless instance owns a renderer or WebContent
   process, that raising the cap can cause out-of-memory termination on
   low-memory devices, and that the cap is process-wide rather than per view.
7. Keep the iOS, Android, and macOS headless lifecycle contract suites green and
   add source-contract coverage for the native setter and propagated ceiling.

## Non-goals

- No per-view cap and no cap changes while a headless view is live.
- No new cap policy for web, Windows, or Linux native implementations.
- No change to registry acquisition, idle-TTL, or module-pool eviction policy.

## Acceptance tests

- Dart tests cover default selection, validation, propagation ordering, and the
  live-instance mutation guard.
- Module tests cover a pool default created after the global cap changes.
- Native source-contract tests cover mutable iOS/Android/macOS ceilings, setter
  method handling, validation, and cap reporting.
- The existing headless lifecycle contract tests continue to pass on all three
  native platform packages.
