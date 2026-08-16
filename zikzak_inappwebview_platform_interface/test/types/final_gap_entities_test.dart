// Public-API regression tests for the last uncovered valueObjects + enums:
// css_link_html_tag_attributes, the js-dialogue requests (before-unload /
// confirm / prompt), pdf_configuration, ssl_certificate_dname,
// url_protection_space_http_auth_credentials, and the CustomTabs enums.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('CSSLinkHtmlTagAttributes', () {
    test('wire + round-trip', () {
      final a = CSSLinkHtmlTagAttributes(
        id: 'l1',
        media: 'screen',
        crossOrigin: CrossOrigin.ANONYMOUS,
        integrity: 'sha256-x',
        referrerPolicy: ReferrerPolicy.ORIGIN,
        disabled: true,
        alternate: false,
        title: 't',
      );
      final map = a.toJson();
      expect(map['id'], 'l1');
      expect(map['media'], 'screen');
      expect(map['crossOrigin'], 'anonymous');
      expect(map['integrity'], 'sha256-x');
      expect(map['referrerPolicy'], 'origin');
      expect(map['disabled'], true);
      expect(map['alternate'], false);
      expect(map['title'], 't');
      final back = CSSLinkHtmlTagAttributes.fromJson(map);
      expect(back.crossOrigin, CrossOrigin.ANONYMOUS);
      expect(back.referrerPolicy, ReferrerPolicy.ORIGIN);
      expect(back.id, 'l1');
    });
  });

  group('JsBeforeUnloadRequest', () {
    test('wire + round-trip', () {
      final r = JsBeforeUnloadRequest(
        url: WebUri('https://a.dev/'),
        message: 'leave?',
      );
      expect(r.toJson(), {'url': 'https://a.dev/', 'message': 'leave?'});
      final back = JsBeforeUnloadRequest.fromJson(r.toJson());
      expect(back.url?.toString(), 'https://a.dev/');
      expect(back.message, 'leave?');
    });
  });

  group('JsConfirmRequest', () {
    test('wire + round-trip', () {
      final r = JsConfirmRequest(
        url: WebUri('https://a.dev/'),
        message: 'ok?',
        isMainFrame: true,
      );
      expect(r.toJson(), {
        'url': 'https://a.dev/',
        'message': 'ok?',
        'isMainFrame': true,
      });
      final back = JsConfirmRequest.fromJson(r.toJson());
      expect(back.isMainFrame, true);
      expect(back.message, 'ok?');
    });
  });

  group('JsPromptRequest', () {
    test('wire + round-trip', () {
      final r = JsPromptRequest(
        url: WebUri('https://a.dev/'),
        message: 'value?',
        defaultValue: 'd',
        isMainFrame: false,
      );
      expect(r.toJson(), {
        'url': 'https://a.dev/',
        'message': 'value?',
        'defaultValue': 'd',
        'isMainFrame': false,
      });
      final back = JsPromptRequest.fromJson(r.toJson());
      expect(back.defaultValue, 'd');
      expect(back.isMainFrame, false);
    });
  });

  group('PDFConfiguration', () {
    test('wire: rect as nested map', () {
      final c = PDFConfiguration(
        rect: InAppWebViewRect(x: 0, y: 1, width: 100, height: 50),
      );
      expect(c.toJson(), {
        'rect': {'x': 0.0, 'y': 1.0, 'width': 100.0, 'height': 50.0},
      });
      final back = PDFConfiguration.fromJson(c.toJson());
      expect(back.rect?.height, 50.0);
      expect(PDFConfiguration.fromJson({}).rect, isNull);
    });
  });

  group('SslCertificateDName', () {
    test('wire + round-trip', () {
      final d = SslCertificateDName(
        CName: 'c',
        DName: 'd',
        OName: 'o',
        UName: 'u',
      );
      expect(d.toJson(), {'CName': 'c', 'DName': 'd', 'OName': 'o', 'UName': 'u'});
      final back = SslCertificateDName.fromJson(d.toJson());
      expect(back.CName, 'c');
      expect(back.UName, 'u');
    });
  });

  group('URLProtectionSpaceHttpAuthCredentials', () {
    test('wire nests protectionSpace + credentials', () {
      final c = URLProtectionSpaceHttpAuthCredentials(
        protectionSpace: URLProtectionSpace(
          host: 'a.dev',
          port: 443,
          protocol: 'https',
          realm: 'r',
          authenticationMethod:
              URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_SERVER_TRUST,
        ),
        credentials: [
          URLCredential(
            username: 'u',
            password: 'p',
            persistence: URLCredentialPersistence.FOR_SESSION,
          ),
        ],
      );
      final map = c.toJson();
      expect(map['protectionSpace'], isA<Map<String, dynamic>>());
      expect(map['credentials'], isA<List<dynamic>>());
      final back = URLProtectionSpaceHttpAuthCredentials.fromJson(map);
      expect(back.protectionSpace?.host, 'a.dev');
      expect(back.credentials?.single.username, 'u');
      expect(
        back.protectionSpace?.authenticationMethod,
        URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_SERVER_TRUST,
      );
    });
  });

  group('CustomTabs enums', () {
    test('CustomTabsNavigationEventType wire [1..6]', () {
      expect(customTabsNavigationEventTypeToWire(CustomTabsNavigationEventType.STARTED), 1);
      expect(customTabsNavigationEventTypeToWire(CustomTabsNavigationEventType.FINISHED), 2);
      expect(customTabsNavigationEventTypeToWire(CustomTabsNavigationEventType.FAILED), 3);
      expect(customTabsNavigationEventTypeToWire(CustomTabsNavigationEventType.ABORTED), 4);
      expect(customTabsNavigationEventTypeToWire(CustomTabsNavigationEventType.TAB_SHOWN), 5);
      expect(customTabsNavigationEventTypeToWire(CustomTabsNavigationEventType.TAB_HIDDEN), 6);
      expect(customTabsNavigationEventTypeFromWire(3), CustomTabsNavigationEventType.FAILED);
      expect(customTabsNavigationEventTypeFromWire(0), isNull);
    });

    test('CustomTabsPostMessageResultType wire [0,-1,-2,-3]', () {
      expect(customTabsPostMessageResultTypeToWire(CustomTabsPostMessageResultType.SUCCESS), 0);
      expect(customTabsPostMessageResultTypeToWire(CustomTabsPostMessageResultType.FAILURE_DISALLOWED), -1);
      expect(customTabsPostMessageResultTypeToWire(CustomTabsPostMessageResultType.FAILURE_REMOTE_ERROR), -2);
      expect(customTabsPostMessageResultTypeToWire(CustomTabsPostMessageResultType.FAILURE_MESSAGING_ERROR), -3);
      expect(customTabsPostMessageResultTypeFromWire(-2), CustomTabsPostMessageResultType.FAILURE_REMOTE_ERROR);
      expect(customTabsPostMessageResultTypeFromWire(1), isNull);
    });

    test('CustomTabsRelationType wire [1,2]', () {
      expect(customTabsRelationTypeToWire(CustomTabsRelationType.USE_AS_ORIGIN), 1);
      expect(customTabsRelationTypeToWire(CustomTabsRelationType.HANDLE_ALL_URLS), 2);
      expect(customTabsRelationTypeFromWire(2), CustomTabsRelationType.HANDLE_ALL_URLS);
      expect(customTabsRelationTypeFromWire(0), isNull);
    });
  });
}
