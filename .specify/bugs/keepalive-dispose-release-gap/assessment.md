# Bug Assessment: keepAlive dispose does not release native view on subsequent plain dispose

- **Slug**: keepalive-dispose-release-gap
- **Created**: 2026-08-29
- **Source**: pasted text (design/implementation conflict surfaced during spec 013 TDD; relates to spec 013 FR-007 vs FR-008, behaviors U5/A8)
- **Verdict**: valid
- **Severity**: medium

## Report (verbatim or summarized)

During the TDD run for spec 013 (standardize-dispose-patterns), behaviors **U5** and **A8** could not be driven to green without contradicting an already-implemented and already-tested behavior (**U3/U6**, FR-008 idempotent double-dispose). The conflict was recorded in `specs/013-standardize-dispose-patterns/tdd/test-list.md` as BLOCKED, not weakened. This assessment promotes that tracked gap into a filed bug so the resolution is owned as work rather than left as a silent contradiction.

## Symptom

When a `keepAlive`-backed wrapper is disposed with `dispose(isKeepAlive: true)` to retain the native view, a later `dispose()` (default `isKeepAlive: false`) is expected to fully release the native view (FR-007, US3-AC2). In the guarded dispose paths, the second call is swallowed by the idempotency guard and never reaches the platform, so the retained native view is never released until process exit.

## Reproduction

1. Call `dispose(isKeepAlive: true)` on a `HeadlessInAppWebView` (or `InAppLocalhostServer`) to retain the native resource.
2. Call `dispose()` with the default `isKeepAlive: false` to release it.
3. Observe that the second call returns early (no platform call) — the native view is never released.

This is reproducible by unit reasoning on the guard; no device is required for the headless path.

## Suspected Code Paths

- `zikzak_inappwebview/lib/src/in_app_webview/headless_in_app_webview.dart:665-671` — `Future<void> dispose({bool isKeepAlive = false}) async { if (_disposed) return; _disposed = true; await platform.dispose(isKeepAlive: isKeepAlive); }`. The `if (_disposed) return;` guard blocks EVERY second dispose, including the `isKeepAlive: false` release that should follow a `keepAlive: true` dispose.
- `zikzak_inappwebview/lib/src/in_app_localhost_server.dart:65-70` — same single-boolean `_disposed` guard pattern swallows the second `dispose()`.

Note: `in_app_webview_controller.dart:568-569` and `in_app_webview.dart:611-612` forward `isKeepAlive` directly to the platform with **no** `_disposed` guard. That is precisely why U9 (controller) and U12 (widget) are DONE while U5 (Headless) and A8 are BLOCKED: the release path exists only where the wrapper forwards without a guard. The bug is isolated to the guarded dispose paths above.

## Root Cause Hypothesis

The disposal guard is keyed on a single boolean `_disposed`, which cannot distinguish three states: not-disposed, keepAlive-held, and fully-released. Because "keepAlive-held" still sets `_disposed = true`, any subsequent `dispose()` — including the plain release FR-007 requires — is treated as a duplicate no-op and never forwarded to the platform. Confidence: **high**.

## Proposed Remediation

**Preferred**: Make the guard keepAlive-aware by tracking a three-state lifecycle (`notDisposed` / `keepAliveHeld` / `released`). Block only identical repeats (released→released no-op, keepAliveHeld→keepAliveHeld repeat no-op) but allow the `keepAliveHeld → released` transition via a plain `dispose()`. This satisfies both FR-007 (release via second dispose) and FR-008 (idempotent double-dispose).

**Alternatives**:
- Drop FR-007's "release via a second plain dispose" wording entirely and instead expose a dedicated `releaseKeepAlive()` method. Trade-off: this is a new public API surface and a spec change; the keepAlive release contract becomes explicit rather than implicit in `dispose()` overloads.

**Files likely to change**:
- `zikzak_inappwebview/lib/src/in_app_webview/headless_in_app_webview.dart`
- `zikzak_inappwebview/lib/src/in_app_localhost_server.dart`

**Tests to add or update**:
- U5: `dispose(isKeepAlive: true)` then `dispose(isKeepAlive: false)` calls `platform.dispose(isKeepAlive: false)` exactly once and fully releases (currently BLOCKED).
- A8: acceptance that a keep-alive controller is fully released by a subsequent plain dispose (currently BLOCKED).

## Risks & Considerations

- Removing or restructuring the guard risks regressing U3/U6 (FR-008 idempotency) and A2/A3 — any fix must keep double-dispose a no-op.
- The controller and widget paths forward without a guard, so they must be checked for consistent keepAlive behavior after the change (avoid a divergence where headless and controller behave differently).
- This is a functional leak, not a crash or data loss, and only affects code that actually uses `keepAlive` retention — hence severity medium.

## Open Questions

- [NEEDS CLARIFICATION: none blocking] — resolution is a design choice (keepAlive-aware guard vs new `releaseKeepAlive()` API), not missing information.
