import 'package:flutter_test/flutter_test.dart';
import 'package:webview_windows/webview_windows.dart' show LoadingState;
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_platform.dart';

/// A minimal controller double: [PlatformInAppWebViewController] requires a
/// platform implementation only for its factory constructor; the
/// implementation constructor used here is enough for callback plumbing.
class _FakeController extends PlatformInAppWebViewController {
  _FakeController(PlatformInAppWebViewControllerCreationParams params)
    : super.implementation(params);
}

void main() {
  group('dispatchLoadingStateChange (windows load events)', () {
    late List<Map<String, Object?>> calls;
    late PlatformInAppWebViewWidgetCreationParams params;
    late PlatformInAppWebViewController controller;

    setUp(() {
      calls = [];
      params = PlatformInAppWebViewWidgetCreationParams(
        onLoadStart: (c, url) =>
            calls.add({'name': 'onLoadStart', 'url': url?.toString()}),
        onLoadStop: (c, url) =>
            calls.add({'name': 'onLoadStop', 'url': url?.toString()}),
        onProgressChanged: (c, progress) =>
            calls.add({'name': 'onProgressChanged', 'progress': progress}),
      );
      controller = _FakeController(
        PlatformInAppWebViewControllerCreationParams(
          id: null,
          webviewParams: params,
        ),
      );
    });

    test('loading maps to onLoadStart + progress 0 (and no onLoadStop)', () {
      dispatchLoadingStateChange(
        state: LoadingState.loading,
        url: 'https://example.com/',
        controller: controller,
        params: params,
      );

      expect(calls, hasLength(2));
      expect(calls[0]['name'], 'onProgressChanged');
      expect(calls[0]['progress'], 0);
      expect(calls[1]['name'], 'onLoadStart');
      expect(calls[1]['url'], 'https://example.com/');
    });

    test('navigationCompleted maps to onLoadStop + progress 100', () {
      dispatchLoadingStateChange(
        state: LoadingState.navigationCompleted,
        url: 'https://example.com/',
        controller: controller,
        params: params,
      );

      expect(calls, hasLength(2));
      expect(calls[0]['name'], 'onProgressChanged');
      expect(calls[0]['progress'], 100);
      expect(calls[1]['name'], 'onLoadStop');
      expect(calls[1]['url'], 'https://example.com/');
    });

    test('none produces no callbacks at all (regression guard)', () {
      dispatchLoadingStateChange(
        state: LoadingState.none,
        url: 'https://example.com/',
        controller: controller,
        params: params,
      );

      expect(calls, isEmpty);
    });

    test('a null url is forwarded as null (best-effort url)', () {
      dispatchLoadingStateChange(
        state: LoadingState.loading,
        url: null,
        controller: controller,
        params: params,
      );

      expect(calls[1]['name'], 'onLoadStart');
      expect(
        calls[1]['url'],
        isNull,
        reason:
            'the urlChanged event can land after loadingStateChanged; '
            'onLoadStart must tolerate a null url',
      );
    });

    test('redirects emit multiple start/stop cycles (documented behavior)', () {
      for (final state in [
        LoadingState.loading,
        LoadingState.navigationCompleted,
        LoadingState.loading,
        LoadingState.navigationCompleted,
      ]) {
        dispatchLoadingStateChange(
          state: state,
          url: 'https://example.com/',
          controller: controller,
          params: params,
        );
      }

      expect(
        calls.where((c) => c['name'] == 'onLoadStart'),
        hasLength(2),
        reason: 'one onLoadStart per top-level navigation, not per page visit',
      );
    });
  });
}
