import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_controller.dart';

/// A [WebviewController] that records the DevTools calls the controller makes
/// instead of talking to a platform channel. The real class is a plain
/// (extendable) class, and every method the controller touches is virtual, so
/// the controller can be driven end-to-end on the Dart VM.
class _FakeWebviewController extends WebviewController {
  final StreamController<Map<String, dynamic>> _events =
      StreamController<Map<String, dynamic>>.broadcast();

  /// DevTools methods called, in order.
  final List<String> calls = <String>[];

  /// The parameters of each recorded call, parallel to [calls].
  final List<Map<String, dynamic>?> callParameters = <Map<String, dynamic>?>[];
  final List<String> loadedUrls = <String>[];
  final List<String> addedListeners = <String>[];
  final List<String> removedListeners = <String>[];

  /// Methods that should throw when called.
  final Set<String> failingMethods = <String>{};

  void emit(Map<String, dynamic> event) => _events.add(event);

  @override
  Stream<Map<String, dynamic>> get devToolsProtocolEvent => _events.stream;

  @override
  Future<dynamic> callDevToolsProtocolMethod(
    String method, [
    Map<String, dynamic>? parameters,
  ]) async {
    calls.add(method);
    callParameters.add(parameters);
    if (failingMethods.contains(method)) {
      throw StateError('$method failed');
    }
    return null;
  }

  @override
  Future<void> loadUrl(String url) async => loadedUrls.add(url);

  @override
  Future<void> addDevToolsProtocolEventListener(String eventName) async =>
      addedListeners.add(eventName);

  @override
  Future<void> removeDevToolsProtocolEventListener(String eventName) async =>
      removedListeners.add(eventName);

  Future<void> close() => _events.close();
}

InAppWebViewWindowsController _buildController(
  _FakeWebviewController webviewController,
) {
  final params = PlatformInAppWebViewControllerCreationParams(id: 0);
  return InAppWebViewWindowsController(params, webviewController);
}

/// Lets the broadcast stream deliver and the unawaited futures run.
Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Map<String, dynamic> _paramsOf(_FakeWebviewController web, String method) {
  final index = web.calls.indexOf(method);
  expect(index, isNonNegative, reason: '$method was never called');
  return web.callParameters[index]!;
}

List<Map<String, dynamic>> _headerList(Map<String, dynamic> params) {
  return (params['headers'] as List).cast<Map<String, dynamic>>();
}

