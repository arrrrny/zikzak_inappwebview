// Tests for keepNavigationInWebView — the shouldOverrideUrlLoading helper
// that keeps user-tapped links inside the WebView (avoids the iOS
// universal-link handoff, which is fatal for guided flows like
// session recording/replay).
//
// Uses a fake PlatformInAppWebViewController so the controller can be built
// without a real platform channel.
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class _FakePlatformController extends PlatformInAppWebViewController {
  _FakePlatformController() : super.implementation(
          const PlatformInAppWebViewControllerCreationParams(id: 'test'),
        );

  final List<URLRequest> loadUrlCalls = <URLRequest>[];

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) async {
    loadUrlCalls.add(urlRequest);
  }
}

void main() {
  NavigationAction _action({
    required String url,
    NavigationType? navigationType,
    bool isForMainFrame = true,
  }) {
    return NavigationAction(
      request: URLRequest(url: WebUri(url)),
      isForMainFrame: isForMainFrame,
      navigationType: navigationType,
    );
  }

  group('keepNavigationInWebView', () {
    test('re-issues LINK_ACTIVATED http navigations + cancels', () async {
      final controller = InAppWebViewController.fromPlatform(
        platform: _FakePlatformController(),
      );
      final policy = await keepNavigationInWebView(
        controller,
        _action(url: 'https://example.com/', navigationType: NavigationType.LINK_ACTIVATED),
      );
      expect(policy, NavigationActionPolicy.CANCEL);
      final fake = controller.platform as _FakePlatformController;
      expect(fake.loadUrlCalls, hasLength(1));
      expect(fake.loadUrlCalls.single.url?.toString(), 'https://example.com/');
    });

    test('ALLOWs non-LINK_ACTIVATED navigations', () async {
      final controller = InAppWebViewController.fromPlatform(
        platform: _FakePlatformController(),
      );
      final policy = await keepNavigationInWebView(
        controller,
        _action(url: 'https://example.com/', navigationType: NavigationType.FORM_SUBMITTED),
      );
      expect(policy, NavigationActionPolicy.ALLOW);
      expect((controller.platform as _FakePlatformController).loadUrlCalls, isEmpty);
    });

    test('ALLOWs LINK_ACTIVATED non-http schemes', () async {
      final controller = InAppWebViewController.fromPlatform(
        platform: _FakePlatformController(),
      );
      final policy = await keepNavigationInWebView(
        controller,
        _action(url: 'tel:+123', navigationType: NavigationType.LINK_ACTIVATED),
      );
      expect(policy, NavigationActionPolicy.ALLOW);
      expect((controller.platform as _FakePlatformController).loadUrlCalls, isEmpty);
    });

    test('ALLOWs LINK_ACTIVATED sub-frame navigations', () async {
      final controller = InAppWebViewController.fromPlatform(
        platform: _FakePlatformController(),
      );
      final policy = await keepNavigationInWebView(
        controller,
        _action(
          url: 'https://example.com/',
          navigationType: NavigationType.LINK_ACTIVATED,
          isForMainFrame: false,
        ),
      );
      expect(policy, NavigationActionPolicy.ALLOW);
      expect((controller.platform as _FakePlatformController).loadUrlCalls, isEmpty);
    });

    test('ALLOWs navigations with null url', () async {
      final controller = InAppWebViewController.fromPlatform(
        platform: _FakePlatformController(),
      );
      final policy = await keepNavigationInWebView(
        controller,
        NavigationAction(
          request: URLRequest(url: WebUri('about:blank')),
          isForMainFrame: true,
          navigationType: NavigationType.LINK_ACTIVATED,
        ),
      );
      expect(policy, NavigationActionPolicy.ALLOW);
      expect((controller.platform as _FakePlatformController).loadUrlCalls, isEmpty);
    });
  });
}
