## Symptom

When a `keepAlive`-backed wrapper is disposed with `dispose(isKeepAlive: true)` to retain the native view, a later `dispose()` (default `isKeepAlive: false`) is expected to fully release the native view (FR-007, US3-AC2). In the guarded dispose paths, the second call is swallowed by the idempotency guard and never reaches the platform, so the retained native view is never released until process exit.

## Reproduction

1. Call `dispose(isKeepAlive: true)` on a `HeadlessInAppWebView` (or `InAppLocalhostServer`) to retain the native resource.
2. Call `dispose()` with the default `isKeepAlive: false` to release it.
3. Observe that the second call returns early (no platform call) — the native view is never released.

Reproducible by unit reasoning on the guard; no device required for the headless path.

## Suspected Code Paths

- `zikzak_inappwebview/lib/src/in_app_webview/headless_in_app_webview.dart:665-671` — `if (_disposed) return; _disposed = true; await platform.dispose(isKeepAlive: isKeepAlive);` blocks every second dispose, including the `isKeepAlive: false` release.
- `zikzak_inappwebview/lib/src/in_app_localhost_server.dart:65-70` — same single-boolean `_disposed` guard swallows the second `dispose()`.

Note: `in_app_webview_controller.dart:568-569` and `in_app_webview.dart:611-612` forward `isKeepAlive` directly with no guard — which is why U9 (controller) and U12 (widget) pass while U5 (Headless) and A8 are blocked. The bug is isolated to the guarded dispose paths.

## Root Cause Hypothesis (confidence: high)

The disposal guard is keyed on a single boolean `_disposed`, which cannot distinguish not-disposed / keepAlive-held / fully-released. Because "keepAlive-held" still sets `_disposed = true`, any subsequent `dispose()` is treated as a duplicate no-op and never forwarded to the platform.

## Severity

medium — functional native-view leak for the keepAlive use case; not a crash or data loss, only affects code that uses keepAlive retention.

## Proposed Remediation

Make the guard keepAlive-aware with a three-state lifecycle (`notDisposed` / `keepAliveHeld` / `released`): block only identical repeats but allow the `keepAliveHeld → released` transition via a plain `dispose()`. Alternative: drop FR-007's "release via second plain dispose" wording and expose a dedicated `releaseKeepAlive()` method (new public API).

Local assessment: `.specify/bugs/keepalive-dispose-release-gap/assessment.md`
