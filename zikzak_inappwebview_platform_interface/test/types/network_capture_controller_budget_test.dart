import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('NetworkCaptureController per-domain budgets (FR-006 / A10-A12)', () {
    test(
      'enforces per-domain maxEntries budget; other domains keep capturing (A10)',
      () {
        const budgetDomain = 'api.example.com';
        final controller = NetworkCaptureController()
          ..domainBudgets = {
            budgetDomain: const DomainBudget(maxEntries: 10),
          };

        // 50 requests to the budgeted domain.
        for (var i = 0; i < 50; i++) {
          controller.trackRequest(NetworkRequest(
            requestId: 'budgeted-$i',
            url: WebUri('https://$budgetDomain/items/$i'),
            resourceType: ResourceType.fetch,
          ));
        }

        // 5 requests to a different (unbudgeted) domain.
        for (var i = 0; i < 5; i++) {
          controller.trackRequest(NetworkRequest(
            requestId: 'other-$i',
            url: WebUri('https://other.example.com/x/$i'),
            resourceType: ResourceType.fetch,
          ));
        }

        // Only the first 10 budgeted entries are retained; the rest are dropped
        // while the unbudgeted domain captures all 5 of its requests.
        expect(controller.count, equals(10 + 5));
      },
    );

    test(
      'enforces per-domain maxBytes budget on response bodies; others kept (A11)',
      () async {
        const budgetDomain = 'api.example.com';
        final controller = NetworkCaptureController()
          ..domainBudgets = {
            budgetDomain: const DomainBudget(maxBytes: 20),
          };

        // Three requests to the budgeted domain, each with a 10-byte body.
        for (var i = 0; i < 3; i++) {
          controller.trackRequest(NetworkRequest(
            requestId: 'budgeted-$i',
            url: WebUri('https://$budgetDomain/items/$i'),
            resourceType: ResourceType.fetch,
          ));
        }
        for (var i = 0; i < 3; i++) {
          controller.attachBody(NetworkResponseBody(
            requestId: 'budgeted-$i',
            url: WebUri('https://$budgetDomain/items/$i'),
            body: 'x' * 10,
            size: 10,
          ));
        }

        // An unbudgeted domain's body must always be retained.
        controller.trackRequest(NetworkRequest(
          requestId: 'other-0',
          url: WebUri('https://other.example.com/x/0'),
          resourceType: ResourceType.fetch,
        ));
        controller.attachBody(NetworkResponseBody(
          requestId: 'other-0',
          url: WebUri('https://other.example.com/x/0'),
          body: 'y' * 10,
          size: 10,
        ));

        // 20-byte cap: the first two 10-byte bodies fit, the third overflows and
        // is dropped; all entries are still tracked.
        expect(controller.count, equals(4));
        final withBodies = await controller.getEntries(withBodyOnly: true);
        expect(withBodies.length, equals(3)); // 2 budgeted + 1 other
      },
    );

    test(
      'enforces per-domain maxBodySize truncation; others kept whole (A12)',
      () async {
        const budgetDomain = 'api.example.com';
        final controller = NetworkCaptureController()
          ..domainBudgets = {
            budgetDomain: const DomainBudget(maxBodySize: 5),
          };

        controller.trackRequest(NetworkRequest(
          requestId: 'b0',
          url: WebUri('https://$budgetDomain/items/0'),
          resourceType: ResourceType.fetch,
        ));
        controller.attachBody(NetworkResponseBody(
          requestId: 'b0',
          url: WebUri('https://$budgetDomain/items/0'),
          body: 'a' * 20,
          size: 20,
        ));

        // Unbudgeted domain's body must be kept whole.
        controller.trackRequest(NetworkRequest(
          requestId: 'o0',
          url: WebUri('https://other.example.com/x/0'),
          resourceType: ResourceType.fetch,
        ));
        controller.attachBody(NetworkResponseBody(
          requestId: 'o0',
          url: WebUri('https://other.example.com/x/0'),
          body: 'b' * 20,
          size: 20,
        ));

        final entries = await controller.getEntries();
        final budgeted =
            entries.firstWhere((e) => e.request.requestId == 'b0');
        final other = entries.firstWhere((e) => e.request.requestId == 'o0');

        // Per-domain cap truncates the body to 5 chars and flags it.
        expect(budgeted.responseBody!.body.length, equals(5));
        expect(budgeted.responseBody!.truncated, isTrue);
        // Other domain is unaffected.
        expect(other.responseBody!.body.length, equals(20));
        expect(other.responseBody!.truncated, isFalse);
      },
    );
  });
}
