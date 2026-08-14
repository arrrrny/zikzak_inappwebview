///Data models for the guided session recipe (record & replay) feature.
///
///All entities are plain Dart classes with `toJson`/`fromJson` and are
///storage-agnostic: the consuming app persists them as JSON maps.
library;

///Declarative, site-agnostic guided-flow definition, authored and bundled
///with the app.
class SessionRecipe {
  ///Unique recipe id, e.g. `"hepsiburada-order-detail"`.
  final String id;

  ///Display name.
  final String name;

  ///Where the webview opens.
  final String entryUrl;

  ///Ordered step definitions (min 1).
  final List<RecipeStepDefinition> steps;

  ///URL substrings/globs indicating an expired session, e.g. `*/giris*`.
  final List<String> loggedOutUrlPatterns;

  ///CSS selectors whose presence means logged out.
  final List<String> loggedOutSelectors;

  ///Schema version of the definition, starts at 1.
  final int version;

  SessionRecipe({
    required this.id,
    required this.name,
    required this.entryUrl,
    required this.steps,
    List<String>? loggedOutUrlPatterns,
    List<String>? loggedOutSelectors,
    this.version = 1,
  }) : loggedOutUrlPatterns =
           loggedOutUrlPatterns ?? const <String>[],
       loggedOutSelectors = loggedOutSelectors ?? const <String>[];

