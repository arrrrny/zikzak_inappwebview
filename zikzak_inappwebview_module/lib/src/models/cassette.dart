/// Cassette format version.
///
/// Increment when the cassette structure changes incompatibly.
/// Spec: 008 (FR-009)
const int cassetteFormatVersion = 1;

/// Mode for the cassette engine.
///
/// Spec: 008 (FR-001)
enum CassetteMode {
  /// Capturing live traffic into a cassette.
  record,

  /// Serving cassette content without live network.
  replay,
}

/// A single recorded navigation entry in a cassette.
///
/// Keyed by (url, normalizedRequest) for matching during replay.
///
/// Spec: 008 (FR-002)
class CassetteEntry {
  final String url;
  final String? normalizedRequest;
  final String servedHtml;
  final List<CassetteNetworkEvent> networkEvents;
  final Map<String, String> cookieSnapshot;

  const CassetteEntry({
    required this.url,
    this.normalizedRequest,
    required this.servedHtml,
    this.networkEvents = const [],
    this.cookieSnapshot = const {},
  });

  /// Serializes this entry to a JSON map.
  Map<String, dynamic> toJson() => {
    'url': url,
    if (normalizedRequest != null) 'normalizedRequest': normalizedRequest,
    'servedHtml': servedHtml,
    'networkEvents': networkEvents.map((e) => e.toJson()).toList(),
    'cookieSnapshot': cookieSnapshot,
  };

  /// Deserializes a cassette entry from JSON.
  factory CassetteEntry.fromJson(Map<String, dynamic> json) {
    return CassetteEntry(
      url: json['url'] as String,
      normalizedRequest: json['normalizedRequest'] as String?,
      servedHtml: json['servedHtml'] as String,
      networkEvents: (json['networkEvents'] as List?)
          ?.map((e) => CassetteNetworkEvent.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      cookieSnapshot: Map<String, String>.from(
        json['cookieSnapshot'] as Map? ?? {},
      ),
    );
  }
}

/// A recorded network capture event within a cassette entry.
///
/// Spec: 008 (FR-002)
class CassetteNetworkEvent {
  final String url;
  final String method;
  final Map<String, String> requestHeaders;
  final String? requestBody;
  final int statusCode;
  final Map<String, String> responseHeaders;
  final String? responseBody;

  const CassetteNetworkEvent({
    required this.url,
    required this.method,
    required this.requestHeaders,
    this.requestBody,
    required this.statusCode,
    required this.responseHeaders,
    this.responseBody,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'method': method,
    'requestHeaders': requestHeaders,
    if (requestBody != null) 'requestBody': requestBody,
    'statusCode': statusCode,
    'responseHeaders': responseHeaders,
    if (responseBody != null) 'responseBody': responseBody,
  };

  factory CassetteNetworkEvent.fromJson(Map<String, dynamic> json) {
    return CassetteNetworkEvent(
      url: json['url'] as String,
      method: json['method'] as String,
      requestHeaders: Map<String, String>.from(
        json['requestHeaders'] as Map? ?? {},
      ),
      requestBody: json['requestBody'] as String?,
      statusCode: json['statusCode'] as int,
      responseHeaders: Map<String, String>.from(
        json['responseHeaders'] as Map? ?? {},
      ),
      responseBody: json['responseBody'] as String?,
    );
  }
}

/// A versioned cassette artifact.
///
/// The cassette is serialized as gzipped JSON. Each cassette carries
/// a declared [formatVersion] so loaders can reject incompatible files.
///
/// Spec: 008 (FR-002, FR-003, FR-009, FR-010)
class Cassette {
  final int formatVersion;
  final String name;
  final DateTime recordedAt;
  final List<CassetteEntry> entries;

  const Cassette({
    this.formatVersion = cassetteFormatVersion,
    required this.name,
    required this.recordedAt,
    this.entries = const [],
  });

  /// Serializes the cassette to a JSON map.
  Map<String, dynamic> toJson() => {
    'formatVersion': formatVersion,
    'name': name,
    'recordedAt': recordedAt.toIso8601String(),
    'entries': entries.map((e) => e.toJson()).toList(),
  };

  /// Deserializes a cassette from JSON.
  ///
  /// Throws [FormatException] if the format version is unsupported.
  factory Cassette.fromJson(Map<String, dynamic> json) {
    final version = json['formatVersion'] as int? ?? 0;
    if (version > cassetteFormatVersion) {
      throw FormatException(
        'Unsupported cassette format version: $version '
        '(max supported: $cassetteFormatVersion)',
      );
    }
    return Cassette(
      formatVersion: version,
      name: json['name'] as String? ?? 'unnamed',
      recordedAt: DateTime.parse(
        json['recordedAt'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      entries: (json['entries'] as List?)
          ?.map((e) => CassetteEntry.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}
