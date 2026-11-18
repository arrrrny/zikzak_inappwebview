// Initial-load dispatch contract (the #425 fix and its review follow-up).
//
// The GUI creation path and the headless manager both fire the webview's
// first navigation, and the two used to drift: the GUI path handled
// `initialUrlRequest` only, so an `initialData` webview armed the readiness
// gate but never loaded anything — a blank page forever (issue #425). The
// fixes round shared the body through `makeInitialLoad`, and the review of
// that change flagged the identical gap one input kind over
// (`initialFile`, sent by MacOSInAppWebViewWidget.build, handled only by
// the headless dispatcher).
//
// This file pins the converged shape as a source scan so neither half can
// silently regress: the GUI path must dispatch through `makeInitialLoad`
// (behind the #197 readiness gate), the headless manager must fire it after
// its own readiness ping, the dispatcher must still handle all three input
// kinds, and the Dart widget must send all three. Executable on any host
// (no Xcode required), like the other source-contract tests in this suite.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/swift_source.dart';

void main() {
  // Stripped sources for code-token assertions; raw for AC3, whose ping
  // marker is a string literal (`evaluateJavaScript("true")`) that
  // stripSwiftNonCode erases.
  late String inAppWebViewSwift;
  late String headlessManagerRaw;
  late String widgetDart;

  setUpAll(() {
    final macosDir = packageMacosDir();
    final sourcesDir = Directory(
      '${macosDir.path}/Sources/zikzak_inappwebview_macos',
    );
    expect(
      sourcesDir.existsSync(),
      isTrue,
      reason:
          'Swift sources dir not found relative to package root '
          '(cwd: ${Directory.current.path})',
    );
    final inAppWebViewFile = File(
      '${sourcesDir.path}/InAppWebView.swift',
    );
    final headlessManagerFile = File(
      '${sourcesDir.path}/HeadlessInAppWebView/HeadlessInAppWebViewManager.swift',
    );
    expect(inAppWebViewFile.existsSync(), isTrue,
        reason: 'missing ${inAppWebViewFile.path}');
    expect(headlessManagerFile.existsSync(), isTrue,
        reason: 'missing ${headlessManagerFile.path}');
    inAppWebViewSwift = stripSwiftNonCode(inAppWebViewFile.readAsStringSync());
    headlessManagerRaw = headlessManagerFile.readAsStringSync();
    final widgetFile = File(
      '${macosDir.parent.parent.path}/lib/src/in_app_webview/in_app_webview.dart',
    );
    expect(
      widgetFile.existsSync(),
      isTrue,
      reason: 'missing ${widgetFile.path}',
    );
    widgetDart = widgetFile.readAsStringSync();
  });

  test('AC1: the GUI creation path dispatches the initial load once', () {
    final initBody = functionBody(
      inAppWebViewSwift,
      'registrar: FlutterPluginRegistrar, viewId: Any, arguments: Any?',
    );
    expect(
      initBody,
      contains('makeInitialLoad(params:'),
      reason:
          'the GUI creation path must issue the initial load through the '
          'shared makeInitialLoad dispatcher — a per-kind branch here is '
          'exactly how initialData was dropped (#425) and initialFile '
          'remained dropped one kind over',
    );
    expect(
      'loadInitialData(args'.allMatches(initBody).length,
      0,
      reason:
          'the GUI path must not re-implement the data branch inline; the '
          'shared body lives in makeInitialLoad/loadInitialData',
    );
    // Exactly one dispatch site: an init that both dispatches and keeps a
    // per-kind branch could drop a kind again on the branch.
    expect(
      'makeInitialLoad(params:'.allMatches(initBody).length,
      1,
      reason: 'the GUI init must hold a single initial-load dispatch site',
    );
  });

  test('AC2: the GUI dispatch sits behind the WebContent readiness gate', () {
    final initBody = functionBody(
      inAppWebViewSwift,
      'registrar: FlutterPluginRegistrar, viewId: Any, arguments: Any?',
    );
    final dispatchIdx = initBody.indexOf('makeInitialLoad(params:');
    expect(dispatchIdx, greaterThanOrEqualTo(0));
    final wrap = initBody.substring(
      // Walk back to the statement start; performLoad is the only wrapper
      // that arms the #197 gate, so assert its call encloses the dispatch.
      dispatchIdx > 400 ? dispatchIdx - 400 : 0,
      dispatchIdx,
    );
    expect(
      wrap,
      contains('performLoad'),
      reason:
          'a load issued while the WebContent XPC process is still booting '
          'is silently dropped (issue #197); the GUI dispatch must be '
          'queued through performLoad like every first navigation',
    );
  });

  test('AC3: the headless manager fires makeInitialLoad after its ping', () {
    final runBody = functionBody(headlessManagerRaw, 'func run(');
    expect(
      runBody,
      contains('makeInitialLoad(params: params)'),
      reason:
          'headless webviews defer the initial load (deferInitialLoad: '
          'true); the manager must fire it itself — from its readiness '
          'ping completion, not from init',
    );
    final pingIdx = runBody.indexOf('evaluateJavaScript("true")');
    final loadIdx = runBody.indexOf('makeInitialLoad(params: params)');
    expect(pingIdx, greaterThanOrEqualTo(0));
    expect(
      loadIdx,
      greaterThan(pingIdx),
      reason:
          'the initial load must be fired from the readiness ping '
          'completion — a load issued before the ping can be dropped by '
          'the same boot race the ping exists to defeat',
    );
  });

  test('AC4: the dispatcher handles every input kind the widget sends', () {
    final body = functionBody(inAppWebViewSwift, 'func makeInitialLoad(');
    expect(
      body,
      contains('initialUrlRequest'),
      reason: 'URL requests are the first input kind',
    );
    expect(
      body,
      contains('initialFile'),
      reason:
          'initialFile was the dropped kind — MacOSInAppWebViewWidget '
          'sends it, so a GUI InAppWebView(initialFileRequest:) must not '
          'render a blank page',
    );
    expect(
      body,
      contains('initialData'),
      reason: 'initialData was the #425 kind',
    );
    // The file kind resolves asset keys through the registrar like the
    // channel "loadFile" handler does.
    expect(
      body,
      contains('getUrlAsset'),
      reason:
          'initialFile may be a Flutter asset key, not an absolute native '
          'path — resolve it through Util.getUrlAsset like loadFile does',
    );
    expect(
      body,
      contains('loadInitialData'),
      reason:
          'the data branch must run through the shared loadInitialData '
          'body (GUI and headless cannot drift on it)',
    );
  });

  test('AC5: the Dart widget sends all three input kinds', () {
    expect(
      widgetDart,
      contains("'initialUrlRequest': params.initialUrlRequest?.toJson()"),
    );
    expect(
      widgetDart,
      contains("'initialData': params.initialData?.toJson()"),
    );
    expect(
      widgetDart,
      contains("'initialFile': params.initialFile"),
      reason:
          'the widget must forward initialFile in creationParams — the '
          'native dispatcher cannot load what the widget never sends',
    );
  });
}
