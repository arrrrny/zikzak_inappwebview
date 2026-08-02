import 'dart:collection';
import 'dart:math';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../cookie_manager.dart';
import '../in_app_webview/in_app_webview_controller.dart';
import '../navigation_tracker/navigation_tracker.dart';
import '../navigation_tracker/url_cycle_entry.dart';
import 'models.dart';
import 'tap_listener_js.dart';

///Signature of the [RecipeRecorder] event callback.
typedef RecipeRecorderCallback = void Function(RecipeRecorderEvent event);

///Base type for [RecipeRecorder] events (live overlay feedback).
sealed class RecipeRecorderEvent {
  const RecipeRecorderEvent();
}

///A tap target was captured for the current step.
class TapCaptured extends RecipeRecorderEvent {
  ///The captured tap target.
  final TapTarget target;

  const TapCaptured(this.target);
}

///A network request matched one of the current step's `signalPatterns`.
class SignalMatched extends RecipeRecorderEvent {
  ///The matched signal.
  final RecordedSignal signal;

  const SignalMatched(this.signal);
}

///A URL change was observed while the current step was active.
class UrlVisited extends RecipeRecorderEvent {
  ///The visited URL.
  final String url;

  const UrlVisited(this.url);
}

///The recorder advanced to a new step.
class StepAdvanced extends RecipeRecorderEvent {
  ///The new current step index.
  final int newStepIndex;

  const StepAdvanced(this.newStepIndex);
}

///Recording finished (all steps confirmed, cookies snapshotted).
class RecordingFinished extends RecipeRecorderEvent {
  ///The final, complete recording.
  final RecipeRecording recording;

  const RecordingFinished(this.recording);
}

///Drives recording of one [SessionRecipe] against one WebView instance.
///
///Architecture mirrors `NetworkCaptureManager`: [maybeCreate] builds the
///recorder and its tap-listener [UserScript], [mergeUserScripts] composes
///caller scripts with the recorder's and its internal `NavigationTracker`'s
///scripts, and [attach] registers the `__zikzakRecipeTap__` JavaScript
///handler.
///
///Step logic, signal matching and URL slicing are usable without a WebView:
///[handleTapPayload], [onNetworkRequest], [onNetworkResponse] and the step
///control methods operate on a plain instance; [attach] only wires the JS
///bridges.
class RecipeRecorder {
  ///The recipe being recorded.
  final SessionRecipe recipe;

  final RecipeRecorderCallback? _onEvent;

  ///The internal navigation tracker; its entries are sliced per step.
  final NavigationTracker tracker;

  final String _id;
  final String _createdAt;
  final List<RecordedStep> _steps;

  int _currentStepIndex = 0;
  bool _finished = false;
  InAppWebViewController? _controller;

  ///When the last tap payload was accepted, for duplicate-tap suppression.
  DateTime? _lastTapAt;

  ///Window during which an identical tap payload is treated as an
  ///accidental double-click (or a touchend/click double-fire) and ignored.
  static const Duration _tapDedupWindow = Duration(milliseconds: 1500);

  RecipeRecorder._({
    required this.recipe,
    required RecipeRecorderCallback? onEvent,
    required this.tracker,
  }) : _onEvent = onEvent,
       _id = _generateId(),
       _createdAt = DateTime.now().toIso8601String(),
       _steps = recipe.steps
           .map((def) => RecordedStep(stepId: def.id))
           .toList();

  ///Creates a recorder and its tap-listener [UserScript].
  ///Returns `null` if [recipe] is invalid (empty steps, duplicate step ids).
  static RecipeRecorder? maybeCreate({
    required SessionRecipe recipe,
    RecipeRecorderCallback? onEvent,
  }) {
    if (!recipe.isValid()) return null;
    late final RecipeRecorder recorder;
    final tracker = NavigationTracker(
      onUrlCycleEntry: (entry) => recorder._onUrlCycleEntry(entry),
    );
    recorder = RecipeRecorder._(
      recipe: recipe,
      onEvent: onEvent,
      tracker: tracker,
    );
    return recorder;
  }

  ///Merges the recorder's scripts (tap listener + navigation tracker) into
  ///the caller-provided scripts. Same convention as
  ///`NetworkCaptureManager.mergeUserScripts`.
  static UnmodifiableListView<UserScript>? mergeUserScripts(
    List<UserScript>? userScripts,
    RecipeRecorder? recorder,
  ) {
    if (recorder == null) {
      return userScripts == null ? null : UnmodifiableListView(userScripts);
    }
    return UnmodifiableListView<UserScript>(<UserScript>[
      ...?userScripts,
      recorder.buildTapListenerUserScript(),
      recorder.tracker.buildUserScript(),
    ]);
  }

