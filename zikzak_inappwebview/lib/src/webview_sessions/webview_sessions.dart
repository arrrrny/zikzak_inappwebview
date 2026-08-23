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

  /// Creates a sessions controller backed by [port].
  WebViewSessions({required this.port, CookieManager? cookieManager})
    : _injectedCookieManager = cookieManager;

  // ── save ──────────────────────────────────────────────────────────────

  /// Saves the current session state of the webview behind [controller]
  /// under [sessionId] / [name] for [url].
  ///
  /// Harvests cookies for [url] and the page's localStorage (key/value
  /// pairs), maps them onto a [PortableSession] (origin = [url]'s origin),
  /// and persists it through the [port]. Overwrites a previously saved
  /// session with the same id.
  Future<void> save(
    InAppWebViewController controller, {
    required String sessionId,
    required String name,
    required WebUri url,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final cookies = await _cookies.getCookies(url: url);
    final storage = await harvestLocalStorage(
      (source) => controller.evaluateJavascript(source: source),
    );

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
  /// Re-applies cookies through the [CookieManager] and localStorage
  /// entries through JavaScript. Returns `false` when no session is saved
  /// under [sessionId] (never throws on missing sessions).
  Future<bool> load(
    InAppWebViewController controller, {
    required String sessionId,
    required WebUri url,
  }) async {
    final session = await port.load(sessionId);
    if (session == null) return false;

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
      await applyLocalStorage(
        (source) => controller.evaluateJavascript(source: source),
        storage,
      );
    }
    return true;
  }

  // ── port surface ──────────────────────────────────────────────────────

  /// Lists every saved session (id, name, origin, saved-at).
  Future<List<PortableSession>> list() => port.list();

  /// Deletes the session under [sessionId]; returns whether one existed.
  Future<bool> delete(String sessionId) => port.delete(sessionId);

  // ── cookie mapping ────────────────────────────────────────────────────

  /// Maps a plugin [Cookie] into a portable [CookieEntry].
  ///
  /// The plugin's cookie value is `dynamic`; anything non-String is
  /// stringified so the portable format stays plain JSON.
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
  /// `evaluateJavascript`) and returns its key/value pairs.
  ///
  /// A page with no localStorage yields an empty list; a failing
  /// evaluation yields an empty list too (best-effort harvest, matching
  /// zikzak_session's corrupt-session tolerance).
  static Future<List<({String key, String value})>> harvestLocalStorage(
    Future<Object?> Function(String source) evaluate,
  ) async {
    final dynamic raw;
    try {
      raw = await evaluate('JSON.stringify(window.localStorage)');
    } catch (_) {
      return const [];
    }
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
  /// localStorage key individually (avoids escaping pitfalls of one
  /// concatenated script).
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
