import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import 'main.dart';

/// First-load race stress demo.
///
/// Reproduces the exact scenario that used to fail: a consumer creates a
/// fresh headless WebView and issues its FIRST real loadUrl immediately
/// after run() completes — the navigation WKWebView can silently drop while
/// its content process is still booting. With the readiness gate (run()
/// completes only after the initial navigation reaches a terminal state)
/// every attempt must succeed.
///
/// The per-attempt timeouts below are TEST HARNESS measurement bounds so the
/// demo reports hangs instead of hanging forever — they are not part of the
/// fix and contain no logic the plugin relies on.
class FirstLoadRaceScreen extends StatefulWidget {
  const FirstLoadRaceScreen({super.key});

  @override
  State<FirstLoadRaceScreen> createState() => _FirstLoadRaceScreenState();
}

class _FirstLoadRaceScreenState extends State<FirstLoadRaceScreen> {
  static const targetUrl = 'https://example.com';
  static const marker = 'Example Domain';

  final List<String> _headlessLog = [];
  final List<String> _visibleLog = [];
  bool _headlessRunning = false;
  bool _visibleRunning = false;
  int _visibleRun = 0;

  String? _visibleHtml;
  String? _visibleLoadStopUrl;
  final _visibleLoadStopCompleters = <Completer<String?>>[];

  /// Live state instance for the debug hook below.
  static _FirstLoadRaceScreenState? _live;

  void _log(List<String> log, String line) {
    debugPrint('[FirstLoadRace] $line');
    log.insert(0, line);
    if (log.length > 60) log.removeLast();
  }

  // ═══════════════════════ HEADLESS STRESS ═══════════════════════

  Future<void> _runHeadlessStress() async {
    if (_headlessRunning) return;
    setState(() {
      _headlessRunning = true;
      _headlessLog.clear();
    });

    const attempts = 10;
    var passed = 0;

    for (var i = 1; i <= attempts; i++) {
      final attemptLog = <String>[];
      final stopwatch = Stopwatch()..start();
      HeadlessInAppWebView? webview;

      try {
        // 1. Fresh webview — the exact dart_web_scraper setup. onLoadStop
        //    is constructor-only, so wire the completer before run().
        final loadStop = Completer<String?>();
        webview = HeadlessInAppWebView(
          initialUrlRequest: URLRequest(url: WebUri('about:blank')),
          initialSettings: InAppWebViewSettings(isInspectable: kDebugMode),
          onLoadStop: (c, url) {
            if (!loadStop.isCompleted) loadStop.complete(url?.toString());
          },
        );

        // 2. run() — with the gate this only completes when the web
        //    process is ready; without it, returns immediately.
        await webview.run().timeout(
              const Duration(seconds: 15),
              onTimeout: () => throw TimeoutException('run() HUNG'),
            );
        final runMs = stopwatch.elapsedMilliseconds;
        attemptLog.add('run(): ${runMs}ms');

        final controller = webview.webViewController!;

        // 3. IMMEDIATELY issue the first real navigation.
        await controller.loadUrl(urlRequest: URLRequest(url: WebUri(targetUrl)));
        final stopUrl = await loadStop.future.timeout(
              const Duration(seconds: 15),
              onTimeout: () => throw TimeoutException('onLoadStop never fired'),
            );
        attemptLog.add('onLoadStop: ${stopwatch.elapsedMilliseconds}ms ($stopUrl)');

        // 4. Verify content actually rendered.
        final html = await controller.getHtml().timeout(
              const Duration(seconds: 15),
              onTimeout: () => throw TimeoutException('getHtml() HUNG'),
            );
        final ok = (html ?? '').contains(marker);
        attemptLog.add('html: ${(html ?? '').length} chars, marker=$ok');
        if (ok) passed++;
        attemptLog.add(ok ? '✅ PASS' : '❌ FAIL (content mismatch)');
      } catch (e) {
        attemptLog.add('❌ FAIL: $e');
      } finally {
        try {
          await webview?.dispose();
        } catch (_) {}
      }

      _log(_headlessLog, '── attempt $i/$attempts ──');
      for (final line in attemptLog.reversed) {
        _log(_headlessLog, '   $line');
      }
      if (mounted) setState(() {});
    }

    _log(_headlessLog, '══════ RESULT: $passed/$attempts passed ══════');
    setState(() {
      _headlessRunning = false;
    });
  }

