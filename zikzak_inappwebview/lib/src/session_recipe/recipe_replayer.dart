import 'dart:async';
import 'dart:convert';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../cookie_manager.dart';
import '../in_app_webview/in_app_webview_controller.dart';
import 'models.dart';
import 'replay_click_js.dart';

///Testability seam for [RecipeReplayer]: every WebView/cookie interaction
///goes through this interface so replay logic can be unit-tested without a
///WebView.
abstract class ReplayDriver {
  ///Restores the recorded cookies (before the first [loadUrl]).
  Future<void> restoreCookies(List<CookieEntry> cookies, String entryUrl);

  ///Navigates the WebView to [url].
  Future<void> loadUrl(String url);

  ///Waits until the current navigation finishes loading.
  ///Must complete (normally or by throwing) within [timeout].
  Future<void> waitForLoad(Duration timeout);

  ///Evaluates JavaScript in the current page.
  Future<dynamic> evaluateJavascript(String source);

  ///The current page URL, if any.
  Future<String?> getUrl();

  ///The current page HTML, if any.
  Future<String?> getHtml();
}

///Default [ReplayDriver] wrapping a real [InAppWebViewController].
class InAppWebViewReplayDriver implements ReplayDriver {
  ///The wrapped controller.
  final InAppWebViewController controller;

  InAppWebViewReplayDriver(this.controller);

  @override
  Future<void> restoreCookies(
    List<CookieEntry> cookies,
    String entryUrl,
  ) async {
    final manager = CookieManager.instance();
    for (final cookie in cookies) {
      try {
        await manager.setCookie(
          url: WebUri(entryUrl),
          name: cookie.name,
          value: cookie.value,
          path: cookie.path,
          domain: cookie.domain,
          expiresDate: cookie.expiresDate,
          isSecure: cookie.isSecure,
          isHttpOnly: cookie.isHttpOnly,
        );
      } catch (_) {
        // Best-effort: a single failing cookie must not abort replay.
      }
    }
  }

  @override
  Future<void> loadUrl(String url) =>
      controller.loadUrl(urlRequest: URLRequest(url: WebUri(url)));

