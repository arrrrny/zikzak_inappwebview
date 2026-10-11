/// KeepAlive-aware disposal lifecycle used by the guarded dispose paths
/// (bug #295, keepalive-dispose-release-gap).
///
/// A single `bool _disposed` cannot distinguish three states: not disposed,
/// disposed with `isKeepAlive: true` (native view retained), and fully
/// released. Because "keepAlive-held" also set `_disposed = true`, any
/// subsequent plain `dispose()` — the one that must fully release the
/// retained native view (spec 013 FR-007) — was swallowed as a duplicate
/// no-op by the idempotency guard (FR-008).
///
/// The guarded wrappers ([HeadlessInAppWebView], [InAppWebViewController],
/// [InAppLocalhostServer]) track this lifecycle instead and block only
/// *identical* repeats:
///
/// | from            | dispose(false)      | dispose(true)       |
/// | --------------- | ------------------- | ------------------- |
/// | notDisposed     | forwards, released  | forwards, keepAliveHeld |
/// | keepAliveHeld   | forwards, released  | no-op               |
/// | released        | no-op               | no-op               |
///
/// This is an implementation detail of `package:zikzak_inappwebview` and is
/// not part of its public API.
enum DisposeLifecycle {
  /// No [dispose] call has been made yet.
  notDisposed,

  /// Disposed with `isKeepAlive: true`: Dart-side ownership released while
  /// the native view is retained. A subsequent plain `dispose()` must fully
  /// release it (FR-007).
  keepAliveHeld,

  /// Fully released. Any further [dispose] call is a terminal no-op (FR-008).
  released,
}
