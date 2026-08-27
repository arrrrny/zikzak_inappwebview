import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Result of a dialogue dismissal attempt.
///
/// Spec: 004, 009 (FR-011)
class DismissResult {
  final bool dismissed;
  final String? selector;
  final String? error;

  const DismissResult({
    required this.dismissed,
    this.selector,
    this.error,
  });
}

/// Port for dismissing consent banners and cookie overlays.
///
/// Spec: 004 (FR-001)
abstract class DialogueDismissPort {
  /// Attempts to dismiss consent/dialogue overlays on the current page.
  ///
  /// [controller] is the webview controller for the active session.
  /// Returns a [DismissResult] indicating whether a dialogue was found
  /// and dismissed.
  Future<DismissResult> dismiss(InAppWebViewController controller);
}
