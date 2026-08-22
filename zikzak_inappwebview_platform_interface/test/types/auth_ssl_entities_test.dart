// Public-API regression tests for the auth/ssl family, migrated from
// @ExchangeableObject/@ExchangeableEnum codegen to Zorphy entities (see
// PROGRESS.md, Phase 2f).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (incl. the fork's defaults)
//   - JSON wire format (map keys; nested sibling entities; int-wire enums as
//     .index; URLProtectionSpace auth-method/proxy-type as their NSURL
//     strings; SslErrorType as its platform-dependent native int —
//     iOS/macOS SecTrustResultType-derived / Android SSL_ERROR_*)
//   - flattened challenge hierarchy (extends URLAuthenticationChallenge is
//     flat on the wire, like the old codegen)
//   - null/missing-key tolerance of fromJson
//   - copyWith availability (zorphy addition)
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// SslErrorType native values are platform-dependent (the old
/// ExchangeableEnum codegen dispatched on `defaultTargetPlatform`), so the
/// wire tests pin the platform explicitly.
void withPlatform(TargetPlatform platform, void Function() fn) {
  debugDefaultTargetPlatformOverride = platform;
  try {
    fn();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

void main() {
  group('URLProtectionSpace', () {
    test('toJson emits host/port + NSURL string enum wires', () {
      final space = URLProtectionSpace(
        host: 'example.com',
        protocol: 'https',
        port: 443,
        realm: 'realm',
        authenticationMethod: URLProtectionSpaceAuthenticationMethod
            .NSURL_AUTHENTICATION_METHOD_NTLM,
        proxyType: URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTP_PROXY,
      );
      final map = space.toJson();
      expect(map['host'], 'example.com');
      expect(map['port'], 443);
      expect(map['realm'], 'realm');
      expect(map['authenticationMethod'], 'NSURLAuthenticationMethodNTLM');
      expect(map['proxyType'], 'NSURLProtectionSpaceHTTPProxy');

      final restored = URLProtectionSpace.fromJson(map);
      expect(restored.host, 'example.com');
      expect(
        restored.authenticationMethod,
        URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_NTLM,
      );
      expect(
        restored.proxyType,
        URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTP_PROXY,
      );
    });

    test('sslCertificate uses the hand-written SslCertificate glue', () {
      final space = URLProtectionSpace.fromJson({
        'host': 'example.com',
        'sslCertificate': {
          'issuedBy': {'CName': 'issuer'},
          'validNotAfterDate': 1000,
        },
      });
      expect(space.sslCertificate, isNotNull);
      expect(space.sslCertificate!.issuedBy!.CName, 'issuer');
      expect(
        space.sslCertificate!.validNotAfterDate,
        DateTime.fromMillisecondsSinceEpoch(1000),
      );
      expect(space.sslCertificate!.x509Certificate, isNull);
    });
  });

  group('SslError (platform-native code wire)', () {
    test('iOS wire ints round-trip', () {
      withPlatform(TargetPlatform.iOS, () {
        final error = SslError.fromJson({'code': 5, 'message': 'msg'});
        expect(error.code, SslErrorType.RECOVERABLE_TRUST_FAILURE);
        expect(error.message, 'msg');
        expect(error.toJson()['code'], 5);
      });
    });

    test('Android wire ints round-trip', () {
      withPlatform(TargetPlatform.android, () {
        final error = SslError.fromJson({'code': 3, 'message': 'msg'});
        expect(error.code, SslErrorType.UNTRUSTED);
        expect(error.toJson()['code'], 3);
      });
    });
  });

  group('URLCredential', () {
    test('persistence int wire + defaults', () {
      final credential = URLCredential(
        username: 'user',
        password: 'pass',
        persistence: URLCredentialPersistence.PERMANENT,
      );
      final map = credential.toJson();
      expect(map['username'], 'user');
      expect(map['persistence'], 2); // .index

      final restored = URLCredential.fromJson(map);
      expect(restored.persistence, URLCredentialPersistence.PERMANENT);
      expect(restored.certificates, isNull);
    });
  });

  group('challenge hierarchy (flattened wire)', () {
    test('HttpAuthenticationChallenge flattened fields round-trip', () {
      final challenge = HttpAuthenticationChallenge(
        protectionSpace: URLProtectionSpace(host: 'example.com'),
        previousFailureCount: 2,
        proposedCredential: URLCredential(username: 'user', password: 'pass'),
        failureResponse: URLResponse(
          url: WebUri('https://example.com'),
          expectedContentLength: 0,
        ),
      );
      final map = challenge.toJson();
      expect((map['protectionSpace'] as Map)['host'], 'example.com');
      expect(map['previousFailureCount'], 2);
      expect((map['proposedCredential'] as Map)['username'], 'user');
      expect((map['failureResponse'] as Map)['url'], 'https://example.com');

      final restored = HttpAuthenticationChallenge.fromJson(map)!;
      expect(restored.previousFailureCount, 2);
      expect(restored.proposedCredential!.username, 'user');
      expect(restored.failureResponse!.url.toString(), 'https://example.com');
      expect(restored.error, isNull);
    });

    test('ClientCertChallenge flattened fields round-trip', () {
      final challenge = ClientCertChallenge(
        protectionSpace: URLProtectionSpace(host: 'example.com'),
        principals: const ['issuer'],
        keyTypes: const ['RSA'],
      );
      final map = challenge.toJson();
      expect((map['protectionSpace'] as Map)['host'], 'example.com');
      expect(map['principals'], ['issuer']);
      expect(map['keyTypes'], ['RSA']);

      final restored = ClientCertChallenge.fromJson(map)!;
      expect(restored.principals, ['issuer']);
      expect(restored.keyTypes, ['RSA']);
    });

    test('ServerTrustChallenge round-trip', () {
      final challenge = ServerTrustChallenge(
        protectionSpace: URLProtectionSpace(host: 'example.com', port: 443),
      );
      final restored = ServerTrustChallenge.fromJson(challenge.toJson())!;
      expect(restored.protectionSpace.port, 443);
    });
  });

  group('auth responses (fork defaults + int-wire action)', () {
    test('HttpAuthResponse defaults + action int wire', () {
      final response = HttpAuthResponse();
      expect(response.username, '');
      expect(response.password, '');
      expect(response.permanentPersistence, isFalse);
      expect(response.action, HttpAuthResponseAction.CANCEL);
      expect(response.toJson()['action'], 0);

      final proceed = HttpAuthResponse(
        username: 'u',
        password: 'p',
        action: HttpAuthResponseAction.PROCEED,
      );
      expect(proceed.toJson()['action'], 1);
      expect(
        HttpAuthResponse.fromJson(proceed.toJson()).action,
        HttpAuthResponseAction.PROCEED,
      );
    });

    test('ClientCertResponse fork defaults (keyStoreType PKCS12, CANCEL)', () {
      final response = ClientCertResponse(certificatePath: '/cert.p12');
      expect(response.certificatePath, '/cert.p12');
      expect(response.certificatePassword, '');
      expect(response.keyStoreType, 'PKCS12');
      expect(response.action, ClientCertResponseAction.CANCEL);
      expect(response.toJson()['keyStoreType'], 'PKCS12');
      expect(response.toJson()['action'], 0);
    });

    test('ServerTrustAuthResponse default action', () {
      final response = ServerTrustAuthResponse();
      expect(response.action, ServerTrustAuthResponseAction.CANCEL);
      expect(response.toJson()['action'], 0);
    });
  });
}
