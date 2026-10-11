import '../models/cassette.dart';

/// Unmatched-request policy during cassette replay.
///
/// Spec: 008 (FR-007)
enum UnmatchedPolicy {
  /// Fail the replay with a clear error (default).
  hard,

  /// Log a warning and return an empty response.
  soft,
}

/// Port for VCR (record/replay) wrapping a webview session.
///
/// In record mode, captures navigations, served HTML, network events,
/// and cookie snapshots into a cassette. In replay mode, serves
/// cassette content without live network.
///
/// Spec: 004 (FR-006), 008 (FR-001–FR-011)
abstract class CassetteEngine {
  /// The current mode.
  CassetteMode get mode;

  /// Loads a cassette for replay.
  ///
  /// Throws if the cassette format version is unsupported.
  Future<void> loadCassette(Cassette cassette);

  /// Saves the current recording as a cassette.
  ///
  /// Applies redaction before writing. The cassette is serialized
  /// as gzipped JSON with a declared format version.
  Future<Cassette> saveCassette();

  /// The policy for unmatched requests during replay.
  UnmatchedPolicy get unmatchedPolicy;
  set unmatchedPolicy(UnmatchedPolicy policy);
}
