import 'dart:async';

/// A single captured network event, produced by the capture source
/// after distillation and redaction.
///
/// This is the module-level representation; it maps to the `Sighting`
/// contract from dart_web_scraper#79. The module depends on this
/// interface, not on the scraper package directly.
///
/// Spec: 004 (FR-005, FR-007, FR-008), 008
class CaptureEvent {
  final String url;
  final String method;
  final Map<String, String> requestHeaders;
  final Map<String, String> responseHeaders;
  final int statusCode;
  final String? body;
  final DateTime timestamp;
  final String resourceType;

  const CaptureEvent({
    required this.url,
    required this.method,
    required this.requestHeaders,
    required this.responseHeaders,
    required this.statusCode,
    this.body,
    required this.timestamp,
    required this.resourceType,
  });
}

/// Configuration for a capture session.
///
/// Spec: 004 (FR-005), 009 (FR-014)
class CaptureConfig {
  /// Maximum number of events to capture (0 = unlimited).
  final int maxEvents;

  /// Maximum payload size per event body in bytes.
  final int maxPayloadSize;

  /// Whether to capture binary content.
  final bool captureBinary;

  /// A predicate that, when true, stops capture early.
  final Future<bool> Function(CaptureEvent event)? stopOn;

  /// Content-type filters (only capture matching types).
  final List<String>? filterContentTypes;

  /// URL pattern filters (only capture matching URLs).
  final List<Pattern>? filterUrlPatterns;

  const CaptureConfig({
    this.maxEvents = 500,
    this.maxPayloadSize = 51200, // 50 KB
    this.captureBinary = false,
    this.stopOn,
    this.filterContentTypes,
    this.filterUrlPatterns,
  });
}

/// Result of a capture session, including any partial data from
/// a salvage flush (cancellation).
///
/// Spec: 004 (FR-005), 005 (FR-009)
class CaptureResult {
  final List<CaptureEvent> events;
  final bool wasCancelled;
  final String? cancelReason;
  final int budgetRemaining;

  const CaptureResult({
    required this.events,
    this.wasCancelled = false,
    this.cancelReason,
    this.budgetRemaining = 0,
  });
}

/// Port for network capture with at-source redaction and distiller slot.
///
/// The capture source provides mission-grade intercept semantics on top
/// of raw plugin capture events: streaming emission, budget caps, early-
/// stop, salvage-on-teardown, and at-source secret redaction.
///
/// Spec: 004 (FR-001, FR-005, FR-007, FR-008)
abstract class CaptureSource {
  /// Starts capturing network events for a session.
  ///
  /// Returns a stream of [CaptureEvent]s as they are captured and
  /// distilled. The stream completes when [stop] is called, the budget
  /// is exhausted, or [stopOn] returns true.
  ///
  /// The [onSalvage] callback is invoked if the capture is cancelled
  /// mid-flight, receiving any buffered events that haven't been
  /// emitted yet.
  Stream<CaptureEvent> start({
    required String sessionId,
    CaptureConfig config = const CaptureConfig(),
  });

  /// Stops capture for a session, flushing remaining buffered events.
  ///
  /// Returns a [CaptureResult] with all captured events (including
  /// any salvaged from a cancellation).
  Future<CaptureResult> stop(String sessionId);

  /// Returns the current capture budget status for a session.
  int budgetRemaining(String sessionId);
}
