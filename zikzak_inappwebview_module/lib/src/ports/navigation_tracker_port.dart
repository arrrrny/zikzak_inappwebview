/// A single URL cycle entry tracked during navigation.
///
/// Spec: 004
class NavigationEntry {
  final String url;
  final DateTime timestamp;
  final String? title;
  final bool isRedirect;

  const NavigationEntry({
    required this.url,
    required this.timestamp,
    this.title,
    this.isRedirect = false,
  });
}

/// Port for tracking URL navigation cycles.
///
/// Records the sequence of URLs visited during a webview session,
/// detecting cycles (same URL revisited) that may indicate
/// redirect loops or SPA navigation.
///
/// Spec: 004 (FR-001)
abstract class NavigationTrackerPort {
  /// Records a navigation to [url].
  void recordNavigation(String url, {String? title});

  /// Returns all recorded navigation entries for the current session.
  List<NavigationEntry> get entries;

  /// Returns true if a navigation cycle has been detected.
  bool get hasCycle;

  /// Clears all recorded entries.
  void reset();
}
