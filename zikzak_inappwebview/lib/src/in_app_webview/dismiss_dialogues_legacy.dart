import 'dart:async';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview_controller.dart';

/// Default delay between dismissal attempts in [runLegacyDismissDialogues].
const Duration legacyDismissRetryDelay = Duration(milliseconds: 800);

/// The exact legacy brute-force dismissal script injected on `onLoadStop`
/// (by `InAppWebView` and `HeadlessInAppWebView`) when `dismissDialogues` is
/// enabled.
///
/// It removes every element whose computed `position` is `fixed` or `sticky`
/// from the top-level document, resets `overflow`/`margin` on the document
/// element and on `body`, and returns the number of removed elements.
///
/// Kept verbatim (and public) so its behavior can be characterized and cannot
/// drift silently. The script purposefully tolerates per-element errors.
String legacyDismissDialoguesJs() => r'''
(function() {
  var removed = 0;
  var all = document.querySelectorAll('*');
  all.forEach(function(el) {
    try {
      var style = window.getComputedStyle(el);
      if (style.position === 'fixed' || style.position === 'sticky') {
        el.remove();
        removed++;
      }
    } catch(e) {}
  });
  document.documentElement.style.overflow = '';
  document.documentElement.style.margin = '';
  document.body.style.overflow = '';
  document.body.style.margin = '';
  return removed;
})();
''';

/// Whether the legacy dismissal script should run for [settings].
///
/// Mirrors the inline guard in [InAppWebView] `onLoadStop`: it runs only when
/// `dismissDialogues` is explicitly true and is a no-op otherwise.
bool shouldDismissDialogues(InAppWebViewSettings? settings) =>
    settings?.dismissDialogues ?? false;

/// Runs the legacy dismissal by injecting [legacyDismissDialoguesJs] up to three
/// times, waiting [retryDelay] between attempts and after the first two.
///
/// Any error raised by the platform is swallowed so the web view is never left
/// in a broken state. The returned future is intentionally fire-and-forget at
/// the call site, matching the original behavior.
Future<void> runLegacyDismissDialogues(
  InAppWebViewController controller, {
  Duration retryDelay = legacyDismissRetryDelay,
}) async {
  try {
    for (var i = 0; i < 3; i++) {
      await controller.evaluateJavascript(source: legacyDismissDialoguesJs());
      if (i < 2) {
        await Future.delayed(retryDelay);
      }
    }
  } catch (_) {}
}
