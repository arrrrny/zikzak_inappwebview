import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

///Configurable [ReplayDriver] fake — no WebView involved.
class FakeReplayDriver implements ReplayDriver {
  ///Ordered interaction log (`restoreCookies`, `loadUrl:<url>`, ...).
  final List<String> calls = <String>[];

  ///Current URL reported by [getUrl].
  String currentUrl = 'about:blank';

  ///HTML reported by [getHtml].
  String? html = '<html>final</html>';

  ///Number of [loadUrl] calls so far.
  int loadCount = 0;

  ///URL to move to after the Nth [loadUrl] (0-based).
  final Map<int, String> urlAfterLoad = <int, String>{};

  ///When true, [waitForLoad] throws a [TimeoutException].
  bool failNextWait = false;

  ///Evaluates JS snippets; defaults to a successful click.
  dynamic Function(String source)? evaluator;

  ///Sources passed to [evaluateJavascript].
  final List<String> evaluatedSources = <String>[];

  @override
  Future<void> restoreCookies(List<CookieEntry> cookies, String entryUrl) async {
    calls.add('restoreCookies:${cookies.map((c) => c.name).join(',')}');
  }

  @override
  Future<void> loadUrl(String url) async {
    calls.add('loadUrl:$url');
    final index = loadCount++;
    final next = urlAfterLoad[index];
    currentUrl = next ?? url;
  }

  @override
  Future<void> waitForLoad(Duration timeout) async {
    calls.add('waitForLoad');
    if (failNextWait) {
      failNextWait = false;
      throw TimeoutException('navigation-timeout', timeout);
    }
  }

  @override
  Future<dynamic> evaluateJavascript(String source) async {
    calls.add('evaluateJavascript');
    evaluatedSources.add(source);
    if (evaluator != null) return evaluator!(source);
    return jsonEncode({'matched': true, 'usedSelector': '#first'});
  }

  @override
  Future<String?> getUrl() async => currentUrl;

  @override
  Future<String?> getHtml() async => html;
}

SessionRecipe buildRecipe({
  List<String> loggedOutUrlPatterns = const [],
  List<String> loggedOutSelectors = const [],
}) {
  return SessionRecipe(
    id: 'test-recipe',
    name: 'Test',
    entryUrl: 'https://shop.example.com',
    steps: [
      RecipeStepDefinition(id: 'login', instruction: 'Log in'),
      RecipeStepDefinition(
        id: 'go-to-orders',
        instruction: 'Open orders',
        captureTap: true,
      ),
    ],
    loggedOutUrlPatterns: loggedOutUrlPatterns,
    loggedOutSelectors: loggedOutSelectors,
  );
}

RecipeRecording buildRecording() {
  return RecipeRecording(
    id: 'rec-1',
    recipeId: 'test-recipe',
    recipeVersion: 1,
    siteHost: 'shop.example.com',
    createdAt: '2026-08-02T04:00:00.000Z',
    steps: [
      RecordedStep(
        stepId: 'login',
        visitedUrls: ['https://shop.example.com'],
        confirmedAt: '2026-08-02T04:01:00.000Z',
      ),
      RecordedStep(
        stepId: 'go-to-orders',
        visitedUrls: ['https://shop.example.com/account'],
        tapTarget: TapTarget(
          selectorCandidates: ['#orders-link', 'a.menu-orders'],
          textContent: 'Orders',
          tagName: 'A',
          pageUrl: 'https://shop.example.com/account',
        ),
        confirmedAt: '2026-08-02T04:02:00.000Z',
      ),
    ],
    session: SessionSnapshot(
      cookies: [CookieEntry(name: 'session', value: 'abc')],
      capturedAt: '2026-08-02T04:03:00.000Z',
    ),
    complete: true,
  );
}

