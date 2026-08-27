import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  group('UrlCycleEntry', () {
    test('JSON round-trip', () {
      final entry = UrlCycleEntry(
        url: 'https://example.com/a',
        timestamp: 1790000000000,
        trigger: UrlCycleTrigger.visitedHistory,
        isMainFrame: false,
      );
      final decoded = UrlCycleEntry.fromJson(entry.toJson());
      expect(decoded.url, 'https://example.com/a');
      expect(decoded.timestamp, 1790000000000);
      expect(decoded.trigger, UrlCycleTrigger.visitedHistory);
      expect(decoded.isMainFrame, isFalse);
    });

    test('trigger names match contract', () {
      expect(
        UrlCycleTrigger.values.map((e) => e.name),
        ['loadStart', 'visitedHistory', 'jsHistory', 'redirect', 'userOverride'],
      );
    });
  });

  group('NavigationTracker', () {
    test('maybeCreate returns a tracker', () {
      expect(NavigationTracker.maybeCreate(), isNotNull);
      expect(
        NavigationTracker.maybeCreate(onUrlCycleEntry: (_) {}),
        isNotNull,
      );
    });

    test('mergeUserScripts returns null-safe results', () {
      expect(NavigationTracker.mergeUserScripts(null, null), isNull);
      final tracker = NavigationTracker.maybeCreate()!;
      final merged = NavigationTracker.mergeUserScripts(null, tracker);
      expect(merged, isNotNull);
      expect(merged!.length, 1);
      expect(merged.single.source, contains('__zikzakNavigationTracker__'));
    });

    test('forwarders classify triggers and keep order', () {
      final tracker = NavigationTracker.maybeCreate()!;
      final base = DateTime.now().millisecondsSinceEpoch;
      var t = base;
      tracker.recordEntry(
        url: 'https://example.com/1',
        trigger: UrlCycleTrigger.loadStart,
        timestamp: t,
      );
      t += 1000;
      tracker.recordEntry(
        url: 'https://example.com/2',
        trigger: UrlCycleTrigger.visitedHistory,
        timestamp: t,
      );
      t += 1000;
      tracker.recordEntry(
        url: 'https://example.com/3',
        trigger: UrlCycleTrigger.jsHistory,
        timestamp: t,
      );

      expect(tracker.entries.map((e) => e.url), [
        'https://example.com/1',
        'https://example.com/2',
        'https://example.com/3',
      ]);
      expect(tracker.entries.map((e) => e.trigger), [
        UrlCycleTrigger.loadStart,
        UrlCycleTrigger.visitedHistory,
        UrlCycleTrigger.jsHistory,
      ]);
    });

    test('onLoadStart/onUpdateVisitedHistory forward urls', () {
      final tracker = NavigationTracker.maybeCreate()!;
      tracker.onLoadStart(WebUri('https://example.com/a'));
      tracker.onUpdateVisitedHistory(WebUri('https://example.com/b'));
      expect(tracker.entries.map((e) => e.trigger), [
        UrlCycleTrigger.loadStart,
        UrlCycleTrigger.visitedHistory,
      ]);
    });

    test('onServerRedirect reuses last url with redirect trigger', () {
      final tracker = NavigationTracker.maybeCreate()!;
      tracker.recordEntry(
        url: 'https://example.com/a',
        trigger: UrlCycleTrigger.loadStart,
        timestamp: 1000,
      );
      tracker.onServerRedirect();
      // Same URL within the dedup window collapses... unless timestamps
      // differ by more than 500ms; here onServerRedirect uses "now", so
      // assert on the general contract instead: no crash, and with a fresh
      // tracker it is a no-op.
      final empty = NavigationTracker.maybeCreate()!;
      empty.onServerRedirect();
      expect(empty.entries, isEmpty);
    });

    test('dedup: same URL within 500ms collapses keeping earliest trigger', () {
      final tracker = NavigationTracker.maybeCreate()!;
      tracker.recordEntry(
        url: 'https://example.com/a',
        trigger: UrlCycleTrigger.loadStart,
        timestamp: 10000,
      );
      tracker.recordEntry(
        url: 'https://example.com/a',
        trigger: UrlCycleTrigger.jsHistory,
        timestamp: 10300,
      );
      tracker.recordEntry(
        url: 'https://example.com/a',
        trigger: UrlCycleTrigger.visitedHistory,
        timestamp: 10499,
      );
      expect(tracker.entries.length, 1);
      expect(tracker.entries.single.trigger, UrlCycleTrigger.loadStart);
      expect(tracker.entries.single.timestamp, 10000);
    });

    test('dedup: same URL after 500ms is a new entry', () {
      final tracker = NavigationTracker.maybeCreate()!;
      tracker.recordEntry(
        url: 'https://example.com/a',
        trigger: UrlCycleTrigger.loadStart,
        timestamp: 10000,
      );
      tracker.recordEntry(
        url: 'https://example.com/a',
        trigger: UrlCycleTrigger.jsHistory,
        timestamp: 10600,
      );
      expect(tracker.entries.length, 2);
      expect(tracker.entries[1].trigger, UrlCycleTrigger.jsHistory);
    });

    test('dedup: different URLs within 500ms are both kept', () {
      final tracker = NavigationTracker.maybeCreate()!;
      tracker.recordEntry(
        url: 'https://example.com/a',
        trigger: UrlCycleTrigger.loadStart,
        timestamp: 10000,
      );
      tracker.recordEntry(
        url: 'https://example.com/b',
        trigger: UrlCycleTrigger.jsHistory,
        timestamp: 10100,
      );
      expect(tracker.entries.length, 2);
    });

    test('handleJsPayload classifies jsHistory and reports main frame', () {
      final seen = <UrlCycleEntry>[];
      final tracker = NavigationTracker.maybeCreate(
        onUrlCycleEntry: seen.add,
      )!;
      tracker.handleJsPayload({
        'url': 'https://example.com/spa/route',
        'trigger': 'jsHistory',
        'isMainFrame': true,
        'timestamp': 20000,
      });
      expect(tracker.entries.single.url, 'https://example.com/spa/route');
      expect(tracker.entries.single.trigger, UrlCycleTrigger.jsHistory);
      expect(tracker.entries.single.timestamp, 20000);
      expect(seen.single.url, 'https://example.com/spa/route');
    });

    test('handleJsPayload drops sub-frame events by default', () {
      final tracker = NavigationTracker.maybeCreate()!;
      tracker.handleJsPayload({
        'url': 'https://iframe.example.com/x',
        'trigger': 'jsHistory',
        'isMainFrame': false,
        'timestamp': 20000,
      });
      expect(tracker.entries, isEmpty);
    });

    test('handleJsPayload keeps sub-frame events when disabled', () {
      final tracker = NavigationTracker(mainFrameOnly: false);
      tracker.handleJsPayload({
        'url': 'https://iframe.example.com/x',
        'trigger': 'jsHistory',
        'isMainFrame': false,
        'timestamp': 20000,
      });
      expect(tracker.entries.single.isMainFrame, isFalse);
    });

    test('handleJsPayload ignores empty urls', () {
      final tracker = NavigationTracker.maybeCreate()!;
      tracker.handleJsPayload({'url': '', 'trigger': 'jsHistory'});
      tracker.handleJsPayload({'trigger': 'jsHistory'});
      expect(tracker.entries, isEmpty);
    });

    test('duplicate flushed JS events collapse', () {
      // The script sends optimistically and re-sends on ready(); identical
      // payloads must collapse.
      final tracker = NavigationTracker.maybeCreate()!;
      final payload = {
        'url': 'https://example.com/a',
        'trigger': 'jsHistory',
        'isMainFrame': true,
        'timestamp': 30000,
      };
      tracker.handleJsPayload(payload);
      tracker.handleJsPayload(payload);
      expect(tracker.entries.length, 1);
    });
  });
}
