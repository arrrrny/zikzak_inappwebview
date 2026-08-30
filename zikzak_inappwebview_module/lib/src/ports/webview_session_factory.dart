import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import '../models/pool_session.dart';

/// Port for creating and managing webview sessions.
///
/// Implementations acquire [HeadlessInAppWebView] instances and wrap
/// them as [PoolSession] handles. The module defines this interface;
/// the plugin core (or an adapter in the module) provides the concrete
/// implementation.
///
/// Spec: 004 (FR-001), 007 (FR-001/FR-005)
abstract class WebViewSessionFactory {
  /// Acquires a webview session for the given [sessionId] and [domainHint].
  Future<PoolSession> acquire({
    required String sessionId,
    String? domainHint,
    InAppWebViewSettings? settings,
  });

  /// Releases the session identified by [sessionId] back to the pool.
  Future<void> release(String sessionId);

  /// Disposes all sessions (active and idle).
  Future<void> disposeAll();

  /// Returns the current number of live (active + idle) instances.
  int get liveCount;

  /// Returns a snapshot of all active sessions.
  List<PoolSessionInfo> sessions();
}
