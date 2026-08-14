import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  group('SessionRecipe', () {
    test('JSON round-trip with all fields', () {
      final recipe = SessionRecipe(
        id: 'hepsiburada-order-detail',
        name: 'Hepsiburada Order Detail',
        entryUrl: 'https://www.hepsiburada.com',
        steps: [
          RecipeStepDefinition(
            id: 'login',
            instruction: 'Log in',
            signalPatterns: ['account', 'user'],
          ),
          RecipeStepDefinition(
            id: 'go-to-orders',
            instruction: 'Open orders',
            captureTap: true,
            signalPatterns: ['order'],
          ),
          RecipeStepDefinition(
            id: 'open-order',
            instruction: 'Open an order',
            captureTap: true,
            signalPatterns: ['order'],
            waitForNetworkIdle: true,
          ),
        ],
        loggedOutUrlPatterns: ['*/giris*', '*/login*'],
        loggedOutSelectors: ['.login-form'],
        version: 2,
      );

      final decoded = SessionRecipe.fromJson(
        jsonDecode(jsonEncode(recipe.toJson())) as Map<String, dynamic>,
      );

      expect(decoded.id, recipe.id);
      expect(decoded.name, recipe.name);
      expect(decoded.entryUrl, recipe.entryUrl);
      expect(decoded.version, 2);
      expect(decoded.loggedOutUrlPatterns, ['*/giris*', '*/login*']);
      expect(decoded.loggedOutSelectors, ['.login-form']);
      expect(decoded.steps.length, 3);
      expect(decoded.steps[0].id, 'login');
      expect(decoded.steps[0].captureTap, isFalse);
      expect(decoded.steps[0].signalPatterns, ['account', 'user']);
      expect(decoded.steps[0].waitForNetworkIdle, isFalse);
      expect(decoded.steps[2].waitForNetworkIdle, isTrue);
    });

    test('JSON round-trip with omitted optional fields', () {
      final recipe = SessionRecipe(
        id: 'r',
        name: 'n',
        entryUrl: 'https://example.com',
        steps: [RecipeStepDefinition(id: 's', instruction: 'i')],
      );
      final decoded = SessionRecipe.fromJson(recipe.toJson());
      expect(decoded.loggedOutUrlPatterns, isEmpty);
      expect(decoded.loggedOutSelectors, isEmpty);
      expect(decoded.version, 1);
      expect(decoded.steps.single.signalPatterns, isEmpty);
      expect(decoded.steps.single.captureTap, isFalse);
    });

    test('isValid: empty steps invalid', () {
      final recipe = SessionRecipe(
        id: 'r',
        name: 'n',
        entryUrl: 'https://example.com',
        steps: const [],
      );
      expect(recipe.isValid(), isFalse);
    });

    test('isValid: duplicate step ids invalid', () {
      final recipe = SessionRecipe(
        id: 'r',
        name: 'n',
        entryUrl: 'https://example.com',
        steps: [
          RecipeStepDefinition(id: 'a', instruction: '1'),
          RecipeStepDefinition(id: 'a', instruction: '2'),
        ],
      );
      expect(recipe.isValid(), isFalse);
    });

    test('isValid: unique non-empty steps valid', () {
      final recipe = SessionRecipe(
        id: 'r',
        name: 'n',
        entryUrl: 'https://example.com',
        steps: [
          RecipeStepDefinition(id: 'a', instruction: '1'),
          RecipeStepDefinition(id: 'b', instruction: '2'),
        ],
      );
      expect(recipe.isValid(), isTrue);
    });
  });

  group('RecipeRecording', () {
    test('JSON round-trip with nested structures', () {
      final recording = RecipeRecording(
        id: 'rec-1',
        recipeId: 'hepsiburada-order-detail',
        recipeVersion: 1,
        siteHost: 'www.hepsiburada.com',
        createdAt: '2026-08-02T04:00:00.000Z',
        steps: [
          RecordedStep(
            stepId: 'login',
            visitedUrls: [
              'https://www.hepsiburada.com',
              'https://www.hepsiburada.com/giris-yap',
            ],
            signals: [
              RecordedSignal(
                url: 'https://www.hepsiburada.com/api/account',
                method: 'POST',
                statusCode: 200,
                requestHeaders: {'content-type': 'application/json'},
                matchedPattern: 'account',
              ),
            ],
            confirmedAt: '2026-08-02T04:01:00.000Z',
          ),
          RecordedStep(
            stepId: 'go-to-orders',
            visitedUrls: ['https://www.hepsiburada.com/siparislerim'],
            tapTarget: TapTarget(
              selectorCandidates: ['#orders-link', 'a.menu-orders'],
              textContent: 'Siparişlerim',
              tagName: 'A',
              pageUrl: 'https://www.hepsiburada.com',
            ),
            confirmedAt: '2026-08-02T04:02:00.000Z',
          ),
        ],
        session: SessionSnapshot(
          cookies: [
            CookieEntry(
              name: 'session',
              value: 'abc',
              domain: '.hepsiburada.com',
              path: '/',
              expiresDate: 1790000000000,
              isSecure: true,
              isHttpOnly: true,
            ),
            CookieEntry(name: 'prefs', value: 'x'),
          ],
          capturedAt: '2026-08-02T04:03:00.000Z',
        ),
        complete: true,
      );

      final decoded = RecipeRecording.fromJson(
        jsonDecode(jsonEncode(recording.toJson())) as Map<String, dynamic>,
      );

      expect(decoded.id, 'rec-1');
      expect(decoded.recipeId, 'hepsiburada-order-detail');
      expect(decoded.recipeVersion, 1);
      expect(decoded.siteHost, 'www.hepsiburada.com');
      expect(decoded.createdAt, '2026-08-02T04:00:00.000Z');
      expect(decoded.complete, isTrue);

      expect(decoded.steps.length, 2);
      final login = decoded.steps[0];
      expect(login.stepId, 'login');
      expect(login.visitedUrls, [
        'https://www.hepsiburada.com',
        'https://www.hepsiburada.com/giris-yap',
      ]);
      expect(login.tapTarget, isNull);
      expect(login.signals.single.url,
          'https://www.hepsiburada.com/api/account');
      expect(login.signals.single.method, 'POST');
      expect(login.signals.single.statusCode, 200);
      expect(login.signals.single.requestHeaders,
          {'content-type': 'application/json'});
      expect(login.signals.single.matchedPattern, 'account');
      expect(login.confirmedAt, '2026-08-02T04:01:00.000Z');

      final goToOrders = decoded.steps[1];
      expect(goToOrders.tapTarget, isNotNull);
      expect(goToOrders.tapTarget!.selectorCandidates,
          ['#orders-link', 'a.menu-orders']);
      expect(goToOrders.tapTarget!.textContent, 'Siparişlerim');
      expect(goToOrders.tapTarget!.tagName, 'A');
      expect(goToOrders.tapTarget!.pageUrl, 'https://www.hepsiburada.com');
      expect(goToOrders.signals, isEmpty);

      final session = decoded.session!;
      expect(session.capturedAt, '2026-08-02T04:03:00.000Z');
      expect(session.cookies.length, 2);
      expect(session.cookies[0].name, 'session');
      expect(session.cookies[0].value, 'abc');
      expect(session.cookies[0].domain, '.hepsiburada.com');
      expect(session.cookies[0].path, '/');
      expect(session.cookies[0].expiresDate, 1790000000000);
      expect(session.cookies[0].isSecure, isTrue);
      expect(session.cookies[0].isHttpOnly, isTrue);
      expect(session.cookies[1].domain, isNull);
      expect(session.cookies[1].expiresDate, isNull);
      expect(session.cookies[1].isSecure, isNull);
    });

    test('JSON round-trip with null optional fields', () {
      final recording = RecipeRecording(
        id: 'rec-2',
        recipeId: 'r',
        recipeVersion: 1,
        siteHost: 'example.com',
        createdAt: '2026-08-02T04:00:00.000Z',
        steps: [RecordedStep(stepId: 'only')],
      );

      final decoded = RecipeRecording.fromJson(
        jsonDecode(jsonEncode(recording.toJson())) as Map<String, dynamic>,
      );

      expect(decoded.complete, isFalse);
      expect(decoded.session, isNull);
      expect(decoded.steps.single.tapTarget, isNull);
      expect(decoded.steps.single.visitedUrls, isEmpty);
      expect(decoded.steps.single.signals, isEmpty);
      expect(decoded.steps.single.confirmedAt, '');
    });
  });

  group('TapTarget', () {
    test('JSON round-trip with null textContent', () {
      final target = TapTarget(
        selectorCandidates: ['button.submit'],
        tagName: 'BUTTON',
        pageUrl: 'https://example.com',
      );
      final decoded = TapTarget.fromJson(target.toJson());
      expect(decoded.textContent, isNull);
      expect(decoded.xpath, isNull);
      expect(decoded.selectorCandidates, ['button.submit']);
      expect(decoded.tagName, 'BUTTON');
      expect(decoded.pageUrl, 'https://example.com');
    });

    test('JSON round-trip with xpath (old recordings without it parse)', () {
      final target = TapTarget(
        selectorCandidates: ['a[href="/urun/123"]'],
        xpath: '//a[@id="product-link"]',
        textContent: 'Lav',
        tagName: 'A',
        pageUrl: 'https://example.com/order/1',
      );
      final decoded = TapTarget.fromJson(target.toJson());
      expect(decoded.xpath, '//a[@id="product-link"]');
      expect(decoded.textContent, 'Lav');

      // Pre-xpath recordings: field absent in JSON → null, no crash.
      final legacy = TapTarget.fromJson({
        'selectorCandidates': ['a.x'],
        'textContent': null,
        'tagName': 'A',
        'pageUrl': 'https://example.com',
      });
      expect(legacy.xpath, isNull);
    });
  });

  group('RecordedStep', () {
    test('JSON round-trip with pageHtml (old recordings without it parse)', () {
      final step = RecordedStep(
        stepId: 'open-order',
        visitedUrls: ['https://example.com/orders'],
        confirmedAt: '2026-08-02T12:00:00.000Z',
        pageHtml: '<html><body>order</body></html>',
      );
      final decoded = RecordedStep.fromJson(step.toJson());
      expect(decoded.pageHtml, '<html><body>order</body></html>');

      final legacy = RecordedStep.fromJson({
        'stepId': 'open-order',
        'visitedUrls': <String>[],
        'tapTarget': null,
        'signals': <Map<String, dynamic>>[],
        'confirmedAt': '',
      });
      expect(legacy.pageHtml, isNull);
    });
  });

  group('RecordedSignal', () {
    test('JSON round-trip with null statusCode', () {
      final signal = RecordedSignal(
        url: 'https://example.com/api/order',
        method: 'GET',
        matchedPattern: 'order',
      );
      final decoded = RecordedSignal.fromJson(signal.toJson());
      expect(decoded.statusCode, isNull);
      expect(decoded.requestHeaders, isEmpty);
      expect(decoded.matchedPattern, 'order');
    });
  });

  group('ReplayResult', () {
    test('JSON round-trip for each status', () {
      final success = ReplayResult(
        status: ReplayStatus.success,
        finalUrl: 'https://example.com/order/123',
        finalHtml: '<html></html>',
        completedSteps: ['a', 'b'],
      );
      final decodedSuccess = ReplayResult.fromJson(success.toJson());
      expect(decodedSuccess.status, ReplayStatus.success);
      expect(decodedSuccess.failedStepId, isNull);
      expect(decodedSuccess.finalUrl, 'https://example.com/order/123');
      expect(decodedSuccess.finalHtml, '<html></html>');
      expect(decodedSuccess.completedSteps, ['a', 'b']);

      final expired = ReplayResult(
        status: ReplayStatus.sessionExpired,
        failedStepId: 'go-to-orders',
        failureReason: 'session-expired',
        completedSteps: ['login'],
      );
      final decodedExpired = ReplayResult.fromJson(expired.toJson());
      expect(decodedExpired.status, ReplayStatus.sessionExpired);
      expect(decodedExpired.failedStepId, 'go-to-orders');
      expect(decodedExpired.failureReason, 'session-expired');
      expect(decodedExpired.completedSteps, ['login']);

      final failed = ReplayResult(
        status: ReplayStatus.stepFailed,
        failedStepId: 'open-order',
        failureReason: 'no-selector-matched',
      );
      final decodedFailed = ReplayResult.fromJson(failed.toJson());
      expect(decodedFailed.status, ReplayStatus.stepFailed);
      expect(decodedFailed.completedSteps, isEmpty);
    });

    test('status survives jsonEncode/jsonDecode', () {
      final result = ReplayResult(status: ReplayStatus.stepFailed);
      final decoded = ReplayResult.fromJson(
        jsonDecode(jsonEncode(result.toJson())) as Map<String, dynamic>,
      );
      expect(decoded.status, ReplayStatus.stepFailed);
    });
  });

  group('ReplayProgress', () {
    test('JSON round-trip', () {
      final progress = ReplayProgress(
        stepId: 'login',
        state: ReplayStepState.tapping,
      );
      final decoded = ReplayProgress.fromJson(progress.toJson());
      expect(decoded.stepId, 'login');
      expect(decoded.state, ReplayStepState.tapping);
    });

    test('ReplayStepState values', () {
      expect(ReplayStepState.values.map((e) => e.name),
          ['navigating', 'tapping', 'done']);
    });
  });
}
