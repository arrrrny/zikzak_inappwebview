import 'dart:async';
import 'dart:convert';

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

  /// Scripts registered via [addScriptToExecuteOnDocumentCreated], in order.
  /// Each entry is `[id, source]`; [removeScriptToExecuteOnDocumentCreated]
  /// removes the matching id.
  final List<List<String>> scripts = [];
  int _nextScriptId = 0;

  /// Event names already registered, mirroring the native
  /// `devtools_protocol_event_listeners_` set: a duplicate registration
  /// throws, the same contract `webview.cc`'s
  /// `AddDevToolsProtocolEventListener` enforces (returns `false` →
  /// `Error(kMethodFailed)`).
  final Set<String> _registeredListeners = <String>{};

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
  Future<void> addDevToolsProtocolEventListener(String eventName) async {
    // Mirror the native duplicate-registration refusal.
    if (!_registeredListeners.add(eventName)) {
      throw StateError('listener "$eventName" already registered');
    }
    addedListeners.add(eventName);
  }

  @override
  Future<void> removeDevToolsProtocolEventListener(String eventName) async {
    _registeredListeners.remove(eventName);
    removedListeners.add(eventName);
  }

  @override
  Future<String?> addScriptToExecuteOnDocumentCreated(String script) async {
    final id = 'script-${_nextScriptId++}';
    scripts.add([id, script]);
    return id;
  }

  @override
  Future<void> removeScriptToExecuteOnDocumentCreated(String scriptId) async {
    scripts.removeWhere((entry) => entry.first == scriptId);
  }

  @override
  Future<void> stop() async => calls.add('stop');

  Future<void> close() async {
    await _events.close();
    await _calls.close();
  }
}