  ///Builds the tap-listener script to add to the initial user scripts.
  UserScript buildTapListenerUserScript() {
    return UserScript(
      groupName: 'zikzakRecipeTap',
      source: buildRecipeTapListenerJs(),
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      forMainFrameOnly: false,
    );
  }

  ///Current step index.
  int get currentStepIndex => _currentStepIndex;

  ///Definition of the current step.
  RecipeStepDefinition get currentStep => recipe.steps[_currentStepIndex];

  ///Live view of the recording (`complete == false` until [finish]).
  RecipeRecording get partialRecording => RecipeRecording(
    id: _id,
    recipeId: recipe.id,
    recipeVersion: recipe.version,
    siteHost: _siteHost,
    createdAt: _createdAt,
    steps: List<RecordedStep>.unmodifiable(_steps),
    complete: false,
  );

  ///Registers the tap JavaScript handler on [controller] and attaches the
  ///navigation tracker. Call from `onWebViewCreated`.
  void attach(InAppWebViewController controller) {
    _controller = controller;
    controller.addJavaScriptHandler(
      handlerName: kRecipeTapHandlerName,
      callback: (arguments) {
        if (arguments.isEmpty) return null;
        final raw = arguments[0];
        if (raw is Map) {
          handleTapPayload(Map<String, dynamic>.from(raw));
        }
        return null;
      },
    );
    tracker.attach(controller);
    _flushTapQueue();
  }

  ///Removes the JavaScript handlers.
  void detach() {
    final controller = _controller;
    if (controller != null) {
      controller.removeJavaScriptHandler(handlerName: kRecipeTapHandlerName);
    }
    _controller = null;
    tracker.detach();
  }

  ///Forward from the widget's `onLoadStart` callback.
  void onLoadStart(WebUri? url) => tracker.onLoadStart(url);

  ///Forward from the widget's `onUpdateVisitedHistory` callback.
  void onUpdateVisitedHistory(WebUri? url) =>
      tracker.onUpdateVisitedHistory(url);

