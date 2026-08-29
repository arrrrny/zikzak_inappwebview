import 'dart:async';

import 'network_entry.dart';
import 'network_request.dart';
import 'network_response.dart';
import 'network_response_body.dart';
import 'resource_type.dart';

///Per-domain capture budget.
///
///When [NetworkCaptureController.domainBudgets] maps a host to a [DomainBudget],
///captures for that host are capped accordingly. Once a cap is reached for a
///domain, further captures for that domain are dropped while other domains keep
///capturing normally (FR-006 / A10, A11, A12).
class DomainBudget {
  ///Maximum number of entries captured for the domain (A10). `null` = unlimited.
  final int? maxEntries;

  ///Maximum total response-body bytes captured for the domain (A11).
  final int? maxBytes;

  ///Maximum number of bytes retained per response body for the domain (A12).
  final int? maxBodySize;

  const DomainBudget({this.maxEntries, this.maxBytes, this.maxBodySize});
}

///Controller that accumulates network capture data for bulk retrieval.
///
///Pass an instance to `InAppWebViewSettings.networkCapture` to automatically
///collect every captured request-response pair:
///
///```dart
///final captureController = NetworkCaptureController();
///
///InAppWebView(
///  initialSettings: InAppWebViewSettings(
///    networkCapture: captureController,
///  ),
///);
///
///// after page load:
///final entries = await captureController.getEntries(
///  urlPatterns: ['api'],
///  mimeTypes: ['application/json'],
///);
///captureController.clear(); // before navigating to the next page
///```
///
///All `getEntries`/`getBodies` filters use case-insensitive substring
///matching and combine with AND logic.
class NetworkCaptureController {
  final List<NetworkEntry> _entries = <NetworkEntry>[];
  final Map<String, NetworkEntry> _byId = <String, NetworkEntry>{};

  ///Events that arrived before their corresponding `request` event
  ///(response streaming can overtake an asynchronously-serialized request).
  final Map<String, NetworkResponse> _pendingResponses =
      <String, NetworkResponse>{};
  final Map<String, NetworkResponseBody> _pendingBodies =
      <String, NetworkResponseBody>{};
  final Map<String, String> _pendingErrors = <String, String>{};

  DateTime _lastActivity = DateTime.now();

  ///Per-domain capture budgets, keyed by exact host (e.g. `api.example.com`).
  ///Empty by default, meaning no per-domain limits are applied.
  ///
  ///Set this before capture begins; changing it mid-capture takes effect on the
  ///next tracked request. (FR-006)
  Map<String, DomainBudget> domainBudgets = const {};

  ///Number of entries currently captured per host, used for budget enforcement.
  final Map<String, int> _domainEntryCount = <String, int>{};

  ///Total retained response-body bytes captured per host, used for budget
  ///enforcement (A11).
  final Map<String, int> _domainByteCount = <String, int>{};

  ///Number of captured entries.
  int get count => _entries.length;

  ///Timestamp of the last observed network activity.
  DateTime get lastActivity => _lastActivity;

  ///All captured request-response pairs, optionally filtered.
  ///
  ///- [urlPatterns]: keep entries whose request URL contains any pattern
  ///  (case-insensitive substring).
  ///- [mimeTypes]: keep entries whose response MIME type contains any
  ///  pattern (case-insensitive substring).
  ///- [resourceTypes]: keep entries whose request resource type is listed.
  ///- [withBodyOnly]: when `true`, keep only entries that have a captured
  ///  response body.
  Future<List<NetworkEntry>> getEntries({
    List<String>? urlPatterns,
    List<String>? mimeTypes,
    List<ResourceType>? resourceTypes,
    bool? withBodyOnly,
  }) async {
    final lowerUrlPatterns = urlPatterns?.map((e) => e.toLowerCase()).toList();
    final lowerMimeTypes = mimeTypes?.map((e) => e.toLowerCase()).toList();

    return _entries.where((entry) {
      if (lowerUrlPatterns != null && lowerUrlPatterns.isNotEmpty) {
        final url = entry.request.url.toString().toLowerCase();
        if (!lowerUrlPatterns.any((p) => url.contains(p))) {
          return false;
        }
      }
      if (lowerMimeTypes != null && lowerMimeTypes.isNotEmpty) {
        final mime =
            entry.response?.mimeType.toLowerCase() ??
            entry.responseBody?.mimeType?.toLowerCase() ??
            '';
        if (!lowerMimeTypes.any((p) => mime.contains(p))) {
          return false;
        }
      }
      if (resourceTypes != null && resourceTypes.isNotEmpty) {
        if (!resourceTypes.any((t) => t == entry.request.resourceType)) {
          return false;
        }
      }
      if (withBodyOnly == true && entry.responseBody == null) {
        return false;
      }
      return true;
    }).toList();
  }

