import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show PlatformException;
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

  /// The sources passed to `addScriptToExecuteOnDocumentCreated`, in order.
  final List<String> addedScripts = <String>[];

  /// The ids passed to `removeScriptToExecuteOnDocumentCreated`, in order.
  final List<ScriptID> removedScriptIds = <ScriptID>[];

  /// The DevTools events currently registered natively.
  ///
  /// `AddDevToolsProtocolEventListener` refuses an event that is already
  /// registered (it returns `false`, which the platform channel raises as a
  /// `PlatformException`), so this set is the contract the controller's
  /// registration bookkeeping has to agree with.
  final Set<String> registeredListeners = <String>{};

  /// Per-method CDP results, keyed by method name.
  final Map<String, Future<dynamic> Function()> results = {};

  int _nextScriptId = 0;

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
  Future<void> addDevToolsProtocolEventListener(String eventName) async {
    if (registeredListeners.contains(eventName)) {
      // The native contract: a duplicate registration is an error, not a
      // no-op, which is what made the second navigation of a fetch-enabled
      // webview throw before the registration was tracked.
      throw PlatformException(
        code: 'method_failed',
        message:
            'DevTools protocol event listener already registered: $eventName',
      );
    }
    registeredListeners.add(eventName);
    addedListeners.add(eventName);
  }

  @override
  Future<void> removeDevToolsProtocolEventListener(String eventName) async {
    registeredListeners.remove(eventName);
    removedListeners.add(eventName);
  }

  @override
  Future<ScriptID?> addScriptToExecuteOnDocumentCreated(String script) async {
    addedScripts.add(script);
    final id = 'script-${_nextScriptId++}';
    return id;
  }

  @override
  Future<void> removeScriptToExecuteOnDocumentCreated(ScriptID scriptId) async {
    removedScriptIds.add(scriptId);
  }

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