  ///Processes a raw tap payload reported by the tap-listener script.
  ///Public so it can be unit-tested without a WebView.
  void handleTapPayload(Map<String, dynamic> payload) {
    if (_finished) return;
    // Taps are only meaningful on steps that declared captureTap — e.g. the
    // login step ignores the "Giriş yap" button click instead of recording
    // it as a replayable action.
    if (!currentStep.captureTap) return;
    final candidates =
        (payload['selectorCandidates'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];
    final target = TapTarget(
      selectorCandidates: candidates,
      xpath: payload['xpath']?.toString(),
      textContent: payload['textContent']?.toString(),
      tagName: payload['tagName']?.toString() ?? '',
      pageUrl: payload['pageUrl']?.toString() ?? '',
    );
    // Suppress accidental double-captures: an identical tap on the same
    // element within [_tapDedupWindow] is a double-click (or a
    // touchend/click double-fire), not a new intent.
    final now = DateTime.now();
    final previous = _steps[_currentStepIndex].tapTarget;
    final lastAt = _lastTapAt;
    if (previous != null &&
        lastAt != null &&
        now.difference(lastAt) < _tapDedupWindow &&
        _sameTapTarget(previous, target)) {
      return;
    }
    _lastTapAt = now;
    // Latest tap wins per step.
    _steps[_currentStepIndex].tapTarget = target;
    _emit(TapCaptured(target));
  }

  static bool _sameTapTarget(TapTarget a, TapTarget b) {
    return a.pageUrl == b.pageUrl &&
        a.textContent == b.textContent &&
        a.tagName == b.tagName &&
        a.selectorCandidates.join('') == b.selectorCandidates.join('');
  }

  ///Forward from the network capture pipeline: matches the request URL
  ///against the current step's `signalPatterns` (case-insensitive
  ///substring) and records a [RecordedSignal] on the first match.
  void onNetworkRequest(NetworkRequest request) {
    if (_finished) return;
    final url = request.url.toString();
    final lowerUrl = url.toLowerCase();
    for (final pattern in currentStep.signalPatterns) {
      if (pattern.isEmpty) continue;
      if (lowerUrl.contains(pattern.toLowerCase())) {
        final signal = RecordedSignal(
          url: url,
          method: request.method,
          requestHeaders: Map<String, String>.from(request.headers),
          matchedPattern: pattern,
        );
        _steps[_currentStepIndex].signals.add(signal);
        _emit(SignalMatched(signal));
        break;
      }
    }
  }

  ///Forward from the network capture pipeline: backfills `statusCode` on
  ///the matching signal of the current step.
  void onNetworkResponse(NetworkResponse response) {
    if (_finished) return;
    final url = response.url.toString();
    final signals = _steps[_currentStepIndex].signals;
    for (var i = signals.length - 1; i >= 0; i--) {
      if (signals[i].url == url && signals[i].statusCode == null) {
        signals[i].statusCode = response.statusCode;
        break;
      }
    }
  }

  ///Freezes the current step's captures and advances; confirming the last
  ///step auto-finishes the recording.
  ///
  ///Also snapshots the page HTML into [RecordedStep.pageHtml] (best-effort,
  ///requires an attached controller) — the artifact used for offline
  ///selector validation and ORDER-config generation.
  Future<void> confirmCurrentStep() async {
    if (_finished) return;
    final step = _steps[_currentStepIndex];
    step.confirmedAt = DateTime.now().toIso8601String();
    final controller = _controller;
    if (controller != null) {
      try {
        step.pageHtml = await controller.getHtml();
      } catch (_) {
        // Snapshot is best-effort; a null pageHtml is acceptable.
      }
    }
    if (_currentStepIndex >= recipe.steps.length - 1) {
      await finish();
      return;
    }
    _currentStepIndex++;
    _emit(StepAdvanced(_currentStepIndex));
  }

  ///Discards the current step's captures (stays on the same step).
  void redoCurrentStep() {
    if (_finished) return;
    _steps[_currentStepIndex] = RecordedStep(stepId: currentStep.id);
    _lastTapAt = null;
  }

  ///Completes the recording: snapshots cookies via `CookieManager`,
  ///filtered to the site host's domain tree, marks the recording complete
  ///and returns it.
  Future<RecipeRecording> finish() async {
    if (_finished) return partialRecording;
    _finished = true;

    List<CookieEntry> cookies = const <CookieEntry>[];
    try {
      final all = await CookieManager.instance().getAllCookies();
      cookies = all
          .where((c) => cookieAppliesToHost(c.domain, _siteHost))
          .map(
            (c) => CookieEntry(
              name: c.name,
              value: c.value?.toString() ?? '',
              domain: c.domain,
              path: c.path ?? '/',
              expiresDate: c.expiresDate,
              isSecure: c.isSecure,
              isHttpOnly: c.isHttpOnly,
            ),
          )
          .toList();
    } catch (_) {
      // Cookie snapshot is best-effort (e.g. unsupported platform).
    }

    final recording = RecipeRecording(
      id: _id,
      recipeId: recipe.id,
      recipeVersion: recipe.version,
      siteHost: _siteHost,
      createdAt: _createdAt,
      steps: List<RecordedStep>.unmodifiable(_steps),
      session: SessionSnapshot(
        cookies: cookies,
        capturedAt: DateTime.now().toIso8601String(),
      ),
      complete: true,
    );
    _emit(RecordingFinished(recording));
    return recording;
  }

  ///Whether a cookie with [cookieDomain] applies to [host]: exact match,
  ///parent domain, or subdomain of the site host.
  static bool cookieAppliesToHost(String? cookieDomain, String host) {
    if (host.isEmpty) return true;
    var domain = (cookieDomain ?? '').toLowerCase();
    if (domain.startsWith('.')) domain = domain.substring(1);
    if (domain.isEmpty) return false;
    final h = host.toLowerCase();
    return h == domain ||
        h.endsWith('.$domain') ||
        domain.endsWith('.$h');
  }

  String get _siteHost {
    try {
      return Uri.parse(recipe.entryUrl).host;
    } catch (_) {
      return '';
    }
  }

  void _onUrlCycleEntry(UrlCycleEntry entry) {
    if (_finished) return;
    final step = _steps[_currentStepIndex];
    if (step.visitedUrls.isEmpty || step.visitedUrls.last != entry.url) {
      step.visitedUrls.add(entry.url);
      _emit(UrlVisited(entry.url));
    }
  }

  void _emit(RecipeRecorderEvent event) => _onEvent?.call(event);

  Future<void> _flushTapQueue() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.evaluateJavascript(
        source:
            'window.__zikzakRecipeTap__ && window.__zikzakRecipeTap__.ready ? window.__zikzakRecipeTap__.ready() : 0;',
      );
    } catch (_) {
      // The page may not exist yet or navigation may have aborted.
    }
  }

  static String _generateId() {
    final now = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final rand = Random().nextInt(0x7fffffff).toRadixString(36);
    return '$now-$rand';
  }
}