void main() {
  group('Fetch.requestPaused header preservation', () {
    test('injects pending headers when WebView2 canonicalizes the URL', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      // Dart keeps the raw "https://example.com"; Chromium reports
      // "https://example.com/". The map must still match.
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com'),
          headers: const {'X-Custom': 'yes'},
        ),
      );
      expect(web.calls, contains('Fetch.enable'));

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-1',
          'request': {
            'url': 'https://example.com/',
            'headers': {'Accept': '*/*'},
          },
        },
      });
      await _flush();

      final params = _paramsOf(web, 'Fetch.continueRequest');
      expect(params['requestId'], 'req-1');
      final headers = _headerList(params);
      expect(
        headers.map((header) => header['name']),
        containsAll(<String>['Accept', 'X-Custom']),
      );
      expect(
        headers.firstWhere((header) => header['name'] == 'X-Custom')['value'],
        'yes',
      );
    });

    test('elides a default port so the lookup still matches', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com:443/path'),
          headers: const {'X-Port': '443'},
        ),
      );

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-2',
          'request': {'url': 'https://example.com/path', 'headers': {}},
        },
      });
      await _flush();

      final headers = _headerList(_paramsOf(web, 'Fetch.continueRequest'));
      expect(
        headers.map((header) => header['name']),
        contains('X-Port'),
      );
    });

    test('replaces a same-name header case-insensitively', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com/'),
          headers: const {'authorization': 'Bearer new'},
        ),
      );

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-3',
          'request': {
            'url': 'https://example.com/',
            'headers': {'Authorization': 'Bearer old'},
          },
        },
      });
      await _flush();

      final headers = _headerList(_paramsOf(web, 'Fetch.continueRequest'));
      final auth = headers.where(
        (header) => header['name'].toString().toLowerCase() == 'authorization',
      );
      expect(auth, hasLength(1));
      expect(auth.single['value'], 'Bearer new');
    });
  });

  group('Fetch.requestPaused always resumes', () {
    test('continues a paused request whose url is missing or malformed', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-4',
          'request': {'headers': <String, dynamic>{}},
        },
      });
      await _flush();

      final params = _paramsOf(web, 'Fetch.continueRequest');
      expect(params['requestId'], 'req-4');
      expect(params.containsKey('headers'), isFalse);
    });

    test('continues a paused request even when the request object is absent', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {'requestId': 'req-5'},
      });
      await _flush();

      expect(_paramsOf(web, 'Fetch.continueRequest')['requestId'], 'req-5');
    });

    test('does not continue when there is no requestId to resume', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {'request': <String, dynamic>{}},
      });
      await _flush();

      expect(web.calls, isNot(contains('Fetch.continueRequest')));
    });

    test('swallows a failed continueRequest instead of freezing', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);
      web.failingMethods.add('Fetch.continueRequest');

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-6',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await _flush();

      expect(web.calls, contains('Fetch.continueRequest'));
    });
  });

  group('loadUrl Fetch gating', () {
    test('does not enable Fetch for a header-less navigation', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com')),
      );

      expect(web.calls, isNot(contains('Fetch.enable')));
      expect(web.loadedUrls, <String>['https://example.com']);
    });

    test('disables Fetch once the pending headers are consumed', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com/'),
          headers: const {'X-One': '1'},
        ),
      );

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-7',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await _flush();

      expect(
        web.calls,
        containsAllInOrder(<String>[
          'Fetch.enable',
          'Fetch.continueRequest',
          'Fetch.disable',
        ]),
      );
    });

    test('falls back to a plain navigation when Fetch.enable throws', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);
      web.failingMethods.add('Fetch.enable');

      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com/'),
          headers: const {'X-Lost': '1'},
        ),
      );

      expect(web.loadedUrls, <String>['https://example.com/']);
      // The pending headers were dropped, so no later navigation tries to
      // disable interception that was never enabled.
      expect(web.calls, isNot(contains('Fetch.disable')));
    });
  });

  group('loadData base-url injection', () {
    Future<String> loadedSourceOf(_FakeWebviewController web) async {
      final uri = Uri.parse(web.loadedUrls.single);
      return uri.data!.contentAsString();
    }

    test('keeps a leading doctype first (standards mode)', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadData(
        data: '<!DOCTYPE html><html><body>x</body></html>',
        baseUrl: WebUri('https://a.dev'),
      );

      final source = await loadedSourceOf(web);
      expect(
        source,
        startsWith('<!DOCTYPE html><base href="https:&#47;&#47;a.dev">'),
      );
    });

    test('matches a case-insensitive doctype and keeps surrounding whitespace', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadData(
        data: '\n  <!doctype html>\n<p>x</p>',
        baseUrl: WebUri('https://a.dev'),
      );

      final source = await loadedSourceOf(web);
      expect(
        source,
        '\n  <!doctype html><base href="https:&#47;&#47;a.dev">\n<p>x</p>',
      );
    });

    test('prepends the base tag when there is no doctype', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadData(
        data: '<html><body>x</body></html>',
        baseUrl: WebUri('https://a.dev'),
      );

      final source = await loadedSourceOf(web);
      expect(source, startsWith('<base href="https:&#47;&#47;a.dev">'));
    });

    test('leaves the data untouched when no baseUrl is given', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadData(data: '<!DOCTYPE html><p>x</p>');

      final source = await loadedSourceOf(web);
      expect(source, '<!DOCTYPE html><p>x</p>');
    });
  });

  group('DevTools listener plumbing', () {
    test('add/remove forward to the controller and clear the callback', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addDevToolsProtocolEventListener(
        eventName: 'Page.loadEventFired',
        callback: (_) {},
      );
      await controller.removeDevToolsProtocolEventListener(
        eventName: 'Page.loadEventFired',
      );

      expect(web.addedListeners, <String>['Page.loadEventFired']);
      expect(web.removedListeners, <String>['Page.loadEventFired']);
    });

    test('dispatches a subscribed event to its callback', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      dynamic received;
      await controller.addDevToolsProtocolEventListener(
        eventName: 'Page.loadEventFired',
        callback: (data) => received = data,
      );

      web.emit({
        'eventName': 'Page.loadEventFired',
        'data': {'timestamp': 1},
      });
      await _flush();

      expect(received, {'timestamp': 1});
    });
  });
}