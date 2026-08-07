///What caused a [UrlCycleEntry] to be recorded.
enum UrlCycleTrigger {
  ///From the `onLoadStart` widget callback.
  loadStart,

  ///From the `onUpdateVisitedHistory` widget callback.
  visitedHistory,

  ///From the injected script (history API / popstate / hashchange / pageshow).
  jsHistory,

  ///From a server redirect callback (iOS/macOS).
  redirect,

  ///From a `shouldOverrideUrlLoading` observation.
  userOverride;

  ///Parses a [UrlCycleTrigger] from its [name].
  static UrlCycleTrigger fromName(String name) =>
      UrlCycleTrigger.values.firstWhere(
        (e) => e.name == name,
        orElse: () => UrlCycleTrigger.jsHistory,
      );
}

///A single URL change observed by the `NavigationTracker`.
class UrlCycleEntry {
  ///Full URL (including query parameters).
  final String url;

  ///When the change was observed, in milliseconds since epoch.
  final int timestamp;

  ///What triggered the observation.
  final UrlCycleTrigger trigger;

  ///Whether the change happened in the main frame.
  final bool isMainFrame;

  UrlCycleEntry({
    required this.url,
    required this.timestamp,
    required this.trigger,
    this.isMainFrame = true,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'timestamp': timestamp,
    'trigger': trigger.name,
    'isMainFrame': isMainFrame,
  };

  factory UrlCycleEntry.fromJson(Map<String, dynamic> json) => UrlCycleEntry(
    url: json['url'] as String,
    timestamp: json['timestamp'] as int,
    trigger: UrlCycleTrigger.fromName(json['trigger'] as String? ?? ''),
    isMainFrame: json['isMainFrame'] as bool? ?? true,
  );

  @override
  String toString() =>
      'UrlCycleEntry{url: $url, timestamp: $timestamp, trigger: $trigger, isMainFrame: $isMainFrame}';
}