  ///Just the captured response bodies — convenience for data extraction.
  Future<List<NetworkResponseBody>> getBodies({
    List<String>? urlPatterns,
    List<String>? mimeTypes,
  }) async {
    final entries = await getEntries(
      urlPatterns: urlPatterns,
      mimeTypes: mimeTypes,
      withBodyOnly: true,
    );
    return entries.map((e) => e.responseBody!).toList();
  }

  ///Waits until no new network activity has been observed for
  ///[quietDuration]. Useful to detect when a SPA finished loading its
  ///API calls.
  ///
  ///Throws a [TimeoutException] when [timeout] elapses before the network
  ///becomes idle.
  Future<void> waitForIdle({
    Duration timeout = const Duration(seconds: 15),
    Duration quietDuration = const Duration(milliseconds: 1500),
  }) async {
    final stopwatch = Stopwatch()..start();
    // Give the page a brief moment to start its first request.
    _lastActivity = DateTime.now();
    while (true) {
      final quietFor = DateTime.now().difference(_lastActivity);
      if (quietFor >= quietDuration) {
        return;
      }
      if (stopwatch.elapsed >= timeout) {
        throw TimeoutException(
          'Network did not become idle within $timeout '
          '(last activity $quietFor ago).',
          timeout,
        );
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  ///Clears all captured data. Call before navigating to a new page.
  void clear() {
    _entries.clear();
    _byId.clear();
    _pendingResponses.clear();
    _pendingBodies.clear();
    _pendingErrors.clear();
    _domainEntryCount.clear();
    _domainByteCount.clear();
    _lastActivity = DateTime.now();
  }

  ///Internal: records a captured request. Called by the capture engine.
  void trackRequest(NetworkRequest request) {
    _lastActivity = DateTime.now();
    final existing = _byId[request.requestId];
    if (existing != null) {
      return;
    }

    // FR-006: enforce a per-domain entry budget. Once a domain hits its
    // `maxEntries` cap, further captures for that domain are dropped while other
    // domains keep capturing normally.
    final host = request.url.host;
    final budget = domainBudgets[host];
    if (budget?.maxEntries != null) {
      final captured = _domainEntryCount[host] ?? 0;
      if (captured >= budget!.maxEntries!) {
        return;
      }
      _domainEntryCount[host] = captured + 1;
    }

    final entry = NetworkEntry(
      request: request,
      response: _pendingResponses.remove(request.requestId),
      responseBody: _pendingBodies.remove(request.requestId),
      error: _pendingErrors.remove(request.requestId),
    );
    _entries.add(entry);
    _byId[request.requestId] = entry;
  }

  ///Internal: attaches a response to its entry. Called by the capture engine.
  void attachResponse(NetworkResponse response) {
    _lastActivity = DateTime.now();
    final entry = _byId[response.requestId];
    if (entry != null) {
      entry.response = response;
    } else {
      _pendingResponses[response.requestId] = response;
    }
  }

  ///Internal: attaches a response body. Called by the capture engine.
  void attachBody(NetworkResponseBody body) {
    _lastActivity = DateTime.now();
    final entry = _byId[body.requestId];
    if (entry != null) {
      // FR-006: enforce a per-domain response-body byte budget. Once a domain
      // crosses its `maxBytes` cap, further response bodies for that domain are
      // dropped while other domains keep their bodies.
      final host = body.url.host;
      final budget = domainBudgets[host];
      if (budget?.maxBytes != null) {
        final retained = _domainByteCount[host] ?? 0;
        if (retained + body.body.length > budget!.maxBytes!) {
          return;
        }
        _domainByteCount[host] = retained + body.body.length;
      }
      entry.responseBody = body;
    } else {
      _pendingBodies[body.requestId] = body;
    }
  }

  ///Internal: marks an entry as failed. Called by the capture engine.
  void attachError(String requestId, String message) {
    _lastActivity = DateTime.now();
    final entry = _byId[requestId];
    if (entry != null) {
      entry.error = message;
    } else {
      _pendingErrors[requestId] = message;
    }
  }
}
