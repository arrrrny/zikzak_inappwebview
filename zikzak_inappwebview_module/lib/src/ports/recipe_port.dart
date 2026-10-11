import 'dart:async';

/// A single recorded step in a recipe.
class RecipeStep {
  final String type;
  final String url;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  const RecipeStep({
    required this.type,
    required this.url,
    this.data,
    required this.timestamp,
  });
}

/// A recorded recipe (user interaction flow).
class Recipe {
  final String name;
  final List<RecipeStep> steps;
  final DateTime recordedAt;
  final String? domainHint;

  const Recipe({
    required this.name,
    required this.steps,
    required this.recordedAt,
    this.domainHint,
  });
}

/// Progress report during recipe replay.
class ReplayStatus {
  final int currentStep;
  final int totalSteps;
  final String? currentUrl;
  final bool isComplete;
  final String? error;

  const ReplayStatus({
    required this.currentStep,
    required this.totalSteps,
    this.currentUrl,
    this.isComplete = false,
    this.error,
  });
}

/// Port for recording and replaying user interaction flows (recipes).
///
/// Recording requires explicit consent. Replay executes the captured
/// flow headlessly. Recorded traces never contain user credentials
/// (redaction is always applied, regardless of consent state).
///
/// Spec: 004 (FR-001), 008, 009 (FR-012, FR-013)
abstract class RecipePort {
  /// Starts recording a recipe with the given [name].
  ///
  /// [consentGranted] must be true for recording to begin.
  /// Throws if consent is not granted.
  Future<void> startRecording({
    required String name,
    required bool consentGranted,
  });

  /// Stops the current recording and returns the captured recipe.
  Future<Recipe> stopRecording();

  /// Replays a [recipe], streaming [ReplayStatus] updates.
  ///
  /// Returns the final replay result. Credential-bearing steps
  /// require explicit confirmation (risk annotation).
  Stream<ReplayStatus> replay(Recipe recipe);

  /// Whether a recording is currently in progress.
  bool get isRecording;
}
