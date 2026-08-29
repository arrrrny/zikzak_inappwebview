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
  });
}
