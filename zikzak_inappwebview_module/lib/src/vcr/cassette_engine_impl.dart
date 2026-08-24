import 'dart:convert';
import 'dart:io';

import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import '../models/cassette.dart';
import '../ports/cassette_engine.dart';

/// VCR wrapper around [HeadlessInAppWebView].
///
/// In record mode, captures navigations, served HTML, network events,
/// and cookie snapshots. In replay mode, serves cassette content
/// without live network.
///
/// Spec: 008 (all FRs)
class CassetteEngineImpl implements CassetteEngine {
  CassetteMode _mode = CassetteMode.record;
  UnmatchedPolicy _unmatchedPolicy = UnmatchedPolicy.hard;

  Cassette? _loadedCassette;
  final List<CassetteEntry> _recordedEntries = [];

  /// Redaction patterns applied at record time.
  ///
  /// Headers matching these patterns have their values scrubbed.
  static const _redactedHeaderPatterns = [
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
    'x-auth-token',
  ];

  @override
  CassetteMode get mode => _mode;

  @override
  UnmatchedPolicy get unmatchedPolicy => _unmatchedPolicy;
  @override
  set unmatchedPolicy(UnmatchedPolicy policy) => _unmatchedPolicy = policy;

  @override
  Future<void> loadCassette(Cassette cassette) async {
    _mode = CassetteMode.replay;
    _loadedCassette = cassette;
  }

  @override
  Future<Cassette> saveCassette() async {
    final cassette = Cassette(
      name: 'recording-${DateTime.now().millisecondsSinceEpoch}',
      recordedAt: DateTime.now(),
      entries: List.unmodifiable(_recordedEntries),
    );
    _recordedEntries.clear();
    return cassette;
  }

  /// Records a navigation entry.
  ///
  /// Call this when a page loads in record mode. Captures the URL,
  /// served HTML, and cookie snapshot. Applies redaction to headers.
  void recordNavigation({
    required String url,
    required String html,
    Map<String, String>? networkHeaders,
    Map<String, String>? cookies,
  }) {
    if (_mode != CassetteMode.record) return;

    _recordedEntries.add(CassetteEntry(
      url: url,
      servedHtml: html,
      cookieSnapshot: _redactCookies(cookies ?? {}),
      networkEvents: [
        if (networkHeaders != null)
          CassetteNetworkEvent(
            url: url,
            method: 'GET',
            requestHeaders: _redactHeaders(networkHeaders),
            statusCode: 200,
            responseHeaders: _redactHeaders(networkHeaders),
          ),
      ],
    ));
  }

  /// Looks up a recorded entry for replay.
  ///
  /// Returns the recorded HTML for a URL, or throws if not found
  /// (in hard policy mode).
  String? replayUrl(String url) {
    if (_mode != CassetteMode.replay || _loadedCassette == null) {
      return null;
    }

    for (final entry in _loadedCassette!.entries) {
      if (entry.url == url) {
        return entry.servedHtml;
      }
    }

    // Best-match fallback: try URL prefix match
    for (final entry in _loadedCassette!.entries) {
      if (url.startsWith(entry.url)) {
        return entry.servedHtml;
      }
    }

    if (_unmatchedPolicy == UnmatchedPolicy.hard) {
      throw StateError(
        'VCR: unmatched URL in replay mode: $url. '
        'No cassette entry found and policy is hard.',
      );
    }
    return null;
  }

  /// Serializes a cassette to a gzipped JSON string.
  static Future<List<int>> serializeCassette(Cassette cassette) async {
    final json = jsonEncode(cassette.toJson());
    return gzip.encode(utf8.encode(json));
  }

  /// Deserializes a cassette from gzipped JSON bytes.
  static Future<Cassette> deserializeCassette(List<int> bytes) async {
    final json = utf8.decode(gzip.decode(bytes));
    return Cassette.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }

  /// Saves a cassette to a file.
  static Future<void> saveCassetteToFile(
    Cassette cassette,
    String filePath,
  ) async {
    final data = await serializeCassette(cassette);
    await File(filePath).writeAsBytes(data);
  }

  /// Loads a cassette from a file.
  static Future<Cassette> loadCassetteFromFile(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    return deserializeCassette(bytes);
  }

  // --- Redaction ---

  Map<String, String> _redactHeaders(Map<String, String> headers) {
    return headers.map((key, value) {
      final lower = key.toLowerCase();
      for (final pattern in _redactedHeaderPatterns) {
        if (lower.contains(pattern)) {
          return MapEntry(key, '[REDACTED]');
        }
      }
      return MapEntry(key, value);
    });
  }

  Map<String, String> _redactCookies(Map<String, String> cookies) {
    return cookies.map((key, value) => MapEntry(key, '[REDACTED]'));
  }
}
