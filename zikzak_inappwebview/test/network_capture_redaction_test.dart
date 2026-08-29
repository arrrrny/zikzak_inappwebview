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
  });
}
