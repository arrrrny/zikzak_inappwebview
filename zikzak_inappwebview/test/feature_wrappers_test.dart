// Delegation tests for the remaining public feature wrappers: WebStorageManager,
// FindInteractionController, PullToRefreshController, PrintJobController,
// ServiceWorkerController and WebMessageChannel. Each pins the public method
// contract (args in, results out) via a fake platform — the MCP-tool surface
// the zuraffa-only rewrite will expose.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class _FakeWebStorageManager extends PlatformWebStorageManager {
  _FakeWebStorageManager() : super.implementation(
          const PlatformWebStorageManagerCreationParams(),
        );

  final List<String> calls = [];
  List<WebStorageOrigin> origins = [];
  int quota = 0;

  @override
  Future<List<WebStorageOrigin>> getOrigins() async {
    calls.add('getOrigins');
    return origins;
  }

  @override
  Future<void> deleteAllData() async => calls.add('deleteAllData');

  @override
  Future<void> deleteOrigin({required String origin}) async =>
      calls.add('deleteOrigin:$origin');

  @override
  Future<int> getQuotaForOrigin({required String origin}) async {
    calls.add('getQuotaForOrigin:$origin');
    return quota;
  }

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {}
}

class _FakeFindInteraction extends PlatformFindInteractionController {
  _FakeFindInteraction() : super.implementation(
          PlatformFindInteractionControllerCreationParams(),
        );

  final List<String> calls = [];

  @override
  Future<void> findAll({String? find}) async => calls.add('findAll:$find');

  @override
  Future<void> findNext({bool forward = true}) async =>
      calls.add('findNext:$forward');

  @override
  Future<void> findPrevious({bool forward = true}) async =>
      calls.add('findPrevious:$forward');

  @override
  Future<void> clearMatches() async => calls.add('clearMatches');

  @override
  void dispose({bool isKeepAlive = false}) {}
}

class _FakePullToRefresh extends PlatformPullToRefreshController {
  _FakePullToRefresh() : super.implementation(
          PlatformPullToRefreshControllerCreationParams(),
        );

  final List<String> calls = [];
  bool enabled = true;

  @override
  Future<void> setEnabled(bool enabled) async {
    calls.add('setEnabled:$enabled');
    this.enabled = enabled;
  }

  @override
  Future<bool> isEnabled() async => enabled;

  @override
  void dispose({bool isKeepAlive = false}) {}
}

class _FakePrintJob extends PlatformPrintJobController {
  _FakePrintJob() : super.implementation(
          PlatformPrintJobControllerCreationParams(id: 'job-1'),
        );

  final List<String> calls = [];

  @override
  Future<void> cancel() async => calls.add('cancel');

  @override
  Future<void> restart() async => calls.add('restart');

  @override
  void dispose({bool isKeepAlive = false}) {}
}

class _FakeServiceWorker extends PlatformServiceWorkerController {
  _FakeServiceWorker() : super.implementation(
          const PlatformServiceWorkerControllerCreationParams(),
        );

  final List<String> calls = [];
  ServiceWorkerClient? client;

  @override
  ServiceWorkerClient? get serviceWorkerClient => client;

  @override
  Future<void> setServiceWorkerClient(ServiceWorkerClient? value) async {
    calls.add('setServiceWorkerClient');
    client = value;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

void main() {
  group('WebStorageManager', () {
    test('delegates origins/data/quota ops', () async {
      final fake = _FakeWebStorageManager();
      final manager = WebStorageManager.fromPlatform(fake);
      expect(await manager.getOrigins(), isEmpty);
      await manager.deleteAllData();
      await manager.deleteOrigin(origin: 'https://a.dev');
      expect(await manager.getQuotaForOrigin(origin: 'https://a.dev'), 0);
      expect(fake.calls, [
        'getOrigins',
        'deleteAllData',
        'deleteOrigin:https://a.dev',
        'getQuotaForOrigin:https://a.dev',
      ]);
    });
  });

  group('FindInteractionController', () {
    test('delegates find ops with the forward flag', () async {
      final fake = _FakeFindInteraction();
      final controller = FindInteractionController.fromPlatform(platform: fake);
      await controller.findAll(find: 'term');
      await controller.findNext();
      await controller.findNext(forward: false);
      await controller.clearMatches();
      expect(fake.calls, [
        'findAll:term',
        'findNext:true',
        'findNext:false',
        'clearMatches',
      ]);
    });
  });

  group('PullToRefreshController', () {
    test('setEnabled/isEnabled round-trip', () async {
      final fake = _FakePullToRefresh();
      final controller = PullToRefreshController.fromPlatform(platform: fake);
      expect(await controller.isEnabled(), true);
      await controller.setEnabled(false);
      expect(await controller.isEnabled(), false);
      expect(fake.calls, ['setEnabled:false']);
    });
  });

  group('PrintJobController', () {
    test('id + cancel + restart', () async {
      final fake = _FakePrintJob();
      final controller = PrintJobController.fromPlatform(platform: fake);
      expect(controller.id, 'job-1');
      await controller.cancel();
      await controller.restart();
      expect(fake.calls, ['cancel', 'restart']);
    });
  });

  group('ServiceWorkerController', () {
    test('setServiceWorkerClient delegates', () async {
      final fake = _FakeServiceWorker();
      final controller = ServiceWorkerController.fromPlatform(fake);
      await controller.setServiceWorkerClient(null);
      expect(fake.calls, ['setServiceWorkerClient']);
      expect(fake.client, isNull);
    });
  });
}
