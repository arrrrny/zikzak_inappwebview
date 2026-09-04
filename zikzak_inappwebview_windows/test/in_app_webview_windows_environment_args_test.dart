import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const defaultFolder = '/tmp/default-zikzak-webview2-data';

  group('WebView2 environment initialization', () {
    test('recognizes an already initialized environment', () {
      expect(
        isEnvironmentAlreadyInitializedError(
          PlatformException(code: 'environment_already_initialized'),
        ),
        isTrue,
      );
    });

    test('does not swallow unrelated platform errors', () {
      expect(
        isEnvironmentAlreadyInitializedError(
          PlatformException(code: 'other_error'),
        ),
        isFalse,
      );
    });

    test('does not treat non-platform errors as reuse', () {
      expect(isEnvironmentAlreadyInitializedError(StateError('x')), isFalse);
    });
  });

  group('ensureWebView2Environment', () {
    // The webview_windows package routes every controller call through a
    // single process-wide method channel. Mocking it lets the tests exercise
    // the real reuse wiring without booting a WebView2 runtime.
    const channel = MethodChannel('io.jns.webview.win');

    void mockEnvironment({required Object? Function() onInitialize}) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'initializeEnvironment');
            return onInitialize();
          });
    }

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('initializes when no environment exists', () async {
      var invoked = false;
      mockEnvironment(onInitialize: () => invoked = true);

      await ensureWebView2Environment(
        WebViewEnvironmentInitArgs(userDataPath: defaultFolder),
      );

      expect(invoked, isTrue);
    });

    test('reuses an already-initialized environment', () async {
      mockEnvironment(
        onInitialize: () =>
            throw PlatformException(code: 'environment_already_initialized'),
      );

      await expectLater(
        ensureWebView2Environment(
          WebViewEnvironmentInitArgs(userDataPath: defaultFolder),
        ),
        completes,
      );
    });

    test('rethrows unrelated platform errors', () async {
      mockEnvironment(
        onInitialize: () =>
            throw PlatformException(code: 'environment_creation_failed'),
      );

      await expectLater(
        ensureWebView2Environment(
          WebViewEnvironmentInitArgs(userDataPath: defaultFolder),
        ),
        throwsA(
          isA<PlatformException>().having(
            (e) => e.code,
            'code',
            'environment_creation_failed',
          ),
        ),
      );
    });

    test('forwards the resolved args to the platform channel', () async {
      Map<String, dynamic>? received;
      mockEnvironment(onInitialize: () => null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            received = Map<String, dynamic>.from(call.arguments as Map);
            return null;
          });

      await ensureWebView2Environment(
        WebViewEnvironmentInitArgs(
          userDataPath: 'D:/appdata/wbv2',
          browserExePath: 'C:/wbv2/fixed',
          additionalArguments: '--disable-web-security',
        ),
      );

      expect(received?['userDataPath'], 'D:/appdata/wbv2');
      expect(received?['browserExePath'], 'C:/wbv2/fixed');
      expect(received?['additionalArguments'], '--disable-web-security');
    });
  });

  group('resolveEnvironmentInitArgs', () {
    group('issue #178 regression — additionalBrowserArguments', () {
      test(
        'forwards --disable-web-security and friends to additionalArguments',
        () {
          // The exact symptom reported in issue #178: the user supplied
          // `--disable-web-security --allow-running-insecure-content
          // --use-fake-ui-for-media-stream
          // --use-fake-device-for-media-stream` via
          // `WebViewEnvironmentSettings.additionalBrowserArguments`, but
          // CORS stayed on because the flag was silently dropped before
          // reaching WebView2. The resolver must surface the value on
          // `WebViewEnvironmentInitArgs.additionalArguments` so the
          // caller can forward it to
          // `WebviewController.initializeEnvironment(additionalArguments:)`.
          const args =
              '--disable-web-security '
              '--allow-running-insecure-content '
              '--use-fake-ui-for-media-stream '
              '--use-fake-device-for-media-stream';
          final resolved = resolveEnvironmentInitArgs(
            settings: WebViewEnvironmentSettings(
              userDataFolder: '/tmp/cors-disabled',
              additionalBrowserArguments: args,
            ),
            defaultUserDataFolder: () => defaultFolder,
          );

          expect(resolved.additionalArguments, args);
          expect(resolved.userDataPath, '/tmp/cors-disabled');
          expect(resolved.browserExePath, isNull);
        },
      );
    });

    test('null settings → only userDataPath, defaults invoked', () {
      var defaultInvoked = 0;
      final resolved = resolveEnvironmentInitArgs(
        settings: null,
        defaultUserDataFolder: () {
          defaultInvoked++;
          return defaultFolder;
        },
      );

      expect(resolved.userDataPath, defaultFolder);
      expect(resolved.browserExePath, isNull);
      expect(resolved.additionalArguments, isNull);
      expect(defaultInvoked, 1);
    });

    test('settings without userDataFolder → falls back to default', () {
      var defaultInvoked = 0;
      final resolved = resolveEnvironmentInitArgs(
        settings: WebViewEnvironmentSettings(
          additionalBrowserArguments: '--disable-web-security',
        ),
        defaultUserDataFolder: () {
          defaultInvoked++;
          return defaultFolder;
        },
      );

      expect(resolved.userDataPath, defaultFolder);
      expect(resolved.additionalArguments, '--disable-web-security');
      expect(defaultInvoked, 1);
    });

    test('settings with all fields → all fields forwarded', () {
      final resolved = resolveEnvironmentInitArgs(
        settings: WebViewEnvironmentSettings(
          browserExecutableFolder: 'C:/wbv2/fixed',
          userDataFolder: 'D:/appdata/wbv2',
          additionalBrowserArguments: '--disable-web-security --flag2',
        ),
        defaultUserDataFolder: () => defaultFolder,
      );

      expect(resolved.userDataPath, 'D:/appdata/wbv2');
      expect(resolved.browserExePath, 'C:/wbv2/fixed');
      expect(resolved.additionalArguments, '--disable-web-security --flag2');
    });

    test('settings with only userDataFolder → null browser/args', () {
      final resolved = resolveEnvironmentInitArgs(
        settings: WebViewEnvironmentSettings(
          userDataFolder: '/tmp/custom-folder',
        ),
        defaultUserDataFolder: () => defaultFolder,
      );

      expect(resolved.userDataPath, '/tmp/custom-folder');
      expect(resolved.browserExePath, isNull);
      expect(resolved.additionalArguments, isNull);
    });

    test(
      'defaultUserDataFolder is NOT invoked when settings.userDataFolder is set',
      () {
        var defaultInvoked = 0;
        resolveEnvironmentInitArgs(
          settings: WebViewEnvironmentSettings(
            userDataFolder: '/tmp/explicit',
            additionalBrowserArguments: '--disable-web-security',
          ),
          defaultUserDataFolder: () {
            defaultInvoked++;
            return defaultFolder;
          },
        );

        expect(defaultInvoked, 0);
      },
    );
  });
}
