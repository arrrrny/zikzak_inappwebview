import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// A managed webview session handle, created by [WebViewPool.acquire].
///
/// Wraps a [HeadlessInAppWebView] instance with session metadata.
/// The pool owns the underlying instance; consumers MUST call
/// [WebViewPool.release] or [WebViewPool.disposeAll] when done.
///
/// Spec: 007
class PoolSession {
  /// The session identifier (caller-supplied, opaque string).
  final String sessionId;

  /// The domain hint supplied at acquisition time.
  final String? domainHint;

  /// The effective top-level domain + 1 used for affinity.
  final String? etldPlusOne;

  /// The underlying headless webview instance.
  final HeadlessInAppWebView webview;

  /// When this session was acquired.
  final DateTime acquiredAt;

  /// When this session was last released (null if still active).
  DateTime? releasedAt;

  /// The [InAppWebViewSettings] composed at acquisition time.
  final InAppWebViewSettings settings;

  PoolSession({
    required this.sessionId,
    this.domainHint,
    this.etldPlusOne,
    required this.webview,
    InAppWebViewSettings? settings,
  })  : settings = settings ?? InAppWebViewSettings(),
        acquiredAt = DateTime.now();

  /// Whether this session is currently active (not released).
  bool get isActive => releasedAt == null;

  /// The controller for the underlying webview.
  InAppWebViewController? get controller => webview.webViewController;
}

/// Introspection snapshot for a pool session.
///
/// Used by [WebViewSessionFactory.sessions()] to report pool state
/// without exposing the underlying webview instances.
///
/// Spec: 007 (FR-006)
class PoolSessionInfo {
  final String sessionId;
  final String? domainHint;
  final String? etldPlusOne;
  final bool isActive;
  final DateTime acquiredAt;

  const PoolSessionInfo({
    required this.sessionId,
    this.domainHint,
    this.etldPlusOne,
    required this.isActive,
    required this.acquiredAt,
  });
}
