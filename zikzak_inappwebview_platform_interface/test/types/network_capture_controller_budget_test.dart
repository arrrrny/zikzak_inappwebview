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
  });
}