InAppWebViewWindowsController _buildController(
  _FakeWebviewController webviewController, {
  PlatformInAppWebViewControllerCreationParams? params,
}) {
  final resolved =
      params ?? PlatformInAppWebViewControllerCreationParams(id: 0);
  return InAppWebViewWindowsController(resolved, webviewController);
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

  group('Fetch listener registration (duplicate-registration regression)', () {
    test(
      'a second fetch-enabled load does not throw on the native side',
      () async {
        final web = _FakeWebviewController();
        // A callback-gated navigation: the branch the PR made default. There is
        // no navigation callback to invoke here (the request is continued), so
        // the point is purely that the second enable does not re-register the
        // native listener and throw.
        final params = PlatformInAppWebViewControllerCreationParams(
          id: 0,
          webviewParams: PlatformInAppWebViewWidgetCreationParams(
            shouldOverrideUrlLoading: (_, _) async =>
                NavigationActionPolicy.ALLOW,
          ),
        );
        final controller = _buildController(web, params: params);
        addTearDown(controller.dispose);
        addTearDown(web.close);

        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri('https://example.com/one')),
        );
        // Drain the first navigation so the second is a fresh enable.
        final firstSettled = web.nextCall('Fetch.disable');
        web.emit({
          'eventName': 'Fetch.requestPaused',
          'data': {
            'requestId': 'first',
            'request': {'url': 'https://example.com/one', 'headers': {}},
          },
        });
        await firstSettled;

        // The second navigation is the case that used to throw
        // PlatformException(method_failed) because the native listener was
        // already registered.
        await expectLater(
          controller.loadUrl(
            urlRequest: URLRequest(url: WebUri('https://example.com/two')),
          ),
          completes,
        );
        expect(web.loadedUrls, hasLength(2));
        // The listener was registered once, not twice.
        expect(
          web.addedListeners.where((e) => e == 'Fetch.requestPaused'),
          hasLength(1),
        );
      },
    );

    test('loadData registers the listener only once across two renders', () {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      return Future<void>.delayed(Duration.zero).then((_) async {
        await controller.loadData(
          data: '<p>one</p>',
          baseUrl: WebUri('https://a.dev/'),
        );
        await controller.loadData(
          data: '<p>two</p>',
          baseUrl: WebUri('https://a.dev/'),
        );
        // One registration for the controller's lifetime, not two.
        expect(
          web.addedListeners.where((e) => e == 'Fetch.requestPaused'),
          hasLength(1),
        );
      });
    });
  });

  group('shouldOverrideUrlLoading navigation policy', () {
    PlatformInAppWebViewControllerCreationParams _callbackParams({
      required Future<NavigationActionPolicy?> Function(
        dynamic controller,
        NavigationAction action,
      )
      callback,
    }) {
      return PlatformInAppWebViewControllerCreationParams(
        id: 0,
        webviewParams: PlatformInAppWebViewWidgetCreationParams(
          shouldOverrideUrlLoading: callback,
        ),
      );
    }

    test('CANCEL produces Fetch.failRequest with errorReason Aborted', () async {
      final web = _FakeWebviewController();
      final params = _callbackParams(
        callback: (_, _) async => NavigationActionPolicy.CANCEL,
      );
      final controller = _buildController(web, params: params);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://example.com/'),
          headers: const {'Authorization': 'Bearer x'},
        ),
      );
      final settled = web.nextCall('Fetch.failRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'nav-1',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(_paramsOf(web, 'Fetch.failRequest'), {
        'requestId': 'nav-1',
        'errorReason': 'Aborted',
      });
    });

    test('ALLOW produces Fetch.continueRequest', () async {
      final web = _FakeWebviewController();
      final params = _callbackParams(
        callback: (_, _) async => NavigationActionPolicy.ALLOW,
      );
      final controller = _buildController(web, params: params);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/')),
      );
      final settled = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'nav-2',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(_paramsOf(web, 'Fetch.continueRequest')['requestId'], 'nav-2');
      expect(web.calls, isNot(contains('Fetch.failRequest')));
    });

    test(
      'a CANCELled navigation does not leave its headers armed for a later URL',
      () async {
        final web = _FakeWebviewController();
        // First request is cancelled, the later one is allowed.
        var allow = false;
        final params = _callbackParams(
          callback: (_, _) async =>
              allow ? NavigationActionPolicy.ALLOW : NavigationActionPolicy.CANCEL,
        );
        final controller = _buildController(web, params: params);
        addTearDown(controller.dispose);
        addTearDown(web.close);

        await controller.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://example.com/'),
            headers: const {'Authorization': 'Bearer cancelled'},
          ),
        );
        final cancelled = web.nextCall('Fetch.failRequest');
        web.emit({
          'eventName': 'Fetch.requestPaused',
          'data': {
            'requestId': 'nav-3',
            'request': {'url': 'https://example.com/', 'headers': {}},
          },
        });
        await cancelled;

        // A later ALLOW navigation to the same URL must not carry the
        // cancelled request's headers.
        allow = true;
        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri('https://example.com/')),
        );
        final continued = web.nextCall('Fetch.continueRequest');
        web.emit({
          'eventName': 'Fetch.requestPaused',
          'data': {
            'requestId': 'nav-4',
            'request': {'url': 'https://example.com/', 'headers': {}},
          },
        });
        await continued;

        final continuedParams = _paramsOf(web, 'Fetch.continueRequest');
        expect(continuedParams.containsKey('headers'), isFalse);
      },
    );

    test('reports isForMainFrame=false for a subframe request', () async {
      final web = _FakeWebviewController();
      final seen = <NavigationAction>[];
      final params = _callbackParams(
        callback: (_, action) async {
          seen.add(action);
          return NavigationActionPolicy.ALLOW;
        },
      );
      final controller = _buildController(web, params: params);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/')),
      );
      final settled = web.nextCall('Fetch.continueRequest');
      web.emit({
        'eventName': 'Fetch.requestPaused',
        'data': {
          'requestId': 'nav-5',
          'frameId': 'subframe-7',
          'request': {'url': 'https://example.com/', 'headers': {}},
        },
      });
      await settled;

      expect(seen, hasLength(1));
      expect(seen.single.isForMainFrame, isFalse);
    });
  });

  group('user scripts (AT_DOCUMENT_START)', () {
    UserScript _script({
      String source = 'console.log(1);',
      UserScriptInjectionTime injectionTime =
          UserScriptInjectionTime.AT_DOCUMENT_START,
      bool forMainFrameOnly = true,
      Set<String> allowedOriginRules = const {'*'},
      String? groupName,
    }) {
      return UserScript(
        source: source,
        injectionTime: injectionTime,
        forMainFrameOnly: forMainFrameOnly,
        allowedOriginRules: allowedOriginRules,
        groupName: groupName,
      );
    }

    test('addUserScript stores the id; removeUserScript forwards it', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      final script = _script();
      await controller.addUserScript(userScript: script);
      expect(web.scripts, hasLength(1));
      // The default forMainFrameOnly wraps the source; assert the source is
      // present and a frame guard was added.
      expect(web.scripts.single[1], contains(script.source));
      expect(web.scripts.single[1], isNot(script.source));

      final removed = await controller.removeUserScript(userScript: script);
      expect(removed, isTrue);
      expect(web.scripts, isEmpty);
    });

    test('removeUserScript returns false for an unknown script', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      final removed = await controller.removeUserScript(
        userScript: _script(source: 'never-added'),
      );
      expect(removed, isFalse);
    });

    test('addUserScript with AT_DOCUMENT_END throws UnsupportedError', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await expectLater(
        controller.addUserScript(
          userScript: _script(
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
          ),
        ),
        throwsUnsupportedError,
      );
    });

    test('two identical scripts are both removable (value collision)', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      final script = _script(source: 'console.log("same");');
      await controller.addUserScript(userScript: script);
      await controller.addUserScript(userScript: script);
      expect(web.scripts, hasLength(2));

      final removed = await controller.removeUserScript(userScript: script);
      expect(removed, isTrue);
      // Every registered id must be gone, not just one.
      expect(web.scripts, isEmpty);
    });

    test('addUserScripts rolls back the batch when one script is invalid', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await expectLater(
        controller.addUserScripts(
          userScripts: [
            _script(source: 'first'),
            _script(
              source: 'second',
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
            ),
          ],
        ),
        throwsUnsupportedError,
      );
      // Nothing stays injected.
      expect(web.scripts, isEmpty);
    });

    test('removeAllUserScripts drains every registered script', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(userScript: _script(source: 'a'));
      await controller.addUserScript(userScript: _script(source: 'b'));
      expect(web.scripts, hasLength(2));

      await controller.removeAllUserScripts();
      expect(web.scripts, isEmpty);
    });

    test('removeUserScriptsByGroupName removes only that group', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(
        userScript: _script(source: 'a', groupName: 'keep'),
      );
      await controller.addUserScript(
        userScript: _script(source: 'b', groupName: 'drop'),
      );

      await controller.removeUserScriptsByGroupName(groupName: 'drop');
      final remaining = web.scripts.map((e) => e[1]).toList();
      expect(remaining, isNot(contains('b')));
      expect(remaining.any((s) => s.contains('a')), isTrue);
    });

    test('forMainFrameOnly=false leaves the source unwrapped', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(
        userScript: _script(source: 'BODY', forMainFrameOnly: false),
      );
      expect(web.scripts.single[1], 'BODY');
    });

    test('forMainFrameOnly=true (default) wraps the source in a frame guard', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(
        userScript: _script(source: 'BODY', forMainFrameOnly: true),
      );
      final registered = web.scripts.single[1];
      expect(registered, isNot('BODY'));
      expect(registered, contains('window.top'));
      expect(registered, contains('BODY'));
    });

    test('allowedOriginRules narrows the source with an origin check', () async {
      final web = _FakeWebviewController();
      final controller = _buildController(web);
      addTearDown(controller.dispose);
      addTearDown(web.close);

      await controller.addUserScript(
        userScript: _script(
          source: 'BODY',
          forMainFrameOnly: false,
          allowedOriginRules: const {'https://trusted.example'},
        ),
      );
      final registered = web.scripts.single[1];
      expect(registered, isNot('BODY'));
      expect(registered, contains('document.location.origin'));
      expect(registered, contains('https://trusted.example'));
      expect(registered, contains('BODY'));
    });
  });
}