  // ═══════════════════════ VISIBLE STRESS ═══════════════════════

  Future<void> _runVisible() async {
    if (_visibleRunning) return;
    setState(() {
      _visibleRunning = true;
      _visibleRun++;
      _visibleHtml = null;
      _visibleLoadStopUrl = null;
    });
    _log(_visibleLog, '── run #$_visibleRun: fresh widget, immediate loadUrl ──');
  }

  void _onVisibleWebViewCreated(InAppWebViewController controller) async {
    // The latent race: navigate IMMEDIATELY from the creation callback,
    // before the web process is guaranteed to be up.
    _log(_visibleLog, '   onWebViewCreated → loadUrl($targetUrl)');
    final completer = Completer<String?>();
    _visibleLoadStopCompleters.add(completer);
    try {
      await controller.loadUrl(urlRequest: URLRequest(url: WebUri(targetUrl)));
      final stopUrl = await completer.future.timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('onLoadStop never fired'),
          );
      final html = await controller.getHtml().timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('getHtml() HUNG'),
          );
      final ok = (html ?? '').contains(marker);
      _log(
        _visibleLog,
        '   onLoadStop: $stopUrl · html: ${(html ?? "").length} chars · marker=$ok '
        '→ ${ok ? '✅ PASS' : '❌ FAIL'}',
      );
      if (mounted) {
        setState(() {
          _visibleLoadStopUrl = stopUrl;
          _visibleHtml = html;
          _visibleRunning = false;
        });
      }
    } catch (e) {
      _log(_visibleLog, '   ❌ FAIL: $e');
      if (mounted) setState(() => _visibleRunning = false);
    }
  }

  void _onVisibleLoadStop(InAppWebViewController controller, WebUri? url) {
    final value = url?.toString();
    for (final c in _visibleLoadStopCompleters) {
      if (!c.isCompleted) c.complete(value);
    }
    _visibleLoadStopCompleters.clear();
    if (mounted) {
      setState(() => _visibleLoadStopUrl = value);
    }
  }

  @override
  void initState() {
    super.initState();
    _live = this;
  }

  @override
  void dispose() {
    if (identical(_live, this)) _live = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First-Load Race Stress')),
      drawer: myDrawer(context: context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Target: $targetUrl (marker: "$marker")\n'
              'Headless: 10 × fresh webview, run() → IMMEDIATE loadUrl. '
              'Visible: loadUrl from onWebViewCreated.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _headlessRunning ? null : _runHeadlessStress,
              icon: _headlessRunning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: const Text('Run Headless Stress (10× fresh webviews)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _visibleRunning ? null : _runVisible,
              icon: const Icon(Icons.visibility),
              label: const Text('Run Visible WebView Stress (fresh widget)'),
            ),
            const SizedBox(height: 16),
            // Visible webview instance — recreated on each run via key.
            if (_visibleRun > 0)
              SizedBox(
                height: 260,
                child: InAppWebView(
                  key: ValueKey('visible-run-$_visibleRun'),
                  initialUrlRequest:
                      URLRequest(url: WebUri('about:blank')),
                  initialSettings: InAppWebViewSettings(
                    isInspectable: kDebugMode,
                  ),
                  onWebViewCreated: _onVisibleWebViewCreated,
                  onLoadStop: _onVisibleLoadStop,
                ),
              ),
            if (_visibleHtml != null) ...[
              const SizedBox(height: 8),
              Text(
                'Visible last result: $_visibleLoadStopUrl\n'
                'html ${_visibleHtml!.length} chars · '
                'marker=${_visibleHtml!.contains(marker)}',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'HEADLESS LOG',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._headlessLog.map(
              (l) => Text(
                l,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const Divider(),
            const Text(
              'VISIBLE LOG',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._visibleLog.map(
              (l) => Text(
                l,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Debug hook — invoke from the VM service / flutter run console:
///   debugRunHeadlessStress()
Future<void> debugRunHeadlessStress() =>
    _FirstLoadRaceScreenState._live?._runHeadlessStress() ??
    Future.error('FirstLoadRaceScreen not open');
