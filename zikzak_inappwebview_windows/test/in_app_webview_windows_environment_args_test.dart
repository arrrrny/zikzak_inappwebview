import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_platform.dart';

void main() {
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

    test('does not match non-PlatformException errors', () {
      expect(isEnvironmentAlreadyInitializedError(StateError('boom')), isFalse);
    });
  });

  group('ensureWebView2Environment (reuse wiring)', () {
    const pluginChannel = MethodChannel('io.jns.webview.win');

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pluginChannel, null);
    });

    test('completes silently when the environment is already initialized '
        '(reuse path)', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      var initializeCalls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pluginChannel, (call) async {
            if (call.method == 'initializeEnvironment') {
              initializeCalls++;
              throw PlatformException(code: 'environment_already_initialized');
            }
            return null;
          });

      await ensureWebView2Environment(
        const WebViewEnvironmentInitArgs(userDataPath: '/tmp/reuse-test'),
      );

      expect(
        initializeCalls,
        1,
        reason:
            'the upstream initializeEnvironment must still be attempted '
            'exactly once before the reuse decision',
      );
    });

    test('rethrows unrelated platform errors', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pluginChannel, (call) async {
            if (call.method == 'initializeEnvironment') {
              throw PlatformException(code: 'environment_creation_failed');
            }
            return null;
          });

      await expectLater(
        ensureWebView2Environment(
          const WebViewEnvironmentInitArgs(userDataPath: '/tmp/rethrow-test'),
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