void main() {
  group('RecipeReplayer', () {
    test('success: cookies restored before first loadUrl, steps completed', () async {
      final driver = FakeReplayDriver();
      final progress = <ReplayProgress>[];

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
        onProgress: progress.add,
      );

      expect(result.status, ReplayStatus.success);
      expect(result.completedSteps, ['login', 'go-to-orders']);
      expect(result.finalUrl, isNotNull);
      expect(result.finalHtml, '<html>final</html>');

      // Cookies restored before the first loadUrl.
      expect(driver.calls.first, 'restoreCookies:session');
      expect(driver.calls.indexWhere((c) => c.startsWith('loadUrl:')), 1);

      // Steps navigate to the first recorded visitedUrl.
      expect(
        driver.calls.where((c) => c.startsWith('loadUrl:')).toList(),
        [
          'loadUrl:https://shop.example.com',
          'loadUrl:https://shop.example.com/account',
        ],
      );

      // Progress events emitted per step in order.
      expect(
        progress.map((p) => '${p.stepId}:${p.state.name}').toList(),
        [
          'login:navigating',
          'login:done',
          'go-to-orders:navigating',
          'go-to-orders:tapping',
          'go-to-orders:done',
        ],
      );
    });

    test('selector candidates sent in recorded order to the click dispatcher',
        () async {
      final driver = FakeReplayDriver();
      String? clickSource;
      driver.evaluator = (source) {
        if (source.contains('usedSelector')) clickSource = source;
        return jsonEncode({'matched': true, 'usedSelector': 'a.menu-orders'});
      };

      await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
      );

      expect(clickSource, isNotNull);
      final firstId = clickSource!.indexOf('#orders-link');
      final secondSel = clickSource!.indexOf('a.menu-orders');
      expect(firstId, greaterThanOrEqualTo(0));
      expect(secondSel, greaterThan(firstId));
    });

    test('zero selector matches -> stepFailed(no-selector-matched)', () async {
      final driver = FakeReplayDriver();
      driver.evaluator = (source) =>
          jsonEncode({'matched': false, 'usedSelector': null});

      final result = await RecipeReplayer(
        // Tap dispatch polls until stepTimeout; keep the test fast.
        stepTimeout: const Duration(milliseconds: 900),
      ).replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
      );

      expect(result.status, ReplayStatus.stepFailed);
      expect(result.failureReason, 'no-selector-matched');
      expect(result.failedStepId, 'go-to-orders');
      expect(result.completedSteps, ['login']);
    });

    test('tap dispatch retries until the selector appears (SPA settle)',
        () async {
      final driver = FakeReplayDriver();
      var attempts = 0;
      driver.evaluator = (source) {
        attempts++;
        // Selector "appears" on the 3rd poll — earlier polls click nothing.
        return jsonEncode({
          'matched': attempts >= 3,
          'usedSelector': attempts >= 3 ? '#orders-link' : null,
        });
      };

      final result = await RecipeReplayer(
        stepTimeout: const Duration(seconds: 5),
      ).replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
      );

      expect(result.status, ReplayStatus.success);
      expect(result.completedSteps, ['login', 'go-to-orders']);
      expect(attempts, greaterThanOrEqualTo(3));
    });

    test('navigation timeout -> stepFailed(navigation-timeout)', () async {
      final driver = FakeReplayDriver();
      driver.failNextWait = true;

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
      );

      expect(result.status, ReplayStatus.stepFailed);
      expect(result.failureReason, 'navigation-timeout');
      expect(result.failedStepId, 'login');
      expect(result.completedSteps, isEmpty);
    });

    test('loggedOut URL pattern -> sessionExpired with failedStepId', () async {
      final driver = FakeReplayDriver();
      // Second navigation lands on the login page (session expired).
      driver.urlAfterLoad[1] = 'https://shop.example.com/giris-yap';

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(loggedOutUrlPatterns: ['*/giris*', '*/login*']),
        recording: buildRecording(),
      );

      expect(result.status, ReplayStatus.sessionExpired);
      expect(result.failedStepId, 'go-to-orders');
      expect(result.completedSteps, ['login']);
    });

    test('loggedOut selector -> sessionExpired', () async {
      final driver = FakeReplayDriver();
      driver.evaluator = (source) {
        // matchesAnySelectorJs snippets lack 'usedSelector'; click snippets
        // have it.
        if (!source.contains('usedSelector')) return true;
        return jsonEncode({'matched': true, 'usedSelector': '#orders-link'});
      };

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(loggedOutSelectors: ['.login-form']),
        recording: buildRecording(),
      );

      expect(result.status, ReplayStatus.sessionExpired);
      expect(result.failedStepId, 'login');
    });

    test('replay never throws when the driver misbehaves', () async {
      final driver = FakeReplayDriver();
      driver.evaluator = (_) => throw StateError('boom');

      final result = await RecipeReplayer(
        // Tap dispatch keeps polling through JS errors until stepTimeout.
        stepTimeout: const Duration(milliseconds: 900),
      ).replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
      );

      expect(result.status, ReplayStatus.stepFailed);
    });

    test('untilStepId stops after the named step and ignores later steps',
        () async {
      final driver = FakeReplayDriver();

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
        untilStepId: 'login',
      );

      expect(result.status, ReplayStatus.success);
      expect(result.completedSteps, ['login']);
      expect(result.finalUrl, isNotNull);
      expect(result.finalHtml, '<html>final</html>');

      // Only the first step navigated; the second step's tap/URL untouched.
      expect(
        driver.calls.where((c) => c.startsWith('loadUrl:')).toList(),
        ['loadUrl:https://shop.example.com'],
      );
    });

    test('untilStepId on the last step behaves like a full replay', () async {
      final driver = FakeReplayDriver();

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
        untilStepId: 'go-to-orders',
      );

      expect(result.status, ReplayStatus.success);
      expect(result.completedSteps, ['login', 'go-to-orders']);
    });

    test('unknown untilStepId fails fast with stepFailed(unknown-step)',
        () async {
      final driver = FakeReplayDriver();

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: buildRecording(),
        untilStepId: 'no-such-step',
      );

      expect(result.status, ReplayStatus.stepFailed);
      expect(result.failureReason, 'unknown-step');
      expect(result.failedStepId, 'no-such-step');
      expect(result.completedSteps, isEmpty);
      // Fails before any WebView interaction — no cookies restored.
      expect(driver.calls, isEmpty);
    });

    test('replay follows recording steps, so old short recordings still '
        'succeed against a longer recipe', () async {
      final driver = FakeReplayDriver();
      final recipe = buildRecipe();
      // Recipe gains a third step the recording (older version) lacks.
      recipe.steps.add(
        RecipeStepDefinition(
          id: 'open-product',
          instruction: 'Open product',
          captureTap: true,
        ),
      );

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: recipe,
        recording: buildRecording(), // 2 steps, version 1
      );

      expect(result.status, ReplayStatus.success);
      expect(result.completedSteps, ['login', 'go-to-orders']);
      expect(
        driver.calls.where((c) => c.startsWith('loadUrl:')).length,
        2,
      );
    });

    test('recorded step without a recipe definition still dispatches its tap',
        () async {
      final driver = FakeReplayDriver();
      // Recipe only knows 'login'; recording has an extra recorded step.
      final recipe = SessionRecipe(
        id: 'test-recipe',
        name: 'Test',
        entryUrl: 'https://shop.example.com',
        steps: [RecipeStepDefinition(id: 'login', instruction: 'Log in')],
      );

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: recipe,
        recording: buildRecording(),
      );

      expect(result.status, ReplayStatus.success);
      expect(result.completedSteps, ['login', 'go-to-orders']);
      // The tap JS ran for the undefined step's captured tap target.
      expect(
        driver.evaluatedSources.any((s) => s.contains('#orders-link')),
        isTrue,
      );
    });
  });

  group('RecipeReplayer.matchesUrlPattern', () {
    test('glob patterns', () {
      expect(
        RecipeReplayer.matchesUrlPattern(
          '*/giris*',
          'https://shop.example.com/giris-yap?next=%2F',
        ),
        isTrue,
      );
      expect(
        RecipeReplayer.matchesUrlPattern(
          '*/login*',
          'https://shop.example.com/account',
        ),
        isFalse,
      );
      expect(
        RecipeReplayer.matchesUrlPattern(
          'https://example.com/*',
          'https://example.com/a/b?c=d',
        ),
        isTrue,
      );
      expect(
        RecipeReplayer.matchesUrlPattern(
          '*example.com/order/?*',
          'https://example.com/order/123',
        ),
        isTrue,
      );
    });
  });

  group('resolveAndClickJs / matchesAnySelectorJs', () {
    test('resolveAndClickJs embeds candidates in order and the text fallback',
        () {
      final js = resolveAndClickJs(['#a', '.b', 'div > c'], 'Hello');
      expect(js.indexOf('"#a"'), lessThan(js.indexOf('".b"')));
      expect(js.indexOf('".b"'), lessThan(js.indexOf('"div > c"')));
      expect(js, contains('Hello'));
      expect(js, contains('matched'));
      expect(js, contains('usedSelector'));
    });

    test('resolveAndClickJs prefers text-matching candidates', () {
      final js = resolveAndClickJs(['a.card-link', 'a[href*="urun"]'], 'Lav');
      // Text-aware resolution: containsWanted scoring is embedded.
      expect(js, contains('containsWanted'));
      expect(js, contains('indexOf(wanted)'));
      expect(js, contains('Lav'));
    });

    test('resolveAndClickJs embeds the xpath fallback when provided', () {
      final js = resolveAndClickJs(
        ['a.x'],
        null,
        xpath: '//a[@id="product-link"]',
      );
      expect(js, contains('document.evaluate'));
      expect(js, contains('product-link'));
      expect(js, contains('XPathResult.FIRST_ORDERED_NODE_TYPE'));
    });

    test('resolveAndClickJs handles null textContent', () {
      final js = resolveAndClickJs(['#a'], null);
      expect(js, contains('var text = null;'));
    });

    test('matchesAnySelectorJs embeds selectors', () {
      final js = matchesAnySelectorJs(['.login-form', '#giris']);
      expect(js, contains('.login-form'));
      expect(js, contains('#giris'));
      expect(js, contains('querySelector'));
    });
  });

  group('tap-step navigation', () {
    test('tap step loads the page the tap happened on, not the post-tap URL',
        () async {
      final driver = FakeReplayDriver();
      final recording = RecipeRecording(
        id: 'rec-2',
        recipeId: 'test-recipe',
        recipeVersion: 1,
        siteHost: 'shop.example.com',
        createdAt: '2026-08-02T04:00:00.000Z',
        steps: [
          RecordedStep(
            stepId: 'login',
            visitedUrls: ['https://shop.example.com'],
            confirmedAt: '2026-08-02T04:01:00.000Z',
          ),
          RecordedStep(
            stepId: 'go-to-orders',
            // visitedUrls holds the POST-tap destination (orders list)…
            visitedUrls: ['https://shop.example.com/orders'],
            tapTarget: TapTarget(
              selectorCandidates: ['a.menu-orders'],
              textContent: 'Orders',
              tagName: 'A',
              // …but the tap happened on the account page.
              pageUrl: 'https://shop.example.com/account',
            ),
            confirmedAt: '2026-08-02T04:02:00.000Z',
          ),
        ],
        complete: true,
      );

      final result = await RecipeReplayer().replayWithDriver(
        driver: driver,
        recipe: buildRecipe(),
        recording: recording,
      );

      expect(result.status, ReplayStatus.success);
      expect(
        driver.calls.where((c) => c.startsWith('loadUrl:')).toList(),
        [
          'loadUrl:https://shop.example.com',
          // Tap step navigates to the tap's origin page so the recorded
          // selector actually resolves there.
          'loadUrl:https://shop.example.com/account',
        ],
      );
    });
  });
}