  ///Whether the recipe is structurally valid: non-empty [steps] and unique
  ///step ids.
  bool isValid() {
    if (steps.isEmpty) return false;
    final ids = <String>{};
    for (final step in steps) {
      if (step.id.isEmpty || !ids.add(step.id)) return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'entryUrl': entryUrl,
    'steps': steps.map((s) => s.toJson()).toList(),
    'loggedOutUrlPatterns': loggedOutUrlPatterns,
    'loggedOutSelectors': loggedOutSelectors,
    'version': version,
  };

  factory SessionRecipe.fromJson(Map<String, dynamic> json) => SessionRecipe(
    id: json['id'] as String,
    name: json['name'] as String,
    entryUrl: json['entryUrl'] as String,
    steps: (json['steps'] as List<dynamic>)
        .map((e) => RecipeStepDefinition.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    loggedOutUrlPatterns: (json['loggedOutUrlPatterns'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    loggedOutSelectors: (json['loggedOutSelectors'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    version: json['version'] as int? ?? 1,
  );
}

///A single step of a [SessionRecipe].
class RecipeStepDefinition {
  ///Unique step id within the recipe, e.g. `"login"`, `"go-to-orders"`.
  final String id;

  ///Overlay text shown to the user.
  final String instruction;

  ///Whether a DOM tap target is recorded for replay.
  final bool captureTap;

  ///Substrings matched against network request URLs during the step
  ///(live feedback only).
  final List<String> signalPatterns;

  ///Whether replay waits for network idle before tapping; default `false`.
  final bool waitForNetworkIdle;

  RecipeStepDefinition({
    required this.id,
    required this.instruction,
    this.captureTap = false,
    List<String>? signalPatterns,
    this.waitForNetworkIdle = false,
  }) : signalPatterns = signalPatterns ?? const <String>[];

  Map<String, dynamic> toJson() => {
    'id': id,
    'instruction': instruction,
    'captureTap': captureTap,
    'signalPatterns': signalPatterns,
    'waitForNetworkIdle': waitForNetworkIdle,
  };

  factory RecipeStepDefinition.fromJson(Map<String, dynamic> json) =>
      RecipeStepDefinition(
        id: json['id'] as String,
        instruction: json['instruction'] as String,
        captureTap: json['captureTap'] as bool? ?? false,
        signalPatterns: (json['signalPatterns'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        waitForNetworkIdle: json['waitForNetworkIdle'] as bool? ?? false,
      );
}

///A recorded session against a [SessionRecipe], persisted by the app.
class RecipeRecording {
  ///UUID, used as the persistence box key.
  final String id;

  ///Id of the [SessionRecipe] this recording belongs to.
  final String recipeId;

  ///Definition version recorded against.
  final int recipeVersion;

  ///Site host, e.g. `www.hepsiburada.com` (display/listing aid).
  final String siteHost;

  ///ISO-8601 creation time.
  final String createdAt;

  ///Ordered recorded steps; same length as the definition on completion.
  final List<RecordedStep> steps;

  ///Cookies captured at final step completion.
  final SessionSnapshot? session;

  ///`false` for abandoned partial recordings.
  final bool complete;

  RecipeRecording({
    required this.id,
    required this.recipeId,
    required this.recipeVersion,
    required this.siteHost,
    required this.createdAt,
    required this.steps,
    this.session,
    this.complete = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'recipeId': recipeId,
    'recipeVersion': recipeVersion,
    'siteHost': siteHost,
    'createdAt': createdAt,
    'steps': steps.map((s) => s.toJson()).toList(),
    'session': session?.toJson(),
    'complete': complete,
  };

  factory RecipeRecording.fromJson(Map<String, dynamic> json) =>
      RecipeRecording(
        id: json['id'] as String,
        recipeId: json['recipeId'] as String,
        recipeVersion: json['recipeVersion'] as int? ?? 1,
        siteHost: json['siteHost'] as String,
        createdAt: json['createdAt'] as String,
        steps: (json['steps'] as List<dynamic>)
            .map((e) => RecordedStep.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        session: json['session'] != null
            ? SessionSnapshot.fromJson(
                Map<String, dynamic>.from(json['session'] as Map),
              )
            : null,
        complete: json['complete'] as bool? ?? false,
      );
}

///Everything captured for one step during recording.
class RecordedStep {
  ///Id of the corresponding [RecipeStepDefinition].
  final String stepId;

  ///Ordered URL cycle (incl. redirects) observed during the step.
  final List<String> visitedUrls;

  ///Null unless `captureTap` and a tap was captured.
  TapTarget? tapTarget;

  ///Network entries matching the step's `signalPatterns`.
  final List<RecordedSignal> signals;

  ///ISO-8601 user-confirmation time; empty string until confirmed.
  String confirmedAt;

  ///Full page HTML captured at step confirmation — an artifact for offline
  ///selector validation and for generating ORDER configs later. Null when
  ///the snapshot could not be taken (e.g. no controller attached).
  String? pageHtml;

  RecordedStep({
    required this.stepId,
    List<String>? visitedUrls,
    this.tapTarget,
    List<RecordedSignal>? signals,
    this.confirmedAt = '',
    this.pageHtml,
  }) : visitedUrls = visitedUrls ?? <String>[],
       signals = signals ?? <RecordedSignal>[];

  Map<String, dynamic> toJson() => {
    'stepId': stepId,
    'visitedUrls': visitedUrls,
    'tapTarget': tapTarget?.toJson(),
    'signals': signals.map((s) => s.toJson()).toList(),
    'confirmedAt': confirmedAt,
    'pageHtml': pageHtml,
  };

  factory RecordedStep.fromJson(Map<String, dynamic> json) => RecordedStep(
    stepId: json['stepId'] as String,
    visitedUrls: (json['visitedUrls'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    tapTarget: json['tapTarget'] != null
        ? TapTarget.fromJson(Map<String, dynamic>.from(json['tapTarget'] as Map))
        : null,
    signals: (json['signals'] as List<dynamic>?)
        ?.map((e) => RecordedSignal.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    confirmedAt: json['confirmedAt'] as String? ?? '',
    pageHtml: json['pageHtml'] as String?,
  );
}

///A DOM tap target captured for replay.
class TapTarget {
  ///CSS selectors, most-stable first (validated in-page at record time;
  ///unique matches lead the list).
  final List<String> selectorCandidates;

  ///Positional XPath (id-anchored when possible) — CSS fallback during
  ///replay. Null for recordings made before XPath capture existed.
  final String? xpath;

  ///Normalized visible text — disambiguator and last-resort match.
  final String? textContent;

  ///Element tag name, e.g. `A`, `BUTTON`.
  final String tagName;

  ///URL where the tap occurred.
  final String pageUrl;

  TapTarget({
    required this.selectorCandidates,
    this.xpath,
    this.textContent,
    required this.tagName,
    required this.pageUrl,
  });

  Map<String, dynamic> toJson() => {
    'selectorCandidates': selectorCandidates,
    'xpath': xpath,
    'textContent': textContent,
    'tagName': tagName,
    'pageUrl': pageUrl,
  };

  factory TapTarget.fromJson(Map<String, dynamic> json) => TapTarget(
    selectorCandidates: (json['selectorCandidates'] as List<dynamic>)
        .map((e) => e.toString())
        .toList(),
    xpath: json['xpath'] as String?,
    textContent: json['textContent'] as String?,
    tagName: json['tagName'] as String,
    pageUrl: json['pageUrl'] as String,
  );
}

///A network request that matched one of the step's `signalPatterns`.
class RecordedSignal {
  ///Request URL that matched a pattern.
  final String url;

  ///HTTP method.
  final String method;

  ///Status code from the response, if observed.
  int? statusCode;

  ///Request headers (for future network-intercept replay).
  final Map<String, String> requestHeaders;

  ///Which `signalPatterns` entry matched.
  final String matchedPattern;

  RecordedSignal({
    required this.url,
    required this.method,
    this.statusCode,
    Map<String, String>? requestHeaders,
    required this.matchedPattern,
  }) : requestHeaders = requestHeaders ?? <String, String>{};

  Map<String, dynamic> toJson() => {
    'url': url,
    'method': method,
    'statusCode': statusCode,
    'requestHeaders': requestHeaders,
    'matchedPattern': matchedPattern,
  };

  factory RecordedSignal.fromJson(Map<String, dynamic> json) => RecordedSignal(
    url: json['url'] as String,
    method: json['method'] as String,
    statusCode: json['statusCode'] as int?,
    requestHeaders: (json['requestHeaders'] as Map?)?.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    ),
    matchedPattern: json['matchedPattern'] as String,
  );
}

///Cookies captured at the end of a recording.
class SessionSnapshot {
  ///Cookies filtered to the site domain (and parents).
  final List<CookieEntry> cookies;

  ///ISO-8601 capture time.
  final String capturedAt;

  SessionSnapshot({List<CookieEntry>? cookies, required this.capturedAt})
    : cookies = cookies ?? <CookieEntry>[];

  Map<String, dynamic> toJson() => {
    'cookies': cookies.map((c) => c.toJson()).toList(),
    'capturedAt': capturedAt,
  };

  factory SessionSnapshot.fromJson(Map<String, dynamic> json) =>
      SessionSnapshot(
        cookies: (json['cookies'] as List<dynamic>?)
            ?.map((e) => CookieEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        capturedAt: json['capturedAt'] as String,
      );
}

///A single cookie inside a [SessionSnapshot].
class CookieEntry {
  ///Cookie name.
  final String name;

  ///Cookie value.
  final String value;

  ///Cookie domain.
  final String? domain;

  ///Cookie path, default `/`.
  final String path;

  ///Expiration date in ms epoch.
  final int? expiresDate;

  ///Secure flag.
  final bool? isSecure;

  ///HttpOnly flag.
  final bool? isHttpOnly;

  CookieEntry({
    required this.name,
    required this.value,
    this.domain,
    this.path = '/',
    this.expiresDate,
    this.isSecure,
    this.isHttpOnly,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
    'domain': domain,
    'path': path,
    'expiresDate': expiresDate,
    'isSecure': isSecure,
    'isHttpOnly': isHttpOnly,
  };

  factory CookieEntry.fromJson(Map<String, dynamic> json) => CookieEntry(
    name: json['name'] as String,
    value: json['value'] as String,
    domain: json['domain'] as String?,
    path: json['path'] as String? ?? '/',
    expiresDate: json['expiresDate'] as int?,
    isSecure: json['isSecure'] as bool?,
    isHttpOnly: json['isHttpOnly'] as bool?,
  );
}

///Terminal replay status.
enum ReplayStatus {
  ///All steps completed; [ReplayResult.finalUrl]/[ReplayResult.finalHtml] set.
  success,

  ///The session is no longer valid (logged-out URL or selector detected).
  sessionExpired,

  ///A step failed (see [ReplayResult.failureReason]).
  stepFailed;

  ///Parses a [ReplayStatus] from its [name].
  static ReplayStatus fromName(String name) => ReplayStatus.values.firstWhere(
    (e) => e.name == name,
    orElse: () => ReplayStatus.stepFailed,
  );
}

///Terminal result of a replay run. Never throws for expected failures.
class ReplayResult {
  ///Terminal state.
  final ReplayStatus status;

  ///Set unless [status] is [ReplayStatus.success].
  final String? failedStepId;

  ///e.g. `no-selector-matched`, `navigation-timeout`.
  final String? failureReason;

  ///Landed URL on success.
  final String? finalUrl;

  ///Page HTML for the caller on success.
  final String? finalHtml;

  ///Step ids completed before the terminal state.
  final List<String> completedSteps;

  ReplayResult({
    required this.status,
    this.failedStepId,
    this.failureReason,
    this.finalUrl,
    this.finalHtml,
    List<String>? completedSteps,
  }) : completedSteps = completedSteps ?? <String>[];

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'failedStepId': failedStepId,
    'failureReason': failureReason,
    'finalUrl': finalUrl,
    'finalHtml': finalHtml,
    'completedSteps': completedSteps,
  };

  factory ReplayResult.fromJson(Map<String, dynamic> json) => ReplayResult(
    status: ReplayStatus.fromName(json['status'] as String? ?? ''),
    failedStepId: json['failedStepId'] as String?,
    failureReason: json['failureReason'] as String?,
    finalUrl: json['finalUrl'] as String?,
    finalHtml: json['finalHtml'] as String?,
    completedSteps: (json['completedSteps'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
  );
}

///Replay step state reported through [ReplayProgress].
enum ReplayStepState {
  ///Navigating to the step's entry URL.
  navigating,

  ///Dispatching the recorded tap.
  tapping,

  ///Step completed.
  done;

  ///Parses a [ReplayStepState] from its [name].
  static ReplayStepState fromName(String name) =>
      ReplayStepState.values.firstWhere(
        (e) => e.name == name,
        orElse: () => ReplayStepState.navigating,
      );
}

///Progress event emitted per step during replay.
class ReplayProgress {
  ///Id of the step in progress.
  final String stepId;

  ///Current state of the step.
  final ReplayStepState state;

  ReplayProgress({required this.stepId, required this.state});

  Map<String, dynamic> toJson() => {'stepId': stepId, 'state': state.name};

  factory ReplayProgress.fromJson(Map<String, dynamic> json) => ReplayProgress(
    stepId: json['stepId'] as String,
    state: ReplayStepState.fromName(json['state'] as String? ?? ''),
  );
}
