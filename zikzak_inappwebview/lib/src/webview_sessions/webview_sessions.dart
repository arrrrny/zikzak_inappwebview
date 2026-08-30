import 'dart:convert';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_session/zikzak_session.dart';

import '../cookie_manager.dart';
import '../in_app_webview/in_app_webview_controller.dart';

/// Portable webview sessions for zikzak_inappwebview, backed entirely by
/// [zikzak_session](https://github.com/arrrrny/zikzak_session) (spec
/// `014-portable-sessions`).
///
/// A [WebViewSessions] instance saves a live webview's session state —
/// cookies (via [CookieManager]) and localStorage (via JavaScript
/// evaluation) — into a named, self-contained [PortableSession] through
/// the injected [SessionPort], and restores it into a fresh webview at the
/// same site. Sessions therefore survive app restarts and can be loaded
/// programmatically onto specific sites (the multi-profile / cloaked
/// browser use case).
///
/// ```dart
/// final sessions = WebViewSessions(
///   port: FileSessionStore(Directory('/path/to/store')),
/// );
/// // after the webview authenticated:
/// await sessions.save(
///   controller,
///   sessionId: 'browser-a',
///   name: 'Account A',
///   url: WebUri('https://app.example.com'),
/// );
/// // after an app restart, in a fresh webview:
/// await sessions.load(
///   controller,
///   sessionId: 'browser-a',
///   url: WebUri('https://app.example.com'),
/// );
/// ```
///
/// All persistence goes through the [SessionPort] — this package never
/// writes its own session format.
class WebViewSessions {
  /// The session persistence surface (e.g. [FileSessionStore]).
  final SessionPort port;

  /// Cookie manager used for harvest/restore. Injectable; created lazily
  /// on first use so pure-Dart tests (which never touch cookies) can run
  /// without a platform implementation registered.
  final CookieManager? _injectedCookieManager;
  CookieManager? _cookieManager;

  CookieManager get _cookies =>
      _injectedCookieManager ?? (_cookieManager ??= CookieManager());

  /// JS evaluator seam used by [save]/[load]. Injected for tests so the
  /// controller can be omitted (no platform needed); in production it is
  /// derived from the [InAppWebViewController] passed to those methods.
  final Future<Object?> Function(String source)? _injectedEvaluator;

  /// Clock used to stamp saved sessions. Injectable (defaults to
  /// [DateTime.now]) so tests can assert the recorded timestamps deterministically.
  final DateTime Function() _clock;

  /// Creates a sessions controller backed by [port].
  ///
  /// [cookieManager], [evaluateJavascript], and [clock] are injectable so the
  /// controller-dependent paths can run without a live webview/platform and so
  /// the recorded timestamps are deterministic under test (Finding #6 / T024).
  WebViewSessions({
    required this.port,
    CookieManager? cookieManager,
    Future<Object?> Function(String source)? evaluateJavascript,
    DateTime Function()? clock,
  }) : _injectedCookieManager = cookieManager,
       _injectedEvaluator = evaluateJavascript,
       _clock = clock ?? DateTime.now;

  // ── save ──────────────────────────────────────────────────────────────

