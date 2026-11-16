import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_webview_windows/zikzak_webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_controller.dart';

/// A [WebviewController] that records the DevTools calls the controller makes
/// instead of talking to a platform channel. The real class is a plain
/// (extendable) class, and every method the controller touches is virtual, so
/// the controller can be driven end-to-end on the Dart VM.
class _FakeWebviewController extends WebviewController {
  final StreamController<Map<String, dynamic>> _events =
      StreamController<Map<String, dynamic>>.broadcast(sync: true);
  final StreamController<String> _calls = StreamController<String>.broadcast(
    sync: true,
  );

  /// DevTools methods called, in order.
  final List<String> calls = <String>[];

  /// The parameters of each recorded call, parallel to [calls].
  final List<Map<String, dynamic>?> callParameters = <Map<String, dynamic>?>[];
  final List<String> loadedUrls = <String>[];
  final List<String> addedListeners = <String>[];
  final List<String> removedListeners = <String>[];

  final Map<String, Future<dynamic> Function()> results = {};
  Future<String> nextCall(String method) =>
      _calls.stream.firstWhere((call) => call == method);

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
    _calls.add(method);
    return await results[method]?.call();
  }

  @override
  Future<void> loadUrl(String url) async => loadedUrls.add(url);

  @override
  Future<void> addDevToolsProtocolEventListener(String eventName) async =>
      addedListeners.add(eventName);

  @override
  Future<void> removeDevToolsProtocolEventListener(String eventName) async =>
      removedListeners.add(eventName);

  @override
  Future<void> stop() async => calls.add('stop');

  Future<void> close() async {
    await _events.close();
    await _calls.close();
  }
}

