import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview/src/in_app_webview/network_capture/secret_redactor.dart';

void main() {
  group('Network Capture secret redaction at source (FR-007 / SC-004)', () {
    test('redacts Authorization and session Cookie headers before any consumer '
        '(A13/A14)', () {
      const token = 's3cr3t-token-12345';
      const session = 'abc123session';

      final request = NetworkRequest(
        requestId: 'r1',
        url: WebUri('https://api.example.com/login'),
        method: 'POST',
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Cookie': 'session=$session; csrf=xyz',
          'X-Other': 'keep-me',
        },
        resourceType: ResourceType.fetch,
      );

      final redacted = redactRequest(request);

      // A13: the Authorization header value is the marker, never the token.
      expect(redacted.headers['Authorization'], equals(kRedactionMarker));
      expect(redacted.headers['Authorization'], isNot(contains(token)));

      // A14: the session cookie value is redacted, not the whole header key.
      expect(redacted.headers['Cookie'], equals(kRedactionMarker));
      expect(redacted.headers['Cookie'], isNot(contains(session)));

      // Non-secret headers survive untouched.
      expect(redacted.headers['X-Other'], equals('keep-me'));
    });

    test('redacts auth-shaped URL query and body params before any consumer '
        '(A15)', () {
      const apiKey = 'AKIA-SECRET-12345';
      const password = 'hunter2-pass';

      final request = NetworkRequest(
        requestId: 'r2',
        url: WebUri(
          'https://api.example.com/login?api_key=$apiKey&password=$password&scope=read',
        ),
        method: 'POST',
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'api_key=$apiKey&password=$password&scope=read',
        resourceType: ResourceType.fetch,
      );

      final redacted = redactRequest(request);

      // Secret values must never appear in the URL string.
      final redactedUrl = redacted.url.toString();
      expect(redactedUrl, isNot(contains(apiKey)));
      expect(redactedUrl, isNot(contains(password)));

      // Decoded query param values are replaced by the marker; non-secret
      // params survive. (The marker is URL-encoded in the raw string but
      // decodes back to the marker, which is what every consumer reads.)
      final decoded = Uri.parse(redactedUrl).queryParameters;
      expect(decoded['api_key'], equals(kRedactionMarker));
      expect(decoded['password'], equals(kRedactionMarker));
      expect(decoded['scope'], equals('read'));

      // Body param values are redacted; non-secret param survives.
      expect(redacted.body, isNot(contains(apiKey)));
      expect(redacted.body, isNot(contains(password)));
      expect(redacted.body, contains(kRedactionMarker));
      expect(redacted.body, contains('scope=read'));
    });
  });
}
