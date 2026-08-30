import 'dart:async';
import '../ports/capture_source.dart';

/// Stub implementation of [CaptureSource].
///
/// Full implementation requires the plugin adapter to bridge raw
/// capture events from [InAppWebViewController] into the module's
/// [CaptureEvent] stream.
///
/// Spec: 004 (FR-001, FR-002, FR-005)
class CaptureService implements CaptureSource {
  final Map<String, StreamController<CaptureEvent>> _controllers = {};
  final Map<String, int> _budgets = {};
  final Map<String, bool> _active = {};

  @override
  Stream<CaptureEvent> start({
    required String sessionId,
    CaptureConfig config = const CaptureConfig(),
  }) {
    if (_active[sessionId] == true) {
      throw StateError('Capture already active for session $sessionId');
    }
    _active[sessionId] = true;
    // Encode "unlimited" (maxEvents == 0) as -1 so a zero budget can be
    // distinguished from an exhausted budget at injection time.
    _budgets[sessionId] = config.maxEvents > 0 ? config.maxEvents : -1;
    final controller = StreamController<CaptureEvent>.broadcast();
    _controllers[sessionId] = controller;
    return controller.stream;
  }

  @override
  Future<CaptureResult> stop(String sessionId) async {
    final controller = _controllers.remove(sessionId);
    _active[sessionId] = false;
    if (controller != null && !controller.isClosed) {
      await controller.close();
    }
    return CaptureResult(
      events: const [],
      budgetRemaining: _budgets.remove(sessionId) ?? 0,
    );
  }

  @override
  int budgetRemaining(String sessionId) => _budgets[sessionId] ?? 0;

  /// Injects a captured event into the active session's stream.
  ///
  /// Called by the plugin adapter when raw capture events arrive.
  /// Returns false if the budget is exhausted or the session is not active.
  bool injectEvent(String sessionId, CaptureEvent event) {
    if (_active[sessionId] != true) return false;
    final budget = _budgets[sessionId] ?? 0;
    // Negative budget means "unlimited" (maxEvents == 0): always emit.
    if (budget < 0) {
      _controllers[sessionId]?.add(event);
      return true;
    }
    // Bounded budget: stop emitting once exhausted so maxEvents is enforced.
    if (budget <= 0) return false;
    _budgets[sessionId] = budget - 1;
    _controllers[sessionId]?.add(event);
    return true;
  }
}