InAppWebViewWindowsController _buildController(
  _FakeWebviewController webviewController,
) {
  final params = PlatformInAppWebViewControllerCreationParams(id: 0);
  return InAppWebViewWindowsController(params, webviewController);
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
    test(
      'injects pending headers when WebView2 canonicalizes the URL',
      () async {
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

        final settled = web.nextCall('Fetch.disable');
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
        await settled;

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
      },
    );

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

      final settled = web.nextCall('Fetch.disable');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-2',
          'request': {'url': 'https://example.com/path', 'headers': {}},
        },
      });
      await settled;

      final headers = _headerList(_paramsOf(web, 'Fetch.continueRequest'));
      expect(headers.map((header) => header['name']), contains('X-Port'));
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

      final settled = web.nextCall('Fetch.disable');
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
      await settled;

      final headers = _headerList(_paramsOf(web, 'Fetch.continueRequest'));
      final auth = headers.where(
        (header) => header['name'].toString().toLowerCase() == 'authorization',
      );
      expect(auth, hasLength(1));
      expect(auth.single['value'], 'Bearer new');
    });
  });

  group('Fetch.requestPaused always resumes', () {
    test(
      'continues a paused request whose url is missing or malformed',
      () async {
        final web = _FakeWebviewController();
        final controller = _buildController(web);
        addTearDown(controller.dispose);
        addTearDown(web.close);

        final settled = web.nextCall('Fetch.continueRequest');
        web.emit({
          'eventName': 'Fetch.requestPaused',
          'data': {
            'requestId': 'req-4',
            'request': {'headers': <String, dynamic>{}},
          },
        });
        await settled;

        final params = _paramsOf(web, 'Fetch.continueRequest');
        expect(params['requestId'], 'req-4');
        expect(params.containsKey('headers'), isFalse);
      },
    );

    test(
      'continues a paused request even when the request object is absent',
      () async {
        final web = _FakeWebviewController();
        final controller = _buildController(web);
        addTearDown(controller.dispose);
        addTearDown(web.close);

        final settled = web.nextCall('Fetch.continueRequest');
        web.emit({
          'eventName': 'Fetch.requestPaused',
          'data': {'requestId': 'req-5'},
        });
        await settled;

        expect(_paramsOf(web, 'Fetch.continueRequest')['requestId'], 'req-5');
      },
    );

    test('does not continue when there is no requestId to resume', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {'request': <String, dynamic>{}},
      });

      expect(web.calls, isNot(contains('Fetch.continueRequest')));
    });

    test('terminates a request when continuation fails', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);
      web.results['Fetch.continueRequest'] = () =>
          Future<dynamic>.error(StateError('continuation failed'));

      final settled = web.nextCall('Fetch.failRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-6',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(_paramsOf(web, 'Fetch.failRequest'), {
        'requestId': 'req-6',
        'errorReason': 'Failed',
      });
    });
  });

  group('loadUrl Fetch gating', () {
    test(
      'a failed disable is retried before starting plain navigation',
      () async {
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
        web.results['Fetch.disable'] = () =>
            Future<dynamic>.error(StateError('disable failed'));
        await expectLater(
          controller.loadUrl(
            urlRequest: URLRequest(url: WebUri('https://example.com/plain')),
          ),
          throwsStateError,
        );
        expect(web.loadedUrls, ['https://example.com/']);
        web.results.remove('Fetch.disable');
        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri('https://example.com/plain')),
        );
        expect(web.calls, ['Fetch.enable', 'Fetch.disable', 'Fetch.disable']);
        expect(web.loadedUrls.last, 'https://example.com/plain');
      },
    );

    test(
      'waits for consumed-request cleanup before enabling the next navigation',
      () async {
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
        final disable = Completer<dynamic>();
        web.results['Fetch.disable'] = () => disable.future;
        final disabling = web.nextCall('Fetch.disable');
        web.emit({
          'eventName': 'Fetch.requestPaused',
          'data': {
            'requestId': 'first',
            'request': {'url': 'https://example.com/', 'headers': {}},
          },
        });
        await disabling;
        final next = controller.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://example.com/next'),
            headers: const {'X-Two': '2'},
          ),
        );
        expect(web.loadedUrls, ['https://example.com/']);
        disable.complete();
        await next;
        expect(web.calls, [
          'Fetch.enable',
          'Fetch.continueRequest',
          'Fetch.disable',
          'Fetch.enable',
        ]);
        expect(web.loadedUrls.last, 'https://example.com/next');
      },
    );

    test(
      'superseded navigation headers cannot leak to a later document',
      () async {
        final web = _FakeWebviewController();
        final controller = _buildController(web);
        addTearDown(controller.dispose);
        addTearDown(web.close);
        await controller.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://example.com/old'),
            headers: const {'Authorization': 'Bearer old'},
          ),
        );
        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri('https://example.com/new')),
        );
        final continued = web.nextCall('Fetch.continueRequest');
        web.emit({
          'eventName': 'Fetch.requestPaused',
          'data': {
            'requestId': 'late',
            'request': {'url': 'https://example.com/old', 'headers': {}},
          },
        });
        await continued;
        expect(_paramsOf(web, 'Fetch.continueRequest'), {'requestId': 'late'});
      },
    );

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

      final settled = web.nextCall('Fetch.disable');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'req-7',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(
        web.calls,
        containsAllInOrder(<String>[
          'Fetch.enable',
          'Fetch.continueRequest',
          'Fetch.disable',
        ]),
      );
    });

    test(
      'rejects navigation without losing supplied headers when enable fails',
      () async {
        final web = _FakeWebviewController();
        final controller = _buildController(web);
        addTearDown(controller.dispose);
        addTearDown(web.close);
        web.results['Fetch.enable'] = () =>
            Future<dynamic>.error(StateError('enable failed'));

        await expectLater(
          controller.loadUrl(
            urlRequest: URLRequest(
              url: WebUri('https://example.com/'),
              headers: const {'X-Lost': '1'},
            ),
          ),
          throwsStateError,
        );

        expect(web.loadedUrls, isEmpty);
        expect(web.calls, isNot(contains('Fetch.disable')));
      },
    );
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

    test(
      'matches a case-insensitive doctype and keeps surrounding whitespace',
      () async {
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
      },
    );

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
    test(
      'add/remove forward to the controller and clear the callback',
      () async {
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
      },
    );

    test('dispatches a subscribed event to its callback', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      final received = Completer<dynamic>();
      await controller.addDevToolsProtocolEventListener(
        eventName: 'Page.loadEventFired',
        callback: received.complete,
      );

      web.emit({
        'eventName': 'Page.loadEventFired',
        'data': {'timestamp': 1},
      });
      expect(await received.future, {'timestamp': 1});
    });
  });
}
