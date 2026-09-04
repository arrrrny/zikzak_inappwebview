import 'package:flutter_test/flutter_test.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_platform.dart';

void main() {
  group('dispatchLoadingState', () {
    test('loading fires progress 0 and onLoadStart with the current url', () {
      final progresses = <int>[];
      final starts = <WebUri?>[];
      final stops = <WebUri?>[];
      final url = WebUri('https://example.com/');

      dispatchLoadingState(
        LoadingState.loading,
        url: url,
        onProgressChanged: progresses.add,
        onLoadStart: starts.add,
        onLoadStop: stops.add,
      );

      expect(progresses, [0]);
      expect(starts, [url]);
      expect(stops, isEmpty);
    });

    test(
      'navigationCompleted fires progress 100 and onLoadStop with the url',
      () {
        final progresses = <int>[];
        final starts = <WebUri?>[];
        final stops = <WebUri?>[];
        final url = WebUri('https://example.com/');

        dispatchLoadingState(
          LoadingState.navigationCompleted,
          url: url,
          onProgressChanged: progresses.add,
          onLoadStart: starts.add,
          onLoadStop: stops.add,
        );

        expect(progresses, [100]);
        expect(starts, isEmpty);
        expect(stops, [url]);
      },
    );

    test('none fires no callbacks', () {
      final progresses = <int>[];
      final starts = <WebUri?>[];
      final stops = <WebUri?>[];

      dispatchLoadingState(
        LoadingState.none,
        url: WebUri('https://example.com/'),
        onProgressChanged: progresses.add,
        onLoadStart: starts.add,
        onLoadStop: stops.add,
      );

      expect(progresses, isEmpty);
      expect(starts, isEmpty);
      expect(stops, isEmpty);
    });

    test('forwards a null url when the url stream has not landed yet', () {
      final progresses = <int>[];
      final starts = <WebUri?>[];
      var startCalled = false;

      dispatchLoadingState(
        LoadingState.loading,
        url: null,
        onProgressChanged: progresses.add,
        onLoadStart: (url) {
          startCalled = true;
          starts.add(url);
        },
      );

      expect(progresses, [0]);
      expect(startCalled, isTrue);
      expect(starts, [null]);
    });

    test('absent callbacks are tolerated', () {
      expect(
        () => dispatchLoadingState(LoadingState.loading, url: null),
        returnsNormally,
      );
      expect(
        () => dispatchLoadingState(
          LoadingState.navigationCompleted,
          url: WebUri('https://example.com/'),
        ),
        returnsNormally,
      );
      expect(
        () => dispatchLoadingState(LoadingState.none, url: null),
        returnsNormally,
      );
    });
  });
}
