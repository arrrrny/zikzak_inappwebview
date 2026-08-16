// Public-API regression tests for the network capture model family
// (hand-written fork — NetworkEntry/Request/Response/Body + the
// NetworkCaptureController accumulator + ResourceType/UrlPatternType).
// Pins the consumer-visible contract:
//   - constructor defaults + toMap wire format (url as string, resourceType
//     native value, headers as String maps)
//   - fromMap null-tolerance + round-trips
//   - NetworkResponseBody.decoded / .bytes helpers
//   - NetworkCaptureController accumulation, pending-out-of-order events,
//     filtering, clear
//   - ResourceType / UrlPatternType lookup + equality
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ResourceType', () {
    test('values + lookup + equality', () {
      expect(ResourceType.values, hasLength(9));
      expect(ResourceType.xhr.toValue(), 'xhr');
      expect(ResourceType.xhr.toNativeValue(), 'xhr');
      expect(ResourceType.fromValue('fetch'), ResourceType.fetch);
      expect(ResourceType.fromNativeValue('document'), ResourceType.document);
      expect(ResourceType.fromValue('nope'), isNull);
      expect(ResourceType.fromValue(null), isNull);
      expect(ResourceType.other, equals(ResourceType.fromValue('other')));
      expect(ResourceType.other.toString(), 'other');
    });
  });

  group('UrlPatternType', () {
    test('values + lookup', () {
      expect(UrlPatternType.substring.toValue(), 'substring');
      expect(UrlPatternType.regex.toNativeValue(), 'regex');
      expect(UrlPatternType.fromValue('regex'), UrlPatternType.regex);
      expect(UrlPatternType.fromValue('bogus'), isNull);
    });
  });

  group('NetworkRequest', () {
    test('defaults + toMap wire format', () {
      final r = NetworkRequest(url: WebUri('https://a.dev/api?x=1'));
      final map = r.toMap();
      expect(map['requestId'], '');
      expect(map['url'], 'https://a.dev/api?x=1');
      expect(map['method'], 'GET');
      expect(map['headers'], isEmpty);
      expect(map['body'], isNull);
      expect(map['bodyIsBinary'], false);
      expect(map['resourceType'], 'other');
      expect(map['timestamp'], isA<int>());
    });

    test('fromMap null-tolerance + round-trip', () {
      expect(NetworkRequest.fromMap(null), isNull);
      expect(NetworkRequest.fromMap({'method': 'POST'}), isNull); // no url
      final r = NetworkRequest(
        requestId: 'r1',
        url: WebUri('https://a.dev/p'),
        method: 'POST',
        headers: {'content-type': 'application/json'},
        body: '{"a":1}',
        bodyIsBinary: false,
        resourceType: ResourceType.xhr,
        timestamp: 5,
      );
      final back = NetworkRequest.fromMap(r.toMap());
      expect(back!.requestId, 'r1');
      expect(back.url.toString(), 'https://a.dev/p');
      expect(back.method, 'POST');
      expect(back.headers, {'content-type': 'application/json'});
      expect(back.body, '{"a":1}');
      expect(back.resourceType, ResourceType.xhr);
      expect(back.timestamp, 5);
    });
  });

  group('NetworkResponse', () {
    test('defaults + round-trip', () {
      final r = NetworkResponse(url: WebUri('https://a.dev/r'));
      expect(r.statusCode, 0);
      expect(r.statusText, '');
      expect(r.mimeType, '');
      expect(r.duration, 0);
      expect(r.fromCache, false);
      expect(r.fromServiceWorker, false);
      final map = r.toMap();
      expect(map['url'], 'https://a.dev/r');
      expect(map['resourceType'], 'other');

      final full = NetworkResponse(
        requestId: 'r1',
        url: WebUri('https://a.dev/full'),
        statusCode: 200,
        statusText: 'OK',
        headers: {'x-a': 'b'},
        mimeType: 'application/json',
        resourceType: ResourceType.fetch,
        timestamp: 10,
        duration: 30,
        fromCache: true,
        fromServiceWorker: false,
      );
      final back = NetworkResponse.fromMap(full.toMap())!;
      expect(back.statusCode, 200);
      expect(back.headers, {'x-a': 'b'});
      expect(back.resourceType, ResourceType.fetch);
      expect(back.duration, 30);
      expect(back.fromCache, true);
    });
  });

  group('NetworkResponseBody', () {
    test('decoded parses JSON lazily + caches', () {
      final b = NetworkResponseBody(
        url: WebUri('https://a.dev/b'),
        body: '{"k": [1, 2]}',
      );
      expect(b.decoded, {'k': [1, 2]});
      // cached: same instance
      expect(identical(b.decoded, b.decoded), isTrue);
      final bad = NetworkResponseBody(url: WebUri('https://a.dev/x'), body: 'not json');
      expect(bad.decoded, isNull);
      final base64 = NetworkResponseBody(
        url: WebUri('https://a.dev/y'),
        body: 'aGVsbG8=',
        isBase64: true,
      );
      expect(base64.decoded, isNull);
      expect(base64.bytes, [104, 101, 108, 108, 111]);
    });

    test('bytes null when not base64; fromMap round-trip', () {
      final b = NetworkResponseBody(url: WebUri('https://a.dev/z'), body: 'text');
      expect(b.bytes, isNull);
      final full = NetworkResponseBody(
        requestId: 'r1',
        url: WebUri('https://a.dev/full'),
        body: 'abc',
        isBase64: false,
        size: 3,
        truncated: true,
        mimeType: 'text/plain',
      );
      final back = NetworkResponseBody.fromMap(full.toMap())!;
      expect(back.requestId, 'r1');
      expect(back.body, 'abc');
      expect(back.size, 3);
      expect(back.truncated, true);
      expect(back.mimeType, 'text/plain');
      expect(NetworkResponseBody.fromMap({'url': null}), isNull);
    });
  });

  group('NetworkEntry', () {
    test('hasError + isComplete', () {
      final entry = NetworkEntry(
        request: NetworkRequest(url: WebUri('https://a.dev/')),
      );
      expect(entry.hasError, false);
      expect(entry.isComplete, false);
      entry.error = 'net::ERR_FAILED';
      expect(entry.hasError, true);
      expect(entry.isComplete, true);
      entry.error = null;
      entry.response = NetworkResponse(url: WebUri('https://a.dev/'));
      expect(entry.isComplete, true);
    });

    test('toMap nests request/response/body', () {
      final entry = NetworkEntry(
        request: NetworkRequest(requestId: 'r', url: WebUri('https://a.dev/')),
        response: NetworkResponse(
          requestId: 'r',
          url: WebUri('https://a.dev/'),
          statusCode: 200,
        ),
        responseBody: NetworkResponseBody(
          requestId: 'r',
          url: WebUri('https://a.dev/'),
          body: '{}',
        ),
      );
      final map = entry.toMap();
      expect(map['request'], isA<Map<String, dynamic>>());
      expect(map['response'], isA<Map<String, dynamic>>());
      expect(map['responseBody'], isA<Map<String, dynamic>>());
      expect(map['error'], isNull);
    });
  });

  group('NetworkCaptureController', () {
    test('accumulates entries + dedupes request ids', () {
      final c = NetworkCaptureController();
      c.trackRequest(NetworkRequest(requestId: 'a', url: WebUri('https://a.dev/1')));
      c.trackRequest(NetworkRequest(requestId: 'a', url: WebUri('https://a.dev/2')));
      expect(c.count, 1);
      expect(c.getEntries(), isA<Future<List<NetworkEntry>>>());
    });

    test('response/body before request are pending then attached', () async {
      final c = NetworkCaptureController();
      c.attachResponse(
        NetworkResponse(requestId: 'b', url: WebUri('https://b.dev/'), statusCode: 200),
      );
      c.attachBody(
        NetworkResponseBody(requestId: 'b', url: WebUri('https://b.dev/'), body: '{}'),
      );
      expect(c.count, 0);
      c.trackRequest(NetworkRequest(requestId: 'b', url: WebUri('https://b.dev/')));
      final entries = await c.getEntries();
      expect(c.count, 1);
      expect(entries.single.response?.statusCode, 200);
      expect(entries.single.responseBody?.body, '{}');
    });

    test('attachError flags the entry', () async {
      final c = NetworkCaptureController();
      c.trackRequest(NetworkRequest(requestId: 'c', url: WebUri('https://c.dev/')));
      c.attachError('c', 'timeout');
      final entries = await c.getEntries();
      expect(entries.single.hasError, true);
      expect(entries.single.error, 'timeout');
    });

    test('getEntries filters by url/mime/resource/body', () async {
      final c = NetworkCaptureController();
      c.trackRequest(
        NetworkRequest(requestId: '1', url: WebUri('https://api.dev/users')),
      );
      c.attachResponse(
        NetworkResponse(
          requestId: '1',
          url: WebUri('https://api.dev/users'),
          mimeType: 'application/json',
        ),
      );
      c.trackRequest(
        NetworkRequest(
          requestId: '2',
          url: WebUri('https://cdn.dev/style.css'),
          resourceType: ResourceType.stylesheet,
        ),
      );
      c.attachResponse(
        NetworkResponse(
          requestId: '2',
          url: WebUri('https://cdn.dev/style.css'),
          mimeType: 'text/css',
        ),
      );

      expect((await c.getEntries(urlPatterns: ['API.'])).map((e) => e.request.requestId), ['1']);
      expect((await c.getEntries(mimeTypes: ['css'])).map((e) => e.request.requestId), ['2']);
      expect(
        (await c.getEntries(resourceTypes: [ResourceType.stylesheet]))
            .map((e) => e.request.requestId),
        ['2'],
      );
      expect(await c.getEntries(withBodyOnly: true), isEmpty);
      expect((await c.getBodies(mimeTypes: ['json'])), isEmpty);
    });

    test('clear resets everything', () async {
      final c = NetworkCaptureController();
      c.trackRequest(NetworkRequest(requestId: 'a', url: WebUri('https://a.dev/')));
      c.attachResponse(
        NetworkResponse(requestId: 'x', url: WebUri('https://x.dev/')),
      );
      expect(c.count, 1);
      c.clear();
      expect(c.count, 0);
      // pending response is dropped too
      c.trackRequest(NetworkRequest(requestId: 'x', url: WebUri('https://x.dev/')));
      expect((await c.getEntries()).single.response, isNull);
    });

    test('waitForIdle returns when quiet', () async {
      final c = NetworkCaptureController();
      c.trackRequest(NetworkRequest(requestId: 'a', url: WebUri('https://a.dev/')));
      await c.waitForIdle(quietDuration: const Duration(milliseconds: 50));
    }, timeout: const Timeout(Duration(seconds: 10)));
  });
}