  @override
  Future<void> waitForLoad(Duration timeout) async {
    final deadline = DateTime.now().add(timeout);
    // Give loadUrl a beat to actually start the navigation.
    await Future<void>.delayed(const Duration(milliseconds: 150));
    while (DateTime.now().isBefore(deadline)) {
      try {
        final loading = await controller.isLoading();
        if (loading == false) return;
      } catch (_) {
        return; // Controller gone — treat as loaded to avoid hanging.
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    throw TimeoutException('navigation-timeout', timeout);
  }

  @override
  Future<dynamic> evaluateJavascript(String source) =>
      controller.evaluateJavascript(source: source);

  @override
  Future<String?> getUrl() async => (await controller.getUrl())?.toString();

  @override
  Future<String?> getHtml() => controller.getHtml();
}

///Replays a [RecipeRecording] against a [SessionRecipe] on a WebView.
///
///Never throws for expected failures — every outcome is reported as a
///[ReplayResult] and every wait is bounded by [stepTimeout].
class RecipeReplayer {
  ///Per-step timeout for navigation and tap resolution.
  final Duration stepTimeout;

  ///Best-effort quiet period waited after load when a step sets
  ///`waitForNetworkIdle`.
  final Duration networkIdleQuiet;

  RecipeReplayer({
    this.stepTimeout = const Duration(seconds: 30),
    this.networkIdleQuiet = const Duration(seconds: 2),
  });

  ///Restores the recording's cookies, then executes each step in order:
  ///`loadUrl` the step's entry URL, wait for load, optionally wait for
  ///network idle, and dispatch the recorded tap via injected JavaScript.
  ///
  ///Replay follows the RECORDING's steps, not the recipe definition, so
  ///recordings made against older recipe versions (fewer steps) still
  ///replay; the recipe definition only contributes per-step settings
  ///(`captureTap`, `waitForNetworkIdle`) looked up by step id.
  ///
  ///[untilStepId] stops the replay after the step with that id completes
  ///successfully, returning [ReplayStatus.success] with the final URL/HTML
  ///as of that step. When the id does not exist in the recording, replay
  ///fails fast with [ReplayStatus.stepFailed] / `unknown-step` before any
  ///WebView interaction.
  ///
  ///[driver] overrides the default [InAppWebViewReplayDriver].
  Future<ReplayResult> replay({
    required InAppWebViewController controller,
    required SessionRecipe recipe,
    required RecipeRecording recording,
    void Function(ReplayProgress progress)? onProgress,
    ReplayDriver? driver,
    String? untilStepId,
  }) {
    return replayWithDriver(
      driver: driver ?? InAppWebViewReplayDriver(controller),
      recipe: recipe,
      recording: recording,
      onProgress: onProgress,
      untilStepId: untilStepId,
    );
  }

  ///Driver-only entry point — the whole replay runs through [driver], so
  ///no WebView is needed (tests).
  Future<ReplayResult> replayWithDriver({
    required ReplayDriver driver,
    required SessionRecipe recipe,
    required RecipeRecording recording,
    void Function(ReplayProgress progress)? onProgress,
    String? untilStepId,
  }) async {
    final d = driver;

    // Fail fast when the requested stop step is not in the recording.
    if (untilStepId != null &&
        !recording.steps.any((step) => step.stepId == untilStepId)) {
      return ReplayResult(
        status: ReplayStatus.stepFailed,
        failedStepId: untilStepId,
        failureReason: 'unknown-step',
        completedSteps: const [],
      );
    }

    // Cookies are restored before the first loadUrl.
    await d.restoreCookies(
      recording.session?.cookies ?? const [],
      recipe.entryUrl,
    );

    final completedSteps = <String>[];

    for (var i = 0; i < recording.steps.length; i++) {
      final recorded = recording.steps[i];
      final stepDef = _stepDefinitionFor(recipe, recorded.stepId);

      void progress(ReplayStepState state) =>
          onProgress?.call(ReplayProgress(stepId: stepDef.id, state: state));

      progress(ReplayStepState.navigating);

      // Entry URL. For tap steps this MUST be the page the tap happened on
      // (tapTarget.pageUrl) — the recorded visitedUrls already contain the
      // POST-tap destination, and tapping there hits whatever element the
      // selector coincidentally matches on the landing page (observed:
      // replay clicking a product link on the order detail page, putting
      // every later step one level off). For non-tap steps, the first
      // visitedUrl (or the current page / recipe entry for the first step).
      //
      // Exception: the FIRST step always starts from recipe.entryUrl. Its
      // recorded first visitedUrl is typically a mid-auth-chain URL (OAuth
      // redirect with a long-dead state/code_challenge), which on a cold run
      // hangs or lands on an error page instead of riding the restored
      // session — the observed "first replay gets stuck, later runs smooth".
      final tapTarget = stepDef.captureTap ? recorded.tapTarget : null;
      String? url;
      if (i == 0) {
        url = recipe.entryUrl;
      } else if (tapTarget != null && tapTarget.pageUrl.isNotEmpty) {
        url = tapTarget.pageUrl;
      } else if (recorded.visitedUrls.isNotEmpty) {
        url = recorded.visitedUrls.first;
      }
      url ??= (await _safeGetUrl(d)) ?? recipe.entryUrl;

      try {
        await d.loadUrl(url);
        await d.waitForLoad(stepTimeout);
      } catch (_) {
        return ReplayResult(
          status: ReplayStatus.stepFailed,
          failedStepId: stepDef.id,
          failureReason: 'navigation-timeout',
          completedSteps: completedSteps,
        );
      }

      if (stepDef.waitForNetworkIdle) {
        // Best-effort idle wait for SPA content settling.
        await Future<void>.delayed(networkIdleQuiet);
      }

      // Session-expiry check after navigation.
      if (await _isSessionExpired(d, recipe)) {
        return ReplayResult(
          status: ReplayStatus.sessionExpired,
          failedStepId: stepDef.id,
          failureReason: 'session-expired',
          completedSteps: completedSteps,
        );
      }

      // Tap dispatch (tapTarget resolved above for URL selection).
      if (tapTarget != null) {
        progress(ReplayStepState.tapping);
        final matched = await _dispatchTap(d, tapTarget);
        if (!matched) {
          return ReplayResult(
            status: ReplayStatus.stepFailed,
            failedStepId: stepDef.id,
            failureReason: 'no-selector-matched',
            completedSteps: completedSteps,
          );
        }
        // The tap may have triggered a navigation; wait best-effort and
        // re-check session expiry on the landed page.
        try {
          await d.waitForLoad(stepTimeout);
        } catch (_) {
          // Non-navigating taps (in-page SPA transitions) end here.
        }
        if (await _isSessionExpired(d, recipe)) {
          return ReplayResult(
            status: ReplayStatus.sessionExpired,
            failedStepId: stepDef.id,
            failureReason: 'session-expired',
            completedSteps: completedSteps,
          );
        }
      }

      completedSteps.add(stepDef.id);
      progress(ReplayStepState.done);

      if (untilStepId != null && stepDef.id == untilStepId) {
        return ReplayResult(
          status: ReplayStatus.success,
          finalUrl: await _safeGetUrl(d),
          finalHtml: await _safeGetHtml(d),
          completedSteps: completedSteps,
        );
      }
    }

    return ReplayResult(
      status: ReplayStatus.success,
      finalUrl: await _safeGetUrl(d),
      finalHtml: await _safeGetHtml(d),
      completedSteps: completedSteps,
    );
  }

  ///Finds the recipe's step definition for a recorded step id. When the
  ///recording has a step the recipe no longer defines (recipe edited after
  ///recording), falls back to a definition that dispatches the captured tap
  ///(if any) and skips the network-idle wait.
  static RecipeStepDefinition _stepDefinitionFor(
    SessionRecipe recipe,
    String stepId,
  ) {
    for (final step in recipe.steps) {
      if (step.id == stepId) return step;
    }
    return RecipeStepDefinition(id: stepId, instruction: '', captureTap: true);
  }

  ///Polls the page until the tap target resolves, then clicks it.
  ///
  ///Replay pages are often SPAs still rendering when `waitForLoad` returns —
  ///dispatching once immediately is what made replay fail with
  ///"no-selector-matched" (or click the wrong element) on slow sections like
  ///the orders list. Retrying bounded by [stepTimeout] is the wait-for-
  ///selector mechanism: `resolveAndClickJs` only clicks when it finds the
  ///target, so polling is side-effect free until the element appears.
  Future<bool> _dispatchTap(ReplayDriver d, TapTarget target) async {
    final js = resolveAndClickJs(
      target.selectorCandidates,
      target.textContent,
      xpath: target.xpath,
    );
    final deadline = DateTime.now().add(stepTimeout);
    while (true) {
      try {
        final raw = await d.evaluateJavascript(js);
        bool matched = false;
        if (raw is String) {
          final decoded = jsonDecode(raw);
          if (decoded is Map) matched = decoded['matched'] == true;
        } else if (raw is Map) {
          matched = raw['matched'] == true;
        }
        if (matched) return true;
      } catch (_) {
        // JS context may be torn down mid-navigation; keep polling.
      }
      if (DateTime.now().isAfter(deadline)) return false;
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
  }

  Future<bool> _isSessionExpired(ReplayDriver d, SessionRecipe recipe) async {
    final url = await _safeGetUrl(d);
    if (url != null) {
      for (final pattern in recipe.loggedOutUrlPatterns) {
        if (matchesUrlPattern(pattern, url)) return true;
      }
    }
    if (recipe.loggedOutSelectors.isNotEmpty) {
      try {
        final result = await d.evaluateJavascript(
          matchesAnySelectorJs(recipe.loggedOutSelectors),
        );
        if (result == true || result == 'true') return true;
      } catch (_) {
        // Selector check is best-effort.
      }
    }
    return false;
  }

  Future<String?> _safeGetUrl(ReplayDriver d) async {
    try {
      return await d.getUrl();
    } catch (_) {
      return null;
    }
  }

  Future<String?> _safeGetHtml(ReplayDriver d) async {
    try {
      return await d.getHtml();
    } catch (_) {
      return null;
    }
  }

  ///Glob-style matcher for `loggedOutUrlPatterns`: `*` matches any run of
  ///characters, `?` a single character; the whole URL must match.
  static bool matchesUrlPattern(String pattern, String url) {
    final buffer = StringBuffer('^');
    for (final unit in pattern.runes) {
      final char = String.fromCharCode(unit);
      switch (char) {
        case '*':
          buffer.write('.*');
          break;
        case '?':
          buffer.write('.');
          break;
        default:
          buffer.write(RegExp.escape(char));
      }
    }
    buffer.write(r'$');
    return RegExp(buffer.toString()).hasMatch(url);
  }
}