  /// Saves the current session state of the webview behind [controller]
  /// under [sessionId] / [name] for [url].
  ///
  /// Harvests cookies for [url] (FR-003) and the page's localStorage (FR-003,
  /// FR-006) through [CookieManager] and JavaScript evaluation, maps them onto
  /// a [PortableSession] (origin = [url]'s origin, FR-002/FR-003), and
  /// persists it entirely through the [port] (FR-002 — no own storage format).
  /// Overwrites a previously saved session with the same id (FR-001).
  Future<void> save(
    InAppWebViewController? controller, {
    required String sessionId,
    required String name,
    required WebUri url,
    Future<Object?> Function(String source)? evaluateJavascript,
  }) async {
    final evaluate =
        evaluateJavascript ?? _injectedEvaluator ??
        (source) => controller!.evaluateJavascript(source: source);
    final now = _clock().millisecondsSinceEpoch;
    final cookies = await _cookies.getCookies(url: url);
    final storage = await harvestLocalStorage(evaluate);

    await port.save(
      PortableSession(
        id: sessionId,
        name: name,
        origin: _originOf(url),
        createdAt: now,
        updatedAt: now,
        cookies: cookies.map(toCookieEntry).toList(growable: false),
        storage: storage
            .map(
              (entry) => StorageEntry(
                key: entry.key,
                value: entry.value,
                area: 'localStorage',
                origin: _originOf(url),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  // ── load ──────────────────────────────────────────────────────────────

  /// Restores the session saved under [sessionId] into the webview behind
  /// [controller], for [url].
  ///
  /// Re-applies cookies through the [CookieManager] (FR-004) and localStorage
  /// entries through JavaScript (FR-004, FR-006). Returns `false` when no
  /// session is saved under [sessionId] — never throws on a missing session
  /// (FR-001, FR-004 / US1 scenario 3).
  Future<bool> load(
    InAppWebViewController? controller, {
    required String sessionId,
    required WebUri url,
    Future<Object?> Function(String source)? evaluateJavascript,
  }) async {
    final evaluate =
        evaluateJavascript ?? _injectedEvaluator ??
        (source) => controller!.evaluateJavascript(source: source);
    final session = await port.load(sessionId);
    if (session == null) return false;

    // Reject sessions whose origin does not match the destination.
    if (session.origin != _originOf(url)) return false;

    // Clear destination-origin cookies and localStorage before restoring
    // so that a previous session (B) does not retain entries from an
    // earlier session (A) at the same origin.
    await _cookies.deleteAllCookies();
    await evaluate('window.localStorage.clear()');

    for (final entry in session.cookies) {
      await _cookies.setCookie(
        url: url,
        name: entry.name,
        value: entry.value,
        domain: entry.domain.isNotEmpty ? entry.domain : null,
        path: entry.path,
        expiresDate: entry.expiresAt,
        isSecure: entry.secure,
        isHttpOnly: entry.httpOnly,
      );
    }

    final storage = session.storage
        .where((entry) => entry.area == 'localStorage')
        .toList(growable: false);
    if (storage.isNotEmpty) {
      await applyLocalStorage(evaluate, storage);
    }
    return true;
  }

  // ── port surface ──────────────────────────────────────────────────────

  /// Lists every saved session (id, name, origin, saved-at).
  Future<List<PortableSession>> list() => port.list();

  /// Deletes the session under [sessionId]; returns whether one existed.
  Future<bool> delete(String sessionId) => port.delete(sessionId);

  // ── cookie mapping ────────────────────────────────────────────────────

  /// Maps a plugin [Cookie] into a portable [CookieEntry] (FR-005).
  ///
  /// The plugin's cookie value is `dynamic`; anything non-String is
  /// stringified so the portable format stays plain JSON. Null optionals fall
  /// back to safe defaults (empty domain, `/` path, secure/httpOnly false).
  static CookieEntry toCookieEntry(Cookie cookie) => CookieEntry(
    name: cookie.name,
    value: cookie.value?.toString() ?? '',
    domain: cookie.domain ?? '',
    path: cookie.path ?? '/',
    expiresAt: cookie.expiresDate,
    secure: cookie.isSecure ?? false,
    httpOnly: cookie.isHttpOnly ?? false,
  );

  // ── localStorage via an evaluator closure ────────────────────────────

  /// Reads `window.localStorage` through [evaluate] (the webview's
  /// `evaluateJavascript`) and returns its key/value pairs (FR-003, FR-006).
  ///
  /// A page with no localStorage yields an empty list. An evaluation
  /// failure propagates to the caller so that save operations can
  /// report the error rather than silently persisting an incomplete
  /// session.
  static Future<List<({String key, String value})>> harvestLocalStorage(
    Future<Object?> Function(String source) evaluate,
  ) async {
    final dynamic raw =
        await evaluate('JSON.stringify(window.localStorage)');
    if (raw is! String || raw.isEmpty) return const [];
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      return const [];
    }
    if (decoded is! Map<String, dynamic>) return const [];
    return decoded.entries
        .map((entry) => (key: entry.key, value: '${entry.value}'))
        .toList(growable: false);
  }

  /// Re-applies [storage] entries through [evaluate] by setting each
  /// localStorage key individually (FR-004, FR-006 — avoids escaping pitfalls
  /// of one concatenated script).
  static Future<void> applyLocalStorage(
    Future<Object?> Function(String source) evaluate,
    List<StorageEntry> storage,
  ) async {
    for (final entry in storage) {
      final encodedKey = jsonEncode(entry.key);
      final encodedValue = jsonEncode(entry.value);
      await evaluate('window.localStorage.setItem($encodedKey, $encodedValue)');
    }
  }

  static String _originOf(WebUri url) {
    final origin = url.origin;
    return origin.isNotEmpty && origin != 'null' ? origin : url.toString();
  }
}