/// A controller whose creation params carry a
/// `shouldOverrideUrlLoading` callback, which is what puts a navigation on the
/// Fetch boundary at all.
///
/// [onNavigation] receives the [NavigationAction] the controller built; when it
/// is omitted every decision is [policy].
InAppWebViewWindowsController _buildControllerWithNavigationPolicy(
  _FakeWebviewController webviewController, {
  NavigationActionPolicy policy = NavigationActionPolicy.ALLOW,
  Future<NavigationActionPolicy?> Function(NavigationAction action)?
      onNavigation,
}) {
  final params = PlatformInAppWebViewControllerCreationParams(
    id: 0,
    webviewParams: PlatformWebViewCreationParams(
      controllerFromPlatform: (PlatformInAppWebViewController controller) =>
          controller,
      shouldOverrideUrlLoading: (dynamic controller, NavigationAction action) =>
          onNavigation == null
              ? Future<NavigationActionPolicy?>.value(policy)
              : onNavigation(action),
    ),
  );
  // The controller resolves its own callback controller lazily from
  // `controllerFromPlatform`, so a controller built directly needs no
  // post-construction assignment.
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

  group('loadData base-url origin', () {
    test('serves HTML at the requested HTTP origin', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      const html = '<!DOCTYPE html><html><body>x</body></html>';
      await controller.loadData(
        data: html,
        baseUrl: WebUri('https://a.dev/bootstrap/'),
      );

      expect(web.loadedUrls, ['https://a.dev/bootstrap/']);
      final settled = web.nextCall('Fetch.fulfillRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'html-1',
          'request': {'url': 'https://a.dev/bootstrap/'},
        },
      });
      await settled;
      expect(
        _paramsOf(web, 'Fetch.fulfillRequest'),
        containsPair('requestId', 'html-1'),
      );
      final body = _paramsOf(web, 'Fetch.fulfillRequest')['body'] as String;
      expect(base64Decode(body), utf8.encode(html));
    });

    test('leaves the data untouched when no baseUrl is given', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadData(data: '<!DOCTYPE html><p>x</p>');

      final source = Uri.parse(web.loadedUrls.single).data!.contentAsString();
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

  group('Fetch.requestPaused listener registration', () {
    test('registers the interceptor listener once, not once per load', () async {
      final web = _FakeWebviewController();
      final controller = _buildControllerWithNavigationPolicy(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/one')),
      );
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/two')),
      );

      // The native side refuses a duplicate registration, so a second add is a
      // PlatformException rather than a no-op.
      expect(web.addedListeners, <String>['Fetch.requestPaused']);
      expect(web.registeredListeners, <String>{'Fetch.requestPaused'});
    });

    test('a second navigation still loads when a policy is registered', () async {
      final web = _FakeWebviewController();
      final controller = _buildControllerWithNavigationPolicy(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/one')),
      );
      final first = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'first',
          'request': {'url': 'https://example.com/one', 'headers': {}},
        },
      });
      await first;

      // Before the registration guard this threw PlatformException(method_failed)
      // and the navigation never reached loadUrl.
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/two')),
      );
      expect(web.loadedUrls, <String>[
        'https://example.com/one',
        'https://example.com/two',
      ]);
    });

    test('loadData twice renders both documents', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadData(
        data: '<p>one</p>',
        baseUrl: WebUri('https://a.dev/one'),
      );
      await controller.loadData(
        data: '<p>two</p>',
        baseUrl: WebUri('https://a.dev/two'),
      );

      expect(web.addedListeners, <String>['Fetch.requestPaused']);
      expect(
        web.loadedUrls,
        <String>['https://a.dev/one', 'https://a.dev/two'],
      );
    });

    test('an application subscription to the same event is not re-added', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addDevToolsProtocolEventListener(
        eventName: 'Fetch.requestPaused',
        callback: (_) {},
      );
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com/'),
          headers: const {'X-One': '1'},
        ),
      );

      expect(web.addedListeners, <String>['Fetch.requestPaused']);
    });
  });

  group('shouldOverrideUrlLoading over the Fetch boundary', () {
    test('ALLOW continues the request', () async {
      final web = _FakeWebviewController();
      final controller = _buildControllerWithNavigationPolicy(
        web,
        policy: NavigationActionPolicy.ALLOW,
      );
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/')),
      );
      final settled = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'allow-1',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(_paramsOf(web, 'Fetch.continueRequest')['requestId'], 'allow-1');
      expect(web.calls, isNot(contains('Fetch.failRequest')));
    });

    test('CANCEL fails the request with Aborted', () async {
      final web = _FakeWebviewController();
      final controller = _buildControllerWithNavigationPolicy(
        web,
        policy: NavigationActionPolicy.CANCEL,
      );
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/')),
      );
      final settled = web.nextCall('Fetch.failRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'cancel-1',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(_paramsOf(web, 'Fetch.failRequest'), {
        'requestId': 'cancel-1',
        'errorReason': 'Aborted',
      });
      expect(web.calls, isNot(contains('Fetch.continueRequest')));
    });

    test('CANCEL leaves no headers armed for a later navigation', () async {
      final web = _FakeWebviewController();
      var policy = NavigationActionPolicy.CANCEL;
      final controller = _buildControllerWithNavigationPolicy(
        web,
        onNavigation: (_) async => policy,
      );
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com/'),
          headers: const {'Authorization': 'Bearer cancelled'},
        ),
      );
      final cancelled = web.nextCall('Fetch.failRequest').timeout(
        const Duration(seconds: 5),
      );
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'cancel-2',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await cancelled;

      expect(_paramsOf(web, 'Fetch.failRequest'), {
        'requestId': 'cancel-2',
        'errorReason': 'Aborted',
      });
      // Policy still owns interception after the one-shot headers are consumed.
      // A later browser request must not inherit the cancelled authorization.
      policy = NavigationActionPolicy.ALLOW;
      final continued = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'later',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await continued;
      expect(_paramsOf(web, 'Fetch.continueRequest'), {'requestId': 'later'});
      expect(web.calls, isNot(contains('Fetch.disable')));
    });

    test('reports a subframe document load as not the main frame', () async {
      final web = _FakeWebviewController();
      final seen = <NavigationAction>[];
      final controller = _buildControllerWithNavigationPolicy(
        web,
        onNavigation: (action) async {
          seen.add(action);
          return NavigationActionPolicy.ALLOW;
        },
      );
      web.results['Page.getFrameTree'] = () async =>
          {'frameTree': {'frame': {'id': 'main-frame'}}};
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/')),
      );
      final settled = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'sub-1',
          'frameId': 'iframe-7',
          'request': {'url': 'https://example.com/iframe', 'headers': {}},
        },
      });
      await settled;

      expect(seen.single.isForMainFrame, isFalse);
    });

    test('reports a top-level document load as the main frame', () async {
      final web = _FakeWebviewController();
      final seen = <NavigationAction>[];
      final controller = _buildControllerWithNavigationPolicy(
        web,
        onNavigation: (action) async {
          seen.add(action);
          return NavigationActionPolicy.ALLOW;
        },
      );
      web.results['Page.getFrameTree'] = () async =>
          {'frameTree': {'frame': {'id': 'main-frame'}}};
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/')),
      );
      final settled = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'main-1',
          'frameId': 'main-frame',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(seen.single.isForMainFrame, isTrue);
    });
  });

  group('pending loadData documents', () {
    test('a later loadUrl abandons the outstanding document', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadData(
        data: '<p>never rendered</p>',
        baseUrl: WebUri('https://a.dev/stale'),
      );
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://a.dev/fresh')),
      );

      final settled = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'after-1',
          'request': {'url': 'https://a.dev/stale', 'headers': {}},
        },
      });
      await settled;

      // The stale document must not be fulfilled for a later navigation.
      expect(web.calls, isNot(contains('Fetch.fulfillRequest')));
      expect(_paramsOf(web, 'Fetch.continueRequest')['requestId'], 'after-1');
    });
  });

  group('user scripts', () {
    test('addUserScript registers the source and removeUserScript undoes it', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      final script = UserScript(
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        source: 'window.__marked = true;',
        forMainFrameOnly: false,
      );
      await controller.addUserScript(userScript: script);

      expect(web.addedScripts, <String>['window.__marked = true;']);

      expect(await controller.removeUserScript(userScript: script), isTrue);
      expect(web.removedScriptIds, <String>['script-0']);
      expect(await controller.removeUserScript(userScript: script), isFalse);
      expect(web.removedScriptIds, <String>['script-0']);
    });

    test('addUserScript rejects AT_DOCUMENT_END', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await expectLater(
        controller.addUserScript(
          userScript: UserScript(
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
            source: 'window.__late = true;',
            forMainFrameOnly: false,
          ),
        ),
        throwsUnsupportedError,
      );
      expect(web.addedScripts, isEmpty);
    });

    test('addUserScripts registers nothing when one entry is unsupported', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await expectLater(
        controller.addUserScripts(
          userScripts: [
            UserScript(
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
              source: 'window.__first = true;',
              forMainFrameOnly: false,
            ),
            UserScript(
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
              source: 'window.__second = true;',
              forMainFrameOnly: false,
            ),
          ],
        ),
        throwsUnsupportedError,
      );

      expect(web.addedScripts, isEmpty);
    });

    test('removeAllUserScripts drains every registered script', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScripts(
        userScripts: [
          UserScript(
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
            source: 'window.__a = true;',
            forMainFrameOnly: false,
          ),
          UserScript(
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
            source: 'window.__b = true;',
            forMainFrameOnly: false,
          ),
        ],
      );
      await controller.removeAllUserScripts();

      expect(web.removedScriptIds, <String>['script-0', 'script-1']);
      expect(
        await controller.removeUserScript(
          userScript: UserScript(
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
            source: 'window.__a = true;',
            forMainFrameOnly: false,
          ),
        ),
        isFalse,
      );
    });

    test('removeUserScriptsByGroupName only drops that group', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      final first = UserScript(
        groupName: 'capture',
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        source: 'window.__a = true;',
        forMainFrameOnly: false,
      );
      final second = UserScript(
        groupName: 'other',
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        source: 'window.__b = true;',
        forMainFrameOnly: false,
      );
      await controller.addUserScripts(userScripts: [first, second]);
      await controller.removeUserScriptsByGroupName(groupName: 'capture');

      expect(web.removedScriptIds, <String>['script-0']);
      expect(await controller.removeUserScript(userScript: second), isTrue);
      expect(web.removedScriptIds, <String>['script-0', 'script-1']);
    });

    test('the same script registered twice is removed twice', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      final script = UserScript(
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        source: 'window.__twice = true;',
        forMainFrameOnly: false,
      );
      await controller.addUserScript(userScript: script);
      await controller.addUserScript(userScript: script);

      expect(web.addedScripts, hasLength(2));
      expect(await controller.removeUserScript(userScript: script), isTrue);
      expect(web.removedScriptIds, <String>['script-0', 'script-1']);
    });

    test('forMainFrameOnly guards the source', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(
        userScript: UserScript(
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          source: 'window.__top = true;',
        ),
      );

      expect(web.addedScripts.single, contains('window === window.top'));
      expect(web.addedScripts.single, contains('window.__top = true;'));
    });

    test('allowedOriginRules narrow the source to those origins', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(
        userScript: UserScript(
          allowedOriginRules: {'https://a.dev/*'},
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          source: 'window.__scoped = true;',
          forMainFrameOnly: false,
        ),
      );

      final source = web.addedScripts.single;
      expect(source, isNot('window.__scoped = true;'));
      // The rule is JSON-encoded into the guard, so the pattern's backslash
      // arrives doubled: `https://a\\.dev/.*` inside the JavaScript literal.
      expect(source, contains(r'https://a\\.dev/.*'));
      expect(source, contains('new RegExp'));
      expect(source, contains('window.__scoped = true;'));
    });

    test('an all-origins script is registered verbatim', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(
        userScript: UserScript(
          allowedOriginRules: {'*'},
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          source: 'window.__plain = true;',
          forMainFrameOnly: false,
        ),
      );

      expect(web.addedScripts, <String>['window.__plain = true;']);
    });
  });
}
